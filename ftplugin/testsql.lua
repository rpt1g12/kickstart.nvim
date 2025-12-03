-- This file runs automatically for buffers with `:set filetype=testsql`
-- (because it's under after/ftplugin/testsql.lua).

-- Avoid attaching multiple times to the same buffer.
local existing = vim.lsp.get_clients { name = 'redshift-lsp', bufnr = 0 }
if #existing > 0 then
  return
end

vim.lsp.set_log_level 'info'

vim.lsp.start {
  name = 'redshift-lsp',
  cmd = { '/Users/Pere87666/code/personal/rust/redshift-lsp/target/debug/redshift-lsp' },
  root_dir = vim.fn.getcwd(), -- good enough for now
  filetypes = { 'testsql' },
}
