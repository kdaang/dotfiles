local utils = require("utils")
local clipboard = require("clipboard")

local tsApp = {}

local getStyledText = function(text)
    return hs.styledtext.new(text, {
        font = {size = 17},
        color = hs.drawing.color.definedCollections.x11.ivory,
        lineSpace = 20.0,
        paragraphSpacing = 20.0
    })
end

local getStyledSubText = function(text)
    return hs.styledtext.new(text, {
        font = {size = 15},
        color = hs.drawing.color.definedCollections.x11.darkgrey,
        lineSpace = 20.0,
        paragraphSpacing = 20.0
    })
end

local formatChoices = function(timestamps)
    local choices = {}

    for i = #timestamps, 1, -1 do
        local ts = timestamps[i]
        local choice = {}
        choice.text = getStyledText(ts)
        choice.subText = getStyledSubText(
                             string.format("UTC: %s\nET: %s",
                                           utils.getFormattedDate(ts, false),
                                           utils.getFormattedDate(ts, true))) ..
                             "\n"
        table.insert(choices, choice)
    end

    return choices
end

function tsApp:getChoices()
    local timestamps = self.timestampHistory:getContents()
    print("history: " .. hs.inspect(timestamps))
    return formatChoices(timestamps)
end

function tsApp:setup()
    local ts = 1688940114
    print(utils.getFormattedDate(ts, false))
end

function tsApp:handleChooserCallback(choice)
    print("callback: " .. hs.inspect(choice))
end

local timestampFilter = function(item)
    local ts = tonumber(item)
    if (ts == nil) then return nil end

    if pcall(os.date, "*t", ts) then
        return ts
    elseif pcall(os.date, "*t", ts / 1000) then
        return ts / 1000
    end

    return nil
end

function tsApp:init()
    self:setup()
    self.timestampHistory = clipboard.New("ts-app", timestampFilter)
    print("history: " .. hs.inspect(self.timestampHistory:getContents()))

    self.chooser = hs.chooser.new(function(choice)
        return self:handleChooserCallback(choice)
    end)

    self.chooser:bgDark(true)
    self.chooser:fgColor(hs.drawing.color.definedCollections.x11.cyan)
    self.chooser:rows(20)

    self.chooser:choices(function() return self:getChoices() end)

    return self
end

function tsApp:trigger()
    local text = utils.getSelectedText()
    self.chooser:refreshChoicesCallback()
    self.chooser:show()
end

return tsApp
