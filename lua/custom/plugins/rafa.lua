-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'vimwiki/vimwiki',
    init = function()
      vim.g.vimwiki_listsyms = '✗○◐●✓'
      vim.g.vimwiki_table_mappings = 0

      -- Add this line to disable header mappings ('-' and '+')
      vim.g.vimwiki_key_mappings = { headers = 0 }

      vim.g.vimwiki_list = {
        {
          path = '~/vimwiki',
          syntax = 'markdown',
          ext = '.md',
        },
      }
    end,
  },
  {
    'junegunn/vim-easy-align',
    config = function()
      vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', { desc = 'Easy [A]lign' })
      vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', { desc = 'Easy [A]lign' })
    end,
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    lazy = false,
    config = function()
      require('oil').setup {
        keymaps = {
          ['<Esc><Esc>'] = 'actions.close', -- Press Esc twice quickly to exit Oil
          ['q'] = 'actions.close', -- Keep 'q' as an single-key alternative
        },
      }

      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },
  {
    'nmac427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup {}
    end,
  },
}
