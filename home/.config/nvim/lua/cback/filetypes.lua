vim.filetype.add({
  pattern = {
    ['.*.Jenkinsfile'] = {
      priority = math.huge,
      function(_, _)
        return 'Jenkinsfile'
      end,
    },
    ['.*.ya?ml'] = {
      priority = math.huge,
      function(_, bufnr)
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
        if vim.regex([[AWSTemplateFormatVersion]]):match_str(content) ~= nil or
            vim.regex([[Resources]]):match_str(content) ~= nil then
          return 'cfn-yaml'
        end
      end,
    },
  },
  filename = {
    ['Jenkinsfile'] = 'Jenkinsfile',
    common = 'group_vars'
  },
})
