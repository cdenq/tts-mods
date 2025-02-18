----------------------
-- Created for Tofu Worldview
-- By cdenq
-- Modified to include decimal seconds and 2x5 layout
----------------------
self.setName("Tofu Timer")
-- control buttons 0-2
-- player name buttons 3, 4 ... numPlayers+2
-- player time buttons numPlayers+3 ... (2*numPlayers)+2
-- counter buttons (2*numPlayers)+3 ... (3*numPlayers)+2

----------------------
-- Variables
----------------------
buttonLiftHeight = 0.25
buttonConfig = {
    common = {
        width = 300,
        height = 175,
        font_size = 70,
        color = {1, 1, 1},
        font_color = {0, 0, 0},
        unlight = {0.5, 0.5, 0.5}
    },
    control = {
        y = buttonLiftHeight,
        z = -0.8,
        start = {label = "Start", x = -0.65, click_function = "startTimer"},
        pause = {label = "Pause", x = 0, click_function = "pauseTimer"},
        reset = {label = "Reset", x = 0.65, click_function = "resetTimer"},
        scale = {0.9, 0.9, 0.9}
    },
    player = {
        y = buttonLiftHeight,
        z = 0.25,
        baseX = -0.8,
        spacing_x = 0.4,
        spacing_z = 0.45,
        spacing_player = 0.15,
        scale = {0.6, 0.6, 0.6}
    },
    name = {
        y = buttonLiftHeight,
        width = 600,
        height = 300,
        z = -0.1,
        font_size = 75,
        scale = {0.3, 0.3, 0.3}
    },
    counter = {
        y = buttonLiftHeight,
        width = 200,
        height = 200,
        z = 0.3,
        spacing_counter = 0.15,
        font_size = 75,
        scale = {0.3, 0.3, 0.3}
    },
}
startingTimeBank = 0
addedTime = 0
playerTimers = {}
playerOrder = {}
playerTurnCounts = {}
activePlayer = 1
isRunning = false
lastUpdateTime = 0
numPlayers = 10
lastTurnColor = nil
turnJustChanged = false
timerCoroutine = nil
deckZone = "cf89ff"

----------------------
-- onLoad
----------------------
function onLoad()
    setTimes()
    createButtons()
    lastTurnColor = Turns.turn_color
    initializeTurnCounts()
end

----------------------
-- create button functions
----------------------
function createButtons()
    createControlButtons()
    createPlayerNameButtons()
    createPlayerTimeButtons()
    createCounterButtons()
end 

function createControlButtons()
    for _, btnType in ipairs({"start", "pause", "reset"}) do
        local btn = buttonConfig.control[btnType]
        self.createButton({
            click_function = btn.click_function,
            function_owner = self,
            label = btn.label,
            position = {btn.x, buttonConfig.control.y, buttonConfig.control.z},
            width = buttonConfig.common.width,
            height = buttonConfig.common.height,
            font_size = buttonConfig.common.font_size,
            color = buttonConfig.common.color,
            scale = buttonConfig.control.scale,
            font_color = buttonConfig.common.font_color,
        })
    end
end

function createPlayerNameButtons()
    for i = 1, numPlayers do
        local row = math.ceil(i / 5)
        local col = (i - 1) % 5 + 1 
        local x = buttonConfig.player.baseX + (col - 1) * buttonConfig.player.spacing_x
        local z = buttonConfig.player.z + (row - 1) * buttonConfig.player.spacing_z
        
        self.createButton({
            click_function = "playerNameButton_" .. i,
            function_owner = self,
            label = "Player " .. i,
            position = {x, buttonConfig.name.y, z},
            width = buttonConfig.name.width,
            height = buttonConfig.name.height / 2,
            font_size = buttonConfig.name.font_size,
            color = {0.8, 0.8, 0.8},
            scale = buttonConfig.name.scale,
            font_color = buttonConfig.common.font_color,
        })
    end
end

