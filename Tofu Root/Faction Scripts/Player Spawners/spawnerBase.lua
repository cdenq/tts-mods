----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Eyrie Spawner")

----------------------
-- set variables
----------------------
spawnerGUID = ""
itemGUIDs = {

}

----------------------
-- setup functions
----------------------
originalPositions = recordOriginalPositions()

----------------------
-- helper functions
----------------------
function recordOriginalPositions(spawnerGUID, itemGUIDs)
    local spawner = getObjectFromGUID(spawnerGUID)
    local originalPositions = {}
    
    for _, guid in ipairs(itemGUIDs) do
        local item = getObjectFromGUID(guid)
        if item then
            local relativePos = worldToLocalPosition(spawner, item.getPosition())
            local relativeRot = worldToLocalRotation(spawner, item.getRotation())
            
            originalPositions[guid] = {
                position = relativePos,
                rotation = relativeRot
            }
        end
    end
    
    return originalPositions
end

function worldToLocalPosition(reference, worldPos)
    local refPos = reference.getPosition()
    local refRot = reference.getRotation()
    local inverse = getInverseTransform(refPos, refRot)
    return transformPoint(inverse, worldPos)
end

function worldToLocalRotation(reference, worldRot)
    local refRot = reference.getRotation()
    return {
        x = worldRot.x - refRot.x,
        y = worldRot.y - refRot.y,
        z = worldRot.z - refRot.z
    }
end

----------------------
-- spawner functions
----------------------
function spawnRelativeItems(spawnerGUID, originalPositions)
    local spawner = getObjectFromGUID(spawnerGUID)
    local spawnerPos = spawner.getPosition()
    local spawnerRot = spawner.getRotation()
    
    for guid, data in pairs(originalPositions) do
        local item = getObjectFromGUID(guid)
        if item then
            -- Convert relative positions back to world coordinates
            local worldPos = localToWorldPosition(spawner, data.position)
            local worldRot = localToWorldRotation(spawner, data.rotation)
            
            -- Move item to new position
            item.setPosition(worldPos)
            item.setRotation(worldRot)
        end
    end
end

-- Convert a local position to world position
function localToWorldPosition(reference, localPos)
    local refPos = reference.getPosition()
    local refRot = reference.getRotation()
    local transform = getTransform(refPos, refRot)
    
    return transformPoint(transform, localPos)
end

-- Convert a local rotation to world rotation
function localToWorldRotation(reference, localRot)
    local refRot = reference.getRotation()
    -- Add reference rotation to local rotation
    return {
        x = localRot.x + refRot.x,
        y = localRot.y + refRot.y,
        z = localRot.z + refRot.z
    }
end

-- Helper function to create transformation matrix
function getTransform(position, rotation)
    -- This is a simplified version - you might want to use a proper matrix library
    -- for more complex transformations
    return {
        position = position,
        rotation = rotation
    }
end

-- Helper function to create inverse transformation
function getInverseTransform(position, rotation)
    -- This is a simplified version - you might want to use a proper matrix library
    return {
        position = {
            x = -position.x,
            y = -position.y,
            z = -position.z
        },
        rotation = {
            x = -rotation.x,
            y = -rotation.y,
            z = -rotation.z
        }
    }
end

-- Example usage:
function onLoad()
    -- List of GUIDs for your items
    local itemGUIDs = {"guid1", "guid2", "guid3"}
    local spawnerGUID = "spawner_guid"
    
    -- Record original positions relative to spawner
    local originalPositions = recordOriginalPositions(spawnerGUID, itemGUIDs)
    
    -- When spawner is clicked
    local spawner = getObjectFromGUID(spawnerGUID)
    spawner.createButton({
        click_function = "onSpawnerClicked",
        function_owner = self,
        label = "Spawn Items",
        position = {0, 1, 0},
        rotation = {0, 0, 0},
        width = 800,
        height = 400,
        font_size = 200
    })
end

function onSpawnerClicked(obj, color, alt_click)
    spawnRelativeItems(obj.getGUID(), originalPositions)
end