----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Badger Tableau")

----------------------
-- variables
----------------------
local wait_id = 0
cardCount = 0
myColors = {
    red = {1, 0, 0},
    green = {0, 1, 0},
    black = {0, 0, 0}
}

----------------------
-- onload function
----------------------
function onLoad()
    createDisplay()
    wait_id = Wait.time(updateCardCount, 1, -1)
end

----------------------
-- create buttons
----------------------
function createDisplay()
    self.createButton({
        click_function = "doNothing",
        function_owner = self,
        label = "0",
        position = {0, 0.25, -0.925},
        scale = {0.5, 0.5, 0.5},
        width = 0,
        height = 0,
        font_size = 120,
        font_color = myColors.black
    })
end

----------------------
-- helper functions
----------------------
function doNothing()
end

function onDestroy()
    Wait.stop(wait_id)
end

----------------------
-- main functions
----------------------
function getCards()
    local result = Physics.cast({
        origin       = self.positionToWorld({0, 0, 0}),
        direction    = {0, 1, 0},
        type         = 3,
        size         = {22, 0.1, 13},
        max_distance = 1
        --debug = true
    })
    return result or {}
end

function updateCardCount()
    local count = 0
    local items = getCards()
    
    if items then
        for _, item in ipairs(items) do
            if item.hit_object.tag == "Card" then
                count = count + 1
            elseif item.hit_object.tag == "Deck" then
                count = count + #item.hit_object.getObjects()
            end
        end
    end
    
    if count ~= cardCount then
        local myColor
        if count > 10 then
            myColor = myColors.red
        elseif count == 10 then 
            myColor = myColors.green 
        else 
            myColor = myColors.black
        end

        cardCount = count
        self.editButton({
            index = 0,
            label = tostring(cardCount),
            font_color = myColor
        })
    end
end