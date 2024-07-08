script_bot = {};
script_path = '/scripts_storage/';
script_path_json = script_path .. player:getName() .. '.json';


actualVersion = 0.69;

script_manager = {
    actualVersion = 0.3,
    _cache = {

        Tibia = {
            ['E Ring'] = {
                url = 'https://raw.githubusercontent.com/GliitchGod/Otcv8Scripts/main/Custom_E-Ring.lua',
                description = 'Script e-ring.',
                author = 'VivoDibra',
                enabled = false
            },

            ['Auto Taunt'] = {
                url = 'https://raw.githubusercontent.com/GliitchGod/Otcv8Scripts/main/exeta_res.lua',
                description = 'Exeta Res based on attack.',
                author = 'VivoDibra',
                enabled = false
            },

            ['Auto Pickup'] = {
                url = 'https://raw.githubusercontent.com/GliitchGod/Otcv8Scripts/main/Auto_Pickup.lua',
                description = 'Script Auto Pickup with ui.',
                author = 'Kratos',
                enabled = false
            },

            ['Exp Analyser'] = {
                url = 'https://raw.githubusercontent.com/GliitchGod/Otcv8Scripts/main/Exp_Analyser.lua',
                description = 'Script UI exp Analyser.',
                author = 'Kratos',
                enabled = false
            },


        Healing = {
            ['Heal Friend'] = {
                url = 'https://raw.githubusercontent.com/GliitchGod/Otcv8Scripts/main/Heal_Friend.lua',
                description = 'Script heal friends/party.',
                author = 'mrlthebest',
                enabled = false
            },

        Utilities = {

            ['Auto Party'] = {
                url = 'https://raw.githubusercontent.com/mrlthebest/Community-Scripts/main/Scripts/Utilities/auto_party.lua',
                description = 'Auto Party.',
                author = 'Lee',
                enabled = false
            },
            ['Buff'] = {
                url = 'https://raw.githubusercontent.com/GliitchGod/Otcv8Scripts/main/auto_buff.lua',
                description = 'Buff script by orange message.',
                author = 'mrlthebest',
                enabled = false
            },


            ['Combo + Combo Interrupt'] = {
                url = 'https://raw.githubusercontent.com/mrlthebest/Community-Scripts/main/Scripts/Utilities/combo_interrumpt.lua',
                description = 'Script de Combo+Combo Interrupt.',
                author = 'VictorNeox.',
                enabled = false
            },

            ['Combo With Leader'] = {
                url = 'https://raw.githubusercontent.com/GliitchGod/Otcv8Scripts/main/Combo_leader.lua',
                description = 'Script target leader mob/player.',
                author = 'Kratos.',
                enabled = false
            },

            ['Follow Player'] = {
                url = 'https://raw.githubusercontent.com/GliitchGod/Otcv8Scripts/main/AutoFollow_with_Botserver.lua',
                description = 'Auto Follow Player with botserver.',
                author = 'Kratos/Cyotah',
                enabled = false
            },

            ['Last Exiva'] = {
                url = 'https://raw.githubusercontent.com/mrlthebest/Community-Scripts/main/Scripts/Utilities/last_exiva.lua',
                description = 'Script de last sense/exiva.',
                author = 'Lee',
                enabled = false
            },

            ['Turn Target'] = {
                url = 'https://raw.githubusercontent.com/mrlthebest/Community-Scripts/main/Scripts/Utilities/turn.lua',
                description = 'Script turn the character to where the target is.',
                author = 'Ryan',
                enabled = false
            },

            ['Stamina'] = {
                url = 'https://raw.githubusercontent.com/GliitchGod/Otcv8Scripts/main/auto_stamina.lua',
                description = 'Script to use stamina.',
                author = 'Kratos',
                enabled = false
            },

          },
        },
      },
    },


};


_G = modules._G;
context = _G.getfenv();
g_resources = _G.g_resources;
listDirectoryFiles = g_resources.listDirectoryFiles;
readFileContents = g_resources.readFileContents;
fileExists = g_resources.fileExists;

-- AnenScripts credit
local G = modules.client_entergame.G;
G.account = ":)"
G.password = ":)"

local account  = g_ui.getRootWidget():recursiveGetChildById("enterGame")
account:getChildById("accountNameTextEdit"):setText("")
account:getChildById("accountPasswordTextEdit"):setText("")

g_settings = modules._G.g_settings;
local copySee = g_settings.get

g_settings.get = function (key)
    if key == "account" or key == "password" or key:match("account_") or key:match("password_") then
        return ":)"
    end
    return copySee(key)
end


if not fileExists(script_path) then
    g_resources.makeDir(script_path);
end


script_bot.readFileContents = function()
    local data = script_manager;
    if g_resources.fileExists(script_path_json) then
        local content = g_resources.readFileContents(script_path_json);
        local status, result = pcall(json.decode, content);
        if status then
            data = result;
        else
            print("Error decoding JSON file:", result);
        end
    else
        script_bot.saveScripts();
    end
    script_manager = data;
end


script_bot.saveScripts = function()
    local res = json.encode(script_manager, 4);
    local status, err = pcall(function() g_resources.writeFileContents(script_path_json, res) end);
    if not status then
        info("Error saving file:" .. err);
    end
end


local script_add = [[
UIWidget
  background-color: alpha
  focusable: true
  height: 30

  $focus:
    background-color: #00000055

  Label
    id: textToSet
    font: terminus-14px-bold
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
]];

