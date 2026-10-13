return { -- Repo-wide diffs and file history (also used by Neogit)
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  keys = {
    {
      '<leader>gd',
      function()
        -- Three-dot: diff against the merge-base, i.e. what the PR shows
        vim.cmd('DiffviewOpen ' .. require('custom.git').default_branch() .. '...HEAD')
      end,
      desc = '[G]it [d]iff branch vs main (PR view)',
    },
    { '<leader>gD', '<cmd>DiffviewOpen<CR>', desc = '[G]it [D]iff working tree' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = '[G]it file [h]istory' },
    { '<leader>gq', '<cmd>DiffviewClose<CR>', desc = '[G]it diffview [q]uit' },
  },
}
