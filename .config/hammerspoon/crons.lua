local hsPathwatcher = require("hs.pathwatcher")

local M = {}

-- Reload config automatically
M.autoReloadConfig = function()
    local configFileWatcher
    local function reloadConfig()
        configFileWatcher:stop()
        configFileWatcher = nil
        hs.reload()
    end

    configFileWatcher = hsPathwatcher.new(
                            os.getenv("HOME") .. "/.config/hammerspoon/",
                            reloadConfig)
    configFileWatcher:start()
end

M.runJobs = function() M.autoReloadConfig() end

return M
