require("lib.constants")
local hsApp = require("hs.application")
local hsAudioDevice = require("hs.audiodevice")
local utils = require("utils")

local M = {}

M.workSetup = function()
    hsApp.find(EQ_MAC, true):kill()

    utils.waitUntilApp(EQ_MAC, false, function()
        local outputDevice = hsAudioDevice.defaultOutputDevice()
        outputDevice:setOutputVolume(0)
        outputDevice:setOutputMuted(false)
    end)
end

M.homeSetup = function()
    hsApp.open(EQ_MAC, 10, true)

    utils.waitUntilApp(EQ_MAC, true, function()
        local outputDevice = hsAudioDevice.defaultOutputDevice()
        outputDevice:setOutputVolume(30)
        outputDevice:setOutputMuted(false)
    end)
end

return M
