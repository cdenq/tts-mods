----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu AdSet Tool")

----------------------
-- variables
----------------------
bagGUID = "7528eb"
vagabondGUIDS = {
    tinker = "78ca46",
    thief = "1c02a2",
    ranger = "3db079",
    vagrant = "a67db3",
    scoundrel = "f69c98",
    arbiter = "c33cb1",
    adventurer = "8548a4",
    harrier = "afbc63",
    ronin = "946238"
}
myButtons = {
    normalButtons = {buttonWidth = 300, buttonHeight = 75, fontSize = 35},
    buttonliftHeight = 0.25
}
myPlacements = {
    gridWidth = 5,
    gridHeight = 2,
    startX = 1.159,
    startZ = -0.56,
    spacingX = 0.58,
    spacingZ = 0.75
}
myColors = {
    white = {1, 1, 1},
    gray = {0.5, 0.5, 0.5},
    green = {0, 1, 0},
    red = {1, 0, 0},
    black = {0, 0, 0}
}
extraDrafts = 0
minDrafts = 0
maxDrafts = 2
guidsToRecall = {}
spawnHeight = 2

----------------------
-- onload
----------------------
function onload()
    setVariables()
    createAllButtons()
end

----------------------
-- helper functions
----------------------
function randomPick(selectList, drawList, depositList)
    local index = math.random(#selectList)
    local faction = table.remove(drawList, index)
    table.insert(depositList, faction)
    return faction
end

function setVariables()
    militantPool = {}
    totalPool = {}
    vagaPool = {
        "tinker", 
        "thief", 
        "ranger",
        "vagrant",
        "scoundrel",
        "arbiter",
        "adventurer",
        "harrier",
        "ronin"
    }
    pickedFactions = {}
    pickedCharacters = {}

    checkBagContents()
end

function checkBagContents()
    local bag = getObjectFromGUID(bagGUID)
    if not bag then
        print("Bag (" .. bagGUID .. ") not found.")
        return
    end

    local bagContents = bag.getObjects()
    
    for _, item in ipairs(bagContents) do
        for label, faction in pairs(factionGUIDS) do
            if item.guid == faction.guid then
                if faction.type == "militant" then
                    table.insert(militantPool, label)
                    table.insert(totalPool, label)
                elseif faction.type == "insurgent" then
                    table.insert(totalPool, label)
                end
                break
            end
        end
    end
end

function getNumPlayers()
    local seated = getSeatedPlayers()
    return #seated
end

----------------------
-- debug functions
----------------------
function printPools()
    print("---------------")
    print("Factions")
    for i, value in ipairs(pickedFactions) do
        print(i .. value)
    end
    print("Characters")
    for i, value in ipairs(pickedCharacters) do
        print(i .. value)
    end
end

----------------------
-- main functions
----------------------
function pickRandomFactions(numPlayers)
    local currentTotalPool = {}
    local currentVagaPool = {}

    -- Pick a random militant faction
    randomPick(militantPool, totalPool, pickedFactions)

    -- Pick remaining factions
    while #pickedFactions < numPlayers + 1 + extraDrafts do
        recentPick = randomPick(totalPool, totalPool, pickedFactions)
        if recentPick == "vaga" then
            table.insert(totalPool, "vaga2")
            randomPick(vagaPool, vagaPool, pickedCharacters)
        elseif recentPick == "vaga2" then
            randomPick(vagaPool, vagaPool, pickedCharacters)
        end
    end
    moveItemsToGrid()
end

function moveItemsToGrid()
    local bag = getObjectFromGUID(bagGUID)
    if not bag then
        print("Bag (" .. bagGUID .. ") not found.")
        return
    end

    local objectRotation = self.getRotation()
    local vagaCount = 0
    local gridIndex = 1

    for i, factionLabel in ipairs(pickedFactions) do
        local faction = factionGUIDS[factionLabel]
        
        if faction then
            local col = (gridIndex - 1) % myPlacements.gridWidth
            local row = math.floor((gridIndex - 1) / myPlacements.gridWidth)
            local posX = myPlacements.startX - col * myPlacements.spacingX
            local posZ = myPlacements.startZ + row * myPlacements.spacingZ
            local relativePos = {posX, myButtons.buttonliftHeight, posZ}
            local worldPos = self.positionToWorld(relativePos)
            local spawnPos = {worldPos[1], worldPos[2], worldPos[3]}

            if factionLabel == "vaga" or factionLabel == "vaga2" then
                vagaCount = vagaCount + 1
                local vagabondLabel = pickedCharacters[vagaCount]
                local vagabondGUID = vagabondGUIDS[vagabondLabel]
                if vagabondGUID then
                    local char = bag.takeObject({
                        guid = vagabondGUID,
                        position = {spawnPos[1], spawnPos[2], spawnPos[3]},
                        rotation = objectRotation,
                        smooth = false
                    })
                    if char then
                        char.setRotation(objectRotation)
                        char.setPositionSmooth({worldPos[1], worldPos[2], worldPos[3]}, false, true)
                    end
                end
            end

            local item = bag.takeObject({
                guid = faction.guid,
                position = spawnPos,
                rotation = objectRotation,
                smooth = false
            })
            if item then
                item.setRotation(objectRotation)
                item.setPositionSmooth({worldPos[1], worldPos[2] + spawnHeight, worldPos[3]}, false, true)
            end

            gridIndex = gridIndex + 1
        end

        if gridIndex > myPlacements.gridWidth * myPlacements.gridHeight then
            break
        end
        Wait.frames(function() end, 5)
    end
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createRandomDraftButton()
    createExtraDraftButton()
    createRecallButton()
end

function createRandomDraftButton()
    self.createButton({
        click_function = "randomDraft",
        function_owner = self,
        label = "Random Draft",
        position = {1.18, myButtons.buttonliftHeight, -0.05},
        width = myButtons.normalButtons.buttonWidth,
        height = myButtons.normalButtons.buttonHeight,
        font_size = myButtons.normalButtons.fontSize,
        color = myColors.white,
        font_color = myColors.black
    })
end

function createExtraDraftButton()
    self.createButton({
        click_function = "extraDraftClick",
        function_owner = self,
        label = "Extra Drafts: " .. extraDrafts,
        position = {1.18, myButtons.buttonliftHeight, 0.2},
        width = myButtons.normalButtons.buttonWidth,
        height = myButtons.normalButtons.buttonHeight,
        font_size = myButtons.normalButtons.fontSize,
        color = myColors.white,
        font_color = myColors.black
    })
end

function createRecallButton()
    self.createButton({
        click_function = "recallItemsToBag",
        function_owner = self,
        label = "Clear Drafts",
        position = {1.18, myButtons.buttonliftHeight, 0.45},
        width = myButtons.normalButtons.buttonWidth,
        height = myButtons.normalButtons.buttonHeight,
        font_size = myButtons.normalButtons.fontSize,
        color = myColors.white,
        font_color = myColors.black
    })
end

----------------------
-- click button functions
----------------------
function randomDraft()
    setVariables()
    recallItemsToBag()
    pickRandomFactions(getNumPlayers())
end

function extraDraftClick(obj, color, alt_click)
    if alt_click then
        extraDrafts = math.max(minDrafts, extraDrafts - 1)
    else
        extraDrafts = math.min(maxDrafts, extraDrafts + 1)
    end
    self.editButton({
        index = 1,
        label = "Extra Drafts: " .. extraDrafts
    })
end

function recallItemsToBag()
    local bag = getObjectFromGUID(bagGUID)
    if not bag then
        print("Bag (" .. bagGUID .. ") not found.")
        return
    end

    local guidsToRecall = {}

    -- Add faction GUIDs to recall list
    for _, faction in pairs(factionGUIDS) do
        table.insert(guidsToRecall, faction.guid)
    end

    -- Add vagabond GUIDs to recall list
    for _, guid in pairs(vagabondGUIDS) do
        table.insert(guidsToRecall, guid)
    end

    local allObjects = getAllObjects()
    for _, obj in ipairs(allObjects) do
        local objGUID = obj.getGUID()
        if objGUID ~= bagGUID then
            for _, guidToRecall in ipairs(guidsToRecall) do
                if objGUID == guidToRecall then
                    bag.putObject(obj)
                    break
                end
            end
        end
    end
end