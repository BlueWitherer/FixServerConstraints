if SERVER then
    -- logging
    AddCSLuaFile("autorun/print.lua")
    local FSCLogger = include("autorun/print.lua")
    local log = FSCLogger:new()
    -- convars
    AddCSLuaFile("autorun/vars.lua")
    local vars = include("autorun/vars.lua")
    -- permissions
    log:info("Creating constraint permission convar...")
    local superPerm = vars.adminperm.name
    local CVsuperPerm = CreateConVar(superPerm, vars.adminperm.default, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Restrict constraint limit modifications to superadmins only")
    SetGlobal2Bool("welds_superadminonly", GetConVar("welds_superadminonly"):GetBool())
    log:debug(CVsuperPerm:GetName(), CVsuperPerm:GetHelpText(), CVsuperPerm:GetBool(), CVsuperPerm:GetFlags())
    -- constraints
    log:info("Creating constraint limit convars...")
    local weldLimit = vars.maxwelds.name
    local ropeLimit = vars.maxropes.name
    local CVweldLimit = CreateConVar(weldLimit, vars.maxwelds.default, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum constraints limit")
    local CVropeLimit = CreateConVar(ropeLimit, vars.maxropes.default, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum rope constraints limit")
    log:debug(CVweldLimit:GetName(), CVweldLimit:GetHelpText(), CVweldLimit:GetInt(), CVweldLimit:GetFlags())
    log:debug(CVropeLimit:GetName(), CVropeLimit:GetHelpText(), CVropeLimit:GetInt(), CVropeLimit:GetFlags())
    log:print("Registered all convars")
else
    log:error("Server instance not found")
    return
end