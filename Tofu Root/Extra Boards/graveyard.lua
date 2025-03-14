----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("To Grave")
-- note, all hireling warriors are figurines except
-- bat, frog warriors are tokens
-- all hireling cardboard are tiles

----------------------
-- Variables
----------------------
groups = {
    cat = {
        factionBoardGUID = "52c93d"
    },
    lizard = {
        factionBoardGUID = "e8687a"
    },
    rat = {
        factionBoardGUID = "53059f"
    },
    mole = {
        factionBoardGUID = "919e94"
    },
    wa = {
        factionBoardGUID = "b69618"
    }
}
movementMappings = { -- the keys are the actual GM descriptions
    cardSouls = {
        lostSoulsGUID = "40abac",
        adjustment = {
            x = 0.07,
            y = 0.71 + 2,
            z = -1.85
        }
    },
    cardDiscard = {
        discardZone = "df7de8",
        boardGUID = "5c414a"
    },
    rootCard = { --do not delete, used to sort cards in parseObj()
        dummy = "" 
    },
    warriorCoffin = {
        coffinKeepersGUID = "bf44eb",
        adjustment = {
            x = -0.54,
            y = 1.84 + 4,
            z = 0.26
        }
    },
    mountainPass = {
        position = {-45.12, 1.69, 15.96},
        rotation = {0.00, 90.00, 0.00}
    },
    retainer = {
        position = {-45.15, 1.60, 11.38},
        rotation = {0.00, 90.00, 0.00}
    },
    hireling1 = {
        locationGUID = "bbf692",
        adjustment = {
            x = 1,
            y = 2,
            z = -1.5
        }
    },
    hireling2 = {
        locationGUID = "fe56c8",
        adjustment = {
            x = 1,
            y = 2,
            z = -1.5
        }
    },
    hireling3 = {
        locationGUID = "c16261",
        adjustment = {
            x = 1,
            y = 2,
            z = -1.5
        }
    },
    catWarrior = {
        locationGUID = "ffa850"
    },
    catWood = {
        locationGUID = "dad414"
    },
    catSawmill = {
        locationGUID = groups["cat"].factionBoardGUID,
        adjustment = {
            x = 0,
            y = 2,
            z = 0
        }
    },
    catPiece = {
        locationGUID = groups["cat"].factionBoardGUID,
        adjustment = {
            x = 0,
            y = 2,
            z = 0
        }
    },
    catRecruiter = {
        locationGUID = groups["cat"].factionBoardGUID,
        adjustment = {
            x = 0,
            y = 2,
            z = 0
        }
    },
    birdWarrior = {
        locationGUID = "5752ee",
    },
    birdPiece = {
        locationGUID = "52af3f",
        adjustment = {
            x = 0,
            y = 2,
            z = 5
        }
    },
    waWarrior = {
        locationGUID = "ebc24d",
    },
    waPiece = {
        locationGUID = groups["wa"].factionBoardGUID,
        adjustment = {
            x = -3,
            y = 2,
            z = 3
        }
    },
    waBase = {
        locationGUID = groups["wa"].factionBoardGUID,
        adjustment = {
            x = -3,
            y = 2,
            z = 3
        }
    },
    otterWarrior = {
        locationGUID = "bfe555",
    },
    otterPiece = {
        locationGUID = "386773",
        adjustment = {
            x = -3,
            y = 2,
            z = 3
        }
    },
    lizardWarrior = {
        locationGUID = groups["lizard"].factionBoardGUID,
        bagGUID = "748e2f",
        adjustment = {
            x = 0.2,
            y = 2,
            z = 0.2
        }
    },
    lizardPiece = {
        locationGUID = groups["lizard"].factionBoardGUID,
        adjustment = {
            x = 0,
            y = 2,
            z = 5
        }
    },
    moleWarrior = {
        locationGUID = "39e6dd",
    },
    molePiece = {
        locationGUID = groups["mole"].factionBoardGUID,
        adjustment = {
            x = 3,
            y = 2,
            z = 3
        }
    },
    moleRecruiter = {
        locationGUID = groups["mole"].factionBoardGUID,
        adjustment = {
            x = 3,
            y = 2,
            z = 3
        }
    },
    moleBurrow = {
        locationGUID = "4464b8",
        adjustment = {
            x = 3.5,
            y = 2,
            z = 3.75
        }
    },
    crowWarrior = {
        locationGUID = "141966",
    },
    crowPiece = {
        locationGUID = "b29092",
        adjustment = {
            x = 0.2,
            y = 2,
            z = 0.2
        }
    },
    ratWarrior = {
        locationGUID = "24fc4b"
    },
    ratWarlord = {
        locationGUID = groups["rat"].factionBoardGUID,
        adjustment = {
            x = 0.2,
            y = 2,
            z = 0.2
        }
    },
    ratPiece = {
        locationGUID = groups["rat"].factionBoardGUID,
        adjustment = {
            x = 0.2,
            y = 2,
            z = 0.2
        }
    },
    ratStronghold = {
        locationGUID = groups["rat"].factionBoardGUID,
        adjustment = {
            x = 0.2,
            y = 2,
            z = 0.2
        }
    },
    badgerWarrior = {
        locationGUID = "948279",
    },
    badgerPiece = {
        locationGUID = "f72cd4",
        adjustment = {
            x = -3,
            y = 2,
            z = 3
        }
    }
    --[[
    ,
    frogWarrior = {
        locationGUID = "",
    },
    frogPiece = {
        locationGUID = "",
        adjustment = {
            x = 0,
            y = 2,
            z = 0
        }
    },
    batWarrior = {
        locationGUID = "",
    },
    batPiece = {
        locationGUID = "",
        adjustment = {
            x = 0,
            y = 2,
            z = 0
        }
    },
    skunkWarrior = {
        locationGUID = "",
    },
    skunkPiece = {
        locationGUID = "",
        adjustment = {
            x = 0,
            y = 2,
            z = 0
        }
    }
    ]]--
}
myIterations = {
    exceptions = {
        byKeyword = {"ratWarrior", "lizardWarrior"}, --unused
        byGUID = {"4f0e65", "13a694", "7a4d1c"}, --otter, stag, exile is pawn
    }
}
myBookkeepingVariables = {
    isReturnPiecesActive = true,
    debugMode = false,
    spacing_x = 1.3,
    spacing_z = 0.9,
    currentGridPosition = 0,
    currentGridPositionCoffin = 0,
    recentlyProcessed = {}
}

