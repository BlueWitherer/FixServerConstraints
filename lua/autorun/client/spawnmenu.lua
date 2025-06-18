if CLIENT then -- Client-side only
    -- logging
    local FSCLogger = include("autorun/print.lua")
    local log = FSCLogger:new()
    -- convars
    local vars = include("autorun/vars.lua")
    -- notifs
    local notify = include("autorun/notify.lua")
    -- functions
    local CheckAdmin = function()
        -- Check if the player has permission to modify constraint limits
        log:debug("Checking if player has admin...")
        local ply = LocalPlayer()
        if IsValid(ply) then -- Check if player object is valid
            local AdminBool = GetGlobal2Bool(vars.adminperm.name, true) -- Check if superadmin restriction is enabled
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

    local SendVarUpdate = function(cvar, value)
        -- Send a convar update to the server
        log:debug("Sending convar update to server for", cvar, "with value", value)
        net.Start("FSC_SetConstraintConVar")
        net.WriteString(cvar)
        net.WriteFloat(value)
        net.SendToServer()
    end

    local ConstraintSettings = function(pnl)
        -- Add a slider to update constraint limits
        log:debug("Setting up constraint limit sliders to spawnmenu utilities...")
        local ply = LocalPlayer()
        if IsValid(ply) then -- Check if player object is valid
            if CheckAdmin() then -- Check for admin
                log:info("Player has permission to modify constraint limits")
                pnl:Help("Adjust the maximum number of constraints allowed on the server.")
                local weldSlider = pnl:NumSlider("Max Constraints", vars.maxwelds.name, 10, 2000, 0)
                local ropeSlider = pnl:NumSlider("Max Rope Constraints", vars.maxropes.name, 10, 2000, 0)
                pnl:Help("If you're on a server, you likely cannot update the values as you adjust the slider. To fix this, press the button below to manually update the constraint limits. This is not required if you're hosting this server on your computer.")
                local UpdateBtn = pnl:Button("Update Limits")
                UpdateBtn.DoClick = function()
                    -- Update button clicked callback
                    log:debug("Update button clicked, sending new constraint limits to server")
                    local weldValue = weldSlider:GetValue()
                    local ropeValue = ropeSlider:GetValue()
                    net.Start("FSC_SetConstraintConVars")
                    net.WriteFloat(weldValue)
                    net.WriteFloat(ropeValue)
                    net.SendToServer()
                end

                pnl:Help("Reset the constraint limits to their default values.")
                local ResetBtn = pnl:Button("Reset to Default")
                ResetBtn.DoClick = function()
                    -- Reset button clicked callback
                    log:debug("Reset button clicked, resetting constraint limits to default")
                    net.Start("FSC_ResetConstraintConVars")
                    net.SendToServer()
                end
            else
                log:warn("Player does not have permission to modify constraint limits")
                local msgTxt = "you cannot change constraint limits." -- Help text
                local AdminBool = GetGlobal2Bool(vars.adminperm.name, true) -- Check if superadmin restriction is enabled
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

    local ConstraintAdmin = function(pnl)
        log:debug("Setting up constraint admin to spawnmenu options...")
        local ply = LocalPlayer()
        if IsValid(ply) then
            if ply:IsSuperAdmin() then -- Check if the player is a superadmin
                log:info("Superadmin detected, adding superadmin-only constraint permission setting")
                pnl:Help("You're a superadmin, you can restrict constraint limit modifications to superadmins only.")
                local adminCheckBox = pnl:CheckBox("Restrict to Super-Admins", vars.adminperm.name)
                pnl:Help("Press this button if you're not hosting this server to update permissions.")
                local UpdateBtn = pnl:Button("Update Permission")
                UpdateBtn.DoClick = function()
                    -- Update button clicked callback
                    log:debug("Update button pressed, sending superadmin restriction update to server")
                    local isChecked = adminCheckBox:GetChecked()
                    log:info("Superadmin restriction is now", isChecked and "enabled" or "disabled")
                    SendVarUpdate(vars.adminperm.name, isChecked and 1 or 0)
                end
            else
                log:warn("Player does not have permission to modify constraint permissions")
                pnl:Help("You do not have permission to change any settings.")
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
        spawnmenu.AddToolMenuOption("Options", "Constraints", "FSCadmin", "Admin", "", "", ConstraintAdmin)
        log:print("Hooked spawnmenu settings")
        local ply = LocalPlayer()
        if IsValid(ply) then
            if ply:IsSuperAdmin() then
                log:debug("Player", ply:Nick(), "is a superadmin")
            elseif ply:IsAdmin() then
                log:debug("Player", ply:Nick(), "is an admin")
            else
                log:debug("Player", ply:Nick(), "is a nonadmin")
            end
        else
            log:error("Couldn't scan player's permissions early")
        end
    end

    hook.Add("AddToolMenuCategories", "ConstraintCategories", hookOptions)
    hook.Add("PopulateToolMenu", "ConstraintSettings", hookUtils)
    -- Events
    local notif = function()
        local msg = net.ReadString()
        local type = net.ReadUInt(8)
        local time = net.ReadFloat()
        notification.AddLegacy(msg, type, time)
        notify.sound(type)
    end

    net.Receive("FSC_ConstraintResetNotification", notif)
else
    log:error("Client instance not found")
    return
end