require("lib.constants")
local hsAudioDevice = require("hs.audiodevice")
local utils = require("utils")

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
    utils.openApp(EQ_MAC)

    utils.waitUntilApp(EQ_MAC, true, function()
        local outputDevice = hsAudioDevice.defaultOutputDevice()
        outputDevice:setOutputVolume(30)
        outputDevice:setOutputMuted(false)
    end)

    print("done running home setup!")
end

M.init = function()
    if (utils.getCurrentWifiName() == HOME_NETWORK_NAME) then
        M.homeSetup()
    else
        M.workSetup()
    end

end

return M
