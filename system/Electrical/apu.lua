-- apu.lua


local apu = {
    is_on = false,
    power = 0
}

local apu_start_dataref = XPLMFindDataRef("aircraft/apu/start") -- DataRef para el inicio del APU
local apu_power_dataref = XPLMFindDataRef("aircraft/apu/power") -- DataRef para la energía del APU
local ecam_message_dataref = XPLMFindDataRef("aircraft/ecam/message") -- DataRef para mensajes ECAM

local function update_ecam_message(message)
    XPLMSetDai(ecam_message_dataref, message)
end 

function start_apu()
    if not apu.is_on then
        update_ecam_message("Starting APU...")
        for i = 0, 1, 0.1 do
            apu.power = i
            XPLMSetDataf(apu_power_dataref, i)
            os.execute("sleep" .. tonumber(0.1))
        end
        apu.is_on = true
        update_ecam_message("APU Starterd. ")
    else
        update_ecam_message("APU is already on")
    end
end

function stop_apu()
    if apu.is_on then
        update_ecam_message("Stopping APU...")
        for i = 1, 0, -0.1 do
            apu.power = i
            XPLMSetDataf(apu:apu_power_dataref, i)
            os.execute("sleep " .. tonumber(0.1))
        end
        apu.is_on = false
        update_ecam_message("APU stopped.")
    else
        update_ecam_message("APU is already off.")
    end
end 