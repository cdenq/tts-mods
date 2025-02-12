-- Starting Object Deleter
-- By ChrismusTime
self.setName("Starting Object Deleter")

------------------------------
-- VARIABLES
------------------------------
local allPieces = {
    red = {"e2f2ca", "84f66e", "6d5f88", "e83f50", "e85ae1"},
    brown = {"8b1aaf", "188b9c", "ea4d2d", "c4d7a2", "c9497c"},
    pink = {"e8286c", "22e756", "319d88", "654782", "853d7d"},
    green = {"7b0936", "96c3d1", "2bbe69", "bbf2a9", "deb6b9"},
    blue = {"d20c01", "4f18c6", "201043", "ea5614", "fad098"},
    orange = {"bca0a8", "21c3ad", "c0d9a8", "2d51fc", "7e55c8"},
    yellow = {"ab9308", "bdab0b", "10ff40", "cb97ca", "e3bae8"},
    white = {"e6ed11", "bea370", "a26a23", "3df2e4", "77f33a"}
}

------------------------------
-- ON LOAD
------------------------------
function onLoad()
    createAllButtons()
end

------------------------------
-- BUTTON FUNCTIONS
------------------------------
function createAllButtons()
    createStartingObjectDeleter()
end

function createStartingObjectDeleter()
    self.createButton({
        click_function = "deleteObjects",
        label = "Remove\nUnused Pieces",
        function_owner = self,
        position = {0, 0.25, 0},
        rotation = {0, 0, 0},
        width = 1500,
        height = 750,
        font_size = 200,
        tooltip = "Delete unused factions' figures and markers."
    })
end

------------------------------
-- ON CLICK FUNCTIONS
------------------------------
function deleteObjects()
    local seatedColors = {}
    local unseatedColors = {}

    -- Check which colors/seats have a player
    for _, color in ipairs({"Red", "Brown", "Pink", "Green", "Blue", "Orange", "Yellow", "White"}) do
        if Player[color].seated then
            table.insert(seatedColors, color:lower())
        else
            table.insert(unseatedColors, color:lower())
        end
    end

    -- Delete objects for unseated colors
    for _, color in ipairs(unseatedColors) do
        if allPieces[color] then
            for _, guid in ipairs(allPieces[color]) do
                local obj = getObjectFromGUID(guid)
                if obj then
                    obj.destroy()
                end
            end
        end
    end

    -- Provide feedback
    local deletedColors = table.concat(unseatedColors, ", ")
    broadcastToAll("Removed unused pieces for: " .. deletedColors, {1, 1, 1})

    -- Remove when done
    self.destroy()
end