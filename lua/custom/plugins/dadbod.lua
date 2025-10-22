return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.keymap.set('n', '<leader>db', ':DBUI<CR>', { desc = 'Open [D]ad[B]od-ui', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>da', ':DBUIFindBuffer<CR>', { desc = '[A]dd file to [D]adBod-ui', noremap = true, silent = true })
  end,
}
