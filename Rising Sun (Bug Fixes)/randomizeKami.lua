-- Random Kami Picker
-- By ChrismusTime
self.setName("Kami Randomizer")

------------------------------
-- VARIABLES
------------------------------
local kamiTileBagGUID = "84780d"
local shrineLocations = {
    {-15.60, 0.97, 11.89},
    {-10.88, 0.97, 11.89},
    {-6.14, 0.97, 11.89},
    {-1.44, 0.97, 11.89}
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
    createRandomKamiButton()
end

function createRandomKamiButton()
    self.createButton({
        click_function = "randomizeKami",
        label = "Random Kami",
        function_owner = self,
        position = {0, 0.25, 0},
        rotation = {0, 0, 0},
        width = 1500,
        height = 750,
        font_size = 200,
        tooltip = "Randomly place and lock Kami shrines."
    })
end

------------------------------
-- ON CLICK FUNCTIONS
------------------------------
function randomizeKami()
    local kamiBag = getObjectFromGUID(kamiTileBagGUID)
    if kamiBag then
        local kamiTiles = kamiBag.getObjects()
        for i, shrineLocation in ipairs(shrineLocations) do
            if i <= #kamiTiles then
                local kami = kamiBag.takeObject({
                    position = shrineLocation,
                    rotation = {0, 180, 0}
                })
                kami.setLock(true)
            end
        end
        self.destroy()
    else
        print("Kami tile bag not found!")
    end
end