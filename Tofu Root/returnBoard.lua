----------------------
-- Coded for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Graveyard")

----------------------
-- Variables
----------------------
bagGUIDs = {
    catWarrior = "ffa850",
    birdWarrior = "5752ee",
    waWarrior = "ebc24d",
    otterWarrior = "bfe555",
    lizardWarrior = "748e2f",
    moleWarrior = "39e6dd",
    crowWarrior = "141966",
    badgerWarrior = "948279",
    ratWarrior = "24fc4b",
    catWood = "dad414"
}
factionBoardGUIDs = {
    catBoard = "52c93d",
    birdBoard = "52af3f",
    waBoard = "b69618",
    otterBoard = "386773",
    lizardBoard = "e8687a",
    moleBoard = "919e94",
    moleBoardTwo = "4464b8",
    crowBoard = "b29092",
    badgerBoard = "f72cd4",
    ratBoard = "53059f"
}
isReturnPiecesActive = true

----------------------
-- onload function
----------------------
function onLoad()
    --createToggleButton()
end

----------------------
-- create button functions
----------------------
function createToggleButton()
    self.createButton({
        click_function = "toggleReturnPieces",
        function_owner = self,
        label          = "Return Pieces",
        position       = {0, 0.5, -0.75},
        rotation       = {0, 0, 0},
        width          = 500,
        height         = 175,
        font_size      = 60,
        color          = {0, 1, 0},
        tooltip        = "Turn on/off."
    })
end

----------------------
-- on click functions
----------------------
function toggleReturnPieces()
    isReturnPiecesActive = not isReturnPiecesActive
    local buttonColor = isReturnPiecesActive and {0, 1, 0} or {1, 0, 0}
    self.editButton({index = 0, color = buttonColor})
end

----------------------
-- helper functions
----------------------
function getBag(key)
    local bagGUID = bagGUIDs[key]
    if bagGUID then
        return getObjectFromGUID(bagGUID)
    end
    return nil
end

function movePieceToPosition(pieceObj, newPos, targetObj)
    pieceObj.setPosition(newPos)
    pieceObj.setVelocity({x=0, y=0, z=0})
    pieceObj.setAngularVelocity({x=0, y=0, z=0})
    local targetRotation = targetObj.getRotation()
    pieceObj.setRotation({x=0, y=targetRotation.y, z=0})
end

----------------------
-- main collison & special case collison function
----------------------
function onCollisionEnter(collision_info)
    if not isReturnPiecesActive then return end

    local collidingObj = collision_info.collision_object
    local gmNotes = collidingObj.getGMNotes()

    if gmNotes ~= "" then
        if gmNotes == "lizardWarrior" then
            handleWarrior(collidingObj, factionBoardGUIDs.lizardBoard, {x = 0.2, z = 0.2})
        elseif gmNotes == "lizardPiece" then
            handleWarrior(collidingObj, factionBoardGUIDs.lizardBoard, {x = 0, z = 5})
        elseif gmNotes == "ratWarlord" then
            handleWarrior(collidingObj, factionBoardGUIDs.ratBoard, {x = 0.2, z = 0.2})
        elseif gmNotes == "ratPiece" or gmNotes == "ratStronghold" then
            handleWarrior(collidingObj, factionBoardGUIDs.ratBoard, {x = 3.5, z = 3.75})
        elseif gmNotes == "catSawmill" or gmNotes == "catPiece" then
            handleWarrior(collidingObj, factionBoardGUIDs.catBoard, {x = 0, z = 5})
        elseif gmNotes == "birdPiece" then
            handleWarrior(collidingObj, factionBoardGUIDs.birdBoard, {x = 0, z = 5})
        elseif gmNotes == "waPiece" then
            handleWarrior(collidingObj, factionBoardGUIDs.waBoard, {x = -3, z = 3})
        elseif gmNotes == "molePiece" then
            handleWarrior(collidingObj, factionBoardGUIDs.moleBoard, {x = 3, z = 3})
        elseif gmNotes == "moleBurrow" then
            handleWarrior(collidingObj, factionBoardGUIDs.moleBoardTwo, {x = 3.5, z = 3.75})
        elseif gmNotes == "otterPiece" then
            handleWarrior(collidingObj, factionBoardGUIDs.otterBoard, {x = -3.5, z = 3.75})
        elseif gmNotes == "crowPiece" then
            handleWarrior(collidingObj, factionBoardGUIDs.crowBoard, {x = 0.2, z = 0.2})
        elseif gmNotes == "badgerPiece" then
            handleWarrior(collidingObj, factionBoardGUIDs.badgerBoard, {x = -3, z = 3})
        else
            local bag = getBag(gmNotes)
            if bag then
                -- Check if the object is already being handled
                if not collidingObj.getVar("isBeingHandled") then
                    collidingObj.setVar("isBeingHandled", true)
                    bag.putObject(collidingObj)
                end
            end
        end
    end
end

function handleWarrior(warriorObj, boardGUID, newPos)
    local targetObj = getObjectFromGUID(boardGUID)
    if targetObj then
        local targetPos = targetObj.getPosition()
        local yOffset = 1

        local gridSize = 4
        local spacing = 1
        local startX = targetPos.x + newPos.x - (gridSize - 1) * spacing / 2
        local startZ = targetPos.z + newPos.z - (gridSize - 1) * spacing / 2

        for row = 0, gridSize - 1 do
            for col = 0, gridSize - 1 do
                local checkPos = {
                    x = startX + col * spacing,
                    y = targetPos.y + yOffset,
                    z = startZ + row * spacing
                }

                local hit = Physics.cast({
                    origin = checkPos,
                    direction = {0, 1, 0},
                    type = 3,
                    size = {0.5, 0.5, 0.5},
                    max_distance = 0,
                })

                if #hit == 0 then
                    movePieceToPosition(warriorObj, checkPos, targetObj)
                    return
                end
            end
        end

        movePieceToPosition(warriorObj, {
            x = targetPos.x + newPos.x,
            y = targetPos.y + yOffset,
            z = targetPos.z + newPos.z
        }, targetObj)
    end
end