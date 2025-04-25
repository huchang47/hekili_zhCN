-- EvokerAugmentation.lua
-- January 2025

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
    aerial_mastery                  = {  93352, 365933, 1 }, -- Hover gains 1 additional charge.
    ancient_flame                   = {  93271, 369990, 1 }, -- Casting Emerald Blossom or Verdant Embrace reduces the cast time of your next Living Flame by 40%.
    attuned_to_the_dream            = {  93292, 376930, 2 }, -- Your healing done and healing received are increased by 2%.
    blast_furnace                   = {  93309, 375510, 1 }, -- Fire Breath's damage over time lasts 4 sec longer.
    bountiful_bloom                 = {  93291, 370886, 1 }, -- Emerald Blossom heals 2 additional allies.
    cauterizing_flame               = {  93294, 374251, 1 }, -- Cauterize an ally's wounds, removing all Bleed, Poison, Curse, and Disease effects. Heals for 65,292 upon removing any effect.
    clobbering_sweep                = { 103844, 375443, 1 }, -- Tail Swipe's cooldown is reduced by 2 min.
    draconic_legacy                 = {  93300, 376166, 1 }, -- Your Stamina is increased by 6%.
    enkindled                       = {  93295, 375554, 2 }, -- Living Flame deals 3% more damage and healing.
    expunge                         = {  93306, 365585, 1 }, -- Expunge toxins affecting an ally, removing all Poison effects.
    extended_flight                 = {  93349, 375517, 2 }, -- Hover lasts 4 sec longer.
    exuberance                      = {  93299, 375542, 1 }, -- While above 75% health, your movement speed is increased by 10%.
    fire_within                     = {  93345, 375577, 1 }, -- Renewing Blaze's cooldown is reduced by 30 sec.
    foci_of_life                    = {  93345, 375574, 1 }, -- Renewing Blaze restores you more quickly, causing damage you take to be healed back over 4 sec.
    forger_of_mountains             = {  93270, 375528, 1 }, -- Landslide's cooldown is reduced by 30 sec, and it can withstand 200% more damage before breaking.
    heavy_wingbeats                 = { 103843, 368838, 1 }, -- Wing Buffet's cooldown is reduced by 2 min.
    inherent_resistance             = {  93355, 375544, 2 }, -- Magic damage taken reduced by 2%.
    innate_magic                    = {  93302, 375520, 2 }, -- Essence regenerates 5% faster.
    instinctive_arcana              = {  93310, 376164, 2 }, -- Your Magic damage done is increased by 2%.
    landslide                       = {  93305, 358385, 1 }, -- Conjure a path of shifting stone towards the target location, rooting enemies for 15 sec. Damage may cancel the effect.
    leaping_flames                  = {  93343, 369939, 1 }, -- Fire Breath causes your next Living Flame to strike 1 additional target per empower level.
    lush_growth                     = {  93347, 375561, 2 }, -- Green spells restore 5% more health.
    natural_convergence             = {  93312, 369913, 1 }, -- Disintegrate channels 20% faster and Eruption's cast time is reduced by 20%.
    obsidian_bulwark                = {  93289, 375406, 1 }, -- Obsidian Scales has an additional charge.
    obsidian_scales                 = {  93304, 363916, 1 }, -- Reinforce your scales, reducing damage taken by 30%. Lasts 13.5 sec.
    oppressing_roar                 = {  93298, 372048, 1 }, -- Let out a bone-shaking roar at enemies in a cone in front of you, increasing the duration of crowd controls that affect them by 50% in the next 10 sec.
    overawe                         = {  93297, 374346, 1 }, -- Oppressing Roar removes 1 Enrage effect from each enemy, and its cooldown is reduced by 30 sec.
    panacea                         = {  93348, 387761, 1 }, -- Emerald Blossom and Verdant Embrace instantly heal you for 29,148 when cast.
    potent_mana                     = {  93715, 418101, 1 }, -- Source of Magic increases the target's healing and damage done by 3%.
    protracted_talons               = {  93307, 369909, 1 }, -- Azure Strike damages 1 additional enemy.
    quell                           = {  93311, 351338, 1 }, -- Interrupt an enemy's spellcasting and prevent any spell from that school of magic from being cast for 4 sec.
    recall                          = {  93301, 371806, 1 }, -- You may reactivate Breath of Eons within 3 sec after landing to travel back in time to your takeoff location.
    regenerative_magic              = {  93353, 387787, 1 }, -- Your Leech is increased by 2%.
    renewing_blaze                  = {  93354, 374348, 1 }, -- The flames of life surround you for 9.0 sec. While this effect is active, 100% of damage you take is healed back over 8 sec.
    rescue                          = {  93288, 370665, 1 }, -- Swoop to an ally and fly with them to the target location. Clears movement impairing effects from you and your ally.
    scarlet_adaptation              = {  93340, 372469, 1 }, -- Store 20% of your effective healing, up to 40,315. Your next damaging Living Flame consumes all stored healing to increase its damage dealt.
    sleep_walk                      = {  93293, 360806, 1 }, -- Disorient an enemy for 20 sec, causing them to sleep walk towards you. Damage has a chance to awaken them.
    source_of_magic                 = {  93344, 369459, 1 }, -- Redirect your excess magic to a friendly healer for 1.1 |4hour:hrs;. When you cast an empowered spell, you restore 0.25% of their maximum mana per empower level. Limit 1.
    spatial_paradox                 = {  93351, 406732, 1 }, -- Evoke a paradox for you and a friendly healer, allowing casting while moving and increasing the range of most spells by 100% for 11.2 sec. Affects the nearest healer within 60 yds, if you do not have a healer targeted.
    tailwind                        = {  93290, 375556, 1 }, -- Hover increases your movement speed by 70% for the first 4 sec.
    terror_of_the_skies             = {  93342, 371032, 1 }, -- Breath of Eons stuns enemies for 3 sec.
    time_spiral                     = {  93351, 374968, 1 }, -- Bend time, allowing you and your allies within 40 yds to cast their major movement ability once in the next 11.2 sec, even if it is on cooldown.
    tip_the_scales                  = {  93350, 370553, 1 }, -- Compress time to make your next empowered spell cast instantly at its maximum empower level.
    twin_guardian                   = {  93287, 370888, 1 }, -- Rescue protects you and your ally from harm, absorbing damage equal to 30% of your maximum health for 5.6 sec.
    unravel                         = {  93308, 368432, 1 }, -- Sunder an enemy's protective magic, dealing 174,613 Spellfrost damage to absorb shields.
    verdant_embrace                 = {  93341, 360995, 1 }, -- Fly to an ally and heal them for 116,966, or heal yourself for the same amount.
    walloping_blow                  = {  93286, 387341, 1 }, -- Wing Buffet and Tail Swipe knock enemies further and daze them, reducing movement speed by 70% for 4 sec.
    zephyr                          = {  93346, 374227, 1 }, -- Conjure an updraft to lift you and your 4 nearest allies within 20 yds into the air, reducing damage taken from area-of-effect attacks by 20% and increasing movement speed by 30% for 9.0 sec.

    -- Augmentation
    accretion                       = {  93229, 407876, 1 }, -- Eruption reduces the remaining cooldown of Upheaval by 1.0 sec.
    anachronism                     = {  93223, 407869, 1 }, -- Prescience has a 35% chance to grant Essence Burst.
    arcane_reach                    = {  93225, 454983, 1 }, -- The range of your helpful magics is increased by 5 yards.
    aspects_favor                   = {  93217, 407243, 2 }, -- Obsidian Scales activates Black Attunement, and amplifies it to increase maximum health by 4.0% for 13.5 sec. Hover activates Bronze Attunement, and amplifies it to increase movement speed by 25% for 4.5 sec.
    bestow_weyrnstone               = {  93195, 408233, 1 }, -- Conjure a pair of Weyrnstones, one for your target ally and one for yourself. Only one ally may bear your Weyrnstone at a time. A Weyrnstone can be activated by the bearer to transport them to the other Weyrnstone's location, if they are within 100 yds.
    blistering_scales               = {  93209, 360827, 1 }, -- Protect an ally with 20 explosive dragonscales, increasing their Armor by 20% of your own. Melee attacks against the target cause 1 scale to explode, dealing 5,820 Volcanic damage to enemies near them. This damage can only occur every few sec. Blistering Scales can only be placed on one target at a time. Casts on your enemy's target if they have one.
    breath_of_eons                  = {  93234, 403631, 1 }, -- Fly to the targeted location, exposing Temporal Wounds on enemies in your path for 11.2 sec. Temporal Wounds accumulate 12% of damage dealt by your allies affected by Ebon Might, then critically strike for that amount as Arcane damage. Applies Ebon Might for 5 sec. Removes all root effects. You are immune to movement impairing and loss of control effects while flying.
    chrono_ward                     = {  93235, 409676, 1 }, -- When allies deal damage with Temporal Wounds, they gain a shield for 100% of the damage dealt. Absorption cannot exceed 30% of your maximum health.
    defy_fate                       = {  93222, 404195, 1 }, -- Fatal attacks are diverted into a nearby timeline, preventing the damage, and your death, in this one. The release of temporal energy restores 241,416 health to you, and 80,472 to 4 nearby allies, over 9 sec. Healing starts high and declines over the duration. May only occur once every 6 min.
    draconic_attunements            = {  93218, 403208, 1 }, -- Learn to attune yourself to the essence of the Black or Bronze Dragonflights: Black Attunement: You and your 4 nearest allies have 2% increased maximum health. Bronze Attunement:You and your 4 nearest allies have 10% increased movement speed.
    dream_of_spring                 = {  93359, 414969, 1 }, -- Emerald Blossom no longer has a cooldown, deals 35% increased healing, and increases the duration of your active Ebon Might effects by 1 sec, but costs 3 Essence.
    ebon_might                      = {  93198, 395152, 1 }, -- Increase your 4 nearest allies' primary stat by 5.0% of your own, and cause you to deal 25% more damage, for 11.2 sec. May only affect 4 allies at once, and does not affect tanks and healers. Eruption, Breath of Eons, and your empower spells extend the duration of these effects.
    echoing_strike                  = {  93221, 410784, 1 }, -- Azure Strike deals 15% increased damage and has a 10% chance per target hit to echo, casting again.
    eruption                        = {  93200, 395160, 1 }, -- Cause a violent eruption beneath an enemy's feet, dealing 54,324 Volcanic damage split between them and nearby enemies. Increases the duration of your active Ebon Might effects by 1 sec.
    essence_attunement              = {  93219, 375722, 1 }, -- Essence Burst stacks 2 times.
    essence_burst                   = {  93220, 396187, 1 }, -- Your Living Flame has a 20% chance, and your Azure Strike has a 15% chance, to make your next Eruption cost no Essence. Stacks 2 times.
    fate_mirror                     = {  93367, 412774, 1 }, -- Prescience grants the ally a chance for their spells and abilities to echo their damage or healing, dealing 15% of the amount again.
    font_of_magic                   = {  93231, 408083, 1 }, -- Your empower spells' maximum level is increased by 1, and they reach maximum empower level 20% faster.
    hoarded_power                   = {  93212, 375796, 1 }, -- Essence Burst has a 20% chance to not be consumed.
    ignition_rush                   = {  93230, 408775, 1 }, -- Essence Burst reduces the cast time of Eruption by 40%.
    imminent_destruction            = { 102248, 459537, 1 }, -- Breath of Eons reduces the Essence cost of Eruption by 1 and increases its damage by 10% for 15 sec after you land.
    imposing_presence               = {  93199, 371016, 1 }, -- Quell's cooldown is reduced by 20 sec.
    infernos_blessing               = {  93197, 410261, 1 }, -- Fire Breath grants the inferno's blessing for 9.0 sec to you and your allies affected by Ebon Might, giving their damaging attacks and spells a high chance to deal an additional 17,073 Fire damage.
    inner_radiance                  = {  93199, 386405, 1 }, -- Your Living Flame and Emerald Blossom are 30% more effective on yourself.
    interwoven_threads              = {  93369, 412713, 1 }, -- The cooldowns of your spells are reduced by 10%.
    molten_blood                    = {  93211, 410643, 1 }, -- When cast, Blistering Scales grants the target a shield that absorbs up to 167,897 damage for 33.7 sec based on their missing health. Lower health targets gain a larger shield.
    molten_embers                   = { 102249, 459725, 1 }, -- Fire Breath causes enemies to take up to 40% increased damage from your Black spells, increased based on its empower level.
    momentum_shift                  = {  93207, 408004, 1 }, -- Consuming Essence Burst grants you 5% Intellect for 6.7 sec. Stacks up to 2 times.
    motes_of_possibility            = {  93227, 409267, 1 }, -- Eruption has a 25% chance to form a mote of diverted essence near you. Allies who comes in contact with the mote gain a random buff from your arsenal.
    overlord                        = {  93213, 410260, 1 }, -- Breath of Eons casts an Eruption at the first 3 enemies struck. These Eruptions have a 100% chance to create a Mote of Possibility.
    perilous_fate                   = {  93235, 410253, 1 }, -- Breath of Eons reduces enemies' movement speed by 70%, and reduces their attack speed by 50%, for 11.2 sec.
    plot_the_future                 = {  93226, 407866, 1 }, -- Breath of Eons grants you Fury of the Aspects for 15 sec after you land, without causing Exhaustion.
    power_nexus                     = {  93201, 369908, 1 }, -- Increases your maximum Essence to 6.
    prescience                      = {  93358, 409311, 1 }, -- Grant an ally the gift of foresight, increasing their critical strike chance by 3% and occasionally copying their damage and healing spells at 15% power for 20.2 sec. Affects the nearest ally within 25 yds, preferring damage dealers, if you do not have an ally targeted.
    prolong_life                    = {  93359, 410687, 1 }, -- Your effects that extend Ebon Might also extend Symbiotic Bloom.
    pupil_of_alexstrasza            = {  93221, 407814, 1 }, -- When cast at an enemy, Living Flame strikes 1 additional enemy for 100% damage.
    reactive_hide                   = {  93210, 409329, 1 }, -- Each time Blistering Scales explodes it deals 15% more damage for 13.5 sec, stacking 10 times.
    regenerative_chitin             = {  93211, 406907, 1 }, -- Blistering Scales has 5 more scales, and casting Eruption restores 1 scale.
    ricocheting_pyroclast           = {  93208, 406659, 1 }, -- Eruption deals 30% more damage per enemy struck, up to 150%.
    rockfall                        = {  93368, 1219236, 1 }, -- Upheaval reaches maximum empower level 20% faster and has a 60% chance to grant Essence Burst.
    rumbling_earth                  = {  93205, 459120, 1 }, -- Upheaval causes an aftershock at its location, dealing 50% of its damage 2 additional times.
    stretch_time                    = {  93382, 410352, 1 }, -- While flying during Breath of Eons, 50% of damage you would take is instead dealt over 10 sec.
    symbiotic_bloom                 = {  93215, 410685, 2 }, -- Emerald Blossom increases targets' healing received by 3% for 11.2 sec.
    tectonic_locus                  = {  93202, 408002, 1 }, -- Upheaval deals 50% increased damage to the primary target, and launches them higher.
    time_skip                       = {  93232, 404977, 1 }, -- Surge forward in time, causing your cooldowns to recover 1,000% faster for 2 sec.
    timelessness                    = {  93360, 412710, 1 }, -- Enchant an ally to appear out of sync with the normal flow of time, reducing threat they generate by 30% for 33.7 min. Less effective on tank-specialized allies. May only be placed on one target at a time.
    tomorrow_today                  = {  93369, 412723, 1 }, -- Time Skip channels for 1 sec longer.
    unyielding_domain               = {  93202, 412733, 1 }, -- Upheaval cannot be interrupted, and has an additional 10% chance to critically strike.
    upheaval                        = {  93203, 396286, 1 }, -- Gather earthen power beneath your enemy's feet and send them hurtling upwards, dealing 83,426 Volcanic damage to the target and nearby enemies. Increases the duration of your active Ebon Might effects by 2 sec. Empowering expands the area of effect. I: 3 yd radius. II: 6 yd radius. III: 9 yd radius.
    volcanism                       = {  93206, 406904, 1 }, -- Eruption's Essence cost is reduced by 1.

    -- Chronowarden
    afterimage                      = {  94929, 431875, 1 }, -- Empower spells send up to 3 Chrono Flames to your targets.
    chrono_flame                    = {  94954, 431442, 1, "chronowarden" }, -- Living Flame is enhanced with Bronze magic, repeating 25% of the damage or healing you dealt to the target in the last 5 sec as Arcane, up to 29,455.
    doubletime                      = {  94932, 431874, 1 }, -- Ebon Might and Prescience gain a chance equal to your critical strike chance to grant 50% additional stats.
    golden_opportunity              = {  94942, 432004, 1 }, -- Prescience has a 20% chance to cause your next Prescience to last 100% longer.
    instability_matrix              = {  94930, 431484, 1 }, -- Each time you cast an empower spell, unstable time magic reduces its cooldown by up to 6 sec.
    master_of_destiny               = {  94930, 431840, 1 }, -- Casting Essence spells extends all your active Threads of Fate by 1 sec.
    motes_of_acceleration           = {  94935, 432008, 1 }, -- Warp leaves a trail of Motes of Acceleration. Allies who come in contact with a mote gain 20% increased movement speed for 30 sec.
    primacy                         = {  94951, 431657, 1 }, -- For each damage over time effect from Upheaval, gain 3% haste, up to 9%.
    reverberations                  = {  94925, 431615, 1 }, -- Upheaval deals 50% additional damage over 8 sec.
    temporal_burst                  = {  94955, 431695, 1 }, -- Tip the Scales overloads you with temporal energy, increasing your haste, movement speed, and cooldown recovery rate by 30%, decreasing over 30 sec.
    temporality                     = {  94935, 431873, 1 }, -- Warp reduces damage taken by 20%, starting high and reducing over 3 sec.
    threads_of_fate                 = {  94947, 431715, 1 }, -- Casting an empower spell during Temporal Burst causes a nearby ally to gain a Thread of Fate for 10 sec, granting them a chance to echo their damage or healing spells, dealing 15% of the amount again.
    time_convergence                = {  94932, 431984, 1 }, -- Non-defensive abilities with a 45 second or longer cooldown grant 5% Intellect for 15 sec. Essence spells extend the duration by 1 sec.
    warp                            = {  94948, 429483, 1 }, -- Hover now causes you to briefly warp out of existence and appear at your destination. Hover's cooldown is also reduced by 5 sec. Hover continues to allow Evoker spells to be cast while moving.

    -- Scalecommander
    bombardments                    = {  94936, 434300, 1 }, -- Mass Eruption marks your primary target for destruction for the next 6 sec. You and your allies have a chance to trigger a Bombardment when attacking marked targets, dealing 73,725 Volcanic damage split amongst all nearby enemies.
    diverted_power                  = {  94928, 441219, 1 }, -- Bombardments have a chance to generate Essence Burst.
    extended_battle                 = {  94928, 441212, 1 }, -- Essence abilities extend Bombardments by 1 sec.
    hardened_scales                 = {  94933, 441180, 1 }, -- Obsidian Scales reduces damage taken by an additional 10%.
    maneuverability                 = {  94941, 433871, 1 }, -- Breath of Eons can now be steered in your desired direction. In addition, Breath of Eons burns targets for 109,334 Volcanic damage over 12 sec.
    mass_eruption                   = {  98931, 438587, 1, "scalecommander" }, -- Empower spells cause your next Eruption to strike up to 3 targets. When striking less than 3 targets, Eruption damage is increased by 15% for each missing target.
    melt_armor                      = {  94921, 441176, 1 }, -- Breath of Eons causes enemies to take 20% increased damage from Bombardments and Essence abilities for 12 sec.
    menacing_presence               = {  94933, 441181, 1 }, -- Knocking enemies up or backwards reduces their damage done to you by 15% for 8 sec.
    might_of_the_black_dragonflight = {  94952, 441705, 1 }, -- Black spells deal 20% increased damage.
    nimble_flyer                    = {  94943, 441253, 1 }, -- While Hovering, damage taken from area of effect attacks is reduced by 10%.
    onslaught                       = {  94944, 441245, 1 }, -- Entering combat grants a charge of Burnout, causing your next Living Flame to cast instantly.
    slipstream                      = {  94943, 441257, 1 }, -- Deep Breath resets the cooldown of Hover.
    unrelenting_siege               = {  94934, 441246, 1 }, -- For each second you are in combat, Azure Strike, Living Flame, and Eruption deal 1% increased damage, up to 15%.
    wingleader                      = {  94953, 441206, 1 }, -- Bombardments reduce the cooldown of Breath of Eons by 1 sec for each target struck, up to 3 sec.
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    born_in_flame        = 5612, -- (414937)
    chrono_loop          = 5564, -- (383005) Trap the enemy in a time loop for 5 sec. Afterwards, they are returned to their previous location and health. Cannot reduce an enemy's health below 20%.
    divide_and_conquer   = 5557, -- (384689) Breath of Eons forms curtains of fire, preventing line of sight to enemies outside its walls and burning enemies who walk through them for 139,690 Fire damage. Lasts 6 sec.
    dreamwalkers_embrace = 5615, -- (415651) Verdant Embrace tethers you to an ally, increasing movement speed by 40% and slowing and siphoning 24,251 life from enemies who come in contact with the tether. The tether lasts up to 10 sec or until you move more than 30 yards away from your ally.
    nullifying_shroud    = 5558, -- (378464) Wreathe yourself in arcane energy, preventing the next 3 full loss of control effects against you. Lasts 30 sec.
    obsidian_mettle      = 5563, -- (378444) While Obsidian Scales is active you gain immunity to interrupt, silence, and pushback effects.
    scouring_flame       = 5561, -- (378438) Fire Breath burns away 1 beneficial Magic effect per empower level from all targets.
    seismic_slam         = 5454, -- (408543)
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
end )

