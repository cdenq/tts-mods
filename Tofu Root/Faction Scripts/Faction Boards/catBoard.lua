----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Cat Board")

----------------------
-- Variables
----------------------
deckZone = "cf89ff"
boardZone = "29b2c0"
keyWordSawmill = "catSawmill"
keyWordRecruiter = "catRecruiter"
woodBagGUID = "dad414"
warriorBagGUID = "ffa850"
warriorMapRotation = {0.00, 180.00, 0.00}
mapGUIDs = {
    autumn = "43180d",
    winter = "e94958",
    lake = "cbb6e5",
    mountain = "2255cd",
    -- gorge = "",
    -- marsh = "",
}
warriorMapPositions = {
    mountain = {
        {18.04, 1.59, -17.01},
        {-0.75, 1.59, -17.11},
        {-15.85, 1.59, -13.66},
        {10.90, 1.59, -9.95},
        {0.96, 1.59, -4.22},
        {-21.50, 1.59, -2.06},
        {22.59, 1.59, 2.40},
        {9.41, 1.59, 7.28},
        {-8.36, 1.59, 2.88},
        {-19.11, 1.59, 11.34},
        {17.58, 1.59, 14.14},
        {-3.66, 1.59, 14.38}
    },
    lake = {
        {17.61, 1.59, -16.08},
        {0.33, 1.59, -18.20},
        {-8.71, 1.59, -13.55},
        {-20.87, 1.59, -8.52},
        {10.98, 1.59, -7.30},
        {-8.38, 1.59, -0.60},
        {-19.29, 1.59, 2.20},
        {9.54, 1.59, 7.89},
        {18.81, 1.59, 13.04},
        {20.11, 1.59, -1.97},
        {2.08, 1.59, 15.65},
        {-18.29, 1.59, 15.15}
    },
    winter = {
        {17.14, 1.59, -17.27},
        {4.57, 1.59, -14.63},
        {-3.23, 1.59, -12.96},
        {-18.21, 1.59, -13.98},
        {-6.49, 1.59, -3.63},
        {-17.75, 1.59, 3.04},
        {6.11, 1.59, 0.00},
        {17.62, 1.59, -5.06},
        {17.27, 1.59, 12.35},
        {9.02, 1.59, 16.15},
        {-5.32, 1.59, 9.44},
        {-14.78, 1.59, 16.25}
    },
    autumn = {
        {20.67, 1.59, -18.69},
        {-1.70, 1.59, -17.24},
        {-17.74, 1.59, -11.62},
        {3.29, 1.59, -9.29},
        {20.70, 1.59, -3.86},
        {-4.20, 1.59, -0.91},
        {10.26, 1.59, 2.43},
        {19.65, 1.59, 14.72},
        {7.66, 1.59, 16.93},
        {-4.11, 1.59, 12.50},
        {-20.29, 1.59, 0.88},
        {-15.84, 1.59, 15.23}
    }
}

----------------------
-- onload function
----------------------
function onLoad()
    createDrawButton()
    createWoodButton()
    createRecruitButton()
    createPlaceButton()
end

