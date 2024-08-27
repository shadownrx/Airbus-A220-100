-- nd.lua para el Navigation Display (ND) del Airbus A220

-- DataRefs para información de navegación y viento
local aircraft_pos_dataref = XPLMFindDataRef("sim/flightmodel/position/latitude")
local aircraft_lon_dataref = XPLMFindDataRef("sim/flightmodel/position/longitude")
local waypoint_dataref = XPLMFindDataRef("sim/cockpit2/fms/waypoints")
local fms_route_dataref = XPLMFindDataRef("sim/cockpit2/fms/route")
local wind_dir_dataref = XPLMFindDataRef("sim/weather/wind_direction_degt")
local wind_speed_dataref = XPLMFindDataRef("sim/weather/wind_speed_kt")

-- Variables para interactividad
local view_mode = 0  -- 0: Ruta, 1: Waypoints
local map_scale = 1  -- 1: Normal, 2: Zoomed

-- Definir áreas interactivas
local button_rects = {
    { x1 = 10, y1 = 10, x2 = 60, y2 = 40, mode = 0 },  -- Botón para modo Ruta
    { x1 = 70, y1 = 10, x2 = 120, y2 = 40, mode = 1 },  -- Botón para modo Waypoints
    { x1 = 130, y1 = 10, x2 = 180, y2 = 40, scale = 2 }, -- Botón para zoom
    { x1 = 190, y1 = 10, x2 = 240, y2 = 40, scale = 1 }  -- Botón para escala normal
}

-- Función para calcular la distancia entre dos coordenadas geográficas
function calculate_distance(lat1, lon1, lat2, lon2)
    local function deg_to_rad(deg)
        return deg * math.pi / 180
    end

    local R = 6371  -- Radio de la Tierra en km
    local dlat = deg_to_rad(lat2 - lat1)
    local dlon = deg_to_rad(lon2 - lon1)
    local a = math.sin(dlat / 2) * math.sin(dlat / 2) +
              math.cos(deg_to_rad(lat1)) * math.cos(deg_to_rad(lat2)) *
              math.sin(dlon / 2) * math.sin(dlon / 2)
    local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c  -- Distancia en km
end

-- Función para obtener la información del próximo waypoint
function get_next_waypoint_distance()
    local aircraft_lat = XPLMGetDataf(aircraft_pos_dataref)
    local aircraft_lon = XPLMGetDataf(aircraft_lon_dataref)
    local waypoints = XPLMGetDataf(waypoint_dataref)
    local next_waypoint_lat, next_waypoint_lon = waypoints[1].latitude, waypoints[1].longitude

    -- Calcular distancia al siguiente waypoint
    return calculate_distance(aircraft_lat, aircraft_lon, next_waypoint_lat, next_waypoint_lon)
end

-- Función para obtener la información del viento
function get_wind_info()
    local wind_dir = XPLMGetDataf(wind_dir_dataref)
    local wind_speed = XPLMGetDataf(wind_speed_dataref)
    return wind_dir, wind_speed
end

