if SERVER then -- Client-side only
    return 
elseif CLIENT then
    local function AdminConstraintSlider(pnl) -- Add a slider to update constraint limits
        if LocalPlayer():IsAdmin() then -- Check for admin
            pnl:NumSlider("Max Constraints", "sbox_maxconstraints", 100, 2000, 0)
        else
            return 
        end
    end
    
    hook.Add("PopulateToolMenu", "AdminConstraintSettings", function() -- Hook spawnmenu to add the slider
        spawnmenu.AddToolMenuOption("Utilities", "Admin", "ServerConstraintSettings", "Server Constraint Limits", "", "", AdminConstraintSlider)
    end)

    cvars.AddChangeCallback("sbox_maxconstraints", function(name, old, new)
        print("Max Constraints updated to: " .. new)
    end)
end