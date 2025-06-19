-- Refactored/udpated by tofuwater
-- Original by Tragic

-- Object state tracking
ObjectTag = {
    Board=false, Dice=false, Tileset=false, Tile=false, Token=false,
    objGeneric=false, objFigurine=false, objDice=false, objCoin=false, 
    objBoard=false, objChip=false, objBag=false, objInfinite=false
}

-- Configuration
template = nil
templateSize = {}
URLtextImport_One = 'fb739f'
URLtextImport_Two = '21d4de'
importBagGUID = '6f2bdd'
cogGUID = '97a85c'
stopMainLoop = false
stopTemplateLoop = false

-- UI Configuration
button_MakeStuff = {
    click_function = 'MakeCopies',
    function_owner = self,
    label = 'Clone From URLs',
    position = {0, 1, 1.32},
    rotation = {0, 0, 0},
    width = 1250,
    height = 300,
    font_size = 150
}

-- Object detection configuration
local ObjectDetectors = {
    -- Simple tag-based detections
    ['Generic'] = {flag = 'objGeneric', message = 'Custom Mesh Object (Generic)', color = 'Yellow'},
    ['Coin'] = {flag = 'objCoin', message = 'Custom Mesh Object (Coin)', color = 'Yellow'},
    ['Chip'] = {flag = 'objChip', message = 'Custom Mesh Object (Chip)', color = 'Yellow'},
    ['Bag'] = {flag = 'objBag', message = 'Custom Mesh Object (Bag)', color = 'Yellow'},
    ['Infinite'] = {flag = 'objInfinite', message = 'Custom Mesh Object (Infinate Bag)', color = 'Yellow'},
    ['Tileset'] = {flag = 'Tileset', message = 'Custom Standee', color = 'Orange'},
    ['Token'] = {flag = 'Token', message = 'Custom Token', color = 'Orange'}
}

-- Initialize
function onLoad()
    self.createButton(button_MakeStuff)
end

-- Main function to determine spawning strategy
function MakeCopies()
    stopTemplateLoop = true
    if template == nil then
        broadcastToAll('NOTHING ON THE TOOL!', stringColorToRGB('Orange'))
        return
    end
    
    if requiresSingleImage() then
        spawnSingle()
    elseif requiresDoubleImage() then
        spawnDouble_Test()
    end
end

-- Determine if object needs single image
function requiresSingleImage()
    return ObjectTag['Board'] or ObjectTag['Dice'] or ObjectTag['Token']
end

-- Determine if object needs double image
function requiresDoubleImage()
    return ObjectTag['Tile'] or ObjectTag['Tileset'] or 
           ObjectTag['objGeneric'] or ObjectTag['objFigurine'] or ObjectTag['objDice'] or 
           ObjectTag['objCoin'] or ObjectTag['objBoard'] or ObjectTag['objChip'] or 
           ObjectTag['objBag'] or ObjectTag['objInfinite']
end

-- Get URLs from text input
function getURLsFromInput(textInputGUID)
    local textInput = getObjectFromGUID(textInputGUID).getValue()
    local urls = {}
    for w in (textInput .. "\n"):gmatch("([^\n]*)\n") do
        table.insert(urls, convertURLs(w))
    end
    return urls
end

-- Create object parameters based on object type
function createObjectParameters(urls_One, urls_Two, index)
    local objPram = {}
    
    -- Single image objects
    if ObjectTag['Board'] or ObjectTag['Dice'] or ObjectTag['Tileset'] or ObjectTag['Tile'] then
        objPram.image = string.gsub(urls_One[index], '\r', '')
    elseif ObjectTag['Token'] then
        objPram.image = string.gsub(urls_One[index], '\r', '')
        objPram.stackable = false
    
    -- Double image objects - Tiles
    elseif ObjectTag['Tile'] and urls_Two then
        objPram.image = string.gsub(urls_One[index], '\r', '')
        objPram.image_bottom = string.gsub(urls_Two[index], '\r', '')
    
    -- Double image objects - Tilesets
    elseif ObjectTag['Tileset'] and urls_Two then
        objPram.image = string.gsub(urls_One[index], '\r', '')
        objPram.image_secondary = string.gsub(urls_Two[index], '\r', '')
    
    -- Custom mesh objects
    elseif ObjectTag['objGeneric'] or ObjectTag['objFigurine'] or ObjectTag['objDice'] or 
           ObjectTag['objCoin'] or ObjectTag['objBoard'] or ObjectTag['objChip'] or 
           ObjectTag['objBag'] or ObjectTag['objInfinite'] then
        objPram.diffuse = string.gsub(urls_One[index], '\r', '')
        if urls_Two then
            objPram.normal = string.gsub(urls_Two[index], '\r', '')
        end
    end
    
    return objPram
end

-- Clone and configure object
function cloneAndConfigureObject(objPram)
    local cl = template.clone()
    cl.setPosition({0,0,0})
    cl.setCustomObject(objPram)
    getObjectFromGUID(importBagGUID).putObject(cl)
