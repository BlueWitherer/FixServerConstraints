if CLIENT then
    -- logging
    local FSCLogger = include("autorun/print.lua")
    local log = FSCLogger:new()
    -- convars
    local vars = include("autorun/vars.lua")
    -- settings
    log:info("Creating client settings convars...")
    local CVshowNotifs = CreateClientConVar(vars.client.notify.name, vars.client.notify.default, true, false, "Enable FSC client notifications", 0, 1)
    log:debug(CVshowNotifs:GetName(), CVshowNotifs:GetHelpText(), CVshowNotifs:GetBool(), CVshowNotifs:GetFlags())
    local CVhostHidePanel = CreateClientConVar(vars.client.hosthidepanel.name, vars.client.hosthidepanel.default, true, false, "Hide manual update button in constraints menu if not locally hosting server", 0, 1)
    log:debug(CVhostHidePanel:GetName(), CVhostHidePanel:GetHelpText(), CVhostHidePanel:GetBool(), CVhostHidePanel:GetFlags())
    log:print("Registered all client convars")
else
    log:error("Client instance not found")
    return
end