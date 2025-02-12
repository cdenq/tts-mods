----------------------
-- Created for Tofu Worldview
-- By cdenq
----------------------
self.setName("Tofu Comprehensive Setup")
--[[
    if adding new maps, add to the myIterations with the map name. 
    remember to add its map specific color to myColors.mapSpecific.

    outstanding bug:
    when you swap between the maps, it duplicates the ruin items in the map bag.
    maybe something to do with the wait.time, idk
    setCardAid is broken -> TTS api doesnt owrk for obj.setPage(i)

    same with landmarks going back in bag

    for button index -> look createAllButtons().
    format buttons are 2-7
]]

----------------------
-- button variables
----------------------
myColors = {
    white = {1, 1, 1},
    gray = {0.5, 0.5, 0.5},
    green = {0, 1, 0},
    red = {1, 0, 0},
    mapSpecific = {
        autumn = {1, 0.647, 0},
        winter = {0.678, 0.847, 0.902},
        lake = {0, 0, 1},
        mountain = {0.502, 0, 0},
        marsh = {0.133, 0.545, 0.133},
        gorge = {0.627, 0.125, 0.941}
    },
    suits = {
        Fox = {0.886, 0.318, 0.204},
        Mouse = {0.945, 0.573, 0.380},
        Bunny = {0.941, 0.843, 0.376}
    }
}
globalButtonLift = 0.18
myButtons = {
    genericMain = {
        buttonHeight = 100, 
        buttonWidth = 300, 
        buttonLift = globalButtonLift,
        buttonRotation = {0, 0, 0},
        fontSize = 45,
        scale = {0.65, 0.65, 0.65}
    },
    resetButton = {0, globalButtonLift, -1.05},
    confirmButton = {0, globalButtonLift, 0.9},
    setupButtonsMain = {
        startX = -0.45, 
        startZ = -0.858, 
        spacingX = 0.45, 
        spacingZ = 0.155,
        scale = {0.65, 0.65, 0.55},
        fontSize = 40
    },
    mapButtonsMain = {
        startX = -0.45, 
        startZ = -0.52, 
        spacingX = 0.45, 
        spacingZ = 0.2,
        scale = {0.65, 0.65, 0.65}
    },
    suitButtonsMain = {
        startX = -0.475, 
        startZ = 0.09, 
        spacingX = 0.325, 
        spacingZ = 0.2,
        scale = {0.55, 0.55, 0.55}
    },
    ruinButtonsMain = {
        startX = -0.475, 
        startZ = 0.273, 
        spacingX = 0.325, 
        spacingZ = 0.2,
        scale = {0.55, 0.55, 0.55}
    },
    deckButtonsMain = {
        startX = -0.45, 
        startZ = 0.455, 
        spacingX = 0.45, 
        spacingZ = 0.2,
        scale = {0.65, 0.65, 0.65},
        fontSize = 40
    }
}

