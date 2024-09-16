-- sensors.lua

require("config")

-- TODO: use variables instead of table
local sensors_data = {
    altitude = 0,
    heading = 0,
    speed = 0,
    vertical_speed = 0,
    pitch = 0,
    roll = 0,
    apu_bleed_pressure = 0,
    fuel_flow = 0,
    ice_detection = false,
    wind_info = {direction = 0, speed = 0}
}

function get_sensor_data()
    return sensors_data
end

function set_sensor_data(data)
    for key, value in pairs(data) do
        if sensors_data[key] ~= nil then
            sensors_data[key] = value
        end
    end
end

-- TODO: getters & setters should be added only when needed
function get_altitude()
    return sensors_data.altitude
end

function get_heading()
    return sensors_data.heading
end

function get_speed()
    return sensors_data.speed
end

function get_vertical_speed()
    return sensors_data.vertical_speed
end

function get_pitch()
    return sensors_data.pitch
end

function get_roll()
    return sensors_data.roll
end

function get_apu_bleed_pressure()
    return sensors_data.apu_bleed_pressure
end

function get_fuel_flow()
    return sensors_data.fuel_flow
end

function is_ice_detected()
    return sensors_data.ice_detection
end

function get_wind_info()
    return sensors_data.wind_info
end

-- TODO: should use SASL lifecycle
function update_sensors()
    -- Random values provided
    sensors_data.altitude = math.random(0, 40000)     -- FL400
    sensors_data.heading = math.random(0, 359)          
    sensors_data.speed = math.random(100, 600)          
    sensors_data.vertical_speed = math.random(-6000, 6000)      
    sensors_data.pitch = math.random(-15, 15)     
    sensors_data.roll = math.random(-30, 30)      
    sensors_data.apu_bleed_pressure = math.random(0, 50) 
    sensors_data.fuel_flow = math.random(500, 2000) 
    sensors_data.ice_detection = (math.random(0, 1) == 1) 
    sensors_data.wind_info.direction = math.random(0, 360)  
    sensors_data.wind_info.speed = math.random(0, 100)
end

function check_apu_bleed_pressure()
    if sensors_data.apu_bleed_pressure < 10 then
        return false
    end
    return true
end

function handle_ice_detection()
    if sensors_data.ice_detection then
        print("Ice detected")
    else
        print("No ice detected")
    end
end

function simulate_sensor_wear()
    if math.random(0, 10) > 8 then
        -- TODO: use a setting to have this disabled in the future
        sensors_data.speed = sensors_data.speed + math.random(-10, 10) -- Random wear
    end
end

function initialize_sensors()
    update_sensors()
    print("Sensors initialized.")
end

function sensor_update_operation()
    while true do
        update_sensors()
        simulate_sensor_wear()
        run_after_delay(1, sensor_update_operation) -- TODO: use SASL lifecycle
    end
end

initialize_sensors()
sensor_update_operation()
