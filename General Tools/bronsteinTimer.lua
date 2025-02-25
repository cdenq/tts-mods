----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Timer")
-- total bank labels 0-2
-- total bank timebanks 3-5
-- control buttons 6-8
-- rest are the other buttons

----------------------
-- Variables
----------------------
buttonConfig = {
    common = {
        baseY = 0.2,
        width = 400,
        height = 175,
        font_size = 70,
        font_color = {0, 0, 0},
        unlight = {0.2, 0.2, 0.2, 0.8}
    },
    totals = {
        baseX = -0.65,
        baseZ = -0.85,
        spacingX = 0.65,
        spacingLabels = 0.25,
        color = "Brown",
        font_color = "White",
        font_size = 90,
        height = 250,
        width = 500,
        scale = {0.5, 0.5, 0.5},
        setup = {
            label = "Pre-Game",
            tooltip = "Total time for pre-game setup (e.g. drafting).",
            bank = 0
        },
        game = {
            label = "Game",
            tooltip = "Total time for active game play.",
            bank = 0
        },
        total = {
            label = "Total",
            tooltip = "Total time spent.",
            bank = 0
        }
    },
    control = {
        baseX = -0.65,
        baseZ = -0.1,
        spacingX = 0.65,
        scale = {0.6, 0.6, 0.6},
        setup = {
            label = "Set Turns",
            clickFunction = "clickSetup",
            color = "Green",
            tooltip = "Add non-spectator players into roster."
        },
        reset = {
            label = "Reset",
            clickFunction = "clickSetup",
            color = "White",
            tooltip = "Reset timebanks and players."
        },
        start = {
            label = "Start",
            clickFunction = "clickStart",
            color = "White",
            tooltip = "Starts the game timer."
        },
        pause = {
            label = "Pause",
            clickFunction = "clickPause",
            color = "Green",
            tooltip = "Pauses the game timer."
        },
        info = {
            label = "Info",
            clickFunction = "clickInfo",
            color = "White",
            tooltip = "Prints starting and incremenetal times in minutes."
        }
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
        color = {1, 1, 1},
        scale = {0.3, 0.3, 0.3}
    },
}
myIterations = {
    totals = {"setup", "game", "total"},
    control = {"setup", "start", "info"}
}
myBookkeepingVariables = {
    numPlayers = 10,
    startingTimeBank = 0,
    addedTime = 0,
    isRunning = false,
    lastUpdateTime = 0,
    gameCoroutine = nil,
    preCoroutine = nil,
    playerOrder = {}, --by color
    activePlayer = 0, --by index
    isSetup = false,
    isFirstStart = false,
    isActivated = false
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
-- onLoad
----------------------
function onLoad()
    createOnLoadButtons()
end

----------------------
-- create button functions
----------------------
function createOnLoadButtons()
    createActiveTimerButton()
end 

function createActiveTimerButton()
    self.createButton({
        click_function = "activateTimer",
        function_owner = self,
        position = {0, buttonConfig.common.baseY, 0},
        width = buttonConfig.totals.width * 1.5,
        height = buttonConfig.totals.height * 1.1,
        scale = buttonConfig.totals.scale,
        color = "Red",
        font_color = "White",
        font_size = buttonConfig.totals.font_size,
        label = "Activate Timer",
        tooltip = "Enable timer for this game."
    })
end

function activateTimer()
    if not myBookkeepingVariables.isActivated then
        delActivateTimerButton()
        initializeAll()
        createAllButtons()
        startPreGame()
        myBookkeepingVariables.isActivated = true
    end
end

function delActivateTimerButton()
    self.removeButton(0)
end

function createAllButtons()
    createTotalButtons()
    createTotalBankButtons()
    createControlButtons()
    createNameButtons()
    createTimeButtons()
    createCounterButtons()
end

function createTotalButtons()
    for i, button in ipairs(myIterations.totals) do
        self.createButton({
            function_owner = self,
            position = {
                x = buttonConfig.totals.baseX + (i-1) * buttonConfig.totals.spacingX, 
                y = buttonConfig.common.baseY, 
                z = buttonConfig.totals.baseZ
            },
            width = buttonConfig.totals.width,
            height = buttonConfig.totals.height,
            scale = buttonConfig.totals.scale,
            font_size = buttonConfig.totals.font_size,
            font_color = buttonConfig.totals.font_color,
            color = buttonConfig.totals.color,
            click_function = "doNothing",
            label = buttonConfig.totals[button].label,
            tooltip = buttonConfig.totals[button].tooltip
        })
    end
end

function createTotalBankButtons()
    for i, button in ipairs(myIterations.totals) do
        self.createButton({
            function_owner = self,
            position = {
                x = buttonConfig.totals.baseX + (i-1) * buttonConfig.totals.spacingX, 
                y = buttonConfig.common.baseY, 
                z = buttonConfig.totals.baseZ + buttonConfig.totals.spacingLabels
            },
            width = buttonConfig.totals.width,
            height = buttonConfig.totals.height,
            scale = buttonConfig.totals.scale,
            font_size = buttonConfig.totals.font_size,
            click_function = "doNothing",
            label = formatTimeHours(buttonConfig.totals[button].bank),
            tooltip = buttonConfig.totals[button].tooltip
        })
    end
end

function createControlButtons()
    for i, button in ipairs(myIterations.control) do
        self.createButton({
            function_owner = self,
            position = {
                x = buttonConfig.control.baseX + (i-1) * buttonConfig.control.spacingX, 
                y = buttonConfig.common.baseY, 
                z = buttonConfig.control.baseZ
            },
            width = buttonConfig.common.width,
            height = buttonConfig.common.height,
            scale = buttonConfig.control.scale,
            font_size = buttonConfig.common.font_size,
            font_color = buttonConfig.common.font_color,
            click_function = buttonConfig.control[button].clickFunction,
            label = buttonConfig.control[button].label,
            tooltip = buttonConfig.control[button].tooltip,
            color = buttonConfig.control[button].color
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
            color = buttonConfig.counter.color,
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
-- pregame/update total bank functions
----------------------
function startPreGame()
    myBookkeepingVariables.lastUpdateTime = Time.time
    myBookkeepingVariables.preCoroutine = Wait.time(updatePreGame, 0.1, -1)
end

function stopPreGame()
    Wait.stop(myBookkeepingVariables.preCoroutine)
    myBookkeepingVariables.preCoroutine = nil
end

function updatePreGame()
    local currentTime = Time.time
    local elapsedTime = currentTime - myBookkeepingVariables.lastUpdateTime
    myBookkeepingVariables.lastUpdateTime = currentTime
    buttonConfig.totals.setup.bank = buttonConfig.totals.setup.bank + elapsedTime
    updateTotalTimeBank()
    updateTotalBanks()
end

function updateTotalTimeBank()
    buttonConfig.totals.total.bank = buttonConfig.totals.setup.bank + buttonConfig.totals.game.bank
end

function updateTotalBanks()
    for i, button in ipairs(myIterations.totals) do
        local bank = buttonConfig.totals[button].bank
        self.editButton({
            index = i + 2,
            label = formatTimeHours(bank)
        })
    end
end
----------------------
-- update main timer functions
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
        index = i + 8,
        label = player,
        color = playerColor
    })
    self.editButton({
        index = i + 8 + myBookkeepingVariables.numPlayers,
        label = timeBank,
        color = playerColor
    })
    self.editButton({
        index = i + 8 + 2*myBookkeepingVariables.numPlayers,
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
            index = i + 8 + myBookkeepingVariables.numPlayers, 
            color = buttonColor
        })
        self.editButton({
            index = i + 8 + 2*myBookkeepingVariables.numPlayers, 
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
    local buttonIndex = (2 * myBookkeepingVariables.numPlayers) + 8 + i
    self.editButton({
        index = buttonIndex,
        label = tostring(myPlayerData[tostring(i)].turnCount)
    })
end

----------------------
-- SETUP/RESET TIMER functions
----------------------
function clickSetup() --also a reset function
    if Turns.enable then
        clickPause()
        resetPlayerData()
        relabelButtons()
        announceNotice()
    else
        broadcastToAll("Enable turns first.")
    end
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

function relabelButtons()
    if not myBookkeepingVariables.isSetup then
        swapButtonReset()
        swapButtonStart()
        myBookkeepingVariables.isSetup = true
    end
end

function swapButtonReset()
    self.editButton({
        index = 6, --setup button
        label = buttonConfig.control["reset"].label,
        tooltip = buttonConfig.control["reset"].tooltip,
        color = buttonConfig.control["reset"].color,
        click_function = buttonConfig.control["reset"].clickFunction
    })
end

----------------------
-- START TIMER functions
----------------------
function clickStart()
    if not myBookkeepingVariables.isSetup then
        doNothing()
    else
        if not myBookkeepingVariables.isRunning then --if isRunning == false
            print("Starting timer!")
            myBookkeepingVariables.isRunning = true
            myBookkeepingVariables.lastUpdateTime = Time.time
            if myBookkeepingVariables.gameCoroutine then
                Wait.stop(myBookkeepingVariables.gameCoroutine)
            end
            myBookkeepingVariables.gameCoroutine = Wait.time(updateTimer, 0.1, -1)
            swapButtonPause()

            if not myBookkeepingVariables.isFirstStart then -- root specific
                shuffleDeck() 
                myBookkeepingVariables.isFirstStart = true
                stopPreGame()
            end
        else --double clicked it
            doNothing()
        end
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

        buttonConfig.totals.game.bank = buttonConfig.totals.game.bank + elapsedTime 
        updateTotalTimeBank()
        updateTotalBanks()
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

function swapButtonPause()
    self.editButton({
        index = 7, --setup button
        label = buttonConfig.control["pause"].label,
        tooltip = buttonConfig.control["pause"].tooltip,
        color = buttonConfig.control["pause"].color,
        click_function = buttonConfig.control["pause"].clickFunction
    })
end

----------------------
-- PAUSE TIMER functions
----------------------
function clickPause()
    if myBookkeepingVariables.isRunning then
        printToAll("Pausing timer.")
        myBookkeepingVariables.isRunning = false
        if myBookkeepingVariables.gameCoroutine then
            Wait.stop(myBookkeepingVariables.gameCoroutine)
            myBookkeepingVariables.gameCoroutine = nil
        end
        swapButtonStart()
    else --double clicked it
        doNothing()
    end
end

function swapButtonStart()
    self.editButton({
        index = 7, --setup button
        label = buttonConfig.control["start"].label,
        tooltip = buttonConfig.control["start"].tooltip,
        color = "Green",
        click_function = buttonConfig.control["start"].clickFunction
    })
end

----------------------
-- INFO functions
----------------------
function clickInfo()
    printToAll("Starting Time: " .. formatTime(myBookkeepingVariables.startingTimeBank) .. ".")
    printToAll("Added Time: " .. formatTime(myBookkeepingVariables.addedTime) .. ".")
end

function announceNotice()
    printToAll("Adding " .. formatTime(myBookkeepingVariables.addedTime) .. " to current/first player's time.")
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
    if myBookkeepingVariables.gameCoroutine then
        Wait.stop(myBookkeepingVariables.gameCoroutine)
        myBookkeepingVariables.gameCoroutine = nil
    end
    if myBookkeepingVariables.preCoroutine then
        Wait.stop(myBookkeepingVariables.preCoroutine)
        myBookkeepingVariables.preCoroutine = nil
    end
end

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

function formatTimeHours(seconds)
    local negative = seconds < 0
    seconds = math.abs(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remainingSeconds = seconds % 60
    local timeString = string.format("%02d:%02d:%04.1f", hours, minutes, remainingSeconds)
    return negative and "-" .. timeString or timeString
end

function round(number, decimals)
    decimals = decimals or 0
    local multiplier = 10 ^ decimals
    return math.floor(number * multiplier + 0.5) / multiplier
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