if CLIENT then -- Client-side only
    local function CheckAdmin() -- Check if the player has permission to modify constraint limits
        local Plr = LocalPlayer() -- Check if player object is valid
        if IsValid(Plr) then
            local AdminVar = GetConVar("welds_superadminonly") -- Check if superadmin restriction is enabled
            if AdminVar then
                if AdminVar:GetBool() then
                    print("Superadmin restriction is enabled, checking player status")
                    if Plr:IsSuperAdmin() then
                        print("Player is a superadmin, permission granted")
                        return true -- Superadmin has permission
                    else
                        print("Player is not a superadmin, permission denied")
                        return false -- Non-superadmin does not have permission
                    end
                else
                    if Plr:IsAdmin() then
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
        else
            print("Player instance not found")
            return false
        end
    end

    local function AdminConstraintSlider(pnl) -- Add a slider to update constraint limits
        local Plr = LocalPlayer() -- Check if player object is valid
        if IsValid(Plr) then
            if CheckAdmin() then -- Check for admin
                print("Player has permission to modify constraint limits")
                pnl:Help("Adjust the maximum number of constraints allowed on the server.")
                pnl:NumSlider("Max Constraints", "sbox_maxconstraints", 100, 2000, 0)
                pnl:NumSlider("Max Rope Constraints", "sbox_maxropeconstraints", 100, 2000, 0)
                if Plr:IsSuperAdmin() then -- Check if the player is a superadmin
                    print("Superadmin detected, adding superadmin-only constraint permission setting")
                    pnl:Help("You're a superadmin, you can restrict constraint limit modifications to superadmins only.")
                    pnl:CheckBox("Restrict to Super-Admins", "welds_superadminonly")
                end
            else
                print("Player does not have permission to modify constraint limits")
                local msgTxt = "you cannot change constraint limits." -- Help text
                local AdminVar = GetConVar("welds_superadminonly") -- Check if superadmin restriction is enabled
                if AdminVar then
                    if AdminVar:GetBool() then
                        msgTxt = "please ask a superadmin to change constraint limits if you wish."
                    else
                        msgTxt = "if you wish to change constraint limits, please ask an admin or above."
                    end
                else
                    print("Admin convar not found")
                end

                print("Creating help text for player...")
                pnl:Help("You're a player, " .. msgTxt)
            end
        else
            print("Player instance not found")
        end
    end

    hook.Add("PopulateToolMenu", "AdminConstraintSettings", function()
        -- Hook spawnmenu to add the slider
        spawnmenu.AddToolMenuOption("Utilities", "Admin", "FixedServerConstraintSettings", "Fix Constraint Limits", "", "", AdminConstraintSlider)
    end)
    return
else
    print("Client instance not found")
    return
end