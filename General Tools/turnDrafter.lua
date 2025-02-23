----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Turn Tool")

----------------------
-- variables
----------------------
myColors = {
    white = {1, 1, 1},
    green = {0, 1, 0},
    red = {1, 0, 0},
    gray = {0.5, 0.5, 0.5},
    black = {0, 0, 0}
}
liftHeight = 0.18
myButtons = {
    buttonFeatures = {
        buttonWidth = 550, 
        buttonHeight = 250, 
        fontSize = 85,
        scale = {0.75, 0.75, 0.75},
        defaultColor = myColors.white
    },
    slotButtonFeatures = {
        buttonWidth = 700, 
        buttonHeight = 400, 
        fontSize = 100,
        scale = {0.45, 0.45, 0.45},
        defaultColor = myColors.gray
    },
    buttonPositions = {
        pickOrderPos = {-1, liftHeight, -0.5},
        promotePos = {1, liftHeight, -0.5},
        demotePos = {0, liftHeight, -0.5},
        finalizeSeatPos = {0.5, liftHeight, 0.75},
        clearSeatPos = {-0.5, liftHeight, 0.75},
        slotButtonPos = {startX = -1.3, startZ = -0.1, spacingX = 0.65, spacingZ = 0.4}
    }
}
pickOrderSet = false
temporarySeatOrder = {}
activeSlots = 0
maxPlayers = 10
tofuTimerGUID = "87aca4"
tofuTimerObj = getObjectFromGUID(tofuTimerGUID)

----------------------
-- onload function
----------------------
function onLoad()
    createButtons()
end

----------------------
-- debugg function
----------------------
function printSeated()
    testseated = getSeatedPlayers()
    for i, value in ipairs(testseated) do 
        printToAll(i..value)
    end
end

----------------------
-- create button functions
----------------------
function createButtons()
    self.createButton({
        click_function = "randomizePickOrder",
        label = "Pick Order",
        function_owner = self,
        position = myButtons.buttonPositions.pickOrderPos,
        width = myButtons.buttonFeatures.buttonWidth,
        height = myButtons.buttonFeatures.buttonHeight,
        font_size = myButtons.buttonFeatures.fontSize,
        scale = myButtons.buttonFeatures.scale,
        color = myColors.green
    })

    self.createButton({
        click_function = "promoteAllPlayers",
        label = "Promote",
        function_owner = self,
        position = myButtons.buttonPositions.promotePos,
        width = myButtons.buttonFeatures.buttonWidth,
        height = myButtons.buttonFeatures.buttonHeight,
        font_size = myButtons.buttonFeatures.fontSize,
        scale = myButtons.buttonFeatures.scale,
        color = myButtons.buttonFeatures.defaultColor
    })

    self.createButton({
        click_function = "demoteAllPlayers",
        label = "Demote",
        function_owner = self,
        position = myButtons.buttonPositions.demotePos,
        width = myButtons.buttonFeatures.buttonWidth,
        height = myButtons.buttonFeatures.buttonHeight,
        font_size = myButtons.buttonFeatures.fontSize,
        scale = myButtons.buttonFeatures.scale,
        color = myButtons.buttonFeatures.defaultColor
    })

    self.createButton({
        click_function = "clearSeats",
        label = "Clear Seats",
        function_owner = self,
        position = myButtons.buttonPositions.clearSeatPos,
        width = myButtons.buttonFeatures.buttonWidth,
        height = myButtons.buttonFeatures.buttonHeight,
        font_size = myButtons.buttonFeatures.fontSize,
        scale = myButtons.buttonFeatures.scale,
        color = myButtons.buttonFeatures.defaultColor
    })

    self.createButton({
        click_function = "finalizeSeats",
        label = "Finalize Seats",
        function_owner = self,
        position = myButtons.buttonPositions.finalizeSeatPos,
        width = myButtons.buttonFeatures.buttonWidth,
        height = myButtons.buttonFeatures.buttonHeight,
        font_size = myButtons.buttonFeatures.fontSize,
        scale = myButtons.buttonFeatures.scale,
        color = myButtons.buttonFeatures.defaultColor
    })

    for i = 1, maxPlayers do
        local row = math.floor((i-1) / 5)  
        local col = (i-1) % 5              
        local posX = myButtons.buttonPositions.slotButtonPos.startX + (col * myButtons.buttonPositions.slotButtonPos.spacingX)
        local posZ = myButtons.buttonPositions.slotButtonPos.startZ + (row * myButtons.buttonPositions.slotButtonPos.spacingZ)
        self.createButton({
            click_function = "clickSlot_" .. i,
            label = "x",
            function_owner = self,
            position = {posX, liftHeight, posZ},
            width = myButtons.slotButtonFeatures.buttonWidth,
            height = myButtons.slotButtonFeatures.buttonHeight,
            font_size = myButtons.slotButtonFeatures.fontSize,
            scale = myButtons.slotButtonFeatures.scale,
            color = myButtons.slotButtonFeatures.defaultColor,
            font_color = {1, 1, 1},
        })
    end
