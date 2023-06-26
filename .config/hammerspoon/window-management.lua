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

    hsHotkey.bind({}, "f4", function()
        hs.execute("cw", true)

        -- script returns list of unmanaged windows ids string in csv form
        local output = hs.execute("yabaiw", true)
        local unmanagedWindowIds = {}

        -- split comma separated string
        for unmanagedWindowId in (output .. ","):gmatch("(.-),") do
            unmanagedWindowIds[tonumber(unmanagedWindowId)] = true
        end

        local unmanagedWindows = hsWindow.filter.new(function(window)
            return unmanagedWindowIds[window:id()]
        end):getWindows()

        for _, unmanagedWindow in ipairs(unmanagedWindows) do
            unmanagedWindow:maximize(0)
        end
    end)
end

return M
