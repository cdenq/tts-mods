----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Tile Randomizer")

----------------------
-- pre-helper functions
----------------------
function getNumPlayers()
    local seated = getSeatedPlayers()
    local n = #seated
    return n
end

function getGridPosition(row, col)  -- row and col are 0-based indices (0-11)
    local x = 99.00 - (row * 4)
    local y = 2.1
    local z = 22.80 - (col * 4)
    return {x, y, z}
end

function getSubgridPosition(colorIndex, level, count)
    -- colorIndex: 1-9 (position in 3x3 grid of subgrids)
    -- level: 1-4 (which row in the 4x4 subgrid)
    -- count: 1-4 (which column in the row)
    
    -- Calculate base position for the subgrid
    local subgridRow = math.floor((colorIndex - 1) / 3)
    local subgridCol = (colorIndex - 1) % 3
    
    -- Calculate final position within the 12x12 grid
    local finalRow = (subgridRow * 4) + (level - 1)
    local finalCol = (subgridCol * 4) + (count - 1)
    
    return finalRow, finalCol
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function table.indexOf(table, value)
    for i, v in ipairs(table) do
        if v == value then
            return i
        end
    end
    return nil
end

function identifyTileProperties(guid)
    for _, color in ipairs(colors) do
        for _, level in ipairs(levels) do
            local key = color .. level
            if allPowerTiles[key] then
                for _, tileGuid in ipairs(allPowerTiles[key]) do
                    if guid == tileGuid then
                        return color, level
                    end
                end
            end
        end
    end
    return nil, nil
end

----------------------
-- coding variables
----------------------
myBookkeepingVariables = {
    tileBag = getObjectFromGUID("9bbbdc"),
    attachmentBag = getObjectFromGUID("4f71ab"),
    numPlayers = math.max(getNumPlayers(), 2)
}
tempColors = {}
tempTiles = {}
drawnColors = {}
drawnTileFormats = {}
drawnTiles = {}
finalDrawn = {}

----------------------
-- onload
----------------------
function onload()
    createAllButtons()
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createSettingButtons()
end

function createSettingButtons()
    self.createButton({
        click_function = "cyclePlayerCount",
        function_owner = self,
        position = {-0.25, 0.45, -0.3},
        height = 200,
        width = 300,
        scale = {0.75, 0.75, 0.75},
        font_size = 45,
        label = "Count: " .. tostring(myBookkeepingVariables.numPlayers),
        tooltip = "Adjust player count."
    })
    self.createButton({
        click_function = "randomizeTiles",
        function_owner = self,
        position = {0, 0.45, 0},
        height = 200,
        width = 300,
        scale = {0.75, 0.75, 0.75},
        font_size = 45,
        color = {0, 1, 0},
        label = "Randomize",
        tooltip = "Randomize tiles."
    })
    self.createButton({
        click_function = "resetTiles",
        function_owner = self,
        position = {0.25, 0.45, 0.3},
        height = 200,
        width = 300,
        scale = {0.75, 0.75, 0.75},
        font_size = 45,
        label = "Reset",
        tooltip = "Reset tiles."
    })
end

----------------------
-- cycle player count
----------------------
function cyclePlayerCount(obj, color, alt_click)
    if not alt_click then
        myBookkeepingVariables.numPlayers = math.min(myBookkeepingVariables.numPlayers + 1, 6)
    else
        myBookkeepingVariables.numPlayers = math.max(myBookkeepingVariables.numPlayers - 1, 2)
    end
    self.editButton({
        index = 0,
        label = "Count: " .. tostring(myBookkeepingVariables.numPlayers)
    })
end

