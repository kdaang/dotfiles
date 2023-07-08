require("utils")
require("hs.ipc")

Clipboard = require("clipboard")
Crons = require("crons")
KeyBinds = require("key-binds")

Caffeine = require("caffeine")

Clipboard.setup()
Crons.runJobs()
KeyBinds.setup()

Caffeine.setup()

--
-- local windows = hs.window.allWindows()
-- for _, window in ipairs(windows) do print(hs.inspect(window)) end
