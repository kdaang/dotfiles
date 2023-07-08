local hsPathwatcher = require("hs.pathwatcher")
local WifiActions = require("wifi-actions")

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

M.caffeinate = function() end

M.runJobs = function()
    M.autoReloadConfig()
    WifiActions.start()
end

return M