----------------------
-- randomizetiles
----------------------
function randomizeTiles()
    resetTiles()

    -- Reset global tables
    tempColors = {}
    drawnColors = {}
    drawnTileFormats = {}
    drawnTiles = {}
    finalDrawn = {}
    
    -- Create deep copies of the tables
    for _, color in ipairs(colors) do
        table.insert(tempColors, color)
    end
    
    tempTiles = {}
    for k, v in pairs(allPowerTiles) do
        tempTiles[k] = {}
        for _, guid in ipairs(v) do
            table.insert(tempTiles[k], guid)
        end
    end
    
    -- Randomly draw colors
    local numColorsToDraw = myBookkeepingVariables.numPlayers + 1
    for i = 1, numColorsToDraw do
        if #tempColors > 0 then
            local randomIndex = math.random(#tempColors)
            table.insert(drawnColors, tempColors[randomIndex])
            table.remove(tempColors, randomIndex)
        end
    end
    
    -- Create a pool of formats based on drawn colors
    local formatPool = {}
    for _, color in ipairs(drawnColors) do
        if drafts[color] then
            for _, format in ipairs(drafts[color]) do
                table.insert(formatPool, format)
            end
        end
    end
    
    -- Draw tile formats
    local numTilesToDraw = 6 * myBookkeepingVariables.numPlayers + 12
    for i = 1, numTilesToDraw do
        if #formatPool > 0 then
            local randomIndex = math.random(#formatPool)
            local selectedFormat = formatPool[randomIndex]
            table.insert(drawnTiles, selectedFormat)
            table.remove(formatPool, randomIndex)
        end
    end

    -- Announce selected colors
    local announcement = "[ffffff]Pyramids:[-]"
    
    for i, color in ipairs(drawnColors) do
        if i > 1 then
            announcement = announcement .. ", "
        end
        announcement = announcement .. string.format(" [%s]%s[-]", colorHexes[color], color)
    end
    
    broadcastToAll(announcement)
    
    -- Add four level one tiles for each drawn color
    for _, color in ipairs(drawnColors) do
        local levelOneKey = color .. "One"
        for i = 1, 4 do
            table.insert(drawnTiles, levelOneKey)
        end
    end
    
    -- Sort drawnTiles
    table.sort(drawnTiles, function(a, b)
        local colorA
        local colorB
        local levelA
        local levelB
        
        for i, color in ipairs(colors) do
            if string.find(a, color) then colorA = i end
            if string.find(b, color) then colorB = i end
        end
        
        for i, level in ipairs(levels) do
            if string.find(a, level) then levelA = i end
            if string.find(b, level) then levelB = i end
        end
        
        if colorA ~= colorB then
            return colorA < colorB
        end
        return levelA < levelB
    end)

    -- Draw specific tiles based on formats
    for _, tileFormat in ipairs(drawnTiles) do
        if tempTiles[tileFormat] and #tempTiles[tileFormat] > 0 then
            local randomIndex = math.random(#tempTiles[tileFormat])
            local selectedGuid = tempTiles[tileFormat][randomIndex]
            table.insert(finalDrawn, selectedGuid)
            table.remove(tempTiles[tileFormat], randomIndex)
        end
    end

    -- Create a table to track placement counts for each color and level
    local placementCounts = {}
    for i, color in ipairs(drawnColors) do
        placementCounts[color] = {
            One = 0,
            Two = 0,
            Three = 0,
            Four = 0
        }
    end
    
    -- Place tiles in organized subgrids
    for i, guid in ipairs(finalDrawn) do
        -- Determine color and level of the tile
        local tileColor, tileLevel = identifyTileProperties(guid)
        
        if tileColor and tileLevel then
            -- Get color index (position in 3x3 grid)
            local colorIndex
            for index, color in ipairs(drawnColors) do
                if color == tileColor then
                    colorIndex = index
                    break
                end
            end
            
            if colorIndex then
                -- Update placement count and get position
                placementCounts[tileColor][tileLevel] = placementCounts[tileColor][tileLevel] + 1
                local levelNum = table.indexOf(levels, tileLevel)
                local row, col = getSubgridPosition(colorIndex, levelNum, placementCounts[tileColor][tileLevel])
                
                -- Place the tile
                local pos = getGridPosition(row, col)
                local obj = myBookkeepingVariables.tileBag.takeObject({
                    guid = guid,
                    position = pos,
                    rotation = {0, 270, 0},
                    smooth = true
                })
                
                -- Handle attachments
                if attachmentItems[guid] then
                    local offsets = {
                        {x = 0, z = 0},      -- Center
                        {x = 0.5, z = 0},    -- Right
                        {x = -0.5, z = 0},   -- Left
                        {x = 0, z = 0.5},    -- Forward
                        {x = 0, z = -0.5}    -- Back
                    }
                    
                    for idx, attachmentGuid in ipairs(attachmentItems[guid]) do
                        local offset = offsets[idx] or offsets[1]
                        local attachPos = {
                            pos[1] + offset.x,
                            pos[2] + 3,
                            pos[3] + offset.z
                        }
                        myBookkeepingVariables.attachmentBag.takeObject({
                            guid = attachmentGuid,
                            position = attachPos,
                            rotation = {0, 270, 0},
                            smooth = true
                        })
                    end
                end
            else
                print("Warning: Color index not found for tile: " .. guid)
            end
        else
            print("Warning: Could not identify properties for tile: " .. guid)
        end
    end
end

----------------------
-- resettiles
----------------------
function resetTiles()
    -- Reset main tiles
    for sectionName, tileList in pairs(allPowerTiles) do
        for _, tileGUID in ipairs(tileList) do
            local obj = getObjectFromGUID(tileGUID)
            if obj then
                myBookkeepingVariables.tileBag.putObject(obj)
            end
        end
    end
    
    -- Reset attachments
    local processedAttachments = {}
    -- Collect all attachment GUIDs
    for _, attachmentList in pairs(attachmentItems) do
        for _, attachmentGUID in ipairs(attachmentList) do
            processedAttachments[attachmentGUID] = true
        end
    end
    
    -- Return all found attachments to the bag
    for attachmentGUID in pairs(processedAttachments) do
        local obj = getObjectFromGUID(attachmentGUID)
        if obj then
            myBookkeepingVariables.attachmentBag.putObject(obj)
        end
    end
end

----------------------
-- object variables
----------------------
levels = {"One", "Two", "Three", "Four"}
colors = {"red", "blue", "white", "black", "green"
    -- "purple", "yellow" 
}
colorHexes = {
    red = "ff0000",
    blue = "0000ff",
    white = "ffffff",
    black = "333333",
    green = "00ff00"
}
allPowerTiles = {
    redOne = {"7e1458", "dc6e9c", "a3edb9", "443a47"}, --charge, --mafdet
    redTwo = {"f298f6", "07eb92", "c804d8", "a3223b"}, -- phoenix, carnage, wyyrt storm, portal
    redThree = {"ca3995", "deaf8e", "b1321a", "56f3f4", "bd1b78", "20138a", "b0b4da"}, -- domination, scarab, divine wound, omniscience, blades, bull, hippo
    redFour = {"d445a2", "580bc5", "a3f1fa", "54965b"}, -- surprise attack, initiaive, scorpid, act of god
    blueOne = {"eb844d", "404ff0", "22d1be", "45668b"}, -- defense, recruiting scribe
    blueTwo = {"0ae747", "12eeec", "eac90c", "1521b7"}, -- shield of neith, reinforcement prayer, shetyw barrier, elephant
    blueThree = {"a8f60a", "35e9e3", "c8c5d0", "496404", "d6621e", "e06be8", "1233c6"}, -- sandworm, spy, perfect arch, defensive victory, domination, legion, widow
    blueFour = {"853180", "81fe6f", "67add3", "0b2857"}, -- divine will, act of god, reinforcements, sphinx
    whiteOne = {"002244", "e0a2cf", "83ca68", "a2ff5a"}, -- priestess, priest
    whiteTwo = {"1f27ae", "9301c6", "8b30dd", "db93a3", "042a45"}, -- vision, magical support, snake, divine boon, anteater
    whiteThree = {"be5bd4", "dc34f0", "273f63", "c28610", "0e24db", "41a764"}, -- strategic hold, divine hunger, night ceremony, dominiation, priest of thoeris, hand of god
    whiteFour = {"dcfe08", "8d090d", "2d2d30", "387b4f"}, -- priest of ra, act of god, mummy, priest of amon
    blackOne = {"c12d97", "604e7e", "7ce540", "221f0d"}, -- sword mercs, spear mercs, local recruit
    blackTwo = {"614d6f", "48d993", "a03e5b", "385c2f", "115cca"}, -- khunm sphinx, dedication to battle, twin cerenomy, honor in battle, spider monkey
    blackThree = {"041c53", "6fc78d", "704ba0", "1b19cc", "bcb4f5", "fbe9c9"}, -- forced march, tactical reinformcnet, divine support, domination, griffin sphinx, deadly trap
    blackFour = {"b11bfc", "fecb26", "7c83e0", "39d539"}, -- soul devorour, divine might, bestial fury, act of god
    greenOne = {"363203", "6925a8", "294419", "70ad9f"}, -- return from beyond, dark cult
    greenTwo = {"75f7bb", "197a5a", "fbd8f8", "139666"}, -- demeaned sphinx, strength drain, dark servants, solar bark
    greenThree = {"975782", "5bb39a", "8635e2", "1ec5b5", "119016", "fee689"}, -- dark knowledge, domination, uncanny reiforncement, death ritual, macabre aspiration, funeral building
    greenFour = {"ff8ff5", "bd8f60", "93f8ab", "f849ab"} -- thoth, aphophis, act of god, putrid power
    --[[ 
    purpleOne = {},
    purpleTwo = {},
    purpleThree = {},
    purpleFour = {},
    yellowOne = {},
    yellowTwo = {},
    yellowThree = {},
    yellowFour = {}
    ]]--
}
attachmentItems = {
    ["f298f6"] = {"3e4b14"},
    ["c804d8"] = {"ba5ce8"},
    ["ca3995"] = {"1496c8"},
    ["deaf8e"] = {"1efdcb"},
    ["20138a"] = {"48513e"},
    ["b0b4da"] = {"46e688"},
    ["d445a2"] = {"082378"},
    ["a3f1fa"] = {"9ba127"},
    ["54965b"] = {"8550dc"},
    ["eac90c"] = {"138013"},
    ["1521b7"] = {"2497d0"},
    ["a8f60a"] = {"649f63"},
    ["d6621e"] = {"f4ab07"},
    ["1233c6"] = {"b137b0"},
    ["853180"] = {"623546"},
    ["81fe6f"] = {"b03291"},
    ["0b2857"] = {"caed09", "2bf12a"},
    ["8b30dd"] = {"74681c"},
    ["042a45"] = {"d96fe1"},
    ["c28610"] = {"574e2a"},
    ["8d090d"] = {"2242cb"},
    ["2d2d30"] = {"da36da"},
    ["c12d97"] = {"2054c6", "f9b0ac", "c57ef5"},
    ["604e7e"] = {"9499de", "d56c17", "7a450b"},
    ["614d6f"] = {"236641"},
    ["a03e5b"] = {"bc58f9"},
    ["115cca"] = {"746184"},
    ["041c53"] = {"26343c"},
    ["1b19cc"] = {"3d3b0f"},
    ["bcb4f5"] = {"fe58d0"},
    ["b11bfc"] = {"d985e3"},
    ["39d539"] = {"ec89f3"},
    ["294419"] = {"4c337e"},
    ["70ad9f"] = {"6ec157"},
    ["75f7bb"] = {"4ca850"},
    ["5bb39a"] = {"b9fd48"},
    ["ff8ff5"] = {"32135b", "1ef9cb"},
    ["bd8f60"] = {"91b99a", "823409"},
    ["93f8ab"] = {"1f2e19"},
    [""] = {""}
}
drafts = {
    red = {
        "redTwo", "redTwo", "redTwo", "redTwo", 
        "redThree", "redThree", "redThree", "redThree",
        "redFour", "redFour", "redFour", "redFour"
    },
    blue = {
        "blueTwo", "blueTwo", "blueTwo", "blueTwo", 
        "blueThree", "blueThree", "blueThree", "blueThree", 
        "blueFour", "blueFour", "blueFour", "blueFour"
    },
    white = {
        "whiteTwo", "whiteTwo", "whiteTwo", "whiteTwo", 
        "whiteThree", "whiteThree", "whiteThree", "whiteThree", 
        "whiteFour", "whiteFour", "whiteFour", "whiteFour"
    },
    green = {
        "greenTwo", "greenTwo", "greenTwo", "greenTwo", 
        "greenThree", "greenThree", "greenThree", "greenThree", 
        "greenFour", "greenFour", "greenFour", "greenFour"
    },
    black = {
        "blackTwo", "blackTwo", "blackTwo", "blackTwo", 
        "blackThree", "blackThree", "blackThree", "blackThree", 
        "blackFour", "blackFour", "blackFour", "blackFour"
    }
    --[[
    purple = {
        "purpleTwo", "purpleTwo", "purpleTwo", "purpleTwo", 
        "purpleThree", "purpleThree", "purpleThree", "purpleThree", 
        "purpleFour", "purpleFour", "purpleFour", "purpleFour"
    },
    yellow = {
        "yellowTwo", "yellowTwo", "yellowTwo", "yellowTwo", 
        "yellowThree", "yellowThree", "yellowThree", "yellowThree", 
        "yellowFour", "yellowFour", "yellowFour", "yellowFour"
    }
    ]]--
    --[[
    xyz = {
        "xyzOne", "xyzOne", "xyzOne", "xyzOne",
        "xyzTwo", "xyzTwo", "xyzTwo", "xyzTwo", 
        "xyzThree", "xyzThree", "xyzThree", "xyzThree", 
        "xyzFour", "xyzFour", "xyzFour", "xyzFour"
    },
    ]]--
}