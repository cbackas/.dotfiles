---@param t1 table
function ConcatTables(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

---@param t table
---@return number
function TableLength(t)
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

local home = os.getenv('HOME')
---@param path string
---@return string
function ReplaceHomeWithTilde(path)
  if path:sub(1, #home) == home then
    return "~" .. path:sub(#home + 1)
  end
  return path
end

---@param label string
---@param path string
---@return table {label: string, id: string}
function CreateDirectoryEntry(label, path)
  return {
    label = PadLabel(label, path),
    id = path
  }
end

---@param label string
---@param path string
function PadLabel(label, path)
  return label .. string.rep(' ', 50 - #label) .. ReplaceHomeWithTilde(path)
end

---@param pane Pane
---@return boolean
function IsVimPane(pane)
  local process_info = pane:get_foreground_process_info()
  local process_name = process_info and process_info.name

  return process_name == 'nvim' or process_name == 'vim' or process_name == 'nvim.exe' or process_name == 'vim.exe'
end
