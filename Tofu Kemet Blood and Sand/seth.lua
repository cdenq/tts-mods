----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Seth Board")

----------------------
-- standard variables
-- added here manually instead of in a global file to allow for 
-- scripting to save locally on objects
----------------------
myColors = {
    white = {1, 1, 1},
    green = {0, 1, 0},
    red = {1, 0, 0},
    gray = {0.5, 0.5, 0.5},
    black = {0, 0, 0},
    yellow = {1, 1, 0},
    purple = {0.5, 0, 0.5}
}

----------------------
-- set variables
----------------------
playerboard = {
    faction = "Seth",
    color = myColors.purple,
    trackerGUID = "3c0b40",
    boardGUID = "72ab3a", --self
}
deckZone = "d9acef"

----------------------
-- script variables
----------------------
buttonsVariables = {
    main = {
        position = {-1.1, 0.18, -0.5},
        color = myColors.white,
        fontcolor = myColors.black,
        scale = {0.5, 0.5, 0.5},
        height = 375,
        width = 450,
        fontsize = 200,
        tooltip = "Prayer Points\nLeft/right click to in/decrement."
    },
    net = {
        position = {-1.3, 0.2, -0.4},
        color = myColors.gray,
        fontcolor = myColors.black,
        scale = {0.5, 0.5, 0.5},
        height = 200,
        width = 225,
        fontsize = 75,
        tooltip = "Planned Prayer Points Tally\nClick to reset planned values."
    },
    pos = {
        position = {-0.75, 0.18, -0.6},
        color = myColors.gray,
        fontcolor = myColors.green,
        scale = {0.5, 0.5, 0.5},
        height = 200,
        width = 250,
        fontsize = 75,
        tooltip = "Planned prayer point gain."
    },
    neg = {
        position = {-0.75, 0.18, -0.4},
        color = myColors.gray,
        fontcolor = myColors.red,
        scale = {0.5, 0.5, 0.5},
        height = 200,
        width = 250,
        fontsize = 75,
        tooltip = "Planned prayer point loss."
    },
    draw = {
        position = {-1.15, 0.18, 0.85},
        color = myColors.white,
        fontcolor = myColors.black,
        scale = {0.5, 0.5, 0.5},
        height = 225,
        width = 400,
        fontsize = 75,
        label = "DRAW DI",
        tooltip = "Draw 1 DI card."
    }
}
buttonValues = {
    main = 7,
    pos = 0,
    neg = 0
}
local scorePositions = {
    [0] = {x = -4.880, y = 0.270, z = 3.800},
    [1] = {x = -3.930, y = 0.270, z = 3.820},
    [2] = {x = -2.950, y = 0.270, z = 3.790},
    [3] = {x = -1.950, y = 0.270, z = 3.800},
    [4] = {x = -1.000, y = 0.270, z = 3.790},
    [5] = {x = -0.010, y = 0.270, z = 3.770},
    [6] = {x = 0.970, y = 0.270, z = 3.760},
    [7] = {x = 1.970, y = 0.270, z = 3.780},
    [8] = {x = 2.940, y = 0.270, z = 3.790},
    [9] = {x = 3.900, y = 0.270, z = 3.770},
    [10] = {x = 4.860, y = 0.270, z = 3.750},
    [11] = {x = 5.830, y = 0.270, z = 3.740}
}

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
    createMainPPButton()
    createNetPPButton()
    createPositivePPButton()
    createNegativePPButton()
    createDrawButton()
end

function createMainPPButton()
    self.createButton({
        click_function = "edit",
        function_owner = self,
        position = buttonsVariables.main.position,
        height = buttonsVariables.main.height,
        width = buttonsVariables.main.width,
        scale = buttonsVariables.main.scale,
        color = buttonsVariables.main.color,
        font_color = buttonsVariables.main.fontcolor,
        font_size = buttonsVariables.main.fontsize,
        label = buttonValues.main,
        tooltip = buttonsVariables.main.tooltip
    })
end

function createNetPPButton()
    self.createButton({
        click_function = "resetPlanButtons",
        function_owner = self,
        position = buttonsVariables.net.position,
        height = buttonsVariables.net.height,
        width = buttonsVariables.net.width,
        scale = buttonsVariables.net.scale,
        color = buttonsVariables.net.color,
        font_color = buttonsVariables.net.fontcolor,
        font_size = buttonsVariables.net.fontsize,
        label = buttonValues.main,
        tooltip = buttonsVariables.net.tooltip
    })
end

