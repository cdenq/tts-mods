----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("")

----------------------
-- Variables
----------------------
buttonData = {
    snare = {
        position = {0.65, -0.05, -0.65},
        toggled = false
    },
    extort = {
        position = {-0.65, -0.05, -0.65},
        toggled = false
    },
    raid = {
        position = {0.65, -0.05, 0.65},
        toggled = false
    },
    bomb = {
        position = {-0.65, -0.05, 0.65},
        toggled = false
    }
}
myColors = {
    grayColor = {0.75, 0.75, 0.75, 0.75},
    redColor = {1, 0, 0, 0.75}
}
myIterations = {"snare", "extort", "raid", "bomb"}

----------------------
-- onLoad()
----------------------
function onLoad()
    createAllButtons()
end

----------------------
-- createbutton functions
----------------------
function createAllButtons()
    for i, button in ipairs(myIterations) do
        self.createButton({
            click_function = "toggleColor" .. i,
            function_owner = self,
            position = buttonData[button].position,
            height = 600,
            width = 600,
            scale = {0.45, 0.65, 0.45},
            color = myColors.grayColor,
            rotation = {0, 0, 180}
        })
    end
end

----------------------
-- on click functions
----------------------
for i = 1, 4 do
    _G["toggleColor" .. i] = function(obj, color, alt_click)
        toggleColor(i)
    end
end

function toggleColor(i)
    local newColor
    if buttonData[myIterations[i]].toggled then
        buttonData[myIterations[i]].toggled = false
        newColor = myColors.grayColor
    else
        buttonData[myIterations[i]].toggled = true
        newColor = myColors.redColor
    end

    self.editButton({
        index = i-1,
        color = newColor
    })
end
