-- EvokerAugmentation.lua
-- August 2025
-- Patch 11.2

--- TODO
-- Hover while moving recommendation spec option

if UnitClassBase( "player" ) ~= "EVOKER" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State
local spec = Hekili:NewSpecialization( 1473 )

---- Local function declarations for increased performance
-- Strings
local strformat = string.format
-- Tables
local insert, remove, sort, wipe = table.insert, table.remove, table.sort, table.wipe
-- Math
local abs, ceil, floor, max, sqrt = math.abs, math.ceil, math.floor, math.max, math.sqrt

-- Common WoW APIs, comment out unneeded per-spec
-- local GetSpellCastCount = C_Spell.GetSpellCastCount
-- local GetSpellInfo = C_Spell.GetSpellInfo
-- local GetSpellInfo = ns.GetUnpackedSpellInfo
-- local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
-- local FindUnitBuffByID, FindUnitDebuffByID = ns.FindUnitBuffByID, ns.FindUnitDebuffByID
-- local IsSpellOverlayed = C_SpellActivationOverlay.IsSpellOverlayed
-- local IsSpellKnownOrOverridesKnown = C_SpellBook.IsSpellInSpellBook
-- local IsActiveSpell = ns.IsActiveSpell

-- Specialization-specific local functions (if any)

-- Resources
spec:RegisterResource( Enum.PowerType.Mana )
spec:RegisterResource( Enum.PowerType.Essence )