----------------------
-- object variables
----------------------
myIterations = {
    maps = {"autumn", "winter", "lake", "mountain", "gorge", "marsh"},
    markers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"},
    extendedMarkers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"},
    supplyItems = {"bag1", "bag2", "boot1", "boot2", "cross", "hammer", "sword1", "sword2", "tea1", "tea2", "coin1", "coin2"},
    ruinItems = {"boot", "bag", "hammer", "sword"},
    formatButtonLabels = {"Printed", "Comprehensive", "AdSet", "ModAdSet", "Landmarks", "Hirelings"},
    suitButtonLabels = {"Random", "Default", "Draw", "Reset"},
    suitLabels = {"Fox", "Mouse", "Bunny"},
    ruinButtonLabels = {"None", "One", "Two", "Reset"},
    deckButtonLabels = {"Base", "Exiles & Partisans", "Squires & Disciples"},
    landmarkCycle = {"None", "Printed", "Competitive", "Random 1", "Random 2"},
    hirelingCycle = {"No", "Yes"}
}
myBagObjs = {
    mapBag = getObjectFromGUID("e05260"),
    landmarksBag = getObjectFromGUID("7dfe70")
}
myBookkeepingVariables = {
    totalPlaced = {},
    totalPlacedLandmarks = {},
    currentMap = "",
    currentFormat = "",
    currentLandmarkFormat = "None",
    currentHirelingFormat = "No",
    markersList = {},
    suitPool = {},
    ruinsPool = {}
}
myDeckGUIDs = {
    ["Base"] = "42d2c7",
    ["Exiles & Partisans"] = "d07572",
    ["Squires & Disciples"] = ""
}
myMapsSetup = {
    overallPosition = {0.04, 1.48, -0.02},
    overallRotation = {0.00, 0.00, 0.00},
    overallRightRotation = {0, 90, 0},
    overallLeftRotation = {0, 270, 0},
    autumn = "43180d",
    winter = "e94958",
    lake = "cbb6e5",
    mountain = "2255cd",
    -- gorge = "",
    -- marsh = "",
    deckZoneGUID = "cf89ff",
    extras = {
        sideboard = {
            GUID = "5c414a",
            position = {-40.87, 1.49, 0.73},
            rotation = {0, 90, 0},
            lock = true,
            interact = false
        },
        sideboardExtended = {
            GUID = "a74be4",
            position = {39.43, 1.49, 0.73},
            rotation = {0, 270, 0},
            lock = true,
            interact = false
        },
        battlemat = {
            GUID = "2314cc",
            position = {-57.76, 1.49, 0.92},
            rotation = {0, 90, 0},
            lock = true,
            interact = true
        },
        cardAid = {
            GUID = "6a64b9",
            position = {-57.77, 1.48, -12.07},
            rotation = {0, 90, 0},
            lock = true,
            interact = true
        },
        battleAid = {
            GUID = "716a87",
            position = {-57.57, 1.53, 12.25},
            rotation = {0, 90, 0},
            lock = true,
            interact = true
        },
        graveone = {
            GUID = "47b453",
            position = {27.64, 1.53, -0.08},
            rotation = {0, 0, 0},
            lock = true,
            interact = false
        },
        gravetwo = {
            GUID = "f391db",
            position = {-27.57, 1.53, -0.08},
            rotation = {0, 0, 0},
            lock = true,
            interact = false
        },
        coffin = {
            GUID = "fc47b2",
            position = {52.36, 1.53, 1.49},
            rotation = {0, 0, 0},
            lock = false,
            interact = true
        }
    },
    boards = {
        landmark = {
            GUID = "a17289",
            position = {105.95, 2.03, 17.88},
            rotation = {0.00, 270.00, 0.00},
            lock = true,
            interact = true
        },
        hireling = {
            GUID = "53df8e",
            position = {105.95, 2.03, -1.76},
            rotation = {0.00, 270.00, 0.00},
            lock = true,
            interact = true
        },
        draft = {
            GUID = "65521b",
            position = {104.59, 2.03, -32.50},
            rotation = {0.00, 270.00, 0.00},
            lock = true,
            interact = true
        }
    }
}
myLandmarkSetup = {
    cardPosition = {35.10, 5, -8.39},
    cardRotation = {0.00, 270.00, 0.00},
    ferry = {
        meepleGUID = "939f2d",
        cardGUID = "7fccee",
        meeplePosition = {-13.35, 3, 12.98},
        meepleRotation = {0.00, 270.00, 0.00}
    },
    tower = {
        meepleGUID = "74ecde",
        cardGUID = "662417",
        meeplePosition = {-1.41, 3, -7.05},
        meepleRotation = {0.00, 0.00, 0.00}
    },
    city = {
        meepleGUID = "6fdc85",
        cardGUID = "e64d9d",
        meeplePosition = {2.45, 3, -8.33},
        meepleRotation = {0.00, 0.00, 0.00}
    },
    citymarker = { --GUID of state "10"
        meepleGUID = "4347ab",
        meeplePosition = {0.65, 5, -0.10},
        meepleRotation = {0.00, 0.00, 0.00}
    }
}
myMarkerGUIDSetup = {
    ["1"] = {Fox = "719693", Mouse = "e86e72", Bunny = "adc360"},
    ["2"] = {Fox = "0d6440", Mouse = "22dfdb", Bunny = "494e8e"},
    ["3"] = {Fox = "755d72", Mouse = "d50532", Bunny = "dae872"},
    ["4"] = {Fox = "3fc03b", Mouse = "e658d1", Bunny = "9ac91f"},
    ["5"] = {Fox = "bba94c", Mouse = "72b139", Bunny = "615708"},
    ["6"] = {Fox = "0f7cd3", Mouse = "486757", Bunny = "72b88f"},
    ["7"] = {Fox = "b416fe", Mouse = "ca801a", Bunny = "0292d9"},
    ["8"] = {Fox = "e100a2", Mouse = "794202", Bunny = "803f2a"},
    ["9"] = {Fox = "b248e7", Mouse = "df3642", Bunny = "03a05d"},
    ["10"] = {Fox = "ada1c4", Mouse = "4e65f9", Bunny = "650767"},
    ["11"] = {Fox = "705560", Mouse = "38724c", Bunny = "836f9f"},
    -- ["13"] = {},
    -- ["14"] = {},
    -- ["15"] = {},
    ["12"] = {Fox = "2f2cb5", Mouse = "3de9f7", Bunny = "f58018"}
}
myMarkerLocationSetup = {
    autumn = {
        ["1"] = {
            position = {17.25, 2.50, -14.38},
            rotation = {0.00, 315.00, 0.00}
        },
        ["2"] = {
            position = {-16.40, 2.50, -9.49},
            rotation = {0.00, 45.00, 0.00}
        },
        ["3"] = {
            position = {-20.26, 2.50, 15.60},
            rotation = {0.00, 240.00, 0.00}
        },
        ["4"] = {
            position = {19.65, 2.50, 18.27},
            rotation = {0.00, 0.00, 0.00}
        },
        ["5"] = {
            position = {-2.66, 2.50, -15.22},
            rotation = {0.00, -0.01, 0.00}
        },
        ["6"] = {
            position = {-23.18, 2.50, 3.75},
            rotation = {0.00, 315.00, 0.00}
        },
        ["7"] = {
            position = {-4.26, 2.50, 16.37},
            rotation = {0.00, 0.00, 0.00}
        },
        ["8"] = {
            position = {9.37, 2.50, 15.01},
            rotation = {0.00, 150.00, 0.00}
        },
        ["9"] = {
            position = {15.66, 2.50, -5.33},
            rotation = {0.00, 270.00, 0.00}
        },
        ["10"] = {
            position = {7.38, 2.50, -7.38},
            rotation = {0.00, 60.00, 0.00}
        },
        ["11"] = {
            position = {-10.25, 2.50, 2.02},
            rotation = {0.00, 315.00, 0.00}
        },
        ["12"] = {
            position = {9.03, 2.50, 6.05},
            rotation = {0.00, 0.02, 0.00}
        }
    },
    winter = {
        ["1"] = {
            position = {15.50, 2.50, -19.57},
            rotation = {0.00, 225.00, 0.00}
        },
        ["2"] = {
            position = {-21.75, 2.50, -10.02},
            rotation = {0.00, 300.02, 0.00}
        },
        ["3"] = {
            position = {-21.15, 2.50, 17.24},
            rotation = {0.00, 285.00, 0.00}
        },
        ["4"] = {
            position = {20.91, 2.50, 17.21},
            rotation = {0.00, 45.00, 0.00}
        },
        ["5"] = {
            position = {7.66, 2.50, -11.48},
            rotation = {0.00, 30.00, 0.00}
        },
        ["6"] = {
            position = {-4.67, 2.50, -8.73},
            rotation = {0.00, 0.00, 0.00}
        },
        ["7"] = {
            position = {-22.53, 2.50, 7.06},
            rotation = {0.00, 330.00, 0.00}
        },
        ["8"] = {
            position = {-4.68, 2.50, 14.57},
            rotation = {0.00, 0.02, 0.00}
        },
        ["9"] = {
            position = {3.02, 2.50, 17.86},
            rotation = {0.00, 285.00, 0.00}
        },
        ["10"] = {
            position = {21.23, 2.50, -6.11},
            rotation = {0.00, 135.00, 0.00}
        },
        ["11"] = {
            position = {3.68, 2.50, 2.56},
            rotation = {0.00, 300.02, 0.00}
        },
        ["12"] = {
            position = {-9.90, 2.50, -1.72},
            rotation = {0.00, 285.00, 0.00}
        }
    },
    lake = {
        ["1"] = {
            position = {-21.68, 2.50, 14.06},
            rotation = {0.00, 225.00, 0.00}
        },
        ["2"] = {
            position = {21.03, 2.50, -17.66},
            rotation = {0.00, 135.00, 0.00}
        },
        ["3"] = {
            position = {17.21, 2.50, 17.98},
            rotation = {0.00, 330.00, 0.00}
        },
        ["4"] = {
            position = {-20.98, 2.50, -11.57},
            rotation = {0.00, 180.00, 0.00}
        },
        ["5"] = {
            position = {-15.89, 2.50, 5.67},
            rotation = {0.00, 45.00, 0.00}
        },
        ["6"] = {
            position = {-6.37, 2.50, -10.44},
            rotation = {0.00, 45.00, 0.00}
        },
        ["7"] = {
            position = {6.38, 2.50, -15.28},
            rotation = {0.00, 60.00, 0.00}
        },
        ["8"] = {
            position = {17.86, 2.50, 2.38},
            rotation = {0.00, 330.00, 0.00}
        },
        ["9"] = {
            position = {-0.08, 2.50, 14.21},
            rotation = {0.00, 225.00, 0.00}
        },
        ["10"] = {
            position = {13.81, 2.50, -7.81},
            rotation = {0.00, 105.00, 0.00}
        },
        ["11"] = {
            position = {-12.68, 2.50, -2.87},
            rotation = {0.00, 240.00, 0.00}
        },
        ["12"] = {
            position = {9.53, 2.50, 11.72},
            rotation = {0.00, 15.00, 0.00}
        }
    },
    --[[ gorge = {
        ["1"] = {
            position = ,
            rotation = 
        },
        ["2"] = {
            position = ,
            rotation = 
        },
        ["3"] = {
            position = ,
            rotation = 
        },
        ["4"] = {
            position = ,
            rotation = 
        },
        ["5"] = {
            position = ,
            rotation = 
        },
        ["6"] = {
            position = ,
            rotation = 
        },
        ["7"] = {
            position = ,
            rotation = 
        },
        ["8"] = {
            position = ,
            rotation = 
        },
        ["9"] = {
            position = ,
            rotation = 
        },
        ["10"] = {
            position = ,
            rotation = 
        },
        ["11"] = {
            position = ,
            rotation = 
        },
        ["12"] = {
            position = ,
            rotation = 
        }
    },
    marsh = {
        ["1"] = {
            position = ,
            rotation = 
        },
        ["2"] = {
            position = ,
            rotation = 
        },
        ["3"] = {
            position = ,
            rotation = 
        },
        ["4"] = {
            position = ,
            rotation = 
        },
        ["5"] = {
            position = ,
            rotation = 
        },
        ["6"] = {
            position = ,
            rotation = 
        },
        ["7"] = {
            position = ,
            rotation = 
        },
        ["8"] = {
            position = ,
            rotation = 
        },
        ["9"] = {
            position = ,
            rotation = 
        },
        ["10"] = {
            position = ,
            rotation = 
        },
        ["11"] = {
            position = ,
            rotation = 
        },
        ["12"] = {
            position = ,
            rotation = 
        },
        ["13"] = {
            position = ,
            rotation =
        },
        ["14"] = {
            position = ,
            rotation = 
        },
        ["15"] = {
            position = ,
            rotation = 
        }
    } ]]
    mountain = {
        ["1"] = {
            position = {22.39, 2.50, -18.19},
            rotation = {0.00, 135.00, 0.00}
        },
        ["2"] = {
            position = {-20.86, 2.50, -11.94},
            rotation = {0.00, 300.03, 0.00}
        },
        ["3"] = {
            position = {-20.03, 2.50, 16.04},
            rotation = {0.00, 330.00, 0.00}
        },
        ["4"] = {
            position = {15.32, 2.50, 17.84},
            rotation = {0.00, 315.00, 0.00}
        },
        ["5"] = {
            position = {-5.25, 2.50, -18.85},
            rotation = {0.00, 240.00, 0.00}
        },
        ["6"] = {
            position = {-17.10, 2.50, -2.15},
            rotation = {0.00, 120.01, 0.00}
        },
        ["7"] = {
            position = {0.17, 2.50, 17.84},
            rotation = {0.00, 60.00, 0.00}
        },
        ["8"] = {
            position = {17.49, 2.50, 5.25},
            rotation = {0.00, 300.04, 0.00}
        },
        ["9"] = {
            position = {7.83, 2.50, -4.88},
            rotation = {0.00, 315.00, 0.00}
        },
        ["10"] = {
            position = {0.65, 2.50, -0.10},
            rotation = {0.00, 0.01, 0.00}
        },
        ["11"] = {
            position = {-5.97, 2.50, 9.08},
            rotation = {0.00, 15.00, 0.00}
        },
        ["12"] = {
            position = {12.48, 2.50, 8.16},
            rotation = {0.00, 75.00, 0.00}
        }
    }
}
mySupplyGUIDSetup = {
    --from adset mountain set
    bag1 = "233b57",
    bag2 = "8cff64",
    boot1 = "473549",
    boot2 = "d50954",
    cross = "a13ed6",
    hammer = "27b19b",
    sword1 = "e0e2a9",
    sword2 = "269d59",
    tea1 = "ce1584",
    tea2 = "4fc243",
    coin1 = "00763e",
    coin2 = "76a02d"
}
mySupplyPositionSetup = {
    autumn = {
        bag1 = {
            position = {13.95, 2.0, -21.60},
            rotation = myMapsSetup.overallRotation
        },
        bag2 = {
            position = {13.95, 2.0, -19.85},
            rotation = myMapsSetup.overallRotation
        },
        boot1 = {
            position = {12.11, 2.0, -21.60},
            rotation = myMapsSetup.overallRotation
        },
        boot2 = {
            position = {12.11, 2.0, -19.85},
            rotation = myMapsSetup.overallRotation
        },
        cross = {
            position = {10.28, 2.0, -21.60},
            rotation = myMapsSetup.overallRotation
        },
        hammer = {
            position = {10.28, 2.0, -19.85},
            rotation = myMapsSetup.overallRotation
        },
        sword1 = {
            position = {8.45, 2.0, -21.60},
            rotation = myMapsSetup.overallRotation
        },
        sword2 = {
            position = {8.45, 2.0, -19.85},
            rotation = myMapsSetup.overallRotation
        },
        tea1 = {
            position = {6.64, 2.0, -21.60},
            rotation = myMapsSetup.overallRotation
        },
        tea2 = {
            position = {6.63, 2.0, -19.85},
            rotation = myMapsSetup.overallRotation
        },
        coin1 = {
            position = {4.80, 2.0, -21.60},
            rotation = myMapsSetup.overallRotation
        },
        coin2 = {
            position = {4.80, 2.0, -19.85},
            rotation = myMapsSetup.overallRotation
        }
    },
    winter = {
        bag1 = {
            position = {-0.12, 2.0, -20.23},
            rotation = myMapsSetup.overallRotation
        },
        bag2 = {
            position = {-0.12, 2.0, -18.48},
            rotation = myMapsSetup.overallRotation
        },
        boot1 = {
            position = {-1.96, 2.0, -20.23},
            rotation = myMapsSetup.overallRotation
        },
        boot2 = {
            position = {-1.96, 2.0, -18.48},
            rotation = myMapsSetup.overallRotation
        },
        cross = {
            position = {-3.79, 2.0, -20.23},
            rotation = myMapsSetup.overallRotation
        },
        hammer = {
            position = {-3.79, 2.0, -18.48},
            rotation = myMapsSetup.overallRotation
        },
        sword1 = {
            position = {-5.62, 2.0, -20.23},
            rotation = myMapsSetup.overallRotation
        },
        sword2 = {
            position = {-5.62, 2.0, -18.48},
            rotation = myMapsSetup.overallRotation
        },
        tea1 = {
            position = {-7.44, 2.0, -20.23},
            rotation = myMapsSetup.overallRotation
        },
        tea2 = {
            position = {-7.44, 2.0, -18.48},
            rotation = myMapsSetup.overallRotation
        },
        coin1 = {
            position = {-9.27, 2.0, -20.23},
            rotation = myMapsSetup.overallRotation
        },
        coin2 = {
            position = {-9.27, 2.0, -18.48},
            rotation = myMapsSetup.overallRotation
        }
    },
    lake = {
        bag1 = {
            position = {16.49, 2.0, -21.35},
            rotation = myMapsSetup.overallRotation
        },
        bag2 = {
            position = {16.48, 2.0, -19.59},
            rotation = myMapsSetup.overallRotation
        },
        boot1 = {
            position = {14.63, 2.0, -21.35},
            rotation = myMapsSetup.overallRotation
        },
        boot2 = {
            position = {14.63, 2.0, -19.60},
            rotation = myMapsSetup.overallRotation
        },
        cross = {
            position = {12.78, 2.0, -21.35},
            rotation = myMapsSetup.overallRotation
        },
        hammer = {
            position = {12.78, 2.0, -19.60},
            rotation = myMapsSetup.overallRotation
        },
        sword1 = {
            position = {10.93, 2.0, -21.34},
            rotation = myMapsSetup.overallRotation
        },
        sword2 = {
            position = {10.94, 2.0, -19.60},
            rotation = myMapsSetup.overallRotation
        },
        tea1 = {
            position = {9.08, 2.0, -21.34},
            rotation = myMapsSetup.overallRotation
        },
        tea2 = {
            position = {9.09, 2.0, -19.60},
            rotation = myMapsSetup.overallRotation
        },
        coin1 = {
            position = {7.24, 2.0, -21.35},
            rotation = myMapsSetup.overallRotation
        },
        coin2 = {
            position = {7.24, 2.0, -19.60},
            rotation = myMapsSetup.overallRotation
        }
    },
    --[[gorge = {
        bag1 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        bag2 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        boot1 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        boot2 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        cross = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        hammer = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        sword1 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        sword2 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        tea1 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        tea2 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        coin1 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        coin2 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        }
    },
    marsh = {
        bag1 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        bag2 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        boot1 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        boot2 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        cross = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        hammer = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        sword1 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        sword2 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        tea1 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        tea2 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        coin1 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        },
        coin2 = {
            position = ,
            rotation = myMapsSetup.overallRotation
        }
    },]]
    mountain = {
        bag1 = {
            position = {14.33, 2.0, -21.18},
            rotation = myMapsSetup.overallRotation
        },
        bag2 = {
            position = {14.33, 2.0, -19.43},
            rotation = myMapsSetup.overallRotation
        },
        boot1 = {
            position = {12.49, 2.0, -21.18},
            rotation = myMapsSetup.overallRotation
        },
        boot2 = {
            position = {12.49, 2.0, -19.43},
            rotation = myMapsSetup.overallRotation
        },
        cross = {
            position = {10.66, 2.0, -21.18},
            rotation = myMapsSetup.overallRotation
        },
        hammer = {
            position = {10.66, 2.0, -19.43},
            rotation = myMapsSetup.overallRotation
        },
        sword1 = {
            position = {8.83, 2.0, -21.17},
            rotation = myMapsSetup.overallRotation
        },
        sword2 = {
            position = {8.83, 2.0, -19.42},
            rotation = myMapsSetup.overallRotation
        },
        tea1 = {
            position = {7.01, 2.0, -21.17},
            rotation = myMapsSetup.overallRotation
        },
        tea2 = {
            position = {7.01, 2.0, -19.42},
            rotation = myMapsSetup.overallRotation
        },
        coin1 = {
            position = {5.18, 2.0, -21.17},
            rotation = myMapsSetup.overallRotation
        },
        coin2 = {
            position = {5.18, 2.0, -19.42},
            rotation = myMapsSetup.overallRotation
        }
    }
}
myExtraFeatureSetup = {
    mountain = {
        pass1 = {
            GUID = "c8991b",
            position = {15.75, 2.5, -1.95},
            rotation = {0.00, 45.00, 0.00}
        },
        pass2 = {
            GUID = "9bff5f",
            position = {4.54, 2.5, -11.45},
            rotation = {0.00, 54.78, 0.00}
        },
        pass3 = {
            GUID = "7584ba",
            position = {-9.03, 2.5, -14.54},
            rotation = {0.00, 100.69, 0.00}
        },
        pass4 = {
            GUID = "e76aac",
            position = {-13.54, 2.5, 2.69},
            rotation = {0.00, 70.89, 0.00}
        },
        pass5 = {
            GUID = "ec5a9b",
            position = {0.53, 2.5, 6.65},
            rotation = {0.00, 80.75, 0.00}
        },
        pass6 = {
            GUID = "70255a",
            position = {-11.31, 2.5, 14.94},
            rotation = {0.00, 75.00, 0.00}
        }
    }
}
--[[myExtraLandmarkSetup = {
    cardPosition = ,
    mountain = {
        tower = {
            GUID = "",
            cardGUID = "",
            position = ,
            rotation = myMapsSetup.overallRotation,
        },
        city = {
            GUID = "",
            cardGUID = "",
            position = ,
            rotation = myMapsSetup.overallRotation,
        },
        spire = {
            GUID = "",
            cardGUID = "",
            position = ,
            rotation = myMapsSetup.overallRotation,
        },
    }
    lake = {
        ferry = {
            GUID = "",
            cardGUID = "",
            position = ,
            rotation = myMapsSetup.overallRotation,
        }
    }
}]]
myRuinItemGUIDs = {
    --GUID of unrevealed items / ruin state
    boot = {
        ["1"] = "c3227f", 
        ["2"] = "f103dd"
    },
    bag = {
        ["1"] = "a6ad41", 
        ["2"] = "880fa1"
    },
    hammer = {
        ["1"] = "793b9b", 
        ["2"] = "008fd8"
    },
    sword = {
        ["1"] = "fedb9a", 
        ["2"] = "447bcb"
    }
}
myRuinItemPositions = {
    autumn = {
        {3.10, 2.0, -7.48}, 
        {7.62, 2.0, 2.03}, 
        {-5.53, 2.0, 0.76}, 
        {-20.79, 2.0, -0.80}
    },
    winter = {
        {7.70, 2.0, -1.40}, 
        {-4.78, 2.0, -3.22}, 
        {-3.51, 2.0, 9.79}, 
        {6.97, 2.0, 17.63}
    },
    lake = {
        {7.80, 2.0, -6.51}, 
        {-8.74, 2.0, -2.78}, 
        {-19.91, 2.0, 5.45}, 
        {8.62, 2.0, 9.49}
    },
    --[[gorge = {
    },
    marsh = {
    },]]
    mountain = {
        {9.22, 2.0, -8.77}, 
        {1.79, 2.0, -6.36}, 
        {9.15, 2.0, 9.20}, 
        {-6.36, 2.0, 3.51}
    },
}

