----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Vagabond 2 Board")
satchelGUIDs = {"b1575f", "68d3c2", "2a1a9a", "b61cc9"} --states of satchel board
-- satchel update requires the board to be in the right orientation

----------------------
-- Variables
----------------------
deckZone = "cf89ff"
factionMarkersBag = "c14af7"
factionDrafterGUID = "65521b"
wait_id = 0
teardrops = {
    cat = "c33191",
    bird = "259983",
    wa = "9e5675",
    vaga = "bb1469",
    vaga2 = "615fc6",
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
    wait_id = Wait.time(updateSatchels, 2, -1)
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createDrawButton()
    createFactionMarkerButton()
    createRefreshButton()
end

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

function createFactionMarkerButton()
    self.createButton({
        click_function = "spawn",
        function_owner = self,
        label = "GET MARKERS",
        position = {0.05, 0.2, -0.3},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 2900,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Adds the Faction Markers for other non-Vagabond Factions at the table. Used during Setup."
    })
end

function createRefreshButton()
    self.createButton({
        click_function = "refreshItems",
        function_owner = self,
        label = "REFRESH",
        position = {-0.975, 0.25, -0.47},
        rotation = {0, 0, 0},
        scale = {0.035, 0.035, 0.035},
        width = 2500,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Refreshes items. Use during Birdsong upkeep."
    })
end

----------------------
-- on click functions
----------------------
function draw(obj, color)
    local objInZone = getObjectFromGUID(deckZone).getObjects()
    for _, obj in ipairs(objInZone) do
        if obj.tag == "Deck" or obj.tag == "Card" then
            getObjectFromGUID(obj.guid).deal(1, color)
        end
    end
end

function getSeatedPlayerCount()
    local factionDrafter = getObjectFromGUID(factionDrafterGUID)
    local count = factionDrafter.call("getCurrentPlayerCount")
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

    if totalTeardrops >= getSeatedPlayerCount() then
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
                else
                    print("Error: Faction marker bag not found.", color)
                end
            end
        end
    else
        broadcastToAll("Please wait until all players have selected their factions.", color)
    end
    
    if markersPlaced then
        self.removeButton(1)
    end
end

----------------------
-- satchel functions
----------------------
function updateSatchels()
    local numSatchels = checkSatchels()
    shiftState(numSatchels + 1)
end

function checkSatchels()
    local zoneSize = {x = 4, y = 1.00, z = 1.25}
    local boardPos = self.getPosition()
    local boardRot = self.getRotation()
    local newPos

    if boardRot.y > 170 and boardRot.y < 190 then
        newPos = {
            x = boardPos.x - 4.82,
            y = boardPos.y + 0.7,
            z = boardPos.z - 7.17
        }
    else
        newPos = {
            x = boardPos.x + 4.82,
            y = boardPos.y + 0.7,
            z = boardPos.z + 7.17
        }
    end

    local hitList = Physics.cast({
        origin = newPos,
        direction = {0, 1, 0},
        type = 3,
        size = zoneSize,
        max_distance = 1
        --debug = true
    })

    local totalItems = 0
    for _, hit in ipairs(hitList) do
        local obj = hit.hit_object
        if obj.getName() == "Bag" then
            totalItems = totalItems + 1
        end
    end
    return totalItems
end

function shiftState(num)
    for i, guid in ipairs(satchelGUIDs) do
        local satchelObj = getObjectFromGUID(guid)
        if satchelObj then
            if satchelObj.getStateId() ~= num then
                satchelObj.setState(num)
            end
            break
        end
    end
end

function onDestroy()
    Wait.stop(wait_id)
end

----------------------
-- refresh tea functions
----------------------
function refreshItems()
    local mod = 1
    if self.getRotation().y > 170 and self.getRotation().y < 190 then
        mod = -1
    end

    local teaCheckRelative = {x = 4.7, y = 0.59, z = -3.49}
    local selfPos = self.getPosition()
    local teaCheckPos = {
        x = selfPos.x + teaCheckRelative.x * mod,
        y = selfPos.y + teaCheckRelative.y,
        z = selfPos.z + teaCheckRelative.z * mod
    }
    
    local hitList = Physics.cast({
        origin = teaCheckPos,
        direction = {0, 1, 0},
        type = 3,
        size = {3.70, 1.00, 1.20},
        max_distance = 2
        --debug = true
    })

    local totalRefresh = 3
    for _, hit in ipairs(hitList) do
        local obj = hit.hit_object
        if obj.hasTag("Root Tea") then
            totalRefresh = totalRefresh + 2
        end
    end
    
    local currSatchelBoardObj
    for i, guid in ipairs(satchelGUIDs) do
        currSatchelBoardObj = getObjectFromGUID(guid)
        if currSatchelBoardObj then
            break
        end
    end

    local itemCheckRelative = {x = 2.79, y = 0.58, z = -0.01}
    local satchelPos = currSatchelBoardObj.getPosition()
    local itemCheckPos = {
        x = satchelPos.x + itemCheckRelative.x * mod,
        y = satchelPos.y + itemCheckRelative.y,
        z = satchelPos.z + itemCheckRelative.z * mod
    }
    
    local hitList = Physics.cast({
        origin = itemCheckPos,
        direction = {0, 1, 0},
        type = 3,
        size = {6.44, 1.00, 7.93},
        max_distance = 2
        --debug = true
    })
    
    local itemsToRefresh = {}
    for _, hit in ipairs(hitList) do
        local obj = hit.hit_object
        if obj.hasTag("Root Item") and obj.getRotation().z < 190 and obj.getRotation().z > 170 then
            table.insert(itemsToRefresh, obj)
        end
    end
    
    if totalRefresh < #itemsToRefresh then
        broadcastToAll("Not enough tea to auto-refresh. You have " .. totalRefresh .. " refreshes but have " .. #itemsToRefresh .. " items to refresh. Refresh manually.")
    else
        for i, obj in ipairs(itemsToRefresh) do
            local tempPos = obj.getPosition()
            local tempRot = self.getRotation()
            obj.setPositionSmooth({
                x = tempPos.x, 
                y = tempPos.y + 1, 
                z = tempPos.z
            })
            obj.setRotationSmooth({
                x = tempRot.x,
                y = tempRot.y,
                z = 0
            })
        end
    end
end