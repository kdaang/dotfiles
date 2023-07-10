Constants = require("lib.constants")
IPC = require("hs.ipc")

ClipboardHistory = require("clipboard-history")
Crons = require("crons")
KeyBinds = require("key-binds")

Caffeine = require("caffeine")
Automation = require("automation")
TSApp = require("ts-app")
local hsApplication = require("hs.application")
local utils = require("utils")

local function loadModules()
    ClipboardHistory.setup()
    Crons.runJobs()
    KeyBinds.setup()

    Caffeine.setup()
    -- TSApp.setup()
end

hsApplication.enableSpotlightForNameSearches(true)
loadModules()
-- Automation.run()

--
local screens = hs.screen.allScreens()
for _, screen in ipairs(screens) do
    print(hs.inspect(screen))
    print("uuid: " .. screen:getUUID())
    print("name: " .. screen:name())
    print("")
end