----------------------
-- onload function
----------------------
function onLoad()
    resetSuitPool()
    createAllButtons()
end

----------------------
-- helper functions
----------------------
function doNothing()
end

function shufflePool(pool)
    for i = #pool, 2, -1 do
        local j = math.random(i)
        pool[i], pool[j] = pool[j], pool[i]
    end
end

function broadcastPlayer(message, color)
    local playerName = Player[color].steam_name or color
    broadcastToAll(playerName .. " selected " .. message .. "!", color)
end

function dealAdset()
    local deckZone = getObjectFromGUID("cf89ff")

    local deck = nil
    for _, obj in ipairs(deckZone.getObjects()) do
        if obj.tag == "Deck" then
            deck = obj
        end
    end
    if not deck then return end
    
    local players = getSeatedPlayers()
    if #players == 0 then return end

    local turnOrder = Turns.order
    if not turnOrder or #turnOrder == 0 then
        Turns.enable = true
        Turns.type = 2
        Turns.order = players
        turnOrder = Turns.order
    end

    if not turnOrder or #turnOrder == 0 then
        turnOrder = players
    end

    deck.shuffle()
    for i, playerColor in ipairs(turnOrder) do
        deck.dealToColor(5, playerColor)
    end
end

----------------------
-- button create functions
----------------------
-- master create button
function createAllButtons()
    createResetButton()
    createConfirmButton()
    createFormatButtons()
    createMapButtons()
    createSuitButtons()
    createRuinButtons()
    createDeckButtons()
