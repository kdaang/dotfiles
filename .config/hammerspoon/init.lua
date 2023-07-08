require("lib.constants")
require("hs.ipc")

Clipboard = require("clipboard")
Crons = require("crons")
KeyBinds = require("key-binds")

Caffeine = require("caffeine")
Automation = require("automation")
local hsApplication = require("hs.application")
local utils = require("utils")

local function loadModules()
    Clipboard.setup()
    Crons.runJobs()
    KeyBinds.setup()

    Caffeine.setup()
end

hsApplication.enableSpotlightForNameSearches(true)
loadModules()
-- Automation.run()

--
-- local windows = hs.window.allWindows()
-- for _, window in ipairs(windows) do print(hs.inspect(window)) end
