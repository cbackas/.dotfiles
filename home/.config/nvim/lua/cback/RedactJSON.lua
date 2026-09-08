local FILTER =
[[walk(if type == "object" then with_entries(if (.key | ascii_downcase | test("token|secret|password|api_?key|auth")) then .value = "REDACTED" else . end) else . end)]]

vim.api.nvim_create_user_command("RedactJSON", function(opts)
  local first, last = opts.line1 - 1, opts.line2
  local lines = vim.api.nvim_buf_get_lines(0, first, last, false)
  local out = vim.fn.systemlist({ "jq", FILTER }, lines)

  if vim.v.shell_error ~= 0 then
    vim.notify("jq failed:\n" .. table.concat(out, "\n"), vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_buf_set_lines(0, first, last, false, out)
  if opts.bang then
    vim.fn.setreg("+", table.concat(out, "\n"))
    vim.notify("Redacted JSON copied to clipboard")
  end
end, { range = "%", bang = true, desc = "Redact secret-ish values in JSON via jq" })
