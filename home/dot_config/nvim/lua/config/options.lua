-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local options = {
  -- Set completeopt to have a better completion experience (recommended for hrsh7th/nvim-cmp)
  completeopt = { "menu", "menuone", "noselect" },

  -- Allows neovim to access the system clipboard
  clipboard = "unnamedplus",

  -- Highlight the text line of the cursor
  cursorline = true,

  -- Makes search act like search in modern browsers
  incsearch = true,

  -- Case insensitive searching UNLESS /C or capital in search
  ignorecase = true,
  smartcase = true,

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  list = true,
  listchars = { tab = "» ", trail = "·", nbsp = "␣" },

  -- Enable mouse mode
  mouse = "a",

  -- Show relative line numbers
  number = true,
  relativenumber = true,

  -- Do not display the mode (ie VISUAL, INSERT, etc)
  showmode = false,

  -- Prefer windows splitting to the right (horizontal) or bottom (vertical)
  splitright = true,
  splitbelow = true,

  -- Do not use a swapfile for the buffer
  swapfile = false,

  -- Convert tab to spaces
  expandtab = true,
  tabstop = 2, -- insert 2 spaces for a tab
  shiftwidth = 2, -- the number of spaces inserted for each indentation

  -- Do smart autoindenting when starting a new line
  smartindent = true,

  -- Save undo history
  undofile = true,

  -- 	Minimal number of screen lines to keep above and below the cursor.
  scrolloff = 10,

  -- Set colorscheme
  termguicolors = true,

  -- Displays which-key popup sooner
  timeoutlen = 300,

  -- Decrease update time
  updatetime = 250,

  -- Keep signcolumn on by default
  signcolumn = "yes",

  -- Disable line wrapping
  wrap = false,

  -- bufferline requires "globals" to be included to restore pinned buffers
  sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
