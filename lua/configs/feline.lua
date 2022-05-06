local M = {}

function M.config()
  local present, feline = pcall(require, "feline")
  if present then
    local lsp = require "feline.providers.lsp"
    local colors = require "default_theme.colors"
    local status = require "core.status"

    feline.setup(require("core.utils").user_plugin_opts("plugins.feline", {
      disable = {
        filetypes = { "^NvimTree$", "^neo%-tree$", "^dashboard$", "^Outline$", "^aerial$" },
      },
      theme = {
        fg = status.get_hl_prop("Feline", "foreground", colors.fg),
        bg = status.get_hl_prop("Feline", "background", colors.bg_1),
      },
      components = {
        active = {
          {
            status.colored_spacer(1),
            status.spacer(1),
            {
              provider = "git_branch",
              hl = { fg = status.get_hl_prop("Conditional", "foreground", colors.purple_1), style = "bold" },
              icon = "  ",
            },
            status.spacer(3),
            {
              provider = { name = "file_type", opts = { filetype_icon = true, case = "lowercase" } },
              enabled = status.buffer_not_empty,
            },
            status.spacer(2),
            {
              provider = "git_diff_added",
              hl = { fg = status.get_hl_prop("GitSignsAdd", "foreground", colors.purple_1) },
              icon = "  ",
            },
            {
              provider = "git_diff_changed",
              hl = { fg = status.get_hl_prop("GitSignsChange", "foreground", colors.purple_1) },
              icon = " 柳",
            },
            {
              provider = "git_diff_removed",
              hl = { fg = status.get_hl_prop("GitSignsDelete", "foreground", colors.purple_1) },
              icon = "  ",
            },
            status.spacer(2),
            {
              provider = "diagnostic_errors",
              enabled = function()
                return lsp.diagnostics_exist(vim.diagnostic.severity.ERROR)
              end,

              hl = { fg = status.get_hl_prop("DiagnosticError", "foreground", colors.purple_1) },
              icon = "  ",
            },
            {
              provider = "diagnostic_warnings",
              enabled = function()
                return lsp.diagnostics_exist(vim.diagnostic.severity.WARN)
              end,

              hl = { fg = status.get_hl_prop("DiagnosticWarn", "foreground", colors.purple_1) },
              icon = "  ",
            },
            {
              provider = "diagnostic_info",
              enabled = function()
                return lsp.diagnostics_exist(vim.diagnostic.severity.INFO)
              end,

              hl = { fg = status.get_hl_prop("DiagnosticInfo", "foreground", colors.purple_1) },
              icon = "  ",
            },
            {
              provider = "diagnostic_hints",
              enabled = function()
                return lsp.diagnostics_exist(vim.diagnostic.severity.HINT)
              end,

              hl = { fg = status.get_hl_prop("DiagnosticHint", "foreground", colors.purple_1) },
              icon = "  ",
            },
          },
          {
            {
              provider = status.lsp_progress,
              hl = { gui = "none" },
              enabled = status.hide_in_width,
            },
            {
              provider = "lsp_client_names",
              hl = { gui = "none" },
              icon = "   ",
              enabled = status.hide_in_width,
            },
            status.spacer(2),
            {
              provider = status.treesitter_status,
              hl = { fg = status.get_hl_prop("GitSignsAdd", "foreground", colors.green) },
              enabled = status.hide_in_width,
            },
            status.spacer(2),
            { provider = "position" },
            status.spacer(1),
            {
              provider = "scroll_bar",
              hl = { fg = status.get_hl_prop("TypeDef", "foreground", colors.yellow) },
            },
            status.spacer(2),
            status.colored_spacer(1),
          },
        },
      },
    }))
  end
end

return M
