require("lib.constants")
local hsApp = require("hs.application")
local hsTimer = require("hs.timer")
local hsWifi = require("hs.wifi")
local hsEventTap = require("hs.eventtap")
local hsPasteboard = require("hs.pasteboard")

local M = {}

M.waitUntilApp = function(appName, toLaunch, fn)
    local triggerFn = function() return hsApp.find(appName, true) == nil end
    if (toLaunch) then
        triggerFn = function() return hsApp.find(appName, true) ~= nil end
    end

    hsTimer.waitUntil(triggerFn, fn, 1)
end

M.openApp = function(appName, hideApp)
    local app = hsApp.open(appName, 10, true)
    if (hideApp) then hsTimer.doAfter(0.5, function() app:hide() end) end
end

M.closeApp = function(appName)
    local app = hsApp.find(appName, true)
    if (app ~= nil) then app:kill() end
end

M.getCurrentWifiName = function() return hsWifi.currentNetwork() end

M.onHomeNetwork = function()
    return string.find(hsWifi.currentNetwork(), HOME_NETWORK_NAME) ~= nil
end

M.getComputerName = function()
    local computerName = hs.execute("scutil --get ComputerName", false)
    return computerName
end

M.isPersonalComputer = function()
    local computerName = M.getComputerName()
    return string.find(computerName, "gogo") ~= nil
end

M.isWeekday = function()
    local weekDayNum = os.date("*t").wday
    return weekDayNum > 1 and weekDayNum < 7
end

M.getWorkTimeStart = function()
    return os.time({year = 1970, month = 1, day = 1, hour = 9, min = 0})
end

M.getWorkTimeEnd = function()
    return os.time({year = 1970, month = 1, day = 1, hour = 18, min = 0})
end

M.getStringTime = function(time) return os.date("%H:%M", time) end

M.isBetweenTime = function(startTime, endTime, compareTime)
    local s = startTime.hour * 60 + startTime.min
    local e = endTime.hour * 60 + endTime.min
    local t = compareTime.hour * 60 + compareTime.min

    return t >= s and t < e
end

M.isWorkingTime = function()
    local s = os.date("*t", M.getWorkTimeStart())
    local e = os.date("*t", M.getWorkTimeEnd())
    local currT = os.date("*t", os.time())
    return M.isBetweenTime(s, e, currT) and M.isWeekday()
end

M.getFormattedDate = function(ts, localTimezone)
    if not M.isTimestamp(ts) then return nil end

    local formatStr = "%A, %B %d, %Y %X" -- eg. Sunday, July 09, 2023 22:01:54
    if not localTimezone then formatStr = "!" .. formatStr end

    local tsStr = tostring(ts)
    if M.isTimestampInMillis(ts) then
        return os.date(formatStr, ts // 1000) .. "." ..
                   string.sub(tsStr, #tsStr - 2, #tsStr)
    end

    return os.date(formatStr, ts)
end

M.getSelectedText = function()
    hsEventTap.keyStroke({"cmd"}, "c")
    hsTimer.usleep(20000)
    local sel = hsPasteboard.getContents()
    hsPasteboard.clearContents()
    return (sel or "")
end

M.isTimestampInMillis = function(ts) return #tostring(ts) == 13 end
M.isTimestampInSec = function(ts) return #tostring(ts) == 10 end

M.isTimestamp = function(ts)
    return M.isTimestampInMillis(ts) or M.isTimestampInSec(ts)
end

return M