function createPositivePPButton()
    self.createButton({
        click_function = "updatePosButton",
        function_owner = self,
        position = buttonsVariables.pos.position,
        height = buttonsVariables.pos.height,
        width = buttonsVariables.pos.width,
        scale = buttonsVariables.pos.scale,
        color = buttonsVariables.pos.color,
        font_color = buttonsVariables.pos.fontcolor,
        font_size = buttonsVariables.pos.fontsize,
        label = buttonValues.pos,
        tooltip = buttonsVariables.pos.tooltip
    })
end

function createNegativePPButton()
    self.createButton({
        click_function = "updateNegButton",
        function_owner = self,
        position = buttonsVariables.neg.position,
        height = buttonsVariables.neg.height,
        width = buttonsVariables.neg.width,
        scale = buttonsVariables.neg.scale,
        color = buttonsVariables.neg.color,
        font_color = buttonsVariables.neg.fontcolor,
        font_size = buttonsVariables.neg.fontsize,
        label = buttonValues.neg,
        tooltip = buttonsVariables.neg.tooltip
    })
end

function createDrawButton()
    self.createButton({
        click_function = "drawDI",
        function_owner = self,
        position = buttonsVariables.draw.position,
        height = buttonsVariables.draw.height,
        width = buttonsVariables.draw.width,
        scale = buttonsVariables.draw.scale,
        color = buttonsVariables.draw.color,
        font_color = buttonsVariables.draw.fontcolor,
        font_size = buttonsVariables.draw.fontsize,
        label = buttonsVariables.draw.label,
        tooltip = buttonsVariables.draw.tooltip
    })
end

----------------------
-- functions
----------------------
function doNothing()
end

function edit(obj, color, alt_click)
    local oldValue = buttonValues.main
    local keyword = ""
    if alt_click then
        buttonValues.main = math.max(buttonValues.main - 1, 0)
        keyword = "decreases"
    else
        buttonValues.main = math.min(buttonValues.main + 1, 11)
        keyword = "increases"
    end
    
    if oldValue ~= buttonValues.main then
        broadcastToAll(playerboard.faction .. " prayer points " .. keyword .. " to " .. buttonValues.main .. ".", playerboard.color)
    end
    
    moveMarker(alt_click)
    updateMainButton()
end

function updatePosButton(obj, color, alt_click)
    if alt_click then
        buttonValues.pos = math.max(buttonValues.pos - 1, 0)
    else
        buttonValues.pos = buttonValues.pos + 1
    end

    self.editButton({
        index = 2, --pos button index
        label = buttonValues.pos
    })

    updateNetButton()
end

function updateNegButton(obj, color, alt_click)
    if alt_click then
        buttonValues.neg = math.max(buttonValues.neg - 1, 0)
    else
        buttonValues.neg = buttonValues.neg + 1
    end

    self.editButton({
        index = 3, --neg button index
        label = buttonValues.neg
    })

    updateNetButton()
end

function resetPlanButtons(obj, color, alt_click)
    buttonValues.pos = 0
    buttonValues.neg = 0
    self.editButton({
        index = 2, --pos button index
        label = buttonValues.pos
    })
    self.editButton({
        index = 3, --neg button index
        label = buttonValues.neg
    })
    updateNetButton()
end

function updateMainButton()
    self.editButton({
        index = 0, --main button index
        label = buttonValues.main
    })
end

function updateNetButton()
    local finalValue = buttonValues.main - buttonValues.neg + buttonValues.pos
    local fontColor = myColors.black
    
    if finalValue > buttonValues.main then
        fontColor = myColors.green
    elseif finalValue < buttonValues.main then
        fontColor = myColors.red
    end

    self.editButton({
        index = 1, --net button index
        font_color = fontColor,
        label = finalValue
    })
end

function moveMarker(alt_click)
    local board = getObjectFromGUID(playerboard.boardGUID)
    local marker = getObjectFromGUID(playerboard.trackerGUID)
    local relativePos = scorePositions[buttonValues.main]
    local boardPos = board.getPosition()
    local newPos = {
        x = boardPos.x + relativePos.x,
        y = boardPos.y + relativePos.y + 2,
        z = boardPos.z + relativePos.z
    }
    marker.setPositionSmooth(newPos)
end

function drawDI(obj, color)
    local zoneItself = getObjectFromGUID(deckZone)
    local objInZone = zoneItself.getObjects()
    for _, obj in ipairs(objInZone) do
        if obj.tag == "Deck" or obj.tag == "Card" then
            getObjectFromGUID(obj.guid).deal(1, color)
            broadcastToAll(playerboard.faction .. " draws 1 DI card.", playerboard.color)
        end
    end
end