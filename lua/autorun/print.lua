local FSCLogger = {}
FSCLogger.__index = FSCLogger
function FSCLogger:new()
    local obj = setmetatable({}, self)
    return obj
end

local function formatMsg(...)
    local args = {...}
    local msg = ""
    for i, v in ipairs(args) do
        msg = msg .. tostring(v)
        if i < #args then msg = msg .. "\t" end
    end
    return msg
end

local function consoleMsg(color, level, ...)
    local msg = formatMsg(...)
    MsgC(Color(255, 186, 245), "[FixServerConstraints] ", color, level .. ": ", msg .. "\n")
end

function FSCLogger:log(...)
    consoleMsg(Color(255, 255, 255), "LOG", ...)
end

function FSCLogger:debug(...)
    consoleMsg(Color(136, 136, 136), "DEBUG", ...)
end

function FSCLogger:info(...)
    consoleMsg(Color(119, 182, 255), "INFO", ...)
end

function FSCLogger:warn(...)
    consoleMsg(Color(255, 244, 159), "WARN", ...)
end

function FSCLogger:error(...)
    consoleMsg(Color(255, 103, 103), "ERROR", ...)
end
return FSCLogger