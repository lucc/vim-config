-- helper functions to bridge lua and vimscript

-- This map function is copied from
-- https://oroques.dev/notes/neovim-init/#mappings
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function command(name, expand)
  vim.cmd("command! " .. name .. " " .. expand)
end

return {
  command = command,
  map = map,
}
