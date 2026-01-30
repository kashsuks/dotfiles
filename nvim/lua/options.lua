require "nvchad.options"

-- ================================
-- Your custom options
-- ================================

-- Show cursor line highlight on both number + text
vim.o.cursorlineopt = "both"

-- --------------------------------
-- Line numbers (NvChad-safe)
-- --------------------------------
-- number & relativenumber are WINDOW-LOCAL options.
-- NvChad/plugins may reset them when windows are created,
-- so we enforce them on window enter.

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})
