----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Crow Board")

----------------------
-- Variables
----------------------
deckZone = "cf89ff"
warriorBagGUID = "141966"
boardZone = "29b2c0"
myMarkerGUIDSetup = {
    ["1"] = {
        Fox = "719693", 
        Mouse = "e86e72", 
        Bunny = "adc360", 
        City = "cf8b2b"
    },
    ["2"] = {
        Fox = "0d6440", 
        Mouse = "22dfdb", 
        Bunny = "494e8e", 
        City = "3b273b"
    },
    ["3"] = {
        Fox = "755d72", 
        Mouse = "d50532", 
        Bunny = "dae872", 
        City = "62623a"
    },
    ["4"] = {
        Fox = "3fc03b", 
        Mouse = "e658d1", 
        Bunny = "9ac91f", 
        City = "696b6b"
    },
    ["5"] = {
        Fox = "bba94c", 
        Mouse = "72b139", 
        Bunny = "615708", 
        City = "461ce6"
    },
    ["6"] = {
        Fox = "0f7cd3", 
        Mouse = "486757", 
        Bunny = "72b88f", 
        City = "e4e4ba"
    },
    ["7"] = {
        Fox = "b416fe", 
        Mouse = "ca801a", 
        Bunny = "0292d9", 
        City = "314295"
    },
    ["8"] = {
        Fox = "e100a2", 
        Mouse = "794202", 
        Bunny = "803f2a", 
        City = "efd2fb"
    },
    ["9"] = {
        Fox = "b248e7", 
        Mouse = "df3642", 
        Bunny = "03a05d", 
        City = "30b6be"
    },
    ["10"] = {
        Fox = "ada1c4", 
        Mouse = "4e65f9", 
        Bunny = "650767", 
        City = "4347ab"
    },
    ["11"] = {
        Fox = "705560", 
        Mouse = "38724c", 
        Bunny = "836f9f", 
        City = "a0de20"
    },
    -- ["13"] = {},
    -- ["14"] = {},
    -- ["15"] = {},
    ["12"] = {
        Fox = "2f2cb5", 
        Mouse = "3de9f7", 
        Bunny = "f58018", 
        City = "1b3b99"
    }
}
myColors = {
    fox = {0.886, 0.318, 0.204},
    mouse = {0.945, 0.573, 0.380},
    bunny = {0.941, 0.843, 0.376}
}
myButtons = {
    xShift = 0.24,
    Fox = {
        label = "FOX",
        clickFunction = "recruitFox",
        color = myColors.fox
    },
    Mouse = {
        label = "MOUSE",
        clickFunction = "recruitMouse",
        color = myColors.mouse
    },
    Bunny = {
        label = "BUNNY",
        clickFunction = "recruitBunny",
        color = myColors.bunny
    }
}
myIterations = {"Fox", "Mouse", "Bunny"}
cityInPlay = false

----------------------
-- onload function
----------------------
function onLoad()
    createDrawButton()
    createRecruitButton()
end

----------------------
-- create button functions
----------------------
function createDrawButton()
    self.createButton({
        click_function = "draw",
        function_owner = self,
        label = "DRAW CARD",
        position = { - 1.01, 0.25, 0.93},
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

function createRecruitButton()
    for i, button in ipairs(myIterations) do 
        self.createButton({
            click_function = myButtons[button].clickFunction,
            function_owner = self,
            label = "RECRUIT " .. myButtons[button].label,
            position = {
                -0.64 + myButtons.xShift * (i-1), 
                0.25, 
                -0.075
            },
            rotation = {0, 0, 0},
            scale = {0.04, 0.04, 0.04},
            width = 2800,
            height = 550,
            font_size = 400,
            color = myButtons[button].color,
            font_color = {0, 0, 0},
            tooltip = "Recruits warriors to every " .. button .. " clearing."
        })
    end
end

----------------------
-- on click functions
----------------------
for i, value in ipairs(myIterations) do
    _G["recruit" .. value] = function(obj, color, alt_click)
        recruit(value, color)
    end
end

----------------------
-- main functions
----------------------
function draw(obj, color)
    local objInZone = getObjectFromGUID(deckZone).getObjects()
    for _, obj in ipairs(objInZone) do
        if obj.tag == "Deck" or obj.tag == "Card" then
            getObjectFromGUID(obj.guid).deal(1, color)
        end
    end
end

function checkCity()
    local cityClearing
    for clearingNum, clearing in pairs(myMarkerGUIDSetup) do
        cityClearing = getObjectFromGUID(clearing["City"])
        if cityClearing then
            break
        end
    end
    print(cityClearing.getGUID())

    local boardZoneObj = getObjectFromGUID(boardZone)
    for _, obj in ipairs(boardZoneObj.getObjects()) do
        if obj.getGUID() == cityClearing.getGUID() then
            cityInPlay = true
            return
        end
    end
    cityInPlay = false
end

function recruit(value, color)
    checkCity()
    print(cityInPlay)
    local warriorBagObj = getObjectFromGUID(warriorBagGUID)
    
    local recruiters = {}
    for clearingNum, clearing in pairs(myMarkerGUIDSetup) do
        local suitedClearing = getObjectFromGUID(clearing[value])
        local cityClearing = getObjectFromGUID(clearing["City"])
        if cityClearing and cityInPlay then
            table.insert(recruiters, cityClearing)
        elseif suitedClearing then
            table.insert(recruiters, suitedClearing)
        end
    end

    if #recruiters == 0 then
        broadcastToAll("No " .. value .. " matching markers found on the map.", color)
        return
    elseif warriorBagObj.getQuantity() == 0 then
        broadcastToAll("No more warriors to place.", color)
        return
    elseif warriorBagObj.getQuantity() < #recruiters then
        broadcastToAll("Not enough warriors to auto-place. You need to add " .. #recruiters .. " warriors but only have " .. warriorBagObj.getQuantity() .. " left.", color)
        return
    else
        local totalWarriors = 0
        for _, recruiter in ipairs(recruiters) do
            local recruiterPosition = recruiter.getPosition()

            local warriorPosition = {
                x = recruiterPosition.x,
                y = recruiterPosition.y + 4,
                z = recruiterPosition.z
            }

            warriorBagObj.takeObject({
                position = warriorPosition,
                rotation = {0, 0, 0}
            })
            totalWarriors = totalWarriors + 1
        end
        
        printToAll(Player[color].steam_name .. " recruits " .. totalWarriors .. " warriors to " .. value .. " clearings in Birdsong.", color)
    end
end