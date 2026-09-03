-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Don't auto-change cwd to git root — use the directory you opened nvim from

vim.g.root_spec = { "cwd" }

vim.opt.scrolloff = 15
vim.opt.sidescrolloff = 5

vim.opt.list = false --NOTE: disabled
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- auto-session: без localoptions сессия не сохраняет filetype,
-- и после восстановления буфер остаётся без подсветки
vim.opt.sessionoptions:append("localoptions")
