----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Hireling Randomizer")

----------------------
-- pre-helper functions
----------------------
function normalizeRGB(rgb)
    return {rgb[1]/255, rgb[2]/255, rgb[3]/255}
end

function getNumPlayers()
    local seated = getSeatedPlayers()
    local n = #seated
    return n
end

----------------------
-- button variables
----------------------
myColors = {
    white = {1, 1, 1},
    gray = {0.5, 0.5, 0.5},
    green = {0, 1, 0},
    red = {1, 0, 0},
    black = {0, 0, 0}
}
globalButtonLift = 0.18
myButtons = {
    settingButtons = {
        startX = -0.65, 
        startZ = -0.775, 
        spacingX = 0.325,
        scale = {0.6, 0.6, 0.6},
        buttonLift = globalButtonLift,
        buttonHeight = 150, 
        buttonWidth = 275, 
        fontSize = 50, 
        defaultColor = myColors.white
    },
    vetoHirelingButtons = {
        startX = -0.55, 
        startZ =  -0.45, 
        spacingX = 0.55,
        spacingZ = 0.225,
        scale = {0.5, 0.5, 0.5},
        buttonLift = globalButtonLift,
        buttonHeight = 225, 
        buttonWidth = 500, 
        fontSize = 55, 
        defaultColor = myColors.white,
        numPerRow = 3
    }
}

