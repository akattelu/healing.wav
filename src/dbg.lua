local function printTable(t)
  local function printTableIndent(t2, indent)
    if (type(t2) == "table") then
      for pos, val in pairs(t2) do
        if (type(val) == "table") then
          if type(pos) == "string" then
            print(indent .. '"' .. pos .. '": ' .. "{")
          else
            print(indent .. pos .. ': ' .. "{")
          end
          printTableIndent(val, indent .. "  ")
          print(indent .. "}")
        elseif (type(val) == "string") then
          print(indent .. '"' .. pos .. '": "' .. val .. '"')
        else
          print(indent .. pos .. ": " .. tostring(val))
        end
      end
    else
      print(indent .. tostring(t2))
    end
  end

  if (type(t) == "table") then
    print("{")
    printTableIndent(t, " ")
    print("}")
  else
    printTableIndent(t, " ")
  end
end

return {
  printTable = printTable,
}
