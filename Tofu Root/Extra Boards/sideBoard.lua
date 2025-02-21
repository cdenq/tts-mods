----------------------
-- Coded for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Sideboard Landmarks")

----------------------
-- variables
----------------------
buttons = {
    ["1"] = {
        player = "Unclaimed",
        color = {0.7, 0.7, 0.7}
    },
    ["2"] = {
        player = "Unclaimed",
        color = {0.7, 0.7, 0.7}
    },
    ["3"] = {
        player = "Unclaimed",
        color = {0.7, 0.7, 0.7}
    }
}
buttonVariables = {
    buttonWidth = 300,
    buttonHeight = 100,
    spacing = 0.6,
    startX = 0.2,
    y = 0.2,
    z = -0.8,
    fontSize = 50,
    scale = {0.4, 0.4, 0.4},
    defaultColor = {0.7, 0.7, 0.7}
}

----------------------
-- on load
----------------------
function onLoad()
    createAllButtons()
end

----------------------
-- create all  buttons
----------------------
function createAllButtons()
    for i = 1, 3 do
        self.createButton({
            click_function = "buttonClick_" .. i,
            function_owner = self,
            position = {
                buttonVariables.startX + (i-1) * buttonVariables.spacing, 
                buttonVariables.y, 
                buttonVariables.z
            },
            width = buttonVariables.buttonWidth,
            height = buttonVariables.buttonHeight,
            color = buttonVariables.defaultColor,
            font_size = buttonVariables.fontSize,
            scale = buttonVariables.scale,
            label = buttons[tostring(i)].player
        })
    end
end

----------------------
-- on click
----------------------
for i = 1, 3 do
    _G["buttonClick_" .. i] = function(obj, color, alt_click)
        handleButtonClick(i, color, alt_click)
    end
end

----------------------
-- main function
----------------------
function handleButtonClick(buttonIndex, color, alt_click)
    if alt_click then
        resetButton(buttonIndex)
    else
        local player = Player[color]
        if player then
            assignPlayerToButton(buttonIndex, player)
        end
    end
    updateButtons()
end

function assignPlayerToButton(buttonIndex, player)
    buttons[tostring(buttonIndex)].player = player.steam_name
    buttons[tostring(buttonIndex)].color = player.color
end

function resetButton(buttonIndex)
    buttons[tostring(buttonIndex)].player = "Unclaimed"
    buttons[tostring(buttonIndex)].color = {0.7, 0.7, 0.7}
end

function updateButtons()
    for i = 1, 3 do
        self.editButton({
            index = i - 1,
            label = buttons[tostring(i)].player,
            color = buttons[tostring(i)].color
        })
    end
end