if SERVER then -- Client-side only
    print("This script is intended for client-side execution only")
    return
elseif CLIENT then
    local function CheckAdmin() -- Check if the player has permission to modify constraint limits
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply.IsAdmin then return false end
        local AdminVar = GetConVar("welds_superadminonly") -- Check if superadmin restriction is enabled
        if IsValid(AdminVar) then
            if AdminVar:GetBool() then
                print("Superadmin restriction is enabled, checking player status")
                if ply:IsSuperAdmin() then
                    print("Player is a superadmin, permission granted")
                    return true -- Superadmin has permission
                else
                    print("Player is not a superadmin, permission denied")
                    return false -- Non-superadmin does not have permission
                end
            else
                if ply:IsAdmin() then
                    print("Player is an admin, permission granted")
                    return true -- Admin has permission
                else
                    print("Player is not an admin, permission denied")
                    return false -- Non-admin does not have permission
                end
            end
        else
            print("Admin convar not found")
            return false
        end
    end

    local function AdminConstraintSlider(pnl) -- Add a slider to update constraint limits
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply.IsAdmin then return false end
        if CheckAdmin() then -- Check for admin
            print("Player has permission to modify constraint limits")
            pnl:Help("Adjust the maximum number of constraints allowed on the server.")
            pnl:NumSlider("Max Constraints", "sbox_maxconstraints", 100, 2000, 0)
            pnl:NumSlider("Max Rope Constraints", "sbox_maxropeconstraints", 100, 2000, 0)
            if ply:IsSuperAdmin() then -- Check if the player is a superadmin
                print("Superadmin detected, adding superadmin-only constraint permission setting")
                pnl:Help("You're a superadmin, you can restrict constraint limit modifications to superadmins only.")
                pnl:CheckBox("Restrict to Super-Admins", "welds_superadminonly")
            end
        else
            print("Player does not have permission to modify constraint limits")
            local msgTxt = "you cannot change constraint limits."
            local AdminVar = GetConVar("welds_superadminonly") -- Check if superadmin restriction is enabled
            if AdminVar:GetBool() then
                msgTxt = "please ask a superadmin to change constraint limits if you wish."
            else
                msgTxt = "if you wish to change constraint limits, please ask an admin or above."
            end

            pnl:Help("You're a player, " .. msgTxt)
        end
    end

    hook.Add("PopulateToolMenu", "AdminConstraintSettings", function()
        -- Hook spawnmenu to add the slider
        spawnmenu.AddToolMenuOption("Utilities", "Admin", "ServerConstraintSettings", "Constraint Limits", "", "", AdminConstraintSlider)
    end)
    return
else
    print("Client or server not found")
    return
end