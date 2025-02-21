----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Legendary Forge")

----------------------
-- script variables
----------------------
itemLocations = {
    {36.71, 2, -1.86},
    {35.10, 2, -1.90},
    {35.09, 2, -3.49},
    {36.70, 2, -3.49}
}
mySupplyGUIDSetup = {
    bag1 = "233b57",
    bag2 = "8cff64",
    boot1 = "473549",
    boot2 = "d50954",
    cross = "a13ed6",
    hammer = "27b19b",
    sword1 = "e0e2a9",
    sword2 = "269d59",
    tea1 = "ce1584",
    tea2 = "4fc243",
    coin1 = "00763e",
    coin2 = "76a02d"
}
myButtons = {
    startPos = {-0.595, -0.5, 0},
    rotation = {0, 0, 180},
    xIncrement = 0.595,
    height = 1000,
    width = 1000,
    scale = {0.1, 0.1, 0.1},
    font_size = 300,
    fox = {
        tooltip = "Setup fox crafting items."
    },
    mouse = {
        tooltip = "Setup mouse crafting items."
    },
    bunny = {
        tooltip = "Setup bunny crafting items."
    }
}
myIterations = {"bunny", "mouse", "fox"}

----------------------
-- onload
----------------------
function onload()
    createAllButtons()
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createSetup()
end

function createSetup()
    for i, suit in ipairs(myIterations) do
        local pos = {
            myButtons.startPos[1] + (i-1) * myButtons.xIncrement,
            myButtons.startPos[2],
            myButtons.startPos[3]
        }
        
        self.createButton({
            click_function = suit,
            function_owner = self,
            position = pos,
            rotation = myButtons.rotation,
            width = myButtons.width,
            height = myButtons.height,
            scale = myButtons.scale,
            label = "SETUP",
            font_color = "White",
            font_size = myButtons.font_size,
            color = {1, 0, 0, 0.8},
            tooltip = myButtons[suit].tooltip
        })
    end
end

----------------------
-- functions
----------------------
function fox()
    local items = {
        getObjectFromGUID(mySupplyGUIDSetup.sword1),
        getObjectFromGUID(mySupplyGUIDSetup.sword2),
        getObjectFromGUID(mySupplyGUIDSetup.cross),
        getObjectFromGUID(mySupplyGUIDSetup.hammer)
    }
    
    for i, item in ipairs(items) do
        if item then
            item.setPosition(itemLocations[i])
            item.setRotation({0, 270, 0})
        end
    end

    deleteButtons()
end

function mouse()
    local items = {
        getObjectFromGUID(mySupplyGUIDSetup.bag1),
        getObjectFromGUID(mySupplyGUIDSetup.bag2),
        getObjectFromGUID(mySupplyGUIDSetup.tea1),
        getObjectFromGUID(mySupplyGUIDSetup.tea2)
    }
    
    for i, item in ipairs(items) do
        if item then
            item.setPosition(itemLocations[i])
            item.setRotation({0, 270, 0})
        end
    end

    deleteButtons()
end

function bunny()
    local items = {
        getObjectFromGUID(mySupplyGUIDSetup.boot1),
        getObjectFromGUID(mySupplyGUIDSetup.boot2),
        getObjectFromGUID(mySupplyGUIDSetup.coin1),
        getObjectFromGUID(mySupplyGUIDSetup.coin2)
    }
    
    for i, item in ipairs(items) do
        if item then
            item.setPosition(itemLocations[i])
            item.setRotation({0, 270, 0})
        end
    end

    deleteButtons()
end

function deleteButtons()
    for i = 0, 2 do
        self.removeButton(i)
    end
end