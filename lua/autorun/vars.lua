local vars = {
    maxwelds = {
        name = "sbox_maxconstraints",
        default = 2000
    },
    maxropes = {
        name = "sbox_maxropeconstraints",
        default = 1000
    },
    adminperm = {
        name = "welds_superadminonly",
        default = 1
    }
}

vars.validVars = {
    [vars.maxwelds.name] = true,
    [vars.maxropes.name] = true
}
return vars