----------------------
-- object variables
----------------------
myIterations = {
    settingButtonLabels = {"player", "random", "demote", "aid", "reset"},
    hirelingObjects = {"die", "markers", "4", "8", "12"},
    hirelingZones = {"1", "2", "3"},
    hirelings = {
        "cat", 
        "bird", 
        "wa", 
        "vaga", 
        "otter", 
        "lizard", 
        "crow", 
        "mole", 
        "badger",
        "rat", 
        "stag", 
        "hedge",
        --[["", 
        "", 
        "",]] 
        "stoat"
    }
}
settingButtonLabels = {
    player = {
        label = "Players: ",
        color = myColors.white, 
        tooltip = "Manually set number of players to calculate Hireling demotion.",
        numPlayers = getNumPlayers()
    },
    random = {
        label = "Random",
        color = myColors.green, 
        tooltip = "Randomly draft and setup Hirelings."
    },
    demote = {
        label = "Demote",
        color = myColors.white, 
        tooltip = "Randomly re-demote Hirelings."
    },
    aid = {
        label = "Player Aid",
        color = myColors.white, 
        tooltip = "Bring out the Hireling player aid."
    },
    reset = {
        label = "Reset",
        color = myColors.white, 
        tooltip = "Return all Hirelings."
    }
}
myBookkeepingVariables = {
    availableHirelings = {},
    hirelingCardsInPlay = {}
}
myBagObjs = {
    hirelingBag = getObjectFromGUID("4f6c63")
}
myHirelingZonesAndObjects = {
    ["die"] = {
        position = {31.95, 2.09, -1.59},
        rotation = {0, 0, 0},
        GUID = "e966f8"
    },
    ["markers"] = {
        position = {31.95, 2.09, -3.79},
        rotation = {0, 0, 0}, 
        GUID = "6b612a"
    },
    ["4"] = {
        position = {17.13, 2.08, 21.09},
        rotation = {0, 0, 0},
        GUID = "a17fac"
    },
    ["8"] = {
        position = {10.93, 2.08, 21.09},
        rotation = {0, 0, 0},
        GUID = "e073fd"
    },
    ["12"] = {
        position = {4.72, 2.08, 21.08},
        rotation = {0, 0, 0},
        GUID = "412889"
    },
    ["zone1"] = {
        rotation = {0, 0, 0},
        scale = {9.50, 2.00, 5.90}, 
        centerSpawn = {35.86, 2.09, 3.29},
        supplySpawn = {43.80, 2.09, 3.29}
    },
    ["zone2"] = {
        rotation = {0, 0, 0},
        scale = {9.50, 2.00, 5.90}, 
        centerSpawn = {35.86, 2.09, 9.40}, 
        supplySpawn = {43.80, 2.09, 9.40}
    },
    ["zone3"] = {
        rotation = {0, 0, 0},
        scale = {9.50, 2.00, 5.90}, 
        centerSpawn = {35.86, 2.09, 15.62}, 
        supplySpawn = {43.80, 2.09, 15.62}
    }
}
myHirelings = {
    cat = {
        bagGUID = "3358b9", 
        cardGUID = "9d2ad7", 
        color = normalizeRGB({196,90,29}), 
        buttonLabel = "Forest Patrol\nFeline Physicians", 
        fontColor = myColors.white,
        supplyItems = {
            "8d6980",
            "cfa84e",
            "f3ed86",
            "ca8cd7",
            "f30541",
            "3f7e68",
            "42b906",
            "682116",
            "583c58",
            "1dcaaa",
            "548b49",
            "e0e01b"
        }
    },
    bird = {
        bagGUID = "f3d7bd", 
        cardGUID = "721bea", 
        color = normalizeRGB({66,104,159}), 
        buttonLabel = "Last Dynasty\nBluebird Nobles", 
        fontColor = myColors.white,
        supplyItems = {
            "fa345a",
            "cf4359",
            "0e4f15",
            "f77249",
            "6f4fa9",
        }
    },
    wa = {
        bagGUID = "c0fae2", 
        cardGUID = "3f3088", 
        color = normalizeRGB({87,179,76}), 
        buttonLabel = "Spring Uprising\nRabbit Scouts", 
        fontColor = myColors.white,
        supplyItems = {
            "04655a",
            "be5873",
            "d4f7bc",
            "c4f5d1",
            "0058ec"
        }
    },
    vaga = {
        bagGUID = "646138", 
        cardGUID = "b133e5", 
        color = normalizeRGB({38,39,38}), 
        buttonLabel = "The Exile\nThe Brigand", 
        fontColor = myColors.white,
        supplyItems = {
            "7a4d1c",
            "dc2c80",
            "7c4c3c",
            "bc68b4"
        }
    },
    otter = {
        bagGUID = "4f0e65", 
        cardGUID = "3bb06d", 
        color = normalizeRGB({93,186,172}), 
        buttonLabel = "Riverfolk Flotilla\nOtter Divers", 
        fontColor = myColors.black,
        supplyItems = {
            "052846"
        }
    },
    lizard = {
        bagGUID = "58d00d", 
        cardGUID = "12961f", 
        color = normalizeRGB({250,239,101}), 
        buttonLabel = "Warm Sun Prophets\nLizard Envoys", 
        fontColor = myColors.black,
        supplyItems = {
            "da02a6",
            "def2d2",
            "879fa6",
            "c10538"
        }
    },
    crow = {
        bagGUID = "d4c75a", 
        cardGUID = "38b807", 
        color = normalizeRGB({86,61,139}), 
        buttonLabel = "Corvid Spies\nRaven Sentries", 
        fontColor = myColors.white,
        supplyItems = {
            "5efb5e",
            "2ea151",
            "397a92",
            "5b1016",
            "35d325",
            "fb3123"
        }
    },
    mole = {
        bagGUID = "6dcfef", 
        cardGUID = "5372e1", 
        color = normalizeRGB({237,190,155}), 
        buttonLabel = "Sunward Expedition\nMole Artisans", 
        fontColor = myColors.black,
        supplyItems = {
            "4e0fd2",
            "b316d4",
            "a47e5c",
            "37a3bd",
            "90d8a9",
            "2bd4e0",
            "0bdaad",
            "c93ac2",
            "a5117f",
            "c95940",
            "fa26f0"
        }
    },
    badger = {
        bagGUID = "7dc9e8", 
        cardGUID = "78f355", 
        color = normalizeRGB({195,188,178}), 
        buttonLabel = "Vault Keepers\nBadger Bodyguards", 
        fontColor = myColors.black,
        supplyItems = {
            "b884e7",
            "04b53a",
            "6b266a",
            "1e581d",
            "38b337",
            "031ef9",
            "407266",
            "cdfc78",
            "3fb4de",
            "597026",
            "80b220",
            "fb61b5"
        }
    },
    rat = {
        bagGUID = "7f5ee4", 
        cardGUID = "7915ab", 
        color = normalizeRGB({212,47,59}), 
        buttonLabel = "Flame Bearers\nRat Smugglers", 
        fontColor = myColors.white,
        supplyItems = {
            "f7f35a",
            "5bfc01",
            "55fae9",
            "da7438",
            "771b98",
            "70d521"
        }
    }, 
    stag = {
        bagGUID = "ee8791", 
        cardGUID = "283578", 
        color = normalizeRGB({223,165,52}), 
        buttonLabel = "Furious Protector\nStoic Protector", 
        fontColor = myColors.black,
        supplyItems = {
            "13a694"
        }
    }, 
    hedge = {
        bagGUID = "4a2020", 
        cardGUID = "92eff0", 
        color = normalizeRGB({251,127,150}), 
        buttonLabel = "Highway Bandits\nBandit Gangs", 
        fontColor = myColors.black,
        supplyItems = {
            "d52aab",
            "fdfe64",
            "aa0af8",
            "1ed70a"
        }
    },
    --[[BLANK = {
        bagGUID = "", 
        cardGUID = "", 
        color = normalizeRGB({1,1,1}), 
        buttonLabel = "NAME\nSECOND NAME", 
        fontColor = myColors.white,
        supplyItems = {
            ""
        }
    },
    BLANK = {
        bagGUID = "", 
        cardGUID = "", 
        color = normalizeRGB({1,1,1}), 
        buttonLabel = "NAME\nSECOND NAME", 
        fontColor = myColors.white,
        supplyItems = {
            ""
        }
    },
    BLANK = {
        bagGUID = "", 
        cardGUID = "", 
        color = normalizeRGB({1,1,1}), 
        buttonLabel = "NAME\nSECOND NAME", 
        fontColor = myColors.white,
        supplyItems = {
            ""
        }
    },]]
    stoat = {
        bagGUID = "ccb556", 
        cardGUID = "5b1d86", 
        color = normalizeRGB({185,62,146}), 
        buttonLabel = "Popular Band\nStreet Band", 
        fontColor = myColors.white,
        supplyItems = {
            "f5a3ba",
            "04564e",
            "7a3f6f",
            "cdbfc4",
            "e96f82"
        }
    }
}
----------------------
-- onload function
----------------------
function onLoad()
    resetAvailableHirelings()
    createAllButtons()
    resetPlayerButton()