function createPlayerTimeButtons()
    for i = 1, numPlayers do
        local row = math.ceil(i / 5) 
        local col = (i - 1) % 5 + 1
        local x = buttonConfig.player.baseX + (col - 1) * buttonConfig.player.spacing_x
        local z = buttonConfig.player.z + (row - 1) * buttonConfig.player.spacing_z + buttonConfig.player.spacing_player

        self.createButton({
            click_function = "playerTimerButton_" .. i,
            function_owner = self,
            label = formatTime(startingTimeBank),
            position = {x, buttonConfig.player.y, z},
            width = buttonConfig.common.width,
            height = buttonConfig.common.height,
            font_size = buttonConfig.common.font_size,
            color = buttonConfig.common.color,
            font_color = buttonConfig.common.font_color,
            scale = buttonConfig.player.scale
        })
    end
end

function createCounterButtons()
    for i = 1, numPlayers do
        local row = math.ceil(i / 5) 
        local col = (i - 1) % 5 + 1
        local x = buttonConfig.player.baseX + (col - 1) * buttonConfig.player.spacing_x
        local z = buttonConfig.counter.z + (row - 1) * buttonConfig.player.spacing_z - buttonConfig.counter.spacing_counter

        self.createButton({
            click_function = "playerTimerButton_" .. i,
            function_owner = self,
            label = "0",
            position = {x, buttonConfig.counter.y, z},
            width = buttonConfig.counter.width,
            height = buttonConfig.counter.height,
            font_size = buttonConfig.counter.font_size,
            scale = buttonConfig.counter.scale
        })
    end
end

----------------------
-- helper functions
----------------------
function doNothing()
end

function getPlayerIndexByColor(color)
    for i, player in ipairs(playerOrder) do
        if player.color == color then
            return i
        end
    end
    return nil
end

function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%02d:%04.1f", minutes, remainingSeconds)
end

function setTimes()
    local description = self.getDescription()
    if description then
        local timeBank, addTime = description:match("(%d+)[%s,]*(%d*)")
        if timeBank then
            startingTimeBank = tonumber(timeBank)
            if addTime and addTime ~= "" then
                addedTime = tonumber(addTime)
            end
        end
    end
    
    if type(startingTimeBank) ~= "number" or startingTimeBank < 0 then
        startingTimeBank = 900
    end
    if type(addedTime) ~= "number" or addedTime < 0 then
        addedTime = 300
    end
end

function cycleTurnCount(obj, color, alt_click)
    local index = tonumber(obj.getVar("click_function"):match("counterButton_(%d+)"))
    if not alt_click then
        playerTurnCounts[index] = playerTurnCounts[index] + 1
    else
        playerTurnCounts[index] = math.max(0, playerTurnCounts[index] - 1)
    end
    updateCounterButton(index)
end

----------------------
-- timer functions
----------------------
function resetTimer()
    isRunning = false
    if timerCoroutine then
        Wait.stop(timerCoroutine)
        timerCoroutine = nil
    end
    requeryPlayerOrder()
    resetTimeBanks()
    initializeTurnCounts() -- Reset turn counts
    updatePlayerButtons()
    updateAllCounterButtons() -- Update all counter displays
    
    requeryActivePlayer()
    updateActivePlayerHighlight()
end

function updateAllCounterButtons()
    for i = 1, numPlayers do
        updateCounterButton(i)
    end
end

function startTimer()
    if not isRunning then
        isRunning = true
        lastUpdateTime = Time.time
        if timerCoroutine then
            Wait.stop(timerCoroutine)
        end
        timerCoroutine = Wait.time(updateTimer, 0.1, -1)
        
        local zoneObjects = getObjectFromGUID(deckZone).getObjects()
        for _, obj in ipairs(zoneObjects) do
            if obj.type == "Deck" then
                obj.shuffle()
                break
            end
        end
    end
end

function pauseTimer()
    isRunning = false
    if timerCoroutine then
        Wait.stop(timerCoroutine)
        timerCoroutine = nil
    end
end

