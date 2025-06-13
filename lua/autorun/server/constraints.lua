if SERVER then
    print("Creating constraint limit convars...")
    CreateConVar("sbox_maxconstraints", 2000, FCVAR_ARCHIVE, "Max constraints limit")
    CreateConVar("sbox_maxropeconstraints", 1000, FCVAR_ARCHIVE, "Max rope constraints limit")
    print("Creating constraint permission convar...")
    CreateConVar("welds_superadminonly", 1, FCVAR_ARCHIVE, "Restrict constraint limit modifications to superadmins only")
    print("Creating debug convar...")
    CreateConVar("test_cheeseworks", 65, FCVAR_ARCHIVE, "Cheeseworks test convar") -- debug
    print("Created all convars for constraint limit addon!")
    return
else
    print("Server instance not found")
    return
end