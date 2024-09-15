-- needed to get wifi network (https://github.com/Hammerspoon/hammerspoon/issues/3537)
print(require("hs.location").get())

Constants = require("lib.constants")
IPC = require("hs.ipc")

ClipboardHistory = require("clipboard-history")
Crons = require("crons")
KeyBinds = require("key-binds")

Caffeine = require("caffeine")
WindowManagement = require("window-management")
Automation = require("automation")
TSApp = require("ts-app")
local hsApplication = require("hs.application")
local utils = require("utils")

local function loadModules()
	-- ClipboardHistory:setup()
	Crons.runJobs()
	KeyBinds.setup()

	Caffeine.setup()

	-- WindowManagement.setupWindowBorders()

	-- TSApp.setup()
end

hsApplication.enableSpotlightForNameSearches(true)
loadModules()
-- Automation.run()

print("~~~~~~~~~~~")

--------------------------------
-- START VIM CONFIG
--------------------------------
local VimMode = hs.loadSpoon("VimMode")
local vim = VimMode:new()

-- Configure apps you do *not* want Vim mode enabled in
-- For example, you don't want this plugin overriding your control of Terminal
-- vim
vim:disableForApp("zoom.us")
	:disableForApp("Alacritty")
	:disableForApp("Terminal")
	:disableForApp("IntelliJ IDEA")
	:disableForApp("WebStorm")
	:disableForApp("CLion")
	:disableForApp("GoLand")
	:disableForApp("PyCharm")

-- If you want the screen to dim (a la Flux) when you enter normal mode
-- flip this to true.
vim:shouldDimScreenInNormalMode(false)

-- If you want to show an on-screen alert when you enter normal mode, set
-- this to true
vim:shouldShowAlertInNormalMode(true)

-- You can configure your on-screen alert font
vim:setAlertFont("Courier New")

-- Enter normal mode by typing a key sequence
vim:enterWithSequence("hl")

-- if you want to bind a single key to entering vim, remove the
-- :enterWithSequence('jk') line above and uncomment the bindHotKeys line
-- below:
--
-- To customize the hot key you want, see the mods and key parameters at:
--   https://www.hammerspoon.org/docs/hs.hotkey.html#bind
--
-- vim:bindHotKeys({ enter = { {'ctrl'}, ';' } })

--------------------------------
-- END VIM CONFIG
--------------------------------
