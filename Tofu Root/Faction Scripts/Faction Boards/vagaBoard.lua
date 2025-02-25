----------------------
-- Edited for Tofu Worldview
-- Original by Root mod
-- Changes by cdenq
----------------------
self.setName("Tofu Vagabond Board")

----------------------
-- Variables
----------------------
deckZone = getObjectFromGUID("cf89ff")
factionMarkersBag = "c14af7"
teardrops = {
    cat = "c33191",
    bird = "259983",
    wa = "9e5675",
    --vaga = "bb1469",
    --vaga2 = "615fc6",
    lizard = "d6f37d",
    otter = "572d09",
    mole = "c6b48f",
    crow = "b3a6dc",
    rat = "1093bf",
    badger = "f1bd2f"
}
factionMarkers = {
    cat = {"a13aa3", "07d1f7"},
    bird = {"af4714", "0599e8"},
    wa = {"4c2e2c", "45146e"},
    lizard = {"999b06", "e6f119"},
    otter = {"a6bab1", "ea0513"},
    mole = {"7bd30f", "17a078"},
    crow = {"fd4564", "f20eb8"},
    rat = {"2af982", "76b4e5"},
    badger = {"e863be", "01e890"}
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
    createFactionMarkerButton()
end

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

function createFactionMarkerButton()
    self.createButton({
        click_function = "spawn",
        function_owner = self,
        label = "MARKERS",
        position = {0.05, 0.2, -0.3},
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
function draw(obj, color)
    local objInZone = deckZone.getObjects()
    for _, obj in ipairs(objInZone) do
        if obj.tag == "Deck" or obj.tag == "Card" then
            getObjectFromGUID(obj.guid).deal(1, color)
        end
    end
end

function getSeatedPlayerCount()
    local count = 0
    for _, player in ipairs(Player.getPlayers()) do
        if player.seated then
            count = count + 1
        end
    end
    return count
end

function spawn(obj, color)
    local scriptPos = self.getPosition()
    local scriptRot = self.getRotation()
    local markerBasePos = {
        x = scriptPos.x,
        y = scriptPos.y,
        z = scriptPos.z
    }
    local markerGridSize = 3
    local markerSpacing = 1.25
    local markerCount = 0
    local markersPlaced = false
    local totalTeardrops = 0

    for _, teardropGUID in pairs(teardrops) do
        local teardropObj = getObjectFromGUID(teardropGUID)
        if teardropObj then
            totalTeardrops = totalTeardrops + 1
        end
    end

    if #totalTeardrops == getSeatedPlayerCount() then
        for teardropLabel, teardropGUID in pairs(teardrops) do
            local teardropObj = getObjectFromGUID(teardropGUID)
            if teardropObj then
                local factionMarkerBag = getObjectFromGUID(factionMarkersBag)
                if factionMarkerBag then
                    local factionMarkers = factionMarkers[teardropLabel]
                    local markerPlaced = false
                    if factionMarkers then
                        for _, markerGUID in ipairs(factionMarkers) do
                            for _, bagItem in ipairs(factionMarkerBag.getObjects()) do
                                if bagItem.guid == markerGUID then
                                    local row = math.floor(markerCount / markerGridSize)
                                    local col = markerCount % markerGridSize
                                    local markerPos = {
                                        x = markerBasePos.x + col * markerSpacing,
                                        y = markerBasePos.y + 2,
                                        z = markerBasePos.z + row * markerSpacing
                                    }
                                    factionMarkerBag.takeObject({
                                        guid = markerGUID,
                                        position = markerPos,
                                        rotation = scriptRot
                                    })
                                    markerPlaced = true
                                    markerCount = markerCount + 1
                                    markersPlaced = true
                                    break
                                end
                            end
                            if markerPlaced then break end
                        end
                    end
                    if not markerPlaced then
                        broadcastToAll("No faction marker for " .. teardropLabel, color)
                    end
                else
                    print("Error: Faction marker bag not found.", color)
                end
            end
        end
    else
        printToAll("Please wait until all players have selected their factions.")
    end
    
    if markersPlaced then
        self.removeButton(1)
    end
end