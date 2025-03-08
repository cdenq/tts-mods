----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Draft Tool")
-- reachButton index 0
-- playerButtons index 1-5
-- factionButtons index 6+
-- finalizeButton index -1

----------------------
-- pre-helper functions
----------------------
function initialPlayerCountSet()
    local seated = getSeatedPlayers()
    local n = #seated
    if n < 2 then 
        n = 2
    elseif n > 6 then
        n = 6
    end
    myBookkeepingVariables.currentPlayerCount = n
    myBookkeepingVariables.reachThreshold = playerReachCounts[tostring(n)]
    myBookkeepingVariables.maxDrafts = n
    myBookkeepingVariables.draftsLeft = n
end

----------------------
-- button variables
----------------------
myColors = {
    white = {1, 1, 1},
    gray = {0.5, 0.5, 0.5},
    green = {0, 1, 0},
    red = {1, 0, 0},
    black = {0, 0, 0},
    whiteShade = {1, 1, 1, 0.65},
    grayShade = {0.5, 0.5, 0.5, 0.75},
    greenShade = {0, 1, 0, 0.85},
    redShade = {1, 0, 0, 0.85}
}
globalButtonLift = 0.18
myButtons = {
    settingButtons = {
        startX = -1.75, 
        startZ = -0.85, 
        spacingX = 0.5833, 
        buttonHeight = 90, 
        buttonWidth = 350,
        buttonLift = globalButtonLift,
        fontSize = 50,
        scale = {0.75, 0.75, 0.75},
        defaultColor = myColors.white
    },
    factionButtons = {
        startX = -1.75, 
        startZ = -0.5, 
        spacingX = 0.5833, 
        spacingZ = 0.3, 
        numCols = 7,
        buttonHeight = 300, 
        buttonWidth = 300,
        buttonLift = globalButtonLift,
        scale = {0.5, 0.5, 0.5},
        fontSize = 45, 
        defaultColor = myColors.whiteShade
    }
}