end

----------------------
-- helper functions
----------------------
function doNothing()
end

function calculateNumDemotes()
    return math.min(settingButtonLabels["player"].numPlayers - 2, 3)
end

function passBannedHirelings()
    if #myIterations.hirelings - settingButtonLabels["player"].numPlayers < #myBookkeepingVariables.availableHirelings then
        broadcastToAll("Make sure to veto same-faction Hirelings!")
        return false 
    else 
        return true
    end
end

function shufflePool(pool)
    for i = #pool, 2, -1 do
        local j = math.random(i)
        pool[i], pool[j] = pool[j], pool[i]
    end
end

----------------------
-- button create functions
----------------------
function createAllButtons()
    createSettingButtons()
    createVetoButtons()
end

function createSettingButtons()
    for i, buttonLabel in ipairs(myIterations.settingButtonLabels) do
        if buttonLabel == "player" then
            goLabel = settingButtonLabels[buttonLabel].label .. settingButtonLabels[buttonLabel].numPlayers
        else 
            goLabel = settingButtonLabels[buttonLabel].label
        end
        self.createButton({
            click_function = "onClickFunction_" .. buttonLabel,
            function_owner = self,
            label = goLabel,
            position = {
                myButtons.settingButtons.startX + (i - 1) * myButtons.settingButtons.spacingX, 
                myButtons.settingButtons.buttonLift, 
                myButtons.settingButtons.startZ
            },
            width = myButtons.settingButtons.buttonWidth,
            height = myButtons.settingButtons.buttonHeight,
            font_size = myButtons.settingButtons.fontSize,
            scale = myButtons.settingButtons.scale,
            color = settingButtonLabels[buttonLabel].color,
            tooltip = settingButtonLabels[buttonLabel].tooltip
        })
    end
end

function createVetoButtons()
    for i, hireling in ipairs(myIterations.hirelings) do
        local row = math.floor((i - 1) / myButtons.vetoHirelingButtons.numPerRow)
        local col = (i - 1) % myButtons.vetoHirelingButtons.numPerRow
        self.createButton({
            click_function = "onClickFunction_" .. hireling,
            function_owner = self,
            label = myHirelings[hireling].buttonLabel,
            position = {
                myButtons.vetoHirelingButtons.startX + col * myButtons.vetoHirelingButtons.spacingX,
                myButtons.vetoHirelingButtons.buttonLift,
                myButtons.vetoHirelingButtons.startZ + row * myButtons.vetoHirelingButtons.spacingZ
            },
            width = myButtons.vetoHirelingButtons.buttonWidth,
            height = myButtons.vetoHirelingButtons.buttonHeight,
            font_size = myButtons.vetoHirelingButtons.fontSize,
            scale = myButtons.vetoHirelingButtons.scale,
            color = myHirelings[hireling].color,
            font_color = myHirelings[hireling].fontColor
        })
    end
