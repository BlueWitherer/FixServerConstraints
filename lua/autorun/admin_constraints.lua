if SERVER then -- Client-side only
    return 
elseif CLIENT then
    local function AdminConstraintSlider(pnl) -- Add a slider to update constraint limits
        if LocalPlayer():IsAdmin() then -- Check for admin
            pnl:Help("Adjust the maximum number of constraints allowed on the server.")

            pnl:NumSlider("Max Constraints", "sbox_maxconstraints", 100, 2000, 0)
            pnl:NumSlider("Max Rope Constraints", "sbox_maxropeconstraints", 100, 2000, 0)

            return
        else
            return 
        end
    end
    
    hook.Add("PopulateToolMenu", "AdminConstraintSettings", function() -- Hook spawnmenu to add the slider
        spawnmenu.AddToolMenuOption("Utilities", "Admin", "ServerConstraintSettings", "Constraint Limits", "", "", AdminConstraintSlider)
    end)

    cvars.AddChangeCallback("sbox_maxconstraints", function(name, old, new)
        print("Maximum Constraints variable updated to: " .. new)
        return
    end)

    cvars.AddChangeCallback("sbox_maxropeconstraints", function(name, old, new)
        print("Maximum Rope Constraints variable updated to: " .. new)
        return
    end)
end