----------------------
-- object variables
----------------------
myIterations = {
    --, "frog", "bat", "skunk"
    factions = {"cat", "bird", "wa", "vaga", "vaga2", "otter", "lizard", "mole", "crow", "rat", "badger"},
    militantFactions = {"cat", "bird", "mole", "rat", "badger"},
    settingButtonLabels = {"setting", "player", "reach", "finalize", "randomize", "deal", "reset"}
}
--draftVariables
myBookkeepingVariables = {
    currentFormat = "",
    currentPlayerCount = 0,
    reachThreshold = 0,
    reachTally = 0,
    draftsLeft = 0,
    maxDrafts = 0,
    sortedReach = {},
    validDraft = {},
    adSetPool = {},
    adSetPicked = {},
    adSetVagaPool = {},
    adsetGUIDs = {},
    availableMilitants = {}
}
myBagObjs = {
    playerBoardBag = getObjectFromGUID("078548"),
    adsetCardBag = getObjectFromGUID("7528eb"),
    deckZone = getObjectFromGUID("cf89ff")
}
mySettingButtons = {
    setting = {
        color = myColors.white,
        tooltip = "Manually adjust the format.",
        label = "<Setting>"
    }, 
    player = {
        color = myColors.white,
        tooltip = "Manually adjust the number of players in the match.",
        label = "<PlayerCount>"
    }, 
    reach = {
        color = myColors.white,
        tooltip = "Displays the running total reach. Used in Classic setups only.",
        label = "<Reach>"
    }, 
    finalize = {
        color = myColors.green,
        tooltip = "Finalize all selected factions. Used in Classic setups only.",
        label = "Finalize"
    }, 
    randomize = {
        color = myColors.white,
        tooltip = "Randomize the limited faction pool. Used in AdSet setups only.",
        label = "Random Draft"
    }, 
    deal = {
        color = myColors.green,
        tooltip = "Deal the most recently selected faction. Used in AdSet setups only.",
        label = "Deal Faction"
    }, 
    reset = {
        color = myColors.white,
        tooltip = "Reset all pieces and settings.",
        label = "Reset"
    }
}
playerReachCounts = {
   ["2"] = 17,
   ["3"] = 18, 
   ["4"] = 21,
   ["5"] = 25,
   ["6"] = 28
}
factions = {
    ["cat"] = {
        reach = 10,
        full = "Marquise de Cat",
        state = "pickable",
        owner = "",
        playerBoardGUID = "c33191",
        adsetCardGUID = "c8f4ed"
    },
    ["bird"] = {
        reach = 7,
        full = "Eyrie Dynasty",
        state = "pickable",
        owner = "",
        playerBoardGUID = "259983",
        adsetCardGUID = "8df1be"
    },
    ["wa"] = {
        reach = 3,
        full = "Woodland Alliance",
        state = "pickable",
        owner = "",
        playerBoardGUID = "9e5675",
        adsetCardGUID = "c7b1d4"
    },
    ["vaga"] = {
        reach = 5,
        full = "Vagabond",
        state = "pickable",
        owner = "",
        playerBoardGUID = "bb1469",
        adsetCardGUID = "304b65"
    },
    ["vaga2"] = {
        reach = 2,
        full = "Vagabond 2",
        state = "unpickable",
        owner = "",
        playerBoardGUID = "615fc6",
        adsetCardGUID = "ff9804"
    },
    ["otter"] = {
        reach = 5,
        full = "Riverfolk Company",
        state = "pickable",
        owner = "",
        playerBoardGUID = "572d09",
        adsetCardGUID = "201005"
    },
    ["lizard"] = {
        reach = 2,
        full = "Lizard Cult",
        state = "pickable",
        owner = "",
        playerBoardGUID = "d6f37d",
        adsetCardGUID = "bdce9c"
    },
    ["mole"] = {
        reach = 8,
        full = "Underground Duchy",
        state = "pickable",
        owner = "",
        playerBoardGUID = "c6b48f",
        adsetCardGUID = "e8f093"
    },
    ["crow"] = {
        reach = 3,
        full = "Corvid Conspiracy",
        state = "pickable",
        owner = "",
        playerBoardGUID = "b3a6dc",
        adsetCardGUID = "06ace2"
    },
    ["rat"] = {
        reach = 9,
        full = "Lord of the Hundreds",
        state = "pickable",
        owner = "",
        playerBoardGUID = "1093bf",
        adsetCardGUID = "39be49"
    },
    ["badger"] = {
        reach = 8,
        full = "Keepers in Iron",
        state = "pickable",
        owner = "",
        playerBoardGUID = "f1bd2f",
        adsetCardGUID = "ed28df"
    }
   --[[["frog"] = {
       reach = 0,
       full = "Tidepool Diaspora",
       state = "pickable",
       owner = "",
       playerBoardGUID = ""
   },
   ["bat"] = {
       reach = 0,
       full = "Twilight Assembly",
       state = "pickable",
       owner = "",
       playerBoardGUID = ""
   }
   ["skunk"] = {
       reach = 0,
       full = "Knaves of the Deepwood",
       state = "pickable",
       owner = "",
       playerBoardGUID = ""
   }]]
}
vagabondAdsetCardGUIDS = {
    tinker = "78ca46",
    thief = "1c02a2",
    ranger = "3db079",
    vagrant = "a67db3",
    scoundrel = "f69c98",
    arbiter = "c33cb1",
    adventurer = "8548a4",
    harrier = "afbc63",
    ronin = "946238"
}
orderedFactionsByReach = {
    ["cat"] = 10,
    ["rat"] = 9,
    ["badger"] = 8,
    ["mole"] = 8,
    ["bird"] = 7,
    ["vaga"] = 5,
    ["otter"] = 5,
    ["wa"] = 3, 
    ["crow"] = 3,
    ["vaga2"] = 2,
    ["lizard"] = 2
}
spawns = {
   ["red"] = {
       position = {55.00, 1.6, 60.00},
       rotation = {0.00, 180.00, 0.00}
   },
   ["purple"] = {
       position = {-5.00, 1.6, 60.00},
       rotation = {0.00, 180.00, 0.00}
   },
   ["white"] = {
       position = {-65.00, 1.6, 60.00},
       rotation = {0.00, 180.00, 0.00}
   },
   ["blue"] = {
       position = {-65.00, 1.6, -60.00},
       rotation = {0.00, 0.00, 0.00}
   },
   ["green"] = {
       position = {-5.00, 1.6, -60.00},
       rotation = {0.00, 0.00, 0.00}
   },
   ["yellow"] = {
       position = {55.00, 1.6, -60.00},
       rotation = {0.00, 0.00, 0.00}
   }
}
adsetSpawns = {
    start = {98.52, 3, -15.08},
    increment = {0, 0, 5.78}
}

