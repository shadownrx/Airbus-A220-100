-- hydraulics.lua

-- Cargar configuración
require("config")

-- Variables del sistema hidráulico
local hydraulic_systems = {
    green = {
        pressure = 0,       -- Presión del sistema hidráulico verde
        pump_active = false,-- Estado de la bomba hidráulica verde
        fluid_level = 100,  -- Nivel de fluido del sistema verde (en %)
        leak_detected = false -- Detección de fugas
    },
    yellow = {
        pressure = 0,       -- Presión del sistema hidráulico amarillo
        pump_active = false,-- Estado de la bomba hidráulica amarilla
        fluid_level = 100,  -- Nivel de fluido del sistema amarillo (en %)
        leak_detected = false -- Detección de fugas
    },
    blue = {
        pressure = 0,       -- Presión del sistema hidráulico azul
        pump_active = false,-- Estado de la bomba hidráulica azul
        fluid_level = 100,  -- Nivel de fluido del sistema azul (en %)
        leak_detected = false -- Detección de fugas
    }
}

-- Configuración de los sistemas hidráulicos
local HydraulicConfig = {
    pressure_max = 3000, -- Presión máxima en PSI
    fluid_consumption_rate = 0.05, -- Tasa de consumo de fluido por segundo (%)
    leak_rate = 0.1, -- Tasa de fuga de fluido por segundo (%)
}

-- Función para activar una bomba hidráulica
function activate_pump(system)
    if not hydraulic_systems[system].pump_active then
        hydraulic_systems[system].pump_active = true
        print("Bomba hidráulica " .. system .. " activada.")
        start_hydraulic_system(system)
    else
        print("Bomba hidráulica " .. system .. " ya está activa.")
    end
end

-- Función para desactivar una bomba hidráulica
function deactivate_pump(system)
    if hydraulic_systems[system].pump_active then
        hydraulic_systems[system].pump_active = false
        hydraulic_systems[system].pressure = 0
        print("Bomba hidráulica " .. system .. " desactivada.")
    else
        print("Bomba hidráulica " .. system .. " ya está desactivada.")
    end
end

-- Función para iniciar un sistema hidráulico
function start_hydraulic_system(system)
    if hydraulic_systems[system].fluid_level > 0 then
        run_after_delay(2, function()
            hydraulic_systems[system].pressure = HydraulicConfig.pressure_max
            update_ecam_display(system:upper() .. " HYD PRESSURE: " .. hydraulic_systems[system].pressure .. " PSI")
        end)
    else
        print("Nivel de fluido insuficiente en el sistema " .. system .. ".")
        update_ecam_display(system:upper() .. " HYD FLUID LOW")
    end
end

-- Función para simular el consumo de fluido y detección de fugas
function manage_hydraulic_fluid(system)
    if hydraulic_systems[system].pump_active then
        hydraulic_systems[system].fluid_level = hydraulic_systems[system].fluid_level - HydraulicConfig.fluid_consumption_rate

        if hydraulic_systems[system].fluid_level <= 0 then
            hydraulic_systems[system].fluid_level = 0
            deactivate_pump(system)
            update_ecam_display(system:upper() .. " HYD PUMP OFF")
        elseif hydraulic_systems[system].leak_detected then
            hydraulic_systems[system].fluid_level = hydraulic_systems[system].fluid_level - HydraulicConfig.leak_rate
            update_ecam_display(system:upper() .. " HYD LEAK DETECTED")
        end
    end
end

-- Función para detectar fugas en el sistema hidráulico
function detect_leak(system)
    if math.random() < 0.01 then -- Simula una pequeña probabilidad de fuga
        hydraulic_systems[system].leak_detected = true
        print("Fuga detectada en el sistema " .. system)
        update_ecam_display(system:upper() .. " HYD LEAK")
    end
end

-- Función para actualizar el ECAM con el estado del sistema hidráulico
function update_ecam_display(message)
    -- Aquí puedes implementar la lógica para mostrar mensajes en el ECAM
    show_message_on_ecam(message)
end

-- Función para mostrar mensajes en el ECAM (reemplaza a print)
function show_message_on_ecam(message)
    -- Lógica para dibujar el texto en la pantalla del ECAM
    print("ECAM: " .. message)  -- Esta línea es para depuración; en un simulador real, se reemplaza por un dibujo en pantalla
end

-- Función para ejecutar una acción después de un retraso (simulando un temporizador)
function run_after_delay(delay, action)
    -- Simulación de retraso (en un entorno real, esto se haría de otra manera)
    local start_time = os.time()
    while os.time() - start_time < delay do
        -- Esperar
    end
    action()
end

-- Función para inicializar el sistema hidráulico al inicio
function initialize_hydraulic_system()
    for system, _ in pairs(hydraulic_systems) do
        hydraulic_systems[system].pressure = 0
        hydraulic_systems[system].pump_active = false
        hydraulic_systems[system].fluid_level = 100
        hydraulic_systems[system].leak_detected = false
    end
    print("Sistemas hidráulicos inicializados.")
end

-- Llamar a la inicialización del sistema al cargar
initialize_hydraulic_system()

-- Simulación de la operación continua del sistema hidráulico
function hydraulic_system_operation()
    while true do
        for system, _ in pairs(hydraulic_systems) do
            manage_hydraulic_fluid(system)
            detect_leak(system)
        end
        run_after_delay(1, hydraulic_system_operation) -- Simular cada segundo
    end
end

-- Iniciar la simulación del sistema hidráulico
hydraulic_system_operation()
