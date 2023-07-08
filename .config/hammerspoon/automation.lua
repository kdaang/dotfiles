local hsAudioDevice = require("hs.audiodevice")
local hsApp = require("hs.application")
local hsTimer = require("hs.timer")

local M = {}

M.homeSetup = function()
    hsApp.find("eqMac", true):kill()

    hsTimer.waitUntil(function() return hsApp.find("eqMac", true) == nil end,
                      function()
        local outputDevice = hsAudioDevice.defaultOutputDevice()
        outputDevice:setOutputVolume(0)
        outputDevice:setOutputMuted(false)
    end, 1)
end

M.workSetup = function()
    hsApp.open("eqMac", 10, true)
    local outputDevice = hsAudioDevice.defaultOutputDevice()
    outputDevice:setOutputVolume(30)
    outputDevice:setOutputMuted(false)
end

return M
