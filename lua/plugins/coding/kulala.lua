return {
  "mistweaverco/kulala.nvim",
  keys = {
    {
      "<leader>rs",
      function()
        require("kulala").run()
      end,
      desc = "Send request",
      ft = "http",
    },
    {
      "<leader>ra",
      function()
        require("kulala").run_all()
      end,
      desc = "Send all requests",
      ft = "http",
    },
    {
      "<leader>ro",
      function()
        require("kulala").open()
      end,
      desc = "Open response",
      ft = "http",
    },
    {
      "<leader>ri",
      function()
        require("kulala").inspect()
      end,
      desc = "Inspect request",
      ft = "http",
    },
    {
      "<leader>rc",
      function()
        require("kulala").copy()
      end,
      desc = "Copy as cURL",
      ft = "http",
    },
    -- No ft: usable from any buffer, and they load the plugin on demand.
    {
      "<leader>rn",
      function()
        require("kulala").scratchpad()
      end,
      desc = "New scratchpad (unsaved, use :sav <name>)",
    },
    {
      "<leader>rN",
      function()
        local name = vim.fn.input("New .http file: ", "api.http")
        if name == "" then
          return
        end
        if not name:match("%.http$") then
          name = name .. ".http"
        end

        vim.cmd("edit " .. vim.fn.fnameescape(name))

        -- Seed the template into a new empty file only; never touch existing content.
        if vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_get_current_line() == "" then
          local ok, config = pcall(require, "kulala.config")
          local template = ok and config.get().scratchpad_default_contents
            or { "@base = http://localhost:8080", "", "### ", "GET {{base}}/" }
          vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
        end
      end,
      desc = "New .http file",
    },
    {
      "<leader>rp",
      function()
        require("kulala").replay()
      end,
      desc = "Replay last request",
    },
    {
      "<leader>rS",
      function()
        require("kulala").search()
      end,
      desc = "Search requests",
    },
    {
      "<leader>rf",
      function()
        require("kulala").from_curl()
      end,
      desc = "Paste from cURL",
    },
    {
      "<leader>re",
      function()
        require("kulala").set_selected_env()
      end,
      desc = "Select environment",
      ft = "http",
    },
    {
      "<leader>rt",
      function()
        require("kulala").toggle_view()
      end,
      desc = "Toggle body/headers",
      ft = "http",
    },
    {
      "[r",
      function()
        require("kulala").jump_prev()
      end,
      desc = "Previous request",
      ft = "http",
    },
    {
      "]r",
      function()
        require("kulala").jump_next()
      end,
      desc = "Next request",
      ft = "http",
    },
  },
  ft = { "http", "rest" },
  opts = {
    ui = {
      display_mode = "float",
    },
    -- Template for <leader>rn and <leader>rN.
    -- The cheatsheet lives above the first "###" on purpose: after a "###" it
    -- would parse as a block of its own and run_all would fire "GET /".
    -- "@" never follows "# " directly, otherwise it reads as a meta tag.
    scratchpad_default_contents = {
      "# ── cheatsheet ───────────────────────────────────────────",
      "# keys:  rs send · ra send all · ro response · ri inspect",
      "#        rc copy as cURL · rf paste from cURL · rp replay",
      "#        rS search · re environment · rt body/headers",
      "#        rn scratchpad · rN new file · [r ]r jump",
      "#",
      "# variables:  declare '@name = value', use {{name}}",
      "# dynamic:    {{$uuid}} {{$timestamp}} {{$isoTimestamp}}",
      "#             {{$randomInt}} {{$date}}",
      "# from response:  {{request_name.response.body.$.field}}",
      "# environments:   http-client.env.json, http-client.private.env.json, .env",
      "#",
      "# meta tags:  '@name id' · '@timeout 5' · '@jq .items[0]'",
      "#             '@graphql' · '@stdin-cmd' · '@env-stdin-cmd'",
      "#             '@env-json-key' · '@env-header-key'",
      "# run:        a line 'run #name' or 'run ./other.http'",
      "# shared:     name a request KULALA_SHARED or KULALA_SHARED_EACH",
      "# scripts:    '< {% js %}' before, '> {% js %}' after",
      "# ─────────────────────────────────────────────────────────",
      "",
      "@base = http://localhost:8080",
      "@token = dev-token",
      "",
      "###",
      "# @name list",
      "GET {{base}}/api/items",
      "Accept: application/json",
      "",
      "###",
      "# @name create",
      "POST {{base}}/api/items",
      "Content-Type: application/json",
      "Authorization: Bearer {{token}}",
      "",
      "{",
      '  "id": "{{$uuid}}",',
      '  "name": "item-{{$timestamp}}"',
      "}",
      "",
      "### id is taken from the response above",
      "GET {{base}}/api/items/{{create.response.body.$.id}}",
      "Authorization: Bearer {{token}}",
      "",
      "###",
      "DELETE {{base}}/api/items/1",
      "Authorization: Bearer {{token}}",
    },
  },
}