function updateTimer()
    if isRunning then
        local currentTime = Time.time
        local elapsedTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        playerTimers[activePlayer] = playerTimers[activePlayer] - elapsedTime
        if playerTimers[activePlayer] <= 0 then
            playerTimers[activePlayer] = 0
            pauseTimer()
        end

        updatePlayerButtons()
        updateActivePlayerHighlight()
    end
end

function onUpdate()
    if Turns.turn_color ~= lastTurnColor then
        turnJustChanged = true
        lastTurnColor = Turns.turn_color
    end
    
    if turnJustChanged and isRunning then
        handleTurnChange()
    end
end

function handleTurnChange()
    pauseTimer()
    requeryActivePlayer()
    playerTimers[activePlayer] = playerTimers[activePlayer] + addedTime
    updatePlayerButtons()
    updateActivePlayerHighlight()
    startTimer()
    turnJustChanged = false
end

----------------------
-- helper time functions
----------------------
function requeryPlayerOrder()
    playerOrder = {}
    for _, color in ipairs(Turns.order) do
        local steam_name
        if Player[color] and Player[color].steam_name then
            steam_name = Player[color].steam_name
            table.insert(playerOrder, {color = color, steam_name = steam_name})
        end
    end
end

function resetTimeBanks()
    playerTimers = {}
    for i = 1, #playerOrder do
        playerTimers[i] = startingTimeBank
    end
end

function updatePlayerButtons()
    for i = 1, numPlayers do 
        updatePlayerButton(i)
    end
end 

function updatePlayerButton(index)
    local player, labelName, color, timeLabel, timeColor
    if index <= #playerOrder then
        player = playerOrder[index]
        labelName = player.steam_name
        color = stringColorToRGB(player.color)
        timeLabel = formatTime(playerTimers[index])
    else 
        labelName = "Unseated"
        color = buttonConfig.common.unlight
        timeLabel = "-"
    end
    self.editButton({
        index = index + 2,
        label = labelName,
        color = color
    })
    self.editButton({
        index = index + 2 + numPlayers,
        label = timeLabel,
        color = color
    })
end

function requeryActivePlayer()
    local currentPlayer = Turns.turn_color
    for index, player in ipairs(playerOrder) do
        if player.color == currentPlayer then
            activePlayer = index
            return
        end
    end
end

function updateActivePlayerHighlight() 
    for index, player in ipairs(playerOrder) do
        local buttonColor
        if index == activePlayer then
            buttonColor = stringColorToRGB(player.color)
        else
            buttonColor = buttonConfig.common.unlight
        end
        self.editButton({
            index = index + 2 + numPlayers, 
            color = buttonColor
        })
    end
end

----------------------
-- onclick functions
----------------------
for i = 1, numPlayers do
    _G["playerTimerButton_" .. i] = function(obj, color, alt_click) 
        doNothing()
    end
end

for i = 1, numPlayers do
    _G["playerNameButton_" .. i] = function(obj, color, alt_click) 
        doNothing()
    end
end

for i = 1, numPlayers do
    _G["counterButton_" .. i] = function(obj, color, alt_click) 
        cycleTurnCount(obj, color, alt_click)
    end
end

----------------------
-- debugging functions
----------------------
function printPlayerOrder()
    for i, value in ipairs(playerOrder) do 
        print(i .. " " .. value.color .. " " .. value.steam_name)
    end
end

----------------------
-- Turn counting functions
----------------------
function initializeTurnCounts()
    playerTurnCounts = {}
    for i = 1, numPlayers do
        playerTurnCounts[i] = 0
    end
end

function onPlayerTurn(player, previous_player)
    if previous_player then
        local prevPlayerIndex = getPlayerIndexByColor(previous_player)
        if prevPlayerIndex then
            playerTurnCounts[prevPlayerIndex] = playerTurnCounts[prevPlayerIndex] + 1
            updateCounterButton(prevPlayerIndex)
        end
    end
end

function updateCounterButton(index)
    if index <= #playerOrder then
        local buttonIndex = (2 * numPlayers) + 2 + index
        self.editButton({
            index = buttonIndex,
            label = tostring(playerTurnCounts[index])
        })
    end
end