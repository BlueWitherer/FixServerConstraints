if SERVER then
    AddCSLuaFile("autorun/print.lua")
    include("autorun/print.lua")
    local log = FscPrint
    -- constraints
    log.info("Creating constraint limit convars...")
    local weldLimit = "sbox_maxconstraints"
    local ropeLimit = "sbox_maxropeconstraints"
    CreateConVar(weldLimit, 2000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum constraints limit")
    CreateConVar(ropeLimit, 1000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum rope constraints limit")
    local CVweldLimit = GetConVar(weldLimit)
    local CVropeLimit = GetConVar(ropeLimit)
    log.debug(CVweldLimit:GetBool(), CVweldLimit:GetFlags())
    log.debug(CVropeLimit:GetBool(), CVropeLimit:GetFlags())
    -- permissions
    log.info("Creating constraint permission convar...")
    local superAdminOnly = "welds_superadminonly"
    CreateConVar(superAdminOnly, 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Restrict constraint limit modifications to superadmins only")
    local CVsuperAdminOnly = GetConVar(superAdminOnly)
    log.debug(CVsuperAdminOnly:GetBool(), CVsuperAdminOnly:GetFlags())
    -- testing
    log.debug("Creating debug convar...")
    CreateConVar("test_cheeseworks", 65, FCVAR_ARCHIVE, "Cheeseworks test convar")
    log.log("Created all convars for constraint limit addon!")
    return
else
    log.error("Server instance not found")
    return
end