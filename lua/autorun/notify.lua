local notify = {
    enum = {
        NOTIFY_GENERIC = 0,
        NOTIFY_ERROR = 1,
        NOTIFY_UNDO = 2,
        NOTIFY_HINT = 3,
        NOTIFY_CLEANUP = 4
    },
    sound = function(t)
        if CLIENT then
            if t == 0 then
                -- NOTIFY_GENERIC
                surface.PlaySound("buttons/button14.wav")
            elseif t == 1 then
                -- NOTIFY_ERROR
                surface.PlaySound("buttons/button10.wav")
            elseif t == 2 then
                -- NOTIFY_UNDO
                surface.PlaySound("buttons/button15.wav")
            elseif t == 3 then
                -- NOTIFY_HINT
                surface.PlaySound("buttons/button9.wav")
            elseif t == 4 then
                -- NOTIFY_CLEANUP
                surface.PlaySound("buttons/button11.wav")
            else
                surface.PlaySound("buttons/button14.wav")
            end
        end
    end
}
return notify