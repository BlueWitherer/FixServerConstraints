if SERVER then
    -- logging
    AddCSLuaFile("autorun/print.lua")
    local FSCLogger = include("autorun/print.lua")
    local log = FSCLogger:new()
    -- convars
    AddCSLuaFile("autorun/vars.lua")
    local vars = include("autorun/vars.lua")
    -- notifs
    AddCSLuaFile("autorun/notify.lua")
    local notify = include("autorun/notify.lua")
    -- event listerners
    util.AddNetworkString("FSC_SetConstraintConVars")
    util.AddNetworkString("FSC_ResetConstraintConVars")
    util.AddNetworkString("FSC_SetConstraintAdmin")
    util.AddNetworkString("FSC_Notification")
    -- admin check
    local function checkAdmin(ply) -- Check if the player has permission to modify constraint limits
        log:debug("Checking if player has admin...")
        local AdminVar = GetConVar(vars.admin.perm.name)
        if AdminVar then
            local adminBool = AdminVar:GetBool()
            log:debug("Checking admin permission...")
            return adminBool and ply:IsSuperAdmin() or not adminBool and ply:IsAdmin()
        else
            log:error("Admin convar not found")
            return false
        end
    end

    -- client notifs
    local function sendNotification(ply, msg, type, time) -- Send a notification to the client
        log:debug("Sending notification to player", ply:Nick(), "with message:", msg, "type:", type, "time:", time)
        local start = net.Start("FSC_Notification")
        if start then -- Start the network message
            log:debug("Network message started successfully from player", ply:Nick())
            net.WriteString(msg)
            net.WriteUInt(type, 8)
            net.WriteFloat(time)
            net.Send(ply)
            log:info("Notification sent to player", ply:Nick())
        else
            log:error("Failed to start network message from player", ply:Nick())
            return
        end
    end

    net.Receive("FSC_SetConstraintConVars", function(len, ply)
        -- Handle client requests to modify constraint variables
        log:info("Received request to modify constraint variables")
        if IsValid(ply) then
            log:debug("Player", ply:Nick(), "is valid, checking permissions...")
            if checkAdmin(ply) then
                log:debug("Player", ply:Nick(), "has required permission, processing request...")
                local weld = net.ReadFloat()
                local rope = net.ReadFloat()
                local varWeld = GetConVar(vars.welds.name)
                local varRope = GetConVar(vars.ropes.name)
                local isError = false
                if varWeld then
                    varWeld:SetFloat(weld)
                    log:info("Set", vars.welds.name, "to", weld)
                else
                    isError = true
                    log:error("Convar", vars.welds.name, "not found")
                end

                if varRope then
                    varRope:SetFloat(rope)
                    log:info("Set", vars.ropes.name, "to", rope)
                else
                    isError = true
                    log:error("Convar", vars.ropes.name, "not found")
                end

                if isError then
                    sendNotification(ply, "Couldn't update constraint limits", notify.enum.NOTIFY_ERROR, 3)
                    log:error("Failed to update constraint limits due to missing convars from player", ply:Nick())
                    return
                else
                    sendNotification(ply, "Constraint limits updated!", notify.enum.NOTIFY_GENERIC, 3)
                    log:info("Successfully updated constraint limits from player", ply:Nick())
                    return
                end
            else
                log:warn("Player", ply:Nick(), "does not have required permission")
                return
            end
        else
            log:error("Player not found")
            return
        end
    end)

    net.Receive("FSC_ResetConstraintConVars", function(len, ply)
        -- Handle client requests to reset constraint variables
        if IsValid(ply) then
            log:info("Received request to reset constraint variables")
            if checkAdmin(ply) then
                log:debug("Resetting constraint limits to default values...")
                -- Get convar names
                local weldLimit = vars.welds.name
                local ropeLimit = vars.ropes.name
                -- get convar objects
                local CVwelds = GetConVar(weldLimit)
                local CVropes = GetConVar(ropeLimit)
                local isError = false
                if CVwelds then
                    CVwelds:Revert()
                    log:info("Reset maximum welds")
                else
                    isError = true
                    log:error("Maximum welds convar not found")
                end

                if CVropes then
                    CVropes:Revert()
                    log:info("Reset maximum ropes")
                else
                    isError = true
                    log:error("Maximum ropes convar not found")
                end

                if isError then
                    sendNotification(ply, "Couldn't reset constraint limits", notify.enum.NOTIFY_ERROR, 3)
                    log:error("Failed to reset constraint limits due to missing convars from player", ply:Nick())
                    return
                else
                    sendNotification(ply, "Constraint limits reset to default!", notify.enum.NOTIFY_UNDO, 3)
                    log:info("Successfully reset constraint limits from player", ply:Nick())
                    return
                end
            else
                log:warn("Player", ply:Nick(), "does not have required permission")
                sendNotification(ply, "You are missing permissions", notify.enum.NOTIFY_ERROR, 3)
                return
            end
        else
            log:error("Player not found")
            return
        end
    end)

    net.Receive("FSC_SetConstraintAdmin", function(len, ply)
        -- Handle client requests to set superadmin permission convar
        if IsValid(ply) then
            log:info("Received request to set superadmin permission convar")
            if checkAdmin(ply) then
                local newValue = net.ReadBool()
                log:debug("Setting superadmin permission convar to", newValue)
                local superPerm = vars.admin.perm.name
                local CVsuperPerm = GetConVar(superPerm)
                if CVsuperPerm then
                    CVsuperPerm:SetBool(newValue)
                    SetGlobal2Bool(vars.admin.perm.name, newValue) -- Sync change globally
                    sendNotification(ply, "Permission updated!", notify.enum.NOTIFY_GENERIC, 3)
                    log:info("Synced superadmin permission convar with all clients")
                else
                    sendNotification(ply, "Couldn't update permission", notify.enum.NOTIFY_ERROR, 3)
                    log:error("Superadmin permission convar not found")
                    return
                end
            else
                log:warn("Player", ply:Nick(), "does not have required permission")
                sendNotification(ply, "You are missing permissions", notify.enum.NOTIFY_ERROR, 3)
                return
            end
        else
            log:error("Player not found")
            return
        end
    end)

    cvars.AddChangeCallback(vars.admin.perm.name, function(name, old, new)
        -- Callback for superadmin permission convar changes
        log:debug("Detected change in superadmin permission convar...")
        SetGlobal2Bool(vars.admin.perm.name, tobool(new)) -- Sync change globally
        log:info("Synced superadmin permission convar with all clients")
    end)
else
    log:error("Server instance not found")
    return
end