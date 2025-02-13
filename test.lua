self.setName("ADSET Faction Selector 6 ENG")

function onLoad()
    bagMarchesa = getObjectFromGUID(bagMarchesa_GUID)
    bagAquile = getObjectFromGUID(bagAquile_GUID)
    bagAlleanza = getObjectFromGUID(bagAlleanza_GUID)
    bagVagabondo = getObjectFromGUID(bagVagabondo_GUID)
    bagVagabondo2 = getObjectFromGUID(bagVagabondo2_GUID)
    bagScartiVagabondo = getObjectFromGUID(bagScartiVagabondo_GUID)
    bagScartiVagabondo2 = getObjectFromGUID(bagScartiVagabondo2_GUID)
    bagLucertole = getObjectFromGUID(bagLucertole_GUID)
    bagCompagnia = getObjectFromGUID(bagCompagnia_GUID)
    bagCorvi = getObjectFromGUID(bagCorvi_GUID)
    bagDucato = getObjectFromGUID(bagDucato_GUID)
    bagKeepers = getObjectFromGUID(bagKeepers_GUID)
    bagHundreds = getObjectFromGUID(bagHundreds_GUID)
    lizardBag = getObjectFromGUID(lizardBag_GUID)

    self.setLock(true)
    --self.interactable = true

    -- marchesa button

    self.createButton({click_function = "marchesa", function_owner = self, label = "",
        position = { - 1.405, 0.25, - 0.55}, rotation = {0, 0, 0}, scale = {0.25, 0.25, 0.25},
    width = 1750, height = 400, color = {255, 255, 255, 0}, })

    -- aquile button

    self.createButton({click_function = "aquile", function_owner = self, label = "",
        position = { - 0.463, 0.25, - 0.55}, rotation = {0, 0, 0}, scale = {0.25, 0.25, 0.25},
    width = 1750, height = 400, color = {255, 255, 255, 0}, })

    -- alleanza button

    self.createButton({click_function = "alleanza", function_owner = self, label = "",
        position = {0.468, 0.25, - 0.55}, rotation = {0, 0, 0}, scale = {0.25, 0.25, 0.25},
    width = 1750, height = 400, color = {255, 255, 255, 0}, })

    -- vagabondo button

    self.createButton({click_function = "vagabondo", function_owner = self, label = "",
        position = { 1.40, 0.25, - 0.55}, rotation = {0, 0, 0}, scale = {0.25, 0.25, 0.25},
    width = 1750, height = 400, color = {255, 255, 255, 0}, })

    -- compagnia del fiume button

    self.createButton({click_function = "compagnia", function_owner = self, label = "",
        position = { - 1.405, 0.25, 0.02}, rotation = {0, 0, 0}, scale = {0.25, 0.25, 0.25},
    width = 1750, height = 400, color = {255, 255, 255, 0}, })

    -- lucertole button

    self.createButton({click_function = "lucertole", function_owner = self, label = "",
        position = { - 0.463, 0.25, 0.02}, rotation = {0, 0, 0}, scale = {0.25, 0.25, 0.25},
    width = 1750, height = 400, color = {255, 255, 255, 0}, })

    -- ducato sotterraneo button

    self.createButton({click_function = "ducato", function_owner = self, label = "",
        position = { 0.468, 0.25, 0.02}, rotation = {0, 0, 0}, scale = {0.25, 0.25, 0.25},
    width = 1750, height = 400, color = {255, 255, 255, 0}, })

    -- cospirazione corvi button

    self.createButton({click_function = "corvi", function_owner = self, label = "",
        position = { 1.40, 0.25, 0.02}, rotation = {0, 0, 0}, scale = {0.25, 0.25, 0.25},
    width = 1750, height = 400, color = {255, 255, 255, 0}, })

    -- keepers in iron

    self.createButton({click_function = "keepers", function_owner = self, label = "",
        position = { - 1.405, 0.25, 0.55}, rotation = {0, 0, 0}, scale = {0.25, 0.25, 0.25},
    width = 1750, height = 400, color = {255, 255, 255, 0}, })

    -- lord of hundreds

    self.createButton({click_function = "hundreds", function_owner = self, label = "",
        position = { - 0.463, 0.25, 0.55}, rotation = {0, 0, 0}, scale = {0.25, 0.25, 0.25},
    width = 1750, height = 400, color = {255, 255, 255, 0}, })


end -- onLoad end

bagMeeple3D_GUID = 'b18254'
bagMeepleFlat_GUID = 'e1eda2'
bagMeepleStand_GUID = 'e5a761'
bagMarchesa_GUID = '9fb26f'
bagAquile_GUID = 'c27d87'
bagAlleanza_GUID = '538322'
bagVagabondo_GUID = '5ac796'
bagVagabondo2_GUID = 'e6f43a'
bagScartiVagabondo_GUID = '33c61c'
bagScartiVagabondo2_GUID = 'ea20cf'
bagLucertole_GUID = 'ede539'
bagCompagnia_GUID = '0e1e03'
bagCorvi_GUID = '794b4c'
bagDucato_GUID = '857add'
bagKeepers_GUID = '01ebb5'
bagHundreds_GUID = '6074cd'
setupChecker_GUID = '6231c5'
bag3DMarchesa_GUID = 'f583f3'
bag3DAlleanza_GUID = '1dfcf8'
bag3DAquile_GUID = '2d832b'
bag3DCompagnia_GUID = '7eb863'
bag3DLucertole_GUID = '0845b5'
bag3DDucato_GUID = '626d96'
lizardBag_GUID = '7e06b9'

-- delete tile faction selector

function deleteMe()
    self.destruct()
end

-- marchesa Setup

