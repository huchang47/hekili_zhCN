-- EvokerAugmentation.lua
-- October 2023

if UnitClassBase( "player" ) ~= "EVOKER" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 1473 )

local strformat = string.format

-- Resources
spec:RegisterResource( Enum.PowerType.Mana )
spec:RegisterResource( Enum.PowerType.Essence )

-- Talents
spec:RegisterTalents( {
    -- Evoker
    aerial_mastery                  = { 93352, 365933, 1 }, -- Hover gains 1 additional charge.
    ancient_flame                   = { 93271, 369990, 1 }, -- Casting Emerald Blossom or Verdant Embrace reduces the cast time of your next Living Flame by 40%.
    attuned_to_the_dream            = { 93292, 376930, 2 }, -- Your healing done and healing received are increased by 2%.
    blast_furnace                   = { 93309, 375510, 1 }, -- Fire Breath's damage over time lasts 4 sec longer.
    bountiful_bloom                 = { 93291, 370886, 1 }, -- Emerald Blossom heals 2 additional allies.
    cauterizing_flame               = { 93294, 374251, 1 }, -- Cauterize an ally's wounds, removing all Bleed, Poison, Curse, and Disease effects. Heals for 171,321 upon removing any effect.
    clobbering_sweep                = { 93296, 375443, 1 }, -- Tail Swipe's cooldown is reduced by 45 sec.
    draconic_legacy                 = { 93300, 376166, 1 }, -- Your Stamina is increased by 6%.
    enkindled                       = { 93295, 375554, 2 }, -- Living Flame deals 3% more damage and healing.
    expunge                         = { 93306, 365585, 1 }, -- Expunge toxins affecting an ally, removing all Poison effects.
    extended_flight                 = { 93349, 375517, 2 }, -- Hover lasts 4 sec longer.
    exuberance                      = { 93299, 375542, 1 }, -- While above 75% health, your movement speed is increased by 10%.
    fire_within                     = { 93345, 375577, 1 }, -- Renewing Blaze's cooldown is reduced by 30 sec.
    foci_of_life                    = { 93345, 375574, 1 }, -- Renewing Blaze restores you more quickly, causing damage you take to be healed back over 4 sec.
    forger_of_mountains             = { 93270, 375528, 1 }, -- Landslide's cooldown is reduced by 30 sec, and it can withstand 200% more damage before breaking.
    heavy_wingbeats                 = { 93296, 368838, 1 }, -- Wing Buffet's cooldown is reduced by 45 sec.
    inherent_resistance             = { 93355, 375544, 2 }, -- Magic damage taken reduced by 2%.
    innate_magic                    = { 93302, 375520, 2 }, -- Essence regenerates 5% faster.
    instinctive_arcana              = { 93310, 376164, 2 }, -- Your Magic damage done is increased by 2%.
    landslide                       = { 93305, 358385, 1 }, -- Conjure a path of shifting stone towards the target location, rooting enemies for 15 sec. Damage may cancel the effect.
    leaping_flames                  = { 93343, 369939, 1 }, -- Fire Breath causes your next Living Flame to strike 1 additional target per empower level.
    lush_growth                     = { 93347, 375561, 2 }, -- Green spells restore 5% more health.
    natural_convergence             = { 93312, 369913, 1 }, -- Disintegrate channels 20% faster and Eruption's cast time is reduced by 20%.
    obsidian_bulwark                = { 93289, 375406, 1 }, -- Obsidian Scales has an additional charge.
    obsidian_scales                 = { 93304, 363916, 1 }, -- Reinforce your scales, reducing damage taken by 30%. Lasts 12.5 sec.
    oppressing_roar                 = { 93298, 372048, 1 }, -- Let out a bone-shaking roar at enemies in a cone in front of you, increasing the duration of crowd controls that affect them by 50% in the next 10 sec.
    overawe                         = { 93297, 374346, 1 }, -- Oppressing Roar removes 1 Enrage effect from each enemy, and its cooldown is reduced by 30 sec.
    panacea                         = { 93348, 387761, 1 }, -- Emerald Blossom and Verdant Embrace instantly heal you for 76,482 when cast.
    permeating_chill                = { 93303, 370897, 1 }, -- Your damaging Blue spells reduce the target's movement speed by 50% for 3 sec.
    potent_mana                     = { 93715, 418101, 1 }, -- Source of Magic increases the target's healing and damage done by 3%.
    protracted_talons               = { 93307, 369909, 1 }, -- Azure Strike damages 1 additional enemy.
    quell                           = { 93311, 351338, 1 }, -- Interrupt an enemy's spellcasting and prevent any spell from that school of magic from being cast for 4 sec.
    recall                          = { 93301, 371806, 1 }, -- You may reactivate Breath of Eons within 3 sec after landing to travel back in time to your takeoff location.
    regenerative_magic              = { 93353, 387787, 1 }, -- Your Leech is increased by 2%.
    renewing_blaze                  = { 93354, 374348, 1 }, -- The flames of life surround you for 8.4 sec. While this effect is active, 100% of damage you take is healed back over 4 sec.
    rescue                          = { 93288, 370665, 1 }, -- Swoop to an ally and fly with them to the target location.
    scarlet_adaptation              = { 93340, 372469, 1 }, -- Store 20% of your effective healing, up to 105,971. Your next damaging Living Flame consumes all stored healing to increase its damage dealt.
    sleep_walk                      = { 93293, 360806, 1 }, -- Disorient an enemy for 20 sec, causing them to sleep walk towards you. Damage has a chance to awaken them.
    source_of_magic                 = { 93344, 369459, 1 }, -- Redirect your excess magic to a friendly healer for 1.0 |4hour:hrs;. When you cast an empowered spell, you restore 0.25% of their maximum mana per empower level. Limit 1.
    spatial_paradox                 = { 93351, 406732, 1 }, -- Evoke a paradox for you and a friendly healer, allowing casting while moving and increasing the range of most spells by 100% for 10.5 sec. Affects the nearest healer within 60 yds, if you do not have a healer targeted.
    tailwind                        = { 93290, 375556, 1 }, -- Hover increases your movement speed by 70% for the first 4 sec.
    terror_of_the_skies             = { 93342, 371032, 1 }, -- Breath of Eons stuns enemies for 3 sec.
    time_spiral                     = { 93351, 374968, 1 }, -- Bend time, allowing you and your allies within 40 yds to cast their major movement ability once in the next 10.5 sec, even if it is on cooldown.
    tip_the_scales                  = { 93350, 370553, 1 }, -- Compress time to make your next empowered spell cast instantly at its maximum empower level.
    twin_guardian                   = { 93287, 370888, 1 }, -- Rescue protects you and your ally from harm, absorbing damage equal to 30% of your maximum health for 5.2 sec.
    unravel                         = { 93308, 368432, 1 }, -- Sunder an enemy's protective magic, dealing 254,536 Spellfrost damage to absorb shields.
    verdant_embrace                 = { 93341, 360995, 1 }, -- Fly to an ally and heal them for 255,758, or heal yourself for the same amount.
    walloping_blow                  = { 93286, 387341, 1 }, -- Wing Buffet and Tail Swipe knock enemies further and daze them, reducing movement speed by 70% for 4 sec. 
    zephyr                          = { 93346, 374227, 1 }, -- Conjure an updraft to lift you and your 4 nearest allies within 20 yds into the air, reducing damage taken from area-of-effect attacks by 20% and increasing movement speed by 30% for 8.4 sec.

    -- Augmentation
    accretion                       = { 93229, 407876, 1 }, -- Eruption reduces the remaining cooldown of Upheaval by 1.0 sec.
    anachronism                     = { 93223, 407869, 1 }, -- Prescience has a 35% chance to grant Essence Burst.
    arcane_reach                    = { 93225, 454983, 1 }, -- The range of your helpful magics is increased by 5 yards.
    aspects_favor                   = { 93217, 407243, 2 }, -- Obsidian Scales activates Black Attunement, and amplifies it to increase maximum health by 7.0% for 12.5 sec. Hover activates Bronze Attunement, and amplifies it to increase movement speed by 25% for 4.2 sec.
    bestow_weyrnstone               = { 93195, 408233, 1 }, -- Conjure a pair of Weyrnstones, one for your target ally and one for yourself. Only one ally may bear your Weyrnstone at a time. A Weyrnstone can be activated by the bearer to transport them to the other Weyrnstone's location, if they are within 100 yds.
    blistering_scales               = { 93209, 360827, 1 }, -- Protect an ally with 15 explosive dragonscales, increasing their Armor by 30% of your own. Melee attacks against the target cause 1 scale to explode, dealing 15,272 Volcanic damage to enemies near them. This damage can only occur every few sec. Blistering Scales can only be placed on one target at a time. Casts on your enemy's target if they have one.
    breath_of_eons                  = { 93234, 403631, 1 }, -- Fly to the targeted location, exposing Temporal Wounds on enemies in your path for 10.5 sec. Temporal Wounds accumulate 11% of damage dealt by your allies affected by Ebon Might, then critically strike for that amount as Arcane damage. Applies Ebon Might for 5 sec. Removes all root effects. You are immune to movement impairing and loss of control effects while flying.
    chrono_ward                     = { 93235, 409676, 1 }, -- When allies deal damage with Temporal Wounds, they gain a shield for 100% of the damage dealt. Absorption cannot exceed 30% of your maximum health.
    defy_fate                       = { 93222, 404195, 1 }, -- Fatal attacks are diverted into a nearby timeline, preventing the damage, and your death, in this one. The release of temporal energy restores 649,174 health to you, and 216,391 to 4 nearby allies, over 9 sec. Healing starts high and declines over the duration. May only occur once every 6 min.
    draconic_attunements            = { 93218, 403208, 1 }, -- Learn to attune yourself to the essence of the Black or Bronze Dragonflights: Black Attunement: You and your 4 nearest allies have 4% increased maximum health. Bronze Attunement:You and your 4 nearest allies have 10% increased movement speed.
    dream_of_spring                 = { 93359, 414969, 1 }, -- Emerald Blossom no longer has a cooldown, deals 35% increased healing, and increases the duration of your active Ebon Might effects by 1 sec, but costs 3 Essence.
    ebon_might                      = { 93198, 395152, 1 }, -- Increase your 4 nearest allies' primary stat by 6.5% of your own, and cause you to deal 22% more damage, for 10.5 sec. May only affect 4 allies at once, and prefers to imbue damage dealers. Eruption, Breath of Eons, and your empower spells extend the duration of these effects.
    echoing_strike                  = { 93221, 410784, 1 }, -- Azure Strike deals 15% increased damage and has a 10% chance per target hit to echo, casting again.
    eruption                        = { 93200, 395160, 1 }, -- Cause a violent eruption beneath an enemy's feet, dealing 142,540 Volcanic damage split between them and nearby enemies. Increases the duration of your active Ebon Might effects by 1 sec.
    essence_attunement              = { 93219, 375722, 1 }, -- Essence Burst stacks 2 times.
    essence_burst                   = { 93220, 396187, 1 }, -- Your Living Flame has a 20% chance, and your Azure Strike has a 15% chance, to make your next Eruption cost no Essence. Stacks 2 times.
    fate_mirror                     = { 93367, 412774, 1 }, -- Prescience grants the ally a chance for their spells and abilities to echo their damage or healing, dealing 15% of the amount again.
    font_of_magic                   = { 93231, 408083, 1 }, -- Your empower spells' maximum level is increased by 1, and they reach maximum empower level 20% faster.
    hoarded_power                   = { 93212, 375796, 1 }, -- Essence Burst has a 20% chance to not be consumed.
    ignition_rush                   = { 93230, 408775, 1 }, -- Essence Burst reduces the cast time of Eruption by 40%.
    imminent_destruction            = { 102248, 459537, 1 }, -- Breath of Eons reduces the Essence cost of Eruption by 1 and increases its damage by 10% for 12 sec after you land.
    imposing_presence               = { 93199, 371016, 1 }, -- Quell's cooldown is reduced by 20 sec.
    infernos_blessing               = { 93197, 410261, 1 }, -- Fire Breath grants the inferno's blessing for 8.4 sec to you and your allies affected by Ebon Might, giving their damaging attacks and spells a high chance to deal an additional 44,798 Fire damage.
    inner_radiance                  = { 93199, 386405, 1 }, -- Your Living Flame and Emerald Blossom are 30% more effective on yourself.
    interwoven_threads              = { 93369, 412713, 1 }, -- The cooldowns of your spells are reduced by 10%.
    molten_blood                    = { 93211, 410643, 1 }, -- When cast, Blistering Scales grants the target a shield that absorbs up to 440,543 damage for 31.4 sec based on their missing health. Lower health targets gain a larger shield.
    molten_embers                   = { 102249, 459725, 1 }, -- Fire Breath causes enemies to take 20% increased damage from your Black spells.
    momentum_shift                  = { 93207, 408004, 1 }, -- Consuming Essence Burst grants you 5% Intellect for 6.3 sec. Stacks up to 2 times.
    motes_of_possibility            = { 93227, 409267, 1 }, -- Eruption has a 15% chance to form a mote of diverted essence near you. Allies who comes in contact with the mote gain a random buff from your arsenal.
    overlord                        = { 93213, 410260, 1 }, -- Breath of Eons casts an Eruption at the first 3 enemies struck. These Eruptions have a 100% chance to create a Mote of Possibility.
    perilous_fate                   = { 93235, 410253, 1 }, -- Breath of Eons reduces enemies' movement speed by 70%, and reduces their attack speed by 50%, for 10.5 sec.
    plot_the_future                 = { 93226, 407866, 1 }, -- Breath of Eons grants you Fury of the Aspects for 15 sec after you land, without causing Exhaustion.
    power_nexus                     = { 93201, 369908, 1 }, -- Increases your maximum Essence to 6.
    prescience                      = { 93358, 409311, 1 }, -- Grant an ally the gift of foresight, increasing their critical strike chance by 3% and occasionally copying their damage and healing spells at 15% power for 18.8 sec. Affects the nearest ally within 25 yds, preferring damage dealers, if you do not have an ally targeted.
    prolong_life                    = { 93359, 410687, 1 }, -- Your effects that extend Ebon Might also extend Symbiotic Bloom.
    pupil_of_alexstrasza            = { 93221, 407814, 1 }, -- When cast at an enemy, Living Flame strikes 1 additional enemy for 100% damage.
    reactive_hide                   = { 93210, 409329, 1 }, -- Each time Blistering Scales explodes it deals 15% more damage for 12.5 sec, stacking 10 times.
    regenerative_chitin             = { 93211, 406907, 1 }, -- Blistering Scales has 5 more scales, and casting Eruption restores 1 scale.
    ricocheting_pyroclast           = { 93208, 406659, 1 }, -- Eruption deals 30% more damage per enemy struck, up to 150%.
    rumbling_earth                  = { 93205, 459120, 1 }, -- Upheaval causes an aftershock at its location, dealing 50% of its damage 2 additional times.
    seismic_slam                    = { 93368, 408543, 1 }, -- Landslide causes enemies who are mid-air to be slammed to the ground, stunning them for 4 sec.
    stretch_time                    = { 93382, 410352, 1 }, -- While flying during Breath of Eons, 50% of damage you would take is instead dealt over 10 sec.
    symbiotic_bloom                 = { 93215, 410685, 2 }, -- Emerald Blossom increases targets' healing received by 3% for 10.5 sec.
    tectonic_locus                  = { 93202, 408002, 1 }, -- Upheaval deals 50% increased damage to the primary target, and launches them higher.
    time_skip                       = { 93232, 404977, 1 }, -- Surge forward in time, causing your cooldowns to recover 1,000% faster for 2 sec.
    timelessness                    = { 93360, 412710, 1 }, -- Enchant an ally to appear out of sync with the normal flow of time, reducing threat they generate by 30% for 31.4 min. Less effective on tank-specialized allies. May only be placed on one target at a time.
    tomorrow_today                  = { 93369, 412723, 1 }, -- Time Skip channels for 1 sec longer.
    unyielding_domain               = { 93202, 412733, 1 }, -- Upheaval cannot be interrupted, and has an additional 10% chance to critically strike.
    upheaval                        = { 93203, 396286, 1 }, -- Gather earthen power beneath your enemy's feet and send them hurtling upwards, dealing 218,901 Volcanic damage to the target and nearby enemies. Increases the duration of your active Ebon Might effects by 2 sec. Empowering expands the area of effect. I: 3 yd radius. II: 6 yd radius. III: 9 yd radius.
    volcanism                       = { 93206, 406904, 1 }, -- Eruption's Essence cost is reduced by 1.

    -- Chronowarden
    afterimage                      = { 94929, 431875, 1 }, -- Empower spells send up to 3 Chrono Flames to your targets.
    chrono_flame                    = { 94954, 431442, 1, "chronowarden" }, -- Living Flame is enhanced with Bronze magic, repeating 25% of the damage or healing you dealt to the target in the last 5 sec as Arcane, up to 122,373.
    doubletime                      = { 94932, 431874, 1 }, -- Ebon Might and Prescience gain a chance equal to your critical strike chance to grant 50% additional stats.
    golden_opportunity              = { 94942, 432004, 1 }, -- Prescience has a 20% chance to cause your next Prescience to last 100% longer.
    instability_matrix              = { 94930, 431484, 1 }, -- Each time you cast an empower spell, unstable time magic reduces its cooldown by up to 6 sec.
    master_of_destiny               = { 94930, 431840, 1 }, -- Casting Essence spells extends all your active Threads of Fate by 1 sec.
    motes_of_acceleration           = { 94935, 432008, 1 }, -- Warp leaves a trail of Motes of Acceleration. Allies who come in contact with a mote gain 20% increased movement speed for 30 sec.
    primacy                         = { 94951, 431657, 1 }, -- For each damage over time effect from Upheaval, gain 3% haste, up to 9%.
    reverberations                  = { 94925, 431615, 1 }, -- Upheaval deals 50% additional damage over 8 sec.
    temporal_burst                  = { 94955, 431695, 1 }, -- Tip the Scales overloads you with temporal energy, increasing your haste, movement speed, and cooldown recovery rate by 30%, decreasing over 30 sec.
    temporality                     = { 94935, 431873, 1 }, -- Warp reduces damage taken by 20%, starting high and reducing over 3 sec.
    threads_of_fate                 = { 94947, 431715, 1 }, -- Casting an empower spell during Temporal Burst causes a nearby ally to gain a Thread of Fate for 10 sec, granting them a chance to echo their damage or healing spells, dealing 15% of the amount again.
    time_convergence                = { 94932, 431984, 1 }, -- Non-defensive abilities with a 45 second or longer cooldown grant 5% Intellect for 15 sec. Essence spells extend the duration by 1 sec.
    warp                            = { 94948, 429483, 1 }, -- Hover now causes you to briefly warp out of existence and appear at your destination. Hover's cooldown is also reduced by 5 sec. Hover continues to allow Evoker spells to be cast while moving.

    -- Scalecommander
    bombardments                    = { 94936, 434300, 1 }, -- Mass Eruption marks your primary target for destruction for the next 10 sec. You and your allies have a chance to trigger a Bombardment when attacking marked targets, dealing 66,179 Volcanic damage split amongst all nearby enemies.
    diverted_power                  = { 94928, 441219, 1 }, -- Bombardments have a chance to generate Essence Burst.
    extended_battle                 = { 94928, 441212, 1 }, -- Essence abilities extend Bombardments by 1 sec.
    hardened_scales                 = { 94933, 441180, 1 }, -- Obsidian Scales reduces damage taken by an additional 5%.
    maneuverability                 = { 94941, 433871, 1 }, -- Breath of Eons can now be steered in your desired direction. In addition, Breath of Eons burns targets for 278,625 Volcanic damage over 12 sec.
    mass_eruption                   = { 98931, 438587, 1, "scalecommander" }, -- Empower spells cause your next Eruption to strike up to 3 targets. When striking less than 3 targets, Eruption damage is increased by 25% for each missing target.
    melt_armor                      = { 94921, 441176, 1 }, -- Breath of Eons causes enemies to take 20% increased damage from Bombardments and Essence abilities for 12 sec.
    menacing_presence               = { 94933, 441181, 1 }, -- Knocking enemies up or backwards reduces their damage done to you by 15% for 8 sec.
    might_of_the_black_dragonflight = { 94952, 441705, 1 }, -- Black spells deal 20% increased damage.
    nimble_flyer                    = { 94943, 441253, 1 }, -- While Hovering, damage taken from area of effect attacks is reduced by 10%.
    onslaught                       = { 94944, 441245, 1 }, -- Entering combat grants a charge of Burnout, causing your next Living Flame to cast instantly.
    slipstream                      = { 94943, 441257, 1 }, -- Deep Breath resets the cooldown of Hover.
    unrelenting_siege               = { 94934, 441246, 1 }, -- For each second you are in combat, Azure Strike, Living Flame, and Eruption deal 1% increased damage, up to 15%.
    wingleader                      = { 94953, 441206, 1 }, -- Bombardments reduce the cooldown of Breath of Eons by 1 sec for each target struck, up to 3 sec.
} )


