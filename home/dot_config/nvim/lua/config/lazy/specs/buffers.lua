local buffers = (function()
  local callbacks = { change = {} }

  local function invoke_callbacks(cbs)
    for _, cb in ipairs(cbs) do
      cb()
    end
  end

  local function close_buffers(bufnrs, opts)
    opts = opts or { force = false }
    for _, bufnr in ipairs(bufnrs) do
      pcall(vim.api.nvim_buf_delete, bufnr, opts)
    end
    invoke_callbacks(callbacks.change)
  end

  --------------------
  -- Pinned buffers
  --------------------
  local pinned = { global_key = "PinnedBuffers", buffers = {} }

  function pinned.bufnrs()
    local t = {}
    for bufnr in pairs(pinned.buffers) do
      if vim.api.nvim_buf_is_valid(bufnr) then
        table.insert(t, bufnr)
      end
    end
    return t
  end

  function pinned.persist()
    local t = {}

    for _, bufnr in ipairs(pinned.bufnrs()) do
      table.insert(t, vim.api.nvim_buf_get_name(bufnr))
    end

    if #t == 0 then
      vim.g[pinned.global_key] = ""
    else
      vim.g[pinned.global_key] = table.concat(t, ",")
    end
  end

  function pinned.restore()
    if not vim.g[pinned.global_key] or vim.g[pinned.global_key] == "" then
      return
    end

    local names = vim.split(vim.g[pinned.global_key], ",") or {}

    for _, name in ipairs(names) do
      local bufnr = vim.fn.bufnr(name)
      if bufnr ~= -1 then
        pinned.add(bufnr)
      end
    end
  end

  function pinned.include(bufnr)
    return pinned.buffers[bufnr] == true
  end

  function pinned.length()
    return #pinned.bufnrs()
  end

  function pinned.add(bufnr)
    if pinned.buffers[bufnr] then
      return
    end

    pinned.buffers[bufnr] = true
    pinned.persist()
    invoke_callbacks(callbacks.change)
  end

  function pinned.remove(bufnr)
    if not pinned.buffers[bufnr] then
      return
    end

    pinned.buffers[bufnr] = nil
    pinned.persist()
    invoke_callbacks(callbacks.change)
  end

  function pinned.reset()
    pinned.buffers = {}
    invoke_callbacks(callbacks.change)
  end

  function pinned.close_unpinned(opts)
    opts = opts or {}
    local bufnrs = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if not pinned.include(bufnr) then
        table.insert(bufnrs, bufnr)
      end
    end
    close_buffers(bufnrs, opts)
  end

  return {
    pinned = pinned,
    close_all = function(opts)
      close_buffers(vim.api.nvim_list_bufs(), opts)
    end,

    close_others = function(opts)
      opts = opts or { force = false }
      local current_bufnr = vim.api.nvim_get_current_buf()
      local bufnrs = {}

      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if bufnr ~= current_bufnr then
          table.insert(bufnrs, bufnr)
        end
      end

      close_buffers(bufnrs, opts)
    end,

    on_change = function(cb)
      table.insert(callbacks.change, cb)
    end,
  }
end)()

