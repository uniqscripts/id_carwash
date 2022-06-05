GlobalState.CarWash = {
	vector3(-699.8639, -932.8102, 18.3358),
	vector3(20.68, -1391.85, 29.32),
	vector3(167.79, -1715.69, 29.29),
}

GlobalState.Blip = { -- https://docs.fivem.net/docs/game-references/blips/
    ID = 100,
    Size = 1.0,
    Display = "Car Wash",
    Colour = 4
}

GlobalState.WashPrice = 1000 -- Price for washing vehicle
GlobalState.WashDuration = 5 -- Duration of vehicle washing (in seconds)

GlobalState.Marker = { -- https://docs.fivem.net/docs/game-references/markers/
    Type = 36,
    ColorR = 51,
    ColorG = 153,
    ColorB = 255
}

GlobalState.MarkerDistance = 16 -- Distance for displaying marker
GlobalState.TextUIDistance = 4 -- Distance for displaying ox_lib Text UI
GlobalState.TextUIicon = "car" -- Icon for ox_lib Text UI (font awesome icons - https://fontawesome.com/icons)

Config.OwnerCategoryEveryone = false -- If everyone can see owner category (access button, money in business) / false - only business owner can see owner category

GlobalState.Translation = {
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
