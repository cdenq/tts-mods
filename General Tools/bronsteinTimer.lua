----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Timer")
-- control buttons 0-2
-- player name buttons 3, 4 ... myBookkeepingVariables.numPlayers+2
-- player time buttons myBookkeepingVariables.numPlayers+3 ... (2*numPlayers)+2
-- counter buttons (2*numPlayers)+3 ... (3*numPlayers)+2

----------------------
-- Variables
----------------------
buttonConfig = {
    common = {
        baseY = 0.2,
        width = 300,
        height = 175,
        font_size = 70,
        color = {1, 1, 1},
        font_color = {0, 0, 0},
        unlight = {0.2, 0.2, 0.2, 0.8}
    },
    control = {
        baseX = -0.65,
        baseZ = -0.8,
        spacingZ = 0.65,
        scale = {0.9, 0.9, 0.9}
    },
    player = {
        baseX = -0.8,
        baseZ = 0.25,
        spacingX = 0.4,
        spacingZ = 0.45,
        width = 400,
        font_size = 50,
        spacingTimeShift = 0.15,
        color = {0.8, 0.8, 0.8},
        scale = {0.5, 0.5, 0.5}
    },
    counter = {
        baseZ = 0.3,
        spacingCounterShift = 0.12,
        width = 200,
        height = 200,
        font_size = 75,
        scale = {0.3, 0.3, 0.3}
    },
}
myIterations = {
    control = {"Start", "Pause", "Setup"}
}
myBookkeepingVariables = {
    numPlayers = 10,
    startingTimeBank = 0,
    addedTime = 0,
    isRunning = false,
    lastUpdateTime = 0,
    timerCoroutine = nil,
    playerOrder = {}, --by color
    activePlayer = 0, --by index
    firstTime = false,
}
myPlayerData = {}
-- an entry looks like the below
-- ["player1"] = {
--     steamName = "",
--     color = {0, 0, 0},
--     turnCount = 0,
--     timeBank = 0,
--     warningAddedMin = false,
--     warningOneMin = false,
--     warningOutOfTime = false
-- }
myMapObjs = {
    deckZone = "cf89ff"
}

----------------------
-- helper functions
----------------------
function doNothing()
end

function getPlayerIndexByColor(color)
    for i, orderedColor in ipairs(myBookkeepingVariables.playerOrder) do
        if orderedColor == color then
            return i
        end
    end
    return nil
end

