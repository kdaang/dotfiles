local hsCaffeine = require("hs.caffeinate")
local hsMenubar = require("hs.menubar")

local M = {}

M.setup = function()
    local caffeine = hsMenubar.new()

    local function setCaffeineDisplay(state)
        if state then
            caffeine:setTitle("🤔")
        else
            caffeine:setTitle("💤")
        end
    end

    local function caffeineClicked()
        setCaffeineDisplay(hsCaffeine.toggle("displayIdle"))
    end

    if caffeine then
        caffeine:setClickCallback(caffeineClicked)
        hsCaffeine.set("displayIdle", false, false)
        setCaffeineDisplay(hsCaffeine.get("displayIdle"))
    end
end

return M
