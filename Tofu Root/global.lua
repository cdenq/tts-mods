function onLoad()
    GLOBALNUMLANDMARKS = 0
    GLOBALSETTING = ""
    HIRELINGSINPLAY = {}
    HIRELING4 = true
    HIRELING8 = true
    HIRELING12 = true
end

function setHirelingsinPlay(newFactions)
    HIRELINGSINPLAY = newFactions
    Global.setVar("HIRELINGSINPLAY", HIRELINGSINPLAY)
end