-- Talents
spec:RegisterTalents( {

    -- Evoker
    aerial_mastery                 = {  93352,  365933, 1 }, -- Hover gains $s1 additional charge
    ancient_flame                  = {  93271,  369990, 1 }, -- Casting Emerald Blossom or Verdant Embrace reduces the cast time of your next Living Flame by $s1%
    attuned_to_the_dream           = {  93292,  376930, 2 }, -- Your healing done and healing received are increased by $s1%
    blast_furnace                  = {  93309,  375510, 1 }, -- Fire Breath's damage over time lasts $s1 sec longer
    bountiful_bloom                = {  93291,  370886, 1 }, -- Emerald Blossom heals $s1 additional allies
    cauterizing_flame              = {  93294,  374251, 1 }, -- Cauterize an ally's wounds, removing all Bleed, Poison, Curse, and Disease effects. Heals for $s1 upon removing any effect
    clobbering_sweep               = { 103844,  375443, 1 }, -- Tail Swipe's cooldown is reduced by $s1 min
    draconic_legacy                = {  93300,  376166, 1 }, -- Your Stamina is increased by $s1%
    enkindled                      = {  93295,  375554, 2 }, -- Living Flame deals $s1% more damage and healing
    expunge                        = {  93306,  365585, 1 }, -- Expunge toxins affecting an ally, removing all Poison effects
    extended_flight                = {  93349,  375517, 2 }, -- Hover lasts $s1 sec longer
    exuberance                     = {  93299,  375542, 1 }, -- While above $s1% health, your movement speed is increased by $s2%
    fire_within                    = {  93345,  375577, 1 }, -- Renewing Blaze's cooldown is reduced by $s1 sec
    foci_of_life                   = {  93345,  375574, 1 }, -- Renewing Blaze restores you more quickly, causing damage you take to be healed back over $s1 sec
    forger_of_mountains            = {  93270,  375528, 1 }, -- Landslide's cooldown is reduced by $s1 sec, and it can withstand $s2% more damage before breaking
    heavy_wingbeats                = { 103843,  368838, 1 }, -- Wing Buffet's cooldown is reduced by $s1 min
    inherent_resistance            = {  93355,  375544, 2 }, -- Magic damage taken reduced by $s1%
    innate_magic                   = {  93302,  375520, 2 }, -- Essence regenerates $s1% faster
    instinctive_arcana             = {  93310,  376164, 2 }, -- Your Magic damage done is increased by $s1%
    landslide                      = {  93305,  358385, 1 }, -- Conjure a path of shifting stone towards the target location, rooting enemies for $s1 sec. Damage may cancel the effect
    leaping_flames                 = {  93343,  369939, 1 }, -- Fire Breath causes your next Living Flame to strike $s1 additional target per empower level
    lush_growth                    = {  93347,  375561, 2 }, -- Green spells restore $s1% more health
    natural_convergence            = {  93312,  369913, 1 }, -- Disintegrate channels $s1% faster and Eruption's cast time is reduced by $s2%
    obsidian_bulwark               = {  93289,  375406, 1 }, -- Obsidian Scales has an additional charge
    obsidian_scales                = {  93304,  363916, 1 }, -- Reinforce your scales, reducing damage taken by $s1%. Lasts $s2 sec
    oppressing_roar                = {  93298,  372048, 1 }, -- Let out a bone-shaking roar at enemies in a cone in front of you, increasing the duration of crowd controls that affect them by $s1% in the next $s2 sec
    overawe                        = {  93297,  374346, 1 }, -- Oppressing Roar removes $s1 Enrage effect from each enemy, and its cooldown is reduced by $s2 sec
    panacea                        = {  93348,  387761, 1 }, -- Emerald Blossom and Verdant Embrace instantly heal you for $s1 when cast
    potent_mana                    = {  93715,  418101, 1 }, -- Source of Magic increases the target's healing and damage done by $s1%
    protracted_talons              = {  93307,  369909, 1 }, -- Azure Strike damages $s1 additional enemy
    quell                          = {  93311,  351338, 1 }, -- Interrupt an enemy's spellcasting and prevent any spell from that school of magic from being cast for $s1 sec
    recall                         = {  93301,  371806, 1 }, -- You may reactivate Breath of Eons within $s1 sec after landing to travel back in time to your takeoff location
    regenerative_magic             = {  93353,  387787, 1 }, -- Your Leech is increased by $s1%
    renewing_blaze                 = {  93354,  374348, 1 }, -- The flames of life surround you for $s1 sec. While this effect is active, $s2% of damage you take is healed back over $s3 sec
    rescue                         = {  93288,  370665, 1 }, -- Swoop to an ally and fly with them to the target location. Clears movement impairing effects from you and your ally
    scarlet_adaptation             = {  93340,  372469, 1 }, -- Store $s1% of your effective healing, up to $s2. Your next damaging Living Flame consumes all stored healing to increase its damage dealt
    sleep_walk                     = {  93293,  360806, 1 }, -- Disorient an enemy for $s1 sec, causing them to sleep walk towards you. Damage has a chance to awaken them
    source_of_magic                = {  93344,  369459, 1 }, -- Redirect your excess magic to a friendly healer for $s1 |$s2hour:hrs;. When you cast an empowered spell, you restore $s3% of their maximum mana per empower level. Limit $s4
    spatial_paradox                = {  93351,  406732, 1 }, -- Evoke a paradox for you and a friendly healer, allowing casting while moving and increasing the range of most spells by $s1% for $s2 sec. Affects the nearest healer within $s3 yds, if you do not have a healer targeted
    tailwind                       = {  93290,  375556, 1 }, -- Hover increases your movement speed by $s1% for the first $s2 sec
    terror_of_the_skies            = {  93342,  371032, 1 }, -- Breath of Eons stuns enemies for $s1 sec
    time_spiral                    = {  93351,  374968, 1 }, -- Bend time, allowing you and your allies within $s1 yds to cast their major movement ability once in the next $s2 sec, even if it is on cooldown
    tip_the_scales                 = {  93350,  370553, 1 }, -- Compress time to make your next empowered spell cast instantly at its maximum empower level
    twin_guardian                  = {  93287,  370888, 1 }, -- Rescue protects you and your ally from harm, absorbing damage equal to $s1% of your maximum health for $s2 sec
    unravel                        = {  93308,  368432, 1 }, -- Sunder an enemy's protective magic, dealing $s$s2 Spellfrost damage to absorb shields
    verdant_embrace                = {  93341,  360995, 1 }, -- Fly to an ally and heal them for $s1, or heal yourself for the same amount
    walloping_blow                 = {  93286,  387341, 1 }, -- Wing Buffet and Tail Swipe knock enemies further and daze them, reducing movement speed by $s1% for $s2 sec
    zephyr                         = {  93346,  374227, 1 }, -- Conjure an updraft to lift you and your $s1 nearest allies within $s2 yds into the air, reducing damage taken from area-of-effect attacks by $s3% and increasing movement speed by $s4% for $s5 sec

    -- Augmentation
    accretion                      = {  93229,  407876, 1 }, -- Eruption reduces the remaining cooldown of Upheaval by $s1 sec
    anachronism                    = {  93223,  407869, 1 }, -- Prescience has a $s1% chance to grant Essence Burst
    arcane_reach                   = {  93225,  454983, 1 }, -- The range of your helpful magics is increased by $s1 yards
    aspects_favor                  = {  93217,  407243, 2 }, -- Obsidian Scales activates Black Attunement, and amplifies it to increase maximum health by $s1% for $s2 sec. Hover activates Bronze Attunement, and amplifies it to increase movement speed by $s3% for $s4 sec
    bestow_weyrnstone              = {  93195,  408233, 1 }, -- Conjure a pair of Weyrnstones, one for your target ally and one for yourself. Only one ally may bear your Weyrnstone at a time. A Weyrnstone can be activated by the bearer to transport them to the other Weyrnstone's location, if they are within $s1 yds
    blistering_scales              = {  93209,  360827, 1 }, -- Protect an ally with $s3 explosive dragonscales, increasing their Armor by $s4% of your own. Melee attacks against the target cause $s5 scale to explode, dealing $s$s6 Volcanic damage to enemies near them$s$s7 This damage can only occur every few sec. Blistering Scales can only be placed on one target at a time. Casts on your enemy's target if they have one
    breath_of_eons                 = {  93234,  403631, 1 }, -- Fly to the targeted location, exposing a Temporal Wound on enemies in your path for $s1 sec and granting Ebon Might for $s2 sec. Removes roots and grants immunity to movement impairing and loss of control effects while flying.  Temporal Wound $s5% of damage dealt by allies affected by Ebon Might is copied as additional Arcane damage to enemies after $s6 sec
    chrono_ward                    = {  93235,  409676, 1 }, -- When allies deal damage with Temporal Wounds, they gain a shield for $s1% of the damage dealt. Absorption cannot exceed $s2% of your maximum health
    defy_fate                      = {  93222,  404195, 1 }, -- Fatal attacks are diverted into a nearby timeline, preventing the damage, and your death, in this one. The release of temporal energy restores $s1 health to you, and $s2 to $s3 nearby allies, over $s4 sec. Healing starts high and declines over the duration. May only occur once every $s5 min
    draconic_attunements           = {  93218,  403208, 1 }, -- Learn to attune yourself to the essence of the Black or Bronze Dragonflights: Black Attunement: You and your $s3 nearest allies have $s4% increased maximum health. Bronze Attunement:You and your $s7 nearest allies have $s8% increased movement speed
    dream_of_spring                = {  93359,  414969, 1 }, -- Emerald Blossom no longer has a cooldown, deals $s1% increased healing, and increases the duration of your active Ebon Might effects by $s2 sec, but costs $s3 Essence
    ebon_might                     = {  93198,  395152, 1 }, -- Increase your $s1 nearest allies' primary stat by $s2% of your own, and cause you to deal $s3% more damage, for $s4 sec. May only affect $s5 allies at once, and does not affect tanks and healers. Eruption, Breath of Eons, and your empower spells extend the duration of these effects
    echoing_strike                 = {  93221,  410784, 1 }, -- Azure Strike deals $s1% increased damage and has a $s2% chance per target hit to echo, casting again
    eruption                       = {  93200,  395160, 1 }, -- Cause a violent eruption beneath an enemy's feet, dealing $s$s2 Volcanic damage split between them and nearby enemies. Increases the duration of your active Ebon Might effects by $s3 sec
    essence_attunement             = {  93219,  375722, 1 }, -- Essence Burst stacks $s1 times
    essence_burst                  = {  93220,  396187, 1 }, -- Your Living Flame has a $s1% chance, and your Azure Strike has a $s2% chance, to make your next Eruption cost no Essence. Stacks $s3 times
    fate_mirror                    = {  93367,  412774, 1 }, -- Prescience grants the ally a chance for their spells and abilities to echo their damage or healing, dealing $s1% of the amount again
    font_of_magic                  = {  93231,  408083, 1 }, -- Your empower spells' maximum level is increased by $s1, and they reach maximum empower level $s2% faster
    hoarded_power                  = {  93212,  375796, 1 }, -- Essence Burst has a $s1% chance to not be consumed
    ignition_rush                  = {  93230,  408775, 1 }, -- Essence Burst reduces the cast time of Eruption by $s1%
    imminent_destruction           = { 102248,  459537, 1 }, -- Breath of Eons reduces the Essence cost of Eruption by $s1 and increases its damage by $s2% for $s3 sec after you land
    imposing_presence              = {  93199,  371016, 1 }, -- Quell's cooldown is reduced by $s1 sec
    infernos_blessing              = {  93197,  410261, 1 }, -- Fire Breath grants the inferno's blessing for $s2 sec to you and your allies affected by Ebon Might, giving their damaging attacks and spells a high chance to deal an additional $s$s3 Fire damage
    inner_radiance                 = {  93199,  386405, 1 }, -- Your Living Flame and Emerald Blossom are $s1% more effective on yourself
    interwoven_threads             = {  93369,  412713, 1 }, -- The cooldowns of your spells are reduced by $s1%
    molten_blood                   = {  93211,  410643, 1 }, -- When cast, Blistering Scales grants the target a shield that absorbs up to $s1 damage for $s2 sec based on their missing health. Lower health targets gain a larger shield
    molten_embers                  = { 102249,  459725, 1 }, -- Fire Breath causes enemies to take up to $s1% increased damage from your Black spells, increased based on its empower level
    momentum_shift                 = {  93207,  408004, 1 }, -- Consuming Essence Burst grants you $s1% Intellect for $s2 sec. Stacks up to $s3 times
    motes_of_possibility           = {  93227,  409267, 1 }, -- Eruption has a $s1% chance to form a mote of diverted essence near you. Allies who comes in contact with the mote gain a random buff from your arsenal
    overlord                       = {  93213,  410260, 1 }, -- Breath of Eons casts an Eruption at the first $s1 enemies struck. These Eruptions have a $s2% chance to create a Mote of Possibility
    perilous_fate                  = {  93235,  410253, 1 }, -- Breath of Eons reduces enemies' movement speed by $s1%, and reduces their attack speed by $s2%, for $s3 sec
    plot_the_future                = {  93226,  407866, 1 }, -- Breath of Eons grants you Fury of the Aspects for $s1 sec after you land, without causing Exhaustion
    power_nexus                    = {  93201,  369908, 1 }, -- Increases your maximum Essence to $s1
    prescience                     = {  93358,  409311, 1 }, -- Grant an ally the gift of foresight, increasing their critical strike chance by $s1% and occasionally copying their damage and healing spells at $s2% power for $s3 sec. Affects the nearest ally within $s4 yds, preferring damage dealers, if you do not have an ally targeted
    prolong_life                   = {  93359,  410687, 1 }, -- Your effects that extend Ebon Might also extend Symbiotic Bloom
    pupil_of_alexstrasza           = {  93221,  407814, 1 }, -- When cast at an enemy, Living Flame strikes $s1 additional enemy for $s2% damage
    reactive_hide                  = {  93210,  409329, 1 }, -- Each time Blistering Scales explodes it deals $s1% more damage for $s2 sec, stacking $s3 times
    regenerative_chitin            = {  93211,  406907, 1 }, -- Blistering Scales has $s1 more scales, and casting Eruption restores $s2 scale
    ricocheting_pyroclast          = {  93208,  406659, 1 }, -- Eruption deals $s1% more damage per enemy struck, up to $s2%
    rockfall                       = {  93368, 1219236, 1 }, -- Upheaval reaches maximum empower level $s1% faster and has a $s2% chance to grant Essence Burst
    rumbling_earth                 = {  93205,  459120, 1 }, -- Upheaval causes an aftershock at its location, dealing $s1% of its damage $s2 additional times
    stretch_time                   = {  93382,  410352, 1 }, -- While flying during Breath of Eons, $s1% of damage you would take is instead dealt over $s2 sec
    symbiotic_bloom                = {  93215,  410685, 2 }, -- Emerald Blossom increases targets' healing received by $s1% for $s2 sec
    tectonic_locus                 = {  93202,  408002, 1 }, -- Upheaval deals $s1% increased damage to the primary target, and launches them higher
    time_skip                      = {  93232,  404977, 1 }, -- Surge forward in time, causing your cooldowns to recover $s1% faster for $s2 sec
    timelessness                   = {  93360,  412710, 1 }, -- Enchant an ally to appear out of sync with the normal flow of time, reducing threat they generate by $s1% for $s2 min. Less effective on tank-specialized allies. May only be placed on one target at a time
    tomorrow_today                 = {  93369,  412723, 1 }, -- Time Skip channels for $s1 sec longer
    unyielding_domain              = {  93202,  412733, 1 }, -- Upheaval cannot be interrupted, and has an additional $s1% chance to critically strike
    upheaval                       = {  93203,  396286, 1 }, -- Gather earthen power beneath your enemy's feet and send them hurtling upwards, dealing $s$s2 Volcanic damage to the target and nearby enemies. Increases the duration of your active Ebon Might effects by $s3 sec. Empowering expands the area of effect. I: $s4 yd radius. II: $s5 yd radius. III: $s6 yd radius
    volcanism                      = {  93206,  406904, 1 }, -- Eruption's Essence cost is reduced by $s1

    -- Chronowarden
    afterimage                     = {  94929,  431875, 1 }, -- Empower spells send up to $s1 Chrono Flames to your targets
    chrono_flame                   = {  94954,  431442, 1 }, -- Living Flame is enhanced with Bronze magic, repeating $s1% of the damage or healing you dealt to the target in the last $s2 sec as Arcane, up to $s3
    doubletime                     = {  94932,  431874, 1 }, -- Ebon Might and Prescience gain a chance equal to your critical strike chance to grant $s1% additional stats
    golden_opportunity             = {  94942,  432004, 1 }, -- Prescience has a $s1% chance to cause your next Prescience to last $s2% longer
    instability_matrix             = {  94930,  431484, 1 }, -- Each time you cast an empower spell, unstable time magic reduces its cooldown by up to $s1 sec
    master_of_destiny              = {  94930,  431840, 1 }, -- Casting Essence spells extends all your active Threads of Fate by $s1 sec
    motes_of_acceleration          = {  94935,  432008, 1 }, -- Warp leaves a trail of Motes of Acceleration. Allies who come in contact with a mote gain $s1% increased movement speed for $s2 sec
    primacy                        = {  94951,  431657, 1 }, -- For each damage over time effect from Upheaval, gain $s1% haste, up to $s2%
    reverberations                 = {  94925,  431615, 1 }, -- Upheaval deals $s1% additional damage over $s2 sec
    temporal_burst                 = {  94955,  431695, 1 }, -- Tip the Scales overloads you with temporal energy, increasing your haste, movement speed, and cooldown recovery rate by $s1%, decreasing over $s2 sec
    temporality                    = {  94935,  431873, 1 }, -- Warp reduces damage taken by $s1%, starting high and reducing over $s2 sec
    threads_of_fate                = {  94947,  431715, 1 }, -- Casting an empower spell during Temporal Burst causes a nearby ally to gain a Thread of Fate for $s1 sec, granting them a chance to echo their damage or healing spells, dealing $s2% of the amount again
    time_convergence               = {  94932,  431984, 1 }, -- Non-defensive abilities with a $s1 second or longer cooldown grant $s2% Intellect for $s3 sec. Essence spells extend the duration by $s4 sec
    warp                           = {  94948,  429483, 1 }, -- Hover now causes you to briefly warp out of existence and appear at your destination. Hover's cooldown is also reduced by $s1 sec. Hover continues to allow Evoker spells to be cast while moving

    -- Scalecommander
    bombardments                   = {  94936,  434300, 1 }, -- Mass Eruption marks your primary target for destruction for the next $s2 sec. You and your allies have a chance to trigger a Bombardment when attacking marked targets, dealing $s$s3 Volcanic damage split amongst all nearby enemies
    diverted_power                 = {  94928,  441219, 1 }, -- Bombardments have a chance to generate Essence Burst
    extended_battle                = {  94928,  441212, 1 }, -- Essence abilities extend Bombardments by $s1 sec
    hardened_scales                = {  94933,  441180, 1 }, -- Obsidian Scales reduces damage taken by an additional $s1%
    maneuverability                = {  94941,  433871, 1 }, -- Breath of Eons can now be steered in your desired direction. In addition, Breath of Eons burns targets for $s$s2 Volcanic damage over $s3 sec
    mass_eruption                  = {  98931,  438587, 1 }, -- Empower spells cause your next Eruption to strike up to $s1 targets. When striking less than $s2 targets, Eruption damage is increased by $s3% for each missing target
    melt_armor                     = {  94921,  441176, 1 }, -- Breath of Eons causes enemies to take $s1% increased damage from Bombardments and Essence abilities for $s2 sec
    menacing_presence              = {  94933,  441181, 1 }, -- Knocking enemies up or backwards reduces their damage done to you by $s1% for $s2 sec
    might_of_the_black_dragonflight = {  94952,  441705, 1 }, -- Black spells deal $s1% increased damage
    nimble_flyer                   = {  94943,  441253, 1 }, -- While Hovering, damage taken from area of effect attacks is reduced by $s1%
    onslaught                      = {  94944,  441245, 1 }, -- Entering combat grants a charge of Burnout, causing your next Living Flame to cast instantly
    slipstream                     = {  94943,  441257, 1 }, -- Deep Breath resets the cooldown of Hover
    unrelenting_siege              = {  94934,  441246, 1 }, -- For each second you are in combat, Azure Strike, Living Flame, and Eruption deal $s1% increased damage, up to $s2%
    wingleader                     = {  94953,  441206, 1 }, -- Bombardments reduce the cooldown of Breath of Eons by $s1 sec for each target struck, up to $s2 sec
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    born_in_flame                  = 5612, -- (414937)
    chrono_loop                    = 5564, -- (383005) Trap the enemy in a time loop for $s1 sec. Afterwards, they are returned to their previous location and health. Cannot reduce an enemy's health below $s2%
    divide_and_conquer             = 5557, -- (384689)
    dreamwalkers_embrace           = 5615, -- (415651)
    nullifying_shroud              = 5558, -- (1241352)
    obsidian_mettle                = 5563, -- (378444)
    scouring_flame                 = 5561, -- (378438)
    seismic_slam                   = 5454, -- (408543)
    swoop_up                       = 5562, -- (370388) Grab an enemy and fly with them to the target location
    time_stop                      = 5619, -- (378441) Freeze an ally's timestream for $s1 sec. While frozen in time they are invulnerable, cannot act, and auras do not progress. You may reactivate Time Stop to end this effect early
    unburdened_flight              = 5560, -- (378437) Hover makes you immune to movement speed reduction effects
} )

