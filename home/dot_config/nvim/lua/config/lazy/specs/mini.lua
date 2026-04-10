return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      -- mini.ai ===============================================================
      require("mini.ai").setup()

      -- mini.files ============================================================
      require("mini.files").setup()

      vim.keymap.set("n", "-", function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
      end, { desc = "Open file explorer" })

      -- mini.indentscope ======================================================
      require("mini.indentscope").setup({
        draw = {
          animation = require("mini.indentscope").gen_animation.none(),
        },
      })

      -- mini.pairs ============================================================
      require("mini.pairs").setup()

      -- mini.statusline =======================================================
      -- Hack: always show the filename with relative path
      --- @diagnostic disable-next-line: duplicate-set-field
      require("mini.statusline").section_filename = (function()
        local section_filename = require("mini.statusline").section_filename
        return function(args)
          args = vim.tbl_extend("force", args or {}, { trunc_width = math.huge })
          return section_filename(args)
        end
      end)()

      require("mini.statusline").setup()

      -- mini.surround =========================================================
      require("mini.surround").setup()
    end,
  },
}