end

----------------------
-- helper click functions
----------------------
function fullReset()
    resetAvailableHirelings()
    resetHirelingButtons()
    resetPlayerButton()
    resetRotation()
    returnAllItems()
    Global.call('setHirelingsinPlay', {})
end

function resetAvailableHirelings()
    myBookkeepingVariables.availableHirelings = {}
    for i, value in ipairs(myIterations.hirelings) do 
        table.insert(myBookkeepingVariables.availableHirelings, value)
    end
end

function resetHirelingButtons()
    for i, hireling in ipairs(myIterations.hirelings) do
        self.editButton({
            index = i + 4,
            label = myHirelings[hireling].buttonLabel,
            color = myHirelings[hireling].color,
            font_color = myHirelings[hireling].fontColor
        })
    end
end

function resetPlayerButton()
    settingButtonLabels["player"].numPlayers = math.max(getNumPlayers(), 2)
    updatePlayerButton()
end

function updatePlayerButton()
    self.editButton({
        index = 0,
        label = settingButtonLabels["player"].label .. settingButtonLabels["player"].numPlayers
    })
end

function resetRotation()
    for _, GUID in ipairs(myBookkeepingVariables.hirelingCardsInPlay) do
        local card = getObjectFromGUID(GUID)
        card.setRotation({0, 0, 0})
    end
end

function flipRotation(zoneIndex)
    local card = getObjectFromGUID(myBookkeepingVariables.hirelingCardsInPlay[zoneIndex])
    local cardPosition = card.getRotation()
    card.setRotation({0, 0, cardPosition.z + 180})
end

----------------------
-- main functions
----------------------
function cyclePlayers(obj, color, alt_click)
    if not alt_click then
        settingButtonLabels["player"].numPlayers = math.min(settingButtonLabels["player"].numPlayers + 1, 6)
    else
        settingButtonLabels["player"].numPlayers = math.max(settingButtonLabels["player"].numPlayers - 1, 2)
    end
    updatePlayerButton()
end 

function moveAllItems()
    if passBannedHirelings() then
        returnAllItems()
        moveHirelingObjects()
        moveHirelings()
        randomDemote(calculateNumDemotes())
    end
end

function toggleVeto(i, hireling)
    local found = false
    for j, value in ipairs(myBookkeepingVariables.availableHirelings) do
        if value == hireling then
            goLabel = "x"
            goColor = myColors.red
            goFontColor = myColors.white
            table.remove(myBookkeepingVariables.availableHirelings, j)
            found = true
            break
        end
    end
    if found == false then
        goLabel = myHirelings[hireling].buttonLabel
        goColor = myHirelings[hireling].color
        goFontColor = myHirelings[hireling].fontColor
        table.insert(myBookkeepingVariables.availableHirelings, hireling)
    end
    self.editButton({
        index = i + 4,
        label = goLabel,  
        color = goColor,
        font_color = goFontColor
    })
end