-- Auras
spec:RegisterAuras( {
    -- The cast time of your next Living Flame is reduced by $w1%.
    ancient_flame = {
        id = 375583,
        duration = 3600,
        max_stack = 1,
    },
    -- Black Attunement grants $w1% additional health.
    black_aspects_favor = {
        id = 407254,
        duration = function() return 12.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
    },
    -- Maximum health increased by $w1%.
    black_attunement = {
        id = 403264,
        duration = 3600,
        tick_time = 2.0,
        max_stack = 1,
    },
    -- $?$w1>0[Armor increased by $w1.][Armor increased by $w2%.] Melee attacks against you have a chance to cause an explosion of Volcanic damage.
    blistering_scales = {
        id = 360827,
        duration = function() return 600.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = function() return 15 + talent.regenerative_chitin.rank * 5 end,
        dot = "buff",
        friendly = true,
        no_ticks = true
    },
    -- Damage taken has a chance to summon air support from the Dracthyr.
    bombardments = {
        id = 434473,
        duration = 6.0,
        pandemic = true,
        max_stack = 1,
    },
    -- Exposing Temporal Wounds on enemies in your path. Immune to crowd control.
    breath_of_eons = {
        id = 403631,
        duration = 6.0,
        max_stack = 1,
    },
    -- Bronze Attunement's grants $w1% additional movement speed.
    bronze_aspects_favor = {
        id = 407244,
        duration = function() return 4.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
    },
    bronze_attunement = {
        id = 403265,
        duration = 3600,
        tick_time = 2.0,
        max_stack = 1,
    },

    -- Next Living Flame's cast time is reduced by $w1%.
    burnout = {
        id = 375802,
        duration = 15.0,
        max_stack = 2,
    },
    -- Trapped in a time loop.
    chrono_loop = {
        id = 383005,
        duration = 5.0,
        max_stack = 1,
    },
    -- Absorbing $w1 damage.
    chrono_ward = {
        id = 409678,
        duration = function() return 20.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
        dot = "buff",
        friendly = true,
        no_ticks = true
    },
    -- Suffering $w1 Volcanic damage every $t1 sec.
    deep_breath = {
        id = 353759,
        duration = 1.0,
        tick_time = 0.5,
        max_stack = 1,
    },
    -- Healing $w1 every $t1 sec.
    defy_fate = {
        id = 404381,
        duration = 9.0,
        max_stack = 1,
        dot = "buff",
        friendly = true
    },
    -- Suffering $w1 Spellfrost damage every $t1 sec.
    disintegrate = {
        id = 356995,
        duration = function() return 3.0 * ( talent.natural_convergence.enabled and 0.8 or 1 ) * haste end,
        tick_time = function() return ( talent.natural_convergence.enabled and 0.8 or 1 ) * haste end,
        max_stack = 1,
    },
    -- Burning for $s1 every $t1 sec.
    divide_and_conquer = {
        id = 403516,
        duration = 6.0,
        tick_time = 3.0,
        max_stack = 1,
    },
    -- Tethered with an ally, causing enemies who touch the tether to be damaged and slowed.
    dreamwalkers_embrace = {
        id = 415516,
        duration = 10.0,
        tick_time = 0.5,
        max_stack = 1,
        dot = "buff",
        friendly = true
    },
    -- Your Ebon Might is active on allies.; Your damage done is increased by $w1%.
    ebon_might_allies = {
        id = 426404,
        duration = function() return 10.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        tick_time = 1.0,
        pandemic = true,
        max_stack = 5, -- IDK, maybe?
        dot = "buff",
        friendly = true,
        no_ticks = true
    },
    -- Your Ebon Might is active on allies.; Your damage done is increased by $w1%.
    ebon_might_self = {
        id = 395296,
        duration = function() return 10.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        tick_time = 1.0,
        pandemic = true,
        max_stack = 1,
        dot = "buff",
        friendly = true,
        no_ticks = true
    },
    ebon_might = {
        alias = { "ebon_might_allies", "ebon_might_self" },
        aliasMode = "longest",
        aliasType = "buff",
        duration = function() return 10.0 * ( 1 + 1.25 * stat.mastery_value ) end
    },
    -- Your next Eruption $?s414969[or Emerald Blossom ][]costs no Essence.
    essence_burst = {
        id = 392268,
        duration = function() return 15.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = function() return 1 + talent.essence_attunement.rank end,
    },
    -- Movement speed increased by $w2%.$?e0[ Area damage taken reduced by $s1%.][]; Evoker spells may be cast while moving. Does not affect empowered spells.$?e9[; Immune to movement speed reduction effects.][]
    hover = {
        id = 358267,
        duration = function() return ( 6.0 + ( talent.extended_flight.enabled and 4 or 0 ) ) end,
        tick_time = 1.0,
        max_stack = 1,
    },
    -- Essence costs of Disintegrate and Pyre are reduced by $s1, and their damage increased by $s2%.
    imminent_destruction = {
        id = 411055,
        duration = 12.0,
        max_stack = 1,
    },
    -- Granted the inferno's blessing by $@auracaster, giving your damaging attacks and spells a high chance to deal additional Fire damage.
    infernos_blessing = {
        id = 410263,
        duration = function() return 8.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
        dot = "buff",
        friendly = true,
        no_ticks = true
    },
    -- Rooted.
    landslide = {
        id = 355689,
        duration = 15,
        max_stack = 1,
    },
    -- Absorbing $w1 damage.; Immune to interrupts and silence effects.
    lava_shield = {
        id = 405295,
        duration = function() return 15.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
        dot = "buff",
        friendly = true,
        no_ticks = true
    },
    -- Your next Living Flame will strike $w1 additional $?$w1=1[target][targets].
    leaping_flames = {
        id = 370901,
        duration = function() return 30.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
    },
    -- Healing for $w2 every $t2 sec.
    living_flame = {
        id = 361509,
        duration = 12.0,
        max_stack = 1,
        dot = "buff",
        friendly = true
    },
    mass_disintegrate_stacks = {
        id = 436336,
        duration = 15,
        max_stack = 8,
        copy = "mass_disintegrate_ticks"
    },
    mass_eruption_stacks = {
        id = 438588,
        duration = 15,
        max_stack = 10,
        copy = "mass_eruption"
    },
    melt_armor = {
        id = 441172,
        duration = 12,
        max_stack = 1
    },
    -- Absorbing $w1 damage.
    molten_blood = {
        id = 410651,
        duration = function() return 30.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
        dot = "buff",
        friendly = true,
        no_ticks = true
    },
    -- Intellect increased by $w1%.
    momentum_shift = {
        id = 408005,
        duration = function() return 6.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 2,
        dot = "buff",
        friendly = true,
        no_ticks = true
    },
    -- Your next Emerald Blossom will restore an additional $406054s1% of maximum health to you.
    nourishing_sands = {
        id = 406043,
        duration = function() return 20.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
    },
    -- Warded against full loss of control effects.
    nullifying_shroud = {
        id = 378464,
        duration = 30.0,
        max_stack = 3,
    },
    -- Damage taken reduced by $w1%.$?$w2=1[; Immune to interrupt and silence effects.][]
    obsidian_scales = {
        id = 363916,
        duration = function() return 12.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
    },
    -- The duration of incoming crowd control effects are increased by $s2%.
    oppressing_roar = {
        id = 372048,
        duration = 10.0,
        max_stack = 1,
    },
    -- Movement speed reduced by $w1%.; Attack speed reduced by $w2%.
    perilous_fate = {
        id = 439606,
        duration = function() return 10.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
    },
    -- Movement speed reduced by $w1%.
    permeating_chill = {
        id = 370898,
        duration = 3.0,
        max_stack = 1,
    },
    -- $?$W1>0[$@auracaster is increasing your critical strike chance by $w1%.][]$?e0&e1[; ][]$?e1[Your abilities have a chance to echo $412774s1% of their damage and healing.][]
    prescience = {
        id = 410089,
        duration = function() return 18.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
        dot = "buff",
        friendly = true,
        no_ticks = true
    },
    prescience_applied = {
        duration = function() return 18.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
    },
    primacy = {
        id = 431654,
        duration = 8,
        max_stack = 3
    },
    -- Blistering Scales deals $w1% increased damage.
    reactive_hide = {
        id = 410256,
        duration = function() return 12.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
    },
    recall = {
        id = 403760,
        duration = 3,
        max_stack = 1
    },
    -- Restoring $w1 health every $t1 sec.
    renewing_blaze = {
        id = 374349,
        duration = function() return ( 8.0 - ( talent.foci_of_life.enabled and 4 or 0 ) ) * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
    },
    -- About to be picked up!
    rescue = {
        id = 370665,
        duration = 1.0,
        max_stack = 1,
    },
    -- Watching for allies who use exceptionally powerful abilities.
    sense_power = {
        id = 361021,
        duration = 3600,
        max_stack = 1,
    },
    sense_power_active = {
        id = 361022,
        duration = 10,
        max_stack = 1,
        dot = "buff",
        friendly = true,
        no_ticks = true,
        shared = "target"
    },
    -- Versatility increased by ${$W1}.1%. Cast by $@auracaster.
    shifting_sands = {
        id = 413984,
        duration = function() return 10.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        tick_time = 1.0,
        max_stack = 1,
        dot = "buff",
        no_ticks = true,
        friendly = true
    },
    -- Asleep.
    sleep_walk = {
        id = 360806,
        duration = 20.0,
        max_stack = 1,
    },
    -- $@auracaster is restoring mana to you when they cast an empowered spell.$?$w2>0[; Healing and damage done increased by $w2%.][]
    source_of_magic = {
        id = 369459,
        duration = function() return 3600.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
        dot = "buff",
        no_ticks = true,
        friendly = true
    },
    -- Able to cast spells while moving and range increased by $s5%. Cast by $@auracaster.
    spatial_paradox = {
        id = 406789,
        duration = function() return 10.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        tick_time = 1.0,
        max_stack = 1,
        dot = "buff",
        no_ticks = true,
        friendly = true
    },
    -- $w1% of damage is being delayed and dealt to you over time.
    stretch_time = {
        id = 410355,
        duration = 10.0,
        max_stack = 1,
    },
    -- About to be grabbed!
    swoop_up = {
        id = 370388,
        duration = 1.0,
        max_stack = 1,
    },
    -- Healing received increased by $w1%.
    symbiotic_bloom = {
        id = 410686,
        duration = function() return 10.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
        dot = "buff",
        no_ticks = true,
        friendly = true
    },
    temporal_burst = {
        id = 431698,
        duration = 30,
        max_stack = 30
    },
    -- Accumulating damage from $@auracaster's allies who are affected by Ebon Might.
    temporal_wound = {
        id = 409560,
        duration = function() return 10.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        tick_time = 1.0,
        max_stack = 1,
    },
    -- Stunned.
    terror_of_the_skies = {
        id = 372245,
        duration = 3.0,
        max_stack = 1,
    },
    -- Surging forward in time, causing your cooldowns to recover $s1% faster.
    time_skip = {
        id = 404977,
        duration = function() return 2.0 + ( talent.tomorrow_today.enabled and 1 or 0 ) end,
        max_stack = 1,
    },
    -- May use Hover once, without incurring its cooldown.
    time_spiral = {
        id = 375234,
        duration = function() return 10.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
    },
    -- Frozen in time, incapacitated and invulnerable.
    time_stop = {
        id = 378441,
        duration = 5.0,
        max_stack = 1,
    },
    -- Threat generation reduced by $w1%. Cast by $@auracaster.
    timelessness = {
        id = 412710,
        duration = function() return 1800.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
        dot = "buff",
        no_ticks = true,
        friendly = true
    },
    -- Your next empowered spell casts instantly at its maximum empower level.
    tip_the_scales = {
        id = 370553,
        duration = 3600,
        max_stack = 1,
        onRemove = function()
            setCooldown( "tip_the_scales", action.tip_the_scales.cooldown )
        end,
    },
    -- Absorbing $w1 damage.
    twin_guardian = {
        id = 370889,
        duration = function() return 5.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
        dot = "buff",
        no_ticks = true,
        friendly = true
    },
    upheaval = {
        id = 431620,
        duration = 8,
        max_stack = 1
    },
    -- Damage taken from area-of-effect attacks reduced by $w1%.; Movement speed increased by $w2%.
    zephyr = {
        id = 374227,
        duration = function() return 8.0 * ( 1 + 1.25 * stat.mastery_value ) end,
        max_stack = 1,
        dot = "buff",
        no_ticks = true,
        friendly = true
    },
} )