----------------------
-- onload function
----------------------
function onLoad()
    if myBookkeepingVariables.debugMode then broadcastToAll("Graveyard debug mode is on.") end
    --createToggleButton()
end

----------------------
-- create button functions
----------------------
function createToggleButton()
    self.createButton({
        click_function = "toggleReturnPieces",
        function_owner = self,
        label = "Return Pieces",
        position = {0, 0.5, -0.75},
        rotation = {0, 0, 0},
        width = 500,
        height = 175,
        font_size = 60,
        color = {0, 1, 0},
        tooltip = "Turn on/off."
    })
end

----------------------
-- on click functions
----------------------
function toggleReturnPieces()
    myBookkeepingVariables.isReturnPiecesActive = not myBookkeepingVariables.isReturnPiecesActive
    local buttonColor = myBookkeepingVariables.isReturnPiecesActive and {0, 1, 0} or {1, 0, 0}
    self.editButton({
        index = 0, 
        color = buttonColor
    })
end

----------------------
-- collision function
----------------------
function onCollisionEnter(collision_info)
    if not myBookkeepingVariables.isReturnPiecesActive then return end

    local collidingObj = collision_info.collision_object
    local objGUID = collidingObj.getGUID()
    
    if myBookkeepingVariables.recentlyProcessed[objGUID] then
        return
    end
    
    myBookkeepingVariables.recentlyProcessed[objGUID] = true
    
    Wait.time(function()
        myBookkeepingVariables.recentlyProcessed[objGUID] = nil
    end, 1)
    
    if myBookkeepingVariables.debugMode then 
        print(collidingObj.type) 
        print(collidingObj.getGMNotes() .. ": gm notes.")
    end
    
    parseObj(collidingObj)
