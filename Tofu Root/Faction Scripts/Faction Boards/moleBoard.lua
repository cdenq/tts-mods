----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Mole Board")

----------------------
-- Variables
----------------------
deckZoneGUID = "cf89ff"
boardZoneGUID = "29b2c0"
burrowObjGUID = "78c688"
warriorBagGUID = "39e6dd"
keyword = "moleRecruiter"
handzoneGUIDS = {
    Red = {"3ec4f1", "f001d4"},
    Purple = {"f8e77a", "855e1e"},
    White = {"502194", "82850f"},
    Yellow = {"1accdc", "6ec2ec"},
    Green = {"a02c64", "f4046f"},
    Blue = {"fc815f", "d39fcf"},
}

----------------------
-- onload function
----------------------
function onLoad()
    createDrawButton()
    createPlaceButton()
    createRecruitButton()
    createDiscardButton()
end

----------------------
-- create button functions
----------------------
function createDrawButton()
    self.createButton({
        click_function = "draw",
        function_owner = self,
        label = "DRAW CARD",
        position = {-1.01, 0.25, 0.93},
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

function createPlaceButton()
    self.createButton({
        click_function = "place",
        function_owner = self,
        label = "PLACE",
        position = {0, 0.2, -0.315},
        rotation = {0, 0, 0},
        scale = {0.035, 0.035, 0.035},
        width = 2100,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Places the correct number of Mole Warriors in the Burrow. Use during your Birdsong upkeep."
    })
end

function createRecruitButton()
    self.createButton({
        click_function = "recruit",
        function_owner = self,
        label = "RECRUIT",
        position = {-0.47, 0.2, -0.14},
        rotation = {0, 0, 0},
        scale = {0.035, 0.035, 0.035},
        width = 2500,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Recruits 1 Mole Warrior to the Burrow. Use as 1 of your Assembly actions."
    })
end

function createDiscardButton()
    self.createButton({
        click_function = "discardCard",
        function_owner = self,
        label = "DISCARD RANDOM CARD",
        position = {0.9, 0.25, -0.43},
        rotation = {0, 0, 0},
        scale = {0.04, 0.04, 0.04},
        width = 4200,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Randomly discards one of your cards. Use when paying Price of Failure."
    })
end

----------------------
-- on click functions
----------------------
function draw(obj, color)
    local deckZone = getObjectFromGUID(deckZoneGUID)
    local objInZone = deckZone.getObjects()
    for _, obj in ipairs(objInZone) do
        if obj.tag == "Deck" or obj.tag == "Card" then
            getObjectFromGUID(obj.guid).deal(1, color)
        end
    end
end

function place(obj, color, alt_click)
    local playerName = Player[color].steam_name
    local boardZone = getObjectFromGUID(boardZoneGUID)
    local recruiters = {}
    for _, obj in ipairs(boardZone.getObjects()) do
        if obj.getGMNotes() == keyword then
            table.insert(recruiters, obj)
        end
    end

    local numToPlace = 0
    if #recruiters == 0 then
        numToPlace = 1
    elseif #recruiters == 1 then
        numToPlace = 2
    elseif #recruiters == 2 then
        numToPlace = 4
    elseif #recruiters == 3 then
        numToPlace = 6
    end

    local warriorBag = getObjectFromGUID(warriorBagGUID)
    if warriorBag.getQuantity() == 0 then
        broadcastToAll("No more warriors to place.", color)
        return
    elseif warriorBag.getQuantity() < numToPlace then
        broadcastToAll("Not enough warriors to auto-place. You need to add " .. numToPlace .. " warriors but only have " .. warriorBag.getQuantity() .. " left.", color)
        return
    else
        placeWarrior(numToPlace)
        printToAll(playerName .. " recruits " .. numToPlace .. " warrior(s) in Birdsong.", color)
    end
end

function recruit(obj, color, alt_click)
    local playerName = Player[color].steam_name
    local warriorBag = getObjectFromGUID(warriorBagGUID)
    if warriorBag.getQuantity() == 0 then
        broadcastToAll("No more warriors to place.")
        return
    else
        placeWarrior(1)
        printToAll(playerName .. " recruits " .. 1 .. " warrior in Daylight.", color)
    end
end

function placeWarrior(numToPlace)
    local burrowObj = getObjectFromGUID(burrowObjGUID)
    local warriorBag = getObjectFromGUID(warriorBagGUID)
    local recruiterPosition = burrowObj.getPosition()
    local recruiterRotation = burrowObj.getRotation()
    
    local spacing = 1.5
    local rows = 2
    local cols = 3
    local placed = 0
    
    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            if placed < numToPlace then
                local warriorPosition = {
                    x = recruiterPosition.x + (col * spacing),
                    y = recruiterPosition.y + 9,
                    z = recruiterPosition.z + (row * spacing)
                }
                
                warriorBag.takeObject({
                    position = warriorPosition,
                    rotation = recruiterRotation
                })
                
                placed = placed + 1
            end
        end
    end
end

function discardCard(obj, color, alt_click)
    local targetPosition = {27.84, 3.65, 25.03}
    local playerHandZones = handzoneGUIDS[color]
    local cardsToDiscard = {}
    
    for _, zoneGUID in ipairs(playerHandZones) do
        local zone = getObjectFromGUID(zoneGUID)
        if zone then
            local cardsInZone = zone.getObjects()
            for _, card in ipairs(cardsInZone) do
                table.insert(cardsToDiscard, card)
            end
        end
    end
    
    cardsToDiscard[math.random(1, #cardsToDiscard)].setPosition(targetPosition)
    printToAll(Player[color].steam_name .. " randomly discards " .. 1 .. " card.", color)
end