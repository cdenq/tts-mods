----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Black Market")

----------------------
-- script variables
----------------------
marketLocations = {
    {42.58, 1.60, -2.69},
    {42.61, 1.60, -8.38},
    {42.63, 1.60, -14.17}
}
deckZone = "cf89ff"

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
    createSetup()
end

function createSetup()
    self.createButton({
        click_function = "setup",
        function_owner = self,
        position = {0, -1, 0.3},
        rotation = {0, 0, 180},
        scale = {0.15, 0.15, 0.15},
        width = 2900,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        label = "SETUP",
        tooltip = "Setup Black Market landmark."
    })
end

----------------------
-- functions
----------------------
function setup()
    local objects = getObjectFromGUID(deckZone).getObjects()
    local deck
    for _, obj in ipairs(objects) do
        if obj.type == "Deck" then
            deck = obj
        end
    end
    
    for i = 1, 3 do
        deck.takeObject({
            position = marketLocations[i],
            rotation = {0, 270, 180},
            smooth = true
        })
    end

    deleteButton(0) --index 0 is the setup button
end

function deleteButton(i)
    self.removeButton(i)
end