end

----------------------
-- main click functions
----------------------
function promoteAllPlayers()
    if not Player.host then
        broadcastToColor("Only the host can use this function.")
        return
    end

    local seated = getSeatedPlayers()
    for _, color in ipairs(seated) do
        if not Player[color].promoted then
            Player[color].promote()
        end
    end
end

function demoteAllPlayers()
    local seated = getSeatedPlayers()
    for _, color in ipairs(seated) do
        if Player[color].promoted then
            Player[color].promote(false)
        end
    end
end

function randomizePickOrder()
    if tofuTimerObj then 
        tofuTimerObj.call("activateTimer")
    end 

    pickOrderSet = true
    clearSeats()
    math.randomseed(os.time())
    local seated = getSeatedPlayers()
    local n = #seated
    
    if n == 0 then
        broadcastToAll("No eligible players found.", {1, 0, 0})
        return
    end
    
    if n > 1 then
        for i = n, 2, -1 do
            local j = math.random(i)
            seated[i], seated[j] = seated[j], seated[i]
        end
    end
    
    Turns.type = 2
    Turns.order = seated
    --Turns.enable = true
    --Turns.turn_color = seated[1]
    printToAll("Pick Order:")
    for i = 1, n do
        printToAll(i .. ": " .. Player[seated[i]].steam_name, stringColorToRGB(seated[i]))
    end

    activeSlots = n
    temporarySeatOrder = {}
    for i = 1, maxPlayers do
        if i <= n then
            self.editButton({
                index = i + 4,
                label = "Seat " .. tostring(i),
                color = myColors.gray,
                font_color = myColors.black
            })
        else
            self.editButton({
                index = i + 4,
                label = "x",
                color = myColors.black,
                font_color = myColors.white
            })
        end
    end
end

function clearSeats()
    if pickOrderSet then
        for i = 1, activeSlots do
            self.editButton({
                index = i + 4,
                label = "Seat " .. i,
                color = myColors.gray,
                font_color = myColors.black
            })
        end
        temporarySeatOrder = {}
        printToAll("Seats have been cleared.")
    else
        broadcastToAll("Assign Pick Order first.")
    end
end

function finalizeSeats()
    if pickOrderSet then
        local sortedPlayers = {}
        for name, index in pairs(temporarySeatOrder) do
            table.insert(sortedPlayers, {name = name, index = index})
        end
        table.sort(sortedPlayers, function(a, b) return a.index < b.index end)

        local newOrder = {}
        for _, playerInfo in ipairs(sortedPlayers) do
            for _, color in ipairs(getSeatedPlayers()) do
                if Player[color].steam_name == playerInfo.name then
                    table.insert(newOrder, color)
                    break
                end
            end
        end
        
        if #newOrder == activeSlots then
            Turns.order = newOrder
            Turns.type = 2
            Turns.enable = true
            Turns.turn_color = newOrder[1]
            
            printToAll("New Turn Order:")
            for i, color in ipairs(newOrder) do
                printToAll(i .. ": " .. Player[color].steam_name, stringColorToRGB(color))
            end
        else
            broadcastToAll("Not all seats have been assigned.")
        end
    else
        broadcastToAll("Assign Pick Order first.")
    end
end

----------------------
-- slot button functions
----------------------
for i = 1, maxPlayers do
    _G["clickSlot_" .. i] = function(obj, color, alt_click)
        if i <= activeSlots then
            local player = Player[color]
            local newLabel = "Seat " .. i .. ":\n" .. player.steam_name
            obj.editButton({
                index = i + 4, 
                label = newLabel, 
                color = stringColorToRGB(color), 
                font_color = myColors.black})
            temporarySeatOrder[player.steam_name] = i
        end
    end
end