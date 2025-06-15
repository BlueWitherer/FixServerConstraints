local printFormat = function(...)
    local args = {...}
    local msg = ""
    for i, v in ipairs(args) do
        msg = msg .. tostring(v)
        if i < #args then msg = msg .. "\t" end
    end
    return msg
end

local consoleMsg = function(color, tag, ...)
    local msg = printFormat(...)
    return MsgC(Color(255, 186, 245), "[FixServerConstraints] ", color, tag .. ": ", msg .. "\n")
end

FscPrint = {
    log = function(...) return consoleMsg(Color(255, 255, 255), "LOG", ...) end,
    debug = function(...) return consoleMsg(Color(136, 136, 136), "DEBUG", ...) end,
    info = function(...) return consoleMsg(Color(119, 182, 255), "INFO", ...) end,
    warn = function(...) return consoleMsg(Color(255, 244, 159), "WARN", ...) end,
    error = function(...) return consoleMsg(Color(255, 103, 103), "ERROR", ...) end
}