end

function createResetButton()
    self.createButton({
        click_function = "onClickFunction_Reset",
        function_owner = self,
        label = "Reset All",
        tooltip = "Return all map objects to their orignal state and back to bag.",
        width = myButtons.genericMain.buttonWidth,
        height = myButtons.genericMain.buttonHeight,
        font_size = myButtons.genericMain.fontSize,
        font_color = myColors.black,
        color = myColors.white,
        position = myButtons.resetButton,
        rotation = myButtons.genericMain.buttonRotation,
        scale = myButtons.genericMain.scale
    })
end

function createConfirmButton()
    self.createButton({
        click_function = "onClickFunction_Confirm",
        function_owner = self,
        label = "Confirm",
        tooltip = "Confirm the settings of the game.",
        width = myButtons.genericMain.buttonWidth,
        height = myButtons.genericMain.buttonHeight,
        font_size = myButtons.genericMain.fontSize,
        font_color = myColors.black,
        color = myColors.white,
        position = myButtons.confirmButton,
        rotation = myButtons.genericMain.buttonRotation,
        scale = myButtons.genericMain.scale
    })
end

-- format buttons
function createFormatButtons()
    local buttonColor = myColors.white
    local buttonLabel = ""
    local buttonTooltip = ""
    local buttonsPerRow = 3
    for i, formatLabel in ipairs(myIterations.formatButtonLabels) do
        if formatLabel == "Printed" then
            buttonColor = myColors.gray
            buttonLabel = "Printed Classic"
            buttonTooltip = "Set the play format to Printed Classic."
        elseif formatLabel == "Comprehensive" then
            buttonColor = myColors.gray
            buttonLabel = "Comprehensive\nClassic"
            buttonTooltip = "Set the play format to Comprehensive Classic (tournament rules for Classic)."
        elseif formatLabel == "AdSet" then
            buttonColor = myColors.gray
            buttonLabel = "Printed AdSet"
            buttonTooltip = "Set the play format to Printed AdSet."
        elseif formatLabel == "ModAdSet" then
            buttonColor = myColors.gray
            buttonLabel = "Modified AdSet"
            buttonTooltip = "Set the play format to Modified AdSet (tournament rules for AdSet)."
        elseif formatLabel == "Landmarks" then
            buttonColor = myColors.white
            buttonLabel = "Landmarks:\nNone"
            buttonTooltip = "Cycle through playing with: None, Printed, Competitive, Random 1, or Random 2 Landmarks."
        elseif formatLabel == "Hirelings" then
            buttonColor = myColors.white
            buttonLabel = "Hirelings:\nNo"
            buttonTooltip = "Cycle through whether playing with or without Hirelings."
        else
            buttonColor = myColors.red
            buttonLabel = "Unknown"
            buttonTooltip = ""
        end

        local row = math.floor((i-1) / buttonsPerRow)
        local col = (i-1) % buttonsPerRow
        self.createButton({
            click_function = "onClickFunction_Format" .. formatLabel,
            function_owner = self,
            label = buttonLabel,
            tooltip = buttonTooltip,
            width = myButtons.genericMain.buttonWidth,
            height = myButtons.genericMain.buttonHeight,
            font_size = myButtons.setupButtonsMain.fontSize,
            color = buttonColor,
            position = {
                myButtons.setupButtonsMain.startX + col * myButtons.setupButtonsMain.spacingX,
                myButtons.genericMain.buttonLift,
                myButtons.setupButtonsMain.startZ + row * myButtons.setupButtonsMain.spacingZ
            },
            rotation = myButtons.genericMain.buttonRotation,
            scale = myButtons.setupButtonsMain.scale
        })
    end
