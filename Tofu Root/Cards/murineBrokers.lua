----------------------
-- Made for Tofu Worldview
-- By cdenq
----------------------

----------------------
-- Variables
----------------------
mySupplyGUIDSetup = {
    bag1 = "233b57",
    bag2 = "8cff64",
    boot1 = "473549",
    boot2 = "d50954",
    cross = "a13ed6",
    hammer = "27b19b",
    sword1 = "e0e2a9",
    sword2 = "269d59",
    tea1 = "ce1584",
    tea2 = "4fc243",
    coin1 = "00763e",
    coin2 = "76a02d"
}
forgeZoneGUID = "5c3c27"
boardZoneGUID = "29b2c0"
currentItemCount = 0
wait_id = nil
playerName = ""
playerColor = "White"

----------------------
-- onload function
----------------------
function onLoad()
    createActivateButton()
end

----------------------
-- create button functions
----------------------
function createActivateButton()
    self.createButton({
        click_function = "toggleMode",
        function_owner = self,
        label = "OFF",
        position = {0, 0.25, -1.25},
        rotation = {0, 0, 0},
        scale = {0.5, 0.5, 0.5},
        width = 600,
        height = 200,
        font_size = 150,
        color = "Red",
        font_color = "White",
    })
end

----------------------
-- on click functions
----------------------
function toggleMode(obj, color, alt_click)
    playerName = Player[color].steam_name
    playerColor = color
    if wait_id then 
        Wait.stop(wait_id)
        offButton()
        broadcastToAll(playerName .. " loses Murine Brokers.", playerColor)
    else
        onButton()
        broadcastToAll(playerName .. " plays Murine Brokers!", playerColor)
        currentItemCount = checkItems()
        wait_id = Wait.time(updateItems, 3, -1)
    end
end

function updateItems()
    local lastItemCount = currentItemCount
    currentItemCount = checkItems()
    if lastItemCount ~= currentItemCount then
        broadcastToAll(playerName .. " might draw 1 card from Murine Brokers!", playerColor)
    end
end

function checkItems()
    local forgeZoneObjs = getObjectFromGUID(forgeZoneGUID).getObjects()
    local boardZoneObjs = getObjectFromGUID(boardZoneGUID).getObjects()
    local items = 0

    for k, v in pairs(mySupplyGUIDSetup) do
        for i, obj in ipairs(forgeZoneObjs) do
            if obj.getGUID() == v then
                items = items + 1
            end
        end
        for i, obj in ipairs(boardZoneObjs) do
            if obj.getGUID() == v then
                items = items + 1
            end
        end
    end

    return items
end

function offButton()
    self.editButton({
        index = 0,
        label = "OFF",
        color = "Red"
    })
end

function onButton()
    self.editButton({
        index = 0,
        label = "ON",
        color = "Green"
    })
end

function onDestroy()
    if wait_id then
        Wait.stop(wait_id)
    end
end