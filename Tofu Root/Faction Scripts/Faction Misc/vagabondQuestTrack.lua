----------------------
-- Tofu Tumble
-- By tofuwater
-- Original by Nevakanezah
----------------------
self.setName("Tofu Quest Tracker")

----------------------
-- variables
----------------------
wait_id = 0
variableData = {
    mouse = {
        count = 0,
        buttonPosition = {-0.2185, 0.15, 0.69}
    },
    bunny = {
        count = 0,
        buttonPosition = {-0.2185, 0.15, 0.105}
    },
    fox = {
        count = 0,
        buttonPosition = {-0.2185, 0.15, -0.475}
    }
}
myIterations = {"mouse", "bunny", "fox"}

----------------------
-- onload function
----------------------
function onLoad()
    createAllButtons()
    wait_id = Wait.time(updateCardCount, 1, -1)
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createSuitCountButtons()
end

function createSuitCountButtons()
    for i, suit in ipairs(myIterations) do
        self.createButton({
            click_function = "doNothing",
            function_owner = self,
            label = variableData[suit].count,
            position = variableData[suit].buttonPosition,
            scale = {0.45, 0, 0.45},
            width = 0,
            height = 0,
            font_color = {1, 1, 1},
            font_size = 120
        })
    end
end

----------------------
-- helper functions
----------------------
function doNothing()
end

----------------------
-- update card functions
----------------------
function updateCardCount()
    resetCount()
    checkCards()
    updateButtons()
end

function checkCards()
    local items = getCards()
    for _, item in ipairs(items) do
        if item.hit_object.tag == "Card" then
            parseCard(item.hit_object.getDescription(), item.hit_object.getName())
        elseif item.hit_object.tag == "Deck" then
            for _, card in ipairs(item.hit_object.getObjects()) do
                parseCard(card.description)
            end
        end
    end
end

function resetCount()
    for i, suit in ipairs(myIterations) do
        variableData[suit].count = 0
    end
end

function getCards()
    local result = Physics.cast({
        origin = self.getPosition(),
        direction = {0, 1, 0},
        type = 3,
        size = {6.8, 0.1, 25},
        max_distance = 1
        --debug = true
    })
    return result or {}
end

function parseCard(foundSuit)
    for i, suit in ipairs(myIterations) do
        if string.find(foundSuit:lower(), suit) then
            variableData[suit].count = variableData[suit].count + 1
        end
    end
end

function updateButtons()
    for i = 0, 2 do
        self.editButton({
            index = i, 
            label = tostring(variableData[myIterations[i + 1]].count + 1)}
        )
    end 
end

function onDestroy()
    Wait.stop(wait_id)
end