----------------------
-- onload and once functions
----------------------
function onLoad()
    initialPlayerCountSet()
    checkValidFactions()
    createAllButtons()
end

----------------------
-- helper functions
----------------------
function doNothing()
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createSettingButtons()
    setFormatButtons()
end

function createSettingButtons() --sets the format
    for i, name in ipairs(myIterations.settingButtonLabels) do
        if name == "setting" then
            checkSetting = Global.getVar("GLOBALSETTING")
            if checkSetting == "ModAdSet" or checkSetting == "AdSet" then
                myBookkeepingVariables.currentFormat = "AdSet"
            else
                myBookkeepingVariables.currentFormat = "Classic"
            end
            goLabel = myBookkeepingVariables.currentFormat
        elseif name == "player" then
            goLabel = myBookkeepingVariables.currentPlayerCount
        elseif name == "reach" then
            goLabel = myBookkeepingVariables.reachTally .. "/" .. myBookkeepingVariables.reachThreshold .. " (" .. myBookkeepingVariables.draftsLeft .. " picks)"
        else
            goLabel = mySettingButtons[name].label
        end

        self.createButton({
            click_function = "onSettingClick_" .. name,
            function_owner = self,
            position = {
                myButtons.settingButtons.startX + ((i - 1) * myButtons.settingButtons.spacingX), 
                myButtons.settingButtons.buttonLift, 
                myButtons.settingButtons.startZ
            },
            height = myButtons.settingButtons.buttonHeight,
            width = myButtons.settingButtons.buttonWidth,
            scale = myButtons.settingButtons.scale,
            font_size = myButtons.settingButtons.fontSize,
            color = mySettingButtons[name].color,
            label = goLabel,
            tooltip = mySettingButtons[name].tooltip
        })
    end
end

function setFormatButtons()
    draftReset()
    
    if myBookkeepingVariables.currentFormat == "Classic" then
        classicButtonEnable()
    else
        deleteFactionButtons()
        adSetButtonEnable()
    end
end

function createFactionButtons()
    for i, faction in ipairs(myIterations.factions) do
        local row = math.floor((i-1) / myButtons.factionButtons.numCols)
        local col = (i-1) % myButtons.factionButtons.numCols        
        local posX = myButtons.factionButtons.startX + (col * myButtons.factionButtons.spacingX)
        local posZ = myButtons.factionButtons.startZ + (row * myButtons.factionButtons.spacingZ)
        local buttonColor = myButtons.factionButtons.defaultColor

        if factions[faction].state ~= "unpickable" then
            if factions[faction].state == "picked" then
                buttonColor = myColors.greenShade
            elseif factions[faction].state == "pickable" then
                buttonColor = myColors.whiteShade
            elseif factions[faction].state == "banned" then
                buttonColor = myColors.redShade
            end
            self.createButton({
                click_function = "onFactionClick_" .. faction,
                function_owner = self,
                position = {
                    posX, 
                    myButtons.factionButtons.buttonLift,
                    posZ
                },
                height = myButtons.factionButtons.buttonHeight,
                width = myButtons.factionButtons.buttonWidth,
                font_size = myButtons.factionButtons.fontSize,
                scale = myButtons.factionButtons.scale, 
                color = buttonColor,
                label = factions[faction].owner,
                tooltip = factions[faction].full
            })
        end
    end
end

function refreshFactionButtons()
    deleteFactionButtons()
    createFactionButtons()
end

function deleteFactionButtons()
    local buttonsToRemove = {}
    for i, button in ipairs(self.getButtons()) do
        if string.match(button.click_function, "^onFactionClick_") then
            table.insert(buttonsToRemove, i)
        end
    end
    for i = #buttonsToRemove, 1, -1 do
        self.removeButton(buttonsToRemove[i] - 1)
    end
end

----------------------
-- onclick button functions
----------------------
function onSettingClick_setting(obj, color, alt_click)
    cycleSetting(obj, color, alt_click)
end

function onSettingClick_player(obj, color, alt_click)
    cyclePlayerCount(obj, color, alt_click)
end

