----------------------
-- Created for Tofu Worldview
-- By tofuwater
----------------------
self.setName("Tofu Bat VP")

----------------------
-- button variables
----------------------
markerGUID = "bed79e"
factionName = "Twilight Council"
trackerPositions = {
    ["0"] = {23.30, 1.73, 21.11},
    ["1"] = {21.75, 1.73, 21.11},
    ["2"] = {20.20, 1.73, 21.11},
    ["3"] = {18.64, 1.73, 21.11},
    ["4"] = {17.09, 1.73, 21.11},
    ["5"] = {15.54, 1.73, 21.11},
    ["6"] = {13.99, 1.73, 21.11},
    ["7"] = {12.44, 1.73, 21.11},
    ["8"] = {10.89, 1.73, 21.11},
    ["9"] = {9.33, 1.73, 21.11},
    ["10"] = {7.78, 1.73, 21.11},
    ["11"] = {6.23, 1.73, 21.11},
    ["12"] = {4.68, 1.73, 21.11},
    ["13"] = {3.13, 1.73, 21.11},
    ["14"] = {1.58, 1.73, 21.11},
    ["15"] = {0.02, 1.73, 21.11},
    ["16"] = {-1.53, 1.73, 21.11},
    ["17"] = {-3.07, 1.73, 21.11},
    ["18"] = {-4.63, 1.73, 21.11},
    ["19"] = {-6.18, 1.73, 21.11},
    ["20"] = {-7.73, 1.73, 21.11},
    ["21"] = {-9.28, 1.73, 21.11},
    ["22"] = {-10.84, 1.73, 21.11},
    ["23"] = {-12.38, 1.73, 21.11},
    ["24"] = {-13.93, 1.73, 21.11},
    ["25"] = {-15.48, 1.73, 21.11},
    ["26"] = {-17.03, 1.73, 21.11},
    ["27"] = {-18.58, 1.73, 21.11},
    ["28"] = {-20.14, 1.73, 21.11},
    ["29"] = {-21.69, 1.73, 21.11},
    ["30"] = {-23.24, 1.73, 21.11}
}
markerIndex = 0
isSetup = false

----------------------
-- onload and once functions
----------------------
function onLoad(saved_data)
    loadIndex(saved_data)
    createAllButtons()
    updateScore()
end

function loadIndex(saved_data)
    if saved_data ~= "" and saved_data ~= nil and saved_data ~= "[]" then
        local loaded_data = JSON.decode(saved_data)
        markerIndex = loaded_data.markerIndex
        isSetup = loaded_data.isSetup
    else
        markerIndex = 0
        isSetup = false
    end
end

function onSave()
    local data_to_save = {
        markerIndex  = markerIndex,
        isSetup = isSetup
    }
    saved_data = JSON.encode(data_to_save)
    return saved_data
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createScoreButton()
    checkSetup()
    checkButtons()
end

function createScoreButton()
    self.createButton({
        click_function = "doNothing",
        function_owner = self,
        position = {0, 0.05, -1.2},
        width = 0,
        height = 0,
        font_size = 600,
        font_color = {0, 0, 0},
        label = "0"
    })
end

function checkSetup()
    if not isSetup then
        createSetup()
    end
end

function checkButtons()
    if isSetup then
        createAddButton()
        createSubButton()
    end
end

function createSetup()
    self.createButton({
        click_function = "startSetup",
        function_owner = self,
        position = {0, 0.05, 1.2},
        width = 800,
        height = 300,
        font_size = 200,
        font_color = "White",
        color = "Red",
        label = "SETUP",
        tooltip = "Place marker on 0."
    })
end

function createAddButton()
    self.createButton({
        click_function = "addVP",
        function_owner = self,
        position = {2.5, 0.1, 0},
        width = 400,
        height = 1250,
        font_size = 600,
        color = "Green",
        font_color = "White",
        label = "+",
        tooltip = "Increase score."
    })
end

function createSubButton()
    self.createButton({
        click_function = "subVP",
        function_owner = self,
        position = {-2.5, 0.1, 0},
        width = 400,
        height = 1250,
        font_size = 600,
        color = "Red",
        font_color = "White",
        label = "-",
        tooltip = "Decrease score."
    })
end

----------------------
-- click functions
----------------------
function addVP(obj, color, alt_click)
    local oldValue = markerIndex
    markerIndex = math.min(markerIndex + 1, 30)
    if oldValue ~= markerIndex then
        if markerIndex == 30 then
            broadcastToAll(factionName .. " reaches " .. markerIndex .. "! Victory!", color)
        else
            printToAll(factionName .. " score increases to " .. markerIndex .. ".", color)
        end
        moveAndCheckMarker(markerIndex, color)
    else
        printToAll(factionName .. " score cannot increase anymore.", color)
    end
end

function subVP(obj, color, alt_click)
    local oldValue = markerIndex
    markerIndex = math.max(markerIndex - 1, 0)
    if oldValue ~= markerIndex then
        printToAll(factionName .. " score decreases to " .. markerIndex .. ".", color)
        moveMarker(markerIndex)
    else
        printToAll(factionName .. " score cannot decrease anymore.", color)
    end
end

function moveAndCheckMarker(markerIndex, color)
    checkMarker(markerIndex, color)
    moveMarker(markerIndex)
end

function checkMarker(markerIndex, color)
    local keyword
    if markerIndex == 4 then
        keyword = "HIRELING4"
    elseif markerIndex == 8 then
        keyword = "HIRELING8"
    elseif markerIndex == 12 then
        keyword = "HIRELING12"
    else
        return
    end

    local checkGlobal = Global.getVar(keyword)
    if not checkGlobal then -- if var is false
        broadcastToAll(Player[color].steam_name .. " needs to claim a hireling!", color)
        Global.setVar(keyword, true)
    end
end

function moveMarker(markerIndex)
    local markerObj = getObjectFromGUID(markerGUID)
    local assignedPosition = trackerPositions[tostring(markerIndex)]
    local newPosition = {
        x = assignedPosition[1],
        y = assignedPosition[2] + 7,
        z = assignedPosition[3]
    }
    markerObj.setPositionSmooth(newPosition)
    markerObj.setRotation({0, 0, 0})
    updateScore()
end

function doNothing()
end

function updateScore()
    self.editButton({
        index = 0,
        label = markerIndex
    })
end

function startSetup()
    moveMarker("0")
    updateScore()
    isSetup = true
    self.removeButton(1)
    checkButtons()
end

