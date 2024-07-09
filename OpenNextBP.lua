macro(1000, "Open Next BP", function()
  for _, c in pairs(getContainers()) do
    if #c:getItems() == 1 then
      local nextC = c:getItems()[1]
      if nextC and nextC:isContainer() then
        g_game.open(nextC)
        return g_game.close(c)
      end
    end
  end
end)
