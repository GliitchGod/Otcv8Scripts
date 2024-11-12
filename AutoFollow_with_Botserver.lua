setDefaultTab("PT")
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
   Up = {1628, 1629, 1631, 1632, 1638, 1640, 1642, 
                     1664, 1644, 1646, 1646, 1648, 1650, 1651, 
                     1653, 1654, 1656, 1658, 1660, 1662, 1664,
                     1666, 1668, 1669, 1671, 1672, 1674, 1676,
                     1678, 1680, 1682, 1683, 1685, 1687, 1689,
                     1691, 1692, 1694, 1696, 1698, 5097, 5098,
                     5100, 5102, 5104, 5106, 5107, 5109, 5111,
                     5113, 5115, 5116, 5118, 5120, 5122, 5124,
                     5125, 5127, 5129, 5131, 5133, 5134, 5136,
                     5137, 5139, 5140, 5142, 5143, 5277, 5278,
                     5280, 5281, 5283, 5285, 5287, 5289, 5291,
                     5293, 5514, 5516, 6191, 6192, 6194, 6195,
                     6197, 6199, 6201, 6203, 6205, 6207, 6248,
                     6249, 6251, 6252, 6254, 6256, 6258, 6260,
                     6262, 6264, 6891, 6892, 6894, 6896, 6898,
                     6900, 6901, 6903, 6905, 6907, 7033, 7034,
                     7036, 7038, 7040, 7042, 7043, 7075, 7047,
                     7049, 7711, 7712, 7714, 7715, 7717, 7719,
                     7721, 7723, 7725, 7727, 8249, 8250, 8252,
                     8253, 8255, 8257, 8259, 8261, 8263, 8265,
                     8351, 8352, 8354, 8355, 8357, 8359, 8361,
                     8363, 8365, 8367, 9351, 9352, 9354, 9355,
                     9359, 9361, 9363, 9365, 9367, 9551, 9552,
                     9554, 9556, 9558, 9560, 9561, 9563, 9565,
                     9567, 9858, 9859, 9863, 9865, 9867, 9868,
                     9872, 9874, 11232, 11233, 11237, 11239, 11241,
                     11242, 11246, 11248, 13135, 13136, 13142, 13143,
                     17560, 17561, 17563, 17565, 17567, 17569, 17570,
                     17572, 17574, 17576, 17700, 17701, 17703, 17705,
                     17707, 17709, 17710, 17712, 17714, 17716, 17993,
                     17994, 17996, 17998, 18000, 18002, 18003, 18005,
                     18007, 18009, 29443, 20444, 20446, 20448, 20450,
                     20452, 20453, 20455, 20457, 20459, 22502, 22504,
                     22506, 22508, 24541, 24543, 28364, 28365, 28366,
                     28367, 28519, 28658, 28659, 30033, 30034, 30037,
                     30038, 30041, 30043, 30045, 30047, 30049, 30051,
                     30772, 30773, 30774, 30775, 30833, 30834, 80835,
                     30836, 30849, 30850, 30851, 30852, 31494, 31495,
                     31568, 31570, 31663, 31665, 33271, 33273, 33335,
                     33336, 34221, 34223, 34635, 34636, 34638, 34639,
                     34641, 34642, 34644, 34645, 34936, 34937, 34938,
                     34939, 37981, 37982, 37983, 37984, 39351, 39352,
                     39660, 39661, 39934, 39935, 39936, 39937, 42624,
                     43625, 43626, 43627, 42744, 43932, 43933, 43934,
                     43935, 43936, 43937, 43938, 43939, 43952, 43953},
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