function onSettingClick_reach(obj, color, alt_click)
    doNothing()
end

function onSettingClick_finalize(obj, color, alt_click)
    dealClassic()
    dealPlayerBoards()
    finalized()
end

function onSettingClick_randomize(obj, color, alt_click)
    randomizeAdset()
end

function onSettingClick_deal(obj, color, alt_click)
    dealAdsetFaction()
end

function onSettingClick_reset(obj, color, alt_click)
    draftReset()
end

for i, faction in ipairs(myIterations.factions) do
    _G["onFactionClick_" .. faction] = function(obj, color, alt_click)
        onFactionClick(faction, color)
    end
end

----------------------
-- setting & reset functions
----------------------
function cycleSetting(obj, color, alt_click)
    if myBookkeepingVariables.currentFormat == "AdSet" then
        myBookkeepingVariables.currentFormat = "Classic"
    else 
        myBookkeepingVariables.currentFormat = "AdSet"
    end

    self.editButton({
        index = 0,
        label = myBookkeepingVariables.currentFormat
    })

    setFormatButtons()
end

function adSetButtonEnable()
    self.editButton({ --reach button
        click_function = "doNothing",
        index = 2,
        color = myColors.gray,
        label = "-",
        tooltip = ""
    })
    self.editButton({ --finalize
        click_function = "doNothing",
        index = 3,
        color = myColors.gray,
        label = "-",
        tooltip = ""
    })
    self.editButton({ --randomize
        click_function = "onSettingClick_randomize",
        index = 4,
        color = mySettingButtons["randomize"].color,
        label = mySettingButtons["randomize"].label,
        tooltip = mySettingButtons["randomize"].tooltip
    })
    self.editButton({ --deal faction
        click_function = "onSettingClick_deal",
        index = 5,
        color = mySettingButtons["deal"].color,
        label = mySettingButtons["deal"].label,
        tooltip = mySettingButtons["deal"].tooltip
    })
end

function classicButtonEnable()
    self.editButton({ --reach button
        click_function = "onSettingClick_reach",
        index = 2,
        color = mySettingButtons["reach"].color,
        label = myBookkeepingVariables.reachTally .. "/" .. myBookkeepingVariables.reachThreshold .. "\n(" .. myBookkeepingVariables.draftsLeft .. " pick(s) left)",
        tooltip = mySettingButtons["reach"].tooltip
    })
    updateReachButton()
    self.editButton({ --finalize
        click_function = "onSettingClick_finalize",
        index = 3,
        color = mySettingButtons["finalize"].color,
        label = mySettingButtons["finalize"].label,
        tooltip = mySettingButtons["finalize"].tooltip
    })
    self.editButton({ --randomize
        click_function = "doNothing",
        index = 4,
        color = myColors.gray,
        label = "-",
        tooltip = ""
    })
    self.editButton({ --deal faction
        click_function = "doNothing",
        index = 5,
        color = myColors.gray,
        label = "-",
        tooltip = ""
    })
end

function draftReset()
    deleteFactionButtons()
    updateDraftMax()
    updateSettings()
    resetAdsetPool()
    resetDraftedAdset()
end
----------------------
-- player & reach functions
----------------------
function cyclePlayerCount(obj, color, alt_click)
    local oldCount = myBookkeepingVariables.currentPlayerCount
    if not alt_click then
        myBookkeepingVariables.currentPlayerCount = math.min(myBookkeepingVariables.currentPlayerCount + 1, 6)
    else
        myBookkeepingVariables.currentPlayerCount = math.max(myBookkeepingVariables.currentPlayerCount - 1, 2)
    end

    if oldCount == myBookkeepingVariables.currentPlayerCount then
        doNothing()
    else
        updateDraftMax()
        updatePlayerCountButton()
        updateSettings()
    end
end

function updateDraftMax()
    myBookkeepingVariables.reachThreshold = playerReachCounts[tostring(myBookkeepingVariables.currentPlayerCount)]
    myBookkeepingVariables.maxDrafts = myBookkeepingVariables.currentPlayerCount
    myBookkeepingVariables.draftsLeft = myBookkeepingVariables.currentPlayerCount
end

function updatePlayerCountButton()
    self.editButton({
        index = 1,
        label = myBookkeepingVariables.currentPlayerCount
    })
