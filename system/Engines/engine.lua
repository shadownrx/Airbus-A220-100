-- engines.lua para el sistema de motores del Airbus A220

-- DataRefs para motores
local engine1_start_switch = XPLMFindDataRef("sim/cockpit2/engines/engine1_start_switch")
local engine2_start_switch = XPLMFindDataRef("sim/cockpit2/engines/engine2_start_switch")
local engine1_thrust_dataref = XPLMFindDataRef("sim/cockpit2/engines/engine1_thrust")
local engine2_thrust_dataref = XPLMFindDataRef("sim/cockpit2/engines/engine2_thrust")

-- DataRef para APU Bleed Pressure
local apu_bleed_pressure_dataref = XPLMFindDataRef("sim/cockpit2/engine/apu_bleed_pressure")

-- DataRef para el paso de combustible
local fuel_flow_switch_1 = XPLMFindDataRef("sim/cockpit2/fuel/fuel_flow_1")
local fuel_flow_switch_2 = XPLMFindDataRef("sim/cockpit2/fuel/fuel_flow_2")

-- DataRefs para los switches de encendido
local start_engine_1_switch = XPLMFindDataRef("sim/cockpit2/engines/start_engine_1_switch")
local start_engine_2_switch = XPLMFindDataRef("sim/cockpit2/engines/start_engine_2_switch")

-- Datos de tiempo
local start_time = 40  -- Tiempo total de encendido del motor en segundos
local engine_start_delay = 10  -- Tiempo de retraso antes de iniciar el encendido del motor

-- Variables para el seguimiento del tiempo
local engine1_start_time = -1
local engine2_start_time = -1

-- Función para simular el encendido del motor
function simulate_engine_start()
    local current_time = os.clock()
    
    -- Obtener el estado del APU Bleed Pressure
    local apu_bleed_pressure = XPLMGetDataf(apu_bleed_pressure_dataref)
    
    -- Obtener el estado del paso de combustible
    local fuel_flow_1 = XPLMGetDatai(fuel_flow_switch_1)
    local fuel_flow_2 = XPLMGetDatai(fuel_flow_switch_2)
    
    -- Obtener el estado de los interruptores de encendido de motores
    local start_engine_1_state = XPLMGetDatai(start_engine_1_switch)
    local start_engine_2_state = XPLMGetDatai(start_engine_2_switch)
    
    -- Verificar que la presión del APU Bleed sea suficiente (30 psi para el A220)
    if apu_bleed_pressure < 30 then
        -- Si la presión es insuficiente, no permitir el encendido de los motores
        XPLMSetDataf(engine1_thrust_dataref, 0)
        XPLMSetDataf(engine2_thrust_dataref, 0)
        return
    end

    -- Iniciar el temporizador de encendido si se ha activado el interruptor de encendido del motor
    if start_engine_1_state == 1 and engine1_start_time == -1 then
        if fuel_flow_1 == 1 then
            engine1_start_time = current_time
        else
            -- Si el flujo de combustible no está activado, no iniciar el motor
            XPLMSetDataf(engine1_thrust_dataref, 0)
            return
        end
    end

    if start_engine_2_state == 1 and engine2_start_time == -1 then
        if fuel_flow_2 == 1 then
            engine2_start_time = current_time
        else
            -- Si el flujo de combustible no está activado, no iniciar el motor
            XPLMSetDataf(engine2_thrust_dataref, 0)
            return
        end
    end

    -- Simulación del encendido del motor 1
    if start_engine_1_state == 1 then
        local elapsed_time = current_time - engine1_start_time
        if elapsed_time >= engine_start_delay then
            local thrust = math.min((elapsed_time - engine_start_delay) / (start_time - engine_start_delay) * 100, 100)
            XPLMSetDataf(engine1_thrust_dataref, thrust)
        end
    else
        -- Restablecer el tiempo de inicio si el interruptor de encendido del motor se apaga
        engine1_start_time = -1
        XPLMSetDataf(engine1_thrust_dataref, 0)
    end

    -- Simulación del encendido del motor 2
    if start_engine_2_state == 1 then
        local elapsed_time = current_time - engine2_start_time
        if elapsed_time >= engine_start_delay then
            local thrust = math.min((elapsed_time - engine_start_delay) / (start_time - engine_start_delay) * 100, 100)
            XPLMSetDataf(engine2_thrust_dataref, thrust)
        end
    else
        -- Restablecer el tiempo de inicio si el interruptor de encendido del motor se apaga
        engine2_start_time = -1
        XPLMSetDataf(engine2_thrust_dataref, 0)
    end
end

-- Función de actualización del motor
XPLMRegisterFlightLoopCallback(simulate_engine_start, 1, 0)
