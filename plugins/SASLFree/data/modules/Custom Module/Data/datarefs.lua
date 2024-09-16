-- datarefs.lua

-- Require section
require("config")

-- TODO: Have datarefs as variables instead
local datarefs = {
    -- Sensors
    altitude_ref = "sim/flightmodel/position/elevation",
    heading_ref = "sim/flightmodel/position/heading",
    speed_ref = "sim/flightmodel/position/true_airspeed",
    vertical_speed_ref = "sim/flightmodel/position/vvi",
    pitch_ref = "sim/flightmodel/position/pitch",
    roll_ref = "sim/flightmodel/position/roll",
    apu_bleed_pressure_ref = "sim/engines/engine/bleed_pressure",
    fuel_flow_ref = "sim/engines/engine/fuel_flow",
    ice_detection_ref = "sim/engines/engine/ice_detection",
    wind_direction_ref = "sim/weather/wind_direction",
    wind_speed_ref = "sim/weather/wind_speed",

    -- Engines
    engine1_status_ref = "sim/engines/engine/1/status",
    engine2_status_ref = "sim/engines/engine/2/status",
    apu_status_ref = "sim/engines/apu/status",

    -- Hydraulics
    hydraulic_status_ref = "sim/flightmodel/engine/1/hydraulic_pressure",

    -- Electrical
    electrical_status_ref = "sim/flightmodel/electrical/voltage",

    -- Fuel
    fuel_status_ref = "sim/flightmodel/fuel/fuel_status"

    -- External Power
    dataref_external_power_connected = find_dataref("your/dataref/external_power_connected")
    dataref_external_power_voltage = find_dataref("your/dataref/external_power_voltage")
    dataref_external_power_frequency = find_dataref("your/dataref/external_power_frequency")
    dataref_external_power_switch = find_dataref("your/dataref/external_power_switch")
}

-- TODO: setters & getters should be added oinly when necessary. 
-- Ideally we would have datarefs per system and not centralized.

function get_dataref_value(dataref_name)
    return datarefs[dataref_name]
end

function read_datarefs()
    local data = {}
    data.altitude = get_dataref_value("altitude_ref")
    data.heading = get_dataref_value("heading_ref")
    data.speed = get_dataref_value("speed_ref")
    data.vertical_speed = get_dataref_value("vertical_speed_ref")
    data.pitch = get_dataref_value("pitch_ref")
    data.roll = get_dataref_value("roll_ref")
    data.apu_bleed_pressure = get_dataref_value("apu_bleed_pressure_ref")
    data.fuel_flow = get_dataref_value("fuel_flow_ref")
    data.ice_detection = get_dataref_value("ice_detection_ref")
    data.wind_direction = get_dataref_value("wind_direction_ref")
    data.wind_speed = get_dataref_value("wind_speed_ref")
    
    data.engine1_status = get_dataref_value("engine1_status_ref")
    data.engine2_status = get_dataref_value("engine2_status_ref")
    data.apu_status = get_dataref_value("apu_status_ref")
    data.hydraulic_status = get_dataref_value("hydraulic_status_ref")
    data.electrical_status = get_dataref_value("electrical_status_ref")
    data.fuel_status = get_dataref_value("fuel_status_ref")
    
    return data
end

-- Setting datarefs in the Simulator. The following are just examples,
-- it should be adjustead according to the API of the simulator
function update_datarefs(data)
    set(datarefs.altitude_ref, data.altitude)
    set(datarefs.heading_ref, data.heading)
    set(datarefs.speed_ref, data.speed)
    set(datarefs.vertical_speed_ref, data.vertical_speed)
    set(datarefs.pitch_ref, data.pitch)
    set(datarefs.roll_ref, data.roll)
    set(datarefs.apu_bleed_pressure_ref, data.apu_bleed_pressure)
    set(datarefs.fuel_flow_ref, data.fuel_flow)
    set(datarefs.ice_detection_ref, data.ice_detection)
    set(datarefs.wind_direction_ref, data.wind_direction)
    set(datarefs.wind_speed_ref, data.wind_speed)

    set(datarefs.engine1_status_ref, data.engine1_status)
    set(datarefs.engine2_status_ref, data.engine2_status)
    set(datarefs.apu_status_ref, data.apu_status)
    set(datarefs.hydraulic_status_ref, data.hydraulic_status)
    set(datarefs.electrical_status_ref, data.electrical_status)
    set(datarefs.fuel_status_ref, data.fuel_status)
end

-- TODO: This can be wraped inside each component and
-- should respond to the SASL lifecycle
function initialize_datarefs()
    print("Initializing Datarefs...")
end

-- TODO: should be under the `update` method provided by SASL
function datarefs_update_operation()
    while true do
        local sensor_data = read_datarefs()
        update_datarefs(sensor_data)
        run_after_delay(1, datarefs_update_operation) -- TODO: Should be milliseconds
    end
end

initialize_datarefs()
datarefs_update_operation()
