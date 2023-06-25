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
                hs.alert.show(string.format(
                                  "Off Home Network - %s, saucing up...",
                                  new_ssid), hs.screen.allScreens(), 3)
            end
        }
    })
end

return M
