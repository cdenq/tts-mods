----------------------
-- Edited for Tofu Worldview
-- Original by Root mod
-- Changes by cdenq and Claude
----------------------
self.setName("Tofu WA Board")


----------------------
-- Variables
----------------------
deckZone = getObjectFromGUID("cf89ff")
handZoneParameters = {
    zoneWidth = 15,
    zoneHeight = 5,
    zoneThickness = 7,
    zoneYOffset = 5,
    zoneScale = {x = 1, y = 1, z = 1}
}

----------------------
-- onload function
----------------------
function onLoad(save_state)
    createDrawButton()
    createHandZoneSpawnButton()
end

----------------------
-- create button functions
----------------------
function createDrawButton()
    self.createButton({
        click_function = "draw",
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

----------------------
-- on click functions
----------------------
function draw(obj, color, amount, targetZone)
    amount = amount or 1
    local objInZone = deckZone.getObjects()
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
    self.removeButton(1)
    Wait.frames(function() draw(obj, color, 3, newZone) end, 10)
end

function createHandZone(playerColor)
    local playerHandPos = Player[playerColor].getHandTransform()
    local zonePos = {}
    local zoneRot = playerHandPos.rotation

    if zoneRot.y == 180 then
        zonePos = {
            x = playerHandPos.position.x + 13,
            y = playerHandPos.position.y - 3,
            z = playerHandPos.position.z - 15.6
        }
    else
        zonePos = {
            x = playerHandPos.position.x - 13,
            y = playerHandPos.position.y - 3,
            z = playerHandPos.position.z + 15.6
        }
    end

    local newZone = spawnObject({
        type = "HandTrigger",
        position = zonePos,
        rotation = zoneRot,
        scale = handZoneParameters.zoneScale
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