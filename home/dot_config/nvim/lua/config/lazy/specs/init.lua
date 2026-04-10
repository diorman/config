return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      flavour = "frappe",
    },
    init = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope = { enabled = false },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {},
  },
  {
    "folke/persistence.nvim",
    config = function()
      require("persistence").setup()

      -- load the session for the current directory
      vim.keymap.set("n", "<leader>ql", require("persistence").load, { desc = "Restore session" })
    end,
  },
  {
    "folke/snacks.nvim",
    config = function()
      require("snacks").setup({ lazygit = {} })

      vim.keymap.set("n", "<leader>gg", require("snacks").lazygit.open, { desc = "Git: UI" })
      vim.keymap.set("n", "<leader>gf", require("snacks").lazygit.log_file, { desc = "Git: File log" })
      vim.keymap.set("n", "<leader>gl", require("snacks").lazygit.log, { desc = "Git: Log" })
    end,
  },
}