spec:RegisterGear({
    -- The War Within
    tww3 = {
        items = { 237658, 237656, 237655, 237654, 237653 },
        auras = {
            -- Scalecommander
            draconic_inspiration = {
                id = 1237241,
                duration = 30,
                max_stack = 1
            },
        }
    },
    tww2 = {
        items = { 229283, 229281, 229279, 229280, 229278 }
    },
    -- Dragonflight
    tier31 = {
        items = { 207225, 207226, 207227, 207228, 207230, 217178, 217180, 217176, 217177, 217179 },
        auras = {
            t31_2pc_proc = {
                duration = 3600,
                max_stack = 1
            },
            t31_2pc_stacks = {
                duration = 3600,
                max_stack = 3
            },
            trembling_earth = {
                id = 424368,
                duration = 3600,
                max_stack = 5
            }
        }
    },
    tier30 = {
        items = { 202491, 202489, 202488, 202487, 202486 }
    },
    tier29 = {
        items = { 200381, 200383, 200378, 200380, 200382 }
    }
} )

-- Pets
spec:RegisterPets({
    dracthyr_commando = {
        id = 219827,
        spell = "breath_of_eons",
        duration = 30,
    },
})

local lastEssenceTick = 0

do
    local previous = 0

    spec:RegisterUnitEvent( "UNIT_POWER_UPDATE", "player", nil, function( event, unit, power )
        if power == "ESSENCE" then
            local value, cap = UnitPower( "player", Enum.PowerType.Essence ), UnitPowerMax( "player", Enum.PowerType.Essence )

            if value == cap then
                lastEssenceTick = 0

            elseif lastEssenceTick == 0 and value < cap or lastEssenceTick ~= 0 and value > previous then
                lastEssenceTick = GetTime()
            end

            previous = value
        end
    end )
end

spec:RegisterStateExpr( "empowerment_level", function()
    return buff.tip_the_scales.down and args.empower_to or max_empower
end )

-- This deserves a better fix; when args.empower_to = "maximum" this will cause that value to become max_empower (i.e., 3 or 4).
spec:RegisterStateExpr( "maximum", function()
    return max_empower
end )

spec:RegisterHook( "runHandler", function( action )
    local ability = class.abilities[ action ]
    local color = ability.color

    if ability.empowered then
        if buff.tip_the_scales.up then
            removeBuff( "tip_the_scales" )
            setCooldown( "tip_the_scales", action.tip_the_scales.cooldown )
        end
        if talent.mass_disintegrate.enabled then
            if talent.eruption.enabled then
                addStack( "mass_eruption_stacks" )
            else
                addStack( "mass_disintegrate_stacks" )
            end
        end
    end

    if ability.spendType == "essence" then
        if buff.essence_burst.up then
            removeStack( "essence_burst" )
            if talent.momentum_shift.enabled then addStack( "momentum_shift" ) end
        end
        if talent.extended_battle.enabled and debuff.bombardments.up then
            debuff.bombardments.expires = debuff.bombardments.expires + 1
        end
    end
end )

spec:RegisterHook( "runHandler_startCombat", function( action )
    if talent.onslaught.enabled then addStack( "burnout" ) end
    if talent.unrelenting_siege.enabled then applyBuff( "unrelenting_siege" ) end
end )

spec:RegisterHook( "reset_precast", function()
    max_empower = talent.font_of_magic.enabled and 4 or 3

    if essence.current < essence.max and lastEssenceTick > 0 then
        local partial = min( 0.95, ( query_time - lastEssenceTick ) * essence.regen )
        gain( partial, "essence" )
        if Hekili.ActiveDebug then Hekili:Debug( "Essence increased to %.2f from passive regen.", partial ) end
    end

    local prescience_remains = action.prescience.lastCast + class.auras.prescience.duration - query_time
    if prescience_remains > 0 then
        applyBuff( "prescience_applied", prescience_remains )
    end

    boss = true
end )

spec:RegisterStateTable( "evoker", setmetatable( {}, {
    __index = setfenv( function( t, k )
        if k == "prescience_buffs" then return active_dot.prescience end
        if k == "allied_cds_up" then
            if buff.sense_power.up then return group and active_dot.sense_power_active or 1 end
            return 1 -- If Sense Power isn't used, always assume there's a CD active.
        end
        if k == "scales_up" then return active_dot.blistering_scales > 0 end
        if k == "use_early_chaining" then k = "use_early_chain" end
        local val = settings[ k ]
        if val ~= nil then return val end
        return false
    end, state )
} ) )

local empowered_cast_time

do
    local stages = {
        1,
        1.75,
        2.5,
        3.25
    }

    empowered_cast_time = setfenv( function()
        if buff.tip_the_scales.up then return 0 end
        local power_level = args.empower_to or class.abilities[ this_action ].empowerment_default or max_empower

        if settings.fire_breath_fixed > 0 then
            power_level = min( settings.fire_breath_fixed, power_level )
        end

        return stages[ power_level ] * ( talent.font_of_magic.enabled and 0.8 or 1 ) * ( talent.rockfall.enabled and action == "upheaval" and 0.8 or 1 ) * haste
    end, state )
end

local GenerateEssenceBurst = setfenv( function ( baseChance, targets )

    local burstChance = baseChance or 0
    if not targets then targets = 1 end

    if burstChance >= 1 then
        addStack( "essence_burst" )
    end

end, state )



