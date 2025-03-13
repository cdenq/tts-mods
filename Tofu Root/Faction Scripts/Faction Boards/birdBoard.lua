----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Bird Board")

----------------------
-- Variables
----------------------
deckZone = getObjectFromGUID("cf89ff")
eyrieDecreeBoardGUID = "09f03c"
eyrieFactionBoardGUID = "52af3f"
eyrieLeaders = {
    builder = {
        GUIDs = {"bafe2a", "46d9b1"}, 
        actions = {"recruit", "move"}
    }, 
    charismatic = {
        GUIDs = {"50b830", "15e0c0"}, 
        actions = {"recruit", "battle"}
    },
    commander = {
        GUIDs = {"e05df9", "adf73d"}, 
        actions = {"move", "battle"}
    },
    despot = {
        GUIDs = {"4532d6", "56c643"},
        actions = {"move", "build"}
    }
}
eyrieViziersGUIDs = {
    one = {"226301", "4de0a7"},
    two = {"4df337", "81852f"}
}
decreeRelativeLocations = {
    recruit = {1.395, 1, -0.39},
    move = {0.465, 1, -0.39},
    battle = {-0.465, 1, -0.39},
    build = {-1.395, 1, -0.39}
}

----------------------
-- onload function
----------------------
function onLoad()
    createAllButtons()
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createDrawButton()
    createTurmoilButton()
    createLeaderSetupButton()
end

function createDrawButton()
    self.createButton({
        click_function = "draw",
        function_owner = self,
        label = "DRAW CARD",
        position = {-1.01, 0.18, 0.93},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 2800,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Draw 1 card from the Deck."
    })
end

function createTurmoilButton()
    self.createButton({
        click_function = "turmoil",
        function_owner = self,
        label = "TURMOIL",
        position = {0.25, 0.18, 0.75},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 2900,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Counts Bird-suited cards in Decree and sorts all cards for discard. Use when triggering Turmoil."
    })
end

function createLeaderSetupButton()
    self.createButton({
        click_function = "setupLeader",
        function_owner = self,
        label = "SET LEADER",
        position = {0.9, 0.18, 0.96},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 2900,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Sets the Loyal Viziers to their appropriate column. Use when selecting a new Leader."
    })
end

----------------------
-- on click functions
----------------------
function draw(obj, color)
    local objInZone = deckZone.getObjects()
    for _, obj in ipairs(objInZone) do
        if obj.tag == "Deck" or obj.tag == "Card" then
            getObjectFromGUID(obj.guid).deal(1, color)
        end
    end
end

function turmoil(obj, color)
    local eyrieDecreeBoardObj = getObjectFromGUID(eyrieDecreeBoardGUID)
    local boardPosition = eyrieDecreeBoardObj.getPosition()
    local zoneSize = {x = 20, y = 5, z = 12}
    
    local hitList = Physics.cast({
        origin = boardPosition,
        direction = {0, 1, 0},
        type = 3,
        size = zoneSize,
        max_distance = 0
        --debug = true
    })
    
    local birdCount = 0
    local vizierPile = {}
    local otherPile = {}
    for _, hit in ipairs(hitList) do
        local card = hit.hit_object
        if card.tag == "Card" then
            local description = card.getDescription()
            for _ in string.gmatch(description, "Bird") do
                birdCount = birdCount + 1
            end
            
            if string.match(card.getName(), "Vizier") then
                table.insert(vizierPile, card)
            else
                table.insert(otherPile, card)
            end
        end
    end
    
    printToAll("Bird-suited cards in decree: " .. birdCount .. ".", color)
    
    local vizierPilePosition = eyrieDecreeBoardObj.positionToWorld({-0.8, 1, 0})
    local otherPilePosition = eyrieDecreeBoardObj.positionToWorld({0.8, 1, 0})
    
    for i, card in ipairs(vizierPile) do
        local xOffset = 1.2 * (i - 1)
        local zOffset = 1.2 * (i - 1)
        card.setPositionSmooth({
            x = vizierPilePosition.x + xOffset,
            y = vizierPilePosition.y + (0.1 * i),
            z = vizierPilePosition.z + zOffset
        })
    end
    
    for i, card in ipairs(otherPile) do
        local xOffset = 0.3 * (i - 1)
        local zOffset = 0.3 * (i - 1)
        card.setPositionSmooth({
            x = otherPilePosition.x + xOffset,
            y = otherPilePosition.y + (0.1 * i),
            z = otherPilePosition.z + zOffset
        })
    end
end

function setupLeader()
    local eyrieFactionBoardObj = getObjectFromGUID(eyrieFactionBoardGUID)
    local eyrieFactionBoardPosition = eyrieFactionBoardObj.getPosition()
    local zoneSize = {x = 18, y = 5, z = 15}

    local hitList = Physics.cast({
        origin = eyrieFactionBoardPosition,
        direction = {0, 1, 0},
        type = 3,
        size = zoneSize,
        max_distance = 0
        --debug = true
    })

    local selectedLeader = nil
    for _, hit in ipairs(hitList) do
        local card = hit.hit_object
        if card.tag == "Card" then
            local cardGUID = card.getGUID()
            for leaderType, leaderInfo in pairs(eyrieLeaders) do
                for _, leaderGUID in ipairs(leaderInfo.GUIDs) do
                    if cardGUID == leaderGUID then
                        selectedLeader = leaderType
                        break
                    end
                end
                if selectedLeader then break end
            end
        end
        if selectedLeader then break end
    end

    local eyrieDecreeBoardObj = getObjectFromGUID(eyrieDecreeBoardGUID)
    if selectedLeader then
        local leaderActions = eyrieLeaders[selectedLeader].actions
        local usedViziers = {}

        for actionIndex, action in ipairs(leaderActions) do
            local relativePosition = decreeRelativeLocations[action]
            local vizierPosition = eyrieDecreeBoardObj.positionToWorld(relativePosition)
            
            local vizierFound = false
            for _, vizierType in ipairs({"one", "two"}) do
                for _, vizierGUID in ipairs(eyrieViziersGUIDs[vizierType]) do
                    if not usedViziers[vizierGUID] then
                        local vizier = getObjectFromGUID(vizierGUID)
                        if vizier then
                            vizier.setPositionSmooth(vizierPosition)
                            usedViziers[vizierGUID] = true
                            vizierFound = true
                            break
                        end
                    end
                end
                if vizierFound then break end
            end
            
            if not vizierFound then
                broadcastToAll("Error: Vizier card not found for action: " .. action)
            end
        end
    end
end