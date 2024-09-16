-- external_power.lua

require("config")
require("datarefs") 

local ExternalPower = {
    connected = false, 
    voltage = 0,        -- volts
    -- TODO: should we use double for frequency?
    frequency = 0       -- hertz
}

local dataref_external_power_switch = "your/dataref/external_power_switch" 

function connect_external_power()
    ExternalPower.connected = true
    ExternalPower.voltage = 115     -- volts
    ExternalPower.frequency = 400   -- hertz

    set_external_power_datarefs(true, ExternalPower.voltage, ExternalPower.frequency)

    print("Energía externa conectada.")
end

function disconnect_external_power()
    ExternalPower.connected = false
    ExternalPower.voltage = 0
    ExternalPower.frequency = 0

    set_external_power_datarefs(false, ExternalPower.voltage, ExternalPower.frequency)

    print("Ground power connected.")
end

function set_external_power_datarefs(connected, voltage, frequency)
    set(dataref_external_power_connected, connected)
    set(dataref_external_power_voltage, voltage)
    set(dataref_external_power_frequency, frequency)
end

function handle_external_power_button()
    local button_state = get(dataref_external_power_switch)
    if button_state > 0 then  -- When the state is greater than 0, it means it's been pressed
        if not ExternalPower.connected then
            connect_external_power()
        else
            disconnect_external_power()
        end
    end
end

function check_external_power()
    local connected = get(dataref_external_power_connected)
    local voltage = get(dataref_external_power_voltage)
    local frequency = get(dataref_external_power_frequency)

    ExternalPower.connected = connected
    ExternalPower.voltage = voltage
    ExternalPower.frequency = frequency

    print("External power status::")
    print("Connection: " .. tostring(ExternalPower.connected))
    print("Voltage: " .. ExternalPower.voltage .. "V")
    print("Frequency: " .. ExternalPower.frequency .. "Hz")
end

function initialize_external_power()
    print("Starting external power...")
    check_external_power()
end

function external_power_update_operation()
    initialize_external_power()
    while true do
        handle_external_power_button()
        check_external_power()
        run_after_delay(1, external_power_update_operation)  -- TODO: use SASLv3 lifecycle
    end
end

external_power_update_operation()
