----------------------
-- Coded for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Bag")

----------------------
-- Code
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
    --vagaWarrior = "7ade90",
    --vaga2Warrior = "05ab0c",
}

function getBag(key)
    local bagGUID = bagGUIDs[key]
    if bagGUID then
        return getObjectFromGUID(bagGUID)
    end
    return nil
end

function onCollisionEnter(collision_info)
    local collidingObj = collision_info.collision_object
    local gmNotes = collidingObj.getGMNotes()
    if gmNotes ~= "" then
        local bag = getBag(gmNotes)
        if bag then
            Wait.frames(function() 
                bag.putObject(collidingObj)
            end, 10)
        end
    end
end