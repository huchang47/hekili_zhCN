-- Constants.lua
-- June 2014

local addon, ns = ...
local Hekili = _G[ addon ]


-- Class Localization
ns.getLocalClass = function ( class )
    if not ns.player.sex then ns.player.sex = UnitSex( "player" ) end
    return ns.player.sex == 1 and LOCALIZED_CLASS_NAMES_MALE[ class ] or LOCALIZED_CLASS_NAMES_FEMALE[ class ]
end


local InverseDirection = {
    LEFT = "RIGHT",
    RIGHT = "LEFT",
    TOP = "BOTTOM",
    BOTTOM = "TOP"
}

ns.getInverseDirection = function ( dir )

    return InverseDirection[ dir ] or dir

end


local ClassIDs = {}

for i = 1, GetNumClasses() do
    local _, classTag = GetClassInfo( i )
    if classTag then ClassIDs[ classTag ] = i end
end

ns.getClassID = function( class )
    return ClassIDs[ class ] or -1
end


local ResourceInfo = {
    -- health       = Enum.PowerType.HealthCost,
    none            = Enum.PowerType.None,
    mana            = Enum.PowerType.Mana,
    rage            = Enum.PowerType.Rage,
    focus           = Enum.PowerType.Focus,
    energy          = Enum.PowerType.Energy,
    combo_points    = Enum.PowerType.ComboPoints,
    runes           = Enum.PowerType.Runes,
    runic_power     = Enum.PowerType.RunicPower,
    soul_shards     = Enum.PowerType.SoulShards,
    astral_power    = Enum.PowerType.LunarPower,
    holy_power      = Enum.PowerType.HolyPower,
    alternate       = Enum.PowerType.Alternate,
    maelstrom       = Enum.PowerType.Maelstrom,
    chi             = Enum.PowerType.Chi,
    insanity        = Enum.PowerType.Insanity,
    obsolete        = Enum.PowerType.Obsolete,
    obsolete2       = Enum.PowerType.Obsolete2,
    arcane_charges  = Enum.PowerType.ArcaneCharges,
    fury            = Enum.PowerType.Fury,
    pain            = Enum.PowerType.Pain,
    essence         = Enum.PowerType.Essence
}

local ResourceByID = {}

for k, powerType in pairs( ResourceInfo ) do
    ResourceByID[ powerType ] = k
end


function ns.GetResourceInfo()
    return ResourceInfo
end


function ns.GetResourceID( key )
    return ResourceInfo[ key ]
end


function ns.GetResourceKey( id )
    return ResourceByID[ id ]
end


local passive_regen = {
    mana = 1,
    focus = 1,
    energy = 1,
    essence = 1
}

function ns.ResourceRegenerates( key )
    -- Does this resource have a passive gain from waiting?
    if passive_regen[ key ] then return true end
    return false
end


local Specializations = {
    death_knight_blood = 250,
    death_knight_frost = 251,
    death_knight_unholy = 252,

    druid_balance = 102,
    druid_feral = 103,
    druid_guardian = 104,
    druid_restoration = 105,

    hunter_beast_mastery = 253,
    hunter_marksmanship = 254,
    hunter_survival = 255,

    mage_arcane = 62,
    mage_fire = 63,
    mage_frost = 64,

    monk_brewmaster = 268,
    monk_windwalker = 269,
    monk_mistweaver = 270,

    paladin_holy = 65,
    paladin_protection = 66,
    paladin_retribution = 70,

    priest_discipline = 256,
    priest_holy = 257,
    priest_shadow = 258,

    rogue_assassination = 259,
    rogue_outlaw = 260,
    rogue_subtlety = 261,

    shaman_elemental = 262,
    shaman_enhancement = 263,
    shaman_restoration = 264,

    warlock_affliction = 265,
    warlock_demonology = 266,
    warlock_destruction = 267,

    warrior_arms = 71,
    warrior_fury = 72,
    warrior_protection = 73,

    demonhunter_havoc = 577,
    demonhunter_vengeance = 581,

    evoker_devastation = 1467,
    evoker_preservation = 1468,
}


