if SERVER then
    -- logging
    AddCSLuaFile("autorun/print.lua")
    local FSCLogger = include("autorun/print.lua")
    local log = FSCLogger:new()
    -- convars
    AddCSLuaFile("autorun/vars.lua")
    local vars = include("autorun/vars.lua")
    -- constraints
    log:info("Creating constraint limit convars...")
    local weldLimit = vars.maxwelds.name
    local ropeLimit = vars.maxropes.name
    CreateConVar(weldLimit, 2000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum constraints limit")
    CreateConVar(ropeLimit, 1000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum rope constraints limit")
    local CVweldLimit = GetConVar(weldLimit)
    local CVropeLimit = GetConVar(ropeLimit)
    log:debug(CVweldLimit:GetName(), CVweldLimit:GetHelpText(), CVweldLimit:GetInt(), CVweldLimit:GetFlags())
    log:debug(CVropeLimit:GetName(), CVropeLimit:GetHelpText(), CVropeLimit:GetInt(), CVropeLimit:GetFlags())
    -- permissions
    log:info("Creating constraint permission convar...")
    local superPerm = vars.adminperm.name
    CreateConVar(superPerm, 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Restrict constraint limit modifications to superadmins only")
    local CVsuperPerm = GetConVar(superPerm)
    log:debug(CVsuperPerm:GetName(), CVsuperPerm:GetHelpText(), CVsuperPerm:GetBool(), CVsuperPerm:GetFlags())
    -- testing
    log:debug("Creating debug convar...")
    CreateConVar("test_cheeseworks", 65, FCVAR_ARCHIVE, "Cheeseworks test convar")
    log:log("Created all convars for constraint limit addon!")
else
    log:error("Server instance not found")
    return
end