-- Abilities
spec:RegisterAbilities( {
    -- Project intense energy onto 3 enemies, dealing 1,161 Spellfrost damage to them.
    azure_strike = {
        id = 362969,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "spellfrost",
        color = "blue",

        startsCombat = true,

        minRange = 0,
        maxRange = 25,

        cycle = function() if talent.bombardments.enabled then return "bombardments" end end,
        cycle_to = true,

        damage = function () return stat.spell_power * 0.755 * ( debuff.shattering_star.up and 1.2 or 1 ) end, -- PvP multiplier = 1.
        critical = function() return stat.crit + conduit.spark_of_savagery.mod end,
        critical_damage = function () return talent.tyranny.enabled and 2.2 or 2 end,
        spell_targets = function() return talent.protracted_talons.enabled and 3 or 2 end,

        handler = function ()
            --[[ Disabled for now because Aug has no scalers/bonuses for essence burst chance
            if talent.essence_burst.enabled then GenerateEssenceBurst( 0.15, 1 ) end
            ]]--
        end
    },
    -- Conjure a pair of Weyrnstones, one for your target ally and one for yourself. Only one ally may bear your Weyrnstone at a time.; A Weyrnstone can be activated by the bearer to transport them to the other Weyrnstone's location, if they are within 100 yds.
    bestow_weyrnstone = {
        id = 408233,
        color = "bronze",
        cast = 3.0,
        cooldown = 60.0,
        gcd = "spell",

        talent = "bestow_weyrnstone",
        startsCombat = false,

        usable = function() return not solo, "requires allies" end,

        handler = function()
        end,
    },

    -- Attune to Black magic, granting you and your $403208s2 nearest allies $s1% increased maximum health.
    black_attunement = {
        id = 403264,
        color = "black",
        cast = 0.0,
        cooldown = function() return 3 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) end,
        gcd = "off",

        startsCombat = false,
        disabled = function() return not settings.manage_attunement, "manage_attunement setting not enabled" end,

        function()
            applyBuff( "black_attunement" )
            removeBuff( "bronze_attunement" )
            setCooldown( "bronze_attunement", action.bronze_attunement.cooldown )
        end,
    },

    -- Protect an ally with $n explosive dragonscales, increasing their Armor by $<perc>% of your own.; Melee attacks against the target cause 1 scale to explode, dealing $<dmg> Volcanic damage to enemies near them. This damage can only occur every few sec.; Blistering Scales can only be placed on one target at a time. Casts on your enemy's target if they have one.
    blistering_scales = {
        id = 360827,
        color = "black",
        cast = 0.0,
        charges = function() return talent.regenerative_chitin.enabled and 2 or nil end,
        cooldown = function() return 30 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) end,
        recharge = function() return talent.regenerative_chitin.enabled and 30 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) or nil end,
        gcd = "spell",

        talent = "blistering_scales",
        startsCombat = false,

        handler = function()
            applyBuff( "blistering_scales", nil, class.auras.blistering_scales.max_stack )
            if talent.molten_blood.enabled then applyBuff( "molten_blood" ) end
        end
    },

    -- Fly to the targeted location, exposing Temporal Wounds on enemies in your path for $409560d.; Temporal Wounds accumulate $409560s1% of damage dealt by your allies affected by Ebon Might, then critically strike for that amount as Arcane damage.$?s395153[; Applies Ebon Might for ${$395153s3/1000} sec.][]; Removes all root effects. You are immune to movement impairing and loss of control effects while flying.
    breath_of_eons = {
        id = function() return talent.maneuverability.enabled and 442204 or 403631 end,
        color = "bronze",
        cast = 4.0,
        channeled = true,
        cooldown = function() return 120 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) end,
        gcd = "spell",

        talent = "breath_of_eons",
        startsCombat = false,
        toggle = "cooldowns",

        start = function()
            applyBuff( "breath_of_eons" )

            if buff.ebon_might.up then buff.ebon_might.expires = buff.ebon_might.expires + 5
            else applyBuff( "ebon_might", 5 ) end

            if talent.melt_armor.enabled then
                applyDebuff( "target", "melt_armor" )
            end

            if talent.overlord.enabled then
                for i = 1, ( max( 3, active_enemies ) ) do
                    spec.abilities.eruption.handler()
                end
            end

            if talent.slipstream.enabled then gainCharges( "hover", 1 ) end

            if set_bonus.tww2 >= 2 then
                local ebon = buff.ebon_might.expires
                spec.abilities.upheaval.handler()
                -- Except ebon might extensions. Why blizz.
                buff.ebon_might.expires = ebon
            end

            if set_bonus.tww3_scalecommander >= 4 then applyBuff( "draconic_inspiration" ) end
        end,

        finish = function()
            removeBuff( "breath_of_eons" )
            if talent.plot_the_future.enabled then applyBuff( "fury_of_the_aspects", 15 ) end
        end,

        copy = { 403631, 442204 }
    },

    -- Attune to Bronze magic...
    bronze_attunement = {
        id = 403265,
        color = "bronze",
        cast = 0.0,
        cooldown = function() return 3 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) end,
        gcd = "off",

        startsCombat = false,
        disabled = function() return not settings.manage_attunement, "manage_attunement setting not enabled" end,

        function()
            applyBuff( "black_attunement" )
            removeBuff( "bronze_attunement" )
            setCooldown( "black_attunement", action.black_attunement.cooldown )
        end,
    },

    -- Trap the enemy in a time loop for $d. Afterwards, they are returned to their previous location and health. Cannot reduce an enemy's health below $s1%.
    chrono_loop = {
        id = 383005,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "spell",

        spend = 0.020,
        spendType = "mana",

        startsCombat = true,

        handler = function()
            applyDebuff( "target", "time_loop" )
        end
    },

    -- Increase your $i nearest allies' primary stat by $s1% of your own, and cause you to deal $395296s1% more damage, for $d.; May only affect $i allies at once, and prefers to imbue damage dealers.; Eruption, $?s403631[Breath of Eons][Deep Breath], and your empower spells extend the duration of these effects.
    ebon_might = {
        id = 395152,
        color = "black",
        cast = 1.5,
        cooldown = function() return 30 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) end,
        gcd = "spell",

        spend = 0.010,
        spendType = "mana",

        talent = "ebon_might",
        startsCombat = false,

        handler = function()
            applyBuff( "ebon_might" )
            applyBuff( "ebon_might_self" )
            active_dot.ebon_might = min( group_members, 5 )
            if pvptalent.born_in_flame.enabled then addStack( "burnout", nil, 2 ) end
        end,
    },

    -- Cause a violent eruption beneath an enemy's feet, dealing $s1 Volcanic damage split between them and nearby enemies.$?s395153[; Increases the duration of your active Ebon Might effects by ${$395153s1/1000} sec.][]
    eruption = {
        id = 395160,
        color = "black",
        cast = function() return 2.5 * ( talent.ignition_rush.enabled and buff.essence_burst.up and 0.6 or 1 ) * ( talent.natural_convergence.enabled and 0.8 or 1 ) * haste end,
        cooldown = 0.0,
        gcd = "spell",

        spend = function()
            if buff.essence_burst.up then return 0 end
            return 3 - talent.volcanism.rank - ( buff.imminent_destruction.up and 1 or 0 )
        end,
        spendType = "essence",
        cycle = function() if talent.bombardments.enabled and buff.mass_eruption_stacks.up then return "bombardments" end end,

        talent = "eruption",
        startsCombat = true,

        handler = function()

            if buff.mass_disintegrate_stacks.up then
                if talent.bombardments.enabled then applyDebuff( "target", "bombardments" ) end
                removeStack( "mass_disintegrate_stacks" )
            end

            if buff.mass_eruption_stacks.up then
                if talent.bombardments.enabled then applyDebuff( "bombardments" ) end
                removeStack( "mass_eruption_stacks" )
            end

            if buff.ebon_might.up then
                buff.ebon_might.expires = buff.ebon_might.expires + 1 + ( set_bonus.tier31_4pc > 0 and ( active_dot.prescience * 0.2 ) or 0 )
            end
            if talent.accretion.enabled then reduceCooldown( "upheaval", 1 ) end
            if talent.regenerative_chitin.enabled and buff.blistering_scales.up then addStack( "blistering_scales" ) end

            if talent.reverberations.enabled then
                applyDebuff( "target", "upheaval" )
                active_dot.upheaval = active_enemies
                if talent.primacy.enabled then applyBuff( "primacy", max( 3, active_dot.upheaval ) ) end
            end

            removeBuff( "trembling_earth" )
        end
    },

    -- Inhale, stoking your inner flame. Release to exhale, burning enemies in a cone in front of you for 8,395 Fire damage, reduced beyond 5 targets. Empowering causes more of the damage to be dealt immediately instead of over time. I: Deals 2,219 damage instantly and 6,176 over 20 sec. II: Deals 4,072 damage instantly and 4,323 over 14 sec. III: Deals 5,925 damage instantly and 2,470 over 8 sec. IV: Deals 7,778 damage instantly and 618 over 2 sec.
    fire_breath = {
        id = function() return talent.font_of_magic.enabled and 382266 or 357208 end,
        known = 357208,
        cast = empowered_cast_time,
        empowered = true,
        cooldown = function() return 30 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) end,
        gcd = "off",
        school = "fire",
        color = "red",

        spend = 0.026,
        spendType = "mana",

        startsCombat = true,
        caption = function()
            local power_level = settings.fire_breath_fixed
            if power_level > 0 then return power_level end
        end,

        spell_targets = function () return active_enemies end,
        damage = function () return 1.334 * stat.spell_power * ( 1 + 0.1 * talent.blast_furnace.rank ) * ( debuff.shattering_star.up and 1.2 or 1 ) end,
        critical = function () return stat.crit + conduit.spark_of_savagery.mod end,
        critical_damage = function () return talent.tyranny.enabled and 2.2 or 2 end,

        handler = function()
            -- Many Color, Essence and Empower interactions have been moved to the runHandler hook
            if talent.leaping_flames.enabled then applyBuff( "leaping_flames", nil, empowerment_level ) end

            applyDebuff( "target", "fire_breath" )
            applyDebuff( "target", "fire_breath_damage" )
            if talent.infernos_blessing.enabled then applyBuff( "infernos_blessing" ) end

            -- Legacy
            if set_bonus.tier29_2pc > 0 then applyBuff( "limitless_potential" ) end
            if set_bonus.tier30_4pc > 0 then applyBuff( "blazing_shards" ) end
        end,

        copy = { 382266, 357208 }
    },

    -- Form a protective barrier of molten rock around an ally, absorbing up to $<shield> damage. While the barrier holds, your ally cannot be interrupted or silenced.
    lava_shield = {
        id = 405295,
        color = "black",
        cast = 0.0,
        cooldown = 30.0,
        gcd = "spell",

        startsCombat = false,
        toggle = "defensives",

        handler = function()
            applyBuff( "lava_shield" )
            active_dot.lava_shield = 1
        end,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': SCHOOL_ABSORB, 'sp_bonus': 12.0, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'value1': 10, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_TARGET_ALLY, 'mechanic': 26, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_TARGET_ALLY, 'mechanic': 9, }
        -- #0: { 'type': APPLY_AURA, 'subtype': SCHOOL_ABSORB, 'ap_bonus': 0.075, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'value1': 10, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- mastery_timewalker[406380] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 0.5, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- hover[358267] #4: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING, 'target': TARGET_UNIT_CASTER, }
        -- spatial_paradox[406732] #2: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING, 'target': TARGET_UNIT_CASTER, }
        -- spatial_paradox[406789] #2: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- spatial_paradox[415305] #2: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING, 'target': TARGET_UNIT_CASTER, }
    },

    -- Send a flickering flame towards your target, dealing 2,625 Fire damage to an enemy or healing an ally for 3,089.
    living_flame = {
        id = function() return talent.chrono_flame.enabled and 431443 or 361469 end,
        cast = function() return 2 * ( buff.ancient_flame.up and 0.6 or 1 ) * haste end,
        cooldown = 0,
        gcd = "spell",
        school = "fire",
        color = "red",

        spend = 0.12,
        spendType = "mana",

        startsCombat = true,

        cycle = function() if talent.bombardments.enabled then return "bombardments" end end,
        cycle_to = true,

        damage = function () return 1.61 * stat.spell_power * ( talent.engulfing_blaze.enabled and 1.4 or 1 ) end,
        healing = function () return 2.75 * stat.spell_power * ( talent.engulfing_blaze.enabled and 1.4 or 1 ) * ( 1 + 0.03 * talent.enkindled.rank ) * ( talent.inner_radiance.enabled and 1.3 or 1 ) end,
        spell_targets = function () return buff.leaping_flames.up and min( active_enemies, 1 + buff.leaping_flames.stack ) end,

        handler = function ()
            if buff.burnout.up then removeStack( "burnout" )
            else removeBuff( "ancient_flame" ) end

            removeBuff( "leaping_flames" )
            removeBuff( "scarlet_adaptation" )
            --[[ Disabled for now because Aug has no scalers/bonuses for essence burst chance
            if talent.essence_burst.enabled then GenerateEssenceBurst( 0.2, max( 2, ( group or health.percent < 100 and 2 or 1 ), action.living_flame.spell_targets ) ) end
            ]]--
        end,

        copy = { 361469, "chrono_flame", 431443 }
    },
    -- Wreathe yourself in arcane energy, preventing the next $s1 full loss of control effects against you. Lasts $d.
    nullifying_shroud = {
        id = 378464,
        cast = 1.5,
        cooldown = 90.0,
        gcd = "spell",

        spend = 0.009,
        spendType = "mana",

        pvptalent = "nullifying_shroud",
        startsCombat = false,
        toggle = "defensives",

        handler = function()
            applyBuff( "nullifying_shroud" )
        end,
    },

    -- Grant an ally the gift of foresight, increasing their critical strike chance by $410089s1% $?s412774[and occasionally copying their damage and healing spells at $412774s1% power ][]for $410089d.; Affects the nearest ally within $s2 yds, preferring damage dealers, if you do not have an ally targeted.
    prescience = {
        id = 409311,
        color = "bronze",
        cast = 0,
        cooldown = function() return 10 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) end,
        charges = 2,
        recharge = function() return 10 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) end,
        gcd = "spell",

        talent = "prescience",
        startsCombat = false,

        handler = function()
            applyBuff( "prescience_applied" )
            if solo then applyBuff( "prescience" ) end
            active_dot.prescience = min( group_members, active_dot.prescience + 1 )

            if set_bonus.tier31_4pc > 0 then addStack( "trembling_earth" ) end
            --[[ Disabled for now because Aug has no scalers/bonuses for essence burst chance
            if talent.essence_burst.enabled and talent.anachronism.enabled then GenerateEssenceBurst( 0.35, 1 ) end
            ]]--
        end,
    },


    -- Gauge the magical energy of your allies, showing you when they are using an exceptionally powerful ability.
    sense_power = {
        id = 361021,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "off",

        startsCombat = false,
        nobuff = "sense_power",

        handler = function()
            applyBuff( "sense_power" )
        end,
    },

    -- Evoke a paradox for you and a friendly healer, allowing casting while moving and increasing the range of most spells by $s4% for $d.; Affects the nearest healer within $407497A1 yds, if you do not have a healer targeted.
    spatial_paradox = {
        id = 406732,
        color = "bronze",
        cast = 0.0,
        cooldown = function() return 120 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) end,
        gcd = "off",
        icd = 0.5,

        talent = "spatial_paradox",
        startsCombat = false,
        toggle = "interrupts", -- Utility CD...

        handler = function()
            applyBuff( "spatial_paradox" )
            if not solo then active_dot.spatial_paradox = 2 end
        end
    },

    -- Surge forward in time, causing your cooldowns to recover $s1% faster for $d.
    time_skip = {
        id = 404977,
        color = "bronze",
        cast = function() return 2.0 + ( talent.tomorrow_today.enabled and 1 or 0 ) end,
        channeled = true,
        cooldown = 180.0,
        gcd = "spell",

        talent = "time_skip",
        notalent = "interwoven_threads",
        startsCombat = false,
        toggle = "cooldowns",

        start = function()
            applyBuff( "time_skip" )
        end,

        finish = function()
            removeBuff( "time_skip" )
        end,
    },

    -- Enchant an ally to appear out of sync with the normal flow of time, reducing threat they generate by $s1% for $d. Less effective on tank-specialized allies. ; May only be placed on one target at a time.
    timelessness = {
        id = 412710,
        color = "bronze",
        cast = 0.0,
        cooldown = 0.0,
        gcd = "spell",

        talent = "timelessness",
        startsCombat = false,

        handler = function()
            applyBuff( "timelessness" )
            active_dot.timelessness = 1
        end,
    },
    tip_the_scales = {
        id = 370553,
        cast = 0,
        cooldown = function()
            if set_bonus.tww3_chronowarden >= 2 then return 60 end
            return 120
        end,
        gcd = "off",
        school = "arcane",
        color = "bronze",

        talent = "tip_the_scales",
        startsCombat = false,

        toggle = "cooldowns",
        nobuff = "tip_the_scales",

        handler = function ()
            applyBuff( "tip_the_scales" )
        end
    },

    -- Gather earthen power beneath your enemy's feet and send them hurtling upwards, dealing $396288s2 Volcanic damage to the target and nearby enemies.$?s395153[; Increases the duration of your active Ebon Might effects by ${$395153s2/1000} sec.][]; Empowering expands the area of effect.; I:   $<radiusI> yd radius.; II:  $<radiusII> yd radius.; III: $<radiusIII> yd radius.
    upheaval = {
        id = function() return talent.font_of_magic.enabled and 408092 or 396286 end,
        color = "black",
        cast = empowered_cast_time,
        empowered = true,
        empowerment_default = 1,
        cooldown = function() return 40 * ( talent.interwoven_threads.enabled and 0.9 or 1 ) end,
        gcd = "spell",

        talent = "upheaval",
        startsCombat = true,

        handler = function()
            if buff.ebon_might.up then buff.ebon_might.expires = buff.ebon_might.expires + 2 end
            -- This was reduced to 50% chance, can't gaurantee it atm
            -- if set_bonus.tww2 >= 4 then addStack( "essence_burst" ) end
            --[[ Disabled for now because Aug has no scalers/bonuses for essence burst chance
            if talent.essence_burst.enabled and talent.rockfall.enabled then GenerateEssenceBurst( 0.6, 1 ) end
            ]]--
        end,

        copy = { 396286, 408092 }
    },
} )

