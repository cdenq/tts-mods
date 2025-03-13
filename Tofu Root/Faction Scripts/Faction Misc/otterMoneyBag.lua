----------------------
-- Tofu Tumble
-- By tofuwater
----------------------
self.setName("Otter Money")

----------------------
-- onload function
----------------------
function onLoad()
end

----------------------
-- functions
----------------------
function onObjectLeaveContainer(container, object)
    if container == self then
        local temp = object.clone({
            position = {132.92, 2.13, -57.55} --this is in the GM hidden zone
        })
        container.putObject(temp)
        self.shuffle()
    end
end