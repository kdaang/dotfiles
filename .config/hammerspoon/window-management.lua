require("lib.constants")
local hsWindow = require("hs.window")
local hsInspect = require("hs.inspect")
local hsScreen = require("hs.screen")
local hsSpaces = require("hs.spaces")

local M = {}

local BASH_COMMAND = "/opt/homebrew/bin/bash "

local setupSpaces = function()

    MONITOR_CONFIG = {
        [MONITOR_NAME_1] = {spaceCount = 2},
        [MONITOR_NAME_2] = {spaceCount = 1},
        [MONITOR_NAME_3] = {spaceCount = 1}
    }

    local spaces = hsSpaces.allSpaces()

    print(hsInspect(spaces))
    print("")

    local screens = hsScreen.allScreens()
    print(hsInspect(screens))
    print("monitor count: " .. #screens)
    print("")

    for _, screen in ipairs(screens) do
        print(hsInspect(screen))
        local config = MONITOR_CONFIG[screen:name()]
        local screenSpaces = spaces[screen:getUUID()]
        local spaceCountDiff = #screenSpaces - config.spaceCount
        print("uuid: " .. screen:getUUID())
        print("name: " .. screen:name())
        print("config: " .. hsInspect(config))
        print("screenSpaces: " .. hsInspect(screenSpaces))
        print("spaceCountDiff: " .. spaceCountDiff)
        print("")

        if spaceCountDiff > 0 then
            for i = 1, spaceCountDiff, 1 do
                hsSpaces.removeSpace(screenSpaces[#screenSpaces - i + 1], false)
                print("removing space")
            end
        elseif spaceCountDiff < 0 then
            for _ = 1, math.abs(spaceCountDiff), 1 do
                hsSpaces.addSpaceToScreen(screen, false)
                print("adding space")
            end
        end
    end

    hsSpaces.closeMissionControl()
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