end

function parseObj(collidingObj)
    local coffinObj = getObjectFromGUID(movementMappings.warriorCoffin.coffinKeepersGUID)
    local soulsObj = getObjectFromGUID(movementMappings.cardSouls.lostSoulsGUID)
    local gmNotes = collidingObj.getGMNotes()

    if gmNotes ~= "" or collidingObj.type == "Deck" then
        if collidingObj.type == "Deck" then
            parseDeck(collidingObj)
        elseif collidingObj.type == "Card" then
            parseCard(collidingObj)
        elseif (gmNotes == "hireling1" or gmNotes == "hireling2" or gmNotes == "hireling3") then
            local isException = false
            for i, guid in ipairs(myIterations.exceptions.byGUID) do
                if collidingObj.getGUID() == guid then
                    isException = true
                    break
                end
            end

            if not isException then
                if coffinObj and collidingObj.type ~= "Tile" then
                    moveToCoffin(collidingObj, coffinObj)
                else
                    moveToBoard(collidingObj)
                end
            else
                print("Hireling is a pawn.")
            end
        elseif (collidingObj.type == "Figurine" or collidingObj.type == "Tile" or collidingObj.type == "Token") then
            if gmNotes == "mountainPass" then --if mountain pass
                moveToDeckBoard(collidingObj)
            elseif coffinObj then
                moveToCoffin(collidingObj, coffinObj)
            else
                moveToBoard(collidingObj)
            end
        else
            print("Invalid type: " .. collidingObj.type .. ".")
        end
    else 
        doNothing()
    end
end 

function parseDeck(collidingObj)
    local cards = collidingObj.getObjects()
    for key, card in pairs(cards) do
        local cardObj = collidingObj.takeObject({
            index = 0,
            smooth = false
        })
        parseCard(cardObj)
    end
end

function parseCard(card)
    local gmNotes = card.getGMNotes()
    local soulsObj = getObjectFromGUID(movementMappings.cardSouls.lostSoulsGUID)
    if gmNotes == "retainer" then --if badgers card
        moveToDeckBoard(card)
    elseif soulsObj then
        moveToSouls(card, soulsObj)
    else
        moveToDiscard(card)
    end
end

----------------------
-- moveTo functions
----------------------
function moveToSouls(collidingObj, soulsObj)
    local tarPos = soulsObj.getPosition()
    local tarRot = soulsObj.getRotation()
    local newPos = {
        x = tarPos.x + movementMappings.cardSouls.adjustment.x,
        y = tarPos.y + movementMappings.cardSouls.adjustment.y,
        z = tarPos.z + movementMappings.cardSouls.adjustment.z
    }
    moveCard(collidingObj, newPos, tarRot)
end

function moveToDiscard(collidingObj)
    local tarPos = getObjectFromGUID(movementMappings.cardDiscard.discardZone).getPosition()
    local tarRot = getObjectFromGUID(movementMappings.cardDiscard.boardGUID).getRotation()
    moveCard(collidingObj, tarPos, tarRot)
end

