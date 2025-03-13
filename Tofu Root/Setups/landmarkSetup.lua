----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Landmark Drafter Tool")
-- buttonIndex 0-4 = settingButtons
-- buttonIndex 5+ = vetoLandmarkButtons

----------------------
-- button variables
----------------------
myColors = {
    white = {1, 1, 1},
    gray = {0.5, 0.5, 0.5},
    green = {0, 1, 0},
    red = {1, 0, 0}
}
globalButtonLift = 0.18
myButtons = {
    settingButtons = {
        startX = -0.635, 
        startZ = -0.76, 
        spacingX = 0.32,
        scale = {0.65, 0.65, 0.65},
        buttonHeight = 100, 
        buttonWidth = 250,
        buttonLift = globalButtonLift,
        fontSize = 40,
        defaultColor = myColors.white
    },
    vetoLandmarkButtons = {
        startX = -0.6, 
        startZ = 0.445, 
        spacingX = 0.4, 
        spacingZ = 0.175,
        scale = {0.65, 0.65, 0.65},
        buttonHeight = 80, 
        buttonWidth = 300,
        buttonLift = globalButtonLift,
        fontSize = 40, 
        defaultColor = myColors.white,
        numPerRow = 4
    },
    confirmButtons = {
        startX = -0.53, 
        startZ = 0.15, 
        spacingX = 0.53,
        scale = {0.65, 0.65, 0.65},
        buttonHeight = 80, 
        buttonWidth = 300,
        buttonLift = globalButtonLift,
        fontSize = 40, 
        defaultColor = myColors.white
    }
}

----------------------
-- object variables
----------------------
myIterations = {
    settingButtonLabels = {"select", "random", "confirm", "aid" , "reset"},
    landmarks = {"city", "tree", "market", "forge", "ferry", "tower", "mouse", "rabbit", "fox"}
}
myBagObjs = {
    landmarksBag = getObjectFromGUID("7dfe70")
}
settingButtons = {
    select = {
        label = "Select:",
        color = myColors.white, 
        tooltip = "Manually adjust the number of landmarks in play.",
        numLandmarks = Global.getVar("GLOBALNUMLANDMARKS")
    },
    random = {
        label = "Show\nDraft",
        color = myColors.white, 
        tooltip = "Randomize and draft Landmarks based on vetos."
    },
    confirm = {
        label = "Confirm",
        color = myColors.green, 
        tooltip = "Confirm your Landmark pick."
    },
    aid = {
        label = "Player Aid",
        color = myColors.gray, 
        tooltip = "Brings out the Landmark player aid."
    },
    reset = {
        label = "Reset",
        color = myColors.white, 
        tooltip = "Reset all vetos and return all Landmarks back to the bag."
    }
}
vetoButtons = {
    city = {
        label = "Lost City",
        cardGUID = "e64d9d",
        markerGUID = "6fdc85",
        state = "pickable",
        extraGUID = "4347ab"
    },
    tree = {
        label = "Elder\nTreetop",
        cardGUID = "4cc77f",
        markerGUID = "d998e3",
        state = "pickable"
    }, 
    market = {
        label = "Black\nMarket",
        cardGUID = "6db3b3",
        markerGUID = "f825e6",
        state = "pickable"
    }, 
    forge = {
        label = "Legendary\nForge",
        cardGUID = "b64d24",
        markerGUID = "254abc",
        state = "pickable"
    }, 
    ferry = {
        label = "The Ferry",
        cardGUID = "7fccee",
        markerGUID = "939f2d",
        state = "pickable"
    }, 
    mouse = {
        label = "Mousehold",
        cardGUID = "",
        markerGUID = "2f3fc7",
        state = "pickable"
    }, 
    rabbit = {
        label = "Rabbit-town",
        cardGUID = "",
        markerGUID = "0f3076",
        state = "pickable"
    }, 
    fox = {
        label = "Foxburrow",
        cardGUID = "",
        markerGUID = "93a8db",
        state = "pickable"
    },
    tower = {
        label = "The Tower\n(The Spire)",
        cardGUID = "662417",
        markerGUID = "74ecde",
        state = "pickable"
    }
}
myPlacementPositions = {
    cardRotation = {0.00, 270.00, 180.00},
    startingRelativeCardPosition = {x = 3.2, y = 0.11, z = 6.1},
    startingRelativeMarkerPosition = {x = 0.81, y = 0.13, z = 6.09},
    zShift = -6.14
}
myBookkeepingVariables = {
    validLandmarks = {},
    runningTotalGUIDs = {},
    drawnLandmarks = {},
    availableLandmarks = {
        ["1"] = {
            guids = {},
            picked = false
        },
        ["2"] = {
            guids = {},
            picked = false
        },
        ["3"] = {
            guids = {},
            picked = false
        }
    }
}
firstPlaced = false