-- TheWarWithin
spec:RegisterGear( "tww2", 229283, 229281, 229279, 229280, 229278 )

-- Dragonflight
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

    boss = true
end )


spec:RegisterStateTable( "evoker", setmetatable( {}, {
    __index = setfenv( function( t, k )
        if k == "prescience_buffs" then return active_dot.prescience end
        if k == "allied_cds_up" then
            if buff.sense_power.up then return group and active_dot.sense_power_active or 1 end
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
        local power_level = args.empower_to or class.abilities[ this_action ].empowerment_default or max_empower

        if settings.fire_breath_fixed > 0 then
            power_level = min( settings.fire_breath_fixed, power_level )
        end

        return stages[ power_level ] * ( talent.font_of_magic.enabled and 0.8 or 1 ) * ( talent.rockfall.enabled and action == "upheaval" and 0.8 or 1 ) * haste
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
            if talent.overlord.enabled then
                for i = 1, ( max( 3, active_enemies ) ) do
                    spec.abilities.eruption.handler()
                end
            end
            if set_bonus.tww2 >= 2 then
                local ebon = buff.ebon_might.remains
                spec.abilities.upheaval.handler()
                -- Except ebon might extensions. Why blizz.
                buff.ebon_might.remains = ebon
            end
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
        cast = function() return 2.5 * ( talent.ignition_rush.enabled and buff.essence_burst.up and 0.6 or 1 ) * ( talent.natural_convergence.enabled and 0.8 or 1 ) end,
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

            removeStack( "essence_burst" )

            if buff.mass_disintegrate_stacks.up then
                if talent.bombardments.enabled then applyDebuff( "target", "bombardments" ) end
                removeStack( "mass_disintegrate_stacks" )
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


            -- Legacy
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
            if talent.mass_eruption.enabled then addStack( "mass_eruption_stacks" ) end -- ???

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

        damage = function () return 1.61 * stat.spell_power * ( talent.engulfing_blaze.enabled and 1.4 or 1 ) end,
        healing = function () return 2.75 * stat.spell_power * ( talent.engulfing_blaze.enabled and 1.4 or 1 ) * ( 1 + 0.03 * talent.enkindled.rank ) * ( talent.inner_radiance.enabled and 1.3 or 1 ) end,
        spell_targets = function () return buff.leaping_flames.up and min( active_enemies, 1 + buff.leaping_flames.stack ) end,

        handler = function ()
            if buff.burnout.up then removeStack( "burnout" )
            else removeBuff( "ancient_flame" ) end

            removeBuff( "leaping_flames" )
            removeBuff( "scarlet_adaptation" )
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
            if talent.mass_disintegrate.enabled then addStack( "mass_disintegrate_stacks" ) end
            if talent.mass_eruption.enabled then applyBuff( "mass_eruption_stacks" ) end
            -- This was reduced to 50% chance, can't gaurantee it atm
            -- if set_bonus.tww2 >= 4 then addStack( "essence_burst" ) end
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


spec:RegisterPack( "增辉Simc", 20250423, [[Hekili:T3ZAZnUns(BXvQOrCMXYI0pYKCwkvUK6UlP2l3wL392pC1zkksklwdfjx(WECkv63(1naFaacacklptsDzFm1mcGnA0Vq)Ie3BF)F7(7c8kdV)xDM7C98RCUCM9n23m)Y7VR85SW7VlZZ)JEpa)LeVDWF(dvpSlmP0Rmknbh854uVaeifPv5(We2wwMv8DxCXdrLBRwpZpD3ffr7QIjpHFU3Ms8F7FX6401xuUn8jV8NGPgLCXp4Jt5VMhLMhv(8FjQOS4IWht)yyURhZQodF87VBDvuC5pNC)Az4)1o2agLf6F)VAF13a7LTrbbH0jhwapno5ZNF15ox(Dhw9Vf9PdRYYdFmkTQ4WQODzP5Lh(Ld)sZSSVcM1Dr7(r4pFoXVBOlpFUdm0F7F8pGrc9kstoSY5WQQmeLQNg84oNp)Mwiio4CksyBpB(SRV)UyCFJe0nrXXH5WF7xjmPWeV1XHb3)VE)D(a9jmpY7(7MEy16QnBM5L4hb0h3nXatAwv2Hv73Fy1oVeVdRwUaWP54)H(RNDyvPxmm7zb5HE7Ct34wKLhL8WS6LGoTh9Gva(NZkYGjTn0l(WkasaqSoSAYHvWs7bmShdDdtc3ffwqg2M(W1lqwvwumUaW)8tfL5Ef)Mh)QqW(4qVmy9PyFbb9TU)opFQmwC0JTdEFjWNvsnoRgEHRttC3f9W2s3IW4neaoPfP4PvTyt3ek89YJdlD9c8YQf5yNLb0p6SuWzMiNW1THd3fM7fh4cAiffP7W98LF53ZQ3ntnIMixG0Ya6XJH5bEWIgUBDUNprg4kKE0mU3VvLh6cIxrFmKLkvc)37sZaOM7QwzkndSuewYSC1c(4FlUkS7hMvdRGWyVNHTX3ZOKSlkbmYbBCMPiWMebJFqbmVYq)YAImqhlsJtPKQAssqA5S1ajTClstdttaQZsQwibXCPwL5wwj6ih9M8CcNq9cjkyo8c5NMghK(uIW2AwE4oVOUTxdniT3elJ2bC7Oe)WdRUfK7I2fkbdzPUTsms1GuXEbHWlzukZRYi)nawxRewVAwevBo8gJvfcc34vfx2Qe08q)ZQW4y(ztfGAMqvsU3JHItz8S(GqYMRmepG1l29P0QKGggplpeNbDuzSU6fkAZXlLXUy4V7287s4UA3xnajdwp3nP5UrbSYd1C9ODG9b0Uj48rzELpR91o(YDZBr)PmMlyXpIe)hynClS)4eLAjcbHHzU0zoRpKoBqGrTshwuecADa02e5hvsvrS5oFOEkURRYlkrX2gbug6zdzeC4QapnbDAKZJgQrWj1GSBACOETA1d5P8NPIgm7EeYuDyCzb(FBQIJb6P)wV8hcDrZhWSGDYd(bZ25bEc(wqXxGa2D6kds0)zORH0ZJBFSZ79uwuyj9XcQYjNgtMBNir3SY8scaJn(ULBHD9waFRnJa(oqqOnKPXH1xsp4LZlpbPSfeHdgdxWj3(BZttIk2X5zabRLkFxZxQfjAyAuHLwc7MiWEvTKz9dWoCvg44jOtq9jKmCTrefIfSKwN(ENiDx0A1Lx6TOeI8HaujdcRHB9eiePwPiB6rZ(p7hdcxOig4npyVfue(gLhBGyD35FOx2ZUMb5Z9IcCdFe3a7sFmeJeAw4NW4eAMeyWp5JHLZkTNfvmlfoHW7tfUGFK(vWce7g(Wd1iAZeD0mXAzdzlBucDBEdNl6BHHZHZjkcbBhBCHTt9w(ddFQBFbV5MibZyhjT5C5VDOZLrJdD6onXZGlMjQT1UJWylW3ROS2cYjxjMYyvqM68rAyJ3tg6GGoGvdjKBgNMhOiSNXUqD6Ut7oPqPjJoTrvScodVmsHDpakmypxX5o(EG9F6)Wfd2MgYD954GaZoIxa2Qd6wLdJeY4eQGB3YLxLOC14dobxv1b3wt8rjepW3wG6VXRKpwUP0SyG6FZS7f2asyzgMHdzI(ghLUmkdevbhnbAziLCPocv0BVNcjbdYyTVvTBkNHgVGa(qbSVSNXiYCqdrlX4iPdtZt0mG1gfgqC(hLL4uteHqJfuRH01wWmeQB6wVJq)9mvjuZzTcjv5mnQHmbgQoeJxGhHSkwdpDsC8xtqDldvV2SMiSOoymDwGiwf25vu42emg9i4Iw7gdr76gNdmdtG72EmucYwrmAH2yMQ9CrHMqZWnCo0pbAKTLPUbrHezxMJxEh6tGthzqPXr4X6oUruIAxACzycMiLWCbjd8Org1t3aVDEpecOK)hb8vqCG1RnoXb7XCQKoETityzJZJkpHHjkeLYiTkzdNeItLsF9uEciIqq9bGnkPNxEK4HfFmhhT)RWEbcX1feQQkMv(0toUxL5lCSFEQ)h3ak39uPKg5hXMqdUwME)De)bTfdgSNMVcc1ufkjOm31niAlHQdiizYNeLh8tfgEqhzqnwR70Y5zBKDOAV8NYl6PkMYR04duNqSaUVSLoO4GsCueSI7z2TClHXG0wWjDVlmU01lFxAExwn0qIuhvWNbs0qeHZeDGtYgqDGgtB8PzaBLFp11flIL9PYI4v2CP)VL1YPJWuMZCw(Qo7vdBvB44jQxqohgXC2(XiscHCe9mVNraDfwrH1gbx44lALJGdy8JYNclPL4qFzueSclrGK4IQy6Zyc1vP17fdz9EYaQlljAlwARUKJySosZ1CF2KcNOg0vTjgegOCoTPNPnrw2kB40dgR)sAco4C5rLPOBeYl160DR9YdWKLuWLzQMSh0sU(uOFvztciBoIZWIeipiaf5DYrmOYg2lF1c(t27Nj2BO)2uuTIs4nWTxv8vXyUBvXBQvLKofqxGd848xCBwnssTMTzkYchNwBUK6TfUT7abfNLWDwXaPPRTySs5qQd0LjJKRXaKjHfwNqLgY8ef8mKWX4FI4JtwzvXLQlDuT5HQKuDgFuwVRCHmadljgqbgQOyThZYuJl77vuEAdGN8ISZu(SJQQKpoIA434yCc8tpbbUM4wNpUo)E7vj62ALROoMhlQrCDuAUiLvbYJcJLvkud4tYkbVaBsmoWHPf8L4iVA9ZUpTnmoZTa(ZM8OWnNN2gvKrvmIs89Yt8aBBr(yIr6pztQzczIERdZZX2rbGDCmyn6bU9E9KDTDd)KFCvqOSk)mIDRJb7wNXSB1v4N(t0WDRd7Uvm8UrSBju4KN3vfw4w31be7AzrjbXHYyhfzpdoIac3fUpfUw2mkbXD)TH5PvfUGVujf7IklXYvHDcyEu9jL)kzrpSkQapCAxwCKpqadE)Hv)NEjvyKc)hEioiNxVJmhz1GAeBENXS5DgCZ7ODZlJh2Tl6v8KrSnie91WYchXuMsQtW6WNttcKt6sFWpWfZ0P0QUmI11zmRRJW6o(gMIVQRB9aEwb6eXMnu(WqJ)5EW(Ut1ZuLqvi4yOqmG5HjbPfUqSjPLGZdKkOAjNPIlP86cnocRZaewzJ)5Eq1ewNbiSoJLW6Wqyhzxr1Nhv8CIV0YAkWgBJEPtEOl)pTLA4RHivWK(SOR5ebUPByCbSOKgBUM9AlTSjJe7Dgg7DuG9oNaSxH3lMI9z1T4(9kAquzmGrS)qXZM9OjYMnP9J3YrheeBvifyWGe5l4Ma(SUDdArAoIP1T(Y70OVrBAkDZOfwsqzuUPnrQ9WBPI2xWnbJXBrdW9XBjMOvG32D4nDg2njoMh7JIFmM0RkS2yi)MfzFypVlrY8c52TI4oslJHHI40Yg6(sK0LlT2nEVTgMphbAG(9MchuX9gxctyb6i9mtZKBpk4i13Te8C9NsRwJWfLgbzjc7hFjAkJ(n4F8ZqGFqu9(LmtOgKaSWAVEyf13xWvxsXYO)6taHGu4xWpQdRssZ3H(ahN(qeigwMEy1dvEyGbHWOywvO(nNNdR0m928uCWVcELm)PnieuXsLYe)5nsRbHHWvB2GydYD2vsZSUHlJQcykggDVu7sFCPrT1M1xjdklBIJjxvdLnkU3xd(Qk0TIK8oTzTSeo1HlkQRMxWZQZxgB7Z3V1LuLDCMf4EUkzFLKK9XGH9l74vu7w0mXSjfi9PBGGTavjXAClf9zbftlH05p5Gn3HMQlIzdDkTEDVJGPVTfGRJXfBtvEINptAQpNKv82wx2IjvQ8e36Uaqss5gKeF5yjXF4pKuqhtOGKKyROh6SKLxXbPUoJL6A78hsYRnl5vljuv2YvscThnj8M)qscNBmju1R5HssiwqO6)9yjMVogu1UlLLg3b3IhVzSb3BcTRLtD7APxoXIEglTjNLCmBZgsP3RspjwvJNq6NkjzpqV7XY89TX5rUUD1u)TheGoTS(Pd13omnF0a6BTfWCqY0sABtsJ8zABLMfEl5AojqtdEBD6P1oNAAnTA2uVuvlLjXRSJ3XwLoFilXBV0avBkfqVivvMOV6SVOnKx5JlBLuNR2gsO8b14gHYsimstb2C9GMS(8K4fKMMZ0(6MnHkCsZr581kris)xUoNm0fBsVZjJEj9Ox0pQUZEvxt2Me9OHwDo988Uj12IDDZ5T8w06MbhA(TZBwotkWnRTsD8QMxmd2yhfODTVWmsE8BMR0EMyrVeMJ0up212kYMhxNb10c76YyQLmZIdGxstTOe8YES4fF5BSAmyqeO5XjsGWnTMbN2Gg)3QxgBJlvWGMfhOgutAYR5rRu2KqBVH6JvfzlGmwTGBxRyTOjGIbtg(zYfZ6AtvgCV3RefZyDVKiw6rx1PuutA(fluWGAhs339oDVN4SqcZr6OGc)Kd1TCDbCGeJeNgxURNJJXLaAWJqhOij)XuQ0wHuP9xwPsBZl(0G2ghwQ0rMb7JvQKKvAXci03wPGKS4Rg9P0ltJmN2odffOrrKvYj3mtq(5EIN9KhIFrTyAV3lfpmR)RCzJdedRYOcNLDm7aNQtjw8Vo(yP9ODwSeYCBxKCOxDz(5nyjxIFg)ZW(vFb1PsFmka1I9OKS33mdSKlPWFMtFS2D0Hv)xWpfbaojmIo(WqBDkQeZbN7L0Os9TSki3psz4tVXxJKHfJyvLjdMj87oz4bCvCapahPmSdVmSSM)sNRG)P5RtkR)uy(sofL3svFpT616D6C16pv4pPC9tHcVCkQgUoT(6QQ(56WIsyBbpqrFl)0yi5MsNSHc)bVxw3a2SAij0DRh2RMuCK5huFStVpBoSF9FMp7MgjTW)zvuwwyWmomM7W6)Eb7r0pf6LrFxpj5l)rqCaNv7Ny07V7jV8eAb5)B4H11FYqxrEPSFtDn6FZHv54sNJ87IuSedEvLP78iFW)8HD3dHfZo8l)Li0)GV57oS6httG1Im8BAeou3D6a8XgX4n8s2QM6u7pzn4IPU5W7TyANA9ID4xKqDAFZsgh95gD0hXgKxoPrYS4OkAxcL9xV81s30nFrnJvyoFx7Ijj)5Yxk5t0CbSb5wQML5lH5CRbNU5lQzCltuCmyXmHBPzICl0h0jwOSmnYfo0nDZxu(ZNLVs9MJ5Gxr9dKVoQNm3c(T64wMtehC6MVOdqeLphZbVPeXbMm3cApxhBt2B3HCEMIzYVw262DgTw6Mj)A5OCFX2dWs2mcdpgOs8elQPbqva7Et6KVcVeSNkB(SoCVBkNyO)sWB0LrWp(yikfD4o)0EfwLxYEylsD0H9nt4Kc5xcgJHgOdHRh)uc3JaDJuuHE5wYunv(v7sLMY0AEP3WJbQdO8RysN8v4LG9QmaiDkNyO)sWBDk(kN2RWQ8s2dYncizcNui)sWyPMb6p(PeUhb6AS5fTtLF1UsPXSEjUsIvmzZ51f(kHCkeLhzkfhwHFz0EJQKxpzQUf4R)ABN5lMB1GmhjuQbsh2ETsU6W0b5ZHNoFQHVsipmD2PhfsYcmiD2mO0JoRkpi89eHcDsMH5PUQZUIwO2ByZG6XYZETHVjqolp1FMxYZUbzf6GUQ5z6oW01bfICpc4BStkd4g0jyfuEsHbW(f4g0lg6JgVp2ZeETHVjq2m5r1ZZ0DGPRZXj3pIy)ps5(rSchH8ZGsMgKDHxm0pc8gFZMLaT6F2mO4ihkogbLENQFMshFm6KA2Z9M0hwTfeE)(ZeOEnpL1(9Qxj9ofWmiNAG1BNoF21VtHzQ3EPQrGNtcQGV3(wwlNQ3rqvQKI4ITsCXEqCH(neagX(DCydY4pxqqW6RTNp3YQ1VR)aZNV43r85l(DhF(IA(CNkVMIoncdhAQM9imI9fPUukx1r4m2ah7DcwbLhFOg2JIMn40nBvhXb5hjnBeRWOPzdk48kjNnQvDWPxVQKwXytACCk((eH9ArUxb2Rl5HK2EjGEMoP5tP9LZHv4hZbSZOkBMxskPpoQs4MDqao5aVsV1EfHF3HFH8(jHP1srpGqEduFZO6)dvfRBqI(lIh95Lf9)32PFwtIPQf7vPGmQs02jQ5go15X7vg8JbW1n0No42nLXI1Ja4ga2HzLg0IfQLugMwBqAoo1GFmawf1w6uglwpcG3cwds1zvMoHdYOCy6PaKgam2yHKanHHhlgoc1IxvGpiynpZwgLbTx(YWffNi4vheKozdXrp5G0aGPvCtF9kmadhHQ7RkWheSMxabJe3E5lJwXn1XtmiXzyf9tlWnaSNKdxnaRhLJmVYGVfWQ67YJtoxaRpTa3aWomR0axEnaRhLJmVYGVfWk7O1JtZrmSTtl0nbUdZnnqX0e8EuQoV2WVdYQdpFqk(W6MNyOBcChMFAG2Pj49O0FETH)mmZu)mjPui8UHpNxyANU)oVQYT4No278cJHheqPF2)5Z)VdbkR1)YHv3fT7hXlkN0nr4xgTV6RoSABzzwX3DXfpevUTAnSS7UOiAxvmzn9Z92uI)B)lwhNU(IYTHp5L)em1OKl(bYQ)xRFZg)lioCb9sn21R6b8(MIaJz4JF4xW16VNr3NbELabcbdfLac1pKLhfFG85gcFL1izJ7BCMF5LB(wCBt3PfZAFtSE3IlAkJW7X3TVfT3CpVV(DzBH97tZwq(Y1AYZl7(QPfaTWCUjGIdeKpnWlAl5H0LjAZIZu(zm61yfFx7OI4XPanyVfDossyTIq3RnA9UIZgG4RB1(9CdR8nKsyEsFXMeMJK3iPXSnCuSnC0VnCmCB4yW2Wr524RA(CAp8vjZy2ZnVY8Y4Ckt3QazN3cUWGkE)Cgdo6ihh1NsybAQkC05eHJmVh8YiLYEvEgd4DucELVPqJb81fDVg0t7qD2QBTFVWa81gJLVl2Qksh7XUUax64BXNv6iybGSKuV)w7qwtMEgh9xAU1TgdjYrojYrfjswjxzf7utICgGej2q6shrfjYrgjsDTogfjI2Ga4zjKl9GAsL977(m8Vy(SRFpiPgeHWCHYM)GrqRNhwnTU7yWmNxmM1R7tK4l)XGznFYjeXnhwCZMbZEjDmZr1Wmht)YiJ40nM0Ksj0PkYuFyAxL(6pg29mYeO6gZemtMTpgmRVXpJ7LgHwPHVJPmrOsXNZKtGSLmrf6i8y7Yf8BgIFl)(7IeXeI5rtfzOaA8pzIojDb)tudKZ0jvIrkm1mSX0feo1y02Fms0v8EvPFej3ycy0EnQijkNzxzcuvDRPyCytO)byRPqbNXHP07opb5O1FPgLEPPOA9zVzuycuhg5FwbOa7puZZz)jb9cGlr)4uwRii)dxzDMIudh2pYrI6wT2Ov8DFwjqzUjNzJtwY94ChlREXB8SRvmMfbV9dtK(DxA)(UJtcdZe(UUdp1zsFmRjc3E0lxyp5mczS3TgnZEfyPf(r4WVN7Z)py(bv1lsJtNqas3eBrf797FacWjBcJ8t30U1b0SNUPkog2X(BrWsU8cUDr9N(O3EjZwT)DRnZ8MmLUpKF3iCE78SUDH0j2CS7B7ye6uQ3Vh)yAoH7BS5TlUCoRJkCCYfFam2rzkEjqyF5Pjrf7O0nfx43nCRBbMulrG974pmLUbA)U9xLznPw5qcdPHq4GoI3dFGTvFPbYNmSBLmq7DGoS1iCnB0lumzEMk8OL1B2UGcpis7qWhkMulIKBYi5P4HdEjF061ylFTfRQYw0fH3x19j(IUnz(YETeD5hqKCVi4KNhP3UfpgIO9SWpH5jDc)HNMK6gPZbefLTirj3U4goKolLyzcWtfIUZvjTZcLo1fHJl6gabKE1uk4y10BVqtorkUtKBPD5Cm2dzgnNOZul(y1pfY5JtZduy7voyqD1PNPZiqJ4PCcwR2chdfouoM9wXNEifPjvzNMWDNpxAAP3D(CYeSzdE58jKVw(eL9)N7EopAZ)lXb7Fkn5nLe9)kajEgBjwWDaqWlO2J54QIsrBeBQYFgPtywK8qf5YcMJrjFN)9j1k5butS(elXF2T1bu0U40A12LlCKQGJPERKJOXFvvXU(0CCJi4gVYWjtZu9rXE)EMHyyZkpSyyM2M1iMi)o8buMMYOH7fe06QYs7l50(jJfLS0bKxPLHzgSCrHbK8XxLre)fNp1CKLknMojdrVOvPkP4SXfZzSm3OgTFFTjK6Vn4lSB10gLVqnki6NgiMCTfh7GzsmYcTk5nrAx4gMxr(OlspwOGOY2FZ08lCps)9iNlX1hO)(URGj6PjmsdnZP9WoIwrzQBqu4YwtNVB(mNj6mJSSXiAhFG7kxA)E0qoJONlnMFy58)iGhmexj3ZqGxMQTUksy5PilTvz3S2kGcwaiqnGZ8hL4BVlWKjh)Qy14X6OD84mHllRRY8Bp0jp1)JB8W6ej3VEozCECMrmNzdovIG1c7RzsnJQWuvA1BIcRa6rTPt1giWvkoOeLf4qHLaYlXYO9173ZJQiMs2bAcNRvKyxyCPRx(U08pB7cz47z0tLzpvR(sYHU4t1QN(9oZTE30(ruWoUL1sGhAG6LZCvXUoghKyahNOl4lle0FG76yydNUJr2naEWDiqlYqtKtKQgWCMwBVbGEki5xBIq2lbJbPKMndeeTHsW87wkcdfpuqi2BIx1kmaSqNbGjAKGwEfhvInbmYc)s2HsApABIwFvLrRh2GwVKsyRpw(LlUzGKcCtBaWRXurLhGb(0kAEBtqg17oWpNq)QsA4NO9ocnjRklkgfJG)5NGnPxXV51)8AoQT3Vvb6uWCJ(4FsThh1o0FBkjFIeIxpNaSugObF4fys8ROfU8WksAolQFf98WRyY4n0pl6IXFqnsMfbwu(mf3Xk4)kGePzyEokqQqEQx(NjeH1KAnhsAs(0kIWYs)SzNJXdeM0VwlmRmyAbK7wfuhCQMLpHL8NlDe5oxUN54gFWG1PrPZ2dCBwlnuwfh77f8S8vNjbWuqY8CSXJCL0K6X5OYvnhuYD5VoGrN2qxugqIsVuUDXuN5V7Q324Kb7nc85382lTSQ549UBQTmBpF5W75p8fB75OE7bc)stJGHBBNH322oFX2324((fT)Sny)DZxS938x8(dSRo8o8LPSQefnddntXskc2)6JEIm6VfNPsIXtrVKBpSt0F)9735L4HbIG)NUOyeI3qAmeycUeDDSn0r5EAsWbiS6Swut0evd6ljuOZuyuxAmln)iyOipgOJEbEz0sOmrXEuverIBrjil4SsawdAGFKds2NuKvosnvjJILFAzcYZ6GpRKejZ6VtSE7k7MbUdKLh(8TlUCIH9qr)gGOP1riYyg1FfAGHdOuRnRbKKwOXSg4P2q5kWE(KZMQ6IOKlP68aW6eqJCob0iMWavilOT3lK)isBmsI(IYwHr2i0EyEc3EukOblAQALgP9HLaGv3VRdTrv0g0gPLy3MKPUSqkpVJ2xZfWvlUeK6QabGZHk(y)A5EmcQIPQdWMbfz4BD8JDLbveXL(Y5Np9Y5VZ2PXxJ(VphwVThv9CN5VLnEumNIVTZWqVlJ7Bx8TZTER63Cf0SIm(ewHk24L42nlNlo9BMlAeGNUPTZzXqtLmCBMpWYwirYVPvM12R)ABMy2fU)R5MIfURnZTQpRR31HTgzk8wcRPhbT5QR7iSIOP33Nm9yepvMmyv(eiKziW0RMod(mjmx0JGmP3mWCOzZ5ywQWezTKOS(yMV5N1jVjzJWCcdRaJ0(fEjVRYt4QeGE5bhPYdgy8xtRC)7j5bBr5b7ppYd2d2x76mdOtEWHZ4ZiKhWJa)b0n2dRWlorWpwA(r)V(3)XFQRbONDy1phesBGJYTylmd8U4GdRwhI9qDt7yDyfg6x9hpvGMrZ7k5ZRg9PW)Fr0UmmjvR8WK0weInHcPrP3coyHDqn5RWwKFiUtpSkiAd4Qef6iy)P)6DZKFYnx62zDwaNGRFGRT9v2Z4Q1thJP99AAIczI2Nrr3TZ7CTiVtUvP(lQZixuhDcmydma0PFhFrnRXEeVFw9oT6OC6v7XvdsR1YG1F2V4PZS39Q3E5Cf9bZsIZpk79G(4cR7eA8tzYu2(pC(m7(HYWOqOZXu1mjh5mPx6zidYK0QqSx3lm6RktsHpFA8PZaMKJzmP)u35KQ7iJqmA(WFQE8IvpKrimIpqIMM5QsUFi9kCPJCAQ0Bs5H46iPGCDppqRG30g7ZNDZKZKDToZMLrUoZ9DJ5R8axN7(9T)SYp3eIpi73SHjK33dTXOBDQX5ZThje5(ity072ZY60oK2Bc0mBeboKEl(xvJjT1ppsvttV4s1pTyriojLlq9YX68m5wb)()V]] )