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
    local mainScreen = hsFnUtils.find(screens, function(screen)
        return screen:name() == MONITOR_NAME_MAIN
    end) or hsFnUtils.find(screens, function(screen)
        return screen:name() ~= MONITOR_NAME_BUILT_IN
    end) or screens[1]

    -- yabaiw expects 4 spaces with 3+ displays (main has 2), otherwise 3 on main
    local mainSpaceCount = #screens >= 3 and 2 or 3
    if #screens == 1 then mainSpaceCount = 3 end

    local config = {}
    for _, screen in ipairs(screens) do
        config[screen:name()] = {spaceCount = 1}
    end
    config[mainScreen:name()] = {spaceCount = mainSpaceCount}
    return config
end

local setupSpaces = function()
    local spaces = hsSpaces.allSpaces()
    local activeSpaces = hsSpaces.activeSpaces()
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
                -- the visible space on each screen cannot be deleted
                if spaceID ~= activeSpaces[screen:getUUID()] then
                    local isRemoved, errMsg =
                        hsSpaces.removeSpace(spaceID, false)
                    if isRemoved then
                        i = i - 1
                    else
                        print("removing space error: " .. tostring(errMsg))
                    end
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
        local id = tonumber(unmanagedWindowId)
        if id then unmanagedWindowIds[id] = true end
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
