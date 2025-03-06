----------------------
-- Edited for Tofu Worldview
-- Original by Root mod
-- Changes by cdenq
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
handZoneGUID = "aa1111"
activeHandZone = nil

----------------------
-- onload function
----------------------
function onLoad()
    createDrawButton()
    createHandZoneSpawnButton()
    createCounterButton()
    createCounterButtonR()
    Wait.time(updateHandZoneCounter, 1, -1)
end

----------------------
-- create button functions
----------------------
function createDrawButton()
    self.createButton({
        click_function = "basicDraw",
        function_owner = self,
        label = "DRAW 1 CARD",
        position = {-1.01, 0.25, 0.93},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 2900,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
    })
end

function createHandZoneSpawnButton()
    self.createButton({
        click_function = "onHandZoneButtonClick",
        function_owner = self,
        label = "MAKE HANDZONE",
        position = {-0.9, 0.25, 0.1},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 2900,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
    })
end

function createCounterButton()
    self.createButton({
        click_function = "doNothing",
        function_owner = self,
        label = "0",
        position = {-1.23, 0.25, 0.05},
        rotation = {0, 0, 0},
        scale = {0.5, 0.5, 0.5},
        width = 100,
        height = 100,
        font_size = 75,
        tooltip = "Current number of supporters."
    })
end

function createCounterButtonR()
    self.createButton({
        click_function = "doNothing",
        function_owner = self,
        label = "0",
        position = {-1.23, 0.25, -0.05},
        rotation = {0, 180, 0},
        scale = {0.5, 0.5, 0.5},
        width = 100,
        height = 100,
        font_size = 75,
        tooltip = "Current number of supporters."
    })
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
    if not self then return end
    local zone = activeHandZone
    if not zone then
        zone = getObjectFromGUID(handZoneGUID)
    end
    local buttons = self.getButtons()
    if not buttons then return end
    
    local counterButtonIndex = nil
    for i, button in ipairs(buttons) do
        if button.click_function == "doNothing" then
            counterButtonIndex = i - 1
            break
        end
    end
    
    if zone and counterButtonIndex then
        local count = #zone.getObjects()
        self.editButton({
            index = counterButtonIndex,
            label = tostring(count)
        })
        self.editButton({
            index = counterButtonIndex + 1,
            label = tostring(count)
        })
    end
end