local function setup()
  buffers.on_change(require("bufferline.ui").refresh)

  local bufferline = require("bufferline")

  bufferline.setup({
    options = {
      style_preset = require("bufferline").style_preset.no_italic,
      numbers = function(args)
        return args["ordinal"] .. ":"
      end,
      show_buffer_icons = false,
      show_buffer_close_icons = false,
      groups = {
        items = {
          {
            name = "PINNED_BUFFERS",
            auto_close = false, -- whether or not close this group if it doesn't contain the current buffer
            priority = 1,
            icon = "󰐃",
            matcher = function(buf)
              return buffers.pinned.include(buf.id)
            end,
            separator = {
              style = bufferline.groups.separator.none,
            },
          },
        },
      },
    },
  })

  vim.keymap.set("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Buffer: Switch to alternate" })

  vim.keymap.set("n", "<leader>bq", "<cmd>bd<cr>", { desc = "Buffer: Close current" })

  vim.keymap.set("n", "<leader>bo", buffers.close_others, { desc = "Buffer: Close others" })

  vim.keymap.set("n", "<leader>baq", buffers.close_all, { desc = "Buffer: Close all" })

  vim.keymap.set("n", "<leader>buq", buffers.pinned.close_unpinned, { desc = "Buffer: Close unpinned" })

  vim.keymap.set("n", "<leader>buQ", function()
    buffers.pinned.close_unpinned({ force = true })
  end, { desc = "Buffer: Close unpinned ignoring changes" })

  vim.keymap.set("n", "<leader>bR", buffers.pinned.reset, { desc = "Buffer: Unpin all" })

  for n = 1, 9 do
    vim.keymap.set("n", "<leader>" .. n, function()
      bufferline.go_to(n, true)
    end, { desc = "Buffer: Go to " .. n })
  end

  vim.keymap.set("n", "<leader>bm0", function()
    if buffers.pinned.include(vim.api.nvim_get_current_buf()) then
      bufferline.move_to(1)
    else
      bufferline.move_to(buffers.pinned.length() + 1)
    end
  end, { desc = "Buffer: Move to first" })

  vim.keymap.set("n", "<leader>bm$", function()
    if buffers.pinned.include(vim.api.nvim_get_current_buf()) then
      bufferline.move_to(buffers.pinned.length())
    else
      bufferline.move_to(-1)
    end
  end, { desc = "Buffer: Move to last" })

  for n = 1, 9 do
    vim.keymap.set("n", "<leader>bm" .. n, function()
      local lo = 1
      local hi = #bufferline.get_elements().elements

      if buffers.pinned.include(vim.api.nvim_get_current_buf()) then
        hi = buffers.pinned.length()
      else
        lo = buffers.pinned.length() + 1
      end

      if n < lo or n > hi then
        vim.notify("Buffer position out of range", vim.log.levels.ERROR)
        return
      end

      bufferline.move_to(n)
    end, { desc = "Buffer: Move to " .. n })
  end

  vim.keymap.set("n", "<leader>bp", function()
    local bufnr = vim.api.nvim_get_current_buf()

    if buffers.pinned.include(bufnr) then
      buffers.pinned.remove(bufnr)
      bufferline.move_to(buffers.pinned.length() + 1)
    else
      buffers.pinned.add(bufnr)
      bufferline.move_to(buffers.pinned.length())
    end
  end, { desc = "Buffer: Toggle pin" })

  local function telescope_buffers(pinned_only)
    local buffs = {}
    local max_bufnr = 0

    for index, buffer in ipairs(bufferline.get_elements().elements) do
      buffs[buffer.id] = { index = index, is_pinned = buffers.pinned.include(buffer.id) }
      max_bufnr = math.max(max_bufnr, buffer.id)
    end

    local default_entry_maker = require("telescope.make_entry").gen_from_buffer({ bufnr_width = #tostring(max_bufnr) })

    require("telescope.builtin").buffers({
      entry_maker = function(entry)
        if pinned_only and not buffs[entry.bufnr].is_pinned then
          return nil
        end

        return default_entry_maker(entry)
      end,
      -- not available in the 1.0.x branch yet
      sort_buffers = function(bufnr_a, bufnr_b)
        return buffs[bufnr_a].index < buffs[bufnr_b].index
      end,
    })
  end

  vim.keymap.set("n", "<leader>bl", function()
    telescope_buffers(buffers.pinned.length() > 0)
  end, { desc = "Buffer: List all or only pinned if any" })

  vim.keymap.set("n", "<leader>bL", function()
    telescope_buffers(false)
  end, { desc = "Buffer: List all" })

  vim.api.nvim_create_autocmd("SessionLoadPost", {
    group = vim.api.nvim_create_augroup("config-buffers-session-load-post", { clear = true }),
    once = true,
    callback = buffers.pinned.restore,
  })
end

return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    setup()
  end,
}
