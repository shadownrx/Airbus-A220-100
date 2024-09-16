-- pfd_display.lua

require("config")
require("datarefs") 

-- TODO: use variables instead of table
local PFD = {
    altitude = 0,
    heading = 0,
    airspeed = 0,
    vertical_speed = 0,
    pitch = 0,
    roll = 0
}

function initialize_PFD()
    print("Initializing PFD...")
end

function update_PFD()
    local data = read_datarefs()
    
    PFD.altitude = data.altitude
    PFD.heading = data.heading
    PFD.airspeed = data.speed
    PFD.vertical_speed = data.vertical_speed
    PFD.pitch = data.pitch
    PFD.roll = data.roll
    
    update_pfd_graphics()
end

function update_pfd_graphics()
    print("Updating PFD graphics:")
    print("Altitude: " .. PFD.altitude .. " ft")
    print("Heading: " .. PFD.heading .. "°")
    print("Speed: " .. PFD.airspeed .. " knots")
    print("Vertical speed: " .. PFD.vertical_speed .. " ft/min")
    print("Pitch: " .. PFD.pitch .. "°")
    print("Bank: " .. PFD.roll .. "°")
end

function pfd_update_operation()
    initialize_PFD()
    while true do
        update_PFD()
        run_after_delay(1, pfd_update_operation) -- TODO: use SASL lifecycle
    end
end

pfd_update_operation()
