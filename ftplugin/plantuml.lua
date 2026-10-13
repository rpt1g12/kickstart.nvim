-- PlantUML-specific settings

-- keymap <C-p>r : save + render current file to PNG
-- keymap <C-p>o : same, then open the PNG (macOS `open`)
local function render(open)
  vim.cmd('silent write')
  vim.cmd('silent !plantuml -tpng %')
  if open then
    vim.cmd('silent !open ' .. vim.fn.shellescape(vim.fn.expand('%:r') .. '.png'))
  else
    print('rendered: ' .. vim.fn.expand('%:r') .. '.png')
  end
end

vim.keymap.set('n', '<C-p>r', function() render(false) end, { buffer = true, desc = 'PlantUML: render' })
vim.keymap.set('n', '<C-p>o', function() render(true) end, { buffer = true, desc = 'PlantUML: render + open' })

-- render on save, silently, in background
vim.api.nvim_create_autocmd('BufWritePost', {
  buffer = 0,
  callback = function(args)
    vim.system({ 'plantuml', '-tpng', args.file })
  end,
})
