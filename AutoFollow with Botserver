leaderPositions = {}
 local leaderDirections = {}
 local leader
 local lastLeaderFloor
 local ropeId = 3003
 local standTime = now
  
 FloorChangers = {
   RopeSpots = {
     Up = {386, 421},
     Down = {}
   },
   
   Use = {
   Up = {1948, 5542, 16693, 16692, 1723, 7771},
     Down = {435}
   }
 }
 
 local function handleUse(pos)
   local lastZ = posz()
   if posz() == lastZ then
     local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
     if newTile then
       g_game.use(newTile:getTopUseThing())
     end
   end
 end
 
 local function handleRope(pos)
   local lastZ = posz()
   if posz() == lastZ then
     local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
     if newTile then
       useWith(ropeId, newTile:getTopUseThing())
     end
   end
 end
 
 local floorChangeSelector = {
   RopeSpots = {Up = handleRope, Down = handleRope},
   Use = {Up = handleUse, Down = handleUse}
 }
 
 local function distance(pos1, pos2)
   local pos2 = pos2 or player:getPosition()
   return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
 end
 
 local function executeClosest(possibilities)
   local closest
   local closestDistance = 99
   for _, data in ipairs(possibilities) do
     local dist = distance(data.pos)
     if dist < closestDistance then
       closest = data
       closestDistance = dist
     end
   end
 
   if closest then
     closest.changer(closest.pos)
   return true
   end
   
   return false
 end
 
 local function handleFloorChange()
   local range = 1
   local p = player:getPosition()
   local possibleChangers = {}
   for _, dir in ipairs({"Down", "Up"}) do
     for changer, data in pairs(FloorChangers) do
       for x = -range, range do
         for y = -range, range do
           local tile = g_map.getTile({x = p.x + x, y = p.y + y, z = p.z})
           if tile and tile:getTopUseThing() then
             if table.find(data[dir], tile:getTopUseThing():getId()) then
               table.insert(possibleChangers, {changer = floorChangeSelector[changer][dir], pos = {x = p.x + x, y = p.y + y, z = p.z}})
       end
           end
         end
       end
     end
   end
   if #possibleChangers > 0 then
     return executeClosest(possibleChangers)
   end
   
   return false
 end
 
 local function levitate(dir)
   turn(dir)
   schedule(200, function()
   say('exani hur "down')
   say('exani hur "up')
   end)
 end
 
 local function matchPos(p1, p2)
   return (p1.x == p2.x and p1.y == p2.y)
 end
 
 local function handleUsing()
   if BotServerFollow.isOff() then
   handleFloorChange()
   else
   local usePos = leaderUsePositions[posz()]
   if usePos then
     local useTile = g_map.getOrCreateTile(usePos)
     if useTile then
       use(useTile:getTopUseThing())
     end
   end
   end
 end
 
 local function useRope(pos)
   if not pos then
     pos = player:getPosition()
   end
   
   local dirs = {{0, 0}, {-1, 0}, {1, 0}, {0, -1}, {0, 1}, {1, -1}, {1, 1}, {-1, 1}, {-1, -1}}
   
   for i = 1, #dirs do
   local tpos = {x = pos.x+dirs[i][1], y = pos.y+dirs[i][2], z = posz()}
   local tile = g_map.getTile(tpos)
   
   if tile then
     if tile:getGround() then
       local ropeSpots = FloorChangers.RopeSpots.Up
       if table.contains(ropeSpots, tile:getGround():getId()) then
         local waitTime = getDistanceBetween(player:getPosition(), tpos) * 60
       handleRope(tpos)
       delay(waitTime)
       return true
     end
     end
   end
   end
   
   return false
 end
 
 local function getStandTime()
   return now - standTime
 end
 
 ultimateFollow = macro(50, "Follow", function()
   if not leader then
   
   local leaderPos = leaderPositions[posz()]
   if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
     autoWalk(leaderPos, 70, {ignoreNonPathable=true, precision=0})
     delay(200)
     return
   end
   
     if BotServerFollow.isOff() then
   
     if handleFloorChange() then
     return
     end
     
     local dir = leaderDirections[posz()]
     if dir then
     levitate(dir)
     end
     
   else
   
     local levitatePos = listenedLeaderPosDir
     if levitatePos and matchPos(player:getPosition(), levitatePos) then 
     levitate(listenedLeaderDir)
     return
     end
     
     if useRope(leaderPos) then
     return
     end
     
     handleUsing()
   end
   else
   listenedLeaderPosDir = nil
   listenedLeaderDir = nil
   
   local lpos = leader:getPosition()
   local parameters = {ignoreNonPathable=true, precision=1, ignoreCreatures=true}
   local path = findPath(player:getPosition(), lpos, 40, parameters)
   local distance = getDistanceBetween(player:getPosition(), lpos)
   if distance > 1 and not path then
     handleUsing()
   elseif distance > 2 then
     if getStandTime() > 500 then
         autoWalk(lpos, 40, parameters)
     delay(200)
     end
   end
   end
 end)
 
 BotServerFollow = macro(1000000, "With BotServer", function() end)
  
 UI.Label("Follow Player:")
 
 UI.TextEdit(storage.followLeader or "Name", function(widget, text)
   storage.followLeader = text
   leader = getCreatureByName(text)
 end)
 
 onCreaturePositionChange(function(creature, newPos, oldPos)
   if ultimateFollow.isOff() then return end
   
   if creature:getName() == player:getName() then
     standTime = now
   return
   end
   
   if creature:getName():lower() ~= storage.followLeader:lower() then return end
   
   if newPos then
   leaderPositions[newPos.z] = newPos
   lastLeaderFloor = newPos.z
   if newPos.z == posz() then
     leader = creature
   else
     leader = nil
   end
   else
   leader = nil
   end
   
   if oldPos then
   if newPos and oldPos.z ~= newPos.z then
     leaderDirections[oldPos.z] = creature:getDirection()
   end
   
   local oldTile = g_map.getTile(oldPos)
   local walkPrecision = 1
   if oldTile then
     if not oldTile:hasCreature() then
       walkPrecision = 0
     end
   end    
   
   autoWalk(oldPos, 40, {ignoreNonPathable=1, precision=walkPrecision})
   end
 end)
 
 onCreatureAppear(function(creature)
   if ultimateFollow.isOff() then return end
   if creature:getPosition().z ~= posz() then return end
   
   if creature:getName():lower() == storage.followLeader:lower() then
   leader = creature
   elseif creature:getName() == player:getName() then
   if lastLeaderFloor and lastLeaderFloor == posz() then
     leader = getCreatureByName(storage.followLeader)
   end
   end
 end)
 
 onCreatureDisappear(function(creature)
   if ultimateFollow.isOff() then return end
   if creature:getPosition().z == posz() then return end
   
   if creature:getName():lower() == storage.followLeader:lower() then
   leader = nil
   elseif creature:getName() == player:getName() and posz() ~= lastLeaderFloor then
   leader = nil
   end
 end)
 
 leader = getCreatureByName(storage.followLeader)
 
 ---------------------------
 commandLeader = "Player Name"
 ---------------------------
 
 commandLeader = commandLeader:lower()
 
 leaderUsePositions = {}
 
 listenedLeaderPosDir = nil
 listenedLeaderDir = nil
