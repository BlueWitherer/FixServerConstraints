local vars = {
    welds = {
        name = "sbox_maxconstraints",
        default = 2000
    },
    ropes = {
        name = "sbox_maxropeconstraints",
        default = 1000
    },
    admin = {
        perm = {
            name = "fsc_superadmin",
            default = 1
        }
    }
}

-- client only fields
if CLIENT then
    vars.client = {
        notify = {
            name = "fsc_notify",
            default = 1
        },
        hosthidepanel = {
            name = "fsc_hosthidepanel",
            default = 1
        },
    }
end
return vars