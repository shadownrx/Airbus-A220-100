-- hidraulics.lua

-- Configuración del sistema hidráulico
local hydraulics = {
    { id = 0, is_on = false, pressure = 0, max_pressure = 3000 }, -- Sistema hidráulico 1
    { id = 1, is_on = false, pressure = 0, max_pressure = 3000 }, -- Sistema hidráulico 2
    { id = 2, is_on = false, pressure = 0, max_pressure = 3000 }  -- Sistema hidráulico 3
}

-- DataRefs para el sistema hidráulico
local hydraulic_pressure_dataref = {
    XPLMFindDataRef("aircraft/hydraulic/pressure1"), -- Presión del sistema hidráulico 1
    XPLMFindDataRef("aircraft/hydraulic/pressure2"), -- Presión del sistema hidráulico 2
    XPLMFindDataRef("aircraft/hydraulic/pressure3")  -- Presión del sistema hidráulico 3
}

local hydraulic_status_dataref = {
    XPLMFindDataRef("aircraft/hydraulic/status1"), -- Estado del sistema hidráulico 1
    XPLMFindDataRef("aircraft/hydraulic/status2"), -- Estado del sistema hidráulico 2
    XPLMFindDataRef("aircraft/hydraulic/status3")  -- Estado del sistema hidráulico 3
}

local ecam_message_dataref = XPLMFindDataRef("aircraft/ecam/message") -- DataRef para mensajes ECAM

-- DataRefs para los botones de las bombas hidráulicas
local pump_button1_dataref = XPLMFindDataRef("aircraft/hydraulic/pump_button1")
local pump_button2_dataref = XPLMFindDataRef("aircraft/hydraulic/pump_button2")
local pump_button3_dataref = XPLMFindDataRef("aircraft/hydraulic/pump_button3")

-- Función para actualizar el mensaje del ECAM
local function update_ecam_message(message)
    XPLMSetDatai(ecam_message_dataref, message)
end

-- Función para iniciar un sistema hidráulico
function start_hydraulic_system(hydraulic_id)
    if hydraulic_id < 0 or hydraulic_id >= #hydraulics then
        update_ecam_message("Invalid hydraulic system ID")
        return
    end
    
    if hydraulics[hydraulic_id].is_on then
        update_ecam_message("Hydraulic System " .. hydraulic_id .. " is already on.")
        return
    end

    update_ecam_message("Starting Hydraulic System " .. hydraulic_id .. "...")
    
    -- Simulación realista del proceso de inicio
    local pressure_increase_rate = 0.05 -- Tasa de aumento de presión
    local pressure_max = hydraulics[hydraulic_id].max_pressure
    hydraulics[hydraulic_id].is_on = true
    for pressure = 0, pressure_max, pressure_max * pressure_increase_rate do
        hydraulics[hydraulic_id].pressure = pressure
        XPLMSetDataf(hydraulic_pressure_dataref[hydraulic_id], pressure)
        os.execute("sleep " .. tonumber(0.2)) -- Intervalo de tiempo realista
    end
    update_ecam_message("Hydraulic System " .. hydraulic_id .. " started.")
    XPLMSetDatai(hydraulic_status_dataref[hydraulic_id], 1)
end

-- Función para detener un sistema hidráulico
function stop_hydraulic_system(hydraulic_id)
    if hydraulic_id < 0 or hydraulic_id >= #hydraulics then
        update_ecam_message("Invalid hydraulic system ID")
        return
    end
    
    if not hydraulics[hydraulic_id].is_on then
        update_ecam_message("Hydraulic System " .. hydraulic_id .. " is already off.")
        return
    end

    update_ecam_message("Stopping Hydraulic System " .. hydraulic_id .. "...")
    
    -- Simulación realista del proceso de apagado
    local pressure_decrease_rate = 0.05 -- Tasa de disminución de presión
    local pressure_min = 0
    for pressure = hydraulics[hydraulic_id].pressure, pressure_min, -pressure_decrease_rate * hydraulics[hydraulic_id].max_pressure do
        hydraulics[hydraulic_id].pressure = pressure
        XPLMSetDataf(hydraulic_pressure_dataref[hydraulic_id], pressure)
        os.execute("sleep " .. tonumber(0.2)) -- Intervalo de tiempo realista
    end
    hydraulics[hydraulic_id].is_on = false
    update_ecam_message("Hydraulic System " .. hydraulic_id .. " stopped.")
    XPLMSetDatai(hydraulic_status_dataref[hydraulic_id], 0)
end

-- Función para manejar el botón de las bombas hidráulicas
function on_pump_button_pressed(button_id)
    if button_id < 0 or button_id >= #hydraulics then
        update_ecam_message("Invalid pump button ID")
        return
    end

    if not hydraulics[button_id].is_on then
        start_hydraulic_system(button_id)
    else
        stop_hydraulic_system(button_id)
    end
end

-- Callback para detectar la acción de presionar el botón
local function pump_button_callback(button_id)
    on_pump_button_pressed(button_id)
end

-- Configuración de los botones de las bombas hidráulicas
function setup_pump_buttons()
    -- Asocia cada botón con su función de callback
    XPLMRegisterCommandHandler(pump_button1_dataref, function() pump_button_callback(0) end, 0, 0)
    XPLMRegisterCommandHandler(pump_button2_dataref, function() pump_button_callback(1) end, 0, 0)
    XPLMRegisterCommandHandler(pump_button3_dataref, function() pump_button_callback(2) end, 0, 0)
end

-- Función para inicializar todos los sistemas y botones
function initialize_hydraulics()
    -- Inicia todos los sistemas hidráulicos al iniciar
    for i = 0, #hydraulics - 1 do
        start_hydraulic_system(i)
    end
    -- Configura los botones de las bombas hidráulicas
    setup_pump_buttons()
end

-- Ejecutar inicialización al cargar el script
initialize_hydraulics()
