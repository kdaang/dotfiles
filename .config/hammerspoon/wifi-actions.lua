local hsAudioDevice = require("hs.audiodevice")
local hsAlert = require("hs.alert")
local hsScreen = require("hs.screen")

WifiTransitions = require("lib.wifi-transitions")
M = {}

M.setup = function()
    WifiTransitions.logger.setLogLevel(5)
    WifiTransitions:start()

    table.insert(WifiTransitions.actions, {
        from = "BeyondFuture",
        to = nil,
        fn = {
            function(event, interface, old_ssid, new_ssid)
                hsAlert.show(string.format(
                                 "Off Home Network - %s, saucing up...",
                                 new_ssid), hsScreen.allScreens(), 3)

                hsAudioDevice.defaultOutputDevice():setOutputMuted(true)
            end
        }
    })
end

return M
