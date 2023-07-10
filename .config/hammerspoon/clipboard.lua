local hsSettings = require("hs.settings")
local hsPasteboard = require("hs.pasteboard")
local hsTimer = require("hs.timer")
local hsFnUtils = require("hs.fnutils")

local C = {}

C.New = function(key, filterFn, historySize)
    local M = {}
    local FREQUENCY = 0.8
    local HIST_SIZE = historySize or 20

    function M:clearAll()
        hsPasteboard.clearContents()
        hsSettings.set(self.key, {})
    end

    function M:insertItem(item)
        table.insert(self.clipboardHistory, item)
        hsSettings.set(self.key, self.clipboardHistory)
    end

    function M:removeOldestItem()
        table.remove(self.clipboardHistory, 1)
        hsSettings.set(self.key, self.clipboardHistory)
    end

    function M:getContents() return self.clipboardHistory end

    function M:getHistory() return hsSettings.get(self.key) or {} end

    function M:saveToHistory(item)
        while (#self.clipboardHistory >= HIST_SIZE) do
            self:removeOldestItem()
        end

        local cleanedItem = item
        if (self.filterFn ~= nil) then cleanedItem = self.filterFn(item) end

        if cleanedItem ~= nil then self:insertItem(cleanedItem) end
    end

    function M:pasteToClipboard(value)
        hsPasteboard.setContents(value)
        self.lastChangeCount = hsPasteboard.changeCount()
    end

    function M:storeCopy()
        local currentChangeCount = hsPasteboard.changeCount()
        if (currentChangeCount > self.lastChangeCount) then
            local currentClipboard = hsPasteboard.getContents()
            self:saveToHistory(currentClipboard)
            self.lastChangeCount = currentChangeCount
        end
    end

    function M:setup(key, filterFn)
        self.key = key
        self.filterFn = filterFn
        self.clipboardHistory = hsFnUtils.filter(self:getHistory(),
                                                 function(item)
            if self.filterFn ~= nil then
                return self.filterFn(item) ~= nil
            end
            return true
        end)
        hsSettings.set(self.key, self.clipboardHistory)

        self.lastChangeCount = hsPasteboard.changeCount()

        self.timer = hsTimer.new(FREQUENCY, function() self:storeCopy() end)
        self.timer:start()

        return self
    end

    return M:setup(key, filterFn)
end

return C
