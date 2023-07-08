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

M.openApp = function(appName) hsApp.open(appName, 10, true) end

M.closeApp = function(appName) hsApp.find(appName, true):kill() end

M.getCurrentWifiName = function() return hsWifi.currentNetwork() end

return M
