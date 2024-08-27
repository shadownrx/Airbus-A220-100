-- pfd.lua para el Primary Flight Display (PFD) del Airbus A220

-- DataRefs para información del vuelo
local attitude_dataref = XPLMFindDataRef("sim/cockpit2/gauges/indicators/attitude_pilot")
local airspeed_dataref = XPLMFindDataRef("sim/cockpit2/gauges/indicators/airspeed_pilot")
local altitude_dataref = XPLMFindDataRef("sim/cockpit2/gauges/indicators/altitude_pilot")
local heading_dataref = XPLMFindDataRef("sim/cockpit2/gauges/indicators/heading_pilot")
local vertical_speed_dataref = XPLMFindDataRef("sim/cockpit2/gauges/indicators/vertical_speed_pilot")

-- DataRef para mostrar mensajes del ECAM
local ecam_message_dataref = XPLMFindDataRef("aircraft/ecam/message")

-- Variables para interactividad
local display_mode = 0  -- 0: Normal, 1: Alternate

-- Función para actualizar el PFD
function update_pfd()
    local attitude = XPLMGetDataf(attitude_dataref)
    local airspeed = XPLMGetDataf(airspeed_dataref)
    local altitude = XPLMGetDataf(altitude_dataref)
    local heading = XPLMGetDataf(heading_dataref)
    local vertical_speed = XPLMGetDataf(vertical_speed_dataref)
    
    -- Crear un nuevo contexto de dibujo
    local context = XPLMCreateGraphicsContext()
    
    -- Obtener el tamaño de la ventana de dibujo
    local w, h = XPLMGetScreenSize()
    
    -- Dibujar el PFD basado en el modo actual
    XPLMSetGraphicsContext(context)
    if display_mode == 0 then
        -- Modo Normal
        XPLMSetColor(0, 0, 1, 1)  -- Color azul para el horizonte
        XPLMDrawLine(0, h/2, w, h/2)  -- Línea del horizonte
        
        -- Dibujar actitud
        XPLMSetColor(1, 1, 1, 1)  -- Color blanco para la actitud
        XPLMDrawString(10, h - 30, string.format("ATTITUDE: %.1f°", attitude), nil, nil, xplmFont_Basic)
        
        -- Dibujar velocidad, altitud, y otros datos
        XPLMDrawString(10, h - 60, string.format("SPEED: %.1f kts", airspeed), nil, nil, xplmFont_Basic)
        XPLMDrawString(10, h - 90, string.format("ALTITUDE: %.0f ft", altitude), nil, nil, xplmFont_Basic)
        XPLMDrawString(10, h - 120, string.format("HEADING: %.0f°", heading), nil, nil, xplmFont_Basic)
        XPLMDrawString(10, h - 150, string.format("VS: %.0f ft/min", vertical_speed), nil, nil, xplmFont_Basic)
    else
        -- Modo Alternativo
        XPLMSetColor(1, 0, 0, 1)  -- Color rojo para el modo alternativo
        XPLMDrawString(10, h - 30, "ALTERNATE MODE", nil, nil, xplmFont_Basic)
        -- Puedes agregar gráficos adicionales aquí
    end
    
    -- Restaurar el contexto gráfico
    XPLMRestoreGraphicsContext()
end

-- Función para manejar la interacción del usuario
function on_mouse_click(x, y)
    -- Comprobar si el clic está dentro de un área específica del PFD
    if x > 50 and x < 150 and y > 50 and y < 100 then
        display_mode = (display_mode + 1) % 2  -- Alternar entre modo 0 y 1
    end
end

-- Configurar la actualización continua del PFD
do_often("update_pfd()")

-- Configurar el manejador de clics del ratón
XPLMRegisterMouseClickHandler(on_mouse_click)
