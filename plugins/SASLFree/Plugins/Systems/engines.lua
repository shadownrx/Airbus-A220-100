local simDR_engine1_N2 = find_dataref("sim/flightmodel/engine/ENGN_N2_[0]")  -- N2 para el motor 1
local simDR_engine2_N2 = find_dataref("sim/flightmodel/engine/ENGN_N2_[1]")  -- N2 para el motor 2
local simDR_fuel_flow = find_dataref("sim/flightmodel/engine/ENGN_FF_[0]")   -- Flujo de combustible motor 1
local simDR_fuel_flow2 = find_dataref("sim/flightmodel/engine/ENGN_FF_[1]")  -- Flujo de combustible motor 2
local simDR_apu_bleed_psi = find_dataref("sim/cockpit2/pressurization/actuators/bleed_air_apu") -- Presión del bleed del APU
local simDR_fuel_pump = find_dataref("sim/cockpit2/fuel/fuel_tank_selector")
local simDR_start_switch_1 = find_dataref("sim/cockpit2/engine/actuators/ignition_key[0]") -- Switch de encendido motor 1
local simDR_start_switch_2 = find_dataref("sim/cockpit2/engine/actuators/ignition_key[1]") -- Switch de encendido motor 2

local simDR_engine1_EGT = find_dataref("sim/cockpit2/engine/indicators/EGT_deg_C[0]") -- EGT motor 1
local simDR_engine2_EGT = find_dataref("sim/cockpit2/engine/indicators/EGT_deg_C[1]") -- EGT motor 2



local engine1_started = false 
local engine2_started = false 


local function start_engine(engine_motor)
    local n2 = engine_number == 1 and simDR_engine1_N2 or simDR_engine2_N2
    local fuel_flow = engine_number == 1 and simDR_fuel_flow or simDR_fuel_flow2
    local start_switch = engine_number == 1 and simDR_start_switch_1 or simDR_start_switch_2


    if simDR_apu_bleed_psi < 20 then
        return "Insufficient APU bleed pressure"
    end


    if simDR_fuel_pum ~= 1 then
        return "Fuel pump is off"
    end


    if start_switch == 1 and n2 > 20 then
        fuel_flow = 1 
        return "Engine " .. engine_number .. " starting..."
    else
        return "Start Switch not in position or N2 below threshold"
    end
end



local function update_engine()
    if not engine1_started then
        local status = start_engine(1)
        if status = "Engine 1 starting..." then
            engine1_started = true
        end
        ecam_menssage(status)
    end

    if engine1_started and simDR_engine1_N2 > 60 and not engine1_ready then
        engine1_ready = true
        ecam_message("Engine 1 READY")
    end
end


local function update_engine2()
    if not engine2_started then
        local status = start_engine(2)
        if status == "Engine 2 starting..." then
            engine2_started = true
        end

        ecam_message(status)
    end

 
    if engine2_started and simDR_engine2_N2 > 60 and not engine2_ready then
        engine2_ready = true
        ecam_message("Engine 2 READY")
    end
end

function update_engines()
    update_engine1()
    update_engine2()


    local engine1_egt = simDR_engine1_EGT
    local engine2_egt = simDR_engine2_EGT


    ecam_message("Engine 1 EGT: " .. engine1_egt)
    ecam_message("Engine 2 EGT: " .. engine2_egt)
end

do_every_frame("update_engines()")
    