end

function updateSettings()
    if myBookkeepingVariables.currentFormat == "Classic" then
        hardResetFactions()
        updateReachButton()
        checkValidFactions()
        refreshFactionButtons()
    else 
        hardResetFactions()
    end
end

function updateReachButton()
    local buttonColor = myColors.white
    local goLabel = ""

    if myBookkeepingVariables.draftsLeft == 0 then
        goLabel = myBookkeepingVariables.reachTally .. "/" .. myBookkeepingVariables.reachThreshold
        if myBookkeepingVariables.reachTally < myBookkeepingVariables.reachThreshold then
            buttonColor = myColors.red
        else
            buttonColor = myColors.green
        closeRemainingFactions()
        end
    else
        goLabel = myBookkeepingVariables.reachTally .. "/" .. myBookkeepingVariables.reachThreshold .. "\n(" .. myBookkeepingVariables.draftsLeft .. " pick(s) left)"
        if myBookkeepingVariables.reachTally >= myBookkeepingVariables.reachThreshold then
            buttonColor = myColors.green
        else
            buttonColor = myColors.white
        end
    end

    self.editButton({
        index = 2,
        color = buttonColor,
        label = goLabel
    })
end

----------------------
-- faction functions
----------------------
function onFactionClick(faction, color)
    if faction == "vaga2" then 
        broadcastToAll("Remember to have the vagabond players sit together! (Re-click factions if seats changed.)")
    end
    cycleFactionState(faction, color)
    if myBookkeepingVariables.currentFormat == "Classic" then
        updateReachTally(faction)
        updateDraftLeft()
        checkValidFactions()
        vagabondExtraForce()
        updateReachButton()
    else
        doNothing()
    end
    refreshFactionButtons()
end

function cycleFactionState(faction, color)
    if factions[faction].state == "pickable" then
        factions[faction].state = "picked"
        factions[faction].owner = Player[color].steam_name
    elseif factions[faction].state == "picked" then
        factions[faction].state = "banned"
        factions[faction].owner = "x"  
    elseif factions[faction].state == "banned" then
        factions[faction].state = "pickable"
        factions[faction].owner = ""
    end
end

function updateReachTally(faction)
    if factions[faction].state == "picked" then
        myBookkeepingVariables.reachTally = myBookkeepingVariables.reachTally + factions[faction].reach
    elseif factions[faction].state == "banned" then
        myBookkeepingVariables.reachTally = myBookkeepingVariables.reachTally - factions[faction].reach 
    end
end

function updateDraftLeft()
    local pickedCount = 0
    for i, faction in ipairs(myIterations.factions) do
        if factions[faction].state == "picked" then
            pickedCount = pickedCount + 1
        end
    end
    myBookkeepingVariables.draftsLeft = myBookkeepingVariables.maxDrafts - pickedCount
end

function checkValidFactions()
    validDraft = {}
    softResetFactions()
    vagabondExtraForce()
    for i, faction in ipairs(myIterations.factions) do
        if factions[faction].state == "pickable" then
            if (myBookkeepingVariables.reachTally + getMaxPossibleReach(myBookkeepingVariables.draftsLeft - 1) + factions[faction].reach >= myBookkeepingVariables.reachThreshold) then
                table.insert(validDraft, {label = faction, reach = factions[faction].reach})
            else
                factions[faction].state = "unpickable"
            end
        end
    end     
end

function softResetFactions()
    for i, faction in ipairs(myIterations.factions) do
        if factions[faction].state == "unpickable" then
            factions[faction].state = "pickable"
        end
    end
end

