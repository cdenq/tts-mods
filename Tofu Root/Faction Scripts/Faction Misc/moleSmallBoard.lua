----------------------
-- Edited for Tofu Worldview
-- Original by Root mod
-- Changes by cdenq
----------------------
self.setName("Tofu Mole Helper Board")

----------------------
-- Functions
----------------------
function toggle_image_alpha(player, value, id)
    if value ~= "-1" then
        local sepiaColor = "rgba(0.64, 0.45, 0.26, 1)"
        self.UI.setAttribute(id, "color", sepiaColor)
    else
        local color = (self.UI.getAttribute(id, "color") == "rgba(1, 1, 1, 1)") and "rgba(1, 1, 1, 0)" or "rgba(1, 1, 1, 1)"
        self.UI.setAttribute(id, "color", color)
    end
end