----------------------
-- onload and once functions
----------------------
function onLoad()
    resetValidLandmarks()
    createAllButtons()
    autoVetoHomelandLandmarks()
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createSettingButtons()
    createConfirmButtons()
    createVetoLandmarkButtons()
end

function createSettingButtons()
    for i, setting in ipairs(myIterations.settingButtonLabels) do
        if setting == "select" then
            goLabel = settingButtons[setting].label .. " " .. settingButtons[setting].numLandmarks
        else
            goLabel = settingButtons[setting].label
        end
        self.createButton({
            click_function = "onSettingClick_" .. setting,
            function_owner = self,
            position = {
                myButtons.settingButtons.startX + (i-1) * myButtons.settingButtons.spacingX, 
                myButtons.settingButtons.buttonLift, 
                myButtons.settingButtons.startZ
            },
            height = myButtons.settingButtons.buttonHeight,
            width = myButtons.settingButtons.buttonWidth,
            font_size = myButtons.settingButtons.fontSize,
            scale = myButtons.settingButtons.scale,
            color = settingButtons[setting].color,
            label = goLabel,
            tooltip = settingButtons[setting].tooltip
        })
    end
end

function createConfirmButtons()
    for i = 1, 3 do
        self.createButton({
            click_function = "onConfirmClick_" .. i,
            function_owner = self,
            position = {
                myButtons.confirmButtons.startX + (i-1) * myButtons.confirmButtons.spacingX, 
                myButtons.confirmButtons.buttonLift, 
                myButtons.confirmButtons.startZ
            },
            height = myButtons.confirmButtons.buttonHeight,
            width = myButtons.confirmButtons.buttonWidth,
            font_size = myButtons.confirmButtons.fontSize,
            scale = myButtons.confirmButtons.scale,
            color = myButtons.confirmButtons.color,
            label = "Pick",
            tooltip = "Pick Landmark " .. i .. ". Remember to click 'CONFIRM' above to lock in choice."
        })
    end
end

function createVetoLandmarkButtons()
    for i, landmark in ipairs(myIterations.landmarks) do
        local row = math.floor((i - 1) / myButtons.vetoLandmarkButtons.numPerRow)
        local col = (i - 1) % myButtons.vetoLandmarkButtons.numPerRow
        local xPos = myButtons.vetoLandmarkButtons.startX + col * myButtons.vetoLandmarkButtons.spacingX
        local zPos = myButtons.vetoLandmarkButtons.startZ + row * myButtons.vetoLandmarkButtons.spacingZ
        
        self.createButton({
            click_function = "onVetoClick_" .. landmark,
            function_owner = self,
            position = {
                xPos, 
                myButtons.vetoLandmarkButtons.buttonLift, 
                zPos},
            height = myButtons.vetoLandmarkButtons.buttonHeight,
            width = myButtons.vetoLandmarkButtons.buttonWidth,
            font_size = myButtons.vetoLandmarkButtons.fontSize,
            scale = myButtons.vetoLandmarkButtons.scale,
            color = myButtons.vetoLandmarkButtons.defaultColor,
            label = vetoButtons[landmark].label
        })
    end
end

----------------------
-- onclick functions
----------------------
function onSettingClick_select()
    cycleSelectState()
end

function onSettingClick_random()
    announceElderTreetop()
    returnItemsToBag()
    randomizeLandmarks()
end

function onSettingClick_aid()
    print("Currently unimplemented.")
end

function onSettingClick_reset()
    resetValidLandmarks()
    resetPicks()
    returnItemsToBag()
end

function onSettingClick_confirm()
    onConfirmFinalize()
end

for _, landmark in ipairs(myIterations.landmarks) do
    _G["onVetoClick_" .. landmark] = function(obj, color, alt_click)
        onVetoButtonClick(landmark)
    end
end

for i = 1, 3 do
    _G["onConfirmClick_" .. i] = function(obj, color, alt_click)
        onConfirmClick(i)
    end
end

----------------------
-- helper functions
----------------------
function doNothing()
end

function resetValidLandmarks()
    myBookkeepingVariables.validLandmarks = {}
    for i, landmark in ipairs(myIterations.landmarks) do 
        if vetoButtons[landmark].state == "banned" then
            onVetoButtonClick(landmark)
        else --vetobutton adds the landmark ot the valid list already
            table.insert(myBookkeepingVariables.validLandmarks, landmark)
        end
    end
    firstPlaced = false
