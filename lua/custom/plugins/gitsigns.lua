return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup {
      -- See `:help gitsigns.txt` for all available configuration options
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    }
    vim.keymap.set('n', '<leader>gh', ':Gitsigns preview_hunk<CR>', { desc = 'Git Preview [H]unk' })
    vim.keymap.set('n', '<leader>gt', ':Gitsigns toggle_current_line_blame<CR>', { desc = 'Git [T]oggle Current Line Blame' })
  end,
}
