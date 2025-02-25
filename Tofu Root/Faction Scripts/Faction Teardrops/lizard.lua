----------------------
-- Created for Tofu Worldview
-- Optimized and cleaned by cdenq
-- Original by Central419
----------------------
self.setName("Lizard Placer")

----------------------
-- button variables
----------------------
myButtonConfig = {
    height = 350,
    width = 1100,
    font_size = 250,
    setup = {
        label = "Setup",
        click_function = "click_setup",
        position = {0, 0.3, -2},
        rotation = {0, 180, 0},
        color = {0, 0, 0},
        font_color = {0, 0, 0}
    },
    setup2 = {
        label = "Config",
        click_function = "click_setup_2",
        position = {-2, 0.3, 0},
        rotation = {0, 270, 0},
        color = {0.5, 0.5, 0.5},
        font_color = {0, 0, 0}
    },
    recall = {
        label = "Return",
        click_function = "click_recall",
        position = {0, 0.3, -2.8},
        rotation = {0, 180, 0},
        color = {0.5, 0.5, 0.5},
        font_color = {0, 0, 0}
    },
    place = {
        label = "Setup",
        click_function = "click_place",
        position = {0, 0.3, -2},
        rotation = {0, 180, 0},
        color = "Green",
        font_color = {0, 0, 0}
    },
    cancel = { --long
        label = "Cancel",
        click_function = "click_cancel",
        position = {0, 0.3, -2},
        rotation = {0, 180, 0},
        color = {0, 0, 0},
        font_color = {1, 1, 1}
    },
    submit = { --long
        label = "Submit",
        click_function = "click_submit",
        position = {0, 0.3, -2.8},
        rotation = {0, 180, 0},
        color = {0, 0, 0},
        font_color = {1, 1, 1}
    },
    reset = {
        label = "Reset",
        click_function = "click_reset",
        position = {-2, 0.3, 0},
        rotation = {0, 270, 0},
        color = {0, 0, 0},
        font_color = {1, 1, 1}
    }
}
myIterations = {
    presetup = {"setup"},
    insetup = {"cancel", "submit", "reset"},
    postsetup = {"place", "recall", "setup2"}
}

