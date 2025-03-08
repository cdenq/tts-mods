----------------------
-- Made for Tofu Worldview
-- By cdenq
----------------------

----------------------
-- Variables
----------------------
partisanType = "Fox"
handzoneGUIDS = {
    Red = {"3ec4f1", "f001d4"},
    Purple = {"f8e77a", "855e1e"},
    White = {"502194", "82850f"},
    Yellow = {"1accdc", "6ec2ec"},
    Green = {"a02c64", "f4046f"},
    Blue = {"fc815f", "d39fcf"},
}

----------------------
-- onload function
----------------------
function onLoad()
    createDiscardButton()
end

----------------------
-- create button functions
----------------------
function createDiscardButton()
    self.createButton({
        click_function = "discardCards",
        function_owner = self,
        label = "DISCARD",
        position = {0, 0.25, -1.25},
        rotation = {0, 0, 0},
        scale = {0.5, 0.5, 0.5},
        width = 600,
        height = 200,
        font_size = 150,
        color = "Black",
        font_color = "White",
    })
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
-- on click functions
----------------------
function discardCards(obj, color, alt_click)
    local playerHandZones = handzoneGUIDS[color]
    local cardsToDiscard = {}
    
    for _, zoneGUID in ipairs(playerHandZones) do
        local zone = getObjectFromGUID(zoneGUID)
        if zone then
            local cardsInZone = zone.getObjects()
            
            for _, card in ipairs(cardsInZone) do
                local notes = card.getDescription()
                if notes == "Bird" or notes ~= titleCase(partisanType) then
                    table.insert(cardsToDiscard, card)
                end
            end
        end
    end
    
    local discardCount = #cardsToDiscard
    
    if discardCount > 0 then
        local targetPosition = {27.84, 3.65, 25.03}
        for i = 1, #cardsToDiscard do
            cardsToDiscard[i].setPosition(targetPosition)
        end   
        broadcastToAll(Player[color].steam_name .. " discards " .. discardCount .. " card(s) off of " .. partisanType .. " Partisans.", color)
    end
end