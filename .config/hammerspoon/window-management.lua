require("lib.constants")
local hsWindow = require("hs.window")
local hsInspect = require("hs.inspect")
local hsScreen = require("hs.screen")
local hsSpaces = require("hs.spaces")
local hsFnUtils = require("hs.fnutils")
local hsTimer = require("hs.timer")

local M = {}

local BASH_COMMAND = "/opt/homebrew/bin/bash "

local getMonitorConfig = function(screens)
    if #screens == 3 then
        return {
            [MONITOR_NAME_1] = {spaceCount = 2},
            [MONITOR_NAME_2] = {spaceCount = 1},
            [MONITOR_NAME_3] = {spaceCount = 1}
        }
    elseif #screens == 2 then
        local otherScreen = hsFnUtils.find(screens, function(screen)
            return screen:name() ~= MONITOR_NAME_BUILT_IN
        end)
        return {
            [otherScreen:name()] = {spaceCount = 3},
            [MONITOR_NAME_BUILT_IN] = {spaceCount = 1}
        }
    else
        return {[screens[1]:name()] = {spaceCount = 3}}
    end
end

local setupSpaces = function()

    local spaces = hsSpaces.allSpaces()
    local screens = hsScreen.allScreens()
    local monitorConfig = getMonitorConfig(screens)

    -- go to first space to be able to remove spaces starting from the end
    -- cause can't remove space if focused.
    local anySpaceId = spaces[screens[1]:getUUID()][1]
    hsSpaces.gotoSpace(anySpaceId)

    hsTimer.waitUntil(
        function() return hsSpaces.focusedSpace() == anySpaceId end, function()
            for _, screen in ipairs(screens) do
                local config = monitorConfig[screen:name()]
                local screenSpaces = spaces[screen:getUUID()]
                local spaceCountDiff = #screenSpaces - config.spaceCount

                if spaceCountDiff > 0 then
                    for i = 1, spaceCountDiff, 1 do
                        hsSpaces.removeSpace(
                            screenSpaces[#screenSpaces - i + 1], false)
                    end
                elseif spaceCountDiff < 0 then
                    for _ = 1, math.abs(spaceCountDiff), 1 do
                        hsSpaces.addSpaceToScreen(screen, false)
                    end
                end
            end
            hsSpaces.closeMissionControl()
            print("done setting up spaces!")
        end, 0.2)
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
