local hsWindow = require("hs.window")

local M = {}

M.maximizeWindow = function()
    local win = hsWindow.focusedWindow()
    win:maximize(0)
end

M.configureWindows = function()
    local BASH_COMMAND = "/opt/homebrew/bin/bash "
    hs.execute(BASH_COMMAND .. "~/bin/yabaiw configure_workspace", false)

    -- script returns list of unmanaged windows ids string in csv form
    local output = hs.execute(BASH_COMMAND ..
                                  "~/bin/yabaiw get_unmanaged_windows", false)
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
end

return M
