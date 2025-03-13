----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Otter Board")

----------------------
-- Variables
----------------------
deckZone = "cf89ff"
boardZone = "29b2c0"
factionBoardGUID = "4a4924"
warriorBagGUID = "bfe555"
keyWordTradePost = "otterPiece"
myButtons = {
    zShift = 0.09,
    fund = {
        label = "ADD WARRIORS",
        clickFunction = "protectionism",
        tooltip = "Adds 2 warriors to your Payments if you have no Payments. Use for Protectionism during Birdsong."
    },
    score = {
        label = "COUNT FUNDS",
        clickFunction = "checkDividends",
        tooltip = "Counts the number of points you would get off of Funds. Use for Score Dividends during Birdsong."
    },
    gather = {
        label = "GATHER",
        clickFunction = "gather",
        tooltip = "Gathers all warriors into your Funds section. Use for Gather Funds during Birdsong."
    }
}
myIterations = {"fund", "score", "gather"}

----------------------
-- onload functions
----------------------
function onLoad()
    createAllButtons()
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createDrawButton()
    createAutoButtons()
end

function createDrawButton()
    self.createButton({
        click_function = "draw",
        function_owner = self,
        label = "DRAW CARD",
        position = {-0.5, 0.25, 0.375},
        rotation = {0, 0, 0},
        scale = {0.05, 0.05, 0.05},
        width = 2800,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        tooltip = "Draw 1 card from the Deck."
    })
end

function createAutoButtons()
    for i, button in ipairs(myIterations) do
        self.createButton({
            click_function = myButtons[button].clickFunction,
            function_owner = self,
            label = myButtons[button].label,
            position = {
                -0.6, 
                0.25, 
                -0.3 + myButtons.zShift * (i-1)
            },
            rotation = {0, 0, 0},
            scale = {0.04, 0.05, 0.035},
            width = 2900,
            height = 600,
            font_size = 400,
            color = "Red",
            font_color = "White",
            tooltip = myButtons[button].tooltip
        })
    end
end

----------------------
-- on click functions
----------------------
function draw(obj, color, alt_click)
    local objInZone = getObjectFromGUID(deckZone).getObjects()
    for _, obj in ipairs(objInZone) do
        if obj.tag == "Deck" or obj.tag == "Card" then
            getObjectFromGUID(obj.guid).deal(1, color)
        end
    end
end

function checkDividends(obj, color, alt_click)
    if checkTradePosts() then
        local points = math.floor(checkFunds() / 2)
        printToAll(Player[color].steam_name .. " would gain " .. points .. " point(s) in Birdsong from Dividends.", color)
    else 
        broadcastToAll(Player[color].steam_name .. " has no Trade Posts to score Dividends.", color)
    end
end

function protectionism(obj, color, alt_click)
    if checkPayments() == 0 then
        move2Warriors(color)
        printToAll(Player[color].steam_name .. " triggers protectionism.", color)
    end
end

function move2Warriors(color)
    local warriorBagObj = getObjectFromGUID(warriorBagGUID)
    local factionBoard = getObjectFromGUID(factionBoardGUID)
    local factionBoardPos = factionBoard.getPosition()
    local factionBoardRot = factionBoard.getRotation()
    local xShift = {-0.94, -2.18}

    if warriorBagObj.getQuantity() == 0 then
        broadcastToAll("No more warriors to place into Payments.", color)
        return
    elseif warriorBagObj.getQuantity() < 2 then
        broadcastToAll("Not enough warriors to auto-place. You need to add 2 warriors but only have " .. warriorBagObj.getQuantity() .. " left.", color)
        return
    else
        local mod
        if factionBoardRot.y < 190 and factionBoardRot.y > 170 then
            mod = -1
        else 
            mod = 1
        end 
        for i, v in ipairs(xShift) do
            warriorBagObj.takeObject({
                position = {
                    x = factionBoardPos.x + v * mod,
                    y = factionBoardPos.y + 3,
                    z = factionBoardPos.z - (2.38 * mod)
                },
                rotation = factionBoardRot
            })
        end
    end
end

function checkPayments()
    local factionBoard = getObjectFromGUID(factionBoardGUID)
    local factionBoardPos = factionBoard.getPosition()
    local factionBoardRot = factionBoard.getRotation()
    local zoneSize = {
        x = 5.16, 
        y = 1.00, 
        z = 2.90
    }

    local newPos
    if factionBoardRot.y < 190 and factionBoardRot.y > 170 then
        newPos = {
            x = factionBoardPos.x + 1.47, 
            y = factionBoardPos.y + 0.73, 
            z = factionBoardPos.z + 2.39
        }
    else
        newPos = {
            x = factionBoardPos.x - 1.47, 
            y = factionBoardPos.y + 0.73, 
            z = factionBoardPos.z - 2.39
        }
    end

    local hitList = Physics.cast({
        origin = newPos,
        direction = {0, 1, 0},
        type = 3,
        size = zoneSize,
        max_distance = 2
        --debug = true
    })
    
    local totalPayments = 0
    for _, hit in ipairs(hitList) do
        local obj = hit.hit_object
        if obj.type == "Figurine" then
            totalPayments = totalPayments + 1
        end
    end

    return totalPayments
