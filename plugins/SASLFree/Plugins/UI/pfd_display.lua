-- pfd_display.lua

-- Requiere módulos y configuración necesarios
require("config")
require("datarefs")  -- Asegúrate de que `datarefs.lua` esté disponible en el mismo directorio

-- Configuración de la pantalla PFD
local PFD = {
    altitude = 0,
    heading = 0,
    airspeed = 0,
    vertical_speed = 0,
    pitch = 0,
    roll = 0
}

-- Inicializar el display PFD
function initialize_PFD()
    print("Inicializando PFD...")
    -- Aquí puedes configurar la interfaz gráfica del PFD
end

-- Función para actualizar el PFD
function update_PFD()
    -- Leer datos desde el simulador
    local data = read_datarefs()
    
    -- Actualizar valores del PFD
    PFD.altitude = data.altitude
    PFD.heading = data.heading
    PFD.airspeed = data.speed
    PFD.vertical_speed = data.vertical_speed
    PFD.pitch = data.pitch
    PFD.roll = data.roll
    
    -- Actualizar la interfaz gráfica del PFD
    update_pfd_graphics()
end

-- Función para actualizar la interfaz gráfica del PFD
function update_pfd_graphics()
    -- Actualización de gráficos y elementos del PFD
    -- Ejemplo de simulación de actualización gráfica
    -- Puedes usar funciones gráficas del SDK de X-Plane para renderizar
    print("Actualizando gráficos del PFD:")
    print("Altitud: " .. PFD.altitude .. " ft")
    print("Rumbo: " .. PFD.heading .. "°")
    print("Velocidad: " .. PFD.airspeed .. " knots")
    print("Velocidad Vertical: " .. PFD.vertical_speed .. " ft/min")
    print("Inclinación: " .. PFD.pitch .. "°")
    print("Alabeo: " .. PFD.roll .. "°")
end

-- Función para inicializar y actualizar el PFD periódicamente
function pfd_update_operation()
    initialize_PFD()
    while true do
        update_PFD()
        run_after_delay(1, pfd_update_operation) -- Actualización cada segundo
    end
end

-- Iniciar la actualización del PFD
pfd_update_operation()
