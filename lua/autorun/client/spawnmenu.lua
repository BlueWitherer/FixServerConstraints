if CLIENT then -- Client-side only
    -- logging
    local FSCLogger = include("autorun/print.lua")
    local log = FSCLogger:new()
    -- convars
    local vars = include("autorun/vars.lua")
    -- functions
    local ShowToOperator = function()
        -- Function to determine if the admin settings panel should be shown or hidden
        log:debug("Checking if admin settings panel should be hidden...")
        local ply = LocalPlayer() -- Get the local player
        local ifHidePanel = GetConVar(vars.client.hosthidepanel.name) -- Get the host hide panel convar
        if IsValid(ply) and ifHidePanel then
            if ply:IsListenServerHost() and ifHidePanel:GetBool() then
                log:debug("Player is the operator (host), hiding admin settings panel")
                return false -- Only hide if player is the operator and hide is enabled
            else
                log:debug("Player is not the operator or host hide panel is disabled, showing admin settings panel")
                return true -- Show the admin settings panel for all other players
            end
        else
            log:error("Player instance not found or host hide panel convar is invalid")
            return false -- Default to hiding the admin settings panel if player or convar is invalid
        end
    end

    local CheckAdmin = function()
        -- Check if the player has permission to modify constraint limits
        log:debug("Checking if player has admin...")
        local ply = LocalPlayer()
        if IsValid(ply) then -- Check if player object is valid
            log:debug("Player", ply:Nick(), "is valid, checking permissions...")
            local AdminBool = GetGlobal2Bool(vars.admin.perm.name, vars.admin.perm.default > 0 or false) -- Check if superadmin restriction is enabled
            if AdminBool then
                log:debug("Superadmin restriction is enabled, checking player status")
                if ply:IsSuperAdmin() then
                    log:info("Player is a superadmin, permission granted")
                    return true -- Superadmin has permission
                else
                    log:warn("Player is not a superadmin, permission denied")
                    return false -- Non-superadmin does not have permission
                end
            else
                if ply:IsAdmin() or plr:IsSuperAdmin() then
                    log:info("Player is an admin, permission granted")
                    return true -- Admin has permission
                else
                    log:warn("Player is not an admin, permission denied")
                    return false -- Non-admin does not have permission
                end
            end
        else
            log:error("Player instance not found")
            return false
        end
    end

    local ConstraintSettings = function(pnl)
        -- Add a slider to update constraint limits
        log:debug("Setting up constraint limit sliders to spawnmenu utilities...")
        local ply = LocalPlayer()
        if IsValid(ply) then -- Check if player object is valid
            log:debug("Player", ply:Nick(), "is valid, checking permissions...")
            if CheckAdmin() then -- Check for admin
                log:info("Player has permission to modify constraint limits")
                pnl:Help("Adjust the maximum number of constraints allowed on the server.")
                local weldSlider = pnl:NumSlider("Max Constraints", vars.welds.name, 10, 2000, 0)
                local ropeSlider = pnl:NumSlider("Max Rope Constraints", vars.ropes.name, 10, 2000, 0)
                weldSlider:SetTooltip("Set the maximum number of weld constraints allowed on the server.")
                ropeSlider:SetTooltip("Set the maximum number of rope constraints allowed on the server.")
                if ShowToOperator() then -- Check if the admin settings panel should be hidden
                    pnl:Help("Press the button below to manually update the constraint limits on the server.")
                    local UpdateBtn = pnl:Button("Update Limits")
                    UpdateBtn:SetTooltip("Request the server to update the constraint limits with the values set in the sliders.")
                    UpdateBtn.DoClick = function()
                        -- Update button pressed callback
                        log:debug("Update button pressed, sending new constraint limits to server")
                        local weldValue = weldSlider:GetValue()
                        local ropeValue = ropeSlider:GetValue()
                        local start = net.Start("FSC_SetConstraintConVars")
                        if start then -- Check if net message started successfully
                            log:debug("Starting net message for updating constraint limits")
                            net.WriteFloat(weldValue)
                            net.WriteFloat(ropeValue)
                            net.SendToServer()
                            log:info("Sent new constraint limits:", weldValue, "welds and", ropeValue, "ropes")
                        else
                            log:error("Failed to start net message for updating constraint limits")
                            return
                        end
                    end
                else
                    log:debug("Manual update panel is hidden due to host hide setting")
                end

                local ResetBtn = pnl:Button("Reset to Default")
                ResetBtn:SetTooltip("Reset all constraint limits to their default values.")
                ResetBtn.DoClick = function()
                    -- Reset button pressed callback
                    log:debug("Reset button pressed, resetting constraint limits to default")
                    local start = net.Start("FSC_ResetConstraintConVars")
                    if start then -- Check if net message started successfully
                        log:debug("Starting net message for resetting constraint limits")
                        net.SendToServer()
                        log:info("Sent request to reset constraint limits to default values")
                    else
                        log:error("Failed to start net message for resetting constraint limits")
                        return
                    end
                end
            else
                log:warn("Player does not have permission to modify constraint limits")
                local msgTxt = "you cannot change constraint limits." -- Help text
                local AdminBool = GetGlobal2Bool(vars.admin.perm.name, vars.admin.perm.default > 0 or false) -- Check if superadmin restriction is enabled
                if AdminBool then
                    msgTxt = "please ask a superadmin to change constraint limits if you wish."
                else
                    msgTxt = "if you wish to change constraint limits, please ask an admin or above."
                end

                log:debug("Creating help text for player...")
                pnl:Help("You're a player, " .. msgTxt)
            end
        else
            log:error("Player instance not found")
            return
        end
    end

    local ConstraintClient = function(pnl)
        log:debug("Setting up constraint client to spawnmenu options...")
        local ply = LocalPlayer()
        if IsValid(ply) then
            log:debug("Player", ply:Nick(), "is valid, creating client settings...")
            pnl:Help("Adjust this addon's settings.")
            local checkNotifs = pnl:CheckBox("Enable Notifications", vars.client.notify.name)
            checkNotifs:SetTooltip("Toggle display of all notifications on your client. If disabled, you will only see notifications logged in the console.")
            local checkHostHide = pnl:CheckBox("Hide Manual Update Panel", vars.client.hosthidepanel.name)
            checkHostHide:SetTooltip("Re-join required. If enabled, the 'Update' panel in constraint settings will not be shown if you're hosting this server locally. However, it will always be shown if you're not hosting this server.")
        else
            log:error("Player instance not found")
            return
        end
    end

    local ConstraintAdmin = function(pnl)
        log:debug("Setting up constraint admin to spawnmenu options...")
        local ply = LocalPlayer()
        local ifHidePanel = GetConVar(vars.client.hosthidepanel.name)
        if IsValid(ply) and ifHidePanel then
            log:debug("Player", ply:Nick(), "is valid, checking permissions...")
            if ply:IsSuperAdmin() then -- Check if the player is a superadmin
                log:info("Superadmin detected, adding superadmin-only constraint permission setting")
                pnl:Help("You're a superadmin, you can restrict constraint limit permissions to superadmins only.")
                local adminCheckBox = pnl:CheckBox("Restrict to Super-Admins", vars.admin.perm.name)
                adminCheckBox:SetTooltip("If enabled, only superadmins can modify constraint limits. If disabled, admins can also modify them.")
                if ShowToOperator() then -- Check if the admin settings panel should be hidden
                    pnl:Help("Press the button below to update permissions.")
                    local UpdateBtn = pnl:Button("Update Permission")
                    UpdateBtn:SetTooltip("Update the superadmin restriction setting on the server.")
                    UpdateBtn.DoClick = function()
                        -- Update button pressed callback
                        log:debug("Update button pressed, sending superadmin restriction update to server")
                        local isChecked = adminCheckBox:GetChecked()
                        log:info("Superadmin restriction is now", isChecked and "enabled" or "disabled")
                        local start = net.Start("FSC_SetConstraintAdmin")
                        if start then -- Check if net message started successfully
                            log:debug("Starting net message for updating superadmin restriction")
                            net.WriteBool(isChecked)
                            net.SendToServer()
                            log:info("Sent superadmin restriction update to server:", isChecked)
                        else
                            log:error("Failed to start net message for updating superadmin restriction")
                            return
                        end
                    end
                else
                    log:debug("Manual update panel is hidden due to host hide setting")
                end
            else
                log:warn("Player does not have permission to modify constraint permissions")
                pnl:Help("You do not have permission to change permission settings.")
            end
        else
            log:error("Player instance not found")
            return
        end
    end

    -- Hooks
    local hookOptions = function()
        -- Hook spawnmenu to add the categories
        spawnmenu.AddToolCategory("Options", "Constraints", "#Constraints")
        log:print("Hooked spawnmenu categories")
    end

    local hookUtils = function()
        -- Hook spawnmenu to add the settings
        spawnmenu.AddToolMenuOption("Utilities", "Admin", "FSCsettings", "Fix Constraint Limits", "", "", ConstraintSettings)
        spawnmenu.AddToolMenuOption("Options", "Constraints", "FSCclient", "Client", "", "", ConstraintClient)
        spawnmenu.AddToolMenuOption("Options", "Constraints", "FSCadmin", "Admin", "", "", ConstraintAdmin)
        log:print("Hooked spawnmenu settings")
        local ply = LocalPlayer()
        if IsValid(ply) then
            log:debug("Player", ply:Nick(), "is valid, checking permissions...")
            if ply:IsSuperAdmin() then
                log:debug("Player", ply:Nick(), "is a superadmin")
            elseif ply:IsAdmin() then
                log:debug("Player", ply:Nick(), "is an admin")
            else
                log:debug("Player", ply:Nick(), "is a nonadmin")
            end
        else
            log:error("Couldn't scan player's permissions early")
            return
        end
    end

    -- Register hooks
    log:debug("Registering hooks for spawnmenu...")
    hook.Add("AddToolMenuCategories", "ConstraintCategories", hookOptions)
    hook.Add("PopulateToolMenu", "ConstraintSettings", hookUtils)
else
    log:error("Client instance not found")
    return
end