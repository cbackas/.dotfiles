local M = {}

-- idk make these configurable
local ssh_host = "root@172.16.1.65"
local local_root = "./packages/"
local remote_root = "/var/www/html/phoenixphpclient6.0/"

local function get_diff_cmd()
  local rsync_cmd = string.format(
    "rsync -rc --ignore-times --dry-run --out-format='%%n' --exclude-from='.gitignore' --exclude='template_editor/resources/' %s %s:%s",
    vim.fn.shellescape(local_root),
    ssh_host,
    vim.fn.shellescape(remote_root .. "packages/")
  )
  return rsync_cmd
end

---@param files string[]
local function get_sync_cmd(files)
  local rsync_cmd = { "rsync", "-vc", "--relative" }

  for _, file in ipairs(files) do
    table.insert(rsync_cmd, vim.fn.shellescape(local_root .. file))
  end

  table.insert(rsync_cmd, string.format("%s:%s", ssh_host, vim.fn.shellescape(remote_root)))
  return table.concat(rsync_cmd, " ")
end

---@param files string[]
local function sync_all_files(files)
  local sync_cmd = get_sync_cmd(files)
  vim.print(sync_cmd)

  local result = vim.fn.system(sync_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error syncing files: " .. result)
    return
  else
    vim.notify("Files synced successfully")
  end
end

function M.setup()
  -- Create user command
  vim.api.nvim_create_user_command('PCDSync', function()
    if vim.fn.isdirectory(local_root) == 0 then
      vim.notify("Local path does not exist: " .. local_root)
      return
    end

    -- check if rsync is installed
    local rsync_check_cmd = "command -v rsync"
    local rsync_check = vim.fn.system(rsync_check_cmd)
    if rsync_check == "" then
      vim.notify("rsync is not installed")
      return
    end

    local rsync_diff_cmd = get_diff_cmd()
    local changed_files = vim.fn.system(rsync_diff_cmd)

    if changed_files == "" then
      vim.notify("No changes detected")
      return
    end

    vim.cmd("vnew")
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(changed_files, "\n"))
    vim.bo[buf].filetype = "PCDDiffList"
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].modifiable = false
  end, {})

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "PCDDiffList",
    callback = function()
      vim.api.nvim_buf_create_user_command(0, "PCDApply", function()
        vim.ui.select({ "Approve", "Cancel" }, {
          prompt = "Review changes and approve:",
        }, function(choice)
          local buf = vim.api.nvim_get_current_buf()
          if choice == "Approve" then
            local files = vim.tbl_filter(function(line)
              return line ~= ""
            end, vim.api.nvim_buf_get_lines(buf, 0, -1, false))
            sync_all_files(files)
          end
          vim.api.nvim_buf_delete(buf, { force = true })
        end)
      end, { desc = "Approval prompt for PCD Syncing" })
    end,
  })
end

return M