-- Función para actualizar el ND
function update_nd()
    local route = XPLMGetDataf(fms_route_dataref)
    local distance_to_waypoint = get_next_waypoint_distance()
    local wind_dir, wind_speed = get_wind_info()

    -- Obtener el tamaño de la ventana de dibujo
    local w, h = XPLMGetScreenSize()

    -- Crear un nuevo contexto de dibujo
    local context = XPLMCreateGraphicsContext()

    -- Dibujar el ND basado en el modo actual y la escala
    XPLMSetGraphicsContext(context)
    if view_mode == 0 then
        -- Modo Ruta
        XPLMSetColor(0, 1, 0, 1)  -- Color verde para la ruta
        XPLMDrawRectangle(0, 0, w, h, xplmColor_White)  -- Mapa de fondo

        -- Dibujar la ruta con líneas (simple representación)
        XPLMSetColor(0, 0, 1, 1)  -- Color azul para la ruta
        XPLMDrawLine(0, h / 2, w, h / 2)  -- Línea horizontal central
        XPLMDrawLine(w / 2, 0, w / 2, h)  -- Línea vertical central

        -- Dibujar waypoints
        for i, waypoint in ipairs(XPLMGetDataf(waypoint_dataref)) do
            local waypoint_lat, waypoint_lon = waypoint.latitude, waypoint.longitude
            -- Convertir coordenadas geográficas a coordenadas de pantalla (simplificado)
            local x = w / 2 + (waypoint_lon - XPLMGetDataf(aircraft_lon_dataref)) * 10
            local y = h / 2 - (waypoint_lat - XPLMGetDataf(aircraft_pos_dataref)) * 10
            XPLMSetColor(1, 0, 0, 1)  -- Color rojo para los waypoints
            XPLMDrawCircle(x, y, 5)  -- Dibujar círculo en el waypoint
        end
    else
        -- Modo Waypoints
        XPLMSetColor(0, 0, 1, 1)  -- Color azul para waypoints
        XPLMDrawRectangle(0, 0, w, h, xplmColor_White)  -- Mapa de fondo

        -- Dibujar waypoints
        for i, waypoint in ipairs(XPLMGetDataf(waypoint_dataref)) do
            local waypoint_lat, waypoint_lon = waypoint.latitude, waypoint.longitude
            -- Convertir coordenadas geográficas a coordenadas de pantalla (simplificado)
            local x = w / 2 + (waypoint_lon - XPLMGetDataf(aircraft_lon_dataref)) * 10
            local y = h / 2 - (waypoint_lat - XPLMGetDataf(aircraft_pos_dataref)) * 10
            XPLMSetColor(1, 0, 0, 1)  -- Color rojo para los waypoints
            XPLMDrawCircle(x, y, 5)  -- Dibujar círculo en el waypoint
        end
    end

    -- Mostrar la distancia al próximo waypoint
    XPLMSetColor(1, 0, 0, 1)  -- Color rojo para la distancia
    XPLMDrawString(10, h - 60, string.format("DISTANCE TO NEXT WP: %.1f km", distance_to_waypoint), nil, nil, xplmFont_Basic)

    -- Mostrar la información del viento
    local wind_dir_radians = wind_dir * math.pi / 180
    local wind_x = math.cos(wind_dir_radians) * wind_speed
    local wind_y = math.sin(wind_dir_radians) * wind_speed
    XPLMSetColor(0, 0, 0, 1)  -- Color negro para el viento
    XPLMDrawString(10, h - 90, string.format("WIND: %.1f° @ %.1f kt", wind_dir, wind_speed), nil, nil, xplmFont_Basic)
    XPLMDrawLine(w / 2, h / 2, w / 2 + wind_x, h / 2 - wind_y)  -- Representación gráfica de la dirección del viento

    -- Ajustar escala
    if map_scale == 2 then
        XPLMDrawString(10, h - 120, "ZOOMED VIEW", nil, nil, xplmFont_Basic)
    end

    -- Dibujar botones
    XPLMSetColor(0.5, 0.5, 0.5, 1)  -- Color gris para los botones
    for _, btn in ipairs(button_rects) do
        if btn.mode then
            XPLMDrawRectangle(btn.x1, h - btn.y2, btn.x2, h - btn.y1, xplmColor_Gray)
            XPLMDrawString(btn.x1 + 5, h - btn.y1 + 15, view_mode == btn.mode and "ON" or "OFF", nil, nil, xplmFont_Basic)
        else
            XPLMDrawRectangle(btn.x1, h - btn.y2, btn.x2, h - btn.y1, xplmColor_Gray)
            XPLMDrawString(btn.x1 + 5, h - btn.y1 + 15, map_scale == btn.scale and "ZOOMED" or "NORMAL", nil, nil, xplmFont_Basic)
        end
    end

    -- Restaurar el contexto de dibujo
    XPLMDestroyGraphicsContext(context)
end

-- Función para manejar los clics en el ND
function handle_nd_click(x, y)
    for _, btn in ipairs(button_rects) do
        if x >= btn.x1 and x <= btn.x2 and y >= btn.y1 and y <= btn.y2 then
            if btn.mode then
                view_mode = btn.mode
            elseif btn.scale then
                map_scale = btn.scale
            end
            update_nd()
            return
        end
    end
end

-- Registrar la función de actualización
XPLMRegisterFlightLoopCallback(update_nd, 1, 0)

-- Registrar la función de clic
function on_nd_click(x, y)
    handle_nd_click(x, y)
end

-- Registrar la función de clic en la pantalla
XPLMRegisterDrawCallback(on_nd_click, xplm_Phase_Map, 0)

