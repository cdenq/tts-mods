----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Vagabond 2 Picker")
factionBoardGUID = "947d73"

----------------------
-- variables
----------------------
myColors = {
    white = {1, 1, 1},
    gray = {0.5, 0.5, 0.5},
    green = {0, 1, 0},
    red = {1, 0, 0},
    whiteShade = {1, 1, 1, 0.65},
    grayShade = {0.5, 0.5, 0.5, 0.75},
    greenShade = {0, 1, 0, 0.85},
    redShade = {1, 0, 0, 0.85}
}
myButtons = {
    liftHeight = 0.25,
    confirmButton = {buttonHeight = 175, buttonWidth = 300, fontSize = 50, defaultColor = myColors.white},
    selectButtons = {buttonHeight = 150, buttonWidth = 300, fontSize = 50, defaultColor = myColors.white, scale = {0.5, 0.5, 0.5}}
}
itemBank = {
    boot = {"bdf89d", "59daee", "447872", "ddbb16"},
    sword = {"bfad7f", "860608", "cd8dd4"},
    hammer = {"8ad39a", "d17f72"},
    coin = {"d71832", "98051b"},
    torch = {"df8daa", "bab0eb"},
    tea = {"a529d8"},
    crossbow = {"11e033", "2c78ab"},
    bag = {"2b0fb5"}
}
characters = {
    {
        label = "ranger",
        meeple = "9b76db",
        card = "3db079",
        items = {"torch", "boot", "crossbow", "sword"}
    },
    {
        label = "tinker",
        meeple = "dab5e8",
        card = "78ca46",
        items = {"torch", "boot", "bag", "hammer"}
    },
    {
        label = "thief",
        meeple = "def9cd",
        card = "1c02a2",
        items = {"torch", "boot", "tea", "sword"}
    },
    {
        label = "scoundrel",
        meeple = "64f0fe",
        card = "f69c98",
        items = {"torch", "boot", "boot", "crossbow"}
    },
    {
        label = "vagrant",
        meeple = "4082ff",
        card = "a67db3",
        items = {"torch", "boot", "coin"}
    },
    {
        label = "arbiter",
        meeple = "18e1fd",
        card = "c33cb1",
        items = {"torch", "boot", "sword", "sword"}
    },
    {
        label = "ronin",
        meeple = "3fdd3d",
        card = "946238",
        items = {"torch", "boot", "boot", "sword"}
    },
    {
        label = "adventurer",
        meeple = "e0d47e",
        card = "8548a4",
        items = {"torch", "boot", "hammer"}
    },
    {
        label = "harrier",
        meeple = "37c484",
        card = "afbc63",
        items = {"torch", "crossbow", "sword", "coin"}
    }
}
itemBagSupplyStorage = "ea0720"
characterMeepleSupplyStorage = "f74291"
itemsToPlace = {}
selectedCharacter = ""

----------------------
-- onload and once functions
----------------------
function onLoad()
    createAllButtons()
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createConfirmButton()
    createSelectButtons()
end

function createConfirmButton()
    self.createButton({
        click_function = "confirmVagabond",
        function_owner = self,
        label = "Confirm",
        position = {0, myButtons.liftHeight, 1.21},
        width = myButtons.confirmButton.buttonWidth,
        height = myButtons.confirmButton.buttonHeight,
        font_size = myButtons.confirmButton.fontSize,
        color = myColors.gray
    })
end

function createSelectButtons()
    local buttonsPerRow = 3
    local buttonSpacing = 1.35
    local rowSpacing = 0.5
    local startX = -buttonSpacing - 0.23
    local startZ = -0.6

    for i, characterData in ipairs(characters) do
        local row = math.floor((i - 1) / buttonsPerRow)
        local col = (i - 1) % buttonsPerRow
        
        local xPos = startX + col * buttonSpacing
        local zPos = startZ + row * rowSpacing

        self.createButton({
            click_function = "onSelectClick_" .. characterData.label,
            function_owner = self,
            label = characterData.label:gsub("^%l", string.upper),
            position = {xPos, myButtons.liftHeight, zPos},
            width = myButtons.selectButtons.buttonWidth,
            height = myButtons.selectButtons.buttonHeight,
            font_size = myButtons.selectButtons.fontSize,
            scale = myButtons.selectButtons.scale,
            color = myButtons.selectButtons.defaultColor
        })
    end
end

----------------------
-- helper functions
----------------------
function doNothing()
end

----------------------
-- select functions
----------------------
function onSelectClick(character)
    local buttonColor
    for i, characterData in ipairs(characters) do
        buttonColor = myColors.white
        if characterData.label == character then
            buttonColor = myColors.green
            selectedCharacter = characterData.label
        end
        self.editButton({
            index = i,
            color = buttonColor
        })
    end
    self.editButton({
        index = 0,
        color = myColors.green
    })
