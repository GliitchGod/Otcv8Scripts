storage.widgetPos = storage.widgetPos or {}

local widgetConfig = [[
UIWidget
  background-color: black
  opacity: 0.8
  padding: 0 5
  focusable: true
  phantom: false
  draggable: true
  text-auto-resize: true
  color: white
  text-align: left 
]]

local trainWidget = {}

trainWidget['widget'] = setupUI(widgetConfig, g_ui.getRootWidget())

local function attachSpellWidgetCallbacks(key)
    trainWidget[key].onDragEnter = function(widget, mousePos)
        if not g_keyboard.isCtrlPressed() then
            return false
        end
        widget:breakAnchors()
        widget.movingReference = { x = mousePos.x - widget:getX(), y = mousePos.y - widget:getY() }
        return true
    end

    trainWidget[key].onDragMove = function(widget, mousePos, moved)
        local parentRect = widget:getParent():getRect()
        local x = math.min(math.max(parentRect.x, mousePos.x - widget.movingReference.x), parentRect.x + parentRect.width - widget:getWidth())
        local y = math.min(math.max(parentRect.y - widget:getParent():getMarginTop(), mousePos.y - widget.movingReference.y), parentRect.y + parentRect.height - widget:getHeight())
        widget:move(x, y)
        return true
    end

    trainWidget[key].onDragLeave = function(widget, pos)
        storage.widgetPos[key] = {}
        storage.widgetPos[key].x = widget:getX()
        storage.widgetPos[key].y = widget:getY()
        return true
    end
end

for key, value in pairs(trainWidget) do
    attachSpellWidgetCallbacks(key)
    trainWidget[key]:setPosition(
        storage.widgetPos[key] or {0, 50}
    )
end

local startTime = os.time()
local initialExp = player:getExperience()
local totalExpGained = 0

local function calcStamina()
    local stam = stamina()
    local hours = math.floor(stam / 60)
    local minutes = stam % 60
    if minutes < 10 then
        minutes = '0' .. minutes
    end
    local percent = math.floor(100 * stam / (42 * 60))
    return hours .. ':' .. minutes, ' (' .. percent .. '%)'
end

local function formatNumberWithCommas(number)
    local formatted = tostring(math.floor(number))
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

local function calcExpRates()
    local currentExp = player:getExperience()
    totalExpGained = currentExp - initialExp
    local elapsedTime = os.time() - startTime
    local expPerHour = (totalExpGained / elapsedTime) * 3600
    local expPerMinute = (totalExpGained / elapsedTime) * 60
    return expPerHour, expPerMinute
end

function expForLevel(level)
    return math.floor((50 * level * level * level) / 3 - 100 * level * level + (850 * level) / 3 - 200)
end

function expToAdvance(currentLevel, currentExp)
    return expForLevel(currentLevel + 1) - currentExp
end

local function calcMissingExpForNextLevel()
    local currentLevel = player:getLevel()
    local currentExp = player:getExperience()
    return expToAdvance(currentLevel, currentExp)
end

macro(100, function()
    local expPerHour, expPerMinute = calcExpRates()
    local missingExp = calcMissingExpForNextLevel()
    
    trainWidget['widget']:setText(
        '~ Level: ' .. player:getLevel() .. '/' .. (player:getLevel() + 1) .. ' - ' .. player:getLevelPercent() .. '%' ..
        '\n~ Missing Exp: ' .. formatNumberWithCommas(missingExp) ..
        '\n~ Exp/h: ' .. formatNumberWithCommas(expPerHour) ..
        '\n~ Exp/min: ' .. formatNumberWithCommas(expPerMinute) ..
        '\n~ Stamina: ' .. calcStamina()
    )
end)
