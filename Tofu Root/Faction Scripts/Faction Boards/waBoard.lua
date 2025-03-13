----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu WA Board")

----------------------
-- Variables
----------------------
deckZone = "cf89ff"
handZoneParameters = {
    zoneWidth = 20,
    zoneHeight = 5,
    zoneThickness = 7,
    zoneYOffset = 5,
    zoneScale = {x = 1, y = 1, z = 1}
}
warriorBagGUID = "ebc24d"
handZoneGUID = "aa1111"
activeHandZone = nil
myIterations = {"mouse", "bunny", "fox"}
myColors = {
    fox = {0.886, 0.318, 0.204},
    mouse = {0.945, 0.573, 0.380},
    bunny = {0.941, 0.843, 0.376}
}

----------------------
-- onload function
----------------------
function onLoad()
    createDrawButton()
    createHandZoneSpawnButton()
    createCounterButton()
    createDiscardSupporterButtons()
    Wait.time(updateHandZoneCounter, 1, -1)
end

----------------------
-- create button functions
----------------------
function createDrawButton()
    self.createButton({
        click_function = "basicDraw",
        function_owner = self,
        label = "DRAW CARD",
        position = {1.01, 0.25, -0.025},
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

function createHandZoneSpawnButton()
    self.createButton({
        click_function = "onHandZoneButtonClick",
        function_owner = self,
        label = "SETUP SUPPORTERS",
        position = {-0.9, 0.25, 0.1},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 3500,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Draws 3 Supporters from the Deck and adds it the Supporters hand. Use during Setup."
    })
end

function createCounterButton()
    self.createButton({
        click_function = "doNothing",
        function_owner = self,
        label = "Supporters: 0",
        position = {0, 0.25, -0.935},
        rotation = {0, 0, 0},
        scale = {0.5, 0.5, 0.5},
        width = 0,
        height = 0,
        font_color = {0, 0, 0},
        font_size = 100
    })
end

function createDiscardSupporterButtons()
    for i, value in ipairs(myIterations) do 
        self.createButton({
            click_function = "discardSupporters" .. value,
            function_owner = self,
            label = "REMOVE " .. value:upper() .. " BASE",
            position = {-0.36, 0.25, 0.25 - (i-1) * 0.05},
            rotation = {0, 0, 0},
            scale = {0.05, 0.05, 0.05},
            width = 2000,
            height = 450,
            color = myColors[value],
            font_color = {0, 0, 0},
            font_size = 200,
            tooltip = "Halves the number of Officers and removes all Bird and " .. titleCase(value) .. " Supporters from the Supporters hand. Use when removing a " .. titleCase(value) .. " Base."
        })
    end
end

----------------------
-- on click functions
----------------------
for i, value in ipairs(myIterations) do
    _G["discardSupporters" .. value] = function(obj, color, alt_click)
        discardSupporters(value, color)
    end
end

----------------------
-- helper functions
----------------------
function titleCase(str)
    return (str:gsub("(%a)([%w_']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end))
end

----------------------
-- functions
----------------------
function doNothing()
end

function basicDraw(obj, color)
    local objInZone = getObjectFromGUID(deckZone).getObjects()
    for _, obj in ipairs(objInZone) do
        if obj.tag == "Deck" or obj.tag == "Card" then
            getObjectFromGUID(obj.guid).deal(1, color)
        end
    end
end

function draw(obj, color, amount, targetZone)
    amount = amount or 1
    local objInZone = getObjectFromGUID(deckZone).getObjects()
    for _, obj in ipairs(objInZone) do
        if obj.tag == "Deck" or obj.tag == "Card" then
            local deck = getObjectFromGUID(obj.guid)
            for i = 1, amount do
                local card = deck.takeObject()
                if targetZone then
                    local zonePos = targetZone.getPosition()
                    card.setPosition({
                        x = zonePos.x,
                        y = zonePos.y,
                        z = zonePos.z
                    })
                    card.setRotation({
                        targetZone.getRotation().x,
                        targetZone.getRotation().y + 180,
                        targetZone.getRotation().z,
                    })
                else
                    deck.deal(1, color)
                end
            end
            break
        end
    end
end

function onHandZoneButtonClick(obj, color)
    local newZone = createHandZone(color)
    activeHandZone = newZone
    self.removeButton(1)
    Wait.frames(function() draw(obj, color, 3, newZone) end, 10)
end

function createHandZone(playerColor)
    local playerHandPos = Player[playerColor].getHandTransform()
    local zonePos = {}
    local zoneRot = playerHandPos.rotation

    if zoneRot.y > 170 and zoneRot.y < 190 then
        zonePos = {
            x = playerHandPos.position.x + 15.66,
            y = playerHandPos.position.y - 0.94,
            z = playerHandPos.position.z - 25.15
        }
    else
        zonePos = {
            x = playerHandPos.position.x - 15.66,
            y = playerHandPos.position.y - 0.94,
            z = playerHandPos.position.z + 25.15
        }
    end

    local newZone = spawnObject({
        type = "HandTrigger",
        position = zonePos,
        rotation = zoneRot,
        scale = handZoneParameters.zoneScale,
        guid = handZoneGUID
    })

    newZone.setColorTint(playerColor)
    newZone.setValue(playerColor)

    newZone.setScale({
        x = handZoneParameters.zoneWidth,
        y = handZoneParameters.zoneHeight,
        z = handZoneParameters.zoneThickness
    })

    return newZone
end

function updateHandZoneCounter()
    local zone = activeHandZone
    if not zone then
        zone = getObjectFromGUID(handZoneGUID)
    end
    local buttons = self.getButtons()
    
    local counterButtonIndex = nil
    for i, button in ipairs(buttons) do
        if button.click_function == "doNothing" then
            counterButtonIndex = i - 1
            break
        end
    end
    
    if zone and counterButtonIndex then
        local count = #zone.getObjects()
        if checkBases() == 3 and count > 5 then
            self.editButton({
                index = counterButtonIndex,
                font_color = "Red",
                label = "Supporters: " .. tostring(count)
            })
        else
            self.editButton({
                index = counterButtonIndex,
                font_color = {0, 0, 0},
                label = "Supporters: " .. tostring(count)
            })
        end
    end
end

function discardSupporters(suit, color)
    local zone = activeHandZone
    if not zone then
        zone = getObjectFromGUID(handZoneGUID)
    end

    local supportersInHand = zone.getObjects()
    local originalCount = #supportersInHand
    local cardsToDiscard = {}
    
    for _, obj in ipairs(supportersInHand) do
        local notes = obj.getDescription()
        if notes == "Bird" or notes == titleCase(suit) then
            table.insert(cardsToDiscard, obj)
        end
    end
    
    local discardCount = #cardsToDiscard
    
    if discardCount > 0 then
        local targetPosition = {27.84, 3.65, 25.03}
        for i = 1, #cardsToDiscard do
            cardsToDiscard[i].setPosition(targetPosition)
        end
        printToAll("Woodland Alliance discards " .. discardCount .. " out of " .. originalCount .. " Supporter(s).", color)
    end

    halveOfficers(color)
end

function checkBases()
    local hitList = Physics.cast({
        origin = self.getPosition(),
        direction = {0, 1, 0},
        type = 3,
        size = {x = 18, y = 5, z = 15},
        max_distance = 2
        -- debug = true
    })
    local totalItems = 0
    for _, hit in ipairs(hitList) do
        local obj = hit.hit_object
        if obj.type == "Tile" and obj.getGMNotes() == "waBase" then
            totalItems = totalItems + 1
        end
    end
    return totalItems
end

function halveOfficers(color)
    local hitList = Physics.cast({
        origin = self.getPosition(),
        direction = {0, 1, 0},
        type = 3,
        size = {x = 18, y = 5, z = 15},
        max_distance = 2
        -- debug = true
    })
    local totalOfficers = {}
    for _, hit in ipairs(hitList) do
        local obj = hit.hit_object
        if obj.type == "Figurine" and obj.getGMNotes() == "waWarrior" then
            table.insert(totalOfficers, obj)
        end
    end

    local warriorBag = getObjectFromGUID(warriorBagGUID)
    local lostOfficers = math.ceil(#totalOfficers / 2)

    if lostOfficers > 0 then
        for i = 1, lostOfficers do
            if totalOfficers[i] then
                warriorBag.putObject(totalOfficers[i])
            end
        end        
        printToAll("Woodland Alliance loses " .. lostOfficers .. " out of " .. #totalOfficers .. " Officer(s).", color)
    end
end