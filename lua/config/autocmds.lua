-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Страховка от «сессия законсервировала пустой filetype».
-- Если restore оставил буфер с файлом, но без filetype, сессия при следующем
-- сохранении запишет `setlocal filetype=` и поломка станет самовоспроизводящейся.
-- Досматриваем буферы после загрузки сессии и доопределяем тип принудительно.
vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = vim.api.nvim_create_augroup("kick_filetype_after_session", { clear = true }),
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_loaded(buf)
        and vim.bo[buf].buftype == ""
        and vim.bo[buf].filetype == ""
        and vim.api.nvim_buf_get_name(buf) ~= ""
      then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("filetype detect")
        end)
      end
    end
  end,
})
