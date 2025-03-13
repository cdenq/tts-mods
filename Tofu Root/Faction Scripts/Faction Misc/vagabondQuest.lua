----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Quest Board")

----------------------
-- variables
----------------------
questDeckGUID = "ff8b6c"
relativeLocations = {
    {3.11, 0.11, -0.37},
    {-3.01, 0.11, -0.38},
    {-9.14, 0.11, -0.38}
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
        tooltip = "Sets up the initial 3 Vagabond quests. Used during Setup."
    })
end

----------------------
-- main function
----------------------
function setup()
    local deck = getObjectFromGUID(questDeckGUID)
    deck.shuffle()
    local boardPos = self.getPosition()
    local boardRot = self.getRotation()
    
    for i = 1, 3 do
        local newPos
        if boardRot.y > 170 and boardRot.y < 190 then
            newPos = {
                x = boardPos.x - relativeLocations[i][1],
                y = boardPos.y + relativeLocations[i][2] + 2,
                z = boardPos.z - relativeLocations[i][3]
            } 
        else
            newPos = {
                x = boardPos.x + relativeLocations[i][1],
                y = boardPos.y + relativeLocations[i][2] + 2,
                z = boardPos.z + relativeLocations[i][3]
            } 
        end
        deck.takeObject({
            position = newPos,
            rotation = boardRot,
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