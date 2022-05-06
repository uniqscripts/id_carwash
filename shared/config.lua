Config = {}

Config.CarWash = vector3(-699.8639, -932.8102, 18.3358) -- Car Wash Location

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

Config.MarkerDistance = 16 -- Distance for displaying marker
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
