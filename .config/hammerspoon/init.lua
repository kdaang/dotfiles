require("lib.constants")
require("hs.ipc")

Clipboard = require("clipboard")
Crons = require("crons")
KeyBinds = require("key-binds")

Caffeine = require("caffeine")
Automation = require("automation")

local function loadModules()
    Clipboard.setup()
    Crons.runJobs()
    KeyBinds.setup()

    Caffeine.setup()
end

loadModules()
-- Automation.init()

--
-- local windows = hs.window.allWindows()
-- for _, window in ipairs(windows) do print(hs.inspect(window)) end
