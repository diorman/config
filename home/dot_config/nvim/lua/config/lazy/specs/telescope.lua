return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
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
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "**/node_modules/*",
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
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current word" })
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
