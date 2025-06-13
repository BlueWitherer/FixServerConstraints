if SERVER then
    CreateConVar("sbox_maxconstraints", 2000, FCVAR_ARCHIVE, "Max constraints limit")
    CreateConVar("sbox_maxropeconstraints", 1000, FCVAR_ARCHIVE, "Max rope constraints limit")
    CreateConVar("welds_superadminonly", 1, FCVAR_ARCHIVE, "Restrict constraint limit modifications to superadmins only")
    CreateConVar("test_cheeseworks", 65, FCVAR_ARCHIVE, "Cheeseworks test convar") -- debug
end