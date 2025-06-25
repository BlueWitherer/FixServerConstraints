local notify = {
    enum = {
        NOTIFY_GENERIC = 0,
        NOTIFY_ERROR = 1,
        NOTIFY_UNDO = 2,
        NOTIFY_HINT = 3,
        NOTIFY_CLEANUP = 4
    }
}

-- client only fields
if CLIENT then
    notify.sound = function(t)
        if t == notify.enum.NOTIFY_GENERIC then
            surface.PlaySound("buttons/button14.wav")
        elseif t == notify.enum.NOTIFY_ERROR then
            surface.PlaySound("buttons/button10.wav")
        elseif t == notify.enum.NOTIFY_UNDO then
            surface.PlaySound("buttons/button15.wav")
        elseif t == notify.enum.NOTIFY_HINT then
            surface.PlaySound("buttons/button9.wav")
        elseif t == notify.enum.NOTIFY_CLEANUP then
            surface.PlaySound("buttons/button11.wav")
        else
            surface.PlaySound("buttons/button14.wav")
        end
    end
end
return notify