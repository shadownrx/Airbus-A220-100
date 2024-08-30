-- init.lua

-- Requiere módulos y configuración necesarios
require("config")
require("datarefs")  -- Asegúrate de que `datarefs.lua` esté disponible en el mismo directorio

-- Funciones de inicialización para los sistemas del avión
local function initialize_systems()
    -- Inicializar cada sistema
    print("Inicializando sistemas del avión...")
    
    -- Inicializar ECAM
    if not ecam_display_initialized then
        require("system.ecam_display")  -- Asegúrate de que `ecam_display.lua` esté disponible
        ecam_display_initialized = true
    end

    -- Inicializar ND
    if not nd_display_initialized then
        require("system.nd_display")  -- Asegúrate de que `nd_display.lua` esté disponible
        nd_display_initialized = true
    end

    -- Inicializar sensores
    if not sensors_initialized then
        require("system.sensors")  -- Asegúrate de que `sensors.lua` esté disponible
        sensors_initialized = true
    end

    -- Inicializar piloto automático
    if not autopilot_initialized then
        require("system.autopilot")  -- Asegúrate de que `autopilot.lua` esté disponible
        autopilot_initialized = true
    end

    -- Inicializar hidráulicos
    if not hydraulics_initialized then
        require("system.hydraulics")  -- Asegúrate de que `hydraulics.lua` esté disponible
        hydraulics_initialized = true
    end

    -- Inicializar APU
    if not apu_initialized then
        require("system.apu")  -- Asegúrate de que `apu.lua` esté disponible
        apu_initialized = true
    end

    -- Inicializar motores
    if not engines_initialized then
        require("system.engines")  -- Asegúrate de que `engines.lua` esté disponible
        engines_initialized = true
    end

    -- Inicializar eléctrico
    if not electrical_initialized then
        require("system.electrical")  -- Asegúrate de que `electrical.lua` esté disponible
        electrical_initialized = true
    end

    print("Todos los sistemas del avión han sido inicializados.")
end

-- Función para ejecutar la inicialización
function run_initialization()
    -- Configurar cualquier cosa necesaria antes de la inicialización
    print("Configurando parámetros iniciales...")

    -- Llamar a la función de inicialización de sistemas
    initialize_systems()

    -- Ejecutar actualizaciones periódicas para los sistemas
    while true do
        -- Aquí puedes llamar a las funciones de actualización de cada sistema
        -- Por ejemplo, actualiza el ECAM, ND, sensores, etc.
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

        -- Puedes agregar actualizaciones para otros sistemas aquí

        run_after_delay(1, run_initialization)  -- Actualización cada segundo (ajustar según sea necesario)
    end
end

-- Iniciar la inicialización
run_initialization()