-- PvP Talents
spec:RegisterPvpTalents( { 
    born_in_flame        = 5612, -- (414937) Casting Ebon Might grants 2 charges of Burnout, reducing the cast time of Living Flame by 100%.
    chrono_loop          = 5564, -- (383005) Trap the enemy in a time loop for 5 sec. Afterwards, they are returned to their previous location and health. Cannot reduce an enemy's health below 20%.
    divide_and_conquer   = 5557, -- (384689) Breath of Eons forms curtains of fire, preventing line of sight to enemies outside its walls and burning enemies who walk through them for 366,531 Fire damage. Lasts 6 sec.
    dream_catcher        = 5613, -- (410962) Sleep Walk no longer has a cooldown, but its cast time is increased by 0.2 sec.
    dream_projection     = 5559, -- (377509) Summon a flying projection of yourself that heals allies you pass through for 73,423. Detonating your projection dispels all nearby allies of Magical effects, and heals for 363,446 over 20 sec.
    dreamwalkers_embrace = 5615, -- (415651) Verdant Embrace tethers you to an ally, increasing movement speed by 40% and slowing and siphoning 63,634 life from enemies who come in contact with the tether. The tether lasts up to 10 sec or until you move more than 30 yards away from your ally.
    nullifying_shroud    = 5558, -- (378464) Wreathe yourself in arcane energy, preventing the next 3 full loss of control effects against you. Lasts 30 sec.
    obsidian_mettle      = 5563, -- (378444) While Obsidian Scales is active you gain immunity to interrupt, silence, and pushback effects.
    scouring_flame       = 5561, -- (378438) Fire Breath burns away 1 beneficial Magic effect per empower level from all targets.
    swoop_up             = 5562, -- (370388) Grab an enemy and fly with them to the target location.
    time_stop            = 5619, -- (378441) Freeze an ally's timestream for 5 sec. While frozen in time they are invulnerable, cannot act, and auras do not progress. You may reactivate Time Stop to end this effect early.
    unburdened_flight    = 5560, -- (378437) Hover makes you immune to movement speed reduction effects.
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
        max_stack = function() return 1 + ( talent.essence_attunement.enabled and 1 or 0 ) end,
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
        max_stack = 1,
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

    if color then
        if color == "red" and buff.iridescence_red.up then removeStack( "iridescence_red" )
        elseif color == "blue" and buff.iridescence_blue.up then removeStack( "iridescence_blue" ) end
    end

    if talent.power_swell.enabled and ability.empowered then
        applyBuff( "power_swell" ) -- TODO: Modify Essence regen rate.
    end

    empowerment.active = false
end )


spec:RegisterGear( "tier29", 200381, 200383, 200378, 200380, 200382 )
spec:RegisterGear( "tier30", 202491, 202489, 202488, 202487, 202486 )
spec:RegisterGear( "tier31", 207225, 207226, 207227, 207228, 207230, 217178, 217180, 217176, 217177, 217179 )
spec:RegisterAuras( {
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
} )


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
end )