function getMaxPossibleReach(draftsLeft)
    local tempSortedReach = {}
    local sum = 0
    if draftsLeft <= 0 then
        return sum
    else
        for i, faction in ipairs(myIterations.factions) do
            if factions[faction].state == "pickable" then
                table.insert(tempSortedReach, {label = faction, reach = factions[faction].reach})
            end
        end
        table.sort(tempSortedReach, function(a, b) return a.reach > b.reach end)
        for i = 1, math.min(draftsLeft, #tempSortedReach) do
            sum = sum + tempSortedReach[i].reach
        end
        return sum
    end
end

function vagabondExtraForce()
    if factions["vaga"].state ~= "picked" then
        factions["vaga2"].state = "unpickable"
        factions["vaga2"].owner = ""
    end
end

function closeRemainingFactions()
    for i, faction in ipairs(myIterations.factions) do
        if factions[faction].state == "pickable" then
            factions[faction].state = "unpickable"
        end
    end
end

function hardResetFactions()
    for i, faction in ipairs(myIterations.factions) do
        factions[faction].state = "pickable"
        factions[faction].owner = ""
    end
    myBookkeepingVariables.reachTally = 0
end

----------------------
-- finalize functions
----------------------
function dealPlayerBoards()
    local ruinCount = 0
    for factionKey, faction in pairs(factions) do
        local playerColor = nil
        local playerName = nil
        
        if faction.owner ~= "" and faction.owner ~= "x" then
            if factionKey == "rat" or factionKey == "vaga" then
                ruinCount = ruinCount + 1
            elseif factionKey == "vaga2" then
                ruinCount = ruinCount + 1
            end

            for _, player in ipairs(Player.getPlayers()) do
                if player.steam_name == faction.owner then
                    playerColor = player.color
                    playerName = player.steam_name
                    break
                end
            end

            if playerColor then
                local selectedBoard = myBagObjs.playerBoardBag.takeObject({
                    guid = faction.playerBoardGUID,
                    position = spawns[string.lower(playerColor)].position,
                    rotation = spawns[string.lower(playerColor)].rotation,
                    smooth = true
                })
                selectedBoard.setLock(true)
                Wait.time(function()
                    selectedBoard.call("click_place")
                end, 2.5)
                printToAll(playerName .. " drafts " .. faction.full .. ".", playerColor)
            end
        end
    end
    broadcastToAll("Set " .. ruinCount .. " ruins in game.")
end

function dealClassic()
    local deck = nil
    if myBagObjs and myBagObjs.deckZone then
        local objects = myBagObjs.deckZone.getObjects()
        if objects then
            for _, obj in ipairs(objects) do
                if obj and obj.tag == "Deck" then
                    deck = obj
                    break
                end
            end
        else 
            print("No objects in deckzone.")
        end
    end

    local turnOrder = Turns.order
    if not turnOrder or #turnOrder == 0 then
        Turns.enable = true
        Turns.type = 2
        Turns.order = players
        turnOrder = Turns.order
    end

    if not turnOrder or #turnOrder == 0 then
        turnOrder = players
    end

    if deck then
        for i, playerColor in ipairs(turnOrder) do
            local cardsToDeal = i + 2
            deck.dealToColor(cardsToDeal, playerColor)
        end
    end
end

function finalized()
    self.editButton({
        index = 3,
        click_function = "doNothing",
        color = myColors.gray,
        label = "Finalized"
    })
end

----------------------
-- adset functions
----------------------
function randomizeAdset()
    if myBookkeepingVariables.currentPlayerCount > 2 then
        hardResetFactions()
        deleteFactionButtons()
        resetAdsetPool()
        draftMilitant()
        draftRest()
        moveDraftedAdset()
        adSetSelectFactions()
        lockLastFaction()
    else
        hardResetFactions()
        deleteFactionButtons()
        resetAdsetPool()
        draftMilitant()
        moveDraftedAdset()
        adSetSelectFactions()
    end
end

function resetAdsetPool()
    myBookkeepingVariables.adSetPool = {}
    myBookkeepingVariables.adSetPicked = {}
    myBookkeepingVariables.adSetVagaPool = {}

    local tempPool = {table.unpack(myIterations.factions)}
    local invalidHirelings = Global.getVar("HIRELINGSINPLAY")

    local indicesToRemove = {}
    for i = #tempPool, 1, -1 do
        for _, hireling in ipairs(invalidHirelings) do
            if hireling == "vaga" then
                if tempPool[i] == "vaga" or tempPool[i] == "vaga2" then
                    table.insert(indicesToRemove, i)
                end
            elseif tempPool[i] == hireling then
                table.insert(indicesToRemove, i)
            end
        end
    end
    
    for _, index in ipairs(indicesToRemove) do
        table.remove(tempPool, index)
    end
    
    myBookkeepingVariables.adSetPool = tempPool
    local tempVagaPool = {}
    for key, _ in pairs(vagabondAdsetCardGUIDS) do
        table.insert(tempVagaPool, key)
    end
    myBookkeepingVariables.adSetVagaPool = tempVagaPool
end

function draftMilitant()
    myBookkeepingVariables.availableMilitants = {}
    for _, faction in ipairs(myBookkeepingVariables.adSetPool) do
        for _, militant in ipairs(myIterations.militantFactions) do
            if faction == militant then
                table.insert(myBookkeepingVariables.availableMilitants, faction)
                break
            end
        end
    end

    local draftCount
    if myBookkeepingVariables.currentPlayerCount == 2 then
        draftCount = 3
    else
        draftCount = 1
    end

    for _ = 1, draftCount do
        draftSingleMilitant()
    end
end

function draftSingleMilitant()
    local randomIndex = math.random(#myBookkeepingVariables.availableMilitants)
    local selectedFaction = myBookkeepingVariables.availableMilitants[randomIndex]

    for i = #myBookkeepingVariables.adSetPool, 1, -1 do
        if myBookkeepingVariables.adSetPool[i] == selectedFaction then
            table.remove(myBookkeepingVariables.adSetPool, i)
            break
        end
    end
    table.remove(myBookkeepingVariables.availableMilitants, randomIndex)
    table.insert(myBookkeepingVariables.adSetPicked, selectedFaction)
end

function draftRest()
    local remainingPicks = myBookkeepingVariables.currentPlayerCount
    
    while remainingPicks > 0 do
        local randomIndex = math.random(#myBookkeepingVariables.adSetPool)
        local selectedFaction = myBookkeepingVariables.adSetPool[randomIndex]
        
        -- Check vagabond special cases
        if selectedFaction == "vaga2" then
            local vagaInPicked = false
            for _, faction in ipairs(myBookkeepingVariables.adSetPicked) do
                if faction == "vaga" then
                    vagaInPicked = true
                    break
                end
            end
            
            -- Skip this pick if vaga isn't picked yet
            if not vagaInPicked then
                goto continue
            end
        end
        
        table.remove(myBookkeepingVariables.adSetPool, randomIndex)
        table.insert(myBookkeepingVariables.adSetPicked, selectedFaction)
        
        remainingPicks = remainingPicks - 1
        
        ::continue::
    end
end

function resetDraftedAdset()
    if myBookkeepingVariables.adsetGUIDs then
        for _, guid in ipairs(myBookkeepingVariables.adsetGUIDs) do
            local obj = getObjectFromGUID(guid)
            if obj then
                myBagObjs.adsetCardBag.putObject(obj)
            end
        end
        myBookkeepingVariables.adsetGUIDs = {}
    end
end

function moveDraftedAdset()
    resetDraftedAdset()
    
    for i, faction in ipairs(myBookkeepingVariables.adSetPicked) do
        local position = {
            x = adsetSpawns.start[1] - (adsetSpawns.increment[1] * (i-1)),
            y = adsetSpawns.start[2] - (adsetSpawns.increment[2] * (i-1)),
            z = adsetSpawns.start[3] - (adsetSpawns.increment[3] * (i-1))
        }
        local factionCard = myBagObjs.adsetCardBag.takeObject({
            guid = factions[faction].adsetCardGUID,
            position = position,
            smooth = true
        })
        table.insert(myBookkeepingVariables.adsetGUIDs, factionCard.getGUID())
        
        -- Handle vagabond special case
        if faction == "vaga" or faction == "vaga2" then
            local randomIndex = math.random(#myBookkeepingVariables.adSetVagaPool)
            local selectedVaga = myBookkeepingVariables.adSetVagaPool[randomIndex]
            table.remove(myBookkeepingVariables.adSetVagaPool, randomIndex)
            
            local vagaPosition = {
                x = position.x,
                y = position.y - 0.5,
                z = position.z
            }
            
            local vagaCard = myBagObjs.adsetCardBag.takeObject({
                guid = vagabondAdsetCardGUIDS[selectedVaga],
                position = vagaPosition,
                smooth = true
            })
            table.insert(myBookkeepingVariables.adsetGUIDs, vagaCard.getGUID())
        end
    end
end

function adSetSelectFactions()
    for _, faction in ipairs(myIterations.factions) do
        factions[faction].state = "unpickable"
        factions[faction].owner = ""
    end
    
    for _, faction in ipairs(myBookkeepingVariables.adSetPicked) do
        factions[faction].state = "pickable"
    end
    
    refreshFactionButtons()
end

function lockLastFaction()
    local militantCount = 0
    
    for _, faction in ipairs(myBookkeepingVariables.adSetPicked) do
        for _, militant in ipairs(myIterations.militantFactions) do
            if faction == militant then
                militantCount = militantCount + 1
                break
            end
        end
    end
    
    if militantCount == 1 then
        local lastNonMilitantIndex = #myBookkeepingVariables.adSetPicked
        local lastNonMilitantFaction = myBookkeepingVariables.adSetPicked[lastNonMilitantIndex]
        if lastNonMilitantFaction and lastNonMilitantIndex then
            local card = getObjectFromGUID(factions[lastNonMilitantFaction].adsetCardGUID)
            if card then
                local currentRotation = card.getRotation()
                card.setRotationSmooth({
                    x = currentRotation.x,
                    y = currentRotation.y + 90,
                    z = currentRotation.z
                })
            end
            if factions[lastNonMilitantFaction].state == "pickable" then
                factions[lastNonMilitantFaction].state = "banned"
                factions[lastNonMilitantFaction].owner = ""
            end
        end
        refreshFactionButtons()
    end
end

function unlockLastFaction(recentlyPickedFaction)
    local isMilitant = false
    for _, militant in ipairs(myIterations.militantFactions) do
        if recentlyPickedFaction == militant then
            isMilitant = true
            break
        end
    end

    if isMilitant then
        for _, faction in ipairs(myBookkeepingVariables.adSetPicked) do
            if factions[faction].state == "banned" then
                factions[faction].state = "pickable"
                factions[faction].owner = ""
                
                local card = getObjectFromGUID(factions[faction].adsetCardGUID)
                if card then
                    card.setRotationSmooth({x = 0, y = 270, z = 0})
                end
                
                printToAll(factions[faction].full .. " can now be picked.")
                refreshFactionButtons()
                break
            end
        end
    else
        doNothing()
    end
end

function dealAdsetFaction()
    for factionKey, faction in pairs(factions) do
        local playerColor = nil
        local playerName = nil
        
        if faction.owner ~= "" and faction.owner ~= "x" then
            for _, player in ipairs(Player.getPlayers()) do
                if player.steam_name == faction.owner then
                    playerColor = player.color
                    playerName = player.steam_name
                    break
                end
            end

            if playerColor then
                local boardExists = false
                for _, obj in ipairs(myBagObjs.playerBoardBag.getObjects()) do
                    if obj.guid == faction.playerBoardGUID then
                        boardExists = true
                        break
                    end
                end

                if boardExists then
                    local selectedBoard = myBagObjs.playerBoardBag.takeObject({
                        guid = faction.playerBoardGUID,
                        position = spawns[string.lower(playerColor)].position,
                        rotation = spawns[string.lower(playerColor)].rotation,
                        smooth = true
                    })
                    selectedBoard.setLock(true)
                    Wait.time(function()
                        selectedBoard.call("click_place")
                    end, 2.5)
                    if factionKey == "rat" or factionKey == "vaga" or factionKey == "vaga2" then
                        broadcastToAll("Adjust ruins settings, if needed.")
                    end
                    unlockLastFaction(factionKey)
                    printToAll(playerName .. " drafts " .. faction.full .. ".", playerColor)
                end
            end
        end
    end
end

----------------------
-- debug functions
----------------------
function printFactions()
    for factionKey, factionData in pairs(factions) do
        print(factionKey .. ": " .. factionData.full)
        print(factionData.state .. "(" .. factionData.owner .. ")")
        print("-")
    end
    print("---------")
end

function printAdsets()
    local poolString = "Pool: "
    local pickedString = "Picked: "
    
    -- Print adSetPool
    for i, faction in ipairs(myBookkeepingVariables.adSetPool) do
        if i == 1 then
            poolString = poolString .. faction
        else
            poolString = poolString .. ", " .. faction
        end
    end
    
    -- Print adSetPicked
    for i, faction in ipairs(myBookkeepingVariables.adSetPicked) do
        if i == 1 then
            pickedString = pickedString .. faction
        else
            pickedString = pickedString .. ", " .. faction
        end
    end
    
    print(poolString)
    print(pickedString)
end