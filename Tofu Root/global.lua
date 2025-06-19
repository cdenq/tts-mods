function onLoad()
    GLOBALNUMLANDMARKS = 0
    GLOBALSETTING = ""
    HIRELINGSINPLAY = {}
    HIRELING4 = true
    HIRELING8 = true
    HIRELING12 = true
end

function setHirelingsinPlay(newFactions)
    HIRELINGSINPLAY = newFactions
    Global.setVar("HIRELINGSINPLAY", HIRELINGSINPLAY)
end

function globalDiscard(obj)
    obj.setPositionSmooth({28.15, 3.37, 23.86})
end

function globalLayFlat(obj)
    local currentRot = obj.getRotation()
    obj.setRotationSmooth({90, currentRot.y, currentRot.z})
end

function onObjectSpawn(obj)
    tagList = obj.getTags()
    if checkHasTag("Root Card", tagList) or obj.type == "Deck" then
        obj.addContextMenuItem(
            "Graveyard",
            function(playerColor) 
                globalDiscard(obj) 
            end,
            false
        )
    elseif checkHasTag("Warrior", tagList) and (not checkHasTag("Captain", tagList)) and (not checkHasTag("Warlord", tagList)) then
        obj.addContextMenuItem(
            "Lay flat",
            function(playerColor) 
                globalLayFlat(obj) 
            end,
            false
        )
    end
end

function checkHasTag(targetTag, tagList)
    for _, tag in ipairs(tagList) do
        if tag == targetTag then
            return true
        end
    end
    return false
end