spec:RegisterSetting( "use_unravel", false, {
    name = strformat( "使用 %s", Hekili:GetSpellLinkWithTexture( 368432 ) ),
    type = "toggle",
    desc = strformat( "如果勾选，则在目标具有吸收护盾的情况下推荐使用 %s。默认情况下，【中断】必须处于激活状态。",
    Hekili:GetSpellLinkWithTexture( 368432 ) ),
    width = "full",
} )

spec:RegisterSetting( "use_hover", nil, {
    name = strformat( "使用 %s", Hekili:GetSpellLinkWithTexture( 358267 ) ),
    type = "toggle",
    desc = strformat( "如果勾选，则会推荐 %s。在默认优先级中，在您正在移动且有费用可用时才会推荐。", Hekili:GetSpellLinkWithTexture( 358267 ) ),
    get = function()
        return not Hekili.DB.profile.specs[ 1473 ].abilities.hover.disabled
    end,
    set = function()
        Hekili.DB.profile.specs[ 1473 ].abilities.hover.disabled = not Hekili.DB.profile.specs[ 1473 ].abilities.hover.disabled
    end,
} )

spec:RegisterSetting( "use_verdant_embrace", false, {
    name = strformat( "使用 %s 在 %s 中", Hekili:GetSpellLinkWithTexture( 360995 ), Hekili:GetSpellLinkWithTexture( spec.talents.ancient_flame[2] ) ),
    type = "toggle",
    desc = strformat( "如果勾选，可能由于 %s 而推荐 %s。", Hekili:GetSpellLinkWithTexture( 360995 ), spec.auras.ancient_flame.name ),
    width = "full"
} )

--[[ spec:RegisterSetting( "skip_boe", false, {
    name = strformat( "%s: Skip %s", Hekili:GetSpellLinkWithTexture( spec.abilities.time_skip.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.breath_of_eons.id ) ),
    type = "toggle",
    desc = strformat( "If checked, %s may be recommended without %s on cooldown.  This setting will waste cooldown recovery, but may be useful to you.",
        Hekili:GetSpellLinkWithTexture( spec.abilities.time_skip.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.breath_of_eons.id ) ),
    width = "full",
} ) ]]

spec:RegisterSetting( "manage_attunement", false, {
    name = strformat( "管理 %s", Hekili:GetSpellLinkWithTexture( spec.talents.draconic_attunements[2] ) ),
    type = "toggle",
    desc = strformat( "如果勾选，则在战斗结束后可推荐使用 %s，如果没有其他人提供光环，则恢复 %s，否则切换到 %s。\n\n"
        .. "这个选项可能会使你分心，因为有些能力可以在战斗中改变你的操作。", Hekili:GetSpellLinkWithTexture( spec.talents.draconic_attunements[2] ),
        spec.abilities.black_attunement.name, spec.abilities.bronze_attunement.name ),
    width = "full"
} )

spec:RegisterSetting( "manage_source_of_magic", false, {
    name = strformat( "管理 %s", Hekili:GetSpellLinkWithTexture( spec.talents.source_of_magic[2] ) ),
    type = "toggle",
    desc = strformat( "如果勾选，则在您处于队伍中时，且您的所有盟友都没有使用你的光环时，可能会建议您使用 %s。\n\n"
        .. "这个选项可能会使你分心，因为有些队伍可能没有治疗师。", Hekili:GetSpellLinkWithTexture( spec.talents.source_of_magic[2] ) ),
    width = "full"
} )

--[[ spec:RegisterSetting( "upheaval_rank_1", true, {
    name = strformat( "%s: 只用等级 1", Hekili:GetSpellLinkWithTexture( spec.abilities.upheaval.id ) ),
    type = "toggle",
    desc = strformat( "如果勾选，则 %s 只会被推荐到默认的等级 1。\n\n"
        .. "否则，在探测到更多目标时，可能会建议使用更高等级的 %s ，这有助于确保目标维持在半径内。",
        Hekili:GetSpellLinkWithTexture( spec.abilities.upheaval.id ), spec.abilities.upheaval.name ),
    width = "full",
} ) ]]

local devastation = class.specs[ 1467 ]

spec:RegisterSetting( "fire_breath_fixed", 0, {
    name = strformat( "%s: 蓄力", Hekili:GetSpellLinkWithTexture( devastation.abilities.fire_breath.id ) ),
    type = "range",
    desc = strformat( "如果设置为 |cffffd1000|r，%s 将根据行动优先级列表推荐不同的蓄力等级。\n\n"
        .. "如需要强制使用特定级别的 %s，请将其设置为 1、2、3 或 4。\n\n"
        .. "如果所选蓄力等级超过了你的最大值，则将使用最大值。", Hekili:GetSpellLinkWithTexture( devastation.abilities.fire_breath.id ),
        devastation.abilities.fire_breath.name ),
    min = 0,
    max = 4,
    step = 1,
    width = "full"
} )

spec:RegisterSetting( "use_early_chain", false, {
    name = strformat( "%s: 持续引导", Hekili:GetSpellLinkWithTexture( 356995 ) ),
    type = "toggle",
    desc = strformat( "如果勾选，可能会在正在引导 %s 情况下被推荐，实现持续引导。",
        Hekili:GetSpellLinkWithTexture( 356995 ) ),
    width = "full"
} )

spec:RegisterSetting( "use_clipping", false, {
    name = strformat( "%s: 中断引导", Hekili:GetSpellLinkWithTexture( 356995 ) ),
    type = "toggle",
    desc = strformat( "如果选中，在 %s 期间可能会推荐其他技能，从而中断引导。", Hekili:GetSpellLinkWithTexture( 356995 ) ),
    width = "full",
} )

spec:RegisterRanges( "azure_strike" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    gcdSync = false,

    nameplates = false,
    nameplateRange = 30,

    damage = true,
    damageDots = true,
    damageOnScreen = true,
    damageExpiration = 8,

    package = "增辉Simc",
} )

