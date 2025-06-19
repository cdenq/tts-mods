----------------------
-- Created for Tofu Worldview
-- By tofuwater
----------------------
self.setName("Lilypad Diaspora")

----------------------
-- button variables
----------------------
trackerGUID = "d22dc3"
wait_id = 0

----------------------
-- onload and once functions
----------------------
function onLoad()
    createAllButtons()
    wait_id = Wait.time(updateScore, 1, -1)
end

function onDestroy()
    Wait.stop(wait_id)
    wait_id = nil
end

----------------------
-- create button functions
----------------------
function createAllButtons()
    createScoreButton()
end

function createScoreButton()
    self.createButton({
        click_function = "doNothing",
        function_owner = self,
        position = {0, 0.15, -1},
        width = 0,
        height = 0,
        font_size = 750,
        label = "0"
    })
end

----------------------
-- update functions
----------------------
function updateScore()
    local vpTrackerButtons = getObjectFromGUID(trackerGUID).getButtons()
    local score = vpTrackerButtons[1].label
    local font_color = vpTrackerButtons[1].font_color
    self.editButton({
        index = 0,
        label = score,
        font_color = font_color
    })
end