----------------------
-- create button functions
----------------------
function createDrawButton()
    self.createButton({
        click_function = "draw",
        function_owner = self,
        label = "DRAW CARD",
        position = { - 1.01, 0.25, 0.93},
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

function createWoodButton()
    self.createButton({
        click_function = "wood",
        function_owner = self,
        label = "PLACE WOOD",
        position = {-0.57, 0.25, -0.23},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 2900,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Places wood at each Sawmill. Use for Birdsong upkeep."
    })
end

function createRecruitButton()
    self.createButton({
        click_function = "recruit",
        function_owner = self,
        label = "RECRUIT",
        position = {-0.7, 0.25, 0.28},
        rotation = {0, 0, 0},
        scale = {0.035, 0.035, 0.035},
        width = 2800,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Places warriors at each Recruiter. Use for your Recruit action."
    })
end

function createPlaceButton()
    self.createButton({
        click_function = "placeAll",
        function_owner = self,
        label = "SETUP WARRIORS",
        position = {0, 0.25, -0.9},
        rotation = {0, 0, 0},
        scale = {0.1, 0.1, 0.1},
        width = 3200,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Places warriors at each clearing. Use during your Setup."
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

function wood(obj, color)
    local boardZoneObj = getObjectFromGUID(boardZone)
    local woodBagObj = getObjectFromGUID(woodBagGUID)
    if not boardZoneObj or not woodBagObj then
        print("Error: Board zone or wood bag not found.")
        return
    end

    local sawmills = {}
    for _, obj in ipairs(boardZoneObj.getObjects()) do
        if obj.tag == "Tile" then
            local notes = obj.getGMNotes() or ""
            if string.find(notes, keyWordSawmill) then
                table.insert(sawmills, obj)
            end
        end
    end

    if #sawmills == 0 then
        broadcastToAll("No sawmills found on the map.", color)
        return
    elseif woodBagObj.getQuantity() == 0 then
        broadcastToAll("No more wood to place.", color)
        return
    elseif woodBagObj.getQuantity() < #sawmills then
        broadcastToAll("Not enough wood to auto-place. You need to add " .. #sawmills .. " wood but only have " .. woodBagObj.getQuantity() .. " left.", color)
        return
    else
        local totalWood = 0
        for _, sawmill in ipairs(sawmills) do
            local sawmillPosition = sawmill.getPosition()
            local sawmillRotation = sawmill.getRotation()
    
            local woodPosition = {
                x = sawmillPosition.x + 1,
                y = sawmillPosition.y + 4,
                z = sawmillPosition.z + 1
            }
    
            woodBagObj.takeObject({
                position = woodPosition,
                rotation = sawmillRotation
            })
            totalWood = totalWood + 1
        end
    
        printToAll(Player[color].steam_name .. " places " .. totalWood .. " wood in Birdsong.", color)
    end
end

function recruit(obj, color)
    local boardZoneObj = getObjectFromGUID(boardZone)
    local warriorBagObj = getObjectFromGUID(warriorBagGUID)
    if not boardZoneObj or not warriorBagObj then
        print("Error: Board zone or wood bag not found.")
        return
    end

    local recruiters = {}
    for _, obj in ipairs(boardZoneObj.getObjects()) do
        if obj.tag == "Tile" then
            local notes = obj.getGMNotes() or ""
            if string.find(notes, keyWordRecruiter) then
                table.insert(recruiters, obj)
            end
        end
    end

    if #recruiters == 0 then
        broadcastToAll("No recruiters found on the map.", color)
        return
    elseif warriorBagObj.getQuantity() == 0 then
        broadcastToAll("No more warriors to place.", color)
        return
    elseif warriorBagObj.getQuantity() < #recruiters then
        broadcastToAll("Not enough warriors to auto-place. You need to add " .. #recruiters .. " warriors but only have " .. warriorBagObj.getQuantity() .. " left.", color)
        return
    else
        local totalWarriors = 0
        for _, recruiter in ipairs(recruiters) do
            local recruiterPosition = recruiter.getPosition()
            local recruiterRotation = recruiter.getRotation()

            local warriorPosition = {
                x = recruiterPosition.x + 1,
                y = recruiterPosition.y + 4,
                z = recruiterPosition.z + 1
            }

            warriorBagObj.takeObject({
                position = warriorPosition,
                rotation = recruiterRotation
            })
            totalWarriors = totalWarriors + 1
        end
        
        printToAll(Player[color].steam_name .. " recruits " .. totalWarriors .. " warriors in Daylight.", color)
    end
end

function placeAll()
    local warriorBag = getObjectFromGUID(warriorBagGUID)
    if not warriorBag then
        print("Error: Warrior bag not found.")
        return
    end

    for mapName, mapGUID in pairs(mapGUIDs) do
        local mapObject = getObjectFromGUID(mapGUID)
        if mapObject then
            local positions = warriorMapPositions[mapName]
            if positions then
                for _, position in ipairs(positions) do
                    if warriorBag.getQuantity() > 0 then
                        local adjustedPosition = {
                            x = position[1],
                            y = position[2] + 2,
                            z = position[3]
                        }
                        warriorBag.takeObject({
                            position = adjustedPosition,
                            rotation = warriorMapRotation
                        })
                    else
                        broadcastToAll("No more warriors to place.")
                        return
                    end
                end
                self.removeButton(3)
            else
                broadcastToAll("No positions found for map: " .. mapName)
            end
            return
        end
    end
    broadcastToAll("No matching map found in the game.")
end