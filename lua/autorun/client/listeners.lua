if CLIENT then
    -- logging
    local FSCLogger = include("autorun/print.lua")
    local log = FSCLogger:new()
    -- convars
    local vars = include("autorun/vars.lua")
    -- notifs
    local notify = include("autorun/notify.lua")
    -- notification handler
    local function notif()
        -- Function to handle constraint reset notifications
        log:info("Received constraint reset notification from server")
        local ifNotifs = GetConVar(vars.client.notify.name)
        if ifNotifs then
            log:debug("Checking notification convar...")
            local msg = net.ReadString()
            local type = net.ReadUInt(8)
            local time = net.ReadFloat()
            if ifNotifs:GetBool() then
                log:debug("Displaying notification for", msg, "of type", type, "for time", time)
                notification.AddLegacy(msg, type, time)
                notify.sound(type)
            else
                log:debug("Skipping notification display for", msg, "of type", type, "for time", time)
                return
            end
        else
            log:error("Notification convar not found, cannot display notifications")
            return
        end
    end

    net.Receive("FSC_Notification", notif)
else
    log:error("Client instance not found")
    return
end