---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "catppuccin",
	theme_toggle = { "catppuccin", "catppuccin" },
	transparency = false,
}

-- Disable NvChad theme to use custom colorscheme
M.ui = {
	theme = "blueberry", -- This won't work with base46
}

return M