local SpecializationKeys = {
    [250] = "blood",
    [251] = "frost",
    [252] = "unholy",

    [102] = "balance",
    [103] = "feral",
    [104] = "guardian",
    [105] = "restoration",

    [253] = "beast_mastery",
    [254] = "marksmanship",
    [255] = "survival",

    [62] = "arcane",
    [63] = "fire",
    [64] = "frost",

    [268] = "brewmaster",
    [269] = "windwalker",
    [270] = "mistweaver",

    [65] = "holy",
    [66] = "protection",
    [70] = "retribution",

    [256] = "discipline",
    [257] = "holy",
    [258] = "shadow",

    [259] = "assassination",
    [260] = "outlaw",
    [261] = "subtlety",

    [262] = "elemental",
    [263] = "enhancement",
    [264] = "restoration",

    [265] = "affliction",
    [266] = "demonology",
    [267] = "destruction",

    [71] = "arms",
    [72] = "fury",
    [73] = "protection",

    [577] = "havoc",
    [581] = "vengeance",

    [1467] = "devastation",
    [1468] = "preservation",
    [1473] = "augmentation"
}

ns.getSpecializationKey = function ( id )
    return SpecializationKeys[ id ] or "none"
end


ns.getSpecializationID = function ( index )
    return GetSpecializationInfo( index or GetSpecialization() or 0 )
end


ns.PvpDummies = {
    [114840] = true,  -- Orgrimmar
    [114832] = true,  -- Stormwind
    [189082] = true,  -- Nowhere
    [197833] = true,  -- Valdrakken
    [197834] = true,  -- Healing
    [219250] = true,  -- Dornogal
    [219251] = true   -- Dornogal Healing
}

