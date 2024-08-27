-- autopilot.lua

-- Importar funciones de sensors.lua, switches.lua, y otros sistemas relevantes
require("sensors")
require("switches")
require("fms")  -- Gestión del FMS
require("climate")  -- Ajustes por clima

-- Configuración de los DataRefs adicionales necesarios
local autopilot_engaged = XPLMFindDataRef("sim/cockpit/autopilot/autopilot_state")
local autopilot_fms_mode = XPLMFindDataRef("sim/cockpit/autopilot/fms_mode")
local autopilot_vor_loc = XPLMFindDataRef("sim/cockpit/autopilot/nav1_loc")
local autopilot_ils_loc = XPLMFindDataRef("sim/cockpit/autopilot/ils_loc")
local autopilot_rnav_mode = XPLMFindDataRef("sim/cockpit/autopilot/rnav_mode")

local ecam_message_dataref = XPLMFindDataRef("aircraft/ecam/message")

-- Funciones para actualizar los mensajes en el ECAM
function update_ecam_message(message)
    XPLMSetDataf(ecam_message_dataref, message)
end

-- Funciones de activación y desactivación del autopilot (AP1 y AP2
function activate_ap1()
    XPLMSetDatai(autopilot_engaged, 1)
    update_ecam_message("AP1 Engaged")
end

function deactivate_ap1()
    XPLMSetDatai(autopilot_engaged, 0)
    update_ecam_message("AP1 Disengaged")
end

function activate_ap2()
    XPLMSetDatai(autopilot_engaged, 2)
    update_ecam_message("AP2 Engaged")
end

function deactivate_ap2()
    XPLMSetDatai(autopilot_engaged, 0)
    update_ecam_message("AP2 Disengaged")
end

-- Función de inicialización del piloto automático
function initialize_autopilot()
    update_ecam_message("Initializing Autopilot System...")
    set_autopilot_altitude(10000)
    set_autopilot_vertical_speed(1500)
    set_autopilot_heading(0)
    set_autopilot_airspeed(250)
    update_ecam_message("Autopilot System Initialized")
end

-- Función de recuperación automática
function auto_recovery()
    local pitch = XPLMGetDataf("sim/flightmodel/position/theta")
    local roll = XPLMGetDataf("sim/flightmodel/position/phi")
    
    if pitch < -10 or pitch > 30 or roll > 45 or roll < -45 then
        update_ecam_message("ATTITUDE WARNING: Engaging recovery")
        activate_ap1()  -- Enganchar piloto automático si no está ya enganchado
        XPLMSetDataf("sim/cockpit/autopilot/altitude", XPLMGetDataf("sim/flightmodel/position/elevation") + 2000)
        XPLMSetDataf("sim/cockpit/autopilot/vertical_velocity", 1500)
        XPLMSetDataf("sim/cockpit/autopilot/heading", XPLMGetDataf("sim/flightmodel/position/mag_psi"))
    end
end

-- Función para monitorizar el clima
function monitor_climate()
    local turbulence = XPLMGetDataf("sim/weather/turbulence_mild_percent")
    
    if turbulence > 0.5 then
        update_ecam_message("Turbulence Detected: Adjusting autopilot")
        XPLMSetDataf("sim/cockpit/autopilot/airspeed", XPLMGetDataf("sim/flightmodel/position/indicated_airspeed2") - 10)
    end
end

-- Función para validar datos de sensores cruzados
function validate_sensors()
    local airspeed_sensor_1 = XPLMGetDataf("sim/flightmodel/position/indicated_airspeed2")
    local airspeed_sensor_2 = XPLMGetDataf("sim/flightmodel/position/indicated_airspeed1")
    
    -- Comparar valores de los sensores para detectar discrepancias
    if math.abs(airspeed_sensor_1 - airspeed_sensor_2) > 10 then
        update_ecam_message("Sensor Discrepancy Detected: Disengaging autopilot")
        deactivate_ap1()
        deactivate_ap2()
    end
end

-- Integración con el FMS y otros sistemas de navegación
function manage_fms()
    local fms_mode = XPLMGetDatai(autopilot_fms_mode)
    
    if fms_mode == 1 then
        update_ecam_message("FMS Mode Active: Following flight plan")
    elseif fms_mode == 0 then
        update_ecam_message("FMS Mode Inactive")
    end
end

-- Monitoreo y actualización del piloto automático
function update_autopilot()
    monitor_sensors()  -- Verificar los sensores
    auto_recovery()  -- Verificar la necesidad de recuperación automática
    monitor_climate()  -- Ajustar por clima
    validate_sensors()  -- Validar datos de sensores
    manage_fms()  -- Gestión del FMS y seguimiento del plan de vuelo
end

-- Llamar a la función de inicialización cuando se cargue el script
initialize_autopilot()

-- Configurar la actualización continua
do_often("update_autopilot()")
