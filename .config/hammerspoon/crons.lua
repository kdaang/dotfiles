local hsPathwatcher = require("hs.pathwatcher")
local hsTimer = require("hs.timer")
local wifiActions = require("wifi-actions")
local caffeine = require("caffeine")
local utils = require("utils")

local M = {}

-- Reload config automatically
M.autoReloadConfig = function()
    local configFileWatcher
    local function reloadConfig()
        configFileWatcher:stop()
        configFileWatcher = nil

        hs.execute("ln -s ~/.config/hammerspoon/* ~/.hammerspoon/")
        hs.reload()
    end

    configFileWatcher = hsPathwatcher.new(
                            os.getenv("HOME") .. "/.config/hammerspoon/",
                            reloadConfig)
    configFileWatcher:start()
end

M.caffeinateJob = function()
    if (utils.isPersonalComputer()) then
        print("not scheduling caffeine job...")
        return
    end

    local START_TIME = utils.getStringTime(utils.getWorkTimeStart())
    local END_TIME = utils.getStringTime(utils.getWorkTimeEnd())

    hsTimer.doAt(START_TIME, hsTimer.days(1), function()
        if (caffeine.shouldCaffeinate()) then
            print("caffeinating...")
            caffeine.setCaffeine(true)
        else
            print("not caffeinating...")
        end
    end)

    hsTimer.doAt(END_TIME, hsTimer.days(1), function()
        print("de-caffeinating...")
        caffeine.setCaffeine(false)
    end)

    print("scheduled caffeine job...")
end

M.runJobs = function()
    M.autoReloadConfig()
    wifiActions.start()

    M.caffeinateJob()
end

return M
