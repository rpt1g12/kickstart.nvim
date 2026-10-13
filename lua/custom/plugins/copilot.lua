return {
  {
    'github/copilot.vim',
    init = function()
      vim.g.copilot_filetypes = {
        markdown = true, -- Enable Copilot for markdown files
      }
    end,
  },
  -- {
  --   'zbirenbaum/copilot.lua',
  --   dependencies = {
  --     'copilotlsp-nvim/copilot-lsp',
  --   },
  --   opts = {},
  -- },
}