function marchesa(obj, color)
        if Global.getVar("marchesa") then
        printToColor("Faction already selected by another player, or the faction of the Mechanical Marquise has already been chosen and cannot coexist with this one as one replaces the other, or this faction is one of the Hireling factions.", color, "Yellow")
    else
        if Global.getVar("trueBuilding") then bagMarchesa = getObjectFromGUID(bag3DMarchesa_GUID) end
        local x = 0
        local posPlayerBoard = self.positionToWorld({0, 0, 0})
        local posMigliorie = self.positionToWorld({ - 1.8, 0, - 0.07})
        local posBagWood = self.positionToWorld({ - 1, 0, - 1.2})
        local posFortezza = self.positionToWorld({ - 0.6, 0, - 1.2})
        local posPv = self.positionToWorld({ - 0.2, 0, - 1.2})
        local posPvCounter = self.positionToWorld({ - 1.8, 0, - 1.38})
        local posBagMeeple = self.positionToWorld({ 1, 0, - 1.31})
        local rotSpawn = self.getRotation()
        local count = Global.getVar("ready")
        local count = count + 1
        Global.setVar("ready", count)
        Global.setVar("marchesa", true)
        self.destruct()
        bagMarchesa.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagMarchesa.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagMarchesa.takeObject({position = posBagWood, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagMarchesa.takeObject({position = posFortezza, rotation = rotSpawn, smooth = false})
        bagMarchesa.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
        bagMarchesa.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        -- segheria tokens positioning
        for i = 1, 6 do
            local segheria = self.positionToWorld({ - 0.04 + x, 0.3, - 0.14})
            bagMarchesa.takeObject({position = segheria, rotation = rotSpawn, smooth = false})
            x = x - 0.194
        end
        -- officina tokens positioning
        local x = 0
        for i = 1, 6 do
            local officina = self.positionToWorld({ - 0.04 + x, 0.3, 0.06})
            bagMarchesa.takeObject({position = officina, rotation = rotSpawn, smooth = false})
            x = x - 0.194
        end
        -- avamposto tokens positioning
        local x = 0
        for i = 1, 6 do
            local avamposto = self.positionToWorld({ - 0.04 + x, 0.3, 0.26})
            bagMarchesa.takeObject({position = avamposto, rotation = rotSpawn, smooth = false})
            x = x - 0.194
        end
        -- meeple bag positioning
        if Global.getVar("trueMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeeple3D_GUID)
            bagMeeple = 'fae05e'
            else if Global.getVar("flatMeeple") == true then
                bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
                bagMeeple = '8805aa'
            else
                bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
                bagMeeple = 'ffa850'
            end
        end
        bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = {0, 180, 0}, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    end
end

-- aquile Setup

function aquile(obj, color)
        if Global.getVar("aquile") then
        printToColor("Faction already selected by another player, or the faction of the Electric Eyrie has already been chosen and cannot coexist with this one as one replaces the other, or this faction is one of the Hireling factions.", color, "Yellow")
    else
        if Global.getVar("trueBuilding") then bagAquile = getObjectFromGUID(bag3DAquile_GUID) end
        local x = 0
        local posPlayerBoard = self.positionToWorld({0, 0, 0})
        local posMigliorie = self.positionToWorld({ - 1.8, 0, - 0.07})
        local posLeaders = self.positionToWorld({ 1.95, 0, 0})
        local posDecreto = self.positionToWorld({ 0, 0, - 2.05})
        local posLeader1 = self.positionToWorld({ 2.255, 0.6, - 0.32})
        local posLeader2 = self.positionToWorld({ 1.645, 0.6, - 0.32})
        local posLeader3 = self.positionToWorld({ 2.255, 0.6, 0.509})
        local posLeader4 = self.positionToWorld({ 1.645, 0.6, 0.509})
        local visir1 = self.positionToWorld({ 1.645, 0.6, - 1.9})
        local visir2 = self.positionToWorld({ 1.745, 0.6, - 2.1})
        local posPv = self.positionToWorld({ 0, 0, - 1.2})
        local posPvCounter = self.positionToWorld({ - 1.8, 0, - 1.38})
        local posBagMeeple = self.positionToWorld({ 1.95, 0, - 1.2})
        local rotSpawn = self.getRotation()
        local count = Global.getVar("ready")
        local count = count + 1
        Global.setVar("ready", count)
        Global.setVar("aquile", true)
        self.destruct()
        bagAquile.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagAquile.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagAquile.takeObject({position = posLeaders, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagAquile.takeObject({position = posDecreto, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagAquile.takeObject({position = posLeader1, rotation = rotSpawn, smooth = false})
        bagAquile.takeObject({position = posLeader2, rotation = rotSpawn, smooth = false})
        bagAquile.takeObject({position = posLeader3, rotation = rotSpawn, smooth = false})
        bagAquile.takeObject({position = posLeader4, rotation = rotSpawn, smooth = false})
        bagAquile.takeObject({position = visir1, rotation = rotSpawn, smooth = false})
        bagAquile.takeObject({position = visir2, rotation = rotSpawn, smooth = false})
        bagAquile.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
        bagAquile.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        -- trespoli tokens positioning
        for i = 1, 7 do
            local trespoli = self.positionToWorld({ - 0.005 + x, 0.3, - 0.082})
            bagAquile.takeObject({position = trespoli, rotation = rotSpawn, smooth = false})
            x = x - 0.1769
        end
        -- meeple bag positioning
        if Global.getVar("trueMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeeple3D_GUID)
            bagMeeple = 'f082cf'
            else if Global.getVar("flatMeeple") == true then
                bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
                bagMeeple = '74a102'
            else
                bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
                bagMeeple = '5752ee'
            end
        end
        bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = {0, 240, 0}, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    end
end

-- alleanza Setup

function alleanza(obj, color)
        if Global.getVar("alleanza") then
        printToColor("Faction already selected by another player, or the faction of the Automated Alliance has already been chosen and cannot coexist with this one as one replaces the other, or this faction is one of the Hireling factions.", color, "Yellow")
    else
        if Global.getVar("trueBuilding") then bagAlleanza = getObjectFromGUID(bag3DAlleanza_GUID) end
        local x = 0
        local posPlayerBoard = self.positionToWorld({0, 0, 0})
        local posMigliorie = self.positionToWorld({ - 1.8, 0, - 0.07})
        local posPv = self.positionToWorld({ 0, 0, - 1.2})
        local posPvCounter = self.positionToWorld({ - 0.9, 0, - 1.31})
        local posBagMeeple = self.positionToWorld({ 1, 0, - 1.31})
        local posHandZone = self.positionToWorld({0, 0, 0})
        local rotSpawn = self.getRotation()
        local count = Global.getVar("ready")
        local count = count + 1
        Global.setVar("ready", count)
        Global.setVar("alleanza", true)
        self.destruct()
        bagAlleanza.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagAlleanza.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagAlleanza.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
        bagAlleanza.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })

        -- basi tokens positioning
        for i = 1, 3 do
            local basi = self.positionToWorld({ 0.1484 + x, 0.3, 0.189})
            bagAlleanza.takeObject({position = basi, rotation = rotSpawn, smooth = false})
            x = x - 0.1725
        end
        -- consenso tokens (0->5) positioning
        local x = 0
        for i = 1, 5 do
            local consenso = self.positionToWorld({ 0.458 + x, 0.3, 0.73})
            bagAlleanza.takeObject({position = consenso, rotation = rotSpawn, smooth = false})
            x = x - 0.342
        end
        -- consenso tokens (5->10) positioning
        local x = 0
        for i = 1, 5 do
            local consenso = self.positionToWorld({ 0.287 + x, 0.3, 0.652})
            bagAlleanza.takeObject({position = consenso, rotation = rotSpawn, smooth = false})
            x = x - 0.342
        end
        -- meeple bag positioning
        if Global.getVar("trueMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeeple3D_GUID)
            bagMeeple = '2ee358'
            else if Global.getVar("flatMeeple") == true then
                bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
                bagMeeple = '2bbdf3'
            else
                bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
                bagMeeple = 'ebc24d'
            end
        end
        bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = {0, 180, 0}, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        local angleY = Player[color].getHandTransform(1).rotation.y
        local posX = Player[color].getHandTransform(1).position.x
        local posZ = Player[color].getHandTransform(1).position.z

        local angle = 2.517 - (math.pi/180 * angleY)

        local offsetX = math.cos(angle) * 14.73
        local offsetZ = math.sin(angle) * 22

        local posy = Vector({posX + offsetX,4,posZ + offsetZ})
        local roty = Player[color].getHandTransform(1).rotation

        Player[color].setHandTransform({
            position = posy,
            rotation = roty,
            scale = {12, 5.4, 5.50}}, 2)
    end
end

-- vagabondo Setup (move 9 char cards)

function vagabondo(obj, color)
    if Global.getVar("vagabondoCount") == 2 then
        printToColor("There can't be more than two Vagabonds/Vagabots!", color, "Yellow")
    else
        if Global.getVar("vagabondoCount") == 1 then
            vagabondo2()
            local vagaCount = Global.getVar("vagabondoCount")
            local vagaCount = vagaCount + 1
            Global.setVar("vagabondoCount", vagaCount)
            Global.setVar("vagabondo2", true)
        else
            if Global.getVar("vagabondoCount") == 0 then
                local vagaCount = Global.getVar("vagabondoCount")
                local vagaCount = vagaCount + 1
                Global.setVar("vagabondoCount", vagaCount)
                Global.setVar("vagabondo", true)
                self.createButton({click_function = "none", function_owner = self, label = "Click on a character\nto choose it",
                    position = {0, 4, - 1.3}, rotation = {0, 0, 0}, scale = {0.12, 0.12, 0.12}, width = 0, height = 0,
                font_size = 700, font_color = "White", })
                local x = -1.25
                for i = 1, 5 do
                    local posCharDeck = self.positionToWorld({ x, 1.6, - 0.6})
                    local rotCharDeck = self.getRotation()
                    bagVagabondo.takeObject({position = posCharDeck, rotation = rotCharDeck, smooth = false, flip = false})
                    x = x + 0.65
                end
                local x = -1
                for i = 1, 4 do
                    local posCharDeck = self.positionToWorld({ x, 1.6, 0.4})
                    local rotCharDeck = self.getRotation()
                    bagVagabondo.takeObject({position = posCharDeck, rotation = rotCharDeck, smooth = false, flip = false})
                    x = x + 0.65
                end
                self.setPosition(self.positionToWorld({0, - 3, 0}))
                self.setLock(true)
                self.interactable = false

                -- make char cards buttons
                self.createButton({click_function = "ronin", function_owner = self, label = "", position = { - 1.345, 3.3, - 0.61},
                rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
                self.createButton({click_function = "thief", function_owner = self, label = "", position = { - 0.695, 3.3, - 0.61},
                rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
                self.createButton({click_function = "ranger", function_owner = self, label = "", position = { - 0.045, 3.3, - 0.61},
                rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
                self.createButton({click_function = "harrier", function_owner = self, label = "", position = { 0.60, 3.3, - 0.61},
                rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
                self.createButton({click_function = "vagrant", function_owner = self, label = "", position = { 1.25, 3.3, - 0.61},
                rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
                self.createButton({click_function = "tinker", function_owner = self, label = "", position = { - 0.94, 3.3, 0.4},
                rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
                self.createButton({click_function = "arbiter", function_owner = self, label = "", position = { - 0.3, 3.3, 0.4},
                rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
                self.createButton({click_function = "scoundrel", function_owner = self, label = "", position = { 0.36, 3.3, 0.4},
                rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
                self.createButton({click_function = "adventurer", function_owner = self, label = "", position = { 1, 3.3, 0.4},
                rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
            end
        end
    end
end

-- char button functions

function ronin(obj, color)
    local readyCount = Global.getVar("ready")
    local readyCount = readyCount + 1
    Global.setVar("ready", readyCount)
    Global.setVar("ronin", true)
    for j, obj in ipairs(vagStartItem) do
        self.clearButtons()
        ruoloVagabondo = "ronin"
        for i, card in ipairs(vagStartItem) do
            bagScartiVagabondo.putObject(getObjectFromGUID(card.card_GUID))
        end
        takeVagabondComps()
        return
    end
end

function thief(obj, color)
    local readyCount = Global.getVar("ready")
    local readyCount = readyCount + 1
    Global.setVar("ready", readyCount)
    Global.setVar("thief", true)
    for j, obj in ipairs(vagStartItem) do
        self.clearButtons()
        ruoloVagabondo = "thief"
        for i, card in ipairs(vagStartItem) do
            bagScartiVagabondo.putObject(getObjectFromGUID(card.card_GUID))
        end
        takeVagabondComps()
        return
    end
end

function ranger(obj, color)
    local readyCount = Global.getVar("ready")
    local readyCount = readyCount + 1
    Global.setVar("ready", readyCount)
    Global.setVar("ranger", true)
    for j, obj in ipairs(vagStartItem) do
        self.clearButtons()
        ruoloVagabondo = "ranger"
        for i, card in ipairs(vagStartItem) do
            bagScartiVagabondo.putObject(getObjectFromGUID(card.card_GUID))
        end
        takeVagabondComps()
        return
    end
end

function harrier(obj, color)
    local readyCount = Global.getVar("ready")
    local readyCount = readyCount + 1
    Global.setVar("ready", readyCount)
    Global.setVar("harrier", true)
    for j, obj in ipairs(vagStartItem) do
        self.clearButtons()
        ruoloVagabondo = "harrier"
        for i, card in ipairs(vagStartItem) do
            bagScartiVagabondo.putObject(getObjectFromGUID(card.card_GUID))
        end
        takeVagabondComps()
        return
    end
end

function vagrant(obj, color)
    local readyCount = Global.getVar("ready")
    local readyCount = readyCount + 1
    Global.setVar("ready", readyCount)
    Global.setVar("vagrant", true)
    for j, obj in ipairs(vagStartItem) do
        self.clearButtons()
        ruoloVagabondo = "vagrant"
        for i, card in ipairs(vagStartItem) do
            bagScartiVagabondo.putObject(getObjectFromGUID(card.card_GUID))
        end
        takeVagabondComps()
        return
    end
end

function tinker(obj, color)
    local readyCount = Global.getVar("ready")
    local readyCount = readyCount + 1
    Global.setVar("ready", readyCount)
    Global.setVar("tinker", true)
    for j, obj in ipairs(vagStartItem) do
        self.clearButtons()
        ruoloVagabondo = "tinker"
        for i, card in ipairs(vagStartItem) do
            bagScartiVagabondo.putObject(getObjectFromGUID(card.card_GUID))
        end
        takeVagabondComps()
        return
    end
end

function arbiter(obj, color)
    local readyCount = Global.getVar("ready")
    local readyCount = readyCount + 1
    Global.setVar("ready", readyCount)
    Global.setVar("arbiter", true)
    for j, obj in ipairs(vagStartItem) do
        self.clearButtons()
        ruoloVagabondo = "arbiter"
        for i, card in ipairs(vagStartItem) do
            bagScartiVagabondo.putObject(getObjectFromGUID(card.card_GUID))
        end
        takeVagabondComps()
        return
    end
end

function scoundrel(obj, color)
    local readyCount = Global.getVar("ready")
    local readyCount = readyCount + 1
    Global.setVar("ready", readyCount)
    Global.setVar("scoundrel", true)
    for j, obj in ipairs(vagStartItem) do
        self.clearButtons()
        ruoloVagabondo = "scoundrel"
        for i, card in ipairs(vagStartItem) do
            bagScartiVagabondo.putObject(getObjectFromGUID(card.card_GUID))
        end
        takeVagabondComps()
        return
    end
end

function adventurer(obj, color)
    local readyCount = Global.getVar("ready")
    local readyCount = readyCount + 1
    Global.setVar("ready", readyCount)
    Global.setVar("adventurer", true)
    for j, obj in ipairs(vagStartItem) do
        self.clearButtons()
        ruoloVagabondo = "adventurer"
        for i, card in ipairs(vagStartItem) do
            bagScartiVagabondo.putObject(getObjectFromGUID(card.card_GUID))
        end
        takeVagabondComps()
        return
    end
end

-- vagabondo character selection

vagStartItem = {
    {id = "vagrant", card_GUID = 'f68b7c', token_GUID = {'fbc21b', '96c36d', '68d051'}},
    {id = "harrier", card_GUID = '0c77f5', token_GUID = {'68d051', '96c36d', '3be707', 'ce8bfd'}},
    {id = "ranger", card_GUID = 'e8e7a0', token_GUID = {'fbc21b', '96c36d', '3be707', 'ce8bfd'}},
    {id = "thief", card_GUID = 'ef4497', token_GUID = {'fbc21b', '96c36d', '39f5f8', 'ce8bfd'}},
    {id = "ronin", card_GUID = 'da5afc', token_GUID = {'fbc21b', 'dc40d4', '96c36d', 'ce8bfd'}},
    {id = "adventurer", card_GUID = '5d3677', token_GUID = {'fbc21b', '96c36d', 'a345fb'}},
    {id = "scoundrel", card_GUID = '55068f', token_GUID = {'fbc21b', 'dc40d4', '96c36d', '3be707'}},
    {id = "arbiter", card_GUID = '338c9e', token_GUID = {'fbc21b', '96c36d', 'ce8bfd', '61c6d3'}},
    {id = "tinker", card_GUID = '32df2a', token_GUID = {'fbc21b', '96c36d', 'dba30a', 'a345fb'}},
}

function takeVagabondComps()
    local x = -0.95
    local posPlayerBoard = self.positionToWorld({0, 3, 0})
    local posMigliorie = self.positionToWorld({ - 1.8, 3, - 0.07})
    local posTileMissioni = {position = { - 58.50, 1.48, 0}, rotation = {0, 90, 0}, smooth = false, callback_function = function(obj) take_callback(obj) end, }
    local posTileMissioniCompletate = self.positionToWorld({ 1.9, 3, - 0.431})
    local posQuestDeck = getObjectFromGUID(setupChecker_GUID).positionToWorld({ - 57.74, 3.5, - 0.3})
    local rotQuestDeck = getObjectFromGUID(setupChecker_GUID).getRotation()
    local posPv = self.positionToWorld({ - 0.2, 5, - 1.6})
    local posPvCounter = self.positionToWorld({ - 1.8, 3, - 1.37})
    local posBagMeeple = self.positionToWorld({ 0.8, 3, - 1.3})
    local rotSpawn = self.getRotation()
    bagVagabondo.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    bagVagabondo.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    bagVagabondo.takeObject(posTileMissioni)
    bagVagabondo.takeObject({position = posTileMissioniCompletate, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    bagVagabondo.takeObject({position = posQuestDeck, rotation = rotQuestDeck + vector(0, 90, 0), smooth = false})
    bagVagabondo.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
    bagVagabondo.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    for i = 1, 9 do
        local posFactionToken = self.positionToWorld({ x, 5, - 1.2})
        bagVagabondo.takeObject({position = posFactionToken, rotation = rotSpawn, smooth = false})
        x = x + 0.165
    end
    -- meeple bag positioning
    if Global.getVar("trueMeeple") == true then
        bagOfBagMeeple = getObjectFromGUID(bagMeeple3D_GUID)
        bagMeeple = 'ac9fc1'
        else if Global.getVar("flatMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
            bagMeeple = '48bdeb'
        else
            bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
            bagMeeple = '7ade90'
        end
    end
    bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = {0, 180, 0}, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    Wait.frames(function() getObjectFromGUID('cc5741').flip() end, 10)
    Wait.frames(function() getObjectFromGUID('cc5741').shuffle() end, 45)
    -- positioning character card and faction tokens
    local x = 0.075
    for i, card in ipairs(vagStartItem) do
        local posCharCard = self.positionToWorld({ - 0.866, 3.9, 0.502})
        local rotObj = self.getRotation()

        if card.id == ruoloVagabondo then
            bagScartiVagabondo.takeObject({guid = card.card_GUID, position = posCharCard, rotation = rotObj, smooth = false, callback_function = function(obj) take_longCallback(obj) end, })
            for k, token in ipairs(card.token_GUID) do
                posTokens = self.positionToWorld({x, 3.9, 0.55})
                bagVagabondo.takeObject({guid = card.token_GUID[k], position = posTokens, rotation = rotObj})
                x = x - 0.15
            end
        end
    end
    Wait.frames(function()
    for m, meeple in ipairs(getObjectFromGUID(bagMeeple).getObjects()) do
        if meeple.gm_notes == ruoloVagabondo then
            local posMeeple = self.positionToWorld({ 0.2, 5, - 1.6})
            getObjectFromGUID(bagMeeple).takeObject({guid = meeple.guid, position = posMeeple, smooth = false})
        end
    end end, 75)
end

-- compagnia Setup

function compagnia(obj, color)
        if Global.getVar("compagnia") then
        printToColor("Faction already selected by another player, or the faction of the Riverfolk Robots has already been chosen and cannot coexist with this one as one replaces the other, or this faction is one of the Hireling factions.", color, "Yellow")
    else
        if Global.getVar("trueBuilding") then bagCompagnia = getObjectFromGUID(bag3DCompagnia_GUID) end
        local x = 0
        local posPlayerBoard = self.positionToWorld({0, 0, 0})
        local posMigliorie = self.positionToWorld({ - 1.8, 0, - 0.07})
        local posTileMano = self.positionToWorld({0, 0, - 1.8})
        local posPv = self.positionToWorld({ 1.6, 0, 0})
        local posPvCounter = self.positionToWorld({ 1.6, 0, 0.78})
        local posBagMeeple = self.positionToWorld({ 1.6, 0, - 0.7})
        local rotSpawn = self.getRotation()
        local count = Global.getVar("ready")
        local count = count + 1
        Global.setVar("ready", count)
        Global.setVar("compagnia", true)
        self.destruct()
        bagCompagnia.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagCompagnia.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagCompagnia.takeObject({position = posTileMano, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagCompagnia.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
        bagCompagnia.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        -- Volpe tokens positioning
        for i = 1, 3 do
            local tokenVolpe = self.positionToWorld({ - 0.715 + x, 0.3, 0.447})
            bagCompagnia.takeObject({position = tokenVolpe, rotation = rotSpawn, smooth = false})
            x = x - 0.18
        end
        -- Coniglio tokens positioning
        local x = 0
        for i = 1, 3 do
            local tokenConiglio = self.positionToWorld({ - 0.715 + x, 0.3, 0.63})
            bagCompagnia.takeObject({position = tokenConiglio, rotation = rotSpawn, smooth = false})
            x = x - 0.18
        end
        -- Topo tokens positioning
        local x = 0
        for i = 1, 3 do
            local TokenTopo = self.positionToWorld({ - 0.715 + x, 0.3, 0.81})
            bagCompagnia.takeObject({position = TokenTopo, rotation = rotSpawn, smooth = false})
            x = x - 0.18
        end
        -- servizi tokens positioning
        local x = 0
        for i = 1, 3 do
            local servizi = self.positionToWorld({ - 1.105, 0.3, - 0.27 + x})
            bagCompagnia.takeObject({position = servizi, rotation = rotSpawn, smooth = false})
            x = x + 0.12
        end
        -- meeple bag positioning
        if Global.getVar("trueMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeeple3D_GUID)
            bagMeeple = 'e8d137'
            else if Global.getVar("flatMeeple") == true then
                bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
                bagMeeple = '26bcf2'
            else
                bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
                bagMeeple = 'bfe555'
            end
        end
        bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = {0, 180, 0}, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        Wait.frames(function()
            local x = 0
            for i = 1, 3 do
                local warriorPos = getObjectFromGUID('428181').positionToWorld({ - 0.37 + x, 1, - 0.3})
                if Global.getVar("trueMeeple") then
                    warriorRot = getObjectFromGUID('e8d137').getRotation()
                else
                    warriorRot = getObjectFromGUID('428181').getRotation()
                end
                getObjectFromGUID(bagMeeple).takeObject({position = warriorPos, rotation = warriorRot, smooth = false})
                x = x + 0.2
            end
        end, 20)
    end
end

-- lucertole Setup

function lucertole(obj, color)
        if Global.getVar("lucertole") then
        printToColor("Faction already selected by another player, or the faction of the Logical Lizards has already been chosen and cannot coexist with this one as one replaces the other, or this faction is one of the Hireling factions.", color, "Yellow")
    else
        if Global.getVar("trueBuilding") then
            bagLucertole = getObjectFromGUID(bag3DLucertole_GUID)
        end
        local x = 0
        local posPlayerBoard = self.positionToWorld({0, 0, 0})
        local posMigliorie = self.positionToWorld({ - 1.8, 0, - 0.07})
        local posPv = self.positionToWorld({ 0.2, 0, - 1.2})
        local posPvCounter = self.positionToWorld({ - 1, 0, - 1.24})
        -- local posOutcast = self.positionToWorld({ - 0.2, 0, - 1.2})
        local posBagMeeple = self.positionToWorld({ 1, 0, - 1.27})
        local rotSpawn = self.getRotation()
        local count = Global.getVar("ready")
        local count = count + 1
        Global.setVar("lost_souls", 'a08505')
        Global.setVar("ready", count)
        Global.setVar("lucertole", true)
        self.destruct()
        bagLucertole.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagLucertole.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagLucertole.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
        bagLucertole.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        -- bagLucertole.takeObject({position = posOutcast, rotation = rotSpawn, smooth = false})

        -- giardinoTopo tokens positioning
        for i = 1, 5 do
            local giardinoTopo = self.positionToWorld({ 0.282 + x, 0.3, 0.435})
            bagLucertole.takeObject({position = giardinoTopo, rotation = rotSpawn, smooth = false})
            x = x - 0.183
        end
        -- giardinoConiglio tokens positioning
        local x = 0
        for i = 1, 5 do
            local giardinoConiglio = self.positionToWorld({ 0.282 + x, 0.3, 0.608})
            bagLucertole.takeObject({position = giardinoConiglio, rotation = rotSpawn, smooth = false})
            x = x - 0.183
        end
        -- giardinoVolpe tokens positioning
        local x = 0
        for i = 1, 5 do
            local giardinoVolpe = self.positionToWorld({ 0.282 + x, 0.3, 0.786})
            bagLucertole.takeObject({position = giardinoVolpe, rotation = rotSpawn, smooth = false})
            x = x - 0.183
        end
        -- meeple bag positioning
        if Global.getVar("trueMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeeple3D_GUID)
            bagMeeple = 'f4c1fc'
            else if Global.getVar("flatMeeple") == true then
                bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
                bagMeeple = 'e1a526'
            else
                bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
                bagMeeple = '748e2f'
            end
        end
        lizardBag.takeObject({guid = 'a08505', position = {-32.85, 1.55, 18.52}, rotation = {0.00, 90.00, 0.00}, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        lizardBag.takeObject({guid = 'd3cb8f', position = {-32.22, 7.82, -3.15}, rotation = {0.00, 0.03, 0.00}, smooth = false})
        bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = {0, 180, 0}, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    end
end

-- ducato sotterraneo Setup

function ducato(obj, color)
        if Global.getVar("ducato") then
        printToColor("Faction already selected by another player, or the faction of the Drillbit Duchy has already been chosen and cannot coexist with this one as one replaces the other, or this faction is one of the Hireling factions.", color, "Yellow")
    else
        if Global.getVar("trueBuilding") then bagDucato = getObjectFromGUID(bag3DDucato_GUID) end
        local x = 0
        local posPlayerBoard = self.positionToWorld({0, 0, 0})
        local posMigliorie = self.positionToWorld({ - 1.8, 0, - 0.07})
        local posBurrow = self.positionToWorld({ - 0.25, 0, - 1.55})
        local posDeck = self.positionToWorld({ - 0.552, 1.65, 0.495})
        local posPv = self.positionToWorld({ 1, 0, - 1.75})
        local posPvCounter = self.positionToWorld({ - 1.8, 0, - 1.5})
        local posBagMeeple = self.positionToWorld({ 1, 0, - 1.27})
        local rotSpawn = self.getRotation()
        local count = Global.getVar("ready")
        local count = count + 1
        Global.setVar("ready", count)
        Global.setVar("ducato", true)
        self.destruct()
        bagDucato.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagDucato.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagDucato.takeObject({position = posBurrow, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagDucato.takeObject({position = posDeck, rotation = rotSpawn, smooth = false})
        bagDucato.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
        bagDucato.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        for i = 1, 3 do
            local posTunnelTokens = self.positionToWorld({ - 1.14 + x, 0, - 1.20})
            bagDucato.takeObject({position = posTunnelTokens, rotation = rotSpawn, smooth = false})
            x = x + 0.19
        end
        local x = 0
        for j = 1, 3 do
            local posCitadel = self.positionToWorld({ - 0.798 + x, 1.58, - 0.298})
            bagDucato.takeObject({position = posCitadel, rotation = rotSpawn, smooth = false})
            x = x + 0.182
        end
        local x = 0
        for k = 1, 3 do
            local posMarket = self.positionToWorld({ - 0.798 + x, 1.58, - 0.110})
            bagDucato.takeObject({position = posMarket, rotation = rotSpawn, smooth = false})
            x = x + 0.182
        end
        local x = 0
        for h = 1, 3 do
            local posCorone1 = self.positionToWorld({ 0.827 + x, 2.07, 0.35})
            bagDucato.takeObject({position = posCorone1, rotation = rotSpawn, smooth = false})
            x = x + 0.11
        end
        local x = 0
        for g = 1, 3 do
            local posCorone2 = self.positionToWorld({ 0.421 + x, 2.07, 0.35})
            bagDucato.takeObject({position = posCorone2, rotation = rotSpawn, smooth = false})
            x = x + 0.11
        end
        local x = 0
        for l = 1, 3 do
            local posCorone3 = self.positionToWorld({ 0.004 + x, 2.07, 0.35})
            bagDucato.takeObject({position = posCorone3, rotation = rotSpawn, smooth = false})
            x = x + 0.11
        end

        -- meeple bag positioning
        if Global.getVar("trueMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeeple3D_GUID)
            bagMeeple = '0b2f75'
            else if Global.getVar("flatMeeple") == true then
                bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
                bagMeeple = '1245f0'
            else
                bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
                bagMeeple = '39e6dd'
            end
        end
        bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = rotSpawn + vector(0, 180, 0), smooth = false, callback_function = function(obj) take_callback(obj) end, })
    end
end

-- cospirazione dei corvi Setup

function corvi(obj, color)
        if Global.getVar("corvi") then
        printToColor("Faction already selected by another player, or the faction of the Cogwheel Corvids has already been chosen and cannot coexist with this one as one replaces the other, or this faction is one of the Hireling factions.", color, "Yellow")
    else
        local x = 0
        local posPlayerBoard = self.positionToWorld({0, 0, 0})
        local posMigliorie = self.positionToWorld({ - 1.8, 0, - 0.07})
        local posPv = self.positionToWorld({ 1, 0, - 1.75})
        local posPvCounter = self.positionToWorld({ - 1.8, 0, - 1.5})
        local posBagMeeple = self.positionToWorld({ 1, 0, - 1.27})
        local posHiddenZone = self.positionToWorld({ 1.55, 2, 0 })
        local rotSpawn = self.getRotation()
        local bagTokenCorvi = getObjectFromGUID('6ffc7f')
        bagTokenCorvi.shuffle()
        local count = Global.getVar("ready")
        local count = count + 1
        Global.setVar("ready", count)
        Global.setVar("corvi", true)
        self.destruct()
        bagCorvi.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagCorvi.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagCorvi.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
        bagCorvi.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })

        for i = 1, 8 do
            local posTokens = self.positionToWorld({ - 1 + x, 0, - 1.27})
            bagTokenCorvi.takeObject({position = posTokens, rotation = rotSpawn + vector(0, 0, 180), smooth = false})
            x = x + 0.2
        end

        -- meeple bag positioning
        if Global.getVar("trueMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeeple3D_GUID)
            bagMeeple = '9b02fb'
            else if Global.getVar("flatMeeple") == true then
                bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
                bagMeeple = '688149'
            else
                bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
                bagMeeple = '141966'
            end
        end
        bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = rotSpawn + vector(0, 140, 0), smooth = false, callback_function = function(obj) take_callback(obj) end, })
        
        if color == "Purple" then
            getObjectFromGUID('86a2e1').setPosition(posHiddenZone) -- purple hidden zone
        else
            getObjectFromGUID('86a2e1').destruct()
        end
        if color == "Blue" then
            getObjectFromGUID('15209b').setPosition(posHiddenZone) -- purple hidden zone
        else
            getObjectFromGUID('15209b').destruct()
        end
        if color == "Teal" then
            getObjectFromGUID('30b8e0').setPosition(posHiddenZone) -- purple hidden zone
        else
            getObjectFromGUID('30b8e0').destruct()
        end
        if color == "Green" then
            getObjectFromGUID('ce6259').setPosition(posHiddenZone) -- purple hidden zone
        else
            getObjectFromGUID('ce6259').destruct()
        end
        if color == "Pink" then
            getObjectFromGUID('782292').setPosition(posHiddenZone) -- purple hidden zone
        else
            getObjectFromGUID('782292').destruct()
        end
        if color == "White" then
            getObjectFromGUID('9354c7').setPosition(posHiddenZone) -- purple hidden zone
        else
            getObjectFromGUID('9354c7').destruct()
        end
        if color == "Brown" then
            getObjectFromGUID('559055').setPosition(posHiddenZone) -- purple hidden zone
        else
            getObjectFromGUID('559055').destruct()
        end
        if color == "Yellow" then
            getObjectFromGUID('0adba2').setPosition(posHiddenZone) -- purple hidden zone
        else
            getObjectFromGUID('0adba2').destruct()
        end
        if color == "Orange" then
            getObjectFromGUID('835f48').setPosition(posHiddenZone) -- purple hidden zone
        else
            getObjectFromGUID('835f48').destruct()
        end
        if color == "Red" then
            getObjectFromGUID('56503c').setPosition(posHiddenZone) -- purple hidden zone
        else
            getObjectFromGUID('56503c').destruct()
        end
    end
end

-- vagabondo #2 Setup (move 9 char cards)

function vagabondo2(obj, color)
    self.createButton({click_function = "none", function_owner = self, label = "Click on a character\nto choose it",
        position = {0, 4, - 1.3}, rotation = {0, 0, 0}, scale = {0.12, 0.12, 0.12}, width = 0, height = 0,
    font_size = 700, font_color = "White", })
    local x = -1.25
    for i = 1, 5 do
        local posCharDeck = self.positionToWorld({ x, 1.6, - 0.6})
        local rotCharDeck = self.getRotation()
        bagVagabondo2.takeObject({position = posCharDeck, rotation = rotCharDeck, smooth = false, flip = false})
        x = x + 0.65
    end
    local x = -1
    for i = 1, 4 do
        local posCharDeck = self.positionToWorld({ x, 1.6, 0.4})
        local rotCharDeck = self.getRotation()
        bagVagabondo2.takeObject({position = posCharDeck, rotation = rotCharDeck, smooth = false, flip = false})
        x = x + 0.65
    end
    self.setPosition(self.positionToWorld({0, - 3, 0}))
    self.setLock(true)
    self.interactable = false

    -- make char cards buttons
    self.createButton({click_function = "ronin2", function_owner = self, label = "", position = { - 1.345, 3.3, - 0.61},
    rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
    self.createButton({click_function = "thief2", function_owner = self, label = "", position = { - 0.695, 3.3, - 0.61},
    rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
    self.createButton({click_function = "ranger2", function_owner = self, label = "", position = { - 0.045, 3.3, - 0.61},
    rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
    self.createButton({click_function = "harrier2", function_owner = self, label = "", position = { 0.60, 3.3, - 0.61},
    rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
    self.createButton({click_function = "vagrant2", function_owner = self, label = "", position = { 1.25, 3.3, - 0.61},
    rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
    self.createButton({click_function = "tinker2", function_owner = self, label = "", position = { - 0.94, 3.3, 0.4},
    rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
    self.createButton({click_function = "arbiter2", function_owner = self, label = "", position = { - 0.3, 3.3, 0.4},
    rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
    self.createButton({click_function = "scoundrel2", function_owner = self, label = "", position = { 0.36, 3.3, 0.4},
    rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
    self.createButton({click_function = "adventurer2", function_owner = self, label = "", position = { 1, 3.3, 0.4},
    rotation = {0, 0, 0}, scale = {1, 1, 1}, width = 290, height = 390, color = {255, 255, 255, 0}, })
end

-- keepers in iron Setup

function keepers(obj, color)
        if Global.getVar("keepers") then
        printToColor("Faction already selected by another player, or this faction is one of the Hireling factions.", color, "Yellow")
    else
        local x = 0
        local posPlayerBoard = self.positionToWorld({0, 0, 0})
        local posMigliorie = self.positionToWorld({ - 1.7, 0, - 0.07})
        local posRetainer = self.positionToWorld({ 0, 0, - 2.05})
        local retainer1 = self.positionToWorld({ 0.805, 0.6, - 2.19})
        local retainer2 = self.positionToWorld({ -0.015, 0.6, - 2.19})
        local retainer3 = self.positionToWorld({ -0.803, 0.6, - 2.19})
        local posPv = self.positionToWorld({ - 1.7, 0, - 2})
        local posPvCounter = self.positionToWorld({ - 1.7, 0, - 1.38})
        local posBagMeeple = self.positionToWorld({ 1.6, 2.58, -0.3})
        local rotSpawn = self.getRotation()
        local count = Global.getVar("ready")
        local count = count + 1
        Global.setVar("ready", count)
        Global.setVar("keepers", true)
        self.destruct()
        bagKeepers.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagKeepers.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagKeepers.takeObject({position = posRetainer, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagKeepers.takeObject({position = retainer1, rotation = rotSpawn, smooth = false})
        bagKeepers.takeObject({position = retainer2, rotation = rotSpawn, smooth = false})
        bagKeepers.takeObject({position = retainer3, rotation = rotSpawn, smooth = false})
        bagKeepers.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
        bagKeepers.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        -- relic tokens positioning
        for i = 1, 3 do
            local waystations = self.positionToWorld({ - 0.035 + x, 0.3, 0.729})
            bagKeepers.takeObject({position = waystations, rotation = rotSpawn, smooth = false})
            x = x - 0.195
        end
        -- Relic bag positioning
        local relicBagPos = self.positionToWorld({ 1.55, 1.50, 0})
        bagKeepers.takeObject({position = relicBagPos, smooth = false, guid = "51dcca", callback_function = function(obj) take_callback(obj) end})
        -- meeple bag positioning
        if Global.getVar("flatMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
            bagMeeple = '0b2c6e'
        else
            bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
            bagMeeple = '948279'
        end
        bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = rotSpawn + vector(90, 180, 0), smooth = false })
        Wait.frames(function() getObjectFromGUID(bagMeeple).setLock(true) end, 150)
    end
end

-- lord of hundreds Setup

function hundreds(obj, color)
    if Global.getVar("hundreds") then
        printToColor("Faction already selected by another player, or this faction is one of the Hireling factions.", color, "Yellow")
    else
        local x = 0
        local posPlayerBoard = self.positionToWorld({0, 0, 0})
        local posMigliorie = self.positionToWorld({ - 1.8, 0, - 0.07})
        local posPv = self.positionToWorld({ - 1.8, 0, - 1.4})
        local posPvCounter = self.positionToWorld({ - 0.9, 0, - 1.31})
        local moodCards = self.positionToWorld({ -0.64, 0.6, 0.514})
        local mobDie = self.positionToWorld({ 0.25, 0.6, - 1.8})
        local warlord = self.positionToWorld({ - 0.25, 0.6, - 1.8})
        local mobLobber = self.positionToWorld({ 1.8, 1.50, - 0.5})
        local posBagMeeple = self.positionToWorld({ 1, 0, - 1.05})
        local rotSpawn = self.getRotation()
        local count = Global.getVar("ready")
        local count = count + 1
        Global.setVar("ready", count)
        Global.setVar("hundreds", true)
        bagHundreds.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagHundreds.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagHundreds.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
        bagHundreds.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
        bagHundreds.takeObject({position = moodCards, rotation = rotSpawn, smooth = false})
        bagHundreds.takeObject({position = mobDie, rotation = rotSpawn + vector(180, 0, 0), smooth = false})
        if Global.getVar("flatMeeple") == true then
            bagHundreds.takeObject({position = warlord, rotation = rotSpawn, smooth = false})
        else
            pos_war = {-80.85, -3.71, 15.48} -- imposta posizione in un punto invisibile
            bagHundreds.takeObject({position = pos_war, smooth = false}) -- prendi dalla bag il warlord flat e metilo nella posizione pos_war
            getObjectFromGUID('0e9351').destruct() -- distruggi il warlord flat
            getObjectFromGUID('80acd0').takeObject({position = warlord, rotation = rotSpawn, smooth = false})
        end

        -- mobs tokens
        for i = 1, 6 do
            local mobs = self.positionToWorld({ 0.56 + x, 0.3, - 1.2})
            bagHundreds.takeObject({position = mobs, rotation = rotSpawn, smooth = false})
            x = x - 0.195
        end

        -- strongholds tokens
        local x = 0
        for i = 1, 5 do
            local strongholds = self.positionToWorld({ 0.46 + x, 0.3, - 1.5})
            bagHundreds.takeObject({position = strongholds, rotation = rotSpawn, smooth = false})
            x = x - 0.195
        end
        -- meeple bag positioning
        if Global.getVar("flatMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
            bagMeeple = 'eb4bd3'
        else
            bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
            bagMeeple = '24fc4b'
        end
        bagHundreds.takeObject({position = mobLobber, rotation = rotSpawn, smooth = false, guid = '82c968'})
        bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = rotSpawn + vector(90, 180, 0), smooth = false })
        Wait.frames(function() getObjectFromGUID(bagMeeple).setLock(true) end, 150)
        Wait.frames(function() getObjectFromGUID('82c968').setLock(true) end, 150)
        self.destruct()
    end
end

-- char button functions

function ronin2(obj, color)
    if Global.getVar("ronin") == true then
        printToColor("Character already selected by the other Vagabond", color, "Yellow")
    else
        local readyCount = Global.getVar("ready")
        local readyCount = readyCount + 1
        Global.setVar("ready", readyCount)
        Global.setVar("ronin", true)
        for j, obj in ipairs(vagStartItem2) do
            self.clearButtons()
            ruoloVagabondo2 = "ronin"
            for i, card in ipairs(vagStartItem2) do
                bagScartiVagabondo2.putObject(getObjectFromGUID(card.card_GUID))
            end
            takeVagabondComps2()
            return
        end
    end
end

function thief2(obj, color)
    if Global.getVar("thief") == true then
        printToColor("Character already selected by the other Vagabond", color, "Yellow")
    else
        local readyCount = Global.getVar("ready")
        local readyCount = readyCount + 1
        Global.setVar("ready", readyCount)
        Global.setVar("thief", true)
        for j, obj in ipairs(vagStartItem2) do
            self.clearButtons()
            ruoloVagabondo2 = "thief"
            for i, card in ipairs(vagStartItem2) do
                bagScartiVagabondo2.putObject(getObjectFromGUID(card.card_GUID))
            end
            takeVagabondComps2()
            return
        end
    end
end

function ranger2(obj, color)
    if Global.getVar("ranger") == true then
        printToColor("Character already selected by the other Vagabond", color, "Yellow")
    else
        local readyCount = Global.getVar("ready")
        local readyCount = readyCount + 1
        Global.setVar("ready", readyCount)
        Global.setVar("ranger", true)
        for j, obj in ipairs(vagStartItem2) do
            self.clearButtons()
            ruoloVagabondo2 = "ranger"
            for i, card in ipairs(vagStartItem2) do
                bagScartiVagabondo2.putObject(getObjectFromGUID(card.card_GUID))
            end
            takeVagabondComps2()
            return
        end
    end
end

function harrier2(obj, color)
    if Global.getVar("harrier") == true then
        printToColor("Character already selected by the other Vagabond", color, "Yellow")
    else
        local readyCount = Global.getVar("ready")
        local readyCount = readyCount + 1
        Global.setVar("ready", readyCount)
        Global.setVar("harrier", true)
        for j, obj in ipairs(vagStartItem2) do
            self.clearButtons()
            ruoloVagabondo2 = "harrier"
            for i, card in ipairs(vagStartItem2) do
                bagScartiVagabondo2.putObject(getObjectFromGUID(card.card_GUID))
            end
            takeVagabondComps2()
            return
        end
    end
end

function vagrant2(obj, color)
    if Global.getVar("vagrant") == true then
        printToColor("Character already selected by the other Vagabond", color, "Yellow")
    else
        local readyCount = Global.getVar("ready")
        local readyCount = readyCount + 1
        Global.setVar("ready", readyCount)
        Global.setVar("vagrant", true)
        for j, obj in ipairs(vagStartItem2) do
            self.clearButtons()
            ruoloVagabondo2 = "vagrant"
            for i, card in ipairs(vagStartItem2) do
                bagScartiVagabondo2.putObject(getObjectFromGUID(card.card_GUID))
            end
            takeVagabondComps2()
            return
        end
    end
end

function tinker2(obj, color)
    if Global.getVar("tinker") == true then
        printToColor("Character already selected by the other Vagabond", color, "Yellow")
    else
        local readyCount = Global.getVar("ready")
        local readyCount = readyCount + 1
        Global.setVar("ready", readyCount)
        Global.setVar("tinker", true)
        for j, obj in ipairs(vagStartItem2) do
            self.clearButtons()
            ruoloVagabondo2 = "tinker"
            for i, card in ipairs(vagStartItem2) do
                bagScartiVagabondo2.putObject(getObjectFromGUID(card.card_GUID))
            end
            takeVagabondComps2()
            return
        end
    end
end

function arbiter2(obj, color)
    if Global.getVar("arbiter") == true then
        printToColor("Character already selected by the other Vagabond", color, "Yellow")
    else
        local readyCount = Global.getVar("ready")
        local readyCount = readyCount + 1
        Global.setVar("ready", readyCount)
        Global.setVar("arbiter", true)
        for j, obj in ipairs(vagStartItem2) do
            self.clearButtons()
            ruoloVagabondo2 = "arbiter"
            for i, card in ipairs(vagStartItem2) do
                bagScartiVagabondo2.putObject(getObjectFromGUID(card.card_GUID))
            end
            takeVagabondComps2()
            return
        end
    end
end

function scoundrel2(obj, color)
    if Global.getVar("scoundrel") == true then
        printToColor("Character already selected by the other Vagabond", color, "Yellow")
    else
        local readyCount = Global.getVar("ready")
        local readyCount = readyCount + 1
        Global.setVar("ready", readyCount)
        Global.setVar("scoundrel", true)
        for j, obj in ipairs(vagStartItem2) do
            self.clearButtons()
            ruoloVagabondo2 = "scoundrel"
            for i, card in ipairs(vagStartItem2) do
                bagScartiVagabondo2.putObject(getObjectFromGUID(card.card_GUID))
            end
            takeVagabondComps2()
            return
        end
    end
end

function adventurer2(obj, color)
    if Global.getVar("adventurer") == true then
        printToColor("Character already selected by the other Vagabond", color, "Yellow")
    else
        local readyCount = Global.getVar("ready")
        local readyCount = readyCount + 1
        Global.setVar("ready", readyCount)
        Global.setVar("adventurer", true)
        for j, obj in ipairs(vagStartItem2) do
            self.clearButtons()
            ruoloVagabondo2 = "adventurer"
            for i, card in ipairs(vagStartItem2) do
                bagScartiVagabondo2.putObject(getObjectFromGUID(card.card_GUID))
            end
            takeVagabondComps2()
            return
        end
    end
end

-- vagabondo character selection

vagStartItem2 = {
    {id = "vagrant", card_GUID = '941788', token_GUID = {'52fb80', '388402', 'e64f60'}},
    {id = "harrier", card_GUID = 'aceab5', token_GUID = {'52fb80', '388402', '5fa4d4', 'e6c326'}},
    {id = "ranger", card_GUID = '4b1e63', token_GUID = {'e64f60', '388402', '5fa4d4', 'e6c326'}},
    {id = "thief", card_GUID = 'd8912f', token_GUID = {'e64f60', '388402', '32287c', 'e6c326'}},
    {id = "ronin", card_GUID = '31b0d0', token_GUID = {'3f3d2d', 'e64f60', '388402', 'e6c326'}},
    {id = "adventurer", card_GUID = '0c0054', token_GUID = {'3f3d2d', '388402', 'df75fe'}},
    {id = "scoundrel", card_GUID = 'fad338', token_GUID = {'e64f60', '3f3d2d', '388402', '5fa4d4'}},
    {id = "arbiter", card_GUID = '469f5d', token_GUID = {'e64f60', '388402', 'e6c326', 'de4365'}},
    {id = "tinker", card_GUID = 'b574bb', token_GUID = {'e64f60', '388402', 'ee5d4f', 'df75fe'}},
}

function takeVagabondComps2()
    local x = -0.95
    local posPlayerBoard = self.positionToWorld({0, 3, 0})
    local posMigliorie = self.positionToWorld({ - 1.8, 3, - 0.07})
    local posTileMissioniCompletate = self.positionToWorld({ 1.9, 3, - 0.431})
    local posPv = self.positionToWorld({ - 0.2, 5, - 1.6})
    local posPvCounter = self.positionToWorld({ - 1.8, 3, - 1.37})
    local posBagMeeple = self.positionToWorld({ 0.8, 3, - 1.3})
    local rotSpawn = self.getRotation()
    bagVagabondo2.takeObject({position = posPlayerBoard, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    bagVagabondo2.takeObject({position = posMigliorie, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    bagVagabondo2.takeObject({position = posTileMissioniCompletate, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    bagVagabondo2.takeObject({position = posPv, rotation = rotSpawn, smooth = false})
    bagVagabondo2.takeObject({position = posPvCounter, rotation = rotSpawn, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    for i = 1, 9 do
        local posFactionToken = self.positionToWorld({ x, 5, - 1.2})
        bagVagabondo2.takeObject({position = posFactionToken, rotation = rotSpawn, smooth = false})
        x = x + 0.165
    end
    -- meeple bag positioning
    if Global.getVar("trueMeeple") == true then
        bagOfBagMeeple = getObjectFromGUID(bagMeeple3D_GUID)
        bagMeeple = 'bd2943'
        else if Global.getVar("flatMeeple") == true then
            bagOfBagMeeple = getObjectFromGUID(bagMeepleFlat_GUID)
            bagMeeple = '6a8af3'
        else
            bagOfBagMeeple = getObjectFromGUID(bagMeepleStand_GUID)
            bagMeeple = '05ab0c'
        end
    end
    bagOfBagMeeple.takeObject({guid = bagMeeple, position = posBagMeeple, rotation = {0, 180, 0}, smooth = false, callback_function = function(obj) take_callback(obj) end, })
    -- positioning character card and faction tokens
    local x = 0.075
    for i, card in ipairs(vagStartItem2) do
        local posCharCard = self.positionToWorld({ - 0.866, 3.9, 0.502})
        local rotObj = self.getRotation()

        if card.id == ruoloVagabondo2 then
            bagScartiVagabondo2.takeObject({guid = card.card_GUID, position = posCharCard, rotation = rotObj, smooth = false, callback_function = function(obj) take_longCallback(obj) end, })
            for k, token in ipairs(card.token_GUID) do
                posTokens = self.positionToWorld({x, 3.9, 0.55})
                bagVagabondo2.takeObject({guid = card.token_GUID[k], position = posTokens, rotation = rotObj})
                x = x - 0.15
            end
        end
    end
    Wait.frames(function()
    for m, meeple in ipairs(getObjectFromGUID(bagMeeple).getObjects()) do
        if meeple.gm_notes == ruoloVagabondo2 then
            local posMeeple = self.positionToWorld({ 0.2, 5, - 1.6})
            getObjectFromGUID(bagMeeple).takeObject({guid = meeple.guid, position = posMeeple, smooth = false})
        end
    end end, 75)
end

-- lock items after positioning (callback)

function take_callback(obj)
    Wait.frames(function()
        obj.setLock(true)
        --obj.interactable = false
    end, 50)
end

function take_longCallback(obj)
    Wait.frames(function()
        obj.setLock(true)
        --obj.interactable = false
    end, 180)
end

-- bot faction button

function botFactions()
    self.setState(2)
end

function none()
end