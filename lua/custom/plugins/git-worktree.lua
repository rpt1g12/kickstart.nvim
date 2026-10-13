return {
  'ThePrimeagen/git-worktree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('git-worktree').setup { confirm_telescope_deletions = true }
    require('telescope').load_extension 'git_worktree'

    vim.keymap.set('n', '<leader>gw', function()
      require('telescope').extensions.git_worktree.git_worktrees { path_display = {} }
    end, { desc = '[G]it [W]orktrees: switch/delete' })

    vim.keymap.set('n', '<leader>gW', function()
      require('telescope').extensions.git_worktree.create_git_worktree()
    end, { desc = '[G]it [W]orktree: create' })
  end,
}
