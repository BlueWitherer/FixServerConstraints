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
    util.AddNetworkString("FSC_SetConstraintConVar")
    util.AddNetworkString("FSC_ResetConstraintConVars")
    util.AddNetworkString("FSC_SetConstraintAdmin")
    util.AddNetworkString("FSC_ConstraintResetNotification")
    -- admin check
    local function checkAdmin(ply)
        local AdminVar = GetConVar(vars.adminperm.name)
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
    local function sendNotification(ply, msg, type, time)
        net.Start("FSC_ConstraintResetNotification")
        net.WriteString(msg)
        net.WriteUInt(type, 8)
        net.WriteFloat(time)
        net.Send(ply)
    end

    net.Receive("FSC_SetConstraintConVar", function(len, ply)
        if IsValid(ply) then
            log:info("Received request to reset constraint variables")
            if checkAdmin(ply) then
                local cvar = net.ReadString()
                local value = net.ReadFloat()
                log:debug("Checking if convar is valid...")
                if vars.validVars[cvar] then
                    local var = GetConVar(cvar)
                    if var then
                        var:SetFloat(value)
                    else
                        log:error("Convar", cvar, "not found")
                        return
                    end
                else
                    log:error("Attempted to modify an unrelated convar")
                    return
                end
            else
                log:error("Player", ply:Nick(), "does not have required permission")
                return
            end
        else
            log:error("Player not found")
            return
        end
    end)

    net.Receive("FSC_ResetConstraintConVars", function(len, ply)
        if IsValid(ply) then
            log:info("Received request to reset constraint variables")
            if checkAdmin(ply) then
                log:debug("Resetting constraint limits to default values...")
                -- Get convar names
                local weldLimit = vars.maxwelds.name
                local ropeLimit = vars.maxropes.name
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
                    sendNotification(ply, "Couldn't find one or more constraint variables", notify.enum.NOTIFY_ERROR, 3)
                    return
                else
                    sendNotification(ply, "Constraint limits reset to default!", notify.enum.NOTIFY_UNDO, 3)
                    return
                end
            else
                log:error("Player", ply:Nick(), "does not have required permission")
                sendNotification(ply, "You are missing permissions", notify.enum.NOTIFY_ERROR, 3)
                return
            end
        else
            log:error("Player not found")
            return
        end
    end)

    net.Receive("FSC_SetConstraintAdmin", function(len, ply)
        if IsValid(ply) then
            log:info("Received request to set superadmin permission convar")
            if checkAdmin(ply) then
                local newValue = net.ReadBool()
                log:debug("Setting superadmin permission convar to", newValue)
                local superPerm = vars.adminperm.name
                local CVsuperPerm = GetConVar(superPerm)
                if CVsuperPerm then
                    CVsuperPerm:SetBool(newValue)
                    SetGlobal2Bool("welds_superadminonly", newValue) -- Sync change globally
                    log:debug("Synced superadmin permission convar with all clients")
                else
                    log:error("Superadmin permission convar not found")
                    return
                end
            else
                log:error("Player", ply:Nick(), "does not have required permission")
                return
            end
        else
            log:error("Player not found")
            return
        end
    end)

    cvars.AddChangeCallback("welds_superadminonly", function(name, old, new)
        log:debug("Detected change in superadmin permission convar...")
        SetGlobal2Bool("welds_superadminonly", tobool(new)) -- Sync change globally
        log:debug("Synced superadmin permission convar with all clients")
    end)
else
    log:error("Server instance not found")
    return
end