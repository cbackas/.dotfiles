-- the coverage plugin needs this to find the coverage files
vim.g.coverage_json_report_path = 'coverage/coverage-final.json'

return {
  'ruanyl/coverage.vim',
  event = { 'BufRead', 'BufNewFile' }
}
