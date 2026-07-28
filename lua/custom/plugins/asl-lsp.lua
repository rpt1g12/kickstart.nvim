return {
  {
    'rperez-torro/mason-asl-lsp',
    dependencies = {
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('mason-asl-lsp').setup()
    end,
  },
}
