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
    local superPerm = vars.admin.perm.name
    local CVsuperPerm = CreateConVar(superPerm, vars.admin.perm.default, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Restrict constraint limit modifications to superadmins only")
    SetGlobal2Bool(vars.admin.perm.name, GetConVar(vars.admin.perm.name):GetBool())
    log:debug(CVsuperPerm:GetName(), CVsuperPerm:GetHelpText(), CVsuperPerm:GetBool(), CVsuperPerm:GetFlags())
    -- constraints
    log:info("Creating constraint limit convars...")
    local weldLimit = vars.welds.name
    local ropeLimit = vars.ropes.name
    local CVweldLimit = CreateConVar(weldLimit, vars.welds.default, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum constraints limit")
    local CVropeLimit = CreateConVar(ropeLimit, vars.ropes.default, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum rope constraints limit")
    log:debug(CVweldLimit:GetName(), CVweldLimit:GetHelpText(), CVweldLimit:GetInt(), CVweldLimit:GetFlags())
    log:debug(CVropeLimit:GetName(), CVropeLimit:GetHelpText(), CVropeLimit:GetInt(), CVropeLimit:GetFlags())
    log:print("Registered all server convars")
else
    log:error("Server instance not found")
    return
end