-- datarefs.lua

-- Requiere módulos y configuración necesarios
require("config")

-- Definir Datarefs
local datarefs = {
    -- Sensores
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

    -- Motores
    engine1_status_ref = "sim/engines/engine/1/status",
    engine2_status_ref = "sim/engines/engine/2/status",
    apu_status_ref = "sim/engines/apu/status",

    -- Hidráulico
    hydraulic_status_ref = "sim/flightmodel/engine/1/hydraulic_pressure",

    -- Eléctrico
    electrical_status_ref = "sim/flightmodel/electrical/voltage",

    -- Combustible
    fuel_status_ref = "sim/flightmodel/fuel/fuel_status"

    -- Datarefs para energía externa
    dataref_external_power_connected = find_dataref("your/dataref/external_power_connected")
    dataref_external_power_voltage = find_dataref("your/dataref/external_power_voltage")
    dataref_external_power_frequency = find_dataref("your/dataref/external_power_frequency")
    dataref_external_power_switch = find_dataref("your/dataref/external_power_switch")  -- Dataref del botón
}

-- Función para obtener el valor de un Dataref
function get_dataref_value(dataref_name)
    return datarefs[dataref_name]
end

-- Función para leer datos desde el simulador
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

-- Función para actualizar los Datarefs en el simulador
function update_datarefs(data)
    -- Aquí implementas la lógica para actualizar los datarefs del simulador
    -- Ejemplo de actualización de datarefs (ajustar según la API del simulador):
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

-- Función para inicializar los Datarefs
function initialize_datarefs()
    print("Inicializando Datarefs...")
    -- Aquí puedes incluir lógica adicional para inicializar los datarefs
end

-- Función para actualizar Datarefs periódicamente
function datarefs_update_operation()
    while true do
        local sensor_data = read_datarefs()
        update_datarefs(sensor_data)
        run_after_delay(1, datarefs_update_operation) -- Actualización cada segundo
    end
end

-- Iniciar la actualización de Datarefs
initialize_datarefs()
datarefs_update_operation()
