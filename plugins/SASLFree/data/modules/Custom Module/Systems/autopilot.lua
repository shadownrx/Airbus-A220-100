-- autopilot.lua

require("config")
require("sensors")

-- Variables del Autopilot
local autopilot_active = false
local selected_altitude = 0         -- feet
local selected_heading = 0          -- integer (0-359)
local selected_speed = 0            -- integer
local current_mode = "OFF"          -- use state machine
local vertical_speed = 0            -- integer
local nav_data = {}
local ils_data = {}
local wind_info = {}

local AutopilotConfig = {
    max_pitch = 15,                 -- degrees
    max_roll = 30,                  -- degrees
    max_vertical_speed = 6000,      -- feet/min
    min_speed = 130,                -- knots
    max_speed = 320,                -- knots
    sensor_threshold = 5,           -- TODO: define unit
}

function activate_autopilot()
    if not autopilot_active then
        autopilot_active = true
        current_mode = "ALT_HOLD" -- TODO: use state machine
        update_ecam_display("AUTOPILOT ACTIVATED")
        print("Autopilot engaged.")
    else
        print("Autopilot disengaged.")
    end
end

function deactivate_autopilot()
    if autopilot_active then
        autopilot_active = false
        current_mode = "OFF"
        update_ecam_display("AUTOPILOT DISENGAGED")
        print("Autopilot disengaged.")
    else
        print("Autopilot is already disengaged")
    end
end

function change_mode(new_mode)
    if autopilot_active then
        current_mode = new_mode
        update_ecam_display("AUTOPILOT MODE: " .. new_mode)
        print("Changin autopilot mode to: " .. new_mode)
    else
        print("Can't change the autopilot mode. It is not engaged.")
    end
end

-- Función para configurar la altitud seleccionada
function set_selected_altitude(altitude)
    if altitude >= 0 then
        selected_altitude = altitude
        update_ecam_display("ALTITUDE SET: " .. altitude .. " FT")
        print("Altitud selected: " .. altitude .. " feet")
    else
        print("Invalid selected altitude.")
    end
end

function set_selected_heading(heading)
    if heading >= 0 and heading <= 359 then
        selected_heading = heading
        update_ecam_display("HEADING SET: " .. heading .. "°")
        print("Heading selected: " .. heading .. "°")
    else
        print("Invalid selected heading.")
    end
end

function set_selected_speed(speed)
    if speed >= AutopilotConfig.min_speed and speed <= AutopilotConfig.max_speed then
        selected_speed = speed
        update_ecam_display("SPEED SET: " .. speed .. " KTS")
        print("Speed selected: " .. speed .. " knots")
    else
        print("Speed selected is not valid.")
    end
end

function calculate_ils_deviation()
    local deviation = {
        localizer = ils_data.localizer - sensors.get_heading(),
        glideslope = ils_data.glideslope - sensors.get_altitude()
    }
    return deviation
end

function manage_autopilot()
    -- TODO: use switch/case
    -- TODO: use state machine
    -- TODO: have functions per mode
    if autopilot_active then
        if current_mode == "ALT_HOLD" then
            local altitude_error = selected_altitude - sensors.get_altitude()
            adjust_pitch(altitude_error)
        elseif current_mode == "VS_HOLD" then
            adjust_vertical_speed(vertical_speed)
        end

        if current_mode == "HDG_HOLD" then
            local heading_error = selected_heading - sensors.get_heading()
            adjust_roll(heading_error)
        elseif current_mode == "NAV" then
            local nav_deviation = calculate_nav_deviation()
            adjust_roll(nav_deviation)
        end

        adjust_thrust(selected_speed - sensors.get_speed())

        if check_sensor_errors() then
            deactivate_autopilot()
            update_ecam_display("AUTOPILOT DISENGAGED DUE TO SENSOR ERROR")
        end
    end
end

function adjust_pitch(error)
    local pitch_command = error * 0.01 -- TODO: explain why we have a correction factor
    pitch_command = clamp(pitch_command, -AutopilotConfig.max_pitch, AutopilotConfig.max_pitch)
    sensors.set_pitch(pitch_command)
end

function adjust_roll(error)
    local roll_command = error * 0.01 -- TODO: explain why we have a correction factor
    roll_command = clamp(roll_command, -AutopilotConfig.max_roll, AutopilotConfig.max_roll)
    sensors.set_roll(roll_command)
end

function adjust_vertical_speed(vs)
    if vs <= AutopilotConfig.max_vertical_speed then
        sensors.set_vertical_speed(vs)
    else
        print("Vertical speed out of limits.")
    end
end

function adjust_thrust(thrust_error)
    local thrust_command = thrust_error * 0.1 -- TODO: explain why we have a correction factor
    sensors.set_thrust(thrust_command)
end

function calculate_nav_deviation()
    -- TODO: explain why we have this correction.
    -- Does it have something to do with magnetic vs indicated heading?
    return nav_data.desired_heading - sensors.get_heading()
end

function check_sensor_errors()
    local sensor_data = sensors.get_data()
    for _, value in pairs(sensor_data) do
        if math.abs(value.error) > AutopilotConfig.sensor_threshold then
            return true
        end
    end
    return false
end

function handle_ils_buttons()
    local ils_deviation = calculate_ils_deviation()
    if ils_deviation.localizer > AutopilotConfig.sensor_threshold then
        change_mode("LOC")
    elseif ils_deviation.glideslope > AutopilotConfig.sensor_threshold then
        change_mode("G/S")
    end
end

-- TODO: we have defined this function on other components
-- Let's have an initializer
function update_ecam_display(message)
    show_message_on_ecam(message)
end

-- TODO: we have defined this function on other components
-- Let's have an initializer
function show_message_on_ecam(message)
    print("ECAM: " .. message) 
end

-- TODO: SASL provides this function out of the box
function clamp(value, min_val, max_val)
    if value < min_val then
        return min_val
    elseif value > max_val then
        return max_val
    else
        return value
    end
end

function initialize_autopilot()
    deactivate_autopilot()
    print("Autopilot initialized.")
end

-- TODO: should be done through SASL's lifecycle
function autopilot_operation()
    while true do
        manage_autopilot()
        run_after_delay(1, autopilot_operation) 
    end
end


initialize_autopilot()
autopilot_operation()
