-- sensors.lua

-- Configuración de los DataRefs para sensores
local airspeed_dataref_1 = XPLMFindDataRef("sim/flightmodel/position/indicated_airspeed1")
local airspeed_dataref_2 = XPLMFindDataRef("sim/flightmodel/position/indicated_airspeed2")
local altitude_dataref_1 = XPLMFindDataRef("sim/flightmodel/position/elevation")
local altitude_dataref_2 = XPLMFindDataRef("sim/flightmodel/position/y_agl")
local attitude_pitch_dataref = XPLMFindDataRef("sim/flightmodel/position/theta")
local attitude_roll_dataref = XPLMFindDataRef("sim/flightmodel/position/phi")

local wind_speed_dataref = XPLMFindDataRef("sim/weather/wind_speed_kt[0]")
local wind_direction_dataref = XPLMFindDataRef("sim/weather/wind_direction_degt[0]")

local ice_detected_dataref = XPLMFindDataRef("sim/cockpit/warnings/annunciators/ice")
local ecam_message_dataref = XPLMFindDataRef("aircraft/ecam/message")
local nd_wind_dataref = XPLMFindDataRef("aircraft/nd/wind")

-- Variables para simular desgaste de sensores
local sensor_drift_factor = 0.01  -- Factor de desviación de sensores a lo largo del tiempo
local sensor_noise_factor = 0.05  -- Factor de ruido aleatorio en las lecturas de los sensores
local failure_probability = 0.001  -- Probabilidad de fallo intermitente

-- Funciones para actualizar los mensajes en el ECAM
function update_ecam_message(message)
    XPLMSetDataf(ecam_message_dataref, message)
end

-- Simulación de desgaste y ruido en sensores
function apply_sensor_wear(sensor_value)
    local wear = sensor_drift_factor * (math.random() - 0.5)
    local noise = sensor_noise_factor * (math.random() - 0.5)
    return sensor_value + wear + noise
end

-- Función para simular fallos intermitentes
function simulate_intermittent_failure(sensor_value)
    if math.random() < failure_probability then
        return sensor_value * (0.9 + 0.2 * math.random())  -- Variación del 10% en ambas direcciones
    end
    return sensor_value
end

-- Simulación de hielo en los sensores
function apply_ice_effects(sensor_value)
    local ice_detected = XPLMGetDatai(ice_detected_dataref)
    
    if ice_detected == 1 then
        update_ecam_message("ICE DETECTED: Sensor Readings Affected")
        return sensor_value * (0.8 + 0.2 * math.random())  -- Variación del 20% en las lecturas
    end
    return sensor_value
end

-- Validación cruzada de sensores
function validate_sensor_data(sensor_1, sensor_2, tolerance)
    if math.abs(sensor_1 - sensor_2) > tolerance then
        update_ecam_message("SENSOR DISCREPANCY DETECTED")
        return false
    end
    return true
end

-- Función para obtener la información del viento
function get_wind_information()
    local wind_speed = XPLMGetDataf(wind_speed_dataref)
    local wind_direction = XPLMGetDataf(wind_direction_dataref)
    return wind_speed, wind_direction
end

-- Función para enviar la información del viento al ND
function send_wind_to_nd()
    local wind_speed, wind_direction = get_wind_information()
    local wind_info = string.format("Wind: %03d°/%02d kt", wind_direction, wind_speed)
    XPLMSetDatab(nd_wind_dataref, wind_info, 0, #wind_info)
end

-- Función principal para monitorizar y ajustar los sensores
function monitor_sensors()
    -- Obtener y ajustar las lecturas de los sensores
    local airspeed_1 = apply_sensor_wear(XPLMGetDataf(airspeed_dataref_1))
    local airspeed_2 = apply_sensor_wear(XPLMGetDataf(airspeed_dataref_2))
    local altitude_1 = apply_sensor_wear(XPLMGetDataf(altitude_dataref_1))
    local altitude_2 = apply_sensor_wear(XPLMGetDataf(altitude_dataref_2))
    local attitude_pitch = apply_sensor_wear(XPLMGetDataf(attitude_pitch_dataref))
    local attitude_roll = apply_sensor_wear(XPLMGetDataf(attitude_roll_dataref))
    
    -- Aplicar efectos de hielo
    airspeed_1 = apply_ice_effects(airspeed_1)
    airspeed_2 = apply_ice_effects(airspeed_2)
    altitude_1 = apply_ice_effects(altitude_1)
    altitude_2 = apply_ice_effects(altitude_2)

    -- Simular fallos intermitentes
    airspeed_1 = simulate_intermittent_failure(airspeed_1)
    airspeed_2 = simulate_intermittent_failure(airspeed_2)
    altitude_1 = simulate_intermittent_failure(altitude_1)
    altitude_2 = simulate_intermittent_failure(altitude_2)

    -- Validación cruzada de datos críticos
    local airspeed_valid = validate_sensor_data(airspeed_1, airspeed_2, 10)
    local altitude_valid = validate_sensor_data(altitude_1, altitude_2, 100)

    -- Actuar ante lecturas inestables
    if not airspeed_valid then
        update_ecam_message("AIRSPEED SENSOR ERROR")
        deactivate_ap1()  -- Desactivar piloto automático como medida de seguridad
    end

    if not altitude_valid then
        update_ecam_message("ALTITUDE SENSOR ERROR")
        deactivate_ap2()  -- Desactivar piloto automático como medida de seguridad
    end
    
    -- Enviar información del viento al ND
    send_wind_to_nd()
end

-- Configurar la actualización continua
do_often("monitor_sensors()")
