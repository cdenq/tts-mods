----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Tofu Rat Helper Board")

----------------------
-- Function
----------------------
function toggle_image_alpha(player, value, id)
    if value ~= "-1" then
        self.UI.setAttribute(id, "color", "rgba(1, 1, 1, 0)")
    else
        local color
        if self.UI.getAttribute(id, "color") == "rgba(1, 1, 1, 1)" then
            color = "rgba(0.64, 0.45, 0.26, 1)"
        else
            color = "rgba(1, 1, 1, 1)"
        end
        self.UI.setAttribute(id, "color", color)
    end
end