end

-- map buttons
function createMapButtons()
    createMapMainButtons()
end

function createMapMainButtons()
    local mapColor = ""
    local mapFontColor = ""
    local buttonsPerRow = 3
    for i, mapVar in ipairs(myIterations.maps) do
        if myColors.mapSpecific[mapVar] ~= nil then
            mapColor = myColors.mapSpecific[mapVar]
            if mapVar == "lake" then
                mapFontColor = myColors.white
            else
                mapFontColor = myColors.black
            end
        else
            mapColor = myColors.gray
            mapFontColor = myColors.red
        end

        local row = math.floor((i-1) / buttonsPerRow)
        local col = (i-1) % buttonsPerRow
        self.createButton({
            click_function = "onClickFunction_" .. tostring(mapVar),
            function_owner = self,
            label = tostring(mapVar:gsub("^%l", string.upper)),
            tooltip = "Select " .. tostring(mapVar:gsub("^%l", string.upper)) .. " as the map.",
            width = myButtons.genericMain.buttonWidth,
            height = myButtons.genericMain.buttonHeight,
            font_size = myButtons.genericMain.fontSize,
            font_color = mapFontColor,
            color = mapColor,
            position = {
                myButtons.mapButtonsMain.startX + col * myButtons.mapButtonsMain.spacingX,
                myButtons.genericMain.buttonLift,
                myButtons.mapButtonsMain.startZ + row * myButtons.mapButtonsMain.spacingZ
            },
            rotation = myButtons.genericMain.buttonRotation,
            scale = myButtons.mapButtonsMain.scale
        })
    end
end

-- suit buttons
function createSuitButtons()
    createSuitsMainButtons()
end

function createSuitsMainButtons()
    local buttonsPerRow = 4
    local myTooltip = ""
    for i, suitButtonLabel in ipairs(myIterations.suitButtonLabels) do
        local row = math.floor((i-1) / buttonsPerRow)
        local col = (i-1) % buttonsPerRow

        if suitButtonLabel == "Random" then
            myTooltip = "Set random clearings."
        elseif suitButtonLabel == "Default" then
            myTooltip = "Set default clearings if possible; else, random."
        elseif suitButtonLabel == "Reset" then
            myTooltip = "Change all clearings back to their original state."
        elseif suitButtonLabel == "Draw" then
            myTooltip = "Manually draw a random suit for one clearing."
        else
            myTooltip = "N/A"
        end

        self.createButton({
            click_function = "onClickFunction_Suit" .. suitButtonLabel,
            function_owner = self,
            label = suitButtonLabel,
            tooltip = myTooltip,
            width = myButtons.genericMain.buttonWidth,
            height = myButtons.genericMain.buttonHeight,
            font_size = myButtons.genericMain.fontSize,
            font_color = myColors.black,
            color = myColors.white,
            position = {
                myButtons.suitButtonsMain.startX + col * myButtons.suitButtonsMain.spacingX,
                myButtons.genericMain.buttonLift,
                myButtons.suitButtonsMain.startZ + row * myButtons.suitButtonsMain.spacingZ
            },
            rotation = myButtons.genericMain.buttonRotation,
            scale = myButtons.suitButtonsMain.scale
        })
    end
end

-- ruins buttons
function createRuinButtons()
    createRuinMainButtons()
end

function createRuinMainButtons()
    local buttonsPerRow = 4
    local myTooltip = ""
    for i, ruinButtonLabel in ipairs(myIterations.ruinButtonLabels) do
        local row = math.floor((i-1) / buttonsPerRow)
        local col = (i-1) % buttonsPerRow

        if ruinButtonLabel == "None" then
            myTooltip = "Place and lock 1 set of ruins."
        elseif ruinButtonLabel == "One" then
            myTooltip = "Place and unlock 1 set of ruins."
        elseif ruinButtonLabel == "Two" then
            myTooltip = "Place and unlock 2 sets of ruins."
        elseif ruinButtonLabel == "Reset" then
            myTooltip = "Return all ruins to the bag."
        else
            myTooltip = "N/A"
        end

        self.createButton({
            click_function = "onClickFunction_Ruin" .. ruinButtonLabel,
            function_owner = self,
            label = ruinButtonLabel,
            tooltip = myTooltip,
            width = myButtons.genericMain.buttonWidth,
            height = myButtons.genericMain.buttonHeight,
            font_size = myButtons.genericMain.fontSize,
            font_color = myColors.black,
            color = myColors.white,
            position = {
                myButtons.ruinButtonsMain.startX + col * myButtons.ruinButtonsMain.spacingX,
                myButtons.genericMain.buttonLift,
                myButtons.ruinButtonsMain.startZ + row * myButtons.ruinButtonsMain.spacingZ
            },
            rotation = myButtons.genericMain.buttonRotation,
            scale = myButtons.ruinButtonsMain.scale
        })
    end
