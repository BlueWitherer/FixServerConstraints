if SERVER then
    -- logging
    AddCSLuaFile("autorun/print.lua")
    local FSCLogger = include("autorun/print.lua")
    local log = FSCLogger:new()
    -- convars
    AddCSLuaFile("autorun/vars.lua")
    local vars = include("autorun/vars.lua")
    -- flags
    local FLAGS = FCVAR_ARCHIVE + FCVAR_REPLICATED
    -- permissions
    log:info("Creating constraint permission convar...")
    local superPerm = vars.admin.perm.name
    local CVsuperPerm = CreateConVar(superPerm, vars.admin.perm.default, FLAGS, "Restrict constraint limit modifications to superadmins only")
    SetGlobal2Bool(superPerm, CVsuperPerm:GetBool())
    log:debug(CVsuperPerm:GetName(), CVsuperPerm:GetHelpText(), CVsuperPerm:GetBool(), CVsuperPerm:GetFlags())
    -- constraints
    log:info("Creating constraint limit convars...")
    local CVweldLimit = CreateConVar(vars.welds.name, vars.welds.default, FLAGS, "Maximum constraints limit")
    local CVropeLimit = CreateConVar(vars.ropes.name, vars.ropes.default, FLAGS, "Maximum rope constraints limit")
    log:debug(CVweldLimit:GetName(), CVweldLimit:GetHelpText(), CVweldLimit:GetInt(), CVweldLimit:GetFlags())
    log:debug(CVropeLimit:GetName(), CVropeLimit:GetHelpText(), CVropeLimit:GetInt(), CVropeLimit:GetFlags())
    log:print("Registered all server convars")
else
    log:error("Server instance not found")
    return
end