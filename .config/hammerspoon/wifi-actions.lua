require("lib.constants")
local hsAlert = require("hs.alert")
local hsScreen = require("hs.screen")
local automation = require("automation")

WifiTransitions = require("external.wifi-transitions")
M = {}

local wifiActions = {
    {
        from = HOME_NETWORK_NAME,
        to = nil,
        fn = {
            function(event, interface, old_ssid, new_ssid)
                hsAlert.show(string.format(
                                 "Off Home Network - %s, cooling down...",
                                 new_ssid), hsScreen.allScreens(), 3)

                automation.run()
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

                automation.run()
            end
        }
    }
}

M.start = function()
    WifiTransitions.logger.setLogLevel(5)
    WifiTransitions:start()

    for _, wifiAction in ipairs(wifiActions) do
        table.insert(WifiTransitions.actions, wifiAction)
    end
end

return M
