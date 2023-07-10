local hsSettings = require("hs.settings")
local hsPasteboard = require("hs.pasteboard")
local hsTimer = require("hs.timer")
local hsFnUtils = require("hs.fnutils")

local M = {}

local FREQUENCY = 0.8
local HIST_SIZE = 20

function M:clearAll()
    hsPasteboard.clearContents()
    hsSettings.set(self.key, {})
end

function M:getContents() return self.clipboardHistory end

function M:pasteboardToClipboard(item)
    while (#self.clipboardHistory >= HIST_SIZE) do
        table.remove(self.clipboardHistory, 1)
    end

    local cleanedItem = self.filterFn(item)
    if cleanedItem ~= nil then
        table.insert(self.clipboardHistory, cleanedItem)
        hsSettings.set(self.key, self.clipboardHistory)
    end
end

function M:storeCopy()
    local currentChangeCount = hsPasteboard.changeCount()
    if (currentChangeCount > self.lastChangeCount) then
        local currentClipboard = hsPasteboard.getContents()
        self:pasteboardToClipboard(currentClipboard)
        self.lastChangeCount = currentChangeCount
    end
end

function M:setup(key, filterFn)
    self.key = key
    self.filterFn = filterFn
    self.clipboardHistory = hsFnUtils.filter(hsSettings.get(self.key) or {},
                                             function(item)
        return self.filterFn(item) ~= nil
    end)
    hsSettings.set(self.key, self.clipboardHistory)

    self.lastChangeCount = hsPasteboard.changeCount()

    self.timer = hsTimer.new(FREQUENCY, function() self:storeCopy() end)
    self.timer:start()

    return self
end

M.New = function(key, filterFn) return M:setup(key, filterFn) end

return M
