-- ecam_display.lua

require("config")
require("datarefs")  

-- TODO: use variables instead of table
local ECAM = {
    system_status = {
        engines = "OFF",
        hydraulic = "OFF",
        electrical = "OFF",
        apu = "OFF"
    },
    alerts = {}
}

function initialize_ECAM()
    print("Initializing ECAM...")
end

function update_ECAM()
    local data = read_datarefs()

    ECAM.system_status.engines = data.engines_status
    ECAM.system_status.hydraulic = data.hydraulic_status
    ECAM.system_status.electrical = data.electrical_status
    ECAM.system_status.apu = data.apu_status

    ECAM.alerts = generate_alerts(data)

    update_ecam_graphics()
end

function generate_alerts(data)
    local alerts = {}
    if data.engines_status == "FAULT" then
        table.insert(alerts, "ENG FAIL")
    end
    if data.hydraulic_status == "LOW PRESSURE" then
        table.insert(alerts, "HYD PRESS LOW")
    end
    if data.electrical_status == "DISCONNECTED" then
        table.insert(alerts, "ELEC DISCONNECT")
    end
    if data.apu_status == "NO PRESSURE" then
        table.insert(alerts, "APU BLEED OFF")
    end
    -- Agregar más condiciones según sea necesario
    return alerts
end

-- TODO: Have this as a shared function
function update_ecam_graphics()
    print("Updating ECAM values:")
    print("Engines: " .. ECAM.system_status.engines)
    print("Hydralics: " .. ECAM.system_status.hydraulic)
    print("Electrical: " .. ECAM.system_status.electrical)
    print("APU: " .. ECAM.system_status.apu)
    print("Warnings:")
    for i, alert in ipairs(ECAM.alerts) do
        print(alert)
    end
end

function ecam_update_operation()
    initialize_ECAM()
    while true do
        update_ECAM()
        run_after_delay(1, ecam_update_operation) -- RTODO: use SASL lifecycle
    end
end

ecam_update_operation()
