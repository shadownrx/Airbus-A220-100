-- display.lua

require("config")
require("sensors")  

-- TODO: variables instead of tables
local PFD = {
    altitude = 0,
    heading = 0,
    airspeed = 0,
    vertical_speed = 0,
    pitch = 0,
    roll = 0
}

local ND = {
    waypoints = {},
    wind_direction = 0,
    wind_speed = 0,
    current_position = {lat = 0, lon = 0}
}

local ECAM = {
    engine1_status = "OFF",
    engine2_status = "OFF",
    apu_status = "OFF",
    hydraulic_status = "NORMAL",
    electrical_status = "NORMAL",
    fuel_status = "NORMAL"
}

-- TODO: use `update` function from SASL
function update_PFD()
    PFD.altitude = get_altitude()
    PFD.heading = get_heading()
    PFD.airspeed = get_speed()
    PFD.vertical_speed = get_vertical_speed()
    PFD.pitch = get_pitch()
    PFD.roll = get_roll()

    print("PFD updated:")
    print("Altitude: " .. PFD.altitude .. " ft")
    print("Heading: " .. PFD.heading .. "°")
    print("Speed: " .. PFD.airspeed .. " knots")
    print("Vertical speed: " .. PFD.vertical_speed .. " ft/min")
    print("Pitch: " .. PFD.pitch .. "°")
    print("Bank: " .. PFD.roll .. "°")
end

function update_ND()
    local wind = get_wind_info()
    ND.wind_direction = wind.direction
    ND.wind_speed = wind.speed

    -- Waypoints should be updated in this section
    print("ND updated:")
    print("Wind: " .. ND.wind_speed .. " knots from " .. ND.wind_direction .. "°")

    -- Ejemplo de impresión de waypoints
    print("Waypoints:")
    for i, waypoint in ipairs(ND.waypoints) do
        print("Waypoint " .. i .. ": Lat " .. waypoint.lat .. ", Lon " .. waypoint.lon)
    end
end

function update_ECAM()
    ECAM.engine1_status = "RUNNING"     -- Use state machine
    ECAM.engine2_status = "RUNNING" 
    ECAM.apu_status = "ON"              -- Use state machine
    ECAM.hydraulic_status = "NORMAL"    -- Use state machine
    ECAM.electrical_status = "NORMAL"   -- Use state machine
    ECAM.fuel_status = "NORMAL"         -- Use state machine

    print("ECAM actualizado:")
    print("Motor 1: " .. ECAM.engine1_status)
    print("Motor 2: " .. ECAM.engine2_status)
    print("APU: " .. ECAM.apu_status)
    print("Hidráulico: " .. ECAM.hydraulic_status)
    print("Eléctrico: " .. ECAM.electrical_status)
    print("Combustible: " .. ECAM.fuel_status)
end

-- TODO: should be done through SASL lifecycle
function update_displays()
    update_PFD()
    update_ND()
    update_ECAM()
end

-- TODO: should be done through SASL lifecycle
function initialize_displays()
    print("Inicializando displays...")
    update_displays()  
end

-- TODO: should be done through SASL lifecycle
function display_update_operation()
    while true do
        update_displays()
        run_after_delay(1, display_update_operation) 
    end
end

initialize_displays()
display_update_operation()
