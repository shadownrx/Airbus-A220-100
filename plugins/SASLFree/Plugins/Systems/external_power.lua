-- external_power.lua

-- Requiere módulos y configuración necesarios
require("config")
require("datarefs")  -- Asegúrate de que `datarefs.lua` esté disponible en el mismo directorio

-- Configuración del sistema de energía externa
local ExternalPower = {
    connected = false,  -- Estado de conexión de energía externa
    voltage = 0,        -- Voltaje de la energía externa
    frequency = 0       -- Frecuencia de la energía externa
}

-- Botón de energía externa
local dataref_external_power_switch = "your/dataref/external_power_switch"  -- Reemplaza con el dataref del botón

-- Función para conectar la energía externa
function connect_external_power()
    -- Configurar los parámetros de energía externa
    ExternalPower.connected = true
    ExternalPower.voltage = 115  -- Valor típico en voltios
    ExternalPower.frequency = 400 -- Frecuencia típica en Hz

    -- Actualizar los datos en el simulador
    set_external_power_datarefs(true, ExternalPower.voltage, ExternalPower.frequency)

    print("Energía externa conectada.")
end

-- Función para desconectar la energía externa
function disconnect_external_power()
    -- Restablecer los parámetros de energía externa
    ExternalPower.connected = false
    ExternalPower.voltage = 0
    ExternalPower.frequency = 0

    -- Actualizar los datos en el simulador
    set_external_power_datarefs(false, ExternalPower.voltage, ExternalPower.frequency)

    print("Energía externa desconectada.")
end

-- Función para actualizar los datos de energía externa en el simulador
function set_external_power_datarefs(connected, voltage, frequency)
    -- Aquí se debe configurar la conexión a los datarefs para la energía externa
    -- Asegúrate de que estos datarefs estén disponibles en `datarefs.lua`
    set(dataref_external_power_connected, connected)
    set(dataref_external_power_voltage, voltage)
    set(dataref_external_power_frequency, frequency)
end

-- Función para manejar el botón de energía externa
function handle_external_power_button()
    local button_state = get(dataref_external_power_switch)
    if button_state > 0 then  -- Asume que un valor mayor a 0 indica que el botón está presionado
        if not ExternalPower.connected then
            connect_external_power()
        else
            disconnect_external_power()
        end
    end
end

-- Función para comprobar el estado de la energía externa
function check_external_power()
    -- Leer el estado de la energía externa desde el simulador
    local connected = get(dataref_external_power_connected)
    local voltage = get(dataref_external_power_voltage)
    local frequency = get(dataref_external_power_frequency)

    -- Actualizar el estado de la energía externa
    ExternalPower.connected = connected
    ExternalPower.voltage = voltage
    ExternalPower.frequency = frequency

    -- Imprimir estado actual para depuración
    print("Estado de energía externa:")
    print("Conectado: " .. tostring(ExternalPower.connected))
    print("Voltaje: " .. ExternalPower.voltage .. "V")
    print("Frecuencia: " .. ExternalPower.frequency .. "Hz")
end

-- Inicializar y verificar el estado de la energía externa
function initialize_external_power()
    print("Inicializando sistema de energía externa...")
    check_external_power()
end

-- Función de actualización periódica para la energía externa
function external_power_update_operation()
    initialize_external_power()
    while true do
        handle_external_power_button()
        check_external_power()
        run_after_delay(1, external_power_update_operation)  -- Actualización cada segundo
    end
end

-- Iniciar la operación de actualización de energía externa
external_power_update_operation()
