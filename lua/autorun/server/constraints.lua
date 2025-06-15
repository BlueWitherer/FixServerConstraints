if SERVER then
    AddCSLuaFile("autorun/print.lua")
    include("autorun/print.lua")
    local log = FscPrint
    log.debug("Creating constraint limit convars...")
    CreateConVar("sbox_maxconstraints", 2000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum constraints limit")
    CreateConVar("sbox_maxropeconstraints", 1000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum rope constraints limit")
    log.debug("Creating constraint permission convar...")
    CreateConVar("welds_superadminonly", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Restrict constraint limit modifications to superadmins only")
    -- testing
    log.debug("Creating debug convar...")
    CreateConVar("test_cheeseworks", 65, FCVAR_ARCHIVE, "Cheeseworks test convar")
    log.log("Created all convars for constraint limit addon!")
    return
else
    log.error("Server instance not found")
    return
end