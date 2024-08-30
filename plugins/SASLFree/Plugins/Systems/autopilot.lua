-- autopilot.lua

-- Cargar módulos y configuración necesarios
require("config")
require("sensors")

-- Variables del Autopilot
local autopilot_active = false
local selected_altitude = 0
local selected_heading = 0
local selected_speed = 0
local current_mode = "OFF"
local vertical_speed = 0
local nav_data = {}
local ils_data = {}
local wind_info = {}

-- Configuración del Autopilot
local AutopilotConfig = {
    max_pitch = 15,  -- Grados máximos de inclinación
    max_roll = 30,   -- Grados máximos de alabeo
    max_vertical_speed = 6000, -- Velocidad vertical máxima en ft/min
    min_speed = 130, -- Velocidad mínima en knots
    max_speed = 320, -- Velocidad máxima en knots
    sensor_threshold = 5, -- Umbral para la detección de errores en sensores
}

-- Función para activar el piloto automático
function activate_autopilot()
    if not autopilot_active then
        autopilot_active = true
        current_mode = "ALT_HOLD" -- Modo inicial del autopilot
        update_ecam_display("AUTOPILOT ACTIVATED")
        print("Piloto automático activado.")
    else
        print("Piloto automático ya está activado.")
    end
end

-- Función para desactivar el piloto automático
function deactivate_autopilot()
    if autopilot_active then
        autopilot_active = false
        current_mode = "OFF"
        update_ecam_display("AUTOPILOT DISENGAGED")
        print("Piloto automático desactivado.")
    else
        print("Piloto automático ya está desactivado.")
    end
end

-- Función para cambiar el modo del piloto automático
function change_mode(new_mode)
    if autopilot_active then
        current_mode = new_mode
        update_ecam_display("AUTOPILOT MODE: " .. new_mode)
        print("Cambiando modo del piloto automático a " .. new_mode)
    else
        print("No se puede cambiar de modo, el piloto automático no está activado.")
    end
end

-- Función para configurar la altitud seleccionada
function set_selected_altitude(altitude)
    if altitude >= 0 then
        selected_altitude = altitude
        update_ecam_display("ALTITUDE SET: " .. altitude .. " FT")
        print("Altitud seleccionada: " .. altitude .. " pies")
    else
        print("Altitud inválida seleccionada.")
    end
end

-- Función para configurar el rumbo seleccionado
function set_selected_heading(heading)
    if heading >= 0 and heading <= 360 then
        selected_heading = heading
        update_ecam_display("HEADING SET: " .. heading .. "°")
        print("Rumbo seleccionado: " .. heading .. "°")
    else
        print("Rumbo inválido seleccionado.")
    end
end

-- Función para configurar la velocidad seleccionada
function set_selected_speed(speed)
    if speed >= AutopilotConfig.min_speed and speed <= AutopilotConfig.max_speed then
        selected_speed = speed
        update_ecam_display("SPEED SET: " .. speed .. " KTS")
        print("Velocidad seleccionada: " .. speed .. " knots")
    else
        print("Velocidad inválida seleccionada.")
    end
end

-- Función para calcular la desviación del ILS
function calculate_ils_deviation()
    local deviation = {
        localizer = ils_data.localizer - sensors.get_heading(),
        glideslope = ils_data.glideslope - sensors.get_altitude()
    }
    return deviation
end

-- Función para manejar el piloto automático
function manage_autopilot()
    if autopilot_active then
        -- Control de altitud
        if current_mode == "ALT_HOLD" then
            local altitude_error = selected_altitude - sensors.get_altitude()
            adjust_pitch(altitude_error)
        elseif current_mode == "VS_HOLD" then
            adjust_vertical_speed(vertical_speed)
        end

        -- Control de rumbo
        if current_mode == "HDG_HOLD" then
            local heading_error = selected_heading - sensors.get_heading()
            adjust_roll(heading_error)
        elseif current_mode == "NAV" then
            local nav_deviation = calculate_nav_deviation()
            adjust_roll(nav_deviation)
        end

        -- Control de velocidad
        adjust_thrust(selected_speed - sensors.get_speed())

        -- Verificar errores en sensores
        if check_sensor_errors() then
            deactivate_autopilot()
            update_ecam_display("AUTOPILOT DISENGAGED DUE TO SENSOR ERROR")
        end
    end
end

-- Función para ajustar el pitch
function adjust_pitch(error)
    local pitch_command = error * 0.01 -- Ajuste proporcional
    pitch_command = clamp(pitch_command, -AutopilotConfig.max_pitch, AutopilotConfig.max_pitch)
    sensors.set_pitch(pitch_command)
end

-- Función para ajustar el roll
function adjust_roll(error)
    local roll_command = error * 0.01 -- Ajuste proporcional
    roll_command = clamp(roll_command, -AutopilotConfig.max_roll, AutopilotConfig.max_roll)
    sensors.set_roll(roll_command)
end

-- Función para ajustar la velocidad vertical
function adjust_vertical_speed(vs)
    if vs <= AutopilotConfig.max_vertical_speed then
        sensors.set_vertical_speed(vs)
    else
        print("Velocidad vertical fuera de límites.")
    end
end

-- Función para ajustar el empuje
function adjust_thrust(thrust_error)
    local thrust_command = thrust_error * 0.1 -- Ajuste proporcional
    sensors.set_thrust(thrust_command)
end

-- Función para calcular la desviación de navegación
function calculate_nav_deviation()
    -- Lógica para calcular la desviación respecto a la ruta NAV
    return nav_data.desired_heading - sensors.get_heading()
end

-- Función para verificar errores en sensores
function check_sensor_errors()
    local sensor_data = sensors.get_data()
    for _, value in pairs(sensor_data) do
        if math.abs(value.error) > AutopilotConfig.sensor_threshold then
            return true
        end
    end
    return false
end

-- Función para manejar botones de ILS
function handle_ils_buttons()
    local ils_deviation = calculate_ils_deviation()
    if ils_deviation.localizer > AutopilotConfig.sensor_threshold then
        change_mode("LOC")
    elseif ils_deviation.glideslope > AutopilotConfig.sensor_threshold then
        change_mode("G/S")
    end
end

-- Función para actualizar la pantalla del ECAM
function update_ecam_display(message)
    -- Aquí se podría dibujar texto en el ECAM
    show_message_on_ecam(message)
end

-- Función para mostrar mensajes en el ECAM (reemplaza a print)
function show_message_on_ecam(message)
    -- Lógica para dibujar el texto en la pantalla del ECAM
    print("ECAM: " .. message)  -- Esta línea es para depuración; en un simulador real, se reemplaza por un dibujo en pantalla
end

-- Función de clamping para limitar valores
function clamp(value, min_val, max_val)
    if value < min_val then
        return min_val
    elseif value > max_val then
        return max_val
    else
        return value
    end
end

-- Inicialización del Autopilot
function initialize_autopilot()
    deactivate_autopilot()
    print("Autopilot inicializado.")
end

-- Llamada a la inicialización del Autopilot al cargar
initialize_autopilot()

-- Simulación continua del Autopilot
function autopilot_operation()
    while true do
        manage_autopilot()
        run_after_delay(1, autopilot_operation) -- Simular cada segundo
    end
end

-- Iniciar la simulación del Autopilot
autopilot_operation()
