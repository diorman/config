return {
  {
    "romus204/tree-sitter-manager.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",

        -- Go
        "go",
        "gomod",
        "gowork",
        "gosum",

        "html",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "query",
        "ruby",
        "rust",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
      },
      auto_install = false,
      highlight = true,
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if args.match == "ruby" then
            return
          end
          local ok, _ = pcall(vim.treesitter.get_parser, args.buf)
          if ok then
            vim.bo[args.buf].indentexpr = "v:lua.vim.treesitter.indent()"
          end
        end,
      })
    end,
  },
}
