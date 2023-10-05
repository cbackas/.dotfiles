function ConcatTables(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end
