local function setup()
  local bufferline = require("bufferline")

  bufferline.setup({
    options = {
      style_preset = bufferline.style_preset.no_italic,
      numbers = function(args)
        return args["ordinal"] .. ":"
      end,
      show_buffer_icons = false,
      show_buffer_close_icons = false,
    },
  })

  vim.keymap.set("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Buffer: Switch to alternate" })
  vim.keymap.set("n", "<leader>bq", "<cmd>bd<cr>", { desc = "Buffer: Close current" })

  vim.keymap.set("n", "<leader>bo", function()
    local current = vim.api.nvim_get_current_buf()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if bufnr ~= current then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
      end
    end
  end, { desc = "Buffer: Close others" })

  vim.keymap.set("n", "<leader>baq", function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
    end
  end, { desc = "Buffer: Close all" })

  vim.keymap.set("n", "<leader>bl", function()
    require("telescope.builtin").buffers()
  end, { desc = "Buffer: List" })

  for n = 1, 9 do
    vim.keymap.set("n", "<leader>" .. n, function()
      bufferline.go_to(n, true)
    end, { desc = "Buffer: Go to " .. n })
  end
end

return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      setup()
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "Harpoon: Add file" })

      vim.keymap.set("n", "<leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon: Toggle menu" })

      vim.keymap.set("n", "<leader>h1", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon: Go to file 1" })

      vim.keymap.set("n", "<leader>h2", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon: Go to file 2" })

      vim.keymap.set("n", "<leader>h3", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon: Go to file 3" })

      vim.keymap.set("n", "<leader>h4", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon: Go to file 4" })
    end,
  },
}