script_bot.widget = setupUI([[
MainWindow
  !text: tr('Community Scripts')
  font: terminus-14px-bold
  color: #d2cac5
  size: 300 400

  TabBar
    id: macrosOptions
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    width: 180

  ScrollablePanel
    id: scriptList
    layout:
      type: verticalBox
    anchors.fill: parent
    margin-top: 25
    margin-left: 2
    margin-right: 15
    margin-bottom: 30
    vertical-scrollbar: scriptListScrollBar
      
  VerticalScrollBar
    id: scriptListScrollBar
    anchors.top: scriptList.top
    anchors.bottom: scriptList.bottom
    anchors.right: scriptList.right
    step: 14
    pixels-scroll: true
    margin-right: -10

  HorizontalSeparator
    id: sep
    anchors.top: enemyList.bottom
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: prev.right
    margin-left: 10
    margin-top: 6

  TextEdit
    id: searchBar
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-right: 5
    width: 130

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.left: searchBar.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-bottom: 1
    margin-right: 5
    margin-left: 5
]], g_ui.getRootWidget())
script_bot.widget:hide();
script_bot.widget:setText('Community Scripts - ' .. actualVersion)

UI.Separator();

local updateLabel = UI.Label('Community Scripts. \n New version available, click "Update Files". \nVersion: ' .. actualVersion);
updateLabel:setColor('yellow');
updateLabel:hide();

-- Define buttons and their functionalities
--[[ Widget Button ]]--
script_bot.buttonWidget = UI.Button('Script Manager');
script_bot.buttonWidget:setColor('#d2cac5');
--[[ Update Script Button ]]--
script_bot.buttonRemoveJson = UI.Button('Update Files');
script_bot.buttonRemoveJson:setColor('#d2cac5');
script_bot.buttonRemoveJson:setTooltip('Click here only when there is an update.');
script_bot.buttonRemoveJson.onClick = function(widget)
    g_resources.deleteFile(script_path_json);
    reload();
end

--[[ Close Widget Button ]] --
script_bot.widget.closeButton:setTooltip('Close and add macros.');
script_bot.widget.closeButton.onClick = function(widget)
    reload();
    script_bot.widget:hide();
end

--[[ Close Button On Widget ]] --
script_bot.buttonWidget.onClick = function(widget)
    if script_bot.widget:isVisible() then
        reload();
    else
        script_bot.widget:show();
    end
end

--[[ Search Bar Tooltip ]] --
script_bot.widget.searchBar:setTooltip('Search macros.');

UI.Separator();

-- Function to filter scripts based on search text
function script_bot.filterScripts(filterText)
    for _, child in pairs(script_bot.widget.scriptList:getChildren()) do
        local scriptName = child:getId();
        if scriptName:lower():find(filterText:lower()) then
            child:show();
        else
            child:hide();
        end
    end
end

function script_bot.updateScriptList(tabName)
    script_bot.widget.scriptList:destroyChildren();
    local macrosCategory = script_manager._cache[tabName];

    if macrosCategory then
        for key, value in pairs(macrosCategory) do
            local label = setupUI(script_add, script_bot.widget.scriptList);
            label.textToSet:setText(key);
            label.textToSet:setColor('#bdbdbd');
            label:setTooltip('Description: ' .. value.description .. '\nAuthor: ' .. value.author);

            label.onClick = function(widget)
                value.enabled = not value.enabled;
                script_bot.saveScripts();
                label.textToSet:setColor(value.enabled and 'green' or '#bdbdbd');
                if value.enabled then
                    -- loadRemoteScript(value.url);
                end
            end

            if value.enabled then
                label.textToSet:setColor('green');
            end

            label:setId(key);
        end
    end
end

-- Function to load scripts
script_bot.onLoading = function()
    script_bot.widget.scriptList:destroyChildren();

    local categories = {};
    for categoryName, categoryList in pairs(script_manager._cache) do
        table.insert(categories, categoryName);
        for key, value in pairs(categoryList) do
            if value.enabled then
                modules.corelib.HTTP.get(value.url, function(script)
                    assert(loadstring(script))();
                end);
            end
        end
    end

    local numSteps = 6;
    local numCategories = #categories;
    local numLoops = math.ceil(numCategories / numSteps);

    for i = 1, numLoops do
        for j = 1, numSteps do
            local index = (i - 1) * numSteps + j;
            if index <= numCategories then
                local categoryName = categories[index];
                local tab = script_bot.widget.macrosOptions:addTab(categoryName);
                tab:setId(categoryName);
                tab:setTooltip(categoryName .. ' Macros');

                tab.onStyleApply = function(widget)
                    if script_bot.widget.macrosOptions:getCurrentTab() == widget then
                        widget:setColor('green');
                    else
                        widget:setColor('white');
                    end
                end
            end
        end
    end

    local currentTab = script_bot.widget.macrosOptions:getCurrentTab().text;
    script_bot.updateScriptList(currentTab);

    script_bot.widget.macrosOptions.onTabChange = function(widget, tabName)
        script_bot.updateScriptList(tabName:getText());
        script_bot.filterScripts(script_bot.widget.searchBar:getText());
    end

    script_bot.widget.searchBar.onTextChange = function(widget, text)
        script_bot.filterScripts(text);
    end
end

-- Main looping
do
    script_bot.readFileContents();
    script_bot.onLoading();
end


if script_manager.actualVersion ~= actualVersion then
    updateLabel:show();
end
