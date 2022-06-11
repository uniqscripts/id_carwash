Config = {}

Config.CarWash = {
    {
        coords = vector3(25.29, -1391.96, 29.33),
        polyzoneBoxData = {
            heading = 269.95,
            width = 40.0,
            length = 40.0,
            innerWidth = 3.5,
            innerLength = 5.5,
            debug = true
        }
    },
    {
        coords = vector3(174.18, -1736.66, 29.35),
        polyzoneBoxData = {
            heading = 269.58,
            width = 40.0,
            length = 40.0,
            innerWidth = 4.5,
            innerLength = 5.5,
            debug = true
        }
    },
    {
        coords = vector3(-74.56, 6427.87, 31.44),
        polyzoneBoxData = {
            heading = 0.0,
            width = 40.0,
            length = 40.0,
            innerWidth = 4.5,
            innerLength = 5.5,
            debug = true
        }
    },
    {
        coords = vector3(1363.22, 3592.7, 34.92),
        polyzoneBoxData = {
            heading = 0.0,
            width = 40.0,
            length = 40.0,
            innerWidth = 4.5,
            innerLength = 5.5,
            debug = true
        }
    },
    {
        coords = vector3(-699.62, -932.7, 19.01),
        polyzoneBoxData = {
            heading = 0.0,
            width = 40.0,
            length = 40.0,
            innerWidth = 4.5,
            innerLength = 5.5,
            debug = true
        }
    },
    
} -- Car Wash Location

Config.Blip = { -- https://docs.fivem.net/docs/game-references/blips/
    ID = 100,
    Size = 1.0,
    Display = "Car Wash",
    Colour = 4
}

Config.WashPrice = 1000 -- Price for washing vehicle
Config.WashDuration = 5 -- Duration of vehicle washing (in seconds)

Config.Marker = { -- https://docs.fivem.net/docs/game-references/markers/
    Type = 36,
    ColorR = 51,
    ColorG = 153,
    ColorB = 255
}

Config.MarkerDistance = 16.0 -- Distance for displaying marker
Config.TextUIDistance = 4 -- Distance for displaying ox_lib Text UI
Config.TextUIicon = "car" -- Icon for ox_lib Text UI (font awesome icons - https://fontawesome.com/icons)

Config.OwnerCategoryEveryone = false -- If everyone can see owner category (access button, money in business) / false - only business owner can see owner category

Config.Translation = {
    -- Progress Bar
    WashingVehicle = "Washing Your Vehicle",

    -- Notification
    Title = "Car Wash",
    Message = "Your vehicle is successfully washed.",
    notEnoughMoney = "You do not have enough money to wash your vehicle",
        -- OWNER MENU
        NotOwner = "You are not car wash owner",

    -- Text UI
    AccessCarWash = "Wash Your Vehicle",
}
