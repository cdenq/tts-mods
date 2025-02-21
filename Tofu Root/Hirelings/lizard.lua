----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Lizard Hireling")

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
    obverse = "Warm Sun Prophets",
    reverse = "Lizard Envoys",
    color = normalizeRGB({250,239,101})
}
buttonValues = {
    main = 2,
    claimed = "",
    claimedBefore = false
}
rollValues = {"2/4", "1/2", "2/3", "2/3", "1/2", "1/2"}
warriorMapRotation = {0.00, 180.00, 0.00}
warriorGUIDs = {
    "c10538",
    "da02a6",
    "def2d2",
    "879fa6"
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
        {11.00, 1.58, -9.84},
        {-0.26, 1.58, -6.77},
        {-8.08, 1.58, 2.58},
        {7.25, 1.58, 10.29}
    },
    lake = {
        {6.54, 1.58, -8.00},
        {-10.84, 1.58, -2.79},
        {-21.85, 1.58, 5.16},
        {11.13, 1.58, 9.27}
    },
    winter = {
        {5.79, 1.58, -1.79},
        {-6.53, 1.58, -3.96},
        {-5.33, 1.58, 9.82},
        {8.87, 1.58, 17.54}
    },
    autumn = {
        {1.10, 1.58, -7.53},
        {-3.51, 1.58, 0.70},
        {7.77, 1.58, 0.37},
        {-22.75, 1.58, -0.92}
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
        position = {0.8, 1, -1.15},
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