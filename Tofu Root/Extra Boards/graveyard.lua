----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Comprehensive Return")
-- set returnMode to value to determine type of return

----------------------
-- Variables
----------------------
myBookkeepingVariables = {
    isReturnPiecesActive = true,
    returnMode = "0", --"0" to grave, "1" to supply, "2" to coffin
    debugMode = false,
    spacing_x = 1.3,
    spacing_z = 0.9,
    currentGridPosition = 0,
    currentGridPositionCoffin = 0,
    recentlyProcessed = {}
}
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
movementMappings = { -- the keys are the actual tags/GM descriptions
    cardSouls = {
        lostSoulsGUID = "40abac",
        adjustment = {
            x = 0.07,
            y = 0.71 + 2,
            z = -1.85
        }
    },
    cardPond = {
        pondGUID = "51070d",
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
    warriorCoffin = {
        coffinKeepersGUID = "bf44eb",
        adjustment = {
            x = -0.54,
            y = 1.84 + 4,
            z = 0.26
        }
    },
    Cat = {
        locationGUID = "ffa850"
    },
    Wood = {
        locationGUID = "dad414"
    },
    Sawmill = {
        locationGUID = groups["cat"].factionBoardGUID,
        adjustment = {
            x = 0,
            y = 2,
            z = 0
        }
    },
    Workshop = {
        locationGUID = groups["cat"].factionBoardGUID,
        adjustment = {
            x = 0,
            y = 2,
            z = 0
        }
    },
    Recruiter = {
        locationGUID = groups["cat"].factionBoardGUID,
        adjustment = {
            x = 0,
            y = 2,
            z = 0
        }
    },
    Bird = {
        locationGUID = "5752ee",
    },
    Roost = {
        locationGUID = "52af3f",
        adjustment = {
            x = 0,
            y = 2,
            z = 5
        }
    },
    WA = {
        locationGUID = "ebc24d",
    },
    Sympathy = {
        locationGUID = groups["wa"].factionBoardGUID,
        adjustment = {
            x = -3,
            y = 2,
            z = 3
        }
    },
    Base = {
        locationGUID = groups["wa"].factionBoardGUID,
        adjustment = {
            x = -3,
            y = 2,
            z = 3
        }
    },
    Otter = {
        locationGUID = "bfe555",
    },
    ["Trade Post"] = {
        locationGUID = "386773",
        adjustment = {
            x = -3,
            y = 2,
            z = 3
        }
    },
    Lizard = {
        locationGUID = groups["lizard"].factionBoardGUID,
        bagGUID = "748e2f",
        adjustment = {
            x = 0.2,
            y = 2,
            z = 0.2
        }
    },
    Garden = {
        locationGUID = groups["lizard"].factionBoardGUID,
        adjustment = {
            x = 0,
            y = 2,
            z = 5
        }
    },
    Mole = {
        locationGUID = "39e6dd",
    },
    Market = {
        locationGUID = groups["mole"].factionBoardGUID,
        adjustment = {
            x = 3,
            y = 2,
            z = 3
        }
    },
    Citadel = {
        locationGUID = groups["mole"].factionBoardGUID,
        adjustment = {
            x = 3,
            y = 2,
            z = 3
        }
    },
    Tunnel = {
        locationGUID = "4464b8",
        adjustment = {
            x = 3.5,
            y = 2,
            z = 3.75
        }
    },
    Crow = {
        locationGUID = "141966",
    },
    Plot = {
        locationGUID = "b29092",
        adjustment = {
            x = 0.2,
            y = 2,
            z = 0.2
        }
    },
    Rat = {
        locationGUID = "24fc4b"
    },
    Warlord = {
        locationGUID = groups["rat"].factionBoardGUID,
        adjustment = {
            x = 0.2,
            y = 2,
            z = 0.2
        }
    },
    Mob = {
        locationGUID = groups["rat"].factionBoardGUID,
        adjustment = {
            x = 0.2,
            y = 2,
            z = 0.2
        }
    },
    Stronghold = {
        locationGUID = groups["rat"].factionBoardGUID,
        adjustment = {
            x = 0.2,
            y = 2,
            z = 0.2
        }
    },
    Badger = {
        locationGUID = "948279",
    },
    Waystation = {
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
        byKeyword = {"lizardWarrior"}, --unused
        byGUID = {"4f0e65", "13a694", "7a4d1c"}, --otter, stag, exile is pawn
    }
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
    
    -- Buffer timer
    if myBookkeepingVariables.recentlyProcessed[objGUID] then
        return
    else
        myBookkeepingVariables.recentlyProcessed[objGUID] = true
        Wait.time(function()
            myBookkeepingVariables.recentlyProcessed[objGUID] = nil
        end, 1)
    end
    
    parseObj(collidingObj)
end

----------------------
-- main parse function
----------------------
function parseObj(collidingObj)
    -- Debug
    local objTags = collidingObj.getTags()
    if myBookkeepingVariables.debugMode then
        local gmNotes = collidingObj.getGMNotes()
        local descNotes = collidingObj.getDescription()
        print("Type: " .. collidingObj.type)
        print("Desc: " .. descNotes)
        print("GMNotes: " .. gmNotes)
        print("Tags:")
        for i, tag in ipairs(objTags) do
            print("   " .. tag)
        end
        print("--")
    end

    -- Main
    if collidingObj.type == "Deck" then
        parseDeck(collidingObj)
    elseif collidingObj.type == "Card" then
        parseCard(collidingObj)
    elseif collidingObj.type == "Figurine" then
        parseFigurine(collidingObj)
    elseif collidingObj.type == "Tile" then 
        parseTile(collidingObj)
    else
        if myBookkeepingVariables.debugMode then
            print("Object type: " .. collidingObj.type .. " doesn't have handling.")
        end
    end
end

----------------------
-- parse functions
----------------------
function parseDeck(deck)
    local cards = deck.getObjects()
    for key, card in pairs(cards) do
        local cardObj = deck.takeObject({
            index = 0,
            smooth = false
        })
        parseCard(cardObj)
    end
end

function parseCard(card)
    local objTags = card.getTags()
    if checkHasTag("Root Card", objTags) then
        local soulsObj = getObjectFromGUID(movementMappings.cardSouls.lostSoulsGUID)
        local pondObj = getObjectFromGUID(movementMappings.cardPond.pondGUID)
        local gmNotes = card.getGMNotes()
        local name = card.getName()
        
        if name == "Faithful Retainer" then
            moveToDeckBoard(card)
        elseif gmNotes == "Frog" then
            moveToPond(card, pondObj)
        elseif soulsObj then
            moveToSouls(card, soulsObj)
        else
            moveToDiscard(card)
        end
    else
        print("Card is not tagged as a Root card.")
    end
end

function parseFigurine(figurine)
    local coffinObj = getObjectFromGUID(movementMappings.warriorCoffin.coffinKeepersGUID)
    local gmNotes = figurine.getGMNotes()
    local objTags = figurine.getTags()

    if checkHasTag("Pawn", objTags) then
        printToAll("This piece is a pawn and cannot be removed.")
    elseif checkHasTag("Warrior", objTags) then
        if myBookkeepingVariables.returnMode == "1" then --forced supply
            moveToSupply(figurine)
        elseif myBookkeepingVariables.returnMode == "2" then --forced coffin
            if coffinObj then
                moveToCoffin(figurine)
            else
                printToAll("Coffin Makers is not in play; returning to supply instead.")
                moveToSupply(figurine)
            end
        else --to grave
            if checkHasTag("Acolyte", objTags) then
                moveToBoard(figurine)
            elseif coffinObj then
                moveToCoffin(figurine)
            else 
                moveToSupply(figurine)
            end
        end
    else
        print("This figurine has no handling!")
    end
end

function parseTile(tile)
    local objTags = tile.getTags()
    if checkHasTag("Mountain Path Marker", objTags) then --if mountain pass
        moveToDeckBoard(tile)
    elseif checkHasTag("Token", objTags) or checkHasTag("Building", objTags) then
        if tile.getName() == "Wood" then
            moveToSupply(tile)
        else
            moveToBoard(tile)
        end
    else
        print("This tile has no handling!")
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

function moveToPond(collidingObj, pondObj)
    local tarPos = pondObj.getPosition()
    local tarRot = pondObj.getRotation()
    local newPos = {
        x = tarPos.x + movementMappings.cardPond.adjustment.x,
        y = tarPos.y + movementMappings.cardPond.adjustment.y,
        z = tarPos.z + movementMappings.cardPond.adjustment.z
    }
    moveCard(collidingObj, newPos, tarRot)
end

function moveToDeckBoard(targetObj)
    if targetObj.getName() == "Faithful Retainer" then
        tarIdentifier = "retainer" --key in the movement mapping
    elseif targetObj.getName() == "Closed Path Marker" then
        tarIdentifier = "mountainPass"
    else
        tarIdentifier = targetObj.getGMNotes()
    end 

    local tarPos = movementMappings[tarIdentifier].position
    local tarRot = movementMappings[tarIdentifier].rotation
    local newPos = {
        x = tarPos[1],
        y = tarPos[2] + 2,
        z = tarPos[3]
    }
    moveThing(targetObj, newPos, tarRot)
end

function moveToDiscard(collidingObj)
    local tarPos = getObjectFromGUID(movementMappings.cardDiscard.discardZone).getPosition()
    local tarRot = getObjectFromGUID(movementMappings.cardDiscard.boardGUID).getRotation()
    moveCard(collidingObj, tarPos, tarRot)
end

function moveToCoffin(collidingObj)
    local coffinObj = getObjectFromGUID(movementMappings.warriorCoffin.coffinKeepersGUID)
    local objTags = collidingObj.getTags()
    if checkHasTag("Warlord", objTags) then
        moveToBoard(collidingObj)
    else
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
    end
end

function moveToSupply(collidingObj)
    local objTags = collidingObj.getTags()
    if checkHasTag("Hireling", objTags) or checkHasTag("Warlord", objTags) or checkHasTag("Captain", objTags) then
        moveToBoard(collidingObj)
    else
        -- otherwise its just normal warrior or is cat wood
        local key = collidingObj.getName()
        local tarBag = getObjectFromGUID(movementMappings[key].locationGUID)
        moveIntoBag(collidingObj, tarBag)
    end
end

function moveToBoard(collidingObj)
    local objTags = collidingObj.getTags()
    local objName = collidingObj.getName()

    if objName == "Relic" then
        printToAll("Place the removed relic in a forest.")
    else
        if checkHasTag("Hireling", objTags) then
            objName = collidingObj.getGMNotes() --uses GMNotes for movement mapping
        end
        
        local tarPos = getObjectFromGUID(movementMappings[objName].locationGUID).getPosition()
        local tarRot = getObjectFromGUID(movementMappings[objName].locationGUID).getRotation()

        local row = math.floor(myBookkeepingVariables.currentGridPosition / 5)
        local col = myBookkeepingVariables.currentGridPosition % 5
        local offset_x = (col - 2) * myBookkeepingVariables.spacing_x
        local offset_z = (row - 1) * myBookkeepingVariables.spacing_z

        local newPos = {
            x = tarPos.x + movementMappings[objName].adjustment.x + offset_x,
            y = tarPos.y + movementMappings[objName].adjustment.y,
            z = tarPos.z + movementMappings[objName].adjustment.z + offset_z
        }
        local newRot

        if objName == "Plot" then
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

function checkHasTag(targetTag, tagList)
    for _, tag in ipairs(tagList) do
        if tag == targetTag then
            return true
        end
    end
    return false
end