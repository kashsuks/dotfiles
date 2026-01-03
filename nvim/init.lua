local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.wo.relativenumber = true

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("lazy").sync()
  end,
})

vim.g.lazyvim_check_order = false 

require("plugins.init")

require("notify").setup({
  background_colour = "#000000"
})