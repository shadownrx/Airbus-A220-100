-- display.lua

-- Cargar módulos y configuración necesarios
require("config")
require("sensors")  -- Asegúrate de que `sensors.lua` esté disponible en el mismo directorio

-- Configuración de pantalla
local PFD = {
    altitude = 0,
    heading = 0,
    airspeed = 0,
    vertical_speed = 0,
    pitch = 0,
    roll = 0
}

local ND = {
    waypoints = {},
    wind_direction = 0,
    wind_speed = 0,
    current_position = {lat = 0, lon = 0}
}

local ECAM = {
    engine1_status = "OFF",
    engine2_status = "OFF",
    apu_status = "OFF",
    hydraulic_status = "NORMAL",
    electrical_status = "NORMAL",
    fuel_status = "NORMAL"
}

-- Función para actualizar el PFD
function update_PFD()
    PFD.altitude = get_altitude()
    PFD.heading = get_heading()
    PFD.airspeed = get_speed()
    PFD.vertical_speed = get_vertical_speed()
    PFD.pitch = get_pitch()
    PFD.roll = get_roll()

    -- Simulación de actualización gráfica en PFD
    print("PFD actualizado:")
    print("Altitud: " .. PFD.altitude .. " ft")
    print("Rumbo: " .. PFD.heading .. "°")
    print("Velocidad: " .. PFD.airspeed .. " knots")
    print("Velocidad Vertical: " .. PFD.vertical_speed .. " ft/min")
    print("Inclinación: " .. PFD.pitch .. "°")
    print("Alabeo: " .. PFD.roll .. "°")
end

-- Función para actualizar el ND
function update_ND()
    local wind = get_wind_info()
    ND.wind_direction = wind.direction
    ND.wind_speed = wind.speed

    -- Aquí deberías implementar la lógica para actualizar los waypoints en ND
    -- Simulación de actualización gráfica en ND
    print("ND actualizado:")
    print("Viento: " .. ND.wind_speed .. " knots desde " .. ND.wind_direction .. "°")

    -- Ejemplo de impresión de waypoints
    print("Waypoints:")
    for i, waypoint in ipairs(ND.waypoints) do
        print("Waypoint " .. i .. ": Lat " .. waypoint.lat .. ", Lon " .. waypoint.lon)
    end
end

-- Función para actualizar el ECAM
function update_ECAM()
    ECAM.engine1_status = "RUNNING"  -- Puedes ajustar según el estado real de los motores
    ECAM.engine2_status = "RUNNING"  -- Igual que arriba
    ECAM.apu_status = "ON"           -- Ajusta según el estado real del APU
    ECAM.hydraulic_status = "NORMAL" -- Puede ser "NORMAL", "LOW", "HIGH", etc.
    ECAM.electrical_status = "NORMAL" -- Similar a los otros estados
    ECAM.fuel_status = "NORMAL"      -- Ajustar según el estado real del sistema de combustible

    -- Simulación de actualización gráfica en ECAM
    print("ECAM actualizado:")
    print("Motor 1: " .. ECAM.engine1_status)
    print("Motor 2: " .. ECAM.engine2_status)
    print("APU: " .. ECAM.apu_status)
    print("Hidráulico: " .. ECAM.hydraulic_status)
    print("Eléctrico: " .. ECAM.electrical_status)
    print("Combustible: " .. ECAM.fuel_status)
end

-- Función para actualizar todos los displays
function update_displays()
    update_PFD()
    update_ND()
    update_ECAM()
end

-- Función para inicializar los displays
function initialize_displays()
    print("Inicializando displays...")
    update_displays()  -- Llamada inicial para actualizar los displays
end

-- Simulación continua de actualización de displays
function display_update_operation()
    while true do
        update_displays()
        run_after_delay(1, display_update_operation) -- Actualización cada segundo
    end
end

-- Iniciar la simulación de actualización de displays
initialize_displays()
display_update_operation()
