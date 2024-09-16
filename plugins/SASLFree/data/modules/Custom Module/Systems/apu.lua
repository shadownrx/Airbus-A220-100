-- apu.lua

local apu_running = false
local apu_bleed_pressure = 0    -- PSI
local apu_power_output = 0      -- TODO: define unit
local apu_starting = false
local apu_available = false

-- TODO: use variables instead of tables
local APUConfig = {
    -- TODO: use millseconds
    start_time = 30,                -- seconds
    bleed_pressure_threshold = 45,  -- PSI
    power_output_max = 90           -- percentages
}

function start_apu()
    if not apu_running and not apu_starting then
        apu_starting = true
        print("Starting APU...")
        run_after_delay(APUConfig.start_time, function()
            apu_running = true
            apu_available = true
            apu_bleed_pressure = APUConfig.bleed_pressure_threshold
            apu_power_output = APUConfig.power_output_max
            print("APU available. Bleed pressure: " .. apu_bleed_pressure .. " PSI")
            update_ecam_display("APU READY")
        end)
    else
        print("APU already running or available.")
    end
end

function shutdown_apu()
    if apu_running then
        print("Shutting down APU...")
        apu_running = false
        apu_available = false
        apu_bleed_pressure = 0
        apu_power_output = 0
        print("APU shutdown.")
        update_ecam_display("APU SHUTDOWN")
    else
        print("APU not running.")
    end
end

function check_apu_bleed()
    if apu_running and apu_bleed_pressure >= APUConfig.bleed_pressure_threshold then
        print("APU Bleed Pressure OK: " .. apu_bleed_pressure .. " PSI")
        return true
    else
        print("Warning: Low bleed pressure.")
        return false
    end
end

function update_ecam_display(message)
    show_message_on_ecam(message)
end

function show_message_on_ecam(message)
    print("ECAM: " .. message)  
end

function run_after_delay(delay, action)
    local start_time = os.time()
    while os.time() - start_time < delay do
        -- TODO: This should be handled using SASL API
    end
    action()
end

function initialize_apu_system()
    apu_running = false
    apu_bleed_pressure = 0
    apu_power_output = 0
    apu_starting = false
    apu_available = false
    print("APU initialized.")
end

initialize_apu_system()
