----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Quest Board")

----------------------
-- variables
----------------------
questDeckGUID = "ff8b6c"
locations = {
    {1.58, 1.60, 29.67},
    {-4.55, 1.60, 29.67},
    {-10.67, 1.60, 29.67}
}

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
    createSetup()
end

function createSetup()
    self.createButton({
        click_function = "setup",
        function_owner = self,
        position = {-1.7, 0.2, 0.8},
        rotation = {0, 0, 0},
        scale = {0.15, 0.15, 0.15},
        width = 2000,
        height = 600,
        font_size = 400,
        color = "Red",
        font_color = "White",
        label = "SETUP",
        tooltip = "Setup Vagabond quests."
    })
end

----------------------
-- main function
----------------------
function setup()
    local deck = getObjectFromGUID(questDeckGUID)
    deck.shuffle()
    for i = 1, 3 do
        deck.takeObject({
            position = locations[i],
            rotation = {0, 0, 0},
            smooth = true
        })
    end

    deleteButton(0) --index 0 is the setup button
end

function deleteButton(i)
    self.removeButton(i)
end

----------------------
-- UI function
----------------------
function toggle_image_alpha(player, value, id)
    local color
    if self.UI.getAttribute(id, "color") == "rgba(1, 1, 1, 1)" then
        color = "rgba(1, 1, 1, 0)"
    else
        color = "rgba(1, 1, 1, 1)"
    end
    self.UI.setAttribute(id, "color", color)
end