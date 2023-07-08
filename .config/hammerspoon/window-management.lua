require("lib.constants")
local hsWindow = require("hs.window")

local M = {}

local BASH_COMMAND = "/opt/homebrew/bin/bash "

local setupSpaces = function()

    MONITOR_CONFIG = {
        [MONITOR_NAME_1] = {spaceCount = 2},
        [MONITOR_NAME_2] = {spaceCount = 1},
        [MONITOR_NAME_3] = {spaceCount = 1}
    }

    local spaces = hs.spaces.allSpaces()

    print(hs.inspect(spaces))
    print("")

    local screens = hs.screen.allScreens()
    print(hs.inspect(screens))
    print("monitor count: " .. #screens)
    print("")

    for _, screen in ipairs(screens) do
        print(hs.inspect(screen))
        local config = MONITOR_CONFIG[screen:name()]
        local screenSpaces = spaces[screen:getUUID()]
        local totalSpacesToRemove = #screenSpaces - config.spaceCount
        print("uuid: " .. screen:getUUID())
        print("name: " .. screen:name())
        print("config: " .. hs.inspect(config))
        print("screenSpaces: " .. hs.inspect(screenSpaces))
        print("totalSpacesToRemove: " .. totalSpacesToRemove)
        print("")

        for i = 1, totalSpacesToRemove + 1, 1 do
            hs.spaces.removeSpace(screenSpaces[i], true)
        end
    end
end

local maximizeUnmangedWindows = function()
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

M.setupSpaces = setupSpaces

M.maximizeWindow = function()
    local win = hsWindow.focusedWindow()
    win:maximize(0)
end

M.configureWindows = function()
    setupSpaces()

    hs.execute(BASH_COMMAND .. "~/bin/yabaiw configure_workspace", false)

    maximizeUnmangedWindows()

    print("done configuring windows!")
end

return M
