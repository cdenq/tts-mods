function onLoad()
    self.createButton({
        click_function = "processCardsInBag",
        function_owner = self,
        label = "Set description Rabbit",
        position = {0, 0.5, 0},
        width = 800,
        height = 400,
        font_size = 200
    })
end

function processCardsInBag()
    local bag = getObjectFromGUID("ab3ac4")
    if not bag then
        print("Bag not found!")
        return
    end

    local bagContents = bag.getObjects()
    print("Found " .. #bagContents .. " objects in bag")
    
    -- Process each object that has cards (is a deck)
    for i, obj in ipairs(bagContents) do
        if obj.name and obj.guid then  -- If it's a valid object
            print("Processing: " .. obj.name)
            local deck = bag.takeObject({
                guid = obj.guid,
                position = {0, 5, 0},
                callback_function = function(spawnedDeck)
                    if spawnedDeck.getObjects then  -- Check if it has cards
                        processCardsInDeck(spawnedDeck, bag)
                    else
                        print("Not a deck: " .. obj.name)
                        bag.putObject(spawnedDeck)
                    end
                end
            })
        end
    end
end

function processCardsInDeck(deck, bag)
    local cards = deck.getObjects()
    print("Processing " .. #cards .. " cards in deck: " .. deck.getName())
    
    local cardIndex = 1
    local function processNextCard()
        if cardIndex <= #cards then
            local card = deck.takeObject({
                guid = cards[cardIndex].guid,
                position = {2, 5, 0},
                callback_function = function(spawnedCard)
                    print("Moving description to GMNotes for card " .. cardIndex)
                    local currentDescription = spawnedCard.getDescription()
                    spawnedCard.setGMNotes(currentDescription)
                    spawnedCard.setDescription("")
                    spawnedCard.addTag("Root Card")
                    deck.putObject(spawnedCard)
                    cardIndex = cardIndex + 1
                    Wait.frames(processNextCard, 5)
                end
            })
        else
            print("Finished processing deck: " .. deck.getName())
            bag.putObject(deck)
        end
    end
    
    processNextCard()
end