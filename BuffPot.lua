BuffPotPanel < Panel
  layout:
    type: verticalBox
    fit-children: true

  Label
    text-align: center
    text: Buff Potion
    font: sans-bold-16px
    color: #BFA500
    height: 23

  Panel
    height: 20
    margin-top: 2
    type: horizontalBox

    BotItem
      id: buffPotions
      margin-top: 2
      anchors.horizontalCenter: parent.horizontalCenter

  Label
    text-align: center
    text: ""
    font: sans-bold-16px
    margin-top: 0
    color: #BFA500
    height: 17

setDefaultTab("Main")
local ui = UI.createWidget("BuffPotPanel")

if type(storage.buffPotions) ~= "table" or not storage.buffPotions[1] then
  storage.buffPotions = {36736} 
end

local buffPotions = ui:recursiveGetChildById("buffPotions")
buffPotions:setItemId(storage.buffPotions[1])  
buffPotions.onItemChange = function()
  storage.buffPotions[1] = buffPotions:getItemId() 
end

local macroName = "[AUTO] Buff Potions"
local items = storage.buffPotions 
local wait = 1


macro(100, macroName, function()
  local time = 0
  for i = 1, #items do
    schedule(time, function()
      g_game.useInventoryItem(items[i])
    end)
    time = time + 250
  end
  delay(wait * 60 * 1000)
end)
UI.Separator()

