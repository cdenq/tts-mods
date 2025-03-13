----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Lizard Board")

----------------------
-- Variables
----------------------
deckZone = getObjectFromGUID("cf89ff")
outcastMarkerGUID = "d90535"
lostSoulsGUID = "40abac"
danGUID = "0c5853"
handzoneGUIDs = {
    Red = {"3ec4f1", "f001d4"},
    Purple = {"f8e77a", "855e1e"},
    White = {"502194", "82850f"},
    Yellow = {"1accdc", "6ec2ec"},
    Green = {"a02c64", "f4046f"},
    Blue = {"fc815f", "d39fcf"},
}
mySuits = {
    mouse = {
        color = {0.945, 0.573, 0.380},
        markerPosition = {-34.73, 1.89, 3.52}
    },
    bunny = {
        color = {0.941, 0.843, 0.376},
        markerPosition = {-33.37, 1.89, 3.56}
    },
    fox = {
        color = {0.886, 0.318, 0.204},
        markerPosition = {-31.98, 1.89, 3.58}
    }
}
myPositions = {
    {-0.868, 0.25, 0.728},
    {-0.63, 0.25, -0.259}
}

----------------------
-- onload function
----------------------
function onLoad()
    createDrawButton()
    createDiscardButton()
    createLostSoulsButton()
    createHatedButton()
    createOutcastButtons()
    createPlaceButton()
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
-- create button functions
----------------------
function createDrawButton()
    self.createButton({
        click_function = "draw",
        function_owner = self,
        label = "DRAW CARD",
        position = {-1.01, 0.25, 0.93},
        scale = {0.05, 0.05, 0.05},
        width = 2800,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Draw 1 card from the Deck."
    })
end

function createDiscardButton()
    self.createButton({
        click_function = "discardCard",
        function_owner = self,
        label = "DISCARD RANDOM CARD",
        position = {-0.205, 0.25, 0.2},
        scale = {0.04, 0.04, 0.04},
        width = 4400,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Randomly discards one of your cards. Use when removing Gardens."
    })
end

function createLostSoulsButton()
    self.createButton({
        click_function = "updateLostSouls",
        function_owner = self,
        label = "ADJUST",
        position = {-0.6, 0.25, -0.35},
        scale = {0.045, 0.045, 0.045},
        width = 2500,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Adjusts the Outcast Marker and discards cards in the Lost Souls. Use during Birdsong upkeep."
    })
end

function createHatedButton()
    self.createButton({
        click_function = "doNothing",
        function_owner = self,
        label = "NOT HATED",
        position = {-0.2, 0.25, -0.5},
        scale = {0.04, 0.04, 0.04},
        width = 2500,
        height = 600,
        font_size = 400,
        color = {0.5, 0.5, 0.5},
        font_color = {0, 0, 0},
        tooltip = "Tracks whether the current Outcast Suit is hated."
    })
end

function createOutcastButtons()
    for i, pos in ipairs(myPositions) do
        self.createButton({
            click_function = "doNothing",
            function_owner = self,
            label = "NONE",
            position = pos,
            rotation = {0, 0, 0},
            scale = {0.035, 0.035, 0.035},
            width = 1600,
            height = 400,
            font_size = 300,
            color = {1, 1, 1},
            font_color = {0, 0, 0},
            tooltip = "Shows the current Outcast Suit."
        })
    end
end

function createPlaceButton()
    self.createButton({
        click_function = "placeAll",
        function_owner = self,
        label = "SETUP LOST SOULS",
        position = {0, 0.25, -0.9},
        rotation = {0, 0, 0},
        scale = {0.1, 0.1, 0.1},
        width = 3600,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Places the Lost Souls tracker (Lizard Wizard) and Discard Blocking Dan in place. Use during Setup."
    })
end

----------------------
-- on click functions
----------------------
function doNothing()
end

function updateLostSouls()
    local lostSoulsObj = getObjectFromGUID(lostSoulsGUID)
    lostSoulsObj.call("updateOutcastMarker")
    Wait.time(function() checkOutcastStatus() end, 1.5)
end

function draw(obj, color)
    local objInZone = deckZone.getObjects()
    for _, obj in ipairs(objInZone) do
        if obj.tag == "Deck" or obj.tag == "Card" then
            getObjectFromGUID(obj.guid).deal(1, color)
        end
    end
end

function discardCard(obj, color, alt_click)
    local targetPosition = {27.84, 3.65, 25.03}
    local playerHandZones = handzoneGUIDs[color]
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
    printToAll(Player[color].steam_name .. " randomly discards " .. 1 .. " card off of Garden removal.", color)
end

function round(num)
    return math.floor(num + 0.5)
end

function checkOutcastStatus()
    local outcastMarkerObj = getObjectFromGUID(outcastMarkerGUID)
    local rot = outcastMarkerObj.getRotation()
    local goLabel, goColor
    if rot.z > 170 and rot.z < 190 then
        goLabel = "HATED"
        goColor = "Green"
    else
        goLabel = "NOT HATED"
        goColor = {0.5, 0.5, 0.5}
    end
    self.editButton({
        index = 3,
        label = goLabel,
        color = goColor
    })

    local pos = outcastMarkerObj.getPosition()
    for suit, data in pairs(mySuits) do
        if round(pos.x) == round(data.markerPosition[1]) then
            goLabel = suit:upper()
            goColor = data.color
        end
    end
    for i, button in ipairs(myPositions) do
        self.editButton({
            index = 3 + i,
            label = goLabel,
            color = goColor
        })
    end
end

function placeAll()
    local danObj = getObjectFromGUID(danGUID)
    local soulsObj = getObjectFromGUID(lostSoulsGUID)
    local markerObj = getObjectFromGUID(outcastMarkerGUID)
    
    danObj.setLock(false)
    danObj.setPositionSmooth({-34.50, 4.81, -10.04})
    danObj.setRotationSmooth({0, 180, 0})
    soulsObj.setLock(false)
    soulsObj.setPositionSmooth({-34.84, 1.59, 0.70})
    soulsObj.setRotationSmooth({0, 90, 0})
    markerObj.setLock(false)
    markerObj.setPositionSmooth({-36.82, 3, 3.44})
    markerObj.setRotationSmooth({0, 90, 0})

    Wait.time(function()
        soulsObj.setLock(true)
    end, 1.5)

    self.removeButton(6)
end