----------------------
-- onload and save functions
----------------------
function onload(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        --Set up information off of loaded_data
        memoryList = loaded_data.ml
        relativeRotation = loaded_data.rr
    else
        --Set up information for if there is no saved saved data
        memoryList = {}
        relativeRotation = readRotation()
    end

    if next(memoryList) == nil then
        changeButtons("before_setup")
    else
        changeButtons("done_setup")
    end
end

function updateSave()
    local data_to_save = {["ml"]=memoryList, ["rr"]=relativeRotation}
    saved_data = JSON.encode(data_to_save)
    self.script_state = saved_data
end

-----------------------
-- create button functions
----------------------
function changeButtons(variant)
    self.clearButtons()

    if (variant == "before_setup") then
        createNoSetupButtons()
    elseif (variant == "in_setup") then
        createInSetupButtons()
    elseif (variant == "done_setup") then
        createDoneSetupButtons()
    end
end

function createNoSetupButtons()
    createAllButtons("presetup")
end

function createInSetupButtons()
    createAllButtons("insetup")
end

function createDoneSetupButtons()
    createAllButtons("postsetup")
end

function createAllButtons(keyword)
    for i, button in ipairs(myIterations[keyword]) do
        self.createButton({
            click_function = myButtonConfig[button].click_function,
            function_owner = self,
            label = myButtonConfig[button].label,
            position = myButtonConfig[button].position,
            rotation = myButtonConfig[button].rotation,
            height = myButtonConfig.height,
            width = myButtonConfig.width,
            color = myButtonConfig[button].color,
            font_color = myButtonConfig[button].font_color,
            font_size = myButtonConfig.font_size
        })
    end
end

----------------------
-- onclcik functions
----------------------
function click_setup()
    local tagTarget = self.getGMNotes()

    if (tagTarget == nil or tagTarget == "") then
        print("No target tag found.")
        return
    end

    memoryListBackup = duplicateTable(memoryList)
    memoryList = readList()

    if (next(memoryList) == nil) then
        print("Target tag found 0 tagged objects.")
        return
    end

    setOutline(memoryList, true)

    relativeRotationBackup = relativeRotation
    relativeRotation = readRotation()

    changeButtons("in_setup")
end

function click_setup_2(obj, color, alt_click)
    if checkHost(obj, color, alt_click) then
        click_setup()
    end
end

function click_cancel()
    setOutline(memoryList, false)

    memoryList = memoryListBackup
    relativeRotation = relativeRotationBackup

    if next(memoryList) == nil then
        changeButtons("before_setup")
    else
        changeButtons("done_setup")
    end

    print("Selection Canceled", {1,1,1})
end

function click_submit()
    memoryList = readList()
    if (next(memoryList) == nil) then
        print("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        changeButtons("done_setup")

        local count = setOutline(memoryList, false)
        print(count .. " objects saved!", {1,1,1})

        updateSave()
    end
end

function click_reset()
    setOutline(memoryList, false)
    memoryList = {}

    relativeRotation = readRotation()

    changeButtons("before_setup")

    print("Saved objects cleared.", {1,1,1})
    updateSave()
end

function click_recall()
    for guid, entry in pairs(memoryList) do
        local obj = getObjectFromGUID(guid)
        if obj ~= nil then
            self.putObject(obj)
        end
    end
end

function click_place()
    local bagObjList = self.getObjects()
    local currentRotation = readRotation()
    local selfPos = self.getPosition()
    local sortedMemory = {}
    for guid, entry in pairs(memoryList) do
        table.insert(sortedMemory, {guid = guid, entry = entry})
    end
    
    table.sort(sortedMemory, function(a, b) 
        return a.entry.pos.y < b.entry.pos.y 
    end)
    
    local previousLayerY = -999
    local currentLayer = 0
    for i, item in ipairs(sortedMemory) do
        local guid = item.guid
        local entry = item.entry
        local obj = getObjectFromGUID(guid)
        local rot = {
            x = entry.rot.x,
            y = entry.rot.y,
            z = entry.rot.z
        }
        local rotationAdjustment = currentRotation - relativeRotation

        rot.y = rot.y + rotationAdjustment
        if (rot.y > 360) then
            rot.y = rot.y - 360
        elseif (rot.y < 0) then
            rot.y = rot.y + 360
        end

        local deltaPos = compare_coords(selfPos, entry.pos, rotationAdjustment)
        if math.abs(entry.pos.y - previousLayerY) < 0.5 then
        else
            previousLayerY = entry.pos.y
            currentLayer = currentLayer + 1
        end

        if obj ~= nil then
            Wait.frames(function()
                obj.setPositionSmooth(deltaPos)
                obj.setRotationSmooth(rot)
                Wait.time(function()
                    obj.setLock(entry.lock)
                end, 1)
            end, i*5)
        else
            for _, bagObj in ipairs(bagObjList) do
                if bagObj.guid == guid then
                    Wait.frames(function()
                        local item = self.takeObject({
                            guid = guid,
                            position = deltaPos,
                            rotation = rot,
                        })
                        Wait.time(function()
                            item.setLock(entry.lock)
                        end, 1)
                    end, i*5)
                    break
                end
            end
        end
    end
end

----------------------
-- object functions
----------------------
function setOutline(list, enabled)
    local count = 0

    if (next(list) == nil) then
        return count
    end

    for guid in pairs(list) do
        count = count + 1
        local obj = getObjectFromGUID(guid)
        if (obj ~= nil and enabled == false) then obj.highlightOff() end
        if (obj ~= nil and enabled == true) then obj.highlightOn({1,1,1}) end
    end

    return count
end

function readRotation()
    local r1, r2, r3 = self.getRotation():get()
    return round(r2)
end

function compare_coords(p1, p2, rotation)
    local deltaPos = {}
    local r = math.rad(rotation)

    local z = ((-p2.x * math.sin(r) + p2.z * math.cos(r)))
    local x = ((p2.x * math.cos(r) + p2.z * math.sin(r)))

    deltaPos.x = (p1.x + x)
    deltaPos.y = (p1.y + p2.y)
    deltaPos.z = (p1.z + z)

    return deltaPos
end

----------------------
-- helper functions
----------------------
function checkHost(obj, color, alt_click)
    if Player[color].host then
        return true
    else
        broadcastToAll("Only the host can use this function.")
        return false
    end
end

function transmute(t, vfn, kfn)
    local out = {}
    local c = 1
    for k,v in pairs(t) do
        local value = vfn(v,c,t)
        local key = kfn != nil and kfn(v,c,t) or k
        if (value and key) then
            out[key] = value
        end
        c = c + 1
    end
    return out
end

function duplicateTable(oldTable)
    local newTable = {}
    for k, v in pairs(oldTable) do
        newTable[k] = v
    end
    return newTable
end

function round(num, dec)
    local mult = 10^(dec or 0)
    return math.floor(num * mult + 0.5) / mult
end

----------------------
-- state functions
----------------------
function readList()
    return transmute(
        getObjectsWithTag(self.getGMNotes()),
        function(obj)
            local selfPos = self.getPosition()
            local objPos = obj.getPosition()
            local deltaPos = {}
            deltaPos.x = (objPos.x-selfPos.x)
            deltaPos.y = (objPos.y-selfPos.y)
            deltaPos.z = (objPos.z-selfPos.z)
            local pos, rot = deltaPos, obj.getRotation()

            return {
                pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
                rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
                lock=obj.getLock()
            }
        end,
        function(obj)
            return obj.guid
        end
    )
end