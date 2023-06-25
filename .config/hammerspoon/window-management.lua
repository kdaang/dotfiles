local hsHotkey = require("hs.hotkey")
local hsAlert = require("hs.alert")
local hsWindow = require("hs.window")

local M = {}

M.setup = function()

    hsHotkey.bind({"cmd", "alt", "ctrl"}, "W",
                  function() hsAlert.show("Hello World!") end)

    hsHotkey.bind({"cmd", "alt"}, "F", function()
        local win = hsWindow.focusedWindow()
        win:maximize(0)
    end)
end

return M
