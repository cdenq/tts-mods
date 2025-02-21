
local CARD_SCALE_XZ = 2.36

local _scriptingZone = false

local pickedUp = false

function onLoad(save_state)
      createScriptingZone()
      Wait.time(resetScriptingZone,0.3)
      createButtons()
      wait_id = Wait.time(updateFox, 1, -1)
      wait_id = Wait.time(updateRabbit, 1, -1)
      wait_id = Wait.time(updateMouse, 1, -1)
end
mouse = 1
rabbit = 1
fox = 1
wait_id = 0


function updateFox()
  fox = 1

  for _, item in ipairs(items) do
    if item.hit_object.tag == "Card" then
        addFox()

    elseif item.hit_object.tag == "Deck" then
        for _, card in ipairs(item.hit_object.getObjects()) do
            addFox()
        end
    end
  end
  if (fox >= 6) then fox = "-" end
  self.editButton({index=0,label=tostring(fox)})

end

function addFox()
  fox = fox + 1
end

function updateRabbit()
  rabbit = 1
  items = Physics.cast({
      origin       = self.positionToWorld({-0.2185, 0.1, 0.105}),
      direction    = self.getTransformUp(),
      type         = 3,
      size         = {3, 0.1, 6},
      max_distance = 2,
  })

  for _, item in ipairs(items) do
    if item.hit_object.tag == "Card" then
        addRabbit()

    elseif item.hit_object.tag == "Deck" then
        for _, card in ipairs(item.hit_object.getObjects()) do
            addRabbit()
        end
    end
  end
  if (rabbit >= 6) then rabbit = "-" end
  self.editButton({index=1,label=tostring(rabbit)})

end

function addRabbit()
  rabbit = rabbit + 1
end

function updateMouse()
  mouse = 1
  items = Physics.cast({
      origin       = self.positionToWorld({-0.2185, 0.1, 0.210 + 0.485}),
      direction    = self.getTransformUp(),
      type         = 3,
      size         = {3, 0.1, 6},
      max_distance = 2,
  })

  for _, item in ipairs(items) do
    if item.hit_object.tag == "Card" then
        addMouse()

    elseif item.hit_object.tag == "Deck" then
        for _, card in ipairs(item.hit_object.getObjects()) do
            addMouse()
        end
    end
  end
  if (mouse >= 6) then mouse = "-" end
  self.editButton({index=2,label=tostring(mouse)})

end

function addMouse()
  mouse = mouse + 1
end



function addCard()
  n = 1;
    suit = suit:lower()
    if suit == "fox" then
        fox = fox +1
    elseif suit == "mouse" then
        mouse = mouse + 1
    elseif suit == "rabbit" then
        rabbit= rabbit + 1
    end
end



function createButtons()
  self.createButton({
    click_function = "nothing",
    function_owner = self,
    label = '1',
    position = {-0.2185, 0.15, -0.475},
    scale = {0.45, 0.00, 0.45},
    width = 0,
    height = 0,
    font_color={1,1,1,1},
    font_size = 120,

})
self.createButton({
    click_function = "nothing",
    function_owner = self,
    label = '1',
    position = {-0.2185, 0.15, 0.105},
    scale = {0.45, 0.00, 0.45},
    width = 0,
    height = 0,
    font_color={1,1,1,1},
    font_size = 120,

})
self.createButton({
    click_function = "nothing",
    function_owner = self,
    label = '1',
    position = {-0.2185, 0.15, 0.210 + 0.48},
    scale = {0.45, 0.00, 0.45},
    width = 0,
    height = 0,
    font_color={1,1,1,1},
    font_size = 120,

})


end



function onPickUp(player_color)
  _scriptingZone = nil
  pickedUp = true
end

function onDrop(playerColor)
    if _scriptingZone == nil then createScriptingZone() end
    Wait.time(resetScriptingZone, 0.3)
    pickedUp = false
end

function onRotate()
    if _scriptingZone == nil and pickedUp == false then createScriptingZone() end
    Wait.time(resetScriptingZone, 0.3)
end

-------------------------------------------------------------------------------

function isRelevantCard(enterObject)
    assert(type(enterObject) == 'userdata')
    return enterObject.tag == 'Card' and enterObject.hasTag("Smallfry")
end

function onObjectEnterScriptingZone(zone, enterObject)
    if not enterObject then
        return
    end
    if zone == _scriptingZone and isRelevantCard(enterObject) then
        enterObject.setScale({
            x = CARD_SCALE_XZ,
            y = 1,
            z = CARD_SCALE_XZ,
        })
    end

    local size = enterObject.getBoundsNormalized().size
end

-------------------------------------------------------------------------------

function createScriptingZone()
    assert(not _scriptingZone)

    local zoneName = self.getGUID() .. ' SCRIPTING ZONE'

    local function getScriptingZone()
        for _, object in ipairs(getAllObjects()) do
            if object.tag == 'Scripting' and object.getName() == zoneName then
                return object
            end
        end
    end

    _scriptingZone = getScriptingZone() or spawnObject({
        type              = 'ScriptingTrigger',
        position          = self.getPosition(),
        rotation          = self.getRotation(),
        sound             = false,
        snap_to_grid      = false
    })
    _scriptingZone.setName(zoneName)

-- Attaching via joint prevents mat from being movable (???).
-- Just reposition zone when mat moves.
function resetScriptingZone()

    local angleY = self.getRotation().y
    local posX = self.getPosition().x
    local posZ = self.getPosition().z

    local angle = -1.18 - (math.pi/180 * angleY) + math.pi

    local offsetX = math.cos(angle) * 2.5
    local offsetZ = math.sin(angle) * 1.5

    local posy = Vector({posX + offsetX,self.getPosition().y,posZ + offsetZ})
    local roty = self.getRotation()

    if _scriptingZone != nil then
      _scriptingZone.setPosition({x = posy.x, y = posy.y, z = posy.z})
      _scriptingZone.setRotation({x = roty.x, y = roty.y, z = roty.z})

      local size = self.getBoundsNormalized().size
      _scriptingZone.setScale({
          x = 3,
          y = 12,  -- 4 is enough, could make larger to be safe
          z = 18,
      })
    end
end