return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
  },
  config = function()
    require('neogit').setup {
      -- add your neogit config here
      integrations = {
        diffview = true,
      },
    }
    vim.keymap.set('n', '<leader>gg', ':Neogit<CR>', { desc = 'Open Neogit', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gc', ':Neogit commit<CR>', { desc = 'Neogit [C]ommit', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gp', ':Neogit pull<CR>', { desc = 'Neogit [p]ull', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gP', ':Neogit push<CR>', { desc = 'Neogit [P]ush', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gf', ':Neogit fetch<CR>', { desc = 'Neogit [F]etch', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gb', ':Neogit branch<CR>', { desc = 'Neogit [B]ranch', noremap = true, silent = true })
  end,
}
