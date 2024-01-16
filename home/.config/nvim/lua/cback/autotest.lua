local group = vim.api.nvim_create_augroup("TestOnSave", { clear = true })
local ns = vim.api.nvim_create_namespace "live-tests"

local test_function_query = [[
(
    (call_expression
        ((identifier) @describe_id )

        (arguments
            (string (string_fragment) @describe_name)


            (arrow_function

                (statement_block
                    (expression_statement
                        (call_expression
                            ((identifier) @it_id)

                            (arguments (string (string_fragment) @test_name))
                        )
                    )
                )
            )
        )
    )

    (#any-of? @describe_id "describe" "fdescribe" "xdescribe")
    (#any-of? @it_id "it" "fit" "xit")
    (#eq? @describe_name "%s")
    (#eq? @test_name "%s")
)
]]

local find_test_line = function(bufnr, suite_name, case_name)
  local formatted = string.format(test_function_query, suite_name, case_name)
  local query = vim.treesitter.query.parse("typescript", formatted)
  local parser = vim.treesitter.get_parser(bufnr, "typescript", {})
  local tree = parser:parse()[1]
  local root = tree:root()

  for id, node in query:iter_captures(root, bufnr, 0, -1) do
    local start_row, _, _, _ = node:range()
    if id == 3 and start_row ~= nil then
      return start_row
    end
  end
end


local function parse_xml(file_path)
  local file = io.open(file_path, "r")
  if not file then
    error("Unable to open file: " .. file_path)
  end

  local content = file:read("*all")
  file:close()

  local xml2lua = require("xml2lua")
  local xmlHandler = require("xmlhandler.tree")

  local handler = xmlHandler:new()
  local parser = xml2lua.parser(handler)
  parser:parse(content)
  return handler.root
end

local function parseTestSuites(bufnr, root, acc)
  if not acc then
    acc = {
      failed = {},
      succeeded = {},
      skipped = {}
    }
  end

  local suiteName = root['_attr']['name']
  local suiteResults = root['results']

  -- Check if it contains test-suites or test-cases
  if suiteResults['test-suite'] then
    for _, innerSuite in ipairs(suiteResults['test-suite']) do
      -- Recursive call for nested test-suite
      parseTestSuites(bufnr, innerSuite, acc)
    end
  elseif suiteResults['test-case'] then
    local cases = suiteResults['test-case']
    if cases[1] == nil then
      cases = { cases }
    end

    for _, testCase in ipairs(cases) do
      local caseName = testCase['_attr']['name']
      local caseSuccess = testCase['_attr']['success']
      local caseTime = testCase['_attr']['time']
      local executed = testCase['_attr']['executed'] == 'true'

      local line_num = find_test_line(bufnr, suiteName, caseName)

      local test = {
        caseName = caseName,
        suiteName = suiteName,
        caseSuccess = caseSuccess,
        caseTime = caseTime,
        executed = executed,
        line_num = line_num
      }

      if not executed then
        table.insert(acc.skipped, test)
        goto continue
      end

      if caseSuccess == 'true' then
        table.insert(acc.succeeded, test)
      else
        table.insert(acc.failed, test)
      end

      ::continue::
    end
  else
    print(suiteName .. " has no results")
  end

  return acc
end

local function report_results(bufnr, results)
  -- tell vim diagnostics about all the failed tests
  local failed = {}
  for _, test in ipairs(results.failed) do
    table.insert(failed, {
      bufnr = bufnr,
      lnum = test.line_num,
      col = 0,
      severity = vim.diagnostic.severity.ERROR,
      source = "jasmine",
      message = "Test Failed",
      user_data = {},
    })
  end
  vim.diagnostic.set(ns, bufnr, failed, {})

  -- put fun checkmark by all the tests that passed
  for _, test in ipairs(results.succeeded) do
    local text = { "✅ (" .. test.caseTime .. "s)" }
    vim.api.nvim_buf_set_extmark(bufnr, ns, test.line_num, 0, {
      virt_text = { text },
    })
  end
end

local function process_results(bufnr)
  local resultsFile = './NUnit_results.xml'

  if not resultsFile or not vim.fn.filereadable(resultsFile) == 1 then
    print("Test run completed, results not found at '" .. resultsFile .. "'")
    return
  end

  print("Test run completed, results found" .. resultsFile)

  local results = parse_xml(resultsFile)['test-results']
  if results['test-suite'] ~= nil then
    print("test suite specific")
    results = results['test-suite']
  elseif results['test-case'] ~= nil then
    print("test case specific") -- idk if this actually happens kek
    results = results['test-case']
  else
    print("No test results found")
  end

  local parsedResults = parseTestSuites(bufnr, results)
  report_results(bufnr, parsedResults)
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = "*.spec.ts",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

    local filename = vim.api.nvim_buf_get_name(bufnr)
    local command = "npm run build -- --skipBuild=true && ts-node --swc spec/index.spec.ts " .. filename

    vim.fn.jobstart(command, {
      on_exit = function()
        process_results(bufnr)
      end,
    })
  end,
})
