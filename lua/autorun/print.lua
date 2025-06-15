FscPrint = function(...)
    -- Pretty print for this addon
    local args = {...}
    local msg = ""
    for i, v in ipairs(args) do
        msg = msg .. tostring(v)
        if i < #args then msg = msg .. "\t" end
    end

    MsgC(Color(255, 186, 245), "[FixServerConstraints] ", color_white, msg .. "\n")
end