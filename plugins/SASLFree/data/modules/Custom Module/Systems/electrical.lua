-- electrical.lua

require("config")


local battery_voltage = 0       -- volts
local screens_active = false
local ecam_initialized = false

function initialize_electrical_system()
    battery_voltage = 0
    screens_active = false
    ecam_initialized = false
    print("Electrical system initialized")
end

-- Encender la batería
function activate_battery()
    if battery_voltage >= ElectricalConfig.battery_voltage_required then
        screens_active = true
        print("Baterries ON. Voltage OK.")
        initialize_screens()
    else
        print("Warning: Voltage is low.")
    end
end

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

function update_ecam_display(message)
    if ecam_initialized then
        -- Mostrar el mensaje en el ECAM
        show_message_on_ecam(message)
    else
        print("ECAM not initialized.")
    end
end

-- TODO: this is also implemented on other components.
-- We could use a shared component
function show_message_on_ecam(message)
    draw_text_on_ecam(message)
end

function draw_text_on_ecam(message)
    print("ECAM: " .. message) 
end

function run_after_delay(delay, action)
    local start_time = os.time()
    while os.time() - start_time < delay do
        -- TODO: use SASL built-in functions
    end
    action()
end

function activate_electrical_system()
    print("Turning on electrical system...")
    battery_voltage = ElectricalConfig.battery_voltage_required
    activate_battery()
end

initialize_electrical_system()
