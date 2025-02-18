----------------------
-- Created for Tofu Worldview
-- Optimized and extended by cdenq
-- Original by Nevakanezah
----------------------
self.setName("Tofu Lizard Wizard Tool")

----------------------
-- variables
----------------------
wait_id = 0
outcastMarkerGUID = "d90535"
outcastMarker = getObjectFromGUID(outcastMarkerGUID)
variableData = {
    mouse = {
        label = "0",
        buttonPosition = {0.45, 0.25, 0.03},
        dominancePosition = {-45.19, 1.60, -9.80},
        markerPosition = {-34.73, 1.89, 3.52},
        count = 0
    },
    bunny = {
        label = "0",
        buttonPosition = {0.45, 0.25, 0.4},
        dominancePosition = {-45.20, 1.60, -2.84},
        markerPosition = {-33.37, 1.89, 3.56},
        count = 0
    },
    fox = {
        label = "0",
        buttonPosition = {0.45, 0.25, 0.73},
        dominancePosition = {-45.22, 1.60, -16.79},
        markerPosition = {-31.98, 1.89, 3.58},
        count = 0
    },
    other = {
        dominancePosition = {-45.23, 1.60, 4.18},
        discardPosition = {-34.53, 1.60, -9.77},
        dominanceCount = 0
    }
}
myIterations = {"mouse", "bunny", "fox"}

----------------------
-- onload function
----------------------
function onLoad()
    createAllButtons()
    wait_id = Wait.time(updateCardCount, 1, -1)
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createSuitCountButtons()
    createDomCountButton()
    createUpdateOutcastButton() 
end

function createSuitCountButtons()
    for i, suit in ipairs(myIterations) do
        self.createButton({
            click_function = "doNothing",
            function_owner = self,
            label = variableData[suit].label,
            position = variableData[suit].buttonPosition,
            scale = {0.9, 0.5, 0.9},
            width = 0,
            height = 0,
            font_size = 120
        })
    end
end

function createDomCountButton()
    self.createButton({
        click_function = "doNothing",
        function_owner = self,
        label = "Dominance: 0",
        position = {0.72, 0.20, -0.17},
        scale = {0.45, 0.25, 0.45},
        width = 0,
        height = 0,
        font_size = 80
    })
end

function createUpdateOutcastButton()
    self.createButton({
        click_function = "updateOutcastMarker",
        function_owner = self,
        label = "Update Outcast",
        position = {-0.5, 0.25, 1.1},
        scale = {0.5, 0.5, 0.5},
        width = 800,
        height = 250,
        font_size = 75
    })
end 

----------------------
-- helper functions
----------------------
function doNothing()
end

function onDestroy()
    Wait.stop(wait_id)
end

function round(num)
    return math.floor(num + 0.5)
end

----------------------
-- update card functions
----------------------
function updateCardCount()
    checkCards()
    updateButtons()
end

function checkCards()
    for i, suit in ipairs(myIterations) do
        variableData[suit].count = 0
    end
    variableData["other"].dominanceCount = 0

    local items = getCards()
    for _, item in ipairs(items) do
        if item.hit_object.tag == "Card" then
            parseCard(item.hit_object.getDescription(), item.hit_object.getName())
        elseif item.hit_object.tag == "Deck" then
            for _, card in ipairs(item.hit_object.getObjects()) do
                parseCard(card.description, card.nickname)
            end
        end
    end
end

function getCards()
    local result = Physics.cast({
        origin = self.positionToWorld({0.4, 0.2, 0.45}),
        direction = self.getTransformUp(),
        type = 3,
        size = {3, 0.1, 6},
        max_distance = 2
        --debug = true
    })
    return result or {}
end

function parseCard(foundSuit, foundName)
    for i, suit in ipairs(myIterations) do
        if string.find(foundSuit:lower(), suit) then
            variableData[suit].count = variableData[suit].count + 1
        end
    end

    if string.find(foundName:lower(), "dominance") then
        variableData["other"].dominanceCount = variableData["other"].dominanceCount + 1
    end
end

function updateButtons()
    for i = 0, 2 do
        self.editButton({
            index = i, 
            label = tostring(variableData[myIterations[i + 1]].count)}
        )
    end 
    
    local dominanceColor
    if variableData["other"].dominanceCount > 0 then
        dominanceColor = {1, 0, 0}
    else 
        dominanceColor = {1, 1, 1}
    end

    self.editButton({
        index = 3,
        label = "Dominance: " .. tostring(variableData["other"].dominanceCount),
        font_color = dominanceColor
    })
end

----------------------
-- update marker function 
----------------------
function updateOutcastMarker()
    checkMarker()
    sortAndMoveCards()
end

function checkMarker()
    local maxCount = -1
    local highestSuits = {}
    
    for _, suit in ipairs(myIterations) do
        local currentCount = variableData[suit].count
        if currentCount > maxCount then
            maxCount = currentCount
            highestSuits = {suit}
        elseif currentCount == maxCount then
            table.insert(highestSuits, suit)
        end
    end
    
    local currentPos = outcastMarker.getPosition()

    if #highestSuits == 1 then
        moveMarker(highestSuits[1])
    else --tied for highest
        flipMarkerUp()
    end
end

function moveMarker(suit)
    local currentPos = outcastMarker.getPosition()
    local moveToPos = variableData[suit].markerPosition
    compareCurrentX = round(currentPos.x)
    compareMoveToX = round(moveToPos[1])
    if compareCurrentX == compareMoveToX then
        flipMarkerUp()
    else
        local newPos = {
            x = moveToPos[1],
            y = moveToPos[2] + 1,
            z = moveToPos[3]
        }
        outcastMarker.setPositionSmooth(newPos)
        flipMarkerDown()
    end
end

function flipMarkerUp()
    local currentPos = outcastMarker.getPosition()
    local newPos = {
        x = currentPos.x,
        y = currentPos.y + 1,
        z = currentPos.z
    }

    local currentRot = outcastMarker.getRotation()
    if round(currentRot.z) == 0 then
        local newRot = {
            x = currentRot.x,
            y = currentRot.y,
            z = currentRot.z + 180
        }
        outcastMarker.setRotationSmooth(newRot)
    end

    outcastMarker.setPositionSmooth(newPos)
end

function flipMarkerDown()
    local currentRot = outcastMarker.getRotation()
    if round(currentRot.z) == 180 then
        local newRot = {
            x = currentRot.x,
            y = currentRot.y,
            z = currentRot.z + 180
        }
        outcastMarker.setRotationSmooth(newRot)
    end
end

function sortAndMoveCards()    
    local items = getCards()
    for _, item in ipairs(items) do
        if item.hit_object.tag == "Card" then
            moveCard(item.hit_object)
        elseif item.hit_object.tag == "Deck" then
            local deck = item.hit_object
            local cards = deck.getObjects()
            for i = #cards, 1, -1 do
                local card = deck.takeObject({
                    position = {deck.getPosition().x, deck.getPosition().y + 5, deck.getPosition().z},
                    smooth = false
                })
                moveCard(card)
            end
        end
    end
end

function moveCard(card)
    local foundName = card.getName():lower()
    local foundDescription = card.getDescription():lower()
    local placed = false
    
    if string.find(foundName, "dominance") then
        for i, suit in ipairs(myIterations) do
            if string.find(foundDescription, suit) then
                card.setPositionSmooth(variableData[suit].dominancePosition)
                placed = true
            end
        end
        if placed == false then 
            card.setPositionSmooth(variableData["other"].dominancePosition)
        end
    else --normal card
        card.setPositionSmooth(variableData["other"].discardPosition)
    end
end