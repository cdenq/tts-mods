----------------------
-- Made for Tofu Worldview
-- By cdenq
----------------------

----------------------
-- Variables
----------------------
coffinObjGUID = "fc47b2"
coffinObj2GUID = "bf44eb"

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
        tooltip = "Click to turn on automatic Coffin Makers tracking; it is currently turned OFF."
    })
end

----------------------
-- on click functions
----------------------
function toggleMode(obj, color, alt_click)
    local coffinObj = getObjectFromGUID(coffinObjGUID)

    if coffinObj then
        coffinObj.setState(2)
        broadcastToAll(Player[color].steam_name .. " plays Coffin Makers!", color)
        onButton()
    else
        coffinObj = getObjectFromGUID(coffinObj2GUID)
        coffinObj.setState(1)
        broadcastToAll(Player[color].steam_name .. " loses Coffin Makers.", color)
        offButton()
    end
end

function offButton()
    self.editButton({
        index = 0,
        label = "OFF",
        color = "Red",
        tooltip = "Click to turn on automatic Coffin Makers tracking; it is currently turned OFF."
    })
end

function onButton()
    self.editButton({
        index = 0,
        label = "ON",
        color = "Green",
        tooltip = "Click to turn off automatic Coffin Makers tracking; it is currently turned ON."
    })
end