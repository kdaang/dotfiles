require("lib.constants")
local hsAudioDevice = require("hs.audiodevice")
local utils = require("utils")
local wm = require("window-management")

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
    print(string.format("On Network: %s", wifiName))

    if (wifiName == HOME_NETWORK_NAME) then
        M.homeSetup()
    else
        M.workSetup()
    end

    wm.configureWindows()

    print("done automating!")
end

M.test = function()
    local BASH_COMMAND = "/opt/homebrew/bin/bash "
    local output, status, type, rc = hs.execute(BASH_COMMAND .. "~/bin/scratch",
                                                false)
    print(string.format("%s, %s, %s, %s", output, status, type, rc))
    print("done test")
end

return M
