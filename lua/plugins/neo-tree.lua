return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.filesystem = opts.filesystem or {}
      opts.filesystem.filtered_items = {
        visible = false,
        hide_dotfiles = true,
        always_show = { ".gitignore" },
      }
      opts.filesystem.window = { position = "float" }
      opts.popup_border_style = "rounded"

      -- neo-tree deletes directories with `rm -rf` and doesn't close buffers inside them.
      -- A buffer left pointing into a deleted dir makes follow_current_file hang the tree scan.
      opts.event_handlers = opts.event_handlers or {}
      table.insert(opts.event_handlers, {
        event = require("neo-tree.events").FILE_DELETED,
        handler = function(path)
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.api.nvim_buf_get_name(buf)
            if name == path or vim.startswith(name, path .. "/") then
              Snacks.bufdelete({ buf = buf })
            end
          end
        end,
      })

      return opts
    end,
  },
}