function randomDemote(numDemotes)
    local randomZoneIndex = math.random(1, #myIterations.hirelingZones)
    resetRotation()

    if numDemotes == 0 then
        return
    elseif numDemotes == 1 then
        flipRotation(randomZoneIndex)
    elseif numDemotes == 2 then
        for i = 1, #myIterations.hirelingZones do
            flipRotation(i)
        end
        flipRotation(randomZoneIndex)
    elseif numDemotes == 3 then
        for i = 1, #myIterations.hirelingZones do
            flipRotation(i)
        end
    end
end

----------------------
-- move item functions
----------------------
function returnAllItems()
    -- sub return
    for i, hireling in ipairs(myIterations.hirelings) do

        -- target the right hireling bag
        local selectedBag = myBagObjs.hirelingBag.takeObject({
            guid = myHirelings[hireling].bagGUID,
            position = myBagObjs.hirelingBag.getPosition() + Vector(0, 1, 0)
        })

        -- move the card into that selected bag
        local selectedItem = getObjectFromGUID(myHirelings[hireling].cardGUID)
        if selectedItem then
            selectedItem.setLock(false)
            selectedBag.putObject(selectedItem)
        end

        -- move the meeples into that selected bag
        for j, item in ipairs(myHirelings[hireling].supplyItems) do
            selectedItem = getObjectFromGUID(item)
            if selectedItem then
                selectedBag.putObject(selectedItem)
            end
        end

        -- return the selected bag into the master bag
        myBagObjs.hirelingBag.putObject(selectedBag)

        -- reset the tracker for tracking card GUIDs
        myBookkeepingVariables.hirelingCardsInPlay = {}
    end

    -- obj return
    for _, obj in ipairs(myIterations.hirelingObjects) do
        local selectedObj = getObjectFromGUID(myHirelingZonesAndObjects[obj].GUID)
        if selectedObj then
            myBagObjs.hirelingBag.putObject(selectedObj)
        end
    end
end

function moveHirelingObjects()
    for _, obj in ipairs(myIterations.hirelingObjects) do
        local item = myBagObjs.hirelingBag.takeObject({
            guid = myHirelingZonesAndObjects[obj].GUID,
            position = myHirelingZonesAndObjects[obj].position,
            rotation = myHirelingZonesAndObjects[obj].rotation,
            smooth = false
        })
    end
end

function moveHirelings()
    shufflePool(myBookkeepingVariables.availableHirelings)
    selectedFactions = {}
    for i = 1, 3 do
        if #myBookkeepingVariables.availableHirelings > 0 then
            table.insert(selectedFactions, myBookkeepingVariables.availableHirelings[i])
        end
    end
    Global.call('setHirelingsinPlay', selectedFactions)

    for j, selectedFaction in ipairs(selectedFactions) do
        -- get right hireling bag
        local selectedBag = myBagObjs.hirelingBag.takeObject({
            guid = myHirelings[selectedFaction].bagGUID,
            position = myBagObjs.hirelingBag.getPosition() + Vector(0, 1, 0)
        })

        -- take the card out
        local selectedCard = selectedBag.takeObject({
            guid = myHirelings[selectedFaction].cardGUID,
            position = myHirelingZonesAndObjects["zone" .. j].centerSpawn,
            rotation = myHirelingZonesAndObjects["zone" .. j].rotation,
            smooth = false
        })
        Wait.time(function()
            selectedCard.setLock(true)
        end, 2)
        table.insert(myBookkeepingVariables.hirelingCardsInPlay, myHirelings[selectedFaction].cardGUID)

        -- take all the items out
        local gridSize = math.ceil(math.sqrt(#myHirelings[selectedFaction].supplyItems))
        local spacing = 1.5
        for k, itemGUID in ipairs(myHirelings[selectedFaction].supplyItems) do
            local row = math.floor((k-1) / gridSize)
            local col = (k-1) % gridSize
            local offset = Vector(
                (col - (gridSize-1)/2) * spacing, 
                0.5,
                (row - (gridSize-1)/2) * spacing
            )
            local itemPosition = {
                x = myHirelingZonesAndObjects["zone" .. j].supplySpawn[1] + offset.x,
                y = myHirelingZonesAndObjects["zone" .. j].supplySpawn[2] + offset.y,
                z = myHirelingZonesAndObjects["zone" .. j].supplySpawn[3] + offset.z
            }
            local item = selectedBag.takeObject({
                guid = itemGUID,
                position = itemPosition,
                rotation = {0, 180, 0},
                smooth = false
            })
        end
        myBagObjs.hirelingBag.putObject(selectedBag)
    end
end

----------------------
-- onclick functions
----------------------
function onClickFunction_player(obj, color, alt_click)
    cyclePlayers(obj, color, alt_click)
end

function onClickFunction_random(obj, color, alt_click)
    moveAllItems()
end

function onClickFunction_demote(obj, color, alt_click)
    randomDemote(calculateNumDemotes())
end

function onClickFunction_aid(obj, color, alt_click)
    print("Currently unimplemented.")
end

function onClickFunction_reset(obj, color, alt_click)
    fullReset()
end

for i, hireling in ipairs(myIterations.hirelings) do
    _G["onClickFunction_" .. hireling] = function(obj, color, alt_click)
        toggleVeto(i, hireling)
    end
end

----------------------
-- debug function
----------------------
function printAvailableHirelings()
    print("--------------")
    for i, value in ipairs(myBookkeepingVariables.availableHirelings) do 
        print(i .. " " .. value)
    end
end

function printList(list)
    print("------------")
        for i, guid in ipairs(list) do 
        print(i .. " " .. guid)
    end 
end