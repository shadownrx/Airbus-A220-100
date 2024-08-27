--engines.lua

-- Global variables for the state of the engines

local engines = {
    { id = 0, is_on = false, thrust = 0},
    { id = 1, is_on = false, thrust = 0}
}

-- Function Starting Engines

Function start_engine(engine_id)
    if engine_id < 0 or engine_id >= #engines then
        print ("Ivalid Engine ID")
        return
    end
    engines[engine_id].is_on = true
    engines[engine_id].thrust = 0.1 -- 
    print ("Engine ".. Engine_id .." Started.")
end