end

-- deck buttons
function createDeckButtons()
    createDeckMainButtons()
end

function createDeckMainButtons()
    local myLabel = ""
    local buttonsPerRow = 3
    for i, deckLabel in ipairs(myIterations.deckButtonLabels) do
        if deckLabel == "Exiles & Partisans" then
            myLabel = "Exiles &\nPartisans"
        elseif deckLabel == "Squires & Disciples" then
            myLabel = "Squires &\nDisciples" 
        else
            myLabel = deckLabel
        end

        local row = math.floor((i-1) / buttonsPerRow)
        local col = (i-1) % buttonsPerRow
        self.createButton({
            click_function = "onClickFunction_Deck" .. tostring(deckLabel),
            function_owner = self,
            label = myLabel,
            tooltip = "Select " .. tostring(deckLabel:gsub("^%l", string.upper)) .. " as the deck.",
            width = myButtons.genericMain.buttonWidth,
            height = myButtons.genericMain.buttonHeight,
            font_size = myButtons.deckButtonsMain.fontSize,
            font_color = myColors.black,
            color = myColors.white,
            position = {
                myButtons.deckButtonsMain.startX + col * myButtons.deckButtonsMain.spacingX,
                myButtons.genericMain.buttonLift,
                myButtons.deckButtonsMain.startZ + row * myButtons.deckButtonsMain.spacingZ
            },
            rotation = myButtons.genericMain.buttonRotation,
            scale = myButtons.deckButtonsMain.scale
        })
    end
end

----------------------
-- on click functions
----------------------
function onClickFunction_Reset()
    resetAllPieces()
end

for _, mapVar in ipairs(myIterations.maps) do
    _G["onClickFunction_" .. mapVar] = function(obj, color, alt_click)
        broadcastPlayer("the " .. mapVar:gsub("^%l", string.upper) .. " map", color)
        placeAllMap(mapVar)
        oneRuinLock()
    end
end

function onClickFunction_SuitRandom()
    randomSuits()
end

function onClickFunction_SuitDefault()
    defaultSuits()
end

