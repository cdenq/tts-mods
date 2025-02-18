----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Deck Board")

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

----------------------
-- onload
----------------------
function onload()
    Wait.stopAll()
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

----------------------
-- functions
----------------------
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