require("lib.constants")
local hsAudioDevice = require("hs.audiodevice")
local hsNotify = require("hs.notify")
local hsSpotify = require("hs.spotify")
local utils = require("utils")
local wm = require("window-management")
local caffeine = require("caffeine")

local M = {}

M.workSetup = function()
    utils.closeApp(EQ_MAC)

    utils.waitUntilApp(EQ_MAC, false, function()
        local outputDevice = hsAudioDevice.defaultOutputDevice()
        outputDevice:setOutputVolume(0)
        outputDevice:setOutputMuted(true)
    end)

    print("done running work setup!")
end

M.homeSetup = function()
    utils.openApp(EQ_MAC, true)

    utils.waitUntilApp(EQ_MAC, true, function()
        local outputDevice = hsAudioDevice.defaultOutputDevice()
        outputDevice:setOutputVolume(30)
        outputDevice:setOutputMuted(false)
    end)

    print("done running home setup!")
end

M.run = function()
    local wifiName = utils.getCurrentWifiName()
    print(string.format("On Network: %s\n", wifiName))

    if (wifiName == HOME_NETWORK_NAME) then
        M.homeSetup()
    else
        M.workSetup()
    end

    caffeine.setup()

    wm.configureWindows()
    hsSpotify.setVolume(50)

    print("done automating!")
    hsNotify.show("Automation Script", "", "done cw!")
end

M.test = function() end

return M