function onClickFunction_SuitDraw()
    local result = drawSuit()
    if result ~= nil then
        broadcastToAll("Drawn: " .. result .. ", " .. #myBookkeepingVariables.suitPool .. " left.", myColors.suits[result])
    else 
        broadcastToAll("Please select a map first.")
    end
end

function onClickFunction_SuitReset()
    broadcastToAll("Suits reverted to default (Fox).")
    revertSuits()
end

function onClickFunction_RuinNone()
    if myBookkeepingVariables.currentMap == "" then
        broadcastToAll("Please select a map first.")
        return
    end
    oneRuinLock()
end

function onClickFunction_RuinOne()
    if myBookkeepingVariables.currentMap == "" then
        broadcastToAll("Please select a map first.")
        return
    end
    oneRuinUnlock()
end

function onClickFunction_RuinTwo()
    if myBookkeepingVariables.currentMap == "" then
        broadcastToAll("Please select a map first.")
        return
    end
    twoRuinUnlock()
end

function onClickFunction_RuinReset()
    ruinRecall()
end

for _, deckLabel in ipairs(myIterations.deckButtonLabels) do
    _G["onClickFunction_Deck" .. deckLabel] = function(obj, color, alt_click)
        broadcastPlayer("the " .. deckLabel .. " deck", color)
        selectDeck(deckLabel)
    end
end

for _, formatLabel in ipairs(myIterations.formatButtonLabels) do
    _G["onClickFunction_" .. formatLabel] = function(obj, color, alt_click)
        if formatLabel ~= "Landmarks" or formatLabel ~= "Hirelings" then
            broadcastPlayer("the " .. formatLabel .. " format", color)
            -- function for the format
        elseif formatLabel == "Landmarks" then 
            -- function for landmarks setting
        elseif formatLabel == "Hirelings" then 
            -- function for Hirelings setting
        else
            broadcastToAll("Unknown button function for myIterations.formatButtonLabels!")
        end
    end
end

function onClickFunction_Confirm()
    confirmSettings()
end

----------------------
-- actual function: RESET & CONFIRM
----------------------
function resetAllPieces()
    revertSuits()
    for _, GUID in ipairs(myBookkeepingVariables.totalPlaced) do
        local obj = getObjectFromGUID(GUID)
        if obj ~= nil and obj.guid ~= nil then
            obj.setLock(false)
            obj.interactable = true
            myBagObjs.mapBag.putObject(obj)
        end
    end
    for _, GUID in ipairs(myBookkeepingVariables.totalPlacedLandmarks) do
        local obj = getObjectFromGUID(GUID)
        if obj ~= nil and obj.guid ~= nil then
            obj.setLock(false)
            obj.interactable = true
            myBagObjs.landmarksBag.putObject(obj)
        end
    end
    myBookkeepingVariables.totalPlaced = {}
    myBookkeepingVariables.currentMap = ""
    GLOBALNUMLANDMARKS = 0
end

function confirmSettings()
    confirmGlobalSettings()
    if myBookkeepingVariables.currentFormat == "AdSet" or myBookkeepingVariables.currentFormat == "ModAdSet" then
        dealAdset()
    end
    setupLandmarks()
    setupHirelings()
    setupDraft()
end

----------------------
-- actual function: MAPS
----------------------
function placeAllMap(mapVar)
    resetAllPieces()
    placeMap(mapVar)
    placeMarkers(mapVar)
    placeSupply(mapVar)
    placeExtra()
end

function placeMap(mapVar)
    if not myMapsSetup[mapVar] then
        broadcastToAll("Map object for " .. mapVar .. " not found.")
        return
    end

    local mapGUID = myMapsSetup[mapVar]
    for _, obj in ipairs(myBagObjs.mapBag.getObjects()) do
        if obj.guid == mapGUID then
            local mapObj = myBagObjs.mapBag.takeObject({
                guid = mapGUID,
                position = myMapsSetup.overallPosition,
                rotation = myMapsSetup.overallRotation,
                smooth = false,
            })
            mapObj.setLock(true)
            mapObj.interactable = false
            table.insert(myBookkeepingVariables.totalPlaced, mapGUID)
            myBookkeepingVariables.currentMap = tostring(mapVar)
            if myBookkeepingVariables.currentMap == "marsh" then
                myBookkeepingVariables.markersList = myIterations.extendedMarkers
            else
                myBookkeepingVariables.markersList = myIterations.markers
            end
            break
        end
    end

    if mapVar == "mountain" then
        placeMountainExtra()
    end
end

function placeMarkers(mapVar)
    for _, markerLabel in ipairs(myIterations.markers) do
        local markerGUID = myMarkerGUIDSetup[markerLabel].Fox
        local markerPosition = myMarkerLocationSetup[mapVar][markerLabel].position
        local markerRotation = myMarkerLocationSetup[mapVar][markerLabel].rotation

        local markerObj = myBagObjs.mapBag.takeObject({
            guid = markerGUID,
            position = markerPosition,
            rotation = markerRotation,
            smooth = false
        })
        Wait.time(function()
            markerObj.setLock(true)
        end, 2)
        table.insert(myBookkeepingVariables.totalPlaced, markerGUID)
    end
end

function placeSupply(mapVar)
    for _, supplyItemLabel in ipairs(myIterations.supplyItems) do
        local supplyItemGUID = mySupplyGUIDSetup[supplyItemLabel]
        local supplyItemPosition = mySupplyPositionSetup[mapVar][supplyItemLabel].position
        local supplyItemRotation = mySupplyPositionSetup[mapVar][supplyItemLabel].rotation

        local supplyItemObj = myBagObjs.mapBag.takeObject({
            guid = supplyItemGUID,
            position = supplyItemPosition,
            rotation = supplyItemRotation,
            smooth = false
        })
        supplyItemObj.setLock(true)
        Wait.time(function()
            supplyItemObj.setLock(false)
        end, 2)
        table.insert(myBookkeepingVariables.totalPlaced, supplyItemGUID)
    end
end

function placeExtra()
    for extraKey, extraData in pairs(myMapsSetup.extras) do
        local targetExtraGUID = extraData.GUID
        local targetExtraObj = myBagObjs.mapBag.takeObject({
            guid = targetExtraGUID,
            position = extraData.position,
            rotation = extraData.rotation,
            smooth = false
        })
        targetExtraObj.setLock(extraData.lock)
        targetExtraObj.interactable = extraData.interact
        table.insert(myBookkeepingVariables.totalPlaced, targetExtraGUID)
    end
end

----------------------
-- actual function: MAPS EXTRA
----------------------
function placeMountainExtra()
    for _, passLabel in pairs(myExtraFeatureSetup.mountain) do
        local targetExtraGUID = passLabel.GUID
        local targetExtraObj = myBagObjs.mapBag.takeObject({
            guid = targetExtraGUID,
            position = passLabel.position,
            rotation = passLabel.rotation,
            smooth = false
        })
        table.insert(myBookkeepingVariables.totalPlaced, targetExtraGUID)
    end
end

----------------------
-- actual function: SUITS
----------------------
function randomSuits()
    revertSuits()

    for _, markerLabel in ipairs(myBookkeepingVariables.markersList) do
        local targetMarker = getObjectFromGUID(myMarkerGUIDSetup[markerLabel].Fox)
        local rolledSuit = drawSuit()
        if rolledSuit == "Mouse" then
            targetMarker.setState(2)
        elseif rolledSuit == "Bunny" then
            targetMarker.setState(3)
        else
            --else, do nothing and it remains on fox
        end
        broadcastToAll("Suit " .. markerLabel .. " is " .. rolledSuit .. ".", myColors.suits[rolledSuit])
    end
end

function defaultSuits()
    broadcastToAll("Currently unimplemented.")
end

function revertSuits()
    resetSuitPool()
    resetSuitMarkers()
end

function resetSuitPool()
    myBookkeepingVariables.suitPool = {}
    for i, suit in ipairs(myIterations.suitLabels) do 
        for i = 1, #myBookkeepingVariables.markersList/3 do 
            table.insert(myBookkeepingVariables.suitPool, suit)
        end 
    end
end

function resetSuitMarkers()
    for _, markerLabel in ipairs(myBookkeepingVariables.markersList) do
        local targetMarker = getObjectFromGUID(myMarkerGUIDSetup[markerLabel].Mouse) or getObjectFromGUID(myMarkerGUIDSetup[markerLabel].Bunny)
        if targetMarker ~= nil then
            targetMarker.setState(1)
        end
    end
end

function drawSuit()
    if #myBookkeepingVariables.suitPool == 0 then
        broadcastToAll("No suits left.")
        return 
    end
   
    local index = math.random(#myBookkeepingVariables.suitPool)
    local drawnSuit = myBookkeepingVariables.suitPool[index]
    table.remove(myBookkeepingVariables.suitPool, index)
    return drawnSuit
end

----------------------
-- actual function: RUINS
----------------------
function oneRuinUnlock()
    ruinRecall()
    ruinResetPool("1")
    ruinPlace()
end

function oneRuinLock()
    oneRuinUnlock()
    Wait.time(function() 
        for i, GUID in ipairs(myBookkeepingVariables.ruinsPool) do
            local targetRuin = getObjectFromGUID(GUID)
            targetRuin.setLock(true)
        end
    end, 2, 0)
end

function twoRuinUnlock()
    oneRuinUnlock()
    ruinResetPool("2")
    ruinPlace()
end

function ruinPlace()
    for i, GUID in ipairs(myBookkeepingVariables.ruinsPool) do
        local basePosition = myRuinItemPositions[myBookkeepingVariables.currentMap][i]
        if basePosition then
            local targetRuin = myBagObjs.mapBag.takeObject({
                guid = GUID,
                position = {
                    basePosition[1],
                    basePosition[2] + 2,
                    basePosition[3]
                },
                rotation = myMapsSetup.overallRotation,
                smooth = false
            })
            table.insert(myBookkeepingVariables.totalPlaced, GUID)
        end
    end
end

function ruinRecall()
    for _, itemLabel in ipairs(myIterations.ruinItems) do
        for setNum, guid in pairs(myRuinItemGUIDs[itemLabel]) do
            local targetRuin = getObjectFromGUID(guid)
            if targetRuin then
                targetRuin.setLock(false)
                myBagObjs.mapBag.putObject(targetRuin)
            end
        end
    end
end

function ruinResetPool(set)
    myBookkeepingVariables.ruinsPool = {}
    for _, itemLabel in ipairs(myIterations.ruinItems) do
        local GUID = myRuinItemGUIDs[itemLabel][set]
        table.insert(myBookkeepingVariables.ruinsPool, GUID)
    end
    shufflePool(myBookkeepingVariables.ruinsPool)
end

----------------------
-- actual function: DECK
----------------------
function selectDeck(deckLabel)
    resetDeck()

    local deckZone = getObjectFromGUID(myMapsSetup.deckZoneGUID)
    local deck = myBagObjs.mapBag.takeObject({
        guid = myDeckGUIDs[deckLabel],
        position = deckZone.getPosition(),
        rotation = {0, 90, 180},
        smooth = false
    })
    table.insert(myBookkeepingVariables.totalPlaced, myDeckGUIDs[deckLabel])
    if deck then
        deck.shuffle()
    end
    --setCardAid(deckLabel)
end

function resetDeck()
    local deckZone = getObjectFromGUID(myMapsSetup.deckZoneGUID)
    local objectsInZone = deckZone.getObjects()
    for _, obj in ipairs(objectsInZone) do
        if obj.tag == "Deck" then
            myBagObjs.mapBag.putObject(obj)
        end
    end
    --setCardAid("")
end

function setCardAid(deckLabel)
    local cardAidGUID = myMapsSetup.extras.cardAid.GUID
    local cardAidObj = getObjectFromGUID(cardAidGUID)

    if deckLabel == "" then
        cardAidObj.setPage(1)
    else 
        for i, label in ipairs(myDeckGUIDs) do
            if label == deckLabel then
                cardAidObj.setPage(i)
                break
            end
        end
    end 
end

----------------------
-- actual function: FORMATS
----------------------
function onClickFunction_FormatPrinted(obj, player_color, alt_click)
    selectFormatButton(2)
    broadcastToAll("Currently unimplemented.")
end

function onClickFunction_FormatComprehensive(obj, player_color, alt_click)
    selectFormatButton(3)
end

function onClickFunction_FormatAdSet(obj, player_color, alt_click)
    selectFormatButton(4)
    broadcastToAll("Currently unimplemented.")
end

function onClickFunction_FormatModAdSet(obj, player_color, alt_click)
    selectFormatButton(5)
end

function onClickFunction_FormatLandmarks(obj, player_color, alt_click)
    cycleLandmarks(alt_click)
end

function onClickFunction_FormatHirelings(obj, player_color, alt_click)
    cycleHirelings(alt_click)
end

function cycleLandmarks(alt_click)
    local targetIndex = 0
    for i, label in ipairs(myIterations.landmarkCycle) do
        if label == myBookkeepingVariables.currentLandmarkFormat then
            if alt_click then
                targetIndex = ((i - 1 - 1 + #myIterations.landmarkCycle) % #myIterations.landmarkCycle) + 1
            else
                targetIndex = ((i - 1 + 1) % #myIterations.landmarkCycle) + 1 
            end
        end
    end
    self.editButton({
        index = 6,
        label = "Landmarks:\n" .. myIterations.landmarkCycle[targetIndex]
    })
    myBookkeepingVariables.currentLandmarkFormat = myIterations.landmarkCycle[targetIndex]
end

function cycleHirelings(alt_click)
    local targetIndex = 0
    for i, label in ipairs(myIterations.hirelingCycle) do
        if label == myBookkeepingVariables.currentHirelingFormat then
            if alt_click then
                targetIndex = ((i - 1 - 1 + #myIterations.hirelingCycle) % #myIterations.hirelingCycle) + 1
            else
                targetIndex = ((i - 1 + 1) % #myIterations.hirelingCycle) + 1 
            end
        end
    end
    self.editButton({
        index = 7,
        label = "Hirelings:\n" .. myIterations.hirelingCycle[targetIndex]
    })
    myBookkeepingVariables.currentHirelingFormat = myIterations.hirelingCycle[targetIndex]
end

function selectFormatButton(i)
    resetFormatButtons()
    self.editButton({
        index = i,
        color = myColors.green
    })
    myBookkeepingVariables.currentFormat = myIterations.formatButtonLabels[i - 1]
end

function resetFormatButtons()
    -- see button indexes
    for i = 2, 5 do 
        self.editButton({
            index = i,
            color = myColors.gray
        })
    end
end

----------------------
-- actual function: POST FORMAT SETUP
----------------------
function setupLandmarks()
    if myBookkeepingVariables.currentLandmarkFormat == "None" then
        -- nothing
    elseif myBookkeepingVariables.currentLandmarkFormat == "Printed" then
        placeLandmarks()
    elseif myBookkeepingVariables.currentLandmarkFormat == "Competitive" then
        placeLandmarks()
    else
        placeLandmarkBoard()
    end
end

function placeLandmarks()
    local targetLabel = ""
    if myBookkeepingVariables.currentMap == "lake" then
        targetLabel = "ferry"
    elseif myBookkeepingVariables.currentMap == "mountain" then
        if myBookkeepingVariables.currentLandmarkFormat == "Printed" then
            targetLabel = "tower"
        elseif myBookkeepingVariables.currentLandmarkFormat == "Competitive" then
            targetLabel = "city"
        end
    else
        return
    end

    local targetMeepleObj = myBagObjs.landmarksBag.takeObject({
        guid = myLandmarkSetup[targetLabel].meepleGUID,
        position = myLandmarkSetup[targetLabel].meeplePosition,
        rotation = myLandmarkSetup[targetLabel].meepleRotation,
        smooth = false,
    })
    table.insert(myBookkeepingVariables.totalPlacedLandmarks, myLandmarkSetup[targetLabel].meepleGUID)
    if targetLabel ~= "ferry" then
        Wait.time(function()
            targetMeepleObj.setLock(true)
        end, 2)
    end
        
    if targetLabel == "city" then
        local targetObj = myBagObjs.landmarksBag.takeObject({
            guid = myLandmarkSetup.citymarker.meepleGUID,
            position = myLandmarkSetup.citymarker.meeplePosition,
            rotation = myLandmarkSetup.citymarker.meepleRotation,
            smooth = false,
        })
        table.insert(myBookkeepingVariables.totalPlacedLandmarks, myLandmarkSetup.citymarker.meepleGUID)
        Wait.time(function()
            targetObj.setLock(true)
        end, 2)
    end

    targetObj = myBagObjs.landmarksBag.takeObject({
        guid = myLandmarkSetup[targetLabel].cardGUID,
        position = myLandmarkSetup.cardPosition,
        rotation = myLandmarkSetup.cardRotation,
        smooth = false,
    })
    table.insert(myBookkeepingVariables.totalPlacedLandmarks, myLandmarkSetup[targetLabel].cardGUID)
end

function placeLandmarkBoard()
    local targetExtraObj = myBagObjs.mapBag.takeObject({
        guid = myMapsSetup.boards.landmark.GUID,
        position = myMapsSetup.boards.landmark.position,
        rotation = myMapsSetup.boards.landmark.rotation,
        smooth = false
    })
    targetExtraObj.setLock(myMapsSetup.boards.landmark.lock)
    targetExtraObj.interactable = myMapsSetup.boards.landmark.interact
    table.insert(myBookkeepingVariables.totalPlaced, myMapsSetup.boards.landmark.GUID)
end

function setupHirelings()
    if myBookkeepingVariables.currentHirelingFormat == "Yes" then
        placeHirelingsBoard()
    end
end

function placeHirelingsBoard()
    local targetExtraObj = myBagObjs.mapBag.takeObject({
        guid = myMapsSetup.boards.hireling.GUID,
        position = myMapsSetup.boards.hireling.position,
        rotation = myMapsSetup.boards.hireling.rotation,
        smooth = false
    })
    targetExtraObj.setLock(myMapsSetup.boards.hireling.lock)
    targetExtraObj.interactable = myMapsSetup.boards.hireling.interact
    table.insert(myBookkeepingVariables.totalPlaced, myMapsSetup.boards.hireling.GUID)
end

function setupDraft()
    placeDraftBoard()
end

function placeDraftBoard()
    local targetExtraObj = myBagObjs.mapBag.takeObject({
        guid = myMapsSetup.boards.draft.GUID,
        position = myMapsSetup.boards.draft.position,
        rotation = myMapsSetup.boards.draft.rotation,
        smooth = false
    })
    targetExtraObj.setLock(myMapsSetup.boards.hireling.lock)
    targetExtraObj.interactable = myMapsSetup.boards.draft.interact
    table.insert(myBookkeepingVariables.totalPlaced, myMapsSetup.boards.draft.GUID)
end


function confirmGlobalSettings()
    --accessing global variable
    if myBookkeepingVariables.currentLandmarkFormat == "Random 1" then
        Global.setVar("GLOBALNUMLANDMARKS", 1)
    elseif myBookkeepingVariables.currentLandmarkFormat == "Random 2" then
        Global.setVar("GLOBALNUMLANDMARKS", 2)
    else 
        Global.setVar("GLOBALNUMLANDMARKS", 0)
    end
    Global.setVar("GLOBALSETTING", myBookkeepingVariables.currentFormat)

    local checkLandmarks = Global.getVar("GLOBALNUMLANDMARKS")
    local checkSetting = Global.getVar("GLOBALSETTING")

    broadcastToAll("Settings confirmed.")
    broadcastToAll("Format: " .. checkSetting .. ".")
    broadcastToAll("Landmarks: " .. checkLandmarks .. ".")
    broadcastToAll("Hirelings: " .. myBookkeepingVariables.currentHirelingFormat .. ".")
end

----------------------
-- temp placement
----------------------