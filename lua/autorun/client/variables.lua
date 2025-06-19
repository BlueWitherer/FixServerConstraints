if CLIENT then
    -- logging
    local FSCLogger = include("autorun/print.lua")
    local log = FSCLogger:new()
    -- convars
    AddCSLuaFile("autorun/vars.lua")
    local vars = include("autorun/vars.lua")
    -- settings
    log:info("Creating client settings convars...")
    local showNotifs = vars.client.notifs.name
    local CVshowNotifs = CreateClientConVar(showNotifs, "1", true, false, "Enable FixServerConstraints notifications")
    log:debug(CVshowNotifs:GetName(), CVshowNotifs:GetHelpText(), CVshowNotifs:GetBool(), CVshowNotifs:GetFlags())
    log:print("Registered all client convars")
else
    log:error("Client instance not found")
    return
end