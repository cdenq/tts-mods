----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------

----------------------
-- pre-helper variables
----------------------
function normalizeRGB(rgb)
    return {rgb[1]/255, rgb[2]/255, rgb[3]/255}
end

----------------------
-- script variables
----------------------
playerboard = {
    obverse = "Riverfolk Flotilla",
    reverse = "Otter Divers",
    color = normalizeRGB({93,186,172})
}
buttonValues = {main = 2}
rollValues = {"2/4", "1/2", "2/3", "2/3", "1/2", "1/2"}

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
    createObverseButtons()
    createReverseButtons()
end

function createObverseButtons()
    createControlMarkerButton()
    createRollButton()
end

function createControlMarkerButton()
    self.createButton({
        click_function = "edit",
        function_owner = self,
        position = {0.95, 0.25, 1.15},
        height = 400,
        width = 225,
        scale = {0.5, 0.5, 0.75},
        color = {1, 1, 1},
        font_color = {0, 0, 0},
        font_size = 200,
        label = buttonValues.main,
        tooltip = "Left/right click to in/decrement control."
    })
end

function createRollButton()
    self.createButton({
        click_function = "roll",
        function_owner = self,
        position = {0.95, 0.25, -1.25},
        height = 250,
        width = 250,
        scale = {0.5, 0.5, 0.85},
        color = {1, 1, 1},
        font_color = {0, 0, 0},
        font_size = 100,
        label = "Roll",
        tooltip = "Randomly roll for control duration."
    })
end

function createReverseButtons()
    createControlMarkerButtonR()
    createRollButtonR()
end

function createControlMarkerButtonR()
    self.createButton({
        click_function = "edit",
        function_owner = self,
        position = {-0.95, -0.25, 1.15},
        rotation = {0, 0, 180},
        height = 400,
        width = 225,
        scale = {0.5, 0.5, 0.75},
        color = {1, 1, 1},
        font_color = {0, 0, 0},
        font_size = 200,
        label = buttonValues.main,
        tooltip = "Left/right click to in/decrement control."
    })
end

function createRollButtonR()
    self.createButton({
        click_function = "roll",
        function_owner = self,
        position = {-0.95, -0.25, -1.25},
        rotation = {0, 0, 180},
        height = 250,
        width = 250,
        scale = {0.5, 0.5, 0.85},
        color = {1, 1, 1},
        font_color = {0, 0, 0},
        font_size = 100,
        label = "Roll",
        tooltip = "Randomly roll for control duration."
    })
end

----------------------
-- functions
----------------------
function edit(obj, color, alt_click)
    local oldValue = buttonValues.main
    local keyword = ""
    local side = self.getRotation()
    if alt_click then
        buttonValues.main = math.max(buttonValues.main - 1, 0)
        keyword = "decreases"
    else
        buttonValues.main = math.min(buttonValues.main + 1, 4)
        keyword = "increases"
    end
    
    if oldValue ~= buttonValues.main then
        if side.z == 180 then 
            broadcastToAll(playerboard.reverse .. " control " .. keyword .. " to " .. buttonValues.main .. ".", playerboard.color)
        else
            broadcastToAll(playerboard.obverse .. " control " .. keyword .. " to " .. buttonValues.main .. ".", playerboard.color)
        end
    end
    
    self.editButton({
        index = 0,
        label = buttonValues.main
    })
    self.editButton({
        index = 2,
        label = buttonValues.main
    })
end

function roll()
    local randomIndex = math.random(#rollValues)
    local selectedValue = rollValues[randomIndex]
    
    local firstNum = string.sub(selectedValue, 1, 1)
    local secondNum = string.sub(selectedValue, 3, 3)
    local formattedText = string.format("[FF8C00]%s[000000]/[800000]%s", firstNum, secondNum)
    
    self.editButton({
        index = 1,
        label = formattedText
    })
    self.editButton({
        index = 3,
        label = formattedText
    })
    
    local broadcastText = string.format("Rolled control values: [FF8C00]%s[000000]/[800000]%s.", firstNum, secondNum)
    broadcastToAll(broadcastText, playerboard.color)
    
    Wait.time(function()
        self.editButton({
            index = 1,
            label = "Roll"
        })
        self.editButton({
            index = 3,
            label = "Roll"
        })
    end, 5)
end