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
      function(path, bufnr)
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
        if vim.regex([[AWSTemplateFormatVersion]]):match_str(content) ~= nil or
            vim.regex([[Resources]]):match_str(content) ~= nil then
          return 'cfn-yaml'
        end

        -- check if the file is in .github/workflows
        if vim.regex([[.github/workflows]]):match_str(path) ~= nil then
          return 'workflow'
        end
      end,
    },
    ['.*.j2'] = {
      priority = math.huge,
      function(_, _)
        -- see if there was a filetype before the .j2 in the file name
        local ft = vim.fn.expand('%:r:e')
        vim.print(ft)
        if ft == 'yml' then
          return 'yaml'
        end
      end,
    },
    ['.env*'] = 'dotenv',
  },
  filename = {
    ['Jenkinsfile'] = 'Jenkinsfile',
    ['.env'] = 'dotenv',
    common = 'group_vars'
  },
})
