-- nd_display.lua

require("config")
require("datarefs")  

local ND = {
    waypoints = {},
    wind_direction = 0,
    wind_speed = 0
}

function initialize_ND()
    print("Initializing ND...")
end

function update_ND()
    local data = read_datarefs()

    ND.wind_direction = data.wind_direction
    ND.wind_speed = data.wind_speed

    ND.waypoints = get_waypoints_from_fms() -- TODO: implement according to FMS

    update_nd_graphics()
end

function get_waypoints_from_fms()
    -- TODO: integrate with FMS
    return {
        { name = "WP1", lat = 34.0, lon = -118.0 },
        { name = "WP2", lat = 35.0, lon = -119.0 },
        { name = "WP3", lat = 36.0, lon = -120.0 }
    }
end

function update_nd_graphics()
    print("Update ND graphics:")
    print("Wind direction: " .. ND.wind_direction .. "°")
    print("Wind speec: " .. ND.wind_speed .. " knots")
    print("Waypoints:")
    for i, waypoint in ipairs(ND.waypoints) do
        print("Name: " .. waypoint.name .. ", Latitude: " .. waypoint.lat .. ", Longitude: " .. waypoint.lon)
    end
end

function nd_update_operation()
    initialize_ND()
    while true do
        update_ND()
        run_after_delay(1, nd_update_operation) -- TODO: use SASL lifecycle
    end
end

nd_update_operation()