end

function resetPicks()
    for num = 1, 3 do
        if myBookkeepingVariables.availableLandmarks[tostring(num)].picked then
            onConfirmClick(num)
            myBookkeepingVariables.availableLandmarks[tostring(num)].guids = {}
        end
    end
end

function returnItemsToBag()
    local bag = myBagObjs.landmarksBag
    for _, GUID in ipairs(myBookkeepingVariables.runningTotalGUIDs) do
        if GUID then
            local item = getObjectFromGUID(GUID)
            bag.putObject(item)
        end
    end
    myBookkeepingVariables.runningTotalGUIDs = {}
end

function announceElderTreetop()
    local seated = getSeatedPlayers()
    local n = #seated
    if n < 3 and vetoButtons["tree"].state ~= "banned" then
        broadcastToAll("Remember: Elder Treetop is banned in 2 player games.")
    end
end

function autoVetoHomelandLandmarks()
    onVetoButtonClick("fox")
    onVetoButtonClick("mouse")
    onVetoButtonClick("rabbit")
end

----------------------
-- main click functions
----------------------
function onVetoButtonClick(vetoedLandmark)
    local myButtonState = vetoButtons[vetoedLandmark].state
    local myColor = myButtons.vetoLandmarkButtons.defaultColor
    if myButtonState == "pickable" then
        vetoButtons[vetoedLandmark].state = "banned"
        myColor = myColors.red
        for j, value in ipairs(myBookkeepingVariables.validLandmarks) do 
            if value == vetoedLandmark then
                table.remove(myBookkeepingVariables.validLandmarks, j)
            end
        end
    elseif myButtonState == "banned" then
        vetoButtons[vetoedLandmark].state = "pickable"
        table.insert(myBookkeepingVariables.validLandmarks, vetoedLandmark)
    end
    for i, value in ipairs(myIterations.landmarks) do
        if value == vetoedLandmark then
            self.editButton({
                index = i + 7,
                color = myColor
            })
            break
        end
    end
end

function cycleSelectState()
    if settingButtons["select"].numLandmarks == 1 then
        settingButtons["select"].numLandmarks = 2
    else 
        settingButtons["select"].numLandmarks = 1
    end
    self.editButton({
        index = 0,
        label = settingButtons["select"].label .. " " .. settingButtons["select"].numLandmarks
    })
end

