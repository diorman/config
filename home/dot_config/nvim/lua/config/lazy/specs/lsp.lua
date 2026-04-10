return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
    opts = {
      keymap = { preset = "default" },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Go
        gopls = {},

        -- TypeScript
        ts_ls = {},
        eslint = {},

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },

        -- Ruby
        ruby_lsp = {},
        rubocop = {},
      },
    },
    dependencies = {
      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function(_, opts)
      -- Change diagnostic symbols in the sign column (gutter)
      local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
      local diagnostic_signs = {}
      for type, icon in pairs(signs) do
        diagnostic_signs[vim.diagnostic.severity[type]] = icon
      end
      vim.diagnostic.config({ signs = { text = diagnostic_signs } })

      local on_attach = function(client, bufnr)
        -- Set up keymaps
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map("gd", require("telescope.builtin").lsp_definitions, "Go to definition")

        -- Find references for the word under your cursor.
        map("gr", require("telescope.builtin").lsp_references, "Go to references")

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map("gI", require("telescope.builtin").lsp_implementations, "Go to implementation")

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type definition")

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document symbols")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace symbols")

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map("<leader>rn", vim.lsp.buf.rename, "Rename")

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map("gD", vim.lsp.buf.declaration, "Go to declaration")

        -- See `:help K` for why this keymap
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

        -- Diagnostics
        map("[d", vim.diagnostic.goto_prev, "Move to previous diagnostic")
        map("]d", vim.diagnostic.goto_next, "Move to next diagnostic")
        map("<leader>e", vim.diagnostic.open_float, "Show diagnostics in a floating window")
        map("<leader>q", vim.diagnostic.setloclist, "Show diagnostics in a quickfix list")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("config-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("config-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "config-lsp-highlight", buffer = event2.buf })
            end,
          })
        end
      end

      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities or {})
        config.on_attach = on_attach
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      format_on_save = function()
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        typescript = { "prettierd" },
      },
    },
  },
}
