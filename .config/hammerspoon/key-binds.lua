local hsHotkey = require("hs.hotkey")
local hsAlert = require("hs.alert")
local WM = require("window-management")
local tsApp = require("ts-app")

local M = {}

local hyper = {"cmd", "alt", "ctrl", "shift"}

M.setup = function()

    hsHotkey.bind({"cmd", "alt", "ctrl"}, "W",
                  function() hsAlert.show("Hello World!") end)

    hsHotkey.bind({"cmd", "alt"}, "F", WM.maximizeWindow)

    hsHotkey.bind({}, "f4", WM.configureWindows)

    hsHotkey.bind(hyper, "space", function() tsApp:setup() end)
end

return M