function randomizeLandmarks()
    myBookkeepingVariables.drawnLandmarks = {}

    local numToDraw = settingButtons["select"].numLandmarks + 1
    local validLandmarksCopy = {table.unpack(myBookkeepingVariables.validLandmarks)}
    local bag = myBagObjs.landmarksBag

    for j = 1, numToDraw do
        if #validLandmarksCopy > 0 then
            local index = math.random(#validLandmarksCopy)
            table.insert(myBookkeepingVariables.drawnLandmarks, validLandmarksCopy[index])
            table.remove(validLandmarksCopy, index)
        end
    end

    local markerRotation = self.getRotation()
    local startingPosition = self.getPosition()
    for i, landmark in ipairs(myBookkeepingVariables.drawnLandmarks) do
        local newCardPos = {
            x = startingPosition.x + myPlacementPositions.startingRelativeCardPosition.x,
            y = startingPosition.y + myPlacementPositions.startingRelativeCardPosition.y + 1,
            z = startingPosition.z + myPlacementPositions.startingRelativeCardPosition.z + (i-1) * myPlacementPositions.zShift
        }
        local newMarkerPos = {
            x = startingPosition.x + myPlacementPositions.startingRelativeMarkerPosition.x,
            y = startingPosition.y + myPlacementPositions.startingRelativeMarkerPosition.y + 2,
            z = startingPosition.z + myPlacementPositions.startingRelativeMarkerPosition.z + (i-1) * myPlacementPositions.zShift
        }

        if vetoButtons[landmark].cardGUID then
            local item = bag.takeObject({
                guid = vetoButtons[landmark].cardGUID,
                position = newCardPos,
                rotation = myPlacementPositions.cardRotation,
                smooth = false
            })
            table.insert(myBookkeepingVariables.runningTotalGUIDs, vetoButtons[landmark].cardGUID)
            table.insert(myBookkeepingVariables.availableLandmarks[tostring(i)].guids, vetoButtons[landmark].cardGUID)
        else
            print(landmark .. " cardGUID not found in database.")
        end

        if vetoButtons[landmark].markerGUID then
            local marker = bag.takeObject({
                guid = vetoButtons[landmark].markerGUID,
                position = newMarkerPos,
                rotation = markerRotation,
                smooth = false
            })
            table.insert(myBookkeepingVariables.runningTotalGUIDs, vetoButtons[landmark].markerGUID)
            table.insert(myBookkeepingVariables.availableLandmarks[tostring(i)].guids, vetoButtons[landmark].markerGUID)
        else
            print(landmark .. " markerGUID not found in database.")
        end    

        if landmark == "city" then
            if vetoButtons[landmark].extraGUID then
                local extra = bag.takeObject({
                    guid = vetoButtons[landmark].extraGUID,
                    position = newMarkerPos,
                    rotation = markerRotation,
                    smooth = false
                })
                table.insert(myBookkeepingVariables.runningTotalGUIDs, vetoButtons[landmark].extraGUID)
                table.insert(myBookkeepingVariables.availableLandmarks[tostring(i)].guids, vetoButtons[landmark].extraGUID)
            else
                print(landmark .. " extraGUID not found in database.")
            end
        end
    end
end

function onConfirmClick(num)
    local goColor
    local currValue = myBookkeepingVariables.availableLandmarks[tostring(num)].picked
    if currValue then
        myBookkeepingVariables.availableLandmarks[tostring(num)].picked = false
        goColor = "White"
    else
        myBookkeepingVariables.availableLandmarks[tostring(num)].picked = true
        goColor = "Green"
    end
    self.editButton({
        index = 4 + num,
        color = goColor
    })
end

function onConfirmFinalize()
    local newPos
    for i = 1, 3 do
        if myBookkeepingVariables.availableLandmarks[tostring(i)].picked then
            if firstPlaced then
                newPos = {35.05, 2.60, -14.13}
            else
                newPos = {35.10, 2.60, -8.39}
                firstPlaced = true
            end
            for j, guid in ipairs(myBookkeepingVariables.availableLandmarks[tostring(i)].guids) do
                local obj = getObjectFromGUID(guid)
                if obj then
                    obj.setPositionSmooth(newPos)
                    if j == 1 then
                        obj.setRotationSmooth({0.00, 270.00, 180.00})
                    else
                        obj.setRotationSmooth({0.00, 270.00, 0})
                    end
                end
            end
            myBookkeepingVariables.availableLandmarks[tostring(i)].picked = false
        end 
    end 
end

----------------------
-- debug/unused functions
----------------------
function onSettingClick_flip()
    print("Currently unimplemented.")
    --flipObject(object)
end

function flipObject(object)
    local rotation = object.getRotation()
    object.setRotation({rotation.x, rotation.y, rotation.z + 180})
end

function isInAnyZone(object, zones)
    local objectPos = self.positionToLocal(object.getPosition())
    for _, zone in ipairs(zones) do
        if objectPos.x >= zone.x_min and objectPos.x <= zone.x_max and
           objectPos.z >= zone.z_min and objectPos.z <= zone.z_max then
            return true
        else 
            return false
        end
    end
end

function printValidLandmarks()
    print("-------------------")
    for i, value in ipairs(myBookkeepingVariables.validLandmarks) do 
        print(i .. value)
    end 
end

function createZoneButtons()
    for i, zone in ipairs(zoneButtons) do
        local width = math.abs(zone.x_max - zone.x_min) * 1000
        local height = math.abs(zone.z_max - zone.z_min) * 1000
        local posX = (zone.x_min + zone.x_max) / 2
        local posZ = (zone.z_min + zone.z_max) / 2

        self.createButton({
            click_function = "doNothing",
            function_owner = self,
            position = {posX, myButtons.liftHeight, posZ},
            height = height,
            width = width,
            color = {1, 1, 0, 0.75},
            font_color = {0, 0, 0, 1},
            label = zone.label
        })
    end
end

-- individually coded just in case for dynamic zones, z_max zone extended down below the marker indication to put objects that stick out back in.
-- xmin is leftx, xmax is rightx, zmin is top, xmax is bttom
zoneButtons = { 
    {label = "Zone 1", x_min = -0.83, x_max = -0.515, z_min = -0.38, z_max = 0.3},
    {label = "Zone 2", x_min = -0.15, x_max = 0.165, z_min = -0.38, z_max = 0.3},
    {label = "Zone 3", x_min = 0.53, x_max = 0.845, z_min = -0.38, z_max = 0.3},
}