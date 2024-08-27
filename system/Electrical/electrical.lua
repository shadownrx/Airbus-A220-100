-- electrical.lua

local batteries = {
    { id = 0, is_on = false, power = 0 }, -- Batería 1
    { id = 1, is_on = false, power = 0 }  -- Batería 2
}

local displays = {
    { id = 0, is_on = false }, -- PFD
    { id = 1, is_on = false }  -- ND
}

local apu = require("apu")
local generators = require("generators")
local panel = require("panel")

local ecam_message_dataref = XPLMFindDataRef("aircraft/ecam/message") -- DataRef para mensajes ECAM

-- Función para actualizar el mensaje del ECAM
local function update_ecam_message(message)
    XPLMSetDatai(ecam_message_dataref, message)
end

function start_battery(battery_id)
    if battery_id < 0 or battery_id >= #batteries then
        update_ecam_message("Invalid battery ID")
        return
    end
    
    batteries[battery_id].power = 0
    update_ecam_message("Starting Battery " .. battery_id .. "...")
    for i = 0, 1, 0.1 do
        batteries[battery_id].power = i
        os.execute("sleep " .. tonumber(0.1))
    end
    batteries[battery_id].is_on = true
    update_ecam_message("Battery " .. battery_id .. " started.")
    
    -- Inicia el APU si no está encendido
    if not apu.is_on then
        apu.start_apu()
    end

    -- Si ambas baterías están encendidas, iniciar los displays
    if batteries[0].is_on and batteries[1].is_on then
        start_displays()
    end
end

function stop_battery(battery_id)
    if battery_id < 0 or battery_id >= #batteries then
        update_ecam_message("Invalid battery ID")
        return
    end
    
    batteries[battery_id].power = 0
    update_ecam_message("Stopping Battery " .. battery_id .. "...")
    for i = 1, 0, -0.1 do
        batteries[battery_id].power = i
        os.execute("sleep " .. tonumber(0.1))
    end
    batteries[battery_id].is_on = false
    update_ecam_message("Battery " .. battery_id .. " stopped.")
    
    -- Si alguna batería se apaga, apagar los displays
    if not batteries[0].is_on or not batteries[1].is_on then
        stop_displays()
        -- Apaga el APU si todas las baterías están apagadas
        if not batteries[0].is_on and not batteries[1].is_on then
            apu.stop_apu()
        end
    end
end

function start_displays()
    for _, display in ipairs(displays) do
        display.is_on = true
    end
    update_ecam_message("Displays started.")
    update_displays(true)
end

function stop_displays()
    for _, display in ipairs(displays) do
        display.is_on = false
    end
    update_ecam_message("Displays stopped.")
    update_displays(false)
end

function update_displays(status)
    if pfd_dataref then
        XPLMSetDatai(pfd_dataref, status and 1 or 0)
    end
    if nd_dataref then
        XPLMSetDatai(nd_dataref, status and 1 or 0)
    end
end
