----------------------
-- Tofu Tumble
-- Refactored by tofuwater
-- Original by MrStump + Archmagos Diodelosus
----------------------
self.setName("River Contract")

----------------------
-- script variables
----------------------
disableSave = false
buttonFontColor = {-1, -1, -1,15}
buttonColor = {1, 1, 1, 0.4}
buttonScale = {0.15, 0.15, 0.15}
defaultButtonData = {
    textbox = {
        {
            pos       = {-0.62,0.1,0},
            rows      = 12,
            width     = 3800,
            font_size = 500,
            label     = "Click me to edit!",
            value     = "",
            alignment = 1
        },
        {
            pos       = {0.62,0.1,0},
            rows      = 12,
            width     = 3800,
            font_size = 500,
            label     = "Click me to edit!",
            value     = "",
            alignment = 1
        },
    }
}
buttons = {
    ["1"] = {
        player = "_____",
        color = {0.7, 0.7, 0.7}
    },
    ["2"] = {
        player = "_____",
        color = {0.7, 0.7, 0.7}
    },
    ["3"] = {
        player = "_____",
        color = {0.7, 0.7, 0.7}
    },
    ["4"] = {
        player = "_____",
        color = {0.7, 0.7, 0.7}
    },
    ["5"] = {
        player = "_____",
        color = {0.7, 0.7, 0.7}
    },
    ["6"] = {
        player = "_____",
        color = {0.7, 0.7, 0.7}
    }
}
buttonVariables = {
    buttonWidth = 300,
    buttonHeight = 100,
    startX = -1,
    startZ = 1.1,
    spacingX = 0.4,
    fontSize = 50,
    scale = {0.5, 0.5, 0.5}
}

----------------------
-- onload
----------------------
function onload(saved_data)
    if disableSave == true then
        saved_data = "" 
    end
    
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        ref_buttonData = loaded_data
    else
        ref_buttonData = defaultButtonData
    end

    createAllButtons()
end

----------------------
-- create buttons
----------------------
function createAllButtons()
    createTextbox()
    createSigns()
end

function createTextbox()
    for i, data in ipairs(ref_buttonData.textbox) do
        --Sets up reference function
        local funcName = "textbox"..i
        local func = function(_,_,val,sel) click_textbox(i,val,sel) end
        self.setVar(funcName, func)

        self.createInput({
            input_function = funcName,
            function_owner = self,
            label          = data.label,
            alignment      = data.alignment,
            position       = data.pos,
            scale          = buttonScale,
            width          = data.width,
            height         = (data.font_size*data.rows)+24,
            font_size      = data.font_size,
            color          = buttonColor,
            font_color     = buttonFontColor,
            value          = data.value,
        })
    end
end

function createSigns()
    for i = 1, 6 do
        self.createButton({
            click_function = "buttonClick_" .. i,
            function_owner = self,
            position = {
                buttonVariables.startX + (i-1) * buttonVariables.spacingX, 
                0.2, 
                buttonVariables.startZ
            },
            width = buttonVariables.buttonWidth,
            height = buttonVariables.buttonHeight,
            color = buttons[tostring(i)].color,
            font_size = buttonVariables.fontSize,
            scale = buttonVariables.scale,
            label = buttons[tostring(i)].player,
            tooltip = "Right: Sign your name.\nLeft: Erase your name."
        })
    end
end

----------------------
-- functions
----------------------
function updateSave()
    saved_data = JSON.encode(ref_buttonData)
    if disableSave==true then saved_data="" end
    self.script_state = saved_data
end

function click_textbox(i, value, selected)
    if selected == false then
        ref_buttonData.textbox[i].value = value
        updateSave()
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
    buttons[tostring(buttonIndex)].player = "_____"
    buttons[tostring(buttonIndex)].color = {0.7, 0.7, 0.7}
end

function updateButtons()
    for i = 1, 6 do
        self.editButton({
            index = i - 1,
            label = buttons[tostring(i)].player,
            color = buttons[tostring(i)].color
        })
    end
end

----------------------
-- on click functions
----------------------
for i = 1, 6 do
    _G["buttonClick_" .. i] = function(obj, color, alt_click)
        handleButtonClick(i, color, alt_click)
    end
end


