--- Remove item from table
--- @param src table of items
--- @param item any to remove
local function remove(src, item)
  do
    for i, s in pairs(src) do
      if (s == item) then
        table.remove(src, i)
      end
    end
  end
end

return {
  remove = remove
}
