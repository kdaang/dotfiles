local hsHotkey = require("hs.hotkey")
local hsAlert = require("hs.alert")
local WM = require("window-management")

local M = {}

M.setup = function()

    hsHotkey.bind({"cmd", "alt", "ctrl"}, "W",
                  function() hsAlert.show("Hello World!") end)

    hsHotkey.bind({"cmd", "alt"}, "F", WM.maximizeWindow)

    hsHotkey.bind({}, "f4", WM.configureWindows)
end

return M
