----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Skunk Board")

----------------------
-- Variables
----------------------
deckZone = "cf89ff"
warriorBagGUID = "dd02f9"
boardZone = "29b2c0"

----------------------
-- onload function
----------------------
function onLoad()
    createDrawButton()
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