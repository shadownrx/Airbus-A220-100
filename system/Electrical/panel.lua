-- panel.lua

local panel = {
    is_on = false
}

local panel_power_dataref = XPLMFindDataRef("aircraft/panel/power") -- DataRef para el encendido del panel
local ecam_message_dataref = XPLMFindDataRef("aircraft/ecam/message") -- DataRef para mensajes ECAM

local function update_ecam_message(message)
    XPLMSetDatai(ecam_message_dataref, message)
end

function power_on_panel()
    if not panel.is_on then
        update_ecam_message("Powering on the panel...")
        panel.is_on = true
        XPLMSetDatai(panel_power_dataref, 1)
        update_ecam_message("Panel Powered on.")
    else
        update_ecam_message("Panel is already on.")
    end
end

function power_off_panel()
    if panel.is_on then
        update_ecam_message("Powering off the panel...")
        panel.is_on = false
        XPLMSetDatai(panel_power_dataref, 0)
        update_ecam_message("Panel powered off.")
    else
        update_ecam_message("Panel is already off")
    end
end