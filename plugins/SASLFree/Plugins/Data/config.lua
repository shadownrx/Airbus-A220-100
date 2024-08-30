-- config.lua

-- Configuración General
AircraftConfig = {
    aircraft_type = "Airbus A220",  -- Tipo de avión
    max_altitude = 41000,           -- Altitud máxima en pies
    max_speed = 470,                -- Velocidad máxima en nudos
    fuel_capacity_kg = 23760,       -- Capacidad de combustible en kilogramos
}

-- Configuración del Motor
EngineConfig = {
    startup_time_seconds = 30,          -- Tiempo de encendido en segundos
    shutdown_time_seconds = 20,         -- Tiempo de apagado en segundos
    apu_bleed_pressure_threshold = 20,  -- Umbral de presión mínima del APU bleed para el encendido
    idle_n2_percentage = 60,            -- N2 en porcentaje cuando el motor está en marcha lenta
    ready_n2_percentage = 80,           -- N2 en porcentaje cuando el motor está listo
    fuel_pump_required = true,          -- Indica si la bomba de combustible debe estar encendida para el encendido
}

-- Configuración Eléctrica
ElectricalConfig = {
    battery_voltage_required = 24,       -- Voltaje mínimo requerido para encender el sistema eléctrico
    startup_sequence_delay = 5,          -- Retraso en segundos para la secuencia de encendido eléctrico
    screen_startup_time = 10,            -- Tiempo en segundos para que las pantallas se inicien
    ecam_boot_message = "ECAM booting...", -- Mensaje mostrado durante el arranque del ECAM
}

-- Configuración Hidráulica
HydraulicConfig = {
    pump_startup_time = 5,               -- Tiempo de encendido de las bombas hidráulicas en segundos
    low_pressure_warning_threshold = 1000, -- Umbral de presión baja para mostrar advertencias
    high_pressure_shutdown_threshold = 3000, -- Umbral de presión alta para apagar el sistema por seguridad
    required_pumps_on_for_operation = 3, -- Número de bombas que deben estar activas para operar el sistema
}

-- Configuración del Piloto Automático
AutopilotConfig = {
    disconnect_on_error = true,          -- Desconectar el piloto automático si se detecta un error en los sensores
    wind_data_update_interval = 5,       -- Intervalo en segundos para actualizar la información del viento
    ils_switch_required = true,          -- Requiere que los switches del ILS estén activados
}

-- Configuración de Sensores
SensorConfig = {
    ice_detection_enabled = true,        -- Habilitar la detección de hielo en sensores
    cross_validation_interval = 2,       -- Intervalo en segundos para validación cruzada de datos de sensores
    noise_threshold = 0.5,               -- Umbral de ruido aceptable en los datos de los sensores
    fail_safe_mode = true,               -- Activar modo seguro si se detectan datos erróneos
}

-- Configuración de Pantallas (Displays)
DisplayConfig = {
    pfd_update_interval = 0.1,           -- Intervalo de actualización del PFD en segundos
    nd_update_interval = 0.1,            -- Intervalo de actualización del ND en segundos
    ecam_update_interval = 0.1,          -- Intervalo de actualización del ECAM en segundos
    nd_show_wind = true,                 -- Mostrar información del viento en el ND
    nd_show_waypoint_distance = true,    -- Mostrar distancia al próximo waypoint en el ND
}
