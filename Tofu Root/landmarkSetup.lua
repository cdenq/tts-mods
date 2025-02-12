----------------------
-- Created for Tofu Worldview
-- By cdenq
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
        startZ = 0.28, 
        spacingX = 0.4, 
        spacingZ = 0.175,
        scale = {0.65, 0.65, 0.65},
        buttonHeight = 80, 
        buttonWidth = 300,
        buttonLift = globalButtonLift,
        fontSize = 40, 
        defaultColor = myColors.white,
        numPerRow = 4
    }
}

----------------------
-- object variables
----------------------
myIterations = {
    settingButtonLabels = {"select", "random", "all", "flip", "reset"},
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
        label = "Random",
        color = myColors.green, 
        tooltip = "Randomize and draft landmarks based on vetos."
    },
    all = {
        label = "Player Aid",
        color = myColors.gray, 
        tooltip = "Brings out the Landmark player aid."
    },
    flip = {
        label = "Flip All",
        color = myColors.gray, 
        tooltip = "Flip all revealed landmark cards."
    },
    reset = {
        label = "Reset",
        color = myColors.white, 
        tooltip = "Reset all vetos and return all landmark items back to the bag."
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
    cardRotation = {
        self.getRotation()[1], 
        self.getRotation()[2], 
        self.getRotation()[3] + 180
    },
    markerRotation = self.getRotation(),
    ["1"] = {
        cardPosition = {137.14, 2.63, 23.97},
        markerPosition = {134.72, 4, 23.97}
    },
    ["2"] = {
        cardPosition = {137.14, 2.63, 17.83},
        markerPosition = {134.72, 4, 17.83}
    },
    ["3"] = {
        cardPosition = {137.14, 2.63, 11.70},
        markerPosition = {134.72, 4, 11.70}
    }
}
myBookkeepingVariables = {
    validLandmarks = {},
    runningTotalGUIDs = {},
    drawnLandmarks = {}
}

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

function flipObject(object)
    local rotation = object.getRotation()
    object.setRotation({rotation.x, rotation.y, rotation.z + 180})
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
                index = i + 4,
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

----------------------
-- onclick functions
----------------------
function onSettingClick_select()
    cycleSelectState()
end

function onSettingClick_random()
    announceElderTreetop()
    returnItemsToBag()
    
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

    for i, landmark in ipairs(myBookkeepingVariables.drawnLandmarks) do
        if vetoButtons[landmark].cardGUID then
            local item = bag.takeObject({
                guid = vetoButtons[landmark].cardGUID,
                position = myPlacementPositions[tostring(i)].cardPosition,
                rotation = myPlacementPositions.cardRotation,
                smooth = false
            })
            table.insert(myBookkeepingVariables.runningTotalGUIDs, vetoButtons[landmark].cardGUID)
        else
            print(landmark .. " cardGUID not found in database.")
        end

        if vetoButtons[landmark].markerGUID then
            local marker = bag.takeObject({
                guid = vetoButtons[landmark].markerGUID,
                position = myPlacementPositions[tostring(i)].markerPosition,
                rotation = myPlacementPositions.markerRotation,
                smooth = false
            })
            table.insert(myBookkeepingVariables.runningTotalGUIDs, vetoButtons[landmark].markerGUID)
        else
            print(landmark .. " markerGUID not found in database.")
        end    

        if landmark == "city" then
            if vetoButtons[landmark].extraGUID then
                local extra = bag.takeObject({
                    guid = vetoButtons[landmark].extraGUID,
                    position = myPlacementPositions[tostring(i)].markerPosition,
                    rotation = myPlacementPositions.markerRotation,
                    smooth = false
                })
                table.insert(myBookkeepingVariables.runningTotalGUIDs, vetoButtons[landmark].extraGUID)
            else
                print(landmark .. " extraGUID not found in database.")
            end
        end
    end
end

function onSettingClick_all()
    print("Currently unimplemented.")
end

function onSettingClick_flip()
    print("Currently unimplemented.")
    --flipObject(object)
end

function onSettingClick_reset()
    resetValidLandmarks()
    returnItemsToBag()
end

for _, landmark in ipairs(myIterations.landmarks) do
    _G["onVetoClick_" .. landmark] = function(obj, color, alt_click)
        onVetoButtonClick(landmark)
    end
end

----------------------
-- debug/unused functions
----------------------
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
        local width = math.abs(zone.x_max - zone.x_min) * 1000 -- Convert to button width
        local height = math.abs(zone.z_max - zone.z_min) * 1000 -- Convert to button height
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