end

-- Spawn objects with single image
function spawnSingle()
    function spawnSingle_CORE()
        print('Spawn Single')
        local urls_One = getURLsFromInput(URLtextImport_One)
        
        for i = 1, #urls_One do
            local objPram = createObjectParameters(urls_One, nil, i)
            cloneAndConfigureObject(objPram)
        end
        
        wait(3)
        stopTemplateLoop = false
        return 1
    end
    startLuaCoroutine(self, 'spawnSingle_CORE')
end

-- Spawn objects with double images
function spawnDouble()
    function spawnDouble_CORE()
        print('Spawn Double')
        local urls_One = getURLsFromInput(URLtextImport_One)
        local urls_Two = getURLsFromInput(URLtextImport_Two)
        
        for i = 1, #urls_One do
            local objPram = createObjectParameters(urls_One, urls_Two, i)
            cloneAndConfigureObject(objPram)
        end
        
        wait(3)
        stopTemplateLoop = false
        return 1
    end
    startLuaCoroutine(self, 'spawnDouble_CORE')
end

-- Test and validate double image spawning
function spawnDouble_Test()
    local textimport_One = getObjectFromGUID(URLtextImport_One).getValue()
    local textimport_Two = getObjectFromGUID(URLtextImport_Two).getValue()
    
    -- Check if only using one URL list
    if #textimport_Two == 9 then
        spawnSingle()
        return
    end
    
    -- Validate both lists have same length
    local urls_One = getURLsFromInput(URLtextImport_One)
    local urls_Two = getURLsFromInput(URLtextImport_Two)
    
    if #urls_One == #urls_Two then
        spawnDouble()
    else
        broadcastToAll('To use two URL Lists, they need to be the SAME ammount on LINES', stringColorToRGB('Orange'))
    end
end

-- Convert various URL formats to usable ones
function convertURLs(urls)
    local link = urls
    link = link:gsub('file/d/', 'uc?export=download&id=')
    link = link:gsub('/view%?usp=sharing', '')
    link = link:gsub('%?dl=0', '?dl=1')
    return link
end

-- Utility function for coroutines
function wait(time)
    local start = os.time()
    repeat coroutine.yield(0) until os.time() > start + time
end

-- Set object tag state and broadcast message
function setObjectState(flag, state, message, color)
    ObjectTag[flag] = state
    local action = state and 'PLACED' or 'REMOVED'
    local colorString = state and color or 'Red'
    broadcastToAll(message .. ' : ' .. action, stringColorToRGB(colorString))
end

-- Handle complex object detection (objects that need custom logic)
function handleComplexObject(tag, placed)
    if tag == 'Figurine' then
        -- Check if standup token or custom mesh figurine
        if template.getCustomObject().diffuse == nil then
            setObjectState('Token', placed, 'Custom Standup Token', 'Orange')
        else
            setObjectState('objFigurine', placed, 'Custom Mesh Object (Standee)', 'Yellow')
        end
        
    elseif tag == 'Board' then
        -- Check if game board or custom mesh board
        if template.getCustomObject().diffuse == nil then
            setObjectState('Board', placed, 'Custom Game Board', 'Orange')
        else
            setObjectState('objBoard', placed, 'Custom Object Mesh (Game Board)', 'Yellow')
        end
        
    elseif tag == 'Dice' then
        -- Check if die or custom mesh die
        if template.getCustomObject().diffuse == nil then
            setObjectState('Dice', placed, 'Custom Die', 'Orange')
        else
            setObjectState('objDice', placed, 'Custom Object Mesh (Die)', 'Yellow')
        end
        
    elseif tag == 'Tile' then
        -- Check if tile or token
        if template.getCustomObject().type == nil then
            setObjectState('Token', placed, 'Custom Token', 'Orange')
        else
            setObjectState('Tile', placed, 'Custom Tile', 'Orange')
        end
    end
end

-- Handle collision events
function handleCollision(collision_info, placed)
    template = collision_info.collision_object
    
    if placed then
        print("DEBUG: Object tag is: " .. template.tag)
        -- Store template size
        templateSize.x = template.getBoundsNormalized().size.x
        templateSize.y = template.getBoundsNormalized().size.y
        templateSize.z = template.getBoundsNormalized().size.z
    end
    
    local tag = template.tag
    
    -- Handle simple detections first
    if ObjectDetectors[tag] then
        local detector = ObjectDetectors[tag]
        setObjectState(detector.flag, placed, detector.message, detector.color)
    else
        -- Handle complex detections
        handleComplexObject(tag, placed)
    end
end

-- Collision event handlers
function onCollisionEnter(collision_info)
    handleCollision(collision_info, true)
end

function onCollisionExit(collision_info)
    handleCollision(collision_info, false)
end

-- Debug function (kept for compatibility)
function printTagsTest()
    local found = false
    for k, v in pairs(ObjectTag) do
        if v == true then
            print(k..': '..tostring(v))
            found = true
        end
    end
    if not found then 
        print('No Truth') 
    end
end