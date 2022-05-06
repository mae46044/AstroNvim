local M = {}
local colors = require "default_theme.colors"

local function get_hl_by_name(name)
  return string.format("#%06x", vim.api.nvim_get_hl_by_name(name.group, true)[name.prop])
end

M.modes = { -- mode text, hlgroup suffix, default color
  ["n"] = { "NORMAL", "Normal", colors.blue },
  ["no"] = { "N-PENDING", "Normal", colors.blue },
  ["i"] = { "INSERT", "Insert", colors.green },
  ["ic"] = { "INSERT", "Insert", colors.green },
  ["t"] = { "TERMINAL", "Insert", colors.green },
  ["v"] = { "VISUAL", "Visual", colors.purple },
  ["V"] = { "V-LINE", "Visual", colors.purple },
  [""] = { "V-BLOCK", "Visual", colors.purple },
  ["R"] = { "REPLACE", "Replace", colors.red_1 },
  ["Rv"] = { "V-REPLACE", "Replace", colors.red_1 },
  ["s"] = { "SELECT", "Select", colors.orange_1 },
  ["S"] = { "S-LINE", "Select", colors.orange_1 },
  [""] = { "S-BLOCK", "Select", colors.orange_1 },
  ["c"] = { "COMMAND", "Command", colors.yellow_1 },
  ["cv"] = { "COMMAND", "Command", colors.yellow_1 },
  ["ce"] = { "COMMAND", "Command", colors.yellow_1 },
  ["r"] = { "PROMPT", "Other", colors.grey_7 },
  ["rm"] = { "MORE", "Other", colors.grey_7 },
  ["r?"] = { "CONFIRM", "Other", colors.grey_7 },
  ["!"] = { "SHELL", "Other", colors.grey_7 },
}

function M.get_hl_prop(group, prop, default)
  local status_ok, color = pcall(get_hl_by_name, { group = group, prop = prop })
  if status_ok then
    default = color
  end
  return default
end

function M.lsp_progress(_)
  local Lsp = vim.lsp.util.get_progress_messages()[1]

  if Lsp then
    local msg = Lsp.message or ""
    local percentage = Lsp.percentage or 0
    local title = Lsp.title or ""

    local spinners = { "", "", "" }
    local success_icon = { "", "", "" }

    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners

    if percentage >= 70 then
      return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
    end

    return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
  end

  return ""
end

function M.treesitter_status()
  local ts = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
  if ts and next(ts) then
    return " 綠TS"
  end
  return ""
end

function M.buffer_not_empty()
  return vim.fn.empty(vim.fn.expand "%:t") ~= 1
end

function M.hide_in_width()
  return vim.fn.winwidth(0) > 80
end

function M.spacer(n)
  return { provider = string.rep(" ", n) }
end

function M.colored_spacer(n)
  return vim.tbl_deep_extend("force", M.spacer(n), { hl = M.mode_colors })
end

function M.mode_colors()
  local mode = M.modes[vim.fn.mode()]
  return {
    fg = M.get_hl_prop("Feline" .. mode[2], "foreground", colors.bg_1),
    bg = M.get_hl_prop("Feline" .. mode[2], "background", mode[3]),
  }
end

return M
