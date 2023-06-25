local hsHotkey = hs.hotkey
local hsAlert = hs.hotkey
local hsWindow = hs.hotkey

hsHotkey.bind({"cmd", "alt", "ctrl"}, "W",
              function() hsAlert.show("Hello World!") end)

hsHotkey.bind({"cmd", "alt"}, "F", function()
    local win = hsWindow.focusedWindow()
    win:maximize(0)
end)

Clipboard = require("clipboard")
Clipboard.setup()