ns.TargetDummies = {
    [   4952 ] = "Theramore Combat Dummy",
    [   5652 ] = "Undercity Combat Dummy",
    [  25225 ] = "Practice Dummy",
    [  25297 ] = "Drill Dummy",
    [  31144 ] = "Training Dummy",
    [  31146 ] = "Raider's Training Dummy",
    [  32541 ] = "Initiate's Training Dummy",
    [  32543 ] = "Veteran's Training Dummy",
    [  32546 ] = "Ebon Knight's Training Dummy",
    [  32542 ] = "Disciple's Training Dummy",
    [  32545 ] = "Training Dummy",
    [  32666 ] = "Training Dummy",
    [  32667 ] = "Training Dummy",
    [  44171 ] = "Training Dummy",
    [  44548 ] = "Training Dummy",
    [  44389 ] = "Training Dummy",
    [  44614 ] = "Training Dummy",
    [  44703 ] = "Training Dummy",
    [  44794 ] = "Training Dummy",
    [  44820 ] = "Training Dummy",
    [  44848 ] = "Training Dummy",
    [  44937 ] = "Training Dummy",
    [  46647 ] = "Training Dummy",
    [  48304 ] = "Training Dummy",
    [  60197 ] = "Training Dummy",
    [  64446 ] = "Training Dummy",
    [  67127 ] = "Training Dummy",
    [  70245 ] = "Training Dummy",
    [  79414 ] = "Training Dummy",
    [  87317 ] = "Training Dummy",
    [  87318 ] = "Dungeoneer's Training Dummy",
    [  87320 ] = "Raider's Training Dummy",
    [  87322 ] = "Dungeoneer's Training Dummy",
    [  87329 ] = "Raider's Training Dummy",
    [  87760 ] = "Training Dummy",
    [  87761 ] = "Dungeoneer's Training Dummy",
    [  87762 ] = "Raider's Training Dummy",
    [  88288 ] = "Dungeoneer's Training Dummy",
    [  88314 ] = "Dungeoneer's Training Dummy",
    [  88836 ] = "Dungeoneer's Training Dummy",
    [  88837 ] = "Raider's Training Dummy",
    [  88906 ] = "Combat Dummy",
    [  89078 ] = "Training Dummy",
    [  92164 ] = "Training Dummy",
    [  92165 ] = "Dungeoneer's Training Dummy",
    [  92166 ] = "Raider's Training Dummy",
    [  92168 ] = "Dungeoneer's Training Dummy",
    [  92169 ] = "Raider's Training Dummy",
    [  93828 ] = "Training Dummy",
    [  97668 ] = "Boxer's Training Dummy",
    [  98581 ] = "Prepfoot Training Dummy",
    [ 107104 ] = "Target Dummy",
    [ 108420 ] = "Training Dummy",
    [ 109066 ] = "Dungeon Damage Dummy",
    [ 109096 ] = "Normal Tanking Dummy",
    [ 111824 ] = "Training Dummy",
    [ 113858 ] = "Training Dummy",
    [ 113859 ] = "Dungeoneer's Training Dummy",
    [ 113860 ] = "Raider's Training Dummy",
    [ 113862 ] = "Training Dummy",
    [ 113863 ] = "Dungeoneer's Training Dummy",
    [ 113864 ] = "Raider's Training Dummy",
    [ 113871 ] = "Bombardier's Training Dummy",
    [ 126712 ] = "Training Dummy",
    [ 126781 ] = "Training Dummy",
    [ 127019 ] = "Training Dummy",
    [ 131983 ] = "Raider's Training Dummy",
    [ 131989 ] = "Training Dummy",
    [ 131990 ] = "Raider's Training Dummy",
    [ 131992 ] = "Dungeoneer's Training Dummy",
    [ 132976 ] = "Training Dummy",
    [ 134324 ] = "Training Dummy",
    [ 138048 ] = "Training Dummy",
    [ 143119 ] = "Gnoll Target Dummy",
    [ 143509 ] = "Training Dummy",
    [ 144073 ] = "Dungeoneer's Training Dummy",
    [ 144077 ] = "Training Dummy",
    [ 144081 ] = "Training Dummy",
    [ 144085 ] = "Training Dummy",
    [ 144086 ] = "Raider's Training Dummy",
    [ 153285 ] = "Training Dummy",
    [ 153292 ] = "Training Dummy",
    [ 172452 ] = "Raider's Tanking Dummy",
    [ 173942 ] = "Training Dummy",
    [ 174565 ] = "Raider's Tanking Dummy",
    [ 174566 ] = "Dungeoneer's Tanking Dummy",
    [ 174567 ] = "Raider's Tanking Dummy",
    [ 174568 ] = "Dungeoneer's Tanking Dummy",
    [ 175449 ] = "Dungeoneer's Training Dummy",
    [ 175450 ] = "Raider's Training Dummy",
    [ 175451 ] = "Dungeoneer's Training Dummy",
    [ 194643 ] = "Dungeoneer's Training Dummy",
    [ 194644 ] = "Dungeoneer's Training Dummy",
    [ 194648 ] = "Training Dummy",
    [ 194649 ] = "Normal Tank Dummy",
    [ 193394 ] = "Tuskarr Training Dummy",
    [ 193563 ] = "Training Dummy",
    [ 198594 ] = "Cleave Training Dummy",
    [ 199057 ] = "Black Dragon's Challenge Dummy",
    [ 216458 ] = "Sparring Dummy",
    [ 222275 ] = "Training Dummy",
    [ 225976 ] = "Normal Tank Dummy",
    [ 225977 ] = "Dungeoneer's Training Dummy",
    [ 225982 ] = "Cleave Training Dummy",
    [ 225983 ] = "Dungeoneer's Training Dummy",
    [ 225984 ] = "Training Dummy",
    [ 235830 ] = "Training Dummy",
}


ns.FrameStratas = {
    "BACKGROUND",
    "LOW",
    "MEDIUM",
    "HIGH",
    "DIALOG",
    "FULLSCREEN",
    "FULLSCREEN_DIALOG",
    "TOOLTIP",

    BACKGROUND = 1,
    LOW = 2,
    MEDIUM = 3,
    HIGH = 4,
    DIALOG = 5,
    FULLSCREEN = 6,
    FULLSCREEN_DIALOG = 7,
    TOOLTIP = 8
}