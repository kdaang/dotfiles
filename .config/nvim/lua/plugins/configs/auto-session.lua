local present, auto_session = pcall(require, "auto-session")

if not present then
    return
end

local options = {
}

options = require("core.utils").load_override(options, "auto_session")

auto_session.setup(options)
