local hsAudioDevice = require("hs.audiodevice")
local hsAlert = require("hs.alert")
local hsScreen = require("hs.screen")
local hsApp = require("hs.application")
local hsTimer = require("hs.timer")

WifiTransitions = require("lib.wifi-transitions")
M = {}

local HOME_NETWORK_NAME = "BeyondFuture"

local wifiActions = {
    {
        from = HOME_NETWORK_NAME,
        to = nil,
        fn = {
            function(event, interface, old_ssid, new_ssid)
                hsAlert.show(string.format(
                                 "Off Home Network - %s, cooling down...",
                                 new_ssid), hsScreen.allScreens(), 3)

                hsApp.find("eqMac", true):kill()

                hsTimer.waitUntil(function()
                    return hsApp.find("eqMac", true) == nil
                end, function()
                    local outputDevice = hsAudioDevice.defaultOutputDevice()
                    outputDevice:setOutputVolume(0)
                    outputDevice:setOutputMuted(false)
                end, 1)
            end
        }
    }, {
        from = nil,
        to = HOME_NETWORK_NAME,
        fn = {
            function(event, interface, old_ssid, new_ssid)
                hsAlert.show(string.format(
                                 "Connected to Home Network - %s, spicing up...",
                                 new_ssid), hsScreen.allScreens(), 3)

                hsApp.open("eqMac", 10, true)
                local outputDevice = hsAudioDevice.defaultOutputDevice()
                outputDevice:setOutputVolume(30)
                outputDevice:setOutputMuted(false)
            end
        }
    }
}

M.setup = function()
    WifiTransitions.logger.setLogLevel(5)
    WifiTransitions:start()

    for _, wifiAction in ipairs(wifiActions) do
        table.insert(WifiTransitions.actions, wifiAction)
    end
end

return M
