-- electrical.lua

-- Cargar la configuración
require("config")

-- Variables del sistema eléctrico
local battery_voltage = 0
local screens_active = false
local ecam_initialized = false

-- Inicialización del sistema eléctrico
function initialize_electrical_system()
    battery_voltage = 0
    screens_active = false
    ecam_initialized = false
    print("Sistema eléctrico inicializado")
end

-- Encender la batería
function activate_battery()
    if battery_voltage >= ElectricalConfig.battery_voltage_required then
        screens_active = true
        print("Baterías activadas. Voltaje suficiente.")
        initialize_screens()
    else
        print("Advertencia: Voltaje insuficiente para activar las baterías.")
    end
end

-- Función para inicializar las pantallas
function initialize_screens()
    if screens_active then
        -- Temporizador para el arranque de las pantallas
        run_after_delay(ElectricalConfig.screen_startup_time, function()
            ecam_initialized = true
            print(ElectricalConfig.ecam_boot_message)
            update_ecam_display("ECAM Ready")
        end)
    end
end

-- Actualizar la pantalla del ECAM
function update_ecam_display(message)
    if ecam_initialized then
        -- Mostrar el mensaje en el ECAM
        show_message_on_ecam(message)
    else
        print("ECAM no está inicializado.")
    end
end

-- Función para mostrar mensajes en el ECAM (reemplaza a print)
function show_message_on_ecam(message)
    -- Aquí puedes implementar la lógica para mostrar mensajes en el ECAM
    -- En lugar de imprimir en consola, se mostrarán en la pantalla del ECAM
    draw_text_on_ecam(message)
end

-- Función simulada para dibujar texto en el ECAM (ejemplo simple)
function draw_text_on_ecam(message)
    -- Lógica para dibujar el texto en la pantalla del ECAM
    -- Esto debería conectarse con el sistema gráfico del avión
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

-- Activación del sistema eléctrico
function activate_electrical_system()
    print("Encendiendo sistema eléctrico...")
    battery_voltage = ElectricalConfig.battery_voltage_required
    activate_battery()
end

-- Inicializar el sistema al cargar
initialize_electrical_system()
