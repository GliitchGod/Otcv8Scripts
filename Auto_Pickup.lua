setDefaultTab("Tools")
  UI.Separator()
  
  if type(storage.pickUp) ~= "table" then
    storage.pickUp = {3725, 3723}
  end
  
  if type(storage.containerpickUp) ~= "table" then
    storage.containerpickUp = {5926}
  end
  
  UI.Label("Items")
  local pickUpContainer = UI.Container(function(widget, items)
    storage.pickUp = items
  end, true)
  pickUpContainer:setHeight(35)
  pickUpContainer:setItems(storage.pickUp)
  
  local CheckPOS = 10
  local moveTrash = true 
  local moveDistance = 2
  local CheckOriginal = CheckPOS --do not modify
  local moveOriginal = moveDistance --do not modify
  
  UI.Label("Containers")
  local containerpickUpContainer = UI.Container(function(widget, items)
    storage.containerpickUp = items
  end, true)
  containerpickUpContainer:setHeight(35)
  containerpickUpContainer:setItems(storage.containerpickUp)
  pegaritem = macro((g_game.getPing()*1.5), "- Auto Pickup -", "", function()
    if not storage.pickUp[1] then return end
    for x = -CheckPOS, CheckPOS do
      for y = -CheckPOS, CheckPOS do
      tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
        if tile and tile:isClickable() and tile:isWalkable() and tile:isPathable() then     
        local topthing = tile:getTopMoveThing():getId()  
          for c, catar in pairs(storage.pickUp) do
            if table.find(catar, topthing) then  
            local containers = getContainers()
              for _, container in pairs(containers) do            
                for g, guardar in pairs(storage.containerpickUp) do
                  if table.find(guardar, container:getContainerItem():getId()) then               
                  if CaveBot.isOn() then 
                  cavebot_status = 1
                CaveBot.setOff()
                  CheckPOS = CheckPOS + 1       
                  end
  --print("Looting: "..tile:getTopMoveThing():getId())
  --print("x: "..posx() + x.." y: "..posy() + y.." z: "..posz())
                  return g_game.move(tile:getTopMoveThing(), container:getSlotPosition(container:getItemsCount()), tile:getTopMoveThing():getCount())      
              end
                end
              end  
            end
          end
        end  
      end
    end
    if moveTrash == true then
    for x = -CheckPOS, CheckPOS do
      for y = -CheckPOS, CheckPOS do
      local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
      if tile and tile:isClickable() and tile:isWalkable() and tile:isPathable() then--acho q n tenho q testar se Ã© walkable pra mover
          for c, catar in pairs(storage.pickUp) do
           for a , item in pairs(tile:getThings()) do         
            if table.find(catar, item:getId()) then
           if CaveBot.isOn() then 
         cavebot_status = 1
           CaveBot.setOff()  
         CheckPOS = CheckPOS + 1        
              end 
        if tile:getTopMoveThing():getPosition().x == player:getPosition().x and tile:getTopMoveThing():getPosition().y == player:getPosition().y then
         return g_game.move(tile:getTopMoveThing(), {x = player:getPosition().x , y = player:getPosition().y, z = player:getPosition().z}, tile:getTopMoveThing():getCount()) 
                end                  
            end
            end  
          end
      end
      end
    end
  end
  

UI.Separator()