end

function checkFunds()
    local factionBoard = getObjectFromGUID(factionBoardGUID)
    local factionBoardPos = factionBoard.getPosition()
    local factionBoardRot = factionBoard.getRotation()
    local zoneSize = {
        x = 5.16,
        y = 1.00, 
        z = 4.74
    }

    local newPos
    if factionBoardRot.y < 190 and factionBoardRot.y > 170 then
        newPos = {
            x = factionBoardPos.x + 1.47, 
            y = factionBoardPos.y + 0.73, 
            z = factionBoardPos.z - 2.39
        }
    else
        newPos = {
            x = factionBoardPos.x - 1.51, 
            y = factionBoardPos.y + 0.73, 
            z = factionBoardPos.z + 2.39
        }
    end

    local hitList = Physics.cast({
        origin = newPos,
        direction = {0, 1, 0},
        type = 3,
        size = zoneSize,
        max_distance = 2
        --debug = true
    })
    
    local totalFunds = 0
    for _, hit in ipairs(hitList) do
        local obj = hit.hit_object
        if obj.type == "Figurine" then
            totalFunds = totalFunds + 1
        end
    end

    return totalFunds
end


function checkTradePosts()
    local boardZoneObj = getObjectFromGUID(boardZone)
    
    for _, obj in ipairs(boardZoneObj.getObjects()) do
        if obj.type == "Token" or obj.type == "Tile" then
            local notes = obj.getGMNotes()
            if notes == keyWordTradePost then
                return true
            end
        end
    end
    return false
end

function gather()
    local totalWarriors = getAllFigurinesOnBoard()
    if #totalWarriors > 0 then
        placeItemsInGrid(totalWarriors)
    end
end

function getAllFigurinesOnBoard()
    local factionBoard = getObjectFromGUID(factionBoardGUID)
    local factionBoardPos = factionBoard.getPosition()
    local zoneSize = {x = 18, y = 5, z = 15}

    local hitList = Physics.cast({
        origin = factionBoardPos,
        direction = {0, 1, 0},
        type = 3,
        size = zoneSize,
        max_distance = 2
        --debug = true
    })
    
    local totalWarriors = {}
    for _, hit in ipairs(hitList) do
        local obj = hit.hit_object
        if obj.type == "Figurine" then
            local notes = obj.getGMNotes() or ""
            if string.find(notes, "Warrior") then
                table.insert(totalWarriors, obj)
            end
        end
    end
    return totalWarriors
end

function placeItemsInGrid(items)
    local factionBoard = getObjectFromGUID(factionBoardGUID)
    local factionBoardPos = factionBoard.getPosition()
    local factionBoardRot = factionBoard.getRotation()

    local centerPosition
    if factionBoardRot.y < 190 and factionBoardRot.y > 170 then
        centerPosition = {
            x = factionBoardPos.x + 1.51, 
            y = factionBoardPos.y + 0.73, 
            z = factionBoardPos.z - 2.18
        }
    else
        centerPosition = {
            x = factionBoardPos.x - 1.51, 
            y = factionBoardPos.y + 0.73, 
            z = factionBoardPos.z + 2.18
        }
    end
    
    local zoneWidth = 5.17
    local zoneLength = 4.74
    local itemCount = #items
    
    local gridColumns = math.ceil(math.sqrt(itemCount))
    local gridRows = math.ceil(itemCount / gridColumns)
    local itemBounds = items[1].getBoundsNormalized()
    local itemWidth = itemBounds.size.x
    local itemLength = itemBounds.size.z
    local maxCols = math.floor(zoneWidth / itemWidth)
    local maxRows = math.floor(zoneLength / itemLength)
    
    if maxCols * maxRows < itemCount then
        itemCount = math.min(itemCount, maxCols * maxRows)
    end
    
    if gridColumns > maxCols then
        gridColumns = maxCols
        gridRows = math.ceil(itemCount / gridColumns)
    end
    if gridRows > maxRows then
        gridRows = maxRows
        gridColumns = math.ceil(itemCount / gridRows)
    end
    
    local spacingX = zoneWidth / gridColumns
    local spacingZ = zoneLength / gridRows
    
    local gridWidthTotal = spacingX * gridColumns
    local gridLengthTotal = spacingZ * gridRows
    
    local startX = centerPosition.x - (gridWidthTotal / 2) + (spacingX / 2)
    local startZ = centerPosition.z - (gridLengthTotal / 2) + (spacingZ / 2)
    
    local itemIndex = 1
    for row = 1, gridRows do
        for col = 1, gridColumns do
            if itemIndex <= itemCount then
                local item = items[itemIndex]
                
                local posX = startX + (col-1) * spacingX
                local posZ = startZ + (row-1) * spacingZ
                
                local currentPos = item.getPosition()
                
                item.setPositionSmooth({x = posX, y = currentPos.y, z = posZ})
                item.setRotationSmooth(factionBoardRot)
                
                itemIndex = itemIndex + 1
            else
                break
            end
        end
    end
end