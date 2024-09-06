-- apu.lua

-- Variables del sistema APU
local apu_running = false
local apu_bleed_pressure = 0
local apu_power_output = 0
local apu_starting = false
local apu_available = false

-- Configuración del APU
local APUConfig = {
    start_time = 30, -- Tiempo en segundos para que el APU arranque completamente
    bleed_pressure_threshold = 45, -- Presión mínima en PSI para que el APU Bleed sea útil
    power_output_max = 90 -- Potencia máxima que puede generar el APU (en %)
}

-- Función para iniciar el APU
function start_apu()
    if not apu_running and not apu_starting then
        apu_starting = true
        print("Iniciando APU...")
        run_after_delay(APUConfig.start_time, function()
            apu_running = true
            apu_available = true
            apu_bleed_pressure = APUConfig.bleed_pressure_threshold
            apu_power_output = APUConfig.power_output_max
            print("APU operativo. Presión del bleed: " .. apu_bleed_pressure .. " PSI")
            update_ecam_display("APU READY")
        end)
    else
        print("APU ya está en proceso de arranque o está corriendo.")
    end
end

-- Función para apagar el APU
function shutdown_apu()
    if apu_running then
        print("Apagando APU...")
        apu_running = false
        apu_available = false
        apu_bleed_pressure = 0
        apu_power_output = 0
        print("APU apagado.")
        update_ecam_display("APU SHUTDOWN")
    else
        print("El APU no está corriendo.")
    end
end

-- Verificar presión de bleed
function check_apu_bleed()
    if apu_running and apu_bleed_pressure >= APUConfig.bleed_pressure_threshold then
        print("APU Bleed Pressure OK: " .. apu_bleed_pressure .. " PSI")
        return true
    else
        print("Advertencia: Presión de bleed insuficiente.")
        return false
    end
end

-- Función para actualizar el ECAM con el estado del APU
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

-- Función para inicializar el APU al inicio
function initialize_apu_system()
    apu_running = false
    apu_bleed_pressure = 0
    apu_power_output = 0
    apu_starting = false
    apu_available = false
    print("Sistema APU inicializado.")
end

-- Llamar a la inicialización del sistema al cargar
initialize_apu_system()
