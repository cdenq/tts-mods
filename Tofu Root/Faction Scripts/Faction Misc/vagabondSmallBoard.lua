----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Quest Board")

----------------------
-- Function
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