local hsCaffeine = require("hs.caffeinate")
local hsMenubar = require("hs.menubar")
local utils = require("utils")

local M = {}

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

M.setCaffeine = function(enabled)
    hsCaffeine.set("displayIdle", enabled, false)
    setCaffeineDisplay(hsCaffeine.get("displayIdle"))
end

M.shouldCaffeinate = function()
    return (not utils.isPersonalComputer()) and utils.onHomeNetwork() and
               utils.isWorkingTime()
end

M.setup = function()
    if caffeine then
        caffeine:setClickCallback(caffeineClicked)
        M.setCaffeine(M.shouldCaffeinate())
    end

    print("done running caffeine setup!")
end

return M