function formatTime(seconds)
    local negative = seconds < 0
    seconds = math.abs(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    local timeString = string.format("%02d:%04.1f", minutes, remainingSeconds)
    return negative and "-" .. timeString or timeString
end

function shuffleDeck()
    local zoneObjects = getObjectFromGUID(myMapObjs.deckZone).getObjects()
    for _, obj in ipairs(zoneObjects) do
        if obj.type == "Deck" then
            obj.shuffle()
            break
        end
    end
end

function round(number, decimals)
    decimals = decimals or 0
    local multiplier = 10 ^ decimals
    return math.floor(number * multiplier + 0.5) / multiplier
end

----------------------
-- onLoad
----------------------
function onLoad()
    initializeAll()
    createButtons()
    --lastTurnColor = Turns.turn_color
end

----------------------
-- create button functions
----------------------
function createButtons()
    createControlButtons()
    createNameButtons()
    createTimeButtons()
    createCounterButtons()
end 

function createControlButtons()
    for i, button in ipairs(myIterations.control) do
        self.createButton({
            click_function = "click" .. button,
            function_owner = self,
            label = button,
            position = {
                x = buttonConfig.control.baseX + (i-1) * buttonConfig.control.spacingZ, 
                y = buttonConfig.common.baseY, 
                z = buttonConfig.control.baseZ
            },
            width = buttonConfig.common.width,
            height = buttonConfig.common.height,
            scale = buttonConfig.control.scale,
            font_size = buttonConfig.common.font_size,
            color = buttonConfig.common.color,
            font_color = buttonConfig.common.font_color
        })
    end
end

function createNameButtons()
    for i = 1, myBookkeepingVariables.numPlayers do
        local row = math.ceil(i / 5)
        local col = (i - 1) % 5 + 1
        
        self.createButton({
            click_function = "doNothing",
            function_owner = self,
            label = "Player " .. i,
            position = {
                x = buttonConfig.player.baseX + (col - 1) * buttonConfig.player.spacingX, 
                y = buttonConfig.common.baseY, 
                z = buttonConfig.player.baseZ + (row - 1) * buttonConfig.player.spacingZ
            },
            width = buttonConfig.player.width,
            height = buttonConfig.common.height / 2,
            scale = buttonConfig.player.scale,
            font_size = buttonConfig.player.font_size,
            color = buttonConfig.player.color,
            font_color = buttonConfig.common.font_color
        })
    end
end

function createTimeButtons()
    for i = 1, myBookkeepingVariables.numPlayers do
        local row = math.ceil(i / 5)
        local col = (i - 1) % 5 + 1
        
        self.createButton({
            click_function = "doNothing",
            function_owner = self,
            label = formatTime(myPlayerData[tostring(i)].timeBank),
            position = {
                x = buttonConfig.player.baseX + (col - 1) * buttonConfig.player.spacingX, 
                y = buttonConfig.common.baseY, 
                z = buttonConfig.player.baseZ + (row - 1) * buttonConfig.player.spacingZ + buttonConfig.player.spacingTimeShift
            },
            width = buttonConfig.player.width,
            height = buttonConfig.common.height,
            scale = buttonConfig.player.scale,
            font_size = buttonConfig.common.font_size,
            color = buttonConfig.player.color,
            font_color = buttonConfig.common.font_color
        })
    end
end

function createCounterButtons()
    for i = 1, myBookkeepingVariables.numPlayers do
        local row = math.ceil(i / 5) 
        local col = (i - 1) % 5 + 1

        self.createButton({
            click_function = "counterButton_" .. i,
            function_owner = self,
            label = myPlayerData[tostring(i)].turnCount,
            position = {
                x = buttonConfig.player.baseX + (col - 1) * buttonConfig.player.spacingX, 
                y = buttonConfig.common.baseY, 
                z = buttonConfig.player.baseZ + (row - 1) * buttonConfig.player.spacingZ - buttonConfig.counter.spacingCounterShift
            },
            width = buttonConfig.counter.width,
            height = buttonConfig.counter.height,
            scale = buttonConfig.counter.scale,
            font_size = buttonConfig.counter.font_size,
            color = buttonConfig.common.color,
            font_color = buttonConfig.common.font_color
        })
    end
end

----------------------
-- onclick functions
----------------------
for i = 1, myBookkeepingVariables.numPlayers do
    _G["counterButton_" .. i] = function(obj, color, alt_click)
        counterButton_click(i, alt_click)
    end
end

----------------------
-- initialize functions
----------------------
function initializeAll()
    initializeTimes()
    initializePlayerData()
end

function initializeTimes()
    local description = self.getDescription()
    if description then
        local timeBank, addTime = description:match("(%d+)[%s,]*(%d*)")
        if timeBank then
            myBookkeepingVariables.startingTimeBank = tonumber(timeBank)
            if addTime and addTime ~= "" then
                myBookkeepingVariables.addedTime = tonumber(addTime)
            end
        end
    end
    
    if type(myBookkeepingVariables.startingTimeBank) ~= "number" or myBookkeepingVariables.startingTimeBank < 0 then
        myBookkeepingVariables.startingTimeBank = 900
    end
    if type(myBookkeepingVariables.addedTime) ~= "number" or myBookkeepingVariables.addedTime < 0 then
        myBookkeepingVariables.addedTime = 180
    end
end

function initializePlayerData()
    myPlayerData = {}
    for i = 1, myBookkeepingVariables.numPlayers do
        myPlayerData[tostring(i)] = {
            steamName = "",
            color = {0, 0, 0},
            turnCount = 0,
            timeBank = 0,
            warningAddedMin = false,
            warningOneMin = false,
            warningOutOfTime = false
        }
    end
end

----------------------
-- SETUP/RESET TIMER functions
----------------------
function clickSetup()
    clickPause()
    resetPlayerData()
    relabelSetupButton()
    announceFeatures()
end

function resetPlayerData()
    wipePlayerData()
    queryPlayerOrder()
    queryActivePlayer()
    fillPlayerData()
    updateAll()
end

function wipePlayerData()
    initializePlayerData()
end

function queryPlayerOrder()
    myBookkeepingVariables.playerOrder = {}
    for _, color in ipairs(Turns.order) do
        table.insert(myBookkeepingVariables.playerOrder, color)
    end
end

function queryActivePlayer()
    myBookkeepingVariables.activePlayer = getPlayerIndexByColor(Turns.turn_color)
end

function fillPlayerData()
    for i, color in ipairs(myBookkeepingVariables.playerOrder) do
        myPlayerData[tostring(i)].steamName = Player[color].steam_name
        myPlayerData[tostring(i)].color = color

        if myBookkeepingVariables.activePlayer == i then
            myPlayerData[tostring(i)].timeBank = myBookkeepingVariables.startingTimeBank + myBookkeepingVariables.addedTime
            myPlayerData[tostring(i)].turnCount = 1
        else 
            myPlayerData[tostring(i)].timeBank = myBookkeepingVariables.startingTimeBank
        end
    end
end

function relabelSetupButton()
    if not myBookkeepingVariables.firstTime then
        self.editButton({
            index = 2, --setup button
            label = "Reset"
        })
        myBookkeepingVariables.firstTime = true
    end
end

function announceFeatures()
    printToAll("Starting Time: " .. formatTime(myBookkeepingVariables.startingTimeBank) .. ".")
    printToAll("Added Time: " .. formatTime(myBookkeepingVariables.addedTime) .. ".")
    printToAll("Adding " .. formatTime(myBookkeepingVariables.addedTime) .. " to current/first player's time.")
end

----------------------
-- update functions
----------------------
function updateAll()
    updateAllPlayerButtons()
    updateAllCounterButtons()
    highlightActivePlayer()
end

function updateAllPlayerButtons()
    for i = 1, myBookkeepingVariables.numPlayers do 
        updatePlayerButton(i)
    end
end 

function updatePlayerButton(i)
    local player, playerColor, timeBank, turnCount, clickFunction

    if i <= #myBookkeepingVariables.playerOrder then
        player = myPlayerData[tostring(i)].steamName
        playerColor = myPlayerData[tostring(i)].color
        timeBank = formatTime(myPlayerData[tostring(i)].timeBank)
        turnCount = myPlayerData[tostring(i)].turnCount
        clickFunction = "counterButton_" .. i
    else 
        player = "Unseated"
        playerColor = buttonConfig.common.unlight
        timeBank = "-"
        turnCount = "-"
        clickFunction = "doNothing"
    end

    self.editButton({
        index = i + 2,
        label = player,
        color = playerColor
    })
    self.editButton({
        index = i + 2 + myBookkeepingVariables.numPlayers,
        label = timeBank,
        color = playerColor
    })
    self.editButton({
        index = i + 2 + 2*myBookkeepingVariables.numPlayers,
        label = turnCount,
        color = playerColor,
        click_function = clickFunction
    })
end

function highlightActivePlayer() 
    for i, color in ipairs(myBookkeepingVariables.playerOrder) do
        local buttonColor
        if i == myBookkeepingVariables.activePlayer then
            buttonColor = color
        else
            buttonColor = {0.5, 0.5, 0.5}
        end

        self.editButton({
            index = i + 2 + myBookkeepingVariables.numPlayers, 
            color = buttonColor
        })
        self.editButton({
            index = i + 2 + 2*myBookkeepingVariables.numPlayers, 
            color = buttonColor
        })
    end
end

function updateAllCounterButtons()
    for i = 1, myBookkeepingVariables.numPlayers do
        updateCounterButton(i)
    end
end

----------------------
-- counter function
----------------------
function counterButton_click(i, alt_click)
    if alt_click then
        myPlayerData[tostring(i)].turnCount = math.max(myPlayerData[tostring(i)].turnCount - 1, 0)
    else
        myPlayerData[tostring(i)].turnCount = myPlayerData[tostring(i)].turnCount + 1
    end
    updateCounterButton(i)
end

function updateCounterButton(i)
    local buttonIndex = (2 * myBookkeepingVariables.numPlayers) + 2 + i
    self.editButton({
        index = buttonIndex,
        label = tostring(myPlayerData[tostring(i)].turnCount)
    })
end

----------------------
-- PAUSE TIMER functions
----------------------
function clickPause()
    myBookkeepingVariables.isRunning = false
    if myBookkeepingVariables.timerCoroutine then
        Wait.stop(myBookkeepingVariables.timerCoroutine)
        myBookkeepingVariables.timerCoroutine = nil
    end
end

----------------------
-- START TIMER functions
----------------------
function clickStart()
    if not myBookkeepingVariables.isRunning then --if isRunning == false
        myBookkeepingVariables.isRunning = true
        myBookkeepingVariables.lastUpdateTime = Time.time
        if myBookkeepingVariables.timerCoroutine then
            Wait.stop(myBookkeepingVariables.timerCoroutine)
        end
        myBookkeepingVariables.timerCoroutine = Wait.time(updateTimer, 0.1, -1)
        shuffleDeck() -- root specific
    else
        doNothing()
    end
end

function updateTimer()
    if myBookkeepingVariables.isRunning then
        local currentTime = Time.time
        local elapsedTime = currentTime - myBookkeepingVariables.lastUpdateTime
        local i = myBookkeepingVariables.activePlayer
        myBookkeepingVariables.lastUpdateTime = currentTime
        myPlayerData[tostring(i)].timeBank = myPlayerData[tostring(i)].timeBank - elapsedTime
        announcementsByTime(i)
        updatePlayerButton(i)
    else
        doNothing()
    end
end

function announcementsByTime(i)
    i = tostring(i)
    if myPlayerData[i].timeBank <= myBookkeepingVariables.addedTime and not myPlayerData[i].warningAddedMin then
        broadcastToAll(myPlayerData[i].steamName .. " " .. round(myBookkeepingVariables.addedTime/60, 2) .. " minutes left.", myPlayerData[i].color)
        myPlayerData[i].warningAddedMin = true
    elseif myPlayerData[i].timeBank <= 60 and not myPlayerData[i].warningOneMin then
        broadcastToAll(myPlayerData[i].steamName .. " 1 minute left.", myPlayerData[i].color)
        myPlayerData[i].warningOneMin = true
    elseif myPlayerData[i].timeBank <= 0 and not myPlayerData[i].warningOutOfTime then
        broadcastToAll(myPlayerData[i].steamName .. " is out of time!", myPlayerData[i].color)
        myPlayerData[i].warningOutOfTime = true
    else 
        doNothing()
    end
end

----------------------
-- change turn functions
----------------------
function onPlayerTurn(player, previous_player)
    if myBookkeepingVariables.isRunning then 
        local prevIndex = getPlayerIndexByColor(previous_player.color)
        local currIndex = getPlayerIndexByColor(player.color)
        
        resetWarnings(prevIndex)
        myPlayerData[tostring(currIndex)].turnCount = myPlayerData[tostring(currIndex)].turnCount + 1
        myPlayerData[tostring(currIndex)].timeBank = myPlayerData[tostring(currIndex)].timeBank + myBookkeepingVariables.addedTime

        queryActivePlayer()
        updateAll()
    end
end

function resetWarnings(i)
    myPlayerData[tostring(i)].warningAddedMin = false
    myPlayerData[tostring(i)].warningOneMin = false
    myPlayerData[tostring(i)].warningOutOfTime = false
end

function onDestroy()
    if myBookkeepingVariables.timerCoroutine then
        Wait.stop(myBookkeepingVariables.timerCoroutine)
        myBookkeepingVariables.timerCoroutine = nil
    end
end