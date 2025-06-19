----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Rat Board")

----------------------
-- Variables
----------------------
deckZone = "cf89ff"
boardZone = "29b2c0"
warlordGUID = {"529f5a", "42a8dc"}
ratFactionBoardGUID = "53059f"
warriorBagGUID = "24fc4b"
warriorMapRotation = {0.00, 180.00, 0.00}

----------------------
-- onload functions
----------------------
function onLoad()
    createAllButtons()
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createDrawButton()
    createRecruitButton()
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

function createRecruitButton()
    self.createButton({
        click_function = "recruit",
        function_owner = self,
        label = "RECRUIT",
        position = {-0.6, 0.25, -0.15},
        rotation = {0, 0, 0},
        scale = {0.04, 0.05, 0.035},
        width = 2900,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Recruits warriors to Warlord and then to each Stronghold. Use during Birdsong upkeep."
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

function isWarlord(guid)
    for _, warlordGuid in ipairs(warlordGUID) do
        if guid == warlordGuid then
            return true
        end
    end
    return false
end

function checkProwess()
    local ratFactionBoard = getObjectFromGUID(ratFactionBoardGUID)
    local ratFactionBoardPosition = ratFactionBoard.getPosition()
    local zoneSize = {x = 18, y = 5, z = 15}

    local hitList = Physics.cast({
        origin = ratFactionBoardPosition,
        direction = {0, 1, 0},
        type = 3,
        size = zoneSize,
        max_distance = 2
        --debug = true
    })
    
    local totalItems = 0
    for _, hit in ipairs(hitList) do
        local obj = hit.hit_object
        if obj.type == "Tile" then
            local tagList = obj.getTags()
            if checkHasTag("Prowess", tagList) then
                totalItems = totalItems + 1
            end
        end
    end
    return totalItems
end

function recruit(obj, color)
    local boardZoneObj = getObjectFromGUID(boardZone)
    local warriorBagObj = getObjectFromGUID(warriorBagGUID)

    local spawners = {}
    local warlordFound = false
    local activeWarlord = nil
    
    for _, obj in ipairs(boardZoneObj.getObjects()) do
        if obj.type == "Tile" then
            if obj.getName() == "Stronghold" then
                table.insert(spawners, obj)
            end
        elseif isWarlord(obj.getGUID()) then
            warlordFound = true
            activeWarlord = obj
        else
            doNothing()
        end
    end

    local totalWarriors = 0

    if warlordFound and activeWarlord then
        local totalItems = checkProwess()
        local warlordPosition = activeWarlord.getPosition()
        local warlordRotation = activeWarlord.getRotation()
        
        local finalCount = 0
        if totalItems >= 3 then
            finalCount = totalItems - 1
        else
            finalCount = totalItems
        end

        if warriorBagObj.getQuantity() == 0 then
            broadcastToAll("No more warriors to place onto Warlord.", color)
            return
        elseif warriorBagObj.getQuantity() < finalCount then
            broadcastToAll("Not enough warriors to auto-place. You need to add " .. finalCount .. " warriors but only have " .. warriorBagObj.getQuantity() .. " left.", color)
            return
        else
            for i = 1, finalCount do
                warriorBagObj.takeObject({
                    position = {
                        x = warlordPosition.x + i,
                        y = warlordPosition.y,
                        z = warlordPosition.z + i
                    },
                    rotation = warlordRotation
                })
                totalWarriors = totalWarriors + 1
            end
        end
    else 
        broadcastToAll("No warlord anointed.", color)
    end

    if #spawners == 0 then
        broadcastToAll("No strongholds built.", color)
        return
    elseif warriorBagObj.getQuantity() == 0 then
        broadcastToAll("No more warriors to place onto strongholds.", color)
        return
    elseif warriorBagObj.getQuantity() < #spawners then
        broadcastToAll("Not enough warriors to auto-place. You need to add " .. #spawners .. " warriors but only have " .. warriorBagObj.getQuantity() .. " left.", color)
        return
    else
        for _, recruiter in ipairs(spawners) do
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

function doNothing()
end

function checkHasTag(targetTag, tagList)
    for _, tag in ipairs(tagList) do
        if tag == targetTag then
            return true
        end
    end
    return false
end