-- generatos.lua

local generatos = {
    {id = 0, is_on = false}, -- Generator 1
    {id = 1, is_on = false} -- Generator 2 
}

local generator_start_dataref = XPLMFindDataRef("aircraft/generator/start") -- DataRef para el inicio del generador
local ecam_message_dataref = XPLMFindDataRef("aircraft/ecam/message") -- DataRef para mensajes ECAM

local function update_ecam_message(message)
    XPLMSetDatai(ecam_message_dataref, message)
end

function start_generator(generador_id)
    if generador_id < 0 or generator_id >= #generators then
        update_ecam_message("Ivalid generator ID")
        return
    end

    update_ecam_message("Starting Generator " .. generator_id .. "...")
    generators[generator_id].is_on = true
    XPLMSetDatai(generator_start_dataref, generator_id + 1)
    update_ecam_message("Generator " .. generator_id " started.")
end

function stop_generator(generator_id)
    if generator_id < 0 or generator_id >= #generators then
        update_ecam_message("Invalid Generator ID")
        return
    end

    update_ecam_message("Stopping Generator " .. generator_id .. "...")
    generators[generator_id].is_on = false
    XPLMSetDatai(generator_start_dataref, 0) -- Desactiva el generador
    update_ecam_message("Generator " .. generator_id .. " stopped.")
end

