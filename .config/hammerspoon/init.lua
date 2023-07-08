require("utils")
require("hs.ipc")

Crons = require("crons")
Clipboard = require("clipboard")
WindowManagement = require("window-management")
WifiActions = require("wifi-actions")
Caffeine = require("caffeine")

Clipboard.setup()
WindowManagement.setup()
WifiActions.setup()
Caffeine.setup()
Crons.runJobs()

--
-- local windows = hs.window.allWindows()
-- for _, window in ipairs(windows) do print(hs.inspect(window)) end
