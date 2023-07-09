local utils = require("utils")

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
        color = hs.drawing.color.definedCollections.x11.lightgrey,
        lineSpace = 20.0,
        paragraphSpacing = 20.0
    })
end

function tsApp:getChoices() return self.choices end

function tsApp:init()
    local ts = 1688940114
    print(utils.getFormattedDate(ts, false))
    self.choices = {
        {
            ["text"] = getStyledText(ts),
            ["subText"] = getStyledSubText(
                string.format("UTC: %s\nET: %s",
                              utils.getFormattedDate(ts, false),
                              utils.getFormattedDate(ts, true)))
        }, {
            ["text"] = getStyledText(ts),
            ["subText"] = getStyledSubText(
                string.format("UTC: %s\nET: %s",
                              utils.getFormattedDate(ts, false),
                              utils.getFormattedDate(ts, true)))
        }, {
            ["text"] = getStyledText(ts),
            ["subText"] = getStyledSubText(
                string.format("UTC: %s\nET: %s",
                              utils.getFormattedDate(ts, false),
                              utils.getFormattedDate(ts, true)))
        }, {
            ["text"] = getStyledText(ts),
            ["subText"] = getStyledSubText(
                string.format("UTC: %s\nET: %s",
                              utils.getFormattedDate(ts, false),
                              utils.getFormattedDate(ts, true)))
        }, {
            ["text"] = getStyledText(ts),
            ["subText"] = getStyledSubText(
                string.format("UTC: %s\nET: %s",
                              utils.getFormattedDate(ts, false),
                              utils.getFormattedDate(ts, true)))
        }, {
            ["text"] = getStyledText(ts),
            ["subText"] = getStyledSubText(
                string.format("UTC: %s\nET: %s",
                              utils.getFormattedDate(ts, false),
                              utils.getFormattedDate(ts, true)))
        }, {
            ["text"] = getStyledText(ts),
            ["subText"] = getStyledSubText(
                string.format("UTC: %s\nET: %s",
                              utils.getFormattedDate(ts, false),
                              utils.getFormattedDate(ts, true)))
        }, {
            ["text"] = getStyledText(ts),
            ["subText"] = getStyledSubText(
                string.format("UTC: %s\nET: %s",
                              utils.getFormattedDate(ts, false),
                              utils.getFormattedDate(ts, true)))
        }, {
            ["text"] = getStyledText(ts),
            ["subText"] = getStyledSubText(
                string.format("UTC: %s\nET: %s",
                              utils.getFormattedDate(ts, false),
                              utils.getFormattedDate(ts, true)))
        }
    }

    for _, choice in ipairs(self.choices) do
        choice.subText = choice.subText .. "\n"
    end
end

function tsApp:handleChooserCallback(choice)
    print("callback: " .. hs.inspect(choice))
end

function tsApp:setup()
    self:init()

    self.chooser = hs.chooser.new(function(choice)
        return self:handleChooserCallback(choice)
    end)

    self.chooser:bgDark(true)
    self.chooser:fgColor(hs.drawing.color.definedCollections.x11.cyan)
    self.chooser:rows(20)

    self.chooser:choices(function() return self:getChoices() end)
    self.chooser:show()
end

return tsApp
