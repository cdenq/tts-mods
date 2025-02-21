----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("WA Hireling")

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
    obverse = "Spring Uprising",
    reverse = "Rabbit Scouts",
    color = normalizeRGB({87,179,76})
}
buttonValues = {
    main = 2,
    claimed = "",
    claimedBefore = false
}
rollValues = {"2/4", "1/2", "2/3", "2/3", "1/2", "1/2"}
rollSuits = {"MOUSE", "FOX", "BUNNY"}

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
    createRollSuitButton()
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

function createRollSuitButton()
    self.createButton({
        click_function = "rollSuit",
        function_owner = self,
        label = "ROLL",
        position = {0.85, 1, -0.4},
        rotation = {0, 0, 0},
        scale = {0.15, 0.15, 0.4},
        width = 550,
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

function rollSuit()
    local randomIndex = math.random(#rollSuits)
    local selectedValue = rollSuits[randomIndex]
    
    self.editButton({
        index = 6,
        label = selectedValue
    })
    
    local broadcastText = string.format("Uprising springs up in " .. selectedValue .. "!")
    printToAll(broadcastText, playerboard.color)
    
    Wait.time(function()
        self.editButton({
            index = 6,
            label = "Roll"
        })
    end, 5)
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