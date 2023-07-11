local utils = require("utils")
local clipboard = require("clipboard")
local hsDrawing = require("hs.drawing")
local hsStyledText = require("hs.styledtext")
local hsChooser = require("hs.chooser")

local tsApp = {}

local getStyledText = function(text)
    return hsStyledText.new(text, {
        font = {size = 17},
        color = hsDrawing.color.definedCollections.x11.ivory,
        lineSpace = 20.0,
        paragraphSpacing = 20.0
    })
end

local getStyledSubText = function(text)
    return hsStyledText.new(text, {
        font = {size = 15},
        color = hsDrawing.color.definedCollections.x11.darkgrey,
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
                             string.format("UTC: %s\nLocal: %s",
                                           utils.getFormattedDate(ts, false),
                                           utils.getFormattedDate(ts, true))) ..
                             "\n"
        table.insert(choices, choice)
    end

    return choices
end

function tsApp:getChoices()
    local timestamps = self.timestampHistory:getContents()

    print("timestamps~~~")
    print(hs.inspect(timestamps))

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
    if (type(item) ~= "string") then return nil end

    if tonumber(item) ~= nil and (#item == 10 or #item == 13) then
        return item
    end

    return nil
end

function tsApp:init()
    self:setup()
    self.timestampHistory = clipboard.New("ts-app", timestampFilter)

    self.chooser = hsChooser.new(function(choice)
        return self:handleChooserCallback(choice)
    end)

    self.chooser:bgDark(true)
    self.chooser:fgColor(hsDrawing.color.definedCollections.x11.cyan)
    self.chooser:rows(20)

    self.chooser:choices(function() return self:getChoices() end)

    return self
end

function tsApp:trigger()
    local text = utils.getSelectedText()
    if timestampFilter(text) ~= nil then
        self.timestampHistory:saveToHistory(text)
    end

    self.chooser:refreshChoicesCallback()
    self.chooser:show()
end

return tsApp
