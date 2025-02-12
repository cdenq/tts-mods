----------------------
-- Edited for Tofu Worldview
-- Original by Root mod
-- Changes by cdenq
----------------------
self.setName("Tofu Badger Board")

----------------------
-- Variables
----------------------
deckZone = getObjectFromGUID("cf89ff")
relicBagGUID = "51dcca"
relicMapRotation = {0, 0, 0}
badgerBoardGUID = "f72cd4"
mapGUIDs = {
    mountain = "2255cd",
    lake = "cbb6e5",
    winter = "e94958",
    autumn = "43180d",
    summer = "43180d"
}
relicGridParameters = {
    relicGridSpacing = 1.5,
    relicGridWidth = 2
}
relicMapPositions = {
    mountain = {
        {15.05, 2.08, 5.52},
        {17.70, 2.08, -6.11},
        {6.84, 2.08, -1.14},
        {-4.31, 2.08, 11.42},
        {0.36, 2.08, 3.18},
        {3.41, 2.08, -8.87},
        {-4.23, 2.08, -5.83},
        {-8.79, 2.08, -10.04},
        {-14.02, 2.08, -2.63},
        {-15.64, 2.08, 6.35}
    },
    lake = {
        {9.84, 2.08, -13.41},
        {17.51, 2.08, -7.46},
        {0.85, 2.08, -7.90},
        {-4.15, 2.08, -9.36},
        {-15.89, 2.08, -5.90},
        {-13.85, 2.08, 7.49},
        {-2.71, 2.08, 12.21},
        {10.61, 2.08, 14.55},
        {15.84, 2.08, 4.15}
    },
    winter = {
        {14.29, 2.08, -5.85},
        {14.69, 2.08, 4.03},
        {0.66, 2.08, -6.74},
        {9.59, 2.08, 10.10},
        {0.48, 2.08, 5.38},
        {-15.30, 2.08, -1.91},
        {-15.18, 2.08, 7.48},
        {-8.98, 2.08, 9.30}
    },
    autumn = {
        {16.50, 2.08, 4.23},
        {12.03, 2.08, -7.57},
        {8.32, 2.08, 11.21},
        {-4.04, 2.08, 7.36},
        {-14.43, 2.08, 5.13},
        {-7.16, 2.08, -4.47},
        {0.86, 2.08, -14.02}
    },
    summer = {
        {16.50, 2.08, 4.23},
        {12.03, 2.08, -7.57},
        {8.32, 2.08, 11.21},
        {-4.04, 2.08, 7.36},
        {-14.43, 2.08, 5.13},
        {-7.16, 2.08, -4.47},
        {0.86, 2.08, -14.02}
    }
}

----------------------
-- onload function
----------------------
function onLoad(save_state)
    createDrawButton()
    createRelicButton()
end

----------------------
--  helper functions
----------------------
function getGridPosition(index)
    local badgerBoardObject = getObjectFromGUID(badgerBoardGUID)
    local badgerBoardObjectPosition = badgerBoardObject.getPosition()

    local row = math.floor((index - 1) / relicGridParameters.relicGridWidth)
    local col = (index - 1) % relicGridParameters.relicGridWidth
    print(badgerBoardObject.getRotation())
    if badgerBoardObject.getRotation().y == 0 then
        x = badgerBoardObjectPosition.x - 9 + col * relicGridParameters.relicGridSpacing
        y = badgerBoardObjectPosition.y + 1
        z = badgerBoardObjectPosition.z - 1.5 + row * relicGridParameters.relicGridSpacing
    else
        x = badgerBoardObjectPosition.x + 9 - col * relicGridParameters.relicGridSpacing
        y = badgerBoardObjectPosition.y + 1
        z = badgerBoardObjectPosition.z + 1.5 - row * relicGridParameters.relicGridSpacing
    end
    return {x, y, z}
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

function createRelicButton()
    self.createButton({
        click_function = "placeRelic",
        function_owner = self,
        label = "PLACE RELICS",
        position = {0.95, 0.25, -0.225},
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

function placeRelic()
    local relicBag = getObjectFromGUID(relicBagGUID)
    if not relicBag then
        print("Error: Relic bag not found.")
        return
    end

    relicBag.shuffle()
    local placedOnMap = false
    for mapName, mapGUID in pairs(mapGUIDs) do
        local mapObject = getObjectFromGUID(mapGUID)
        if mapObject then
            local positions = relicMapPositions[mapName]
            if positions then
                for _, position in ipairs(positions) do
                    if relicBag.getQuantity() > 0 then
                        local adjustedPosition = {
                            x = position[1],
                            y = position[2] + 2,
                            z = position[3]
                        }
                        relicBag.takeObject({
                            position = adjustedPosition,
                            rotation = relicMapRotation
                        })
                    else
                        print("No more relics to place on the map.")
                        break
                    end
                end
                placedOnMap = true
                break
            else
                print("No positions found for map: " .. mapName)
            end
        end
    end

    if not placedOnMap then
        print("No matching map found in the game.")
        return
    end

    print("Remember to place the remaining " .. relicBag.getQuantity() .. " relics in the forest!")
    local objects = relicBag.getObjects()
    for i, objectData in ipairs(objects) do
        local gridPosition = getGridPosition(i)
        if gridPosition then
            relicBag.takeObject({
                guid = objectData.guid,
                position = gridPosition
            })
        end
    end
    self.removeButton(1)
end
