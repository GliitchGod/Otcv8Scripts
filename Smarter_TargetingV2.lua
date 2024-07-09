macro(100, "Smarter targeting", function()
   if isInPz() then
        targetMonster = nil
        return
    end
    local playerPos = player:getPosition()
    local battlelist = getSpectators()

    local ignoreSet = {}
    local ignoreText = storage.Mobs
    local monsterNames = string.split(ignoreText, ",")

    for _, name in ipairs(monsterNames) do
        ignoreSet[name:trim()] = true
    end

    local currentTarget = g_game.getAttackingCreature()
    local targetMonster = nil
    local closestDistance = tonumber(storage.Range)
    local lowestHealthPercent = 101

    for _, val in pairs(battlelist) do
        if val:isMonster() and not ignoreSet[val:getName()] then
            local distance = getDistanceBetween(playerPos, val:getPosition())
            local healthPercent = val:getHealthPercent()
            if distance <= closestDistance and (healthPercent < lowestHealthPercent or currentTarget == val) then
                local canShootMonster = val:canShoot(closestDistance)
                if canShootMonster then
                    closestDistance = distance
                    lowestHealthPercent = healthPercent
                    targetMonster = val
                end
            end
        end
    end

    if targetMonster and currentTarget ~= targetMonster then
        g_game.attack(targetMonster)
    end
end)

UI.Label("Mobs To Ignore")
UI.TextEdit(storage.Mobs or "monster1, monster2, monster3", function(widget, text)
    storage.Mobs = text 
end)

UI.Label("Attack Distance")
UI.TextEdit(storage.Range or "10", function(widget, text)
    storage.Range = tonumber(text)
end)
