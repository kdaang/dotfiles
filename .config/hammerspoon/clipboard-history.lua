local clipboard = require("clipboard")
local hsEventTap = require("hs.eventtap")

local M = {}

local LABEL_LENGTH = 40 -- How wide (in characters) the dropdown menu should be. Copies larger than this will have their label truncated and end with "…" (unicode for elipsis ...)

local jumpcut = require("hs.menubar").new()
jumpcut:setTooltip("Jumpcut replacement")

function M:isDirectPasteMode(key) return key.alt == true end

function M:setTitle()
    if (#self.clipboardHistory:getContents() == 0) then
        jumpcut:setTitle("✂") -- Unicode magic
    else
        jumpcut:setTitle("✂ (" .. #self.clipboardHistory:getContents() .. ")") -- updates the menu counter
    end
end

function M:clearAll()
    self.clipboardHistory = {}
    self.clipboardHistory:clearAll()
    self:setTitle()
end

function M:handleOnClick(value, keyPressed)
    if (self:isDirectPasteMode(keyPressed)) then -- direcly type text when alt is clicked (must be before clicking menu item)
        hsEventTap.keyStrokes(string)
    else
        self.clipboardHistory:pasteToClipboard(value)
    end
end

function M:populateMenu(key)
    self:setTitle()
    local menuData = {}

    if (#self.clipboardHistory:getContents() == 0) then
        table.insert(menuData, {title = "None", disabled = true})
    else
        for _, v in pairs(self.clipboardHistory:getContents()) do
            local handleClick = function() self:handleOnClick(v, key) end

            local title = v
            if (string.len(v) > LABEL_LENGTH) then
                title = string.sub(v, 0, LABEL_LENGTH) .. "…"
            end

            table.insert(menuData, 1, {title = title, fn = handleClick})
        end
    end

    -- footer
    table.insert(menuData, {title = "-"})
    table.insert(menuData,
                 {title = "Clear All", fn = function() self:clearAll() end})

    if (self:isDirectPasteMode(key)) then
        table.insert(menuData, {title = "Direct Paste Mode", disabled = true})
    end

    return menuData
end

function M:setup()
    self.clipboardHistory = clipboard.New("clipboard-history", nil, 80)

    self:setTitle()
    jumpcut:setMenu(function(key) return self:populateMenu(key) end)
end

return M
