----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Cat Hireling")

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
    obverse = "Forest Patrol",
    reverse = "Feline Physicians",
    color = normalizeRGB({196,90,29})
}
buttonValues = {
    main = 2,
    claimed = "",
    claimedBefore = false
}
rollValues = {"2/4", "1/2", "2/3", "2/3", "1/2", "1/2"}
warriorMapRotation = {0.00, 180.00, 0.00}
warriorGUIDs = {
    "f3ed86",
    "cfa84e",
    "8d6980",
    "e0e01b",
    "42b906",
    "3f7e68",
    "f30541",
    "ca8cd7",
    "548b49",
    "1dcaaa",
    "583c58",
    "682116"
}
mapGUIDs = {
    autumn = "43180d",
    winter = "e94958",
    lake = "cbb6e5",
    mountain = "2255cd",
    -- gorge = "",
    -- marsh = "",
}
warriorMapPositions = {
    mountain = {
        {18.04, 1.59, -17.01},
        {-0.75, 1.59, -17.11},
        {-15.85, 1.59, -13.66},
        {10.90, 1.59, -9.95},
        {0.96, 1.59, -4.22},
        {-21.50, 1.59, -2.06},
        {22.59, 1.59, 2.40},
        {9.41, 1.59, 7.28},
        {-8.36, 1.59, 2.88},
        {-19.11, 1.59, 11.34},
        {17.58, 1.59, 14.14},
        {-3.66, 1.59, 14.38}
    },
    lake = {
        {17.61, 1.59, -16.08},
        {0.33, 1.59, -18.20},
        {-8.71, 1.59, -13.55},
        {-20.87, 1.59, -8.52},
        {10.98, 1.59, -7.30},
        {-8.38, 1.59, -0.60},
        {-19.29, 1.59, 2.20},
        {9.54, 1.59, 7.89},
        {18.81, 1.59, 13.04},
        {20.11, 1.59, -1.97},
        {2.08, 1.59, 15.65},
        {-18.29, 1.59, 15.15}
    },
    winter = {
        {17.14, 1.59, -17.27},
        {4.57, 1.59, -14.63},
        {-3.23, 1.59, -12.96},
        {-18.21, 1.59, -13.98},
        {-6.49, 1.59, -3.63},
        {-17.75, 1.59, 3.04},
        {6.11, 1.59, 0.00},
        {17.62, 1.59, -5.06},
        {17.27, 1.59, 12.35},
        {9.02, 1.59, 16.15},
        {-5.32, 1.59, 9.44},
        {-14.78, 1.59, 16.25}
    },
    autumn = {
        {20.67, 1.59, -18.69},
        {-1.70, 1.59, -17.24},
        {-17.74, 1.59, -11.62},
        {3.29, 1.59, -9.29},
        {20.70, 1.59, -3.86},
        {-4.20, 1.59, -0.91},
        {10.26, 1.59, 2.43},
        {19.65, 1.59, 14.72},
        {7.66, 1.59, 16.93},
        {-4.11, 1.59, 12.50},
        {-20.29, 1.59, 0.88},
        {-15.84, 1.59, 15.23}
    }
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
    createControlMarkerButton()
    createRollButton()
    createClaimButton()
    createPlaceButton()
end

function createControlMarkerButton()
    for i = 1, 2 do
        local pos
        local rot

        if i == 1 then
            pos = {0.975, 1, 1.25}
            rot = {0, 0, 0}
        else 
            pos = {-0.975, -1, 1.25}
            rot = {0, 0, 180}
        end

        self.createButton({
            click_function = "edit",
            function_owner = self,
            position = pos,
            rotation = rot,
            height = 400,
            width = 225,
            scale = {0.35, 0.35, 0.60},
            color = {1, 1, 1},
            font_color = {0, 0, 0},
            font_size = 200,
            label = buttonValues.main,
            tooltip = "Left/right click to in/decrement control.",
            visibility = 3
        })
    end
end

function createRollButton()
    for i = 1, 2 do
        local pos
        local rot

        if i == 1 then
            pos = {0.975, 1, -1.35}
            rot = {0, 0, 0}
        else 
            pos = {-0.975, -1, -1.35}
            rot = {0, 0, 180}
        end

        self.createButton({
            click_function = "roll",
            function_owner = self,
            position = pos,
            rotation = rot,
            height = 250,
            width = 250,
            scale = {0.275, 0.275, 0.525},
            color = {1, 1, 1},
            font_color = {0, 0, 0},
            font_size = 100,
            label = "Roll",
            tooltip = "Roll for control duration.",
            visibility = 3
        })
    end
end

function createClaimButton()
    for i = 1, 2 do
        local pos
        local rot

        if i == 1 then
            pos = {-1.025, 1, 0}
            rot = {0, 270, 0}
        else 
            pos = {1.025, -1, 0}
            rot = {0, 270, 180}
        end

        self.createButton({
            click_function = "claim",
            function_owner = self,
            position = pos,
            rotation = rot,
            height = 250,
            width = 1300,
            scale = {0.35, 0.15, 0.15},
            color = {1, 1, 1},
            font_color = {0, 0, 0},
            font_size = 100,
            label = "Unclaimed",
            tooltip = "Click to claim.",
            visibility = 3
        })
    end
end

function createPlaceButton()
    self.createButton({
        click_function = "placeAll",
        function_owner = self,
        label = "PLACE ALL",
        position = {0.5, 1, -1.15},
        rotation = {0, 0, 0},
        scale = {0.15, 0.15, 0.4},
        width = 650,
        height = 250,
        font_size = 100,
        color = "Red",
        font_color = "White",
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
            hirelingName = playerboard.reverse
        else
            hirelingName = playerboard.obverse
        end
        printToAll(hirelingName .. " control " .. keyword .. " to " .. buttonValues.main .. ".", playerboard.color)
    end
    
    self.editButton({
        index = 0,
        label = buttonValues.main
    })
    self.editButton({
        index = 1,
        label = buttonValues.main
    })

    if buttonValues.main == 0 then
        local steamColor = playerboard.color
        for _, player in ipairs(Player.getPlayers()) do
            if player.steam_name == buttonValues.claimed then
                steamColor = player.color
                break
            end
        end
        broadcastToAll(buttonValues.claimed .. " relinquishes " .. hirelingName .. ".", steamColor)
    end
end

function roll()
    local randomIndex = math.random(#rollValues)
    local selectedValue = rollValues[randomIndex]
    
    local firstNum = string.sub(selectedValue, 1, 1)
    local secondNum = string.sub(selectedValue, 3, 3)
    local formattedText = string.format("[FF8C00]%s[000000]/[800000]%s", firstNum, secondNum)
    
    self.editButton({
        index = 2,
        label = formattedText
    })
    self.editButton({
        index = 3,
        label = formattedText
    })
    
    local broadcastText = string.format("Rolled control values: [FF8C00]%s[000000]/[800000]%s.", firstNum, secondNum)
    printToAll(broadcastText, playerboard.color)
    
    Wait.time(function()
        self.editButton({
            index = 2,
            label = "Roll"
        })
        self.editButton({
            index = 3,
            label = "Roll"
        })
    end, 5)
end

function claim(obj, color)
    local steamName = Player[color].steam_name
    local side = self.getRotation()
    local hirelingName 
    if side.z == 180 then 
        hirelingName = playerboard.reverse
    else
        hirelingName = playerboard.obverse
    end

    if buttonValues.claimed == steamName then
        buttonValues.claimed = ""
        
        self.editButton({
            index = 4,
            label = "Unclaimed",
            color = {1, 1, 1}
        })
        self.editButton({
            index = 5,
            label = "Unclaimed",
            color = {1, 1, 1}
        })

        printToAll(hirelingName .. " has been unclaimed.", playerboard.color)
        buttonValues.claimedBefore = false
    else 
        self.editButton({
            index = 4,
            label = steamName,
            color = Player[color].color
        })
        self.editButton({
            index = 5,
            label = steamName,
            color = Player[color].color
        })
        
        if buttonValues.claimed ~= "" then
            broadcastToAll(steamName .. " claims " .. hirelingName .. " from " .. buttonValues.claimed .. ".", playerboard.color)
        else
            broadcastToAll(steamName .. " claims " .. hirelingName .. ".", playerboard.color)
        end
        buttonValues.claimed = steamName
    end
end

function placeAll()
    local mapObject, mapName
    for key, mapGUID in pairs(mapGUIDs) do
        mapObject = getObjectFromGUID(mapGUID)
        if mapObject then
            mapName = key
            break
        end
    end
     
    if mapName then
        local positions = warriorMapPositions[mapName]
        for i, warrGUID in ipairs(warriorGUIDs) do
            local tarWarr = getObjectFromGUID(warrGUID)
            if tarWarr then
                local adjustedPosition = {
                    x = positions[i][1],
                    y = positions[i][2] + 2,
                    z = positions[i][3]
                }
                tarWarr.setPositionSmooth(adjustedPosition)
                tarWarr.setRotationSmooth(warriorMapRotation)
            end
        end
        self.removeButton(6)
    end
end

----------------------
-- Turn change
----------------------
function onPlayerTurn(player, previous_player)
    local side = self.getRotation()
    local hirelingName 
    if side.z == 180 then 
        hirelingName = playerboard.reverse
    else
        hirelingName = playerboard.obverse
    end

    if previous_player.steam_name == buttonValues.claimed then
        if buttonValues.claimedBefore == false then
            printToAll(hirelingName .. " control does not decrease the first time it's claimed.", playerboard.color)
            buttonValues.claimedBefore = true
        else
            edit(self, previous_player.color, true)
        end
    end
end