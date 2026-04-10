return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signs_staged = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    on_attach = function(buffer)
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = "Git: " .. desc })
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          require("gitsigns").nav_hunk("next")
        end
      end, "Next Hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          require("gitsigns").nav_hunk("prev")
        end
      end, "Prev Hunk")

      -- Actions
      map("n", "<leader>ghs", require("gitsigns").stage_hunk, "Stage hunk")
      map("v", "<leader>ghs", function()
        require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage hunk")

      map("n", "<leader>ghr", require("gitsigns").reset_hunk, "Reset hunk")
      map("v", "<leader>ghr", function()
        require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset hunk")

      map("n", "<leader>ghS", require("gitsigns").stage_buffer, "Stage buffer")
      map("n", "<leader>ghu", require("gitsigns").undo_stage_hunk, "Undo stage hunk")
      map("n", "<leader>ghR", require("gitsigns").reset_buffer, "Reset buffer")
      map("n", "<leader>ghp", require("gitsigns").preview_hunk, "Preview hunk")

      map("n", "<leader>gtd", require("gitsigns").toggle_deleted, "Toggle deleted")
      map("n", "<leader>gtb", require("gitsigns").toggle_current_line_blame, "Toggle blame on current line")

      map("n", "<leader>ghb", function()
        require("gitsigns").blame_line({ full = true })
      end, "Blame line")

      map("n", "<leader>ghB", function()
        require("gitsigns").blame()
      end, "Blame Buffer")

      map("n", "<leader>ghd", require("gitsigns").diffthis, "Diff against index")
      map("n", "<leader>ghD", function()
        require("gitsigns").diffthis("@")
      end, "Diff against last commit")
    end,
  },
}
