----------------------
-- Coded for Tofu Worldview
-- By cdenq
----------------------
self.setName("Collections Bowl")

----------------------
-- Variables
----------------------
gmNoteKeywords = {
    "catWarrior",
    "birdWarrior",
    "waWarrior",
    "otterWarrior",
    "lizardWarrior",
    "moleWarrior",
    "crowWarrior",
    "ratWarrior",
    "badgerWarrior",
    "frogWarrior",
    "batWarrior",
    "skunkWarrior"
}
otterFactionBoardGUID = "4a4924"
myBookkeepingVariables = {
    isReturnPiecesActive = true,
    debugMode = false,
    spacing_x = 0.8,
    spacing_z = 0.8,
    currentGridPosition = 0
}

----------------------
-- onload function
----------------------
function onLoad()
    if myBookkeepingVariables.debugMode then broadcastToAll("Bowl debug mode is on.") end
    createToggleButton()
end

----------------------
-- create button functions
----------------------
function createToggleButton()
    self.createButton({
        click_function = "toggleReturnPieces",
        function_owner = self,
        label = "Toggle",
        position = {0, 0, 0.5},
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

----------------------
-- collision function
----------------------
function onCollisionEnter(collision_info)
    if not myBookkeepingVariables.isReturnPiecesActive then return end

    local collidingObj = collision_info.collision_object
    if myBookkeepingVariables.debugMode then 
        print(collidingObj.type) 
        print(collidingObj.getGMNotes() .. ": gm notes.")
    end
    
    parseObj(collidingObj)
end

function parseObj(collidingObj)
    local gmNotes = collidingObj.getGMNotes()
    local matchesKeyword = false
    for i, keyword in ipairs(gmNoteKeywords) do 
        if gmNotes == keyword then 
            matchesKeyword = true 
        end
    end 

    if gmNotes ~= "" and collidingObj.type == "Figurine" and matchesKeyword then
        moveToBoard(collidingObj)
    else 
        doNothing()
    end
end 

----------------------
-- moveTo functions
----------------------
function moveToBoard(collidingObj)
    local tarPos = getObjectFromGUID(otterFactionBoardGUID).getPosition()
    local tarRot = getObjectFromGUID(otterFactionBoardGUID).getRotation()

    local row = math.floor(myBookkeepingVariables.currentGridPosition / 5)
    local col = myBookkeepingVariables.currentGridPosition % 5
    local offset_x = (col - 2) * myBookkeepingVariables.spacing_x
    local offset_z = (row - 1) * myBookkeepingVariables.spacing_z
    
    local newPos
    if math.floor(tarRot.y) == 180 then
        newPos = {
            x = tarPos.x + 0.35 + offset_x,
            y = tarPos.y + 0.88 + 3,
            z = tarPos.z + 3.44 + offset_z
        }
    else
        newPos = {
            x = tarPos.x + 0.35 + offset_x,
            y = tarPos.y + 0.88 + 3,
            z = tarPos.z - 3.44 + offset_z
        }
    end
    
    -- Update grid position for next meeple
    myBookkeepingVariables.currentGridPosition = (myBookkeepingVariables.currentGridPosition + 1) % 15
    
    moveToPlace(collidingObj, newPos, tarRot)

    Wait.time(function()
        myBookkeepingVariables.currentGridPosition = 0
    end, 5)
end

function moveToPlace(collidingObj, tarPos, tarRot)
    moveThing(collidingObj, tarPos, tarRot)
end