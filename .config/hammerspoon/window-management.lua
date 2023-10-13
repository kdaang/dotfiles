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

    for _, screen in ipairs(screens) do
        local config = monitorConfig[screen:name()]
        local screenSpaces = spaces[screen:getUUID()]
        local spaceCountDiff = #screenSpaces - config.spaceCount

        if spaceCountDiff > 0 then
            local i = spaceCountDiff
            for _, spaceID in ipairs(screenSpaces) do
                if i == 0 then break end
                -- this is done to ensure the right number of spaces can be deleted since a focused space cannot be deleted
                if spaceID ~= hsSpaces.focusedSpace() then
                    local isRemoved, errMsg =
                        hsSpaces.removeSpace(spaceID, false)
                    print("removing space error: " .. errMsg)
                    if (isRemoved) then i = i - 1 end
                end
            end
        elseif spaceCountDiff < 0 then
            for _ = 1, math.abs(spaceCountDiff), 1 do
                hsSpaces.addSpaceToScreen(screen, false)
            end
        end
    end
    hsSpaces.closeMissionControl()
    print("done setting up spaces!")

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
    -- KNOWN LIMITATION: sometimes windows don't properly move to the correct space if the window is off screen.
    setupSpaces()
    hs.execute(BASH_COMMAND .. "~/bin/yabaiw configure_workspace", false)

    hsTimer.usleep(300000) -- adding delay cause sometimes windows don't maximize but adding delay seems to help
    maximizeUnmangedWindows()

    print("done configuring windows!")
end

M.setupWindowBorders = function()

    hs.window.highlight.ui.overlay = true
    hs.window.highlight.ui.overlayColor = {1, 1, 1, 0.00000000001}
    hs.window.highlight.ui.frameWidth = 10
    hs.window.highlight.ui.frameColor = {0, 1, 1, 0.5}

    hs.window.highlight.start()

    print("done configuring windows!")
end

return M
