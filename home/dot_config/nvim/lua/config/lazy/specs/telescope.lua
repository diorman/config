return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
  },
  config = function()
    local layout_actions = require("telescope.actions.layout")

    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "%.git/",
        },

        preview = {
          hide_on_startup = true,
        },

        mappings = {
          i = { ["<C-x>"] = layout_actions.toggle_preview },
          n = { ["<C-x>"] = layout_actions.toggle_preview },
        },

        layout_strategy = "horizontal",
        layout_config = {
          width = 0.95,
          height = 0.95,
          preview_width = 0.6,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Search select telescope" })
    vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "Search current word" })
    vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "Search commands" })

    vim.keymap.set("n", "<leader>sb", builtin.git_branches, { desc = "Search git branches" })
    vim.keymap.set("n", "<leader>sm", builtin.git_status, { desc = "Search git modified files" })
    vim.keymap.set("n", "<leader>sH", builtin.git_bcommits, { desc = "Search git history (current buffer)" })
    vim.keymap.set("n", "<leader>sC", builtin.git_commits, { desc = "Search git commits" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by grep" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Search resume" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = 'Search recent files ("." for repeat)' })

    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live grep in open files",
      })
    end, { desc = "Search [/] in open files" })
  end,
}