spec:RegisterPack( "增辉Simc", 20250806, [[Hekili:T3t7YnUns(S4ARHJONXYKu2ooZAPuztUBVKkx2uL392FC1zkkkilwdLOwsk7XPuPN9RBa(bajaiOK8mj1MSjzZic2O)gD3Ob4dUp83F4(5b5Kh(zphVRDU15MHUJ8UX96hUp)LnKhUFtq4hdEe(pwhSc(3F72hxrwNhKhLSgF4lXjbZrGKLSnnegWY88nzF4YlFmkF52zddtwDzw0QTX03imnyro(NdVCwCYSlZxsEoi9zyOrRV8BdXH8lPrjPr5V8trz5zxoNSiyBC(LKNs(ij1pGB2hIG5H7NTnko)hw)Wmz0X1x5cy2gs4d)S7vF1ia7IMpNWgmjdE7lUy)0)(sY(P)ZGu4FrrK9tVNeKLa))J2)Ji0UW52lCU5d7N(dRJYJcI3p9B)LFA)pU)h1)2ELV9vx4Dl82)Lx2eKLbVr0k4vU)JrB2pn7fGA(0(PrzzBjCJ)Ay8)NrWd(lj)h)59t)hBwscEcN5TzGWy)0fjWe(DlttwNamqGK4E3rLV7MuYtrjBHPmA1MK086X4EfmM7Jw9DW)(L1HLpy0foEWd(7)Z)jpvmD7gKZshe8QEmEb7TfFKdBYDDh6meuGIrriQBSikoMKc)x)mvFJSoywmz(d)LhUpee1K0OGhUFW(PZ2UyXWG1HrGi2FrmOVnClWJ2TB)0vbRd2pDYyaFCW)I9RNTFAEqmm6HZtjbR8tw4NTjnA9JdlMc2WEkaMb4pomBdmiGtc8rasaqS3p1A)uyQdaDVNi(K1KvrKm6JDzVCXeSz7MOyCcG)4NYYtdY(1G6zX(H7dczMeXrpbiad9FihuhrkU8Hb)62uIp86rFKWZhYH)39jBGPp1xnZkzdOmtYRbxjHH)xXBj1)WWcynNeh8cW3(goMWQO1G9iWS4gcVG4mUXwmMW5zW4YjH5iXcCmM54WG44iYC6Jrb1eGNsXbFMVcHzOKvCkOhWSZv3enQ3tK7RkhG)Tr87kLwbQeGG(4OA0NKUDd9)cG11kH1rPtRwH(gJvOlCExPkx(s)RTK4yXrlAMSDDAWtKMdP)s15eQlLCc6(li2)5KTRNpmLSkiADgVCchb7PYepDprHjjXZtEE9WzGFO8LipLKSot2uH)UF5Vlr(PDYkbYgy(8H1a8JMZlXlKRrRaBC0hkSgxE6wkCQ9vXC4b64WS4plz92SH5p)8i)R2ew5vDjjnXppLqggYVgd6NRuOEVtf1pGZEHN82p9U9tVLoJfywd2JGx6kE4CczJpBKdBdPZ6eymN6KSmY6qcaTfrHr5mBi3sqq1lkgI)STPz5WsnvA3snNEmCEn6GadwJJJBMgen3N8eIyRsEIGHPmK8jCfWYbbgjR)ijFyU7WOSHjGvvWNY8xrsd3ctqSp5XhlmplhONMbAZgRSPfdc5oabVryHPLWJtbBRmcWYw4dKdAwcK8x1GKlFbi8HmCTymQUWxcJj(5bPpsGL0)z3gRCNLeNqjtkFT(ffKFfoFEmnbDvAvTO78KCUxHoupULMH)EX24yqPkCjo)(504NqcefjRWWNohJvtulIaQ2(RIECzohs0(DyZbtDO6n8ZiXlQFTlA9w2myj91MVnLgFkDS12f1JAtW65Gl5q)8LavVeWxgQpljJPRSGombSEKtLexLP2yQfcN7DiKjQ1Bu2kbRFkwl1hrHCPWUOuOXSyQySlIap(fMNfVa)J3weQk9zvcrJuq4zYEmsrTksXtOlaNXntNPN(Pm62g)z5qAou4k5Hao5xmak7Ts)Z1PWLygynSPyfrkRmByHFY3n(sC8(zq4(VNz)4hTymaYpuS60SKvZa3ROLB1cgVhgIugEBlHjowvJKJVQFGnCDQFWvsuzdJjiej4A0GNIJw)HbfKCB5)fqy9NpGn6HPjG2DqoYX3TJ)3Gm5IJf)P5BYSF31oNx8ByUEd5Zs0gzLdg0g1VBCH625J2TtJxdUXznqNFIlQgN9DJ16z4CZ8kSBh6C3cDlyj4s4UXJCS3TtQJG7gFlYGAAayPZO3QqD)oxRZuyMZ9aodCBlLc07k5gEwdoRn(SBNkJW70zacKgv056yBPrKIRQDB3Xy32bQJjEI5wHmPmk8VUZ8A1T6sqriA1kFHbz5fl0DYxRH5NubxysftO7aTS6kOTAGXfMsW85zvHOmI3L6e26CClHTkjoNS2NSAgjnRziScXV657Xf)QbHBwmemOO4K05cHpYVyI(vlRxorL4viMdUWXQFbu)X1rrqyHWcC(S)Gpwpfwvvksda0XwrtIWvDDvuLrjnt1YzjD7ALtIyzjWjRzE8Tsabv2cGCEbg)IGCstbhwxkm(ZHUnKqm(j3J50QQ1JyXr0rWscXckpRSI0QDeel5rBaBfy9AGXty82M5DwtUyELptOfCIZDjBYhORgbTdwrHMUazu55vGAhqJ77D7NEf1lqPQFm6bzX2uWNlNa4cAwb1dBrcOud8LvbpgfQ0gqfJS0cOMmQs1M54waGgQuVygLR3mj8Y3LtLamawdscSyiqegczOD3yhkuuxDKce(zq4fdkRGCIxlTzTtMugjCrCg0y6Yt8NhrkYSCuNLfQKcezI6jcR8OWpMnbwWJsoQZovp5mOteFGCF00kUEDLuU5qktWvMlEbRSIzP5yct2Ugsn)syayY031MXxPjYxuUAQelcsiD1F4NQZ0MUCYBau)khMrI3iMnN4tMmUmBUE4B5KiiBMZTPrN0G(gvqEUEvurfYxrosOc3RRvlmOKr8RitIZ9dsxLKkT63hblrDaB)(w79KWCAgFzvLslwsqXQsBR23OILK6mAuWvvDqL2D4tRxlJH5WZTkP)8ayrhYqKobuTXsD8zFikk431MJmr(M1a1JvdulEcknj8JlasxKwKxbraDdZlf6fsbqBf3DbSc3ndXtqbN93Dq)FdU9x0j4DIdVDKbCJL93LX6yj(M6cnYRWNz3bt3Di3DNRW4keUhXE3ryhwfWOXZf1OUUraGfvRHkZuhxDxB8OLovelXuWe3xYIsFP4PILWU9ULAXv)l(NXhkMLAhbLm2wLpNl7yLwDJ7YQZQJc0oHgflFwsRiGyBU)SyyzTKvuzsZ0pkhRWgv1wsTkilZVCNZAlNeEmdFZ4QVzNfn9i8fzjB3kkL0D7XEmnMEb3NQk(9nLIFn1ESAHmKlvXU(ejCBEzT3fcDq)oJJOvZvfzAX2s2vbu82mDRsXR4wn(hI3ptIxs4Ye0SIX4nijjvYvvj010e3SYPVjcEjS2ULRaG)AyY6NiWKcSARZyo(B8Z(ymxXXKqC)(SguixMm2tAbjPERTLvI7KnyjpZqgtAsq6NhePNl)u3Zm3CnRNz6CTHUwzrcQv8KbYxPT4PY2Q5ESkFZU)PEZWi)RTrB2qMpCEeeo56Cag(pLenpmjLuXegUjSy)FVMwShuBuDHbaeac(AEP6BX8Qmwc9uOYTAwz7v41mh)k7KYM(OpfxgmjfTT)sV2UIjPoUizrK3UcaCnaHG6Nw1Ow09D1rBPqZwiqSoQRolJivU)uNX)zvPyXk6OVGXwZk(dSxUmkX6Mrt1JRGLEnZKUC06QYBv5DZPB8FiUYrDN7WbmS)uasURouPkOvHogrrtGza8K31AIGU)ni0t9OP4kRucM0(Zjpbz5wuM76wMsDhP1)wkslQrtauAL9L1oqheglRVKmqojRJ3AiMA6GRBEHyNZKUD2l(pVKeVXpd(3ff3qCmpVmkBdZWiADyq66aWdyuiwuJ2d2KwXHoWGzK0uyvgF6grdUFEuG2lgSVRp5tHXBNtK1Dn9GA9mGA96d1QRFIApqdPwpEQTPRNEqTuo86xwTf9aYAaqQFTnrRNhtKjoY28cewpOCN5)mzMSrKJRRGnZ22mFiZK1zRIYHXlBOltyDgLpW)MN1ik0FMIwyBAJlYTAtCuiWIN)(9t)VdwVfZm))kaXs5AdROJr22e3d2JxFypEDYE8mN94jJ9itpOMoBTDM9GqPsJzaIbltLNq3mUzKxswpxoZn5XW5(42LlDFq7X861N51RX82)wBEGGc4YaqQMHrESybJ931Z)C)W2XG1YDNyX7efOq8TPK1ZtY83efNKdbGaH0qJwsMqfNs5B(A)ySEDWyL98p3punJ1RdgRxFzSECmwfrKG7eHU13RLrzVSou6gx1qmwvpHA9H6kbxTvdVb3elNQZLrH00NeNbtk90Ku1P(Y2x3EI9EDJ9EkWEVta2RicitX(nfhrQhuCMfKja6b9HQNL0Oj6MO29zT8CudHM9TQcmOtM8LcdaFxFHTQ6CkmODL970yVX6GxDJOcwsqzuVPAlvAH3svTVuyagJ3nDa3gVL4IwbE7wJ3Sr4wUfsIyFu8tX0MeH3hd93Sz7ZPt9wkjQK7wPI7jDdUnufNTPG(hJMUCT16N3I0W670GhON2ueKlsBIBAnhq7zSBAgC1sbhO9EZgw(7t2odHlQnc6suXpEimZJ(vcEKhlktj3akajalS752pLfD87PNkrS7SXF9zGrq3w3C88rUojDfgLCCYJrGAyEY(PpUnatUGapflfdlY60uSGO695PyHFfYkzrCBqASyfD8l3cxGS4YH9gPBMRHWvBjK4tuE4vs3)rdNgvnitRIXCGvJHSwpyLf1MbGLw0iGbHU0ke8TaDZ4wyVP0CvlNkzpuFnGLusUUk6MWXItCRiRNcA51wmtwD1QNCfnbqW8xuxwqE8RDlmQAht5MGheAyHRKuetomSrhfXQSB9MlOOPcTmz3UaVa1T(CDiVD2DjD3KKy8z9TljhvUAxvjIfzUSd5ISAp2jlEuFzX3(7soONjCqAX5v0lT2YkFANCxV(YDD9(Dj71LN9QLf20zxNSq3EZcV53LSqhJzHQ2zoLSqC3Xk(Z9Lz(64qvlvkRA1DsIhUBSoPnzNVdRU0tSzRXYozeswMTKGugGT0vIv1LCfhHLwf4qFe8YcpVm(wHJPVPPe0jaRBp4bD1KHijDLr2BxvMlsNSPjS(2KLC2GQ2tPX5YVCLanhpe7tpV27uZRzTadlSu1AzsIk7WJKvzWhYQn4XMlD5(z0kzAL1ISOarAZkx(ZLntQlNCjlu(d1egHI9bP3UcCf6XgzNfdKvy05maVaMkZawoYPznDXD(PrvjoEJpzOl2AXxqF6i2AWyav1lcREpOllkLgM2fSf2Rhuvp6wpMZfDTvpcb08RDkNot2qFENMsOzVIEMPJ(JxYBEJJsxzn30UgJrAHrRBFhzJtOtcDDuwmw(9AOThXoWlPf(ucE52x8sCZLSl9vqvHfXjAoWL1rqq)xtOBn3wtUtrrr()lJwGfYQ0v1K6Lm0mIQE7S71A)kJwR9R4wuPboRjQTcMORXBttN(77y))SkRP8b7KPCZec660eOOmi0NH0VqJPwhtvf2lPwtL4)zDFIhRatJtp94QtOITsdnb2Tml26wQKJr16aMY9S6J5JTEEJ6AhRz)CAUJqD6OrkD3kgPwEgASZiiVuW3jyxdRMZPvlPFtAO57z8w81z8hDSjy)HMFNA(Uk08D)YQ57A(oz25szDR57jB91EQ5t3zdvNiqXJjHWo98T4J2p9E6ZkUdj)B)1V77RWLSH7N(dZjqKmaYMVe3tgq9f7T1zeCtHQVaEWAkapfpKLGGjMsDZ2Mx(w4)KfTAtmU9qbRNJjZdjKVNUZplHCHWTec)N8OqcscGDt0ci3gg0rW(9)Y9dLgaoMApeLLVR7vUCkmsKRvTOtZeiKOVv96k2bsf5L3wfqTFFfOJuh)gHontDvMgPDrTRuEbtu5nTP31M3uyNY0gnkmcJ4bMismkA2MruMsWRmvUd5ZOMHO22byzgbD7gxfoll45oIvNXSeVD6W2jGfdQEZIM7f8pSa3Mx06pznP9o(IUEtEkAoUYsaJL9(YrGBZBc8VtzVwffbUyGFkca8Ase75DdTzjOVEb48GS27R9Y9nCu2tL4tFebgPeBIHCJb8BoL4oYauN5E)vI9evIL1bM6Yb6p8FDsf9Nc)xY5OIUQAh(FR2dvx8))Hb)jvQFkm4LZr1i1zn1JQ64oJKLdKf8czT98ZkEIWqQ1n0LtLsTZcvNU5k8vluRmV1nCHwD2UncLoX6QniZxQQ6kJd2Fza2s8mPc3pOEH2hBEX5(i398PZWBkTTQolNcYiH4t(hz8rL8mjytc9wuMUNFpbga4OyFbaUY72hU)5G01SguIEn9xCn4ZY85Tfnw0BXuyGPof1WZsWTjnyBEYQa6v9DiqDpsGeJ(XFkcdjcV67)o6X4L(43wYvvFqIEllRN3kAlRAOdC)KDNtM6ZXtRjt7qfMm3gZwYgctnQipV3QSc9wdAF98mzS7iRbTVuEMm276D7ot(vXd7gVuY1WdfAsV(DEJ7WRVtSQh22wNvz0OQt4aCgq238gVRCUBS3i8(2P4poz8iBTx9Mv84FlYpU844hISdJ4g1kqFvhkqsxdcVRJkKfJG521dMo6mrNZgtN71iVLTTnAUXQQUbuBFBvzxk96az(8Gl18UB7G39fuLsQjwjB8liEjvvhzPuF9lsIJtEM2cYbW6HyPSiy1VGvoMZ4P0uwzlTTFk2tNfLWInU1j0fk2Uwy0ZNJdEEqEWSGmYh2)JSULx5L7a(vIrYspvNW6t4IpnpOOYx3rYOmAjh9NQw5ZLUHB(KA26Ch)IQQoHVYNk5duyI(kDRE3P0s1OmFkmxA15WnFsntAzEujANmtKwAgOWeDRo1cL9XJCLdDd38jvmDp5ZuRXyo4v0xjYNh1d28juCFRLppTgJa4)ADkdMlJ6C4MpPDiJKpgZbVPYOogS5tyhYi5JrmnchD6aYoF1Y1eumsX5YvhTy0CPBKIZLNs6I)u4jHyA84(avAzjQcMqbSBnOt(mCmypt1)fD4E9qoXq)yWBSAcqe44wBQd3fh2RWSCm0WsK7Od7lhWjfYhdgJvnshcx88tjCpa0nsrdOk3tMQHkoBJu6ktR7LwpUpqTdJFfd6Kpdhd2RYbG0HCIH(XG36m8voSxHz5yOb5obKmGtkKpgmwQBG2p)uc3daDn29I2HkoBxP0zwRTnqIxmzJ51f(kHS6QkwaVYnMXAGUj4nVX1ZzSt7Yb2pOuaKAS9ALs1U5dYhJiF(udFLqUB(SxloKKjOt(SzqPfFw9wJGgDLaqHnj3Jf5UQRnKwO26XMb1dvM9AdFtG8M0KWHbRFXF(MmDqx14mLcmDEqLi)da(ghKshHbDcMbLRuyaSpIWGoAO3B8(qxt41g(MazZ0hvpotPatNNdtVVh5(FG699ygoa9No1mnO6chn0pa8gVBHKaTIF2mO4jhkEgbLwRQFMYaFmALA(19SAdRQUJA3UZAW9kFl(pKLTMj9bfW9qbZa7Zh4m863PWn15Ju9e49KGk4nNLT9Kb6deuLjztCXvjU42jUWUfVGN4(obSbf8x0qrW(nUoo217t7VJLZx(Bi58L)MtoFzHCU2KxZwM1dhhQGs)CI9fzx1uoR9iySow27emdkx(qnS7fpRZHB2S2JfYpqEwpMHEZZ6uX5vspRxZANdVyw)S3xlyzTu0bl0lyL32RUxr1M11jt)OKrFEfr)7gL(zTiMQMSxLnKrvH2orTMXPUoEVYGVpaUOX90b36H0xSUha3aW2TO0Go4qTMs38AdkZXPg89bWQ42shsFX6Ea8kWQo22Q3z7gDkh0NkGPNcqAaW4Zfsc0A84(IH9WS4vf4DcwZRSLrvq74NgHS4AcE1HvQt3O5tp5G0aGPvDt)(vyag2dt3xvG3jynFdemsD74NgTQBQAnV(OB8kaYob2H5RWqm9WaEFaBNU37pM2ji7eyhMbHHy6Hb8kWQShppmzvZezoTq3e4EsId0e8UxbD)Ad)AiRoH1o54DReEIHUjWTB5PbPOzcE3RiVFTHFnKv16IhMfut8(0cDtGB3YttSpnaV7L9ZRn8RHS6kF0jh3a7Ztl0nbUDlpnX(0a8Ux2pV2WVgYN6ULRjMFQHFVGCp0voa8UhqVB4EOwMMI3hk87fK7HV2daV7b0hI7vWpq3MaeA3iUle4gb8W9bBZxIFoDUpGedKlGq)q4lx8)qG33(pVF69rR(o8dqCYIi8Qy)p9N2pDzE(MSpC5LpgLVC7mywxDzw0QTXuovyAWIC8phE5S4KzxMVK8Cq6ZWqJwF53sN9FP4Ix5NqC4YIl9HlzxER(bBFe)64tH1qem7)rCoVVAc(oCcqM0Qv4NPO7FzDiWZUE0voeVfSb)9b5KpG3ZgExFHZTx4CnYgyuE2WQt677gFz5g9(E8QizC1xi53xGtJDEFYMX0ptoM8(Y(UaxbGAyAcOeab9ZN04QnLw60eTy8zkV(KFnMX3v90M4XPan4)AfFGSWc7I6B5McQsynVMhN3D7eESYtGBJXj9GZ2ymsoXR9Hm8uqgE6jdpdjdpdidpLKXFQ8tow3FqE7dnxEdFjtYPCdXAW2fJyPXdvCanBmkXJxzFiap5eG(D0Rbdxfb4zeb4DCea3f(LmHGSJPzFaVNsW7DkaFrdvva6b1OoFNlSBxJhi23d86cnBdrPp7P6t4J0NVeFxPpb3CFBj9YvLhmBRbNjW)LUVP29Hf5jNf5PIfjRDA412uZI86Gf18Wgj9jQyrEYyrQ3h7EXIyn)fUke9tkzbRY991FKdh7m863dAQZJqyowzJ9XPO1kcZYJLrFWmVJgZA1zHsI99qWSY7wVM4MhpU5YHzht3qEqnd5H0lKYyo1pt6go0OleLz(W1kITTFmSZiLPqv)mtWmz((4WS2o)mUpjB0MKIDdRjkvkU3gpb6wYuvypreBNmwKyOr88BVptRMWmpyUihhqtWlw600BewIAGCMoTsmhJbMHnMoHWQg92)JrQUn)Q12oxMBmbmA)i1kj)OHxzcuvDZZDGjC14tq7bcfjFlemgs47GTbjdsgNWvRpFS0SPB(5Mv(7Y)DLLRkdWt(xBHzL)hku74)PgMMGIc7RtrHTO8VCfff3rnC4V)8kmVlay1Iek(MzrREYra2IV4spfLMdz9GFtaWlITsWZxKIgFRnuslBaqJAN(rZ5RTGKR3piWpHVpHJ8VAtiSGpMDeOjriddxMMSo5zihiYABXA8utl1oceUgcV1skIVBx96UeYMgFpHG3so9ABrYYW7Lo4TwefgLpzSR1zuHDXdaFmPz5d5u7awZsCbI3ZYLJEVUcoObMc3156emGpGtWD98TcEjSIAfxRFwIUonjLFPJXw4(bSAsIwF34BSPRpwJ3vF7VEp7Uj0hq6vbF6df63ZqJP0547NXRRuXA5)unTyBCmivcxIqIQEnXXQAKBQ(Iy0XaByaOFWvFbOKnmEcTE65P0O1FyqbPYHFfe6fEooNxENnMMa6Db54DfnElvw)BuxyI)eelN97U258IFdgbeJhxXtTPRtoOnkF34IR73ZhXP(wVetL2B94SgW0nL)nn9IQXzF3yPdSmMZZRnU0TIM2R3u(q1fVPqVT6M9myDa1ypkBLfl4bz3hOB3uAgEhy9jvBdgYzTvd2UX2sPa9UsUHhMkAl8z3ojM50Bh87K8a87vBwH6av056yBPrKY7TGtzu4dclZPXGSK4elv0G7UDpMMaupcUNi(ZtY5g2DEqat)ovZ630kv6fkvkw72jxSu8R0vHZSFLu)AgKGE1mTkjMzePYbNO7W8G1F8vHKV2wWOkb)VqktH(IJkvmEOuRJsnf1AcWElEROQpF0NiJcl5X8mXblxISWxS0f0d(ATVQHboaJHozKtLfLWxmAq5N08ZlTkeOccyarXjPZTrrVoJYsLa5m5kDsbzne5FSp7p6JPiWIiLEoR4hw621ThvX(yTicsznvqDHF7YGOhOwt)V3)sA0I)pAje((K1VnNAGTL9z)IMTbO1pVOMaXBZYBAeUyB6liZbRtEaAPKNXfUCZBd5IqnvFjjJUOguyxmzSNuliCNhYTTKR6m(wEouE0gkMvNDvjIX2yqeZxeKtSgSr1xJVD74EeNwN2qf4wesEcptqx)DlYxmdXz5FJ23TBGSp3Sq4Jv(IeuZ5WPMFyrVB8GBF3vNxQXZ)vY)IBk)zPFD2PQ)QOvu5VevQsLKkdTfODoU67ddabDSVyYf3nwWjM40WjvRRRqz4dfxg4tCTuC5KlNfQenSYJc)iErK3Be6l4TJ(xGpmchndu1ICNSpqa7AFz8BF0y9V1eY9KGk9l8(YchMNWcMIZdu5ya3pAdFysv5(vyJP0nfgBjNFoFwv4hIymGaCUXK8HuEcnpLbhyCxN1iqGR2ewvhL0KWpUiaZfww5syRjzlU2tzThOPdpqlA)nEo2VBGsh00NBBJRAynOZLw8CuvZOdjQkaCDhJJuV8wIfrSKtvkOeJVLSIadAU)SyWGozfNt05a(ScX1SnOgOLk2px0KvnufgcHKFTSMxG1reso0QOIXEufep3VBRivrKUBunnAq4k09gRt3ZstsRtUsGrXx4xzj(uAufKL5ts3s)CjX4zc)eBEZO5eQnPYdYwQvzgD1NV9KX30rI73uv5dzvT7UYKvkOoWpkjCBolXVQ1b2SDtumQjb)Xpbezq2VguLsBHtZXUcCB(VHU)b3UxCBi37e6wBqzETIitETA3ebEb(8Kbb)KNSblfqgIUPjbPFMqGdY93QG1bGa8Ah4VK6VsLVnj4bIQYCsd)E7T0OZfbyyMNd9VGqZQ(kUnpcwcFDo8w(pLenpmjLqjJHBcZNm(Ah1(3a2aml4TksPzhmbsxxrok39wBuQdlTuLAnI4v6)CTsGATjR2XUWhJp32zviYvkgBqj3PqhghQzL5zIOa2SD90skVhzmDwcewTp4B96fZKwmafHKfm)f5Zo)EXsbj37XhZ8vslijF6jtUYswA1D42UQ(Bhuk(EoQZXFKTDHqwKlHfh2mAEu308TFXipp1KhOVlT8kgs2EDt2UEFXOBxKUpk6Z1a67MVy0NZrtFGF3UPWJZyvjkAggAMHLueSDDTTKX)TfCvsDEoU5QWdKgtH4A(15x2iMfP5GHzv2m07QejLfPUDtKSr458ubTw5VRzJ5OSnSewmqEA13nEKLHn)v7o3QSN3OuOrngMgyGv9sB1eUB8vAnPUYwz7iuzt7yD2a5Dbek1vwTC7tapY7eWJ4sItHUG2M0s(RiTJUPbVOSh(K9e2jZWsGgLcAWEQ1R7PeWEnbS6g1VlcvXH7WiRe3QKsQlRSMsf7ETWokvHqZPToLmSaCeM9X29I0HOTQfV6uds88XCO4ayX0CQh5CXGroVZ1RCzV2NOn7ZBXKVWZ5C(CwXspEETFIQFRwu91o2NR(S7HEzAGzEGlEffZTXiVXPPNarUL2((hZDsYJRkEHRJ0MMV8GyO9ymP9OqWpXTpeXkM46djJDr6MIZOqwdY1KepMu0cUxKn0YOfytzZm6PvtqXtCT6yjHVs7scFLoTD8ZVEzxy7kS5m9WDNMtxK1GdXWrz1SvK6wZcqHRflgwsIqZ)2XgBQy7NDPHKQ2TTe9ASimCuPWw8Y97LcnBveOSEjx2bqr8uROZutcHWTclVTI0d6XeXWunudZtQgMbR7P5438VbAyUn1WC)8OH525rCsNpvDAyEcEYntddIK4BXuc2p9(CAobS7O4)2F97((6tbZW9t)H5ewpUKVephlGYq889tNrWdstzlHTFkMcxXxhbGBHNAWI7pz2BH)tw0QnyXMMgGTjtgbBrh6PLzjeSkEmAOxZYrHeKg3pDE0ciStg0rW(9)Y9dBBxiSPd8bDHdaBUDx3RCPsvjIJQd2QLcnHQ3rXXBsmjLMsm5E3ApPE9Cs90PMyZ2SGFybEMMqXwYAs7J30(PGsYtrZXtdEakPwS49LJa7FPe4FNYETQja0nGFkca8Ase75DdTzaKAch1o3edvT1IPhuYdAxnTtETwbS(WNAgGtkbVJpk2JQrok9A5PSN(KIl8rKPjupRbCT1WeNHUTtjKZGqxmoQfsEYfsh7csDkK0AqSt3DnWRQqsryZQ1hnri5zMq6pSDoP2oYye9wo8hMhhT5HmgHrYbAYJZizqIGOijRDvrufPQuzpvIPLuyLaqnFVO9RuQoOvFve4Yt8NfhW)iJF1)NjbBs6o9ceg(lHW064CSvEaaCgEJ1zvBHnhxMVoZcDB976ZvBKq3y)nv)SY7yPMVi)fvKIoS7uJMx42tikCzkvEhrCYjMQDWpsvZUpEK63U5gD0RTKqny5dH)HC4)9W)p]] )