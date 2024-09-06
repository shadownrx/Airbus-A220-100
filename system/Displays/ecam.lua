-- ecam.lua para el ECAM del Airbus A220

-- DataRefs para la información del sistema
local battery_status_dataref = XPLMFindDataRef("sim/cockpit2/electrical/battery_on")
local hydraulic_status_dataref = XPLMFindDataRef("sim/cockpit2/hydraulic/pump_status")
local engines_status_dataref = XPLMFindDataRef("sim/cockpit2/engines/engine_status")
local autopilot_status_dataref = XPLMFindDataRef("sim/cockpit2/autopilot/status")
local sensors_status_dataref = XPLMFindDataRef("sim/cockpit2/sensors/status")

-- Mensajes ECAM detallados
local ecam_messages = {
    ["BATT"] = {
        ["ON"] = "Battery Power Available",
        ["OFF"] = "Battery Power Not Available",
        ["FAIL"] = "Battery Failure"
    },
    ["HYD"] = {
        ["ON"] = "Hydraulic System Operational",
        ["OFF"] = "Hydraulic Pump Off",
        ["FAIL"] = "Hydraulic Pump Failure"
    },
    ["ENG"] = {
        ["ON"] = "Engines Running",
        ["OFF"] = "Engines Off",
        ["FAIL"] = "Engine Failure"
    },
    ["AP"] = {
        ["ON"] = "Autopilot Engaged",
        ["OFF"] = "Autopilot Disengaged",
        ["FAIL"] = "Autopilot Failure"
    },
    ["SENS"] = {
        ["ON"] = "Sensors Functional",
        ["OFF"] = "Sensors Error",
        ["FAIL"] = "Sensors Failure"
    },
}

-- Función para obtener el estado de los sistemas
function get_system_status()
    local battery_status = XPLMGetDatai(battery_status_dataref)
    local hydraulic_status = XPLMGetDatai(hydraulic_status_dataref)
    local engines_status = XPLMGetDatai(engines_status_dataref)
    local autopilot_status = XPLMGetDatai(autopilot_status_dataref)
    local sensors_status = XPLMGetDatai(sensors_status_dataref)

    return battery_status, hydraulic_status, engines_status, autopilot_status, sensors_status
end

-- Función para dibujar iconos y gráficos de estado
function draw_status_icon(x, y, status, color, text)
    XPLMSetColor(color[1], color[2], color[3], color[4])
    XPLMDrawRectangle(x, y, x + 40, y + 40, xplmColor_White) -- Fondo del icono
    XPLMSetColor(0, 0, 0, 1) -- Color del icono
    XPLMDrawString(x + 10, y + 20, text, nil, nil, xplmFont_Basic)
end