spec:RegisterStateTable( "evoker", setmetatable( {}, {
    __index = setfenv( function( t, k )
        if k == "prescience_buffs" then return active_dot.prescience end
        if k == "allied_cds_up" then
            if buff.sense_power.up and group then return active_dot.sense_power_active end
            return 1 -- If Sense Power isn't used, always assume there's a CD active.
        end
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
        local power_level = args.empower_to or max_empower

        if settings.fire_breath_fixed > 0 then
            power_level = min( settings.fire_breath_fixed, max_empower )
        end

        return stages[ power_level ] * ( talent.font_of_magic.enabled and 0.8 or 1 ) * haste
    end, state )
end

-- Abilities
spec:RegisterAbilities( {
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
        cooldown = 30.0,
        recharge = function() return talent.regenerative_chitin.enabled and 30 or nil end,
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
        cooldown = 120.0,
        gcd = "spell",

        talent = "breath_of_eons",
        startsCombat = false,
        toggle = "cooldowns",

        start = function()
            applyBuff( "breath_of_eons" )
            if buff.ebon_might.up then buff.ebon_might.expires = buff.ebon_might.expires + 5
            else applyBuff( "ebon_might", 5 ) end
        end,

        finish = function()
            removeBuff( "breath_of_eons" )
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
        cooldown = 30.0,
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
        cast = function() return 2.5 * ( talent.ignition_rush.enabled and buff.essence_burst.up and 0.6 or 1 ) * ( talent.natural_convergence.enabled and 0.8 or 1 ) end,
        cooldown = 0.0,
        gcd = "spell",

        spend = function()
            if buff.essence_burst.up then return 0 end
            return 3 - ( talent.volcanism.enabled and 1 or 0 )
        end,
        spendType = "essence",

        talent = "eruption",
        startsCombat = true,

        handler = function()
            removeBuff( "essence_burst" )
            removeBuff( "trembling_earth" )
            removeBuff( "mass_eruption_stacks" )

            if buff.ebon_might.up then
                buff.ebon_might.expires = buff.ebon_might.expires + 1 + ( set_bonus.tier31_4pc > 0 and ( active_dot.prescience * 0.2 ) or 0 )
            end


            if talent.regenerative_chitin.enabled and buff.blistering_scales.up then addStack( "blistering_scales" ) end
        end
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
        cooldown = 12,
        charges = 2,
        recharge = 12,
        gcd = "spell",

        talent = "prescience",
        startsCombat = false,

        handler = function()
            applyBuff( "prescience_applied" )
            if solo then applyBuff( "prescience" ) end
            active_dot.prescience = min( group_members, active_dot.prescience + 1 )

            if set_bonus.tier31_4pc > 0 then addStack( "trembling_earth" ) end
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
        cooldown = 120.0,
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

    -- Gather earthen power beneath your enemy's feet and send them hurtling upwards, dealing $396288s2 Volcanic damage to the target and nearby enemies.$?s395153[; Increases the duration of your active Ebon Might effects by ${$395153s2/1000} sec.][]; Empowering expands the area of effect.; I:   $<radiusI> yd radius.; II:  $<radiusII> yd radius.; III: $<radiusIII> yd radius.
    upheaval = {
        id = function() return talent.font_of_magic.enabled and 408092 or 396286 end,
        color = "black",
        cast = empowered_cast_time,
        empowered = true,
        cooldown = 40.0,
        gcd = "spell",

        talent = "upheaval",
        startsCombat = true,

        handler = function()
            if buff.ebon_might.up then buff.ebon_might.expires = buff.ebon_might.expires + 2 end
            if talent.mass_disintegrate.enabled then addStack( "mass_disintegrate_stacks" ) end
            if talent.mass_eruption.enabled then applyBuff( "mass_eruption_stacks" ) end -- ???
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
    desc = strformat( "如果勾选，则在您处于队伍中时，且您的所有盟友都没有使用您的光环时，可能会建议您使用 %s。\n\n"
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
    name = strformat( "%s: 授权", Hekili:GetSpellLinkWithTexture( devastation.abilities.fire_breath.id ) ),
    type = "range",
    desc = strformat( "如果设置为 |cffffd1000|r，%s 将根据行动优先级列表推荐不同的授权级别。\n\n"
        .. "如需要强制使用特定级别的 %s，请将其设置为 1、2、3 或 4。\n\n"
        .. "如果所选授权级别超过了您的最大值，则将使用最大值。", Hekili:GetSpellLinkWithTexture( devastation.abilities.fire_breath.id ),
        devastation.abilities.fire_breath.name ),
    min = 0,
    max = 4,
    step = 1,
    width = "full"
} )

spec:RegisterSetting( "use_early_chain", false, {
    name = strformat( "%s: 链接通道", Hekili:GetSpellLinkWithTexture( 356995 ) ),
    type = "toggle",
    desc = strformat( "如果勾选，则 %s 可能会在已经导入的情况下被推荐，从而延长导入时间。",
        Hekili:GetSpellLinkWithTexture( 356995 ) ),
    width = "full"
} )

spec:RegisterSetting( "use_clipping", false, {
    name = strformat( "%s: 中断通道", Hekili:GetSpellLinkWithTexture( 356995 ) ),
    type = "toggle",
    desc = strformat( "如果选中，在 %s 期间可能会推荐其他技能，从而中断通道。", Hekili:GetSpellLinkWithTexture( 356995 ) ),
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


spec:RegisterPack( "增辉Simc", 20240922, [[Hekili:L3ZAZnoUr(BXvQvJ4yBnI02ZJnJCQKDR7UzQ72Klo7LVzkkrQXSgkrfsk71BPs)2VUbjbbardcQhZJ72QYKzeb7Ur3n6xOjW9U3)pU)UWGIO7)fVXExp(DEEJCV6MXJV((7kEED093Toy(Nd(e8xwfSe(Z)8MpTmAvrqrC6k8HpNKgeIajpDt2CyapuuSo)hF1RE6PNgfp)5lFmkEv(O5PlF1tPp9QaHx)YOht)Cu2LRFm6YW15xMLw97ZtttctFAv(LbZItIlIJYV)UzBItk(WQ7NPHEV(Dx)wGcwhn)(FX963CfqfXHHrLdokF(93Hd(YXV7spVFC30FnpA30)T4m4p)lzrbfpSB6Yu4F9XDFKpoxyC)9OhJZbckF30fPz7MMNMKUB6J5J2n9tzPBw)h3nDZAKyGNNLUC307Ix(tIqX9gak)3BIssGHgTkFdIYFD9drbpgKSB68G8IC8)B1UPbjpf8mIO4vX5p0aK3CP3BUy3uayJFhs6gWhm0RGH8pEaE()maO3)zCXdXGukjgWdkJIlIwI)LFHj2Jwfmljk8()Y93fmVuEU65LBIY93Skl4XOK4vFYpFD8QWeqUopdE7S4a4VvjEgnJX88tx4hbmPrzrldIrM17NSB6v7Moy30H7MwKfV6ZrfJkChfNpIebSH)yaGaGMgv9s(RZItb8(8UPaiD3nD7wba6DOa0B3uNsyc0jFwTaum8lNAYtPRlhlFGBQeKTgLdd3DYMUfMsJzd9mgfegnBZIfJaz060SGe)Ns3SkeWsjAxNf9O)NMhoYvbG147OYR9o28Aq45uBdHwlRawwROAw(kbZIYYcwvaJewnbRgrls1AT6EiaPRiuYla238hIGvW5(fW7LVmUauT7TkU74AQJcIarCnbrKV(5LWY)OSC)NIMjIBMsGWJZIa1HIr5fGH4AwzPodfvIQmLJqfwaQQFAr8sqU9(sDWQ1ahUg4I4p9qHFdBcaV3yXLzZsZZzdwDKOsxfLu6xyuqssCuO)8qqvznB5YyQ38129MMq(vJ1VksM71AmEJ4sHWnzm)xmH04wlG4JJJwhDlY6aFUwIpx94ZPwwrQCuRtROGcQY3qUEIHtxrL4wgdC9r0LxJBnpFzWQnOxXYj8bQnIJOfo8KPbDYMQfhdLGVGhHw4Ed3BEjFLrYrZsx5VKPJLhLSGbv(senKv0VnpztyujWLPShcY9RPoluP0oVBziULUcs1(n6t3oP1sKQvpGErsAHGmh0lETz9cpJ6fEDOx49fqVWLqVW9RREHlTEHRj9cDl97wVWtN9O9vVWd1lEtN2lu0LUBtEeiTwGSqmgvb9g9Mm6Njf(acdwcz04tT8WQfzDA02SB83x6WHcvQM25kjOYLyaKJh5Y1o0WasHX7JPzWI(ctfklEDPu4dl2nnDvYZ4FgH)bKmdMxu1lJkZPpgdVcKBs5S5I6rGjyKc)zw5RXP6Dt)RWpfdaEvuC5Z7gAZsXvpsWbvEEBNgvuu46PYtFT7yLYJAuZuRefgWXs5XqCb7NYJNSYdisEhHibbO)dbRcRLjc)aTqrMyMusDld(TDtFjszVwrDLLZoxj9POG1GjDGQa0LUoAvuM)I4KeiMBnz3Mcb1Khv0qX1tw8VLSjsWTufScJscar6T)jbgZsiZ8LBw6loekTSQXGbGggvenVikSwiuweHUcw1Hrt(LHIjHrnPiT3ZVlb7DMqKAguDJiY1DNeoIi00LSLM4oueWyG)ntNOSnLQBAI2Tbw4OFmYhGZYy0GMGxJGKOvfJwVzDCcg2b8p)TCiHW8FpyunO4ilj(rm13fj4mQomkEkT)(gi2c4DJ)CKizWu4dJweSjPGRQx)s)lSstYJUuxPEavzCRmK(lL1hbw1Qzr5eoIYNQt8yer1GynywZhYP3pouuiuXQJxcllH)ciqbM1ggCAy11mQ7gZj9HCP0ta3pjkieu4QEbMcz3P(VB6BBIi7yaRsd0r55rRMdoyIweppUOu50vkzTQHaUUYYlWC1mKvgelA(8yC4ISny6xP(gMckQ8XWifwrn9xgTCg4ZPCkwU2S2JuZ4hvg3PJqy5l2KKaoQM)qqg6FSS8ck21VQeQC(staXYLwr5DkXH2qO5V2LTElNsyP91A8rY82CTAeYC92sXWqbGFEjle1ZQmxmcDswnJRIHURkn4inPkGNpJviSOGSIhQ9ZFo3IydJVoSLQjhaHByd0EbqvvaaTINNNaJdhDroAkXqUCNyTjXfeCYTPOs2nX(guZIRqjmQ1qGrGNJ5(fpamGha61svg9sm1SS6UiM1zk3r5dnyARBYvqZjT2JQAi9T8OIkrnmkXYAzJmsEr4Xu(0mzMdHM4x(p8XDvPCVvQ8uXGrs6NINRlA5UJfrSkLnOmBZksmkh5lGu3XeRFns4LBle(6sHtegfTUQ8gkrm4Qgbkp7S41aBdcCbWhUPDsHWxoO8rvELpFYRKh(fXlMuP0HS(ai4oqLCrqr0GHNrRSUDlk0V1DSJM4duaKK35Hglwu364vPf5Qg)uht65bGfVeMD8lq()K2Cbt7f1TtQmg9sVbKBfLWG2Uvl02S20B76nOIbUmnPiALFPvCt6tAS7GYf)8phVwXKsZVlkoAIMkEfaPNsFeWBL8t20tnPfKN7Z9blcQQbaqiljnlSNXKXd7shlqcwQzcWsNOkvgi04Na(XQpjY2Lw2TGvvDxQDiQwQOXS)Dvq3VivjLlffvWMsJ9UZXiD8A8)sAmv6TezzFVlqp7Ojt5chucsNQO50dQ9QjnV9zb)P6fU9mxobK2pNAl5yzvCt9dZcId9JEebrqiiwIRQYB9wXP(8wGXXYqEB0RLftmgOAuNsryo0IO6QIFVJISxsH3YN)AN8LpfHw79YSjYDzF0AMs0HL1XEuEuNXTnhup5iLwIZYZSyIshvhJ2a1(18YCW1QjCjPhPQfkXLo0kt82Q4iP1ObMZv616RumQxuCw7re9BXSE5HVQRtRs4ciEKGyuM(1g1z9AK8YBfGOZ45(wcIoOdhlJHS0zMhv8NF74mZsvadY4o0q4QaD6TbbeMZJWIa)YTxa8Oo)ZGa9)tQqH6jQLOxYIVPWFzsEYixz8RBvC4WJoHHz1uxA5SoeW3sCALVM5QxCYRTkC1si(KoFnaaGWse3uiINkxGpi1GyGgkT1jV9WKw6zrMOw7WMuN1qYnTsKMhcjn4xnGbD4h62YUDtO(5lJYcab(SeWaE6sg)wn7ijjDNlDJ(TO5BkQl6Zx9PATWIlmLQonNniSncE07jHqvpMHwszrwwLfy90IY8gsOcULvFDgMPQmSPkkWlLqbRMFZtxolOzJgeagw7(SOoREpxzxOy8U3tShwwap9BcNqD(3R9ZOp7XxNP0yAd161oG0nPXmgQTCs62QK9IIvvISuoPBd6uetQb93nVqEBZZ2m7z)NEikzTFo8NjvoVKgZtpeNVUCHr8Q5bzRcaBjXZRGE9MuLP0Vn6kRApOoplOoVEtDEIuNAq39G66Q1GBZev7pH2JGSJALkf2VWq6UPX5OX2LRtINdt4Wl2n9)QQvl(pck71CDYMY2XqxLv7XKVR2yUTmY4K3Z4KxNmSzw0QuT9yAWy6Za0cMWlszfpCw0ZPRc1Z64nYrtnE3p861h86PG3(31ccZxSD3WEjbDgYtLZ4Z)s)W2Xg02UIwPdBd90wi5EWH86GdP75FPFinhYZehYtGdr4)mEHzVrnm78Nxnx7EXOipQJ6wqCRP)Q(HQ2BFsthQaIf)OKCaPJhDdxo5QToH9K696M69iOETTwypPEc)12s91nk399ORo7X8tUFy7spRjDy5LZnqGQxHvOGozYVANH(P1HTjKdXszuUl(KRDk33ztJGdlnKmQ3uxQ2BBr3AvTFL0aSMUvTk2MU1y3KGUDBO7Yr4w3PdYuFCYJjSDawG3u(BoS5H74X7A66brLCxUkUN2I2APkorlH2hn9UAr1wtnSihk8aZZnIqgX5Muk5IaTNXkzyWoTkss)wVR29Y)C6MzjIDeki()BaFVi(3H)XhGuDG8yNx0UVMbyH7vYUPLrJEb7t7e7yf8xFcyeSQUXAX5vPzlXOszBPp8BP7M(Pnb4hAwe8uS0dLrYMb5jxmYSnpcp4eYkDr4ArsxQfBtiJRxRT6Swc3oAoIM06gDT2I7vcL95t4Zq166U6jDvFew4w1drAtgeWiRsicD2HApx2WBA9wlMPRWjA2NC5YCge(mDDFWVpRM6Ak1SfAkQs9iL2bAXYTFTU6XBQa8xZD9wwuHfPGmlDbKxdWC0U5M9PW8wvXCdf)TQJ4WGAoNrRVKdWzjy7bTydKK9CH2abmB8A5gJJxirz2BDXyzLGu7E7xvABQV6uszWv9vg8wHGp(EIf7DSyXuDmbjl2RVSyxVVh1HDfzWg5GuLgMKd62Bo4R)EKdo2woybVu5gnXpKCFDqeSmyvqD7wG)xtwjDStuszMiVFsIBazLlY97dvyN4g7OUf80ULpZWovnGJyz(HOBJQbaweYsGiOccdwxEQGq0ArM2To6DvBGEMJGB927Kf9gz9fBotpBgAfprVsNJf8di44qm8myPygS0HBfMh)MHVxLc2RJhKk8dTfaYpfKTciU87VJDGLeJFkjfvh0kVOCT1l2nnl6FTbw7fI9ooUdGbBksxgW(4HM)qWQpbEn29X)Zy8lyepXw(P0vaQyp(f6zgVOmqEINwZQGrn093C6c26w)OGatlXuXINESijWvaVwLklHBB9nfGtRqAjgok8(RorCfc4Ee5key4a5k7(OMfmsDcE)w3CZjw3wl9wLZy)O0R1tP6(gWuOutFMyQsncS00omkWUDFYC6H4Bo6q0LyjSsd0RaxI2RVfWjwjW7mhvWQ2pX2cW27XTQIa5MGBlkKAwxfORTbMTfW1TWRcmv7SxBbNuSZQ0PU4QBbyc129xOrT(9ik0iqXHl0ia8(k0OOZdwOryn)qSmqaY9DQFKb370do5UtubO67(rBb9bWl9gFIK7ua(iWgOa9HWgonXlQnsdExS9IEfRXP3bZP3A4RvXq1U1OT9P4yrA)F0mk7rbz)nPhxMgU5OFQaJ2gVQfUOgL9OW(5vNdxcPV1eZKCZ10ZmnnC7rQC3pPhtTgJ9GNO1P0Jh6blHWwgTfLC2Ze7C42J0oyI6hJ9G3wMyhdw21xlB(IInDDaMEzgXiLXvRIRio7ScxMgPmUA54HpVe7kbntgLh3hOYQAxC9wsta7wd6OJHdH6l1nF2eT3mKJm0pe6gEwEqbEgsBK2Lh2jalhYC4bK7yI6RhWrfYhcfJvg3ebx98JjCjj3wXXXnUyCbFRh3hO2XYrIbD0XWHq9ulj1oKJm0pe620srYHDcWYHmh0VSuZaoQq(qOyTlmB)8JjCjj3wPvXTJ0Qlh1ylr3yoTWNeYPqodSHGFYeRaWq16CdgAcb)Wp46nEYyNAIzpHsfqAO2wLXHl(6MpOFmY85Jn8jHC38zVwCiniOt(SDqPfFMkdB5wEMyvIWJL5U05TBeQTESDqDFLzNA4BdKxNLoFuWQN9dxNBc6uJZ2zGT4bvI83d4BDydDeyYradK2UTa2hqGjhm07nDVV(eo1W3giBN(i94SDgylE2p9(EKF8EQ33dmSh6pDQzArg4hm03d6g)Ee0aTQF2oO4PhkEwbLwE1pJmWhR8ul63BqByX)YI2U9mfUx9B5SDlnMmhuGWdLwg48YHJhDZ5eMPE5vupbEpIVsihNBhAoqqQLKQ0IljT42jTu(L)apX9CjQbf8xQOi48dUJh74WJ767y58R(gso)QV5KZVQso3SK3WM00ddhuqPFgX(QS3nKyThbJ1HBVJagiDFqd7EXZ6C42H1E4iFp5z9ad9MN1PIZjspRxyTZHxHv224Vinjjf7LaCF6ZcYXB9b8(teynHL(0zFLELDG8UP4N4f2H0f1JBvkRhayNH3nJomehCyqrWSG8OFC3hlp7GZIli6Fa2HJ7l6vVdqTHwDY0piz0xwr0)FBMsx2VU3Hxl2MCkWVVv24ed((a4QVlhtWTzi9LQ7bWTaSDlkTyZ6p2fi(ed((aykUT2H0xQUhaNdwlks8M1MuoypvIspgG0cGjMXGgOP84(sH9yzXjf4Dcw7R)Jv1z6WrJuUoQG3I6WPr3q9PhDqAbWmQUzUQ(wqH9yP7jf4Dcw7lZUvQBhoAmQUrNFBNmNUxOFCbUfG9O4C1cQUxbYCIbphW0PT1j3U7frhxGBby7wuAriVwq19kqMtm4hrKF4cCI1JKdjA9DPdsdobP5z98tW8W)Yc0dxPVKEf4Q9RSxfUNQpBjc4EW07P6l2HaUhm9s8z2CW0lbCpa6D3h)aBffcU3ixqhCzdEqeNUioHFAbLpI)nDC(Kxvxu5Y7sh(HHWfvFHPtCViD9e2HC0Up297R7u2LdaomhBdOKab74DAcVa4Art8IjNr(nECkW458NQshhdYq8S)DpzHvgKBobnRMvsEIu)uo2Uv6XKF9f9Ha8iiaTFljneG5p)JDF8puFmK19HIBFO26dlxDClYcEPW2K9DR8qIVIG(qJE6PrZfLtHZsrJM(sh6dnkCY5QJvQ7doOpG3Je8KFpd9b8vB7zlkxC7f2UDO8dK3CcrXUAVcO9zp20ySAF(d47Q9jyf4D0SHRnxc(9yQ7PDQ7rn11TxwIAt0tDVoM6Q9ER2Nqn192NPE5wQI2BzhUJvSa3lAoUbNmE0nxaAwHXimNqUD5cAgTIgUUzh7dL5DWuwR9R3qBy2hkR(yAuL28ePnxbk7q6XG9Qfd2NomWuJKquGcL92x36cHn4V9cdl73atTvcrL6uOmDgReOS2wRSU7duA(a5EmXgLkIdd2JGULovLYNitT3orEYWIZ4BVdmvByM7nxuGdyiEIbM00vINGgiNzsReJMEODuJTi0zGoDzZ2FSs1v98JTDu7V2gWy84IvtMaJUwpurp14UVxcvnNqS6FTwh2ROiO60nt7PflvUiIh6DywQvJbEc7I2x8hQesI)KIIm)cfVsZ14vOpnCeUVHeZttZXBud)TArtfIh26uAO5IGv)v617Fl6jQ)VLZaL7QPBN4o4m20U1vOLWeU5Ab)cPJCsy9nUwsqs2mY3lDzJVDlErJpGHP1Yxz9WANHTVoXFp)6Y9kHRl323ducJBWWYjI(Z1Yl5JZ59t0oWAhBVeu)fDNZ1tUDYWkGCEjVrZ1npeiaEvjoq64389tUAStf5P9IL)CIlvEGuhEZ5MzpIobpLYQ65sfIH5Z3wsnUaZOXosXJepKDbPlDTpRSIcVJRPF2GwlnPqRiwvVmhfmDZCFRy0SzAozmK5KrUyJ65XHlks2k3DzsfCQ8WVdjCoCfRR1TJhWU0t7KjW64lXHjCrOZILQ5jh5lWCrKApOxtDjMBq9tAw8D8nsE3sZfZKOFXRW6AiY)Tb01FfesvOx84cRgc1NsvD6ue8aQBAmOAPw1PV6TtalAeh)WIrDuXLAz7T5KBU0qSKgWT1l)oF8iVbMwjZh5GVHyFNTh8VAgLiZtgdcRVecXzyDkK6UEUvj(MGKQ)f0RLeNFI7ndg2(QJ92jEGrvIBLw8LCiD0BEgnCOr3IqGhAf)Bw7WmvElqUAOw3B2UvMqWaouTT2MA0D5mdgLpaIuM7I0LgUesCNPsDIX2J0gdfTURQhqzOQf8mz7r)8g8IsjXDVQT2aW3rLKZ0FPedAADS052gNIQP51O4Q6(O3b9BaloFDSCzKjtWnj4(atwRXNTBnFjo)9MWHBpNzcXKN)ZjDy7CRIXjLduDb7TkhRFd0MGOqjp4BX7epHeNA(16CmvpN0Dic(hdatjrvmgxnKbZ0)enpGFrcpWGPSBVwIlx7qHXKnQllEhi)fJufQ2OqnhKmW3)6SOFnlseDgJFzW9cLHzutUki3KdtXHSyM2aPjuPdcFwpbkuFIsqk8EIwSUwxsWYwWUEqD9xKAQhZ5LkynJWae56qiLEVXNF9l11jgx(AmF(k1NwxflourG6yhZ4QUzgVf89)1zE7D6M3EDpVHCz(knVDDo0PNRftVx)1A6n240tycYmMOjmWHA9CSDlEPzGrPJ)xJhzfpxA9gHrniNCYexUVBDhG(oAitnoppJWsvDwjsZH6FS9vxWaI5cHp0bQtfne7JYxvihvIvprnKuGik3CSH4fVhte1yy1e6C19KGClAmvnVMS3gy5gd1ExDQ3pmMUKvBAKby4blAmgMhljmdRjHOf6k0t3XdoBO(98axFrwclNJapY7iWJCD6sxW4(tP)viArjRuECHOR)dnvXJJHWuFcWcMSZ)8fifKUybYSRks)EivuZ)hlrrxtw5M1INZTWpNfHDbAvORqu8gk59zQVlasM9eCBbCXCR3JzLA5AEVlKZhwSBnvEbZfNOEgkJ810JuFjDu04LNKg79fmxanpUoLmJDpNX29reWT)IbCCCOeigukYtslQ3MExPI23DFpu3GJq8J7JC2q7ZCMg(h6HraycgiLqsTDrhQKi0TV96A2h5oeYKivZerWILOmtBt1CRCGBYLWZSeZtReZZqNQCSLyUQsm3Vmsm3oBpltRvmjX8KwH2djg6h4pJbUSBkE1ddrUu(TP8x)3)PFUPpEgTB6hcHqstEgBxhStCaoFs4UPZIWwbQERx3nf3)UQtnjGNHn0y15Qq5BH)V84LRX0XNgGNUc5r4gMX63NhaxQyJaXo(fINhHZ0DtdJxaohlHoc2F(VD3i9UVeJ)sYpioaWYPVR71UY1dQrWWBN2be6e83HOjTKdNsJbun61TrQxprQNzJRSnR7dlWoZcfDPRIA3Kw7McQlpghIDsEq59e4f1Ja7mRu4pZkFnoca9d4NIbaVkkU85DdTzP4nGPmCOTyihSrll(9Pv3Am53j)0Oq0StqtHK8(R07ETXjjyUanSuhZ74raLOBMWvzmf0enVZtpVZgJVDY7mQlU10NiG98oTbyyhVZtI3bRl(1CXvdpffSoDvN(Wqu4)ay6QD0WI0aFhRhp61I5ck1UbN3NpchP2r4pX)zYVgi1xu8tQzWqSXzOIT05ytUx62tik95)u3R3NSjLy101ZUNCf9BRwgOEvWgAWkFPOgSP4b8o5)UGOeqVF30HFy(Zx()eHg5)JGN74L)e7Ys9()3d]] )