function moveToCoffin(collidingObj, coffinObj)
    local gmNotes = collidingObj.getGMNotes()
    if collidingObj.type == "Figurine" and gmNotes ~= "ratWarlord" and gmNotes ~= "lizardWarrior" then
        local coffinPos = coffinObj.getPosition()
        local coffinRot = coffinObj.getRotation()

        local row = math.floor(myBookkeepingVariables.currentGridPositionCoffin / 3)  
        local col = myBookkeepingVariables.currentGridPositionCoffin % 3              
        local offset_x = (col - 1) * myBookkeepingVariables.spacing_x          
        local offset_z = (row - 2) * myBookkeepingVariables.spacing_z         

        local newCoffinPos = {
            x = coffinPos.x + movementMappings.warriorCoffin.adjustment.x + offset_x,
            y = coffinPos.y + movementMappings.warriorCoffin.adjustment.y,
            z = coffinPos.z + movementMappings.warriorCoffin.adjustment.z + offset_z
        }

        myBookkeepingVariables.currentGridPositionCoffin = (myBookkeepingVariables.currentGridPositionCoffin + 1) % 15
        moveToPlace(collidingObj, newCoffinPos, coffinRot)

        Wait.time(function()
            myBookkeepingVariables.currentGridPositionCoffin = 0
        end, 5)
    else
        moveToBoard(collidingObj)
    end
end

function moveToBoard(collidingObj)
    local gmNotes = collidingObj.getGMNotes()
    if (collidingObj.type == "Figurine" and gmNotes ~= "ratWarlord" and gmNotes ~= "lizardWarrior" and gmNotes ~= "hireling1" and gmNotes ~= "hireling2" and gmNotes ~= "hireling3") or (gmNotes == "catWood") then
        local tarBag = getObjectFromGUID(movementMappings[gmNotes].locationGUID)
        moveIntoBag(collidingObj, tarBag)
    else
        local tarPos = getObjectFromGUID(movementMappings[gmNotes].locationGUID).getPosition()
        local tarRot = getObjectFromGUID(movementMappings[gmNotes].locationGUID).getRotation()

        local row = math.floor(myBookkeepingVariables.currentGridPosition / 5)
        local col = myBookkeepingVariables.currentGridPosition % 5
        local offset_x = (col - 2) * myBookkeepingVariables.spacing_x
        local offset_z = (row - 1) * myBookkeepingVariables.spacing_z

        local newPos = {
            x = tarPos.x + movementMappings[gmNotes].adjustment.x + offset_x,
            y = tarPos.y + movementMappings[gmNotes].adjustment.y,
            z = tarPos.z + movementMappings[gmNotes].adjustment.z + offset_z
        }
        local newRot
        if gmNotes == "crowPiece" then
            newRot = {
                x = tarRot.x,
                y = tarRot.y,
                z = 180
            }
        else
            newRot = tarRot
        end
        
        myBookkeepingVariables.currentGridPosition = (myBookkeepingVariables.currentGridPosition + 1) % 15
        moveToPlace(collidingObj, newPos, newRot)

        Wait.time(function()
            myBookkeepingVariables.currentGridPosition = 0
        end, 5)
    end
end

function moveToDeckBoard(targetObj)
    local tarPos = movementMappings[targetObj.getGMNotes()].position
    local tarRot = movementMappings[targetObj.getGMNotes()].rotation
    local newPos = {
        x = tarPos[1],
        y = tarPos[2] + 2,
        z = tarPos[3]
    }
    moveThing(targetObj, newPos, tarRot)
end

----------------------
-- moveType functions
----------------------
function moveCard(collidingObj, targetPos, targetRot)
    moveThing(collidingObj, targetPos, targetRot)
end

function moveIntoBag(collidingObj, targetBag)
    depositThing(collidingObj, targetBag)
end

function moveToPlace(collidingObj, tarPos, tarRot)
    moveThing(collidingObj, tarPos, tarRot)
end

----------------------
-- helper functions
----------------------
function doNothing()
end

function moveThing(targetObj, targetPos, targetRot)
    slowThing(targetObj)
    targetObj.setPositionSmooth(targetPos)
    targetObj.setRotationSmooth(targetRot)
end

function slowThing(targetObj)
    targetObj.setVelocity({
        x = 0, 
        y = 0, 
        z = 0
    })
    targetObj.setAngularVelocity({
        x = 0, 
        y = 0, 
        z = 0
    })
end

function depositThing(targetObj, targetBag)
    targetBag.putObject(targetObj)
end