end

----------------------
-- onclick button functions
----------------------
for _, characterData in ipairs(characters) do
    _G["onSelectClick_" .. characterData.label] = function(obj, color, alt_click)
        onSelectClick(characterData.label)
    end
end

function confirmVagabond(obj, color, alt_click)
    if selectedCharacter ~= "" then 
        local characterData = nil
        for _, char in ipairs(characters) do
            if char.label == selectedCharacter then
                characterData = char
                break
            end
        end

        if characterData then
            local factionBoard = getObjectFromGUID(factionBoardGUID)
            local factionBoardPos = factionBoard.getPosition()
            local factionBoardRot = factionBoard.getRotation()
            local newCardPos, newItemPos
            local relativeCard = {x = -8.32, y = 0.22, z = 4.7}
            local relativeItem = {x = 0.72, y = 0.2, z = 1.34}
            local flipped = false
            if factionBoardRot.y > 170 and factionBoardRot.y < 190 then
                flipped = true
                newCardPos = {
                    x = factionBoardPos.x - relativeCard.x, 
                    y = factionBoardPos.y + relativeCard.y + 1, 
                    z = factionBoardPos.z - relativeCard.z
                }
                newItemPos = {
                    x = factionBoardPos.x - relativeItem.x, 
                    y = factionBoardPos.y + relativeItem.y + 1, 
                    z = factionBoardPos.z - relativeItem.z
                }
            else
                newCardPos = {
                    x = factionBoardPos.x + relativeCard.x, 
                    y = factionBoardPos.y + relativeCard.y + 1, 
                    z = factionBoardPos.z + relativeCard.z
                }
                newItemPos = {
                    x = factionBoardPos.x + relativeItem.x, 
                    y = factionBoardPos.y + relativeItem.y + 1, 
                    z = factionBoardPos.z + relativeItem.z
                }
            end
            
            local storageBag = getObjectFromGUID(characterMeepleSupplyStorage)
            if storageBag then
                local cardFound = false
                for _, item in ipairs(storageBag.getObjects()) do
                    if item.guid == characterData.card then
                        cardFound = true
                        break
                    end
                end
                
                if not cardFound then
                    broadcastToAll(string.gsub(" "..selectedCharacter, "%W%l", string.upper):sub(2) .. " is already chosen!", color)
                    return
                end
                
                for _, item in ipairs(storageBag.getObjects()) do
                    if item.guid == characterData.card then
                        local card = storageBag.takeObject({
                            guid = item.guid,
                            position = newCardPos,
                            rotation = factionBoardRot,
                            smooth = false
                        })
                        Wait.time(function()
                            card.setLock(true)
                        end, 3)
                        break
                    end
                end
                
                for _, item in ipairs(storageBag.getObjects()) do
                    if item.guid == characterData.meeple then
                        local meeple = storageBag.takeObject({
                            guid = item.guid,
                            position = newCardPos,
                            rotation = factionBoardRot
                        })
                        break
                    end
                end
                
                broadcastToAll(Player[color].steam_name .. " chose the " .. string.gsub(" "..selectedCharacter, "%W%l", string.upper):sub(2), color)
                
                local itemBag = getObjectFromGUID(itemBagSupplyStorage)
                if itemBag then
                    local gridSize = 3
                    local itemSpacing = 1.25
                    local mod = 1
                    if flipped then
                        mod = -1
                    end
                    
                    for i, itemType in ipairs(characterData.items) do
                        local itemGUIDs = itemBank[itemType]
                        local itemPlaced = false
                        
                        for _, guid in ipairs(itemGUIDs) do
                            for _, bagItem in ipairs(itemBag.getObjects()) do
                                if bagItem.guid == guid then
                                    local row = math.floor((i-1) / gridSize)
                                    local col = (i-1) % gridSize
                                    local itemPos = {
                                        x = newItemPos.x - col * itemSpacing * mod,
                                        y = newItemPos.y,
                                        z = newItemPos.z + row * itemSpacing * mod
                                    }
                                    itemBag.takeObject({
                                        guid = guid,
                                        position = itemPos,
                                        rotation = factionBoardRot
                                    })
                                    itemPlaced = true
                                    break
                                end
                            end
                            if itemPlaced then break end
                        end
                        
                        if not itemPlaced then
                            print("No more copies of " .. itemType .. ".", color)
                        end
                    end
                else
                    print("Error: Item storage bag not found.", color)
                end
                
                Wait.frames(function()
                    self.destruct()
                end, 10)
            else
                print("Error: Character storage bag not found.", color)
            end
        else
            print("Error: Selected character not found.", color)
        end
    else
        broadcastToAll("Please select a character first.", color)
    end
end