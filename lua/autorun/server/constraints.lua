if SERVER then
    AddCSLuaFile("autorun/print.lua")
    include("autorun/print.lua")
    FscPrint.debug("Creating constraint limit convars...")
    CreateConVar("sbox_maxconstraints", 2000, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Max constraints limit")
    CreateConVar("sbox_maxropeconstraints", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Max rope constraints limit")
    FscPrint.debug("Creating constraint permission convar...")
    CreateConVar("welds_superadminonly", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Restrict constraint limit modifications to superadmins only")
    -- testing
    FscPrint.debug("Creating debug convar...")
    CreateConVar("test_cheeseworks", 65, {FCVAR_ARCHIVE}, "Cheeseworks test convar")
    FscPrint.log("Created all convars for constraint limit addon!")
    return
else
    FscPrint.error("Server instance not found")
    return
end