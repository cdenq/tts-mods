----------------------
-- Edited for Tofu Worldview
-- Original by Root mod
-- Changes by cdenq
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

----------------------
-- onload function
----------------------
function onLoad(save_state)
    createDrawButton()
    createPlaceButton()
    createRecruitButton()
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

function createPlaceButton()
    self.createButton({
        click_function = "place",
        function_owner = self,
        label = "PLACE",
        position = {0, 0.2, -0.315},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 2100,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
    })
end

function createRecruitButton()
    self.createButton({
        click_function = "recruit",
        function_owner = self,
        label = "RECRUIT",
        position = {-0.47, 0.2, -0.14},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 2500,
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
        broadcastToAll("No more warriors to place.")
        return
    elseif warriorBag.getQuantity() < numToPlace then
        broadcastToAll("Not enough warriors to auto-place. You need to add " .. numToPlace .. " warriors but only have " .. warriorBag.getQuantity() .. " left.")
        return
    else
        placeWarrior(numToPlace)
        broadcastToAll(playerName .. " recruits " .. numToPlace .. " warriors in Birdsong.", color)
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
        broadcastToAll(playerName .. " Assembly recruits " .. 1 .. " warriors in Daylight.", color)
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
                    y = recruiterPosition.y + 4,
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