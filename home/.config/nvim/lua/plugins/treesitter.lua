return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  init = function()
    vim.treesitter.language.register('yaml', 'cfn-yaml')
    vim.treesitter.language.register('yaml', 'group_vars')
    vim.treesitter.language.register('groovy', 'Jenkinsfile')
    vim.treesitter.language.register('yaml', 'workflow')
  end,
}
