-- init.lua

require("config")
require("datarefs")  

-- TODO: use SASL lifecycle
local function initialize_systems()
    print("Initializing systems...")
    
    if not ecam_display_initialized then
        require("system.ecam_display")
        ecam_display_initialized = true
    end

    if not nd_display_initialized then
        require("system.nd_display")
        nd_display_initialized = true
    end

    if not sensors_initialized then
        require("system.sensors")
        sensors_initialized = true
    end

    -- Inicializar piloto automático
    if not autopilot_initialized then
        require("system.autopilot") 
        autopilot_initialized = true
    end

    if not hydraulics_initialized then
        require("system.hydraulics")
        hydraulics_initialized = true
    end

    if not apu_initialized then
        require("system.apu")
        apu_initialized = true
    end

    if not engines_initialized then
        require("system.engines")
        engines_initialized = true
    end

    if not electrical_initialized then
        require("system.electrical")
        electrical_initialized = true
    end

    print("All systems have been initialized.")
end

-- TODO: use SASL lifecycle
function run_initialization()
    print("Setting up initial parameters")

    initialize_systems()

    while true do
        if ecam_display_initialized then
            update_ECAM()
        end
        if nd_display_initialized then
            update_ND()
        end
        if sensors_initialized then
            update_sensors()
        end
        if autopilot_initialized then
            update_autopilot()
        end

        run_after_delay(1, run_initialization)  -- TODO: use SASL lifecycle
    end
end

run_initialization()
