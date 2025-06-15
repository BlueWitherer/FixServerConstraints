if SERVER then AddCSLuaFile("autorun/print.lua") end
include("autorun/print.lua")
if CLIENT then -- Client-side only
    local CheckAdmin = function()
        -- Check if the player has permission to modify constraint limits
        FscPrint.debug("Checking if player has admin...")
        local Plr = LocalPlayer()
        if IsValid(Plr) then -- Check if player object is valid
            local AdminVar = GetConVar("welds_superadminonly") -- Check if superadmin restriction is enabled
            if AdminVar then -- Check that convar is loaded
                if AdminVar:GetBool() then
                    FscPrint.debug("Superadmin restriction is enabled, checking player status")
                    if Plr:IsSuperAdmin() then
                        FscPrint.info("Player is a superadmin, permission granted")
                        return true -- Superadmin has permission
                    else
                        FscPrint.warn("Player is not a superadmin, permission denied")
                        return false -- Non-superadmin does not have permission
                    end
                else
                    if Plr:IsAdmin() then
                        FscPrint.info("Player is an admin, permission granted")
                        return true -- Admin has permission
                    else
                        FscPrint.warn("Player is not an admin, permission denied")
                        return false -- Non-admin does not have permission
                    end
                end
            else
                FscPrint.error("Admin convar not found")
                return false
            end
        else
            FscPrint.error("Player instance not found")
            return false
        end
    end

    local AdminConstraintSlider = function(pnl)
        -- Add a slider to update constraint limits
        FscPrint.debug("Setting up constraint limit sliders to spawnmenu utilities...")
        local Plr = LocalPlayer()
        if IsValid(Plr) then -- Check if player object is valid
            if CheckAdmin() then -- Check for admin
                FscPrint.info("Player has permission to modify constraint limits")
                pnl:Help("Adjust the maximum number of constraints allowed on the server.")
                pnl:NumSlider("Max Constraints", "sbox_maxconstraints", 100, 2000, 0)
                pnl:NumSlider("Max Rope Constraints", "sbox_maxropeconstraints", 100, 2000, 0)
                if Plr:IsSuperAdmin() then -- Check if the player is a superadmin
                    FscPrint.info("Superadmin detected, adding superadmin-only constraint permission setting")
                    pnl:Help("You're a superadmin, you can restrict constraint limit modifications to superadmins only.")
                    pnl:CheckBox("Restrict to Super-Admins", "welds_superadminonly")
                else
                    FscPrint.warn("Player does not have permission to modify constraint permissions")
                end
            else
                FscPrint.warn("Player does not have permission to modify constraint limits")
                local msgTxt = "you cannot change constraint limits." -- Help text
                local AdminVar = GetConVar("welds_superadminonly") -- Check if superadmin restriction is enabled
                if AdminVar then -- Check that convar is loaded
                    if AdminVar:GetBool() then
                        msgTxt = "please ask a superadmin to change constraint limits if you wish."
                    else
                        msgTxt = "if you wish to change constraint limits, please ask an admin or above."
                    end
                else
                    FscPrint.error("Admin convar not found")
                end

                FscPrint.debug("Creating help text for player...")
                pnl:Help("You're a player, " .. msgTxt)
            end
        else
            FscPrint.error("Player instance not found")
        end
    end

    -- Hooks
    local hookFsc = function()
        -- Hook spawnmenu to add the slider
        spawnmenu.AddToolMenuOption("Utilities", "Admin", "FixedServerConstraintSettings", "Fix Constraint Limits", "", "", AdminConstraintSlider)
        FscPrint.log("Hooked spawnmenu")
        local Plr = LocalPlayer()
        if IsValid(Plr) then
            if Plr:IsSuperAdmin() then
                FscPrint.debug("Player" .. Plr:Nick() .. "is superadmin")
            elseif Plr:IsAdmin() then
                FscPrint.debug("Player" .. Plr:Nick() .. "is admin")
            else
                FscPrint.debug("Player" .. Plr:Nick() .. "is nonadmin")
            end
        else
            FscPrint.error("Couldn't scan player's permissions early")
        end
    end

    hook.Add("PopulateToolMenu", "AdminConstraintSettings", hookFsc)
    return
else
    FscPrint.error("Client instance not found")
    return
end