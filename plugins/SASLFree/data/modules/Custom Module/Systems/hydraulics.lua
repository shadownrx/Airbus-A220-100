-- hydraulics.lua

require("config")

local hydraulic_systems = {
    green = {
        pressure = 0,           -- PSI
        pump_active = false,    
        fluid_level = 100,      -- percentage
        leak_detected = false 
    },
    yellow = {
        pressure = 0,           -- PSI
        pump_active = false,    
        fluid_level = 100,      -- percentage
        leak_detected = false   
    },
    blue = {
        pressure = 0,           -- PSI
        pump_active = false,
        fluid_level = 100,      -- percentage
        leak_detected = false   
    }
}

local HydraulicConfig = {
    pressure_max = 3000,            -- PSI
    fluid_consumption_rate = 0.05,  -- percentage ratio (0-1)
    leak_rate = 0.1,                -- percentage ratio (0-1)
}

function activate_pump(system)
    if not hydraulic_systems[system].pump_active then
        hydraulic_systems[system].pump_active = true
        print("Hydraulic pump " .. system .. " is active.")
        start_hydraulic_system(system)
    else
        print("Hydraylic pump " .. system .. " is already active.")
    end
end

function deactivate_pump(system)
    if hydraulic_systems[system].pump_active then
        hydraulic_systems[system].pump_active = false
        hydraulic_systems[system].pressure = 0
        print("Hydraulic pump " .. system .. " is inactive.")
    else
        print("Hydraulic pump " .. system .. " is already inactive.")
    end
end

function start_hydraulic_system(system)
    if hydraulic_systems[system].fluid_level > 0 then
        run_after_delay(2, function()
            hydraulic_systems[system].pressure = HydraulicConfig.pressure_max
            update_ecam_display(system:upper() .. " HYD PRESSURE: " .. hydraulic_systems[system].pressure .. " PSI")
        end)
    else
        print("Fluid level low " .. system .. ".")
        update_ecam_display(system:upper() .. " HYD FLUID LOW")
    end
end

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

function detect_leak(system)
    if math.random() < 0.01 then -- TODO: indicated what the factor stands for
        hydraulic_systems[system].leak_detected = true
        print("Leak detected on the system " .. system)
        update_ecam_display(system:upper() .. " HYD LEAK")
    end
end

-- TODO: use a share function for this
function update_ecam_display(message)
    show_message_on_ecam(message)
end

-- TODO: use a share function for this
function show_message_on_ecam(message)
    print("ECAM: " .. message) 
end

function run_after_delay(delay, action)
    local start_time = os.time()
    while os.time() - start_time < delay do
        -- TODO: use SASL lifecycle
    end
    action()
end

function initialize_hydraulic_system()
    for system, _ in pairs(hydraulic_systems) do
        hydraulic_systems[system].pressure = 0
        hydraulic_systems[system].pump_active = false
        hydraulic_systems[system].fluid_level = 100
        hydraulic_systems[system].leak_detected = false
    end
    print("Hydraulic pumps initialized.")
end


function hydraulic_system_operation()
    while true do
        for system, _ in pairs(hydraulic_systems) do
            manage_hydraulic_fluid(system)
            detect_leak(system)
        end
        run_after_delay(1, hydraulic_system_operation) -- TODO: use SASL lifecycle
    end
end

initialize_hydraulic_system()
hydraulic_system_operation()
