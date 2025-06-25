if CLIENT then
    -- logging
    local FSCLogger = include("autorun/print.lua")
    local log = FSCLogger:new()
    -- convars
    local vars = include("autorun/vars.lua")
    -- settings
    log:info("Creating client settings convars...")
    local CVshowNotifs = CreateClientConVar(vars.client.notifs.name, vars.client.notifs.default, true, false, "Enable FixServerConstraints client notifications", 0, 1)
    log:debug(CVshowNotifs:GetName(), CVshowNotifs:GetHelpText(), CVshowNotifs:GetBool(), CVshowNotifs:GetFlags())
    log:print("Registered all client convars")
else
    log:error("Client instance not found")
    return
end