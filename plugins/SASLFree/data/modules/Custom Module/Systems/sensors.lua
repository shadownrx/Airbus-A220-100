-- sensors.lua

-- Cargar módulos y configuración necesarios
require("config")

-- Variables de sensores
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

-- Función para obtener datos de los sensores
function get_sensor_data()
    return sensors_data
end

-- Función para establecer datos de los sensores (simulación de datos en un entorno de prueba)
function set_sensor_data(data)
    for key, value in pairs(data) do
        if sensors_data[key] ~= nil then
            sensors_data[key] = value
        end
    end
end

-- Función para obtener altitud
function get_altitude()
    return sensors_data.altitude
end

-- Función para obtener rumbo
function get_heading()
    return sensors_data.heading
end

-- Función para obtener velocidad
function get_speed()
    return sensors_data.speed
end

-- Función para obtener velocidad vertical
function get_vertical_speed()
    return sensors_data.vertical_speed
end

-- Función para obtener inclinación (pitch)
function get_pitch()
    return sensors_data.pitch
end

-- Función para obtener alabeo (roll)
function get_roll()
    return sensors_data.roll
end

-- Función para obtener presión del APU bleed
function get_apu_bleed_pressure()
    return sensors_data.apu_bleed_pressure
end

-- Función para obtener el flujo de combustible
function get_fuel_flow()
    return sensors_data.fuel_flow
end

-- Función para obtener la detección de hielo
function is_ice_detected()
    return sensors_data.ice_detection
end

-- Función para obtener información del viento
function get_wind_info()
    return sensors_data.wind_info
end

-- Función para actualizar el estado de los sensores
function update_sensors()
    -- Aquí deberías incluir la lógica para actualizar los datos de los sensores
    -- en un entorno real, esto podría implicar lecturas de hardware o cálculos basados en la simulación.
    -- Ejemplo de actualización de datos (simulación):
    sensors_data.altitude = math.random(0, 40000) -- Altitud aleatoria entre 0 y 40,000 pies
    sensors_data.heading = math.random(0, 360)   -- Rumbo aleatorio entre 0 y 360 grados
    sensors_data.speed = math.random(100, 600)    -- Velocidad aleatoria entre 100 y 600 nudos
    sensors_data.vertical_speed = math.random(-6000, 6000) -- Velocidad vertical aleatoria entre -6,000 y 6,000 ft/min
    sensors_data.pitch = math.random(-15, 15)     -- Inclinación aleatoria entre -15 y 15 grados
    sensors_data.roll = math.random(-30, 30)      -- Alabeo aleatorio entre -30 y 30 grados
    sensors_data.apu_bleed_pressure = math.random(0, 50) -- Presión del APU bleed aleatoria entre 0 y 50 psi
    sensors_data.fuel_flow = math.random(500, 2000) -- Flujo de combustible aleatorio entre 500 y 2,000 kg/h
    sensors_data.ice_detection = (math.random(0, 1) == 1) -- Detección de hielo aleatoria (true o false)
    sensors_data.wind_info.direction = math.random(0, 360) -- Dirección del viento aleatoria
    sensors_data.wind_info.speed = math.random(0, 100)     -- Velocidad del viento aleatoria entre 0 y 100 nudos
end

-- Función para verificar la presión del APU bleed
function check_apu_bleed_pressure()
    if sensors_data.apu_bleed_pressure < 10 then
        return false
    end
    return true
end

-- Función para manejar la detección de hielo
function handle_ice_detection()
    if sensors_data.ice_detection then
        -- Lógica para manejar el hielo detectado
        print("¡Hielo detectado!")
    else
        -- Lógica cuando no hay hielo
        print("No se detecta hielo.")
    end
end

-- Función para simular el desgaste de sensores (para pruebas)
function simulate_sensor_wear()
    -- Aquí se pueden agregar lógicas de desgaste, errores intermitentes, etc.
    -- Ejemplo básico:
    if math.random(0, 10) > 8 then
        sensors_data.speed = sensors_data.speed + math.random(-10, 10) -- Introducción de error aleatorio
    end
end

-- Función para inicializar los sensores
function initialize_sensors()
    update_sensors()
    print("Sensores inicializados.")
end

-- Llamada a la inicialización de sensores al cargar
initialize_sensors()

-- Simulación continua de actualización de sensores
function sensor_update_operation()
    while true do
        update_sensors()
        simulate_sensor_wear()
        run_after_delay(1, sensor_update_operation) -- Actualización cada segundo
    end
end

-- Iniciar la simulación de actualización de sensores
sensor_update_operation()
