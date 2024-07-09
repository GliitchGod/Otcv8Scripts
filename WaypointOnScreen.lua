macro(200, function()
  local list = CaveBotList() 
  for index, child in ipairs(list:getChildren()) do
    if child.action == "goto" then
      local x = child.value:split(",")[1]
      local y = child.value:split(",")[2]
      local z = child.value:split(",")[3]
      local coordinatesText = "X: " .. x .. "\nY: " .. y .. "\nZ: " .. z
      local p = {x=x, y=y, z=z}
      local t = g_map.getTile(p)
      if t then
        local color = child:isFocused() and "yellow" or "red"
        t:setText(coordinatesText, color)
      end
    end
  end
end)