-- Función para actualizar el ECAM
function update_ecam()
    local battery_status, hydraulic_status, engines_status, autopilot_status, sensors_status = get_system_status()

    -- Obtener el tamaño de la ventana de dibujo
    local w, h = XPLMGetScreenSize()

    -- Crear un nuevo contexto de dibujo
    local context = XPLMCreateGraphicsContext()

    -- Dibujar el ECAM
    XPLMSetGraphicsContext(context)
    XPLMSetColor(0, 0, 0, 1)  -- Color de fondo negro
    XPLMDrawRectangle(0, 0, w, h, xplmColor_White)  -- Área de visualización del ECAM

    -- Mostrar los mensajes del ECAM
    local y_offset = h - 60
    local text_color = {1, 1, 1, 1}  -- Color blanco para el texto

    -- Battery Status
    if battery_status == 1 then
        draw_status_icon(10, y_offset - 40, "BATT", {0, 1, 0, 1}, "ON") -- Icono verde
        XPLMDrawString(60, y_offset, ecam_messages["BATT"]["ON"], nil, nil, xplmFont_Basic)
    elseif battery_status == 0 then
        draw_status_icon(10, y_offset - 40, "BATT", {1, 0, 0, 1}, "OFF") -- Icono rojo
        XPLMDrawString(60, y_offset, ecam_messages["BATT"]["OFF"], nil, nil, xplmFont_Basic)
    else
        draw_status_icon(10, y_offset - 40, "BATT", {1, 0.5, 0, 1}, "FAIL") -- Icono amarillo
        XPLMDrawString(60, y_offset, ecam_messages["BATT"]["FAIL"], nil, nil, xplmFont_Basic)
    end
    y_offset = y_offset - 50

    -- Hydraulic Status
    if hydraulic_status == 1 then
        draw_status_icon(10, y_offset - 40, "HYD", {0, 1, 0, 1}, "ON") -- Icono verde
        XPLMDrawString(60, y_offset, ecam_messages["HYD"]["ON"], nil, nil, xplmFont_Basic)
    elseif hydraulic_status == 0 then
        draw_status_icon(10, y_offset - 40, "HYD", {1, 0, 0, 1}, "OFF") -- Icono rojo
        XPLMDrawString(60, y_offset, ecam_messages["HYD"]["OFF"], nil, nil, xplmFont_Basic)
    else
        draw_status_icon(10, y_offset - 40, "HYD", {1, 0.5, 0, 1}, "FAIL") -- Icono amarillo
        XPLMDrawString(60, y_offset, ecam_messages["HYD"]["FAIL"], nil, nil, xplmFont_Basic)
    end
    y_offset = y_offset - 50

    -- Engines Status
    if engines_status == 1 then
        draw_status_icon(10, y_offset - 40, "ENG", {0, 1, 0, 1}, "ON") -- Icono verde
        XPLMDrawString(60, y_offset, ecam_messages["ENG"]["ON"], nil, nil, xplmFont_Basic)
    elseif engines_status == 0 then
        draw_status_icon(10, y_offset - 40, "ENG", {1, 0, 0, 1}, "OFF") -- Icono rojo
        XPLMDrawString(60, y_offset, ecam_messages["ENG"]["OFF"], nil, nil, xplmFont_Basic)
    else
        draw_status_icon(10, y_offset - 40, "ENG", {1, 0.5, 0, 1}, "FAIL") -- Icono amarillo
        XPLMDrawString(60, y_offset, ecam_messages["ENG"]["FAIL"], nil, nil, xplmFont_Basic)
    end
    y_offset = y_offset - 50

    -- Autopilot Status
    if autopilot_status == 1 then
        draw_status_icon(10, y_offset - 40, "AP", {0, 1, 0, 1}, "ON") -- Icono verde
        XPLMDrawString(60, y_offset, ecam_messages["AP"]["ON"], nil, nil, xplmFont_Basic)
    elseif autopilot_status == 0 then
        draw_status_icon(10, y_offset - 40, "AP", {1, 0, 0, 1}, "OFF") -- Icono rojo
        XPLMDrawString(60, y_offset, ecam_messages["AP"]["OFF"], nil, nil, xplmFont_Basic)
    else
        draw_status_icon(10, y_offset - 40, "AP", {1, 0.5, 0, 1}, "FAIL") -- Icono amarillo
        XPLMDrawString(60, y_offset, ecam_messages["AP"]["FAIL"], nil, nil, xplmFont_Basic)
    end
    y_offset = y_offset - 50

    -- Sensors Status
    if sensors_status == 1 then
        draw_status_icon(10, y_offset - 40, "SENS", {0, 1, 0, 1}, "ON") -- Icono verde
        XPLMDrawString(60, y_offset, ecam_messages["SENS"]["ON"], nil, nil, xplmFont_Basic)
    elseif sensors_status == 0 then
        draw_status_icon(10, y_offset - 40, "SENS", {1, 0, 0, 1}, "OFF") -- Icono rojo
        XPLMDrawString(60, y_offset, ecam_messages["SENS"]["OFF"], nil, nil, xplmFont_Basic)
    else
        draw_status_icon(10, y_offset - 40, "SENS", {1, 0.5, 0, 1}, "FAIL") -- Icono amarillo
        XPLMDrawString(60, y_offset, ecam_messages["SENS"]["FAIL"], nil, nil, xplmFont_Basic)
    end

    -- Restaurar el contexto de dibujo
    XPLMDestroyGraphicsContext(context)
end

-- Función de actualización del ECAM
XPLMRegisterFlightLoopCallback(update_ecam, 1, 0)
