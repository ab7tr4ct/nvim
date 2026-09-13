-- lua/plugins/go.lua
return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          -- Merged on top of LazyVim's lang.go extra (staticcheck, analyses, hints, etc.)
          settings = {
            gopls = {
              buildFlags = { "-tags=wireinject" },
              analyses = {
                unusedparams = true,
              },
            },
          },
        },
      },
    },
  },

  -- Linting: lang.go extra registers golangcilint; only run it in projects with their own config
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        golangcilint = {
          condition = function(ctx)
            return vim.fs.find(
              { ".golangci.yml", ".golangci.yaml", ".golangci.toml", ".golangci.json" },
              { path = ctx.filename, upward = true }
            )[1]
          end,
        },
      },
    },
  },

  -- Go struct tags
  {
    "fatih/vim-go",
    ft = "go",
    build = ":GoUpdateBinaries",
    config = function()
      -- Disable most vim-go features (we use gopls for LSP)
      vim.g.go_code_completion_enabled = 0
      vim.g.go_def_mapping_enabled = 1
      vim.g.go_doc_keywordprg_enabled = 0
      vim.g.go_template_autocreate = 0

      -- Only enable struct tag features
      vim.g.go_addtags_transform = "snakecase"
      vim.g.go_addtags_skip_unexported = 1
    end,
  },
}
