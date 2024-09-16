-- config.lua

AircraftConfig = {
    aircraft_type = "Airbus A220",  -- Aircraft model
    max_altitude = 41000,           -- feet
    max_speed = 470,                -- knots
    fuel_capacity_kg = 23760,       -- Kilograms
}

EngineConfig = {
    -- TODO: Use milliseconds
    startup_time_seconds = 30,          -- seconds
    shutdown_time_seconds = 20,         -- seconds
    apu_bleed_pressure_threshold = 20,  -- PSI
    idle_n2_percentage = 60,            -- Percentage
    ready_n2_percentage = 80,           -- Percentage
    fuel_pump_required = true,          
}

-- Electrical configuration
ElectricalConfig = {
    battery_voltage_required = 24,       -- volts
    -- TODO: Use milliseconds
    startup_sequence_delay = 5,          -- seconds
    screen_startup_time = 10,            -- seconds
    ecam_boot_message = "ECAM booting...", 
}

-- Hydraulics configuration
HydraulicConfig = {
    -- TODO: Use milliseconds
    pump_startup_time = 5,                      -- seconds
    low_pressure_warning_threshold = 1000,      -- TODO: specify unit
    high_pressure_shutdown_threshold = 3000,    -- TODO: specify unit
    required_pumps_on_for_operation = 3, 
}

-- Auto pilot configuration
AutopilotConfig = {
    disconnect_on_error = true,          
    -- TODO: Use milliseconds
    wind_data_update_interval = 5,       -- seconds
    ils_switch_required = true,          
}

-- Sensor configuration
SensorConfig = {
    ice_detection_enabled = true,        
    -- TODO: Use milliseconds
    cross_validation_interval = 2,       -- seconds
    noise_threshold = 0.5,               -- percentage double (0 to 1)
    fail_safe_mode = true,               
}

-- Displays configuration
DisplayConfig = {
    -- TODO: Use milliseconds
    pfd_update_interval = 0.1,           -- seconds
    nd_update_interval = 0.1,            -- seconds
    ecam_update_interval = 0.1,          -- seconds
    nd_show_wind = true,                 
    nd_show_waypoint_distance = true,    
}
