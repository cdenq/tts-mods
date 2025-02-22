----------------------
-- Coded for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Supply-Graveyard")

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
    rootCard = { --do not delete, used to sort carads in parseObj()
        dummy = "" 
    },
    warriorCoffin = {
        coffinKeepersGUID = "bf44eb",
        adjustment = {
            x = -0.54,
            y = 1.84 + 2,
            z = 0.26
        }
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
        locationGUID = "b69618",
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
        locationGUID = "919e94",
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
        byGUID = {"4f0e65", "13a694", "7a4d1c"} --otter, stag, exile is pawn
    }
}
myBookkeepingVariables = {
    isReturnPiecesActive = true,
    debugMode = false,
    spacing_x = 0.9,
    spacing_z = 0.9,
    currentGridPosition = 0,
    recentlyProcessed = {}
}

----------------------as
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
    local soulsObj = getObjectFromGUID(movementMappings.cardSouls.lostSoulsGUID)
    local gmNotes = collidingObj.getGMNotes()

    if gmNotes ~= "" or collidingObj.type == "Deck" then
        if collidingObj.type == "Deck" or collidingObj.type == "Card" then
            if soulsObj then
                moveToSouls(collidingObj, soulsObj)
            else
                moveToDiscard(collidingObj)
            end
        elseif gmNotes == "hireling1" or gmNotes == "hireling2" or gmNotes == "hireling3" then
            local isException = false
            for i, guid in ipairs(myIterations.exceptions.byGUID) do
                if collidingObj.getGUID() == guid then
                    isException = true
                    break
                end
            end

            if not isException then
                moveToBoard(collidingObj)
            else
                print("Hireling is a pawn.")
            end
        elseif collidingObj.type == "Figurine" or collidingObj.type == "Tile" or collidingObj.type == "Token" then
            moveToBoard(collidingObj)
        else
            print("Invalid type: " .. collidingObj.type .. ".")
        end
    else 
        doNothing()
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

function moveToBoard(collidingObj)
    local gmNotes = collidingObj.getGMNotes()
    if (collidingObj.type == "Figurine" and gmNotes ~= "ratWarlord" and gmNotes ~= "hireling1" and gmNotes ~= "hireling2" and gmNotes ~= "hireling3") or (gmNotes == "catWood") then
        local tarBag 
        if gmNotes == "lizardWarrior" then
            tarBag = getObjectFromGUID(movementMappings[gmNotes].bagGUID)
        else
            tarBag = getObjectFromGUID(movementMappings[gmNotes].locationGUID)
        end 
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

----------------------
-- moveType functions
----------------------
function moveCard(collidingObj, targetPos, targetRot)
    if collidingObj.type == "Card" then
        moveThing(collidingObj, targetPos, targetRot)
    else 
        local cards = collidingObj.getObjects()
        for i = #cards, 1, -1 do
            local card = collidingObj.takeObject({
                guid = cards[i].guid,
                position = targetPos,
                rotation = targetRot,
                smooth = true
            })
        end
    end
end

function moveIntoBag(collidingObj, targetBag)
    depositThing(collidingObj, targetBag)
end

function moveToPlace(collidingObj, tarPos, tarRot)
    moveThing(collidingObj, tarPos, tarRot)
end