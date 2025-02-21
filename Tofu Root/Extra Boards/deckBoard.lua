----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Deck Board")
-- TTS bug for getstates, will return 1 less in count if 3 or more states.

----------------------
-- script variables
----------------------
deckZone = "cf89ff"
discardZone = "df7de8"
dominancePositions = {
    mouse = {-45.20, 1.60, -2.84},
    bunny = {-45.19, 1.60, -9.80},
    fox = {-45.22, 1.60, -16.79},
    bird = {-45.23, 1.60, 4.17},
    count = 0
}
myIterations = {"mouse", "bunny", "fox", "bird"}
wait_id = 7348
myMaps = {
    autumn = {"43180d", "8d1572", "7f8900"},
    winter = {"e94958"},
    lake = {"cbb6e5", "64338c"},
    mountain = {"2255cd"}
    -- gorge = "",
    -- marsh = "",
}
debug = false

----------------------
-- onload
----------------------
function onload()
    createAllButtons()
    wait_id = Wait.time(moveDominance, 1, -1)
end

function onDestroy()
    Wait.stop(wait_id)
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createReshuffle()
    createMapVariant()
end

function createReshuffle()
    self.createButton({
        click_function = "reshuffle",
        function_owner = self,
        position = {-1.3, 0.25, 0.1},
        rotation = {0, 0, 0},
        scale = {0.75, 0.75, 0.75},
        color = {0, 0, 0, 0},
        width = 350,
        height = 75,
        tooltip = "Reshuffle the discard into the deck."
    })
end

function createMapVariant()
    self.createButton({
        click_function = "turnOnOff",
        function_owner = self,
        position = {-2.1, 0.2, 0},
        rotation = {0, 270, 0},
        scale = {0.75, 0.75, 0.75},
        width = 400,
        height = 75,
        font_size = 50,
        label = "Decorate Map",
        tooltip = "RMB: Reskin the map, if available.\nLMB: Delete this button."
    })
end

----------------------
-- functions
----------------------
function doNothing()
end

function unlockMap(mapObj)
    mapObj.setLock(false)
    mapObj.interactable = true
end

function lockMap(mapObj)
    mapObj.setLock(true)
    mapObj.interactable = false
end

function reshuffle()
    local discardZoneObj = getObjectFromGUID(discardZone)
    local discardObjects = discardZoneObj.getObjects()
    local deckZoneObj = getObjectFromGUID(deckZone)
    local pos = deckZoneObj.getPosition()

    for _, obj in ipairs(discardObjects) do
        if obj.type == "Deck" then
            obj.shuffle()
            obj.setPositionSmooth(pos)
            obj.setRotationSmooth({0, 90, 180})
        end
    end
end

function turnOnOff(obj, color, alt_click)
    if alt_click then
        self.removeButton(1) -- removes shift states button 
    else
        shiftStates()
    end
end

function shiftStates()
    mapObj = seekMap()
    if mapObj then
        if debug then print(guid) end
        local states = mapObj.getStates()
        if states then --if more than 1 state
            unlockMap(mapObj)
            local actualNumStates = #mapObj.getStates() + 1
            local currentState = mapObj.getStateId()
            local nextState = currentState + 1
            if debug then
                print("currState: " .. currentState .. "/" .. actualNumStates)
                print("nextState: " .. nextState)
                print("resetLimit: " .. actualNumStates + 1)
            end

            if nextState == actualNumStates + 1 then
                if debug then
                    print("hit limit!")
                    print("new nextState: " .. nextState)
                end
                nextState = 1
            end
            mapObj.setState(nextState)
            newMapObj = seekMap()
            lockMap(newMapObj)
        else
            printToAll("No variants for this map.")
        end
    else
        printToAll("Valid map not found.")
    end
end

function seekMap()
    for mapKey, mapList in pairs(myMaps) do 
        for _, guid in ipairs(mapList) do
            local mapObj = getObjectFromGUID(guid)
            if mapObj then
                return mapObj
            end
        end
    end
end

----------------------
-- dominance function
----------------------
function moveDominance()
    local discardZoneObj = getObjectFromGUID(discardZone)
    if not discardZoneObj then return end
    
    local discardObjects = discardZoneObj.getObjects()
    
    for _, obj in ipairs(discardObjects) do
        if obj and obj.type == "Card" and string.find(obj.getName():lower(), "dominance") then
            for _, suit in ipairs(myIterations) do
                if string.find(obj.getDescription():lower(), suit) then
                    if dominancePositions[suit] then
                        obj.setPositionSmooth(dominancePositions[suit])
                        obj.setRotationSmooth({0, 90, 0})
                    end
                end
            end
        elseif obj and obj.type == "Deck" then
            local cards = obj.getObjects()
            for i = #cards, 1, -1 do
                local card = cards[i]
                if string.find(card.nickname:lower(), "dominance") then
                    for _, suit in ipairs(myIterations) do
                        if string.find(card.description:lower(), suit) then
                            if dominancePositions[suit] then
                                Wait.time(function()
                                    if obj then
                                        obj.takeObject({
                                            position = dominancePositions[suit],
                                            rotation = {0, 90, 0},
                                            smooth = true,
                                            index = i-1
                                        })
                                    end
                                end, 0.1)
                            end
                        end
                    end
                end
            end
        end
    end
end