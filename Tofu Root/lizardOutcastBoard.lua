----------------------
-- Created for Tofu Worldview
-- Code-edited by cdenq and Claude
-- Original by Nevakanezah
----------------------
self.setName("Tofu Lizard Wizard Tool")

----------------------
-- variables
----------------------
wait_id = 0
buttonData = {
    {ref = "mouse", label = "0", position = {0.45, 0.25, 0.03}},
    {ref = "bunny", label = "0", position = {0.45, 0.25, 0.4}},
    {ref = "fox", label = "0", position = {0.45, 0.25, 0.73}}
}
myCounters = {
    mice = 0,
    bunnies = 0,
    foxes = 0,
    dominance = 0
}
dominancePositions = {
    fox = {-42.75, 2.09, -9.58},
    bunny = {-42.73, 2.09, -2.70},
    mouse = {-42.63, 2.09, 4.22},
    bird = {-42.65, 2.09, 11.13}
}
discardPosition = {-32.10, 2.08, -2.64}
outcastPositions = {
    mouse = {-32.33, 1.78, 10.56},
    bunny = {-30.97, 1.78, 10.60},
    fox = {-29.58, 1.78, 10.61}
}
outcastMarkerGUID = "d90535"

----------------------
-- onload function
----------------------
function onLoad(save_state)
    createAllButtons()
    wait_id = Wait.time(
        updateAllButtons, 
    1, -1)
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createButtons()
    createDominanceButton()
    createUpdateOutcastButton() 
end

function createButtons()
    for i, data in ipairs(buttonData) do
        self.createButton({
            click_function = "nothing",
            function_owner = self,
            label = data.label,
            position = data.position,
            scale = {0.9, 0.5, 0.9},
            width = 0,
            height = 0,
            font_size = 120
        })
    end
end

function createDominanceButton()
    self.createButton({
        click_function = "nothing",
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
function onDestroy()
    Wait.stop(wait_id)
end

function nothing()
end

function checkCards()
    myCounters.mice = 0
    myCounters.bunnies = 0
    myCounters.foxes = 0
    myCounters.dominance = 0

    local items = getCards()
    for _, item in ipairs(items) do
        if item.hit_object.tag == "Card" then
            addCard(item.hit_object.getDescription(), item.hit_object.getName())
        end
        if item.hit_object.tag == "Deck" then
            for _, card in ipairs(item.hit_object.getObjects()) do
                addCard(card.description, card.nickname)
            end
        end
    end
end

function getCards()
    local result = Physics.cast({
        origin       = self.positionToWorld({0.4, 0.2, 0.45}),
        direction    = self.getTransformUp(),
        type         = 3,
        size         = {3, 0.1, 6},
        max_distance = 2
    })
    return result or {}
end

function addCard(suit, name)
    suit = suit:lower()
    if string.find(suit, "fox") and string.find(suit, "mouse") and string.find(suit, "bunny") then
        myCounters.foxes = myCounters.foxes + 1
        myCounters.bunnies = myCounters.bunnies + 1
        myCounters.mice = myCounters.mice + 1
    elseif string.find(suit, "fox") then
        myCounters.foxes = myCounters.foxes + 1
    elseif string.find(suit, "mouse") then
        myCounters.mice = myCounters.mice + 1
    elseif string.find(suit, "bunny") then
        myCounters.bunnies = myCounters.bunnies + 1
    end
    if string.find(name:lower(), "dominance") then
        myCounters.dominance = myCounters.dominance + 1
    end
end

function updateButtons()
    self.editButton({index=0, label=tostring(myCounters.mice)})
    self.editButton({index=1, label=tostring(myCounters.bunnies)})
    self.editButton({index=2, label=tostring(myCounters.foxes)})
    
    local dominanceColor = {1, 1, 1}
    if myCounters.dominance > 0 then
        dominanceColor = {1, 0, 0}
    end
    self.editButton({
        index = 3,
        label = "Dominance: " .. tostring(myCounters.dominance),
        font_color = dominanceColor
    })
end

----------------------
-- main function
----------------------
function updateAllButtons()
    checkCards()
    updateButtons()
end

function updateOutcastMarker()
    moveMarker()
    sortAndMoveCards()
end

----------------------
-- main helper function
----------------------
function sortAndMoveCards()    
    local items = getCards()
    for _, item in ipairs(items) do
        if item.hit_object.tag == "Card" then
            moveCard(item.hit_object, dominancePositions, discardPosition)
        elseif item.hit_object.tag == "Deck" then
            local deck = item.hit_object
            local cards = deck.getObjects()
            for i = #cards, 1, -1 do
                local card = deck.takeObject({
                    position = {deck.getPosition().x, deck.getPosition().y + 5, deck.getPosition().z},
                    smooth = false
                })
                moveCard(card, dominancePositions, discardPosition)
            end
        end
    end
end

function moveCard(card, dominancePositions, discardPosition)
    local name = card.getName():lower()
    local description = card.getDescription():lower()
    
    if string.find(name, "dominance") then
        local suit
        if string.find(description, "fox") then
            suit = "fox"
        elseif string.find(description, "bunny") then
            suit = "bunny"
        elseif string.find(description, "mouse") then
            suit = "mouse"
        elseif string.find(description, "bird") then
            suit = "bird"
        end
        card.setPositionSmooth(dominancePositions[suit])
    else
        card.setPositionSmooth(discardPosition)
    end
end

function moveMarker()
    local miceLocked = myCounters.mice
    local bunniesLocked = myCounters.bunnies
    local foxesLocked = myCounters.foxes

    local outcastMarker = getObjectFromGUID(outcastMarkerGUID)
    if not outcastMarker then return end

    local highestCount = math.max(miceLocked, bunniesLocked, foxesLocked)
    local highestSuits = {}
    if miceLocked == highestCount then table.insert(highestSuits, "mouse") end
    if bunniesLocked == highestCount then table.insert(highestSuits, "bunny") end
    if foxesLocked == highestCount then table.insert(highestSuits, "fox") end

    local currentPosition = outcastMarker.getPosition()
    local newPositionX, newPositionZ

    if #highestSuits == 1 then
        newPositionX = outcastPositions[highestSuits[1]][1]
        newPositionZ = outcastPositions[highestSuits[1]][3]
    else
        newPositionX = math.floor(currentPosition.x * 100 + 0.5) / 100
        newPositionZ = math.floor(currentPosition.z * 100 + 0.5) / 100
    end

    local newPosition = {
        x = newPositionX,
        y = currentPosition.y + 0.25,
        z = newPositionZ
    }

    local newRotation
    if newPositionX == math.floor(currentPosition.x * 100 + 0.5) / 100 then
        newRotation = {0, 90, 180}
    else
        newRotation = {0, 90, 0}
    end

    outcastMarker.setPositionSmooth(newPosition)
    outcastMarker.setRotationSmooth(newRotation)
end