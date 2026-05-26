vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("trim-trailing-whitespace", { clear = true }),
  pattern = { "*" },
  command = [[keeppatterns %s/\s\+$//e]], -- keeppatterns: prevents the \s\+$ pattern from being added to the search history.
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
