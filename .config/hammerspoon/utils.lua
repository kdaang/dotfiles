local hsApp = require("hs.application")
local hsTimer = require("hs.timer")
local hsWifi = require("hs.wifi")

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

M.closeApp = function(appName) hsApp.find(appName, true):kill() end

M.getCurrentWifiName = function() return hsWifi.currentNetwork() end

M.getComputerName = function()
    local computerName = hs.execute("scutil --get ComputerName", false)
    return computerName
end

M.isPersonalComputer = function()
    local computerName = M.getComputerName()
    return string.find(computerName, "gogo") ~= nil
end

return M
