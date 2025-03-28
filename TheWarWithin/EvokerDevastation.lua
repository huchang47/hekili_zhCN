-- EvokerDevastation.lua
-- January 2025

if UnitClassBase( "player" ) ~= "EVOKER" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local strformat = string.format

local spec = Hekili:NewSpecialization( 1467 )

spec:RegisterResource( Enum.PowerType.Essence )
spec:RegisterResource( Enum.PowerType.Mana )

-- Talents
spec:RegisterTalents( {
    -- Evoker
    aerial_mastery                  = {  93352, 365933, 1 }, -- Hover gains 1 additional charge.
    afterimage                      = {  94929, 431875, 1 }, -- Empower spells send up to 3 Chrono Flames to your targets.
    ancient_flame                   = {  93271, 369990, 1 }, -- Casting Emerald Blossom or Verdant Embrace reduces the cast time of your next Living Flame by 40%.
    attuned_to_the_dream            = {  93292, 376930, 2 }, -- Your healing done and healing received are increased by 3%.
    blast_furnace                   = {  93309, 375510, 1 }, -- Fire Breath's damage over time lasts 4 sec longer.
    bountiful_bloom                 = {  93291, 370886, 1 }, -- Emerald Blossom heals 2 additional allies.
    cauterizing_flame               = {  93294, 374251, 1 }, -- Cauterize an ally's wounds, removing all Bleed, Poison, Curse, and Disease effects. Heals for 65,292 upon removing any effect.
    chrono_flame                    = {  94954, 431442, 1 }, -- Living Flame is enhanced with Bronze magic, repeating 25% of the damage or healing you dealt to the target in the last 5 sec as Arcane, up to 46,638.
    clobbering_sweep                = { 103844, 375443, 1 }, -- Tail Swipe's cooldown is reduced by 2 min.
    doubletime                      = {  94932, 431874, 1 }, -- Ebon Might and Prescience gain a chance equal to your critical strike chance to grant 50% additional stats.
    draconic_legacy                 = {  93300, 376166, 1 }, -- Your Stamina is increased by 8%.
    enkindled                       = {  93295, 375554, 2 }, -- Living Flame deals 3% more damage and healing.
    expunge                         = {  93306, 365585, 1 }, -- Expunge toxins affecting an ally, removing all Poison effects.
    extended_flight                 = {  93349, 375517, 2 }, -- Hover lasts 4 sec longer.
    exuberance                      = {  93299, 375542, 1 }, -- While above 75% health, your movement speed is increased by 10%.
    fire_within                     = {  93345, 375577, 1 }, -- Renewing Blaze's cooldown is reduced by 30 sec.
    foci_of_life                    = {  93345, 375574, 1 }, -- Renewing Blaze restores you more quickly, causing damage you take to be healed back over 4 sec.
    forger_of_mountains             = {  93270, 375528, 1 }, -- Landslide's cooldown is reduced by 30 sec, and it can withstand 200% more damage before breaking.
    golden_opportunity              = {  94942, 432004, 1 }, -- Prescience has a 20% chance to cause your next Prescience to last 100% longer.
    heavy_wingbeats                 = { 103843, 368838, 1 }, -- Wing Buffet's cooldown is reduced by 2 min.
    inherent_resistance             = {  93355, 375544, 2 }, -- Magic damage taken reduced by 4%.
    innate_magic                    = {  93302, 375520, 2 }, -- Essence regenerates 5% faster.
    instability_matrix              = {  94930, 431484, 1 }, -- Each time you cast an empower spell, unstable time magic reduces its cooldown by up to 6 sec.
    instinctive_arcana              = {  93310, 376164, 2 }, -- Your Magic damage done is increased by 2%.
    landslide                       = {  93305, 358385, 1 }, -- Conjure a path of shifting stone towards the target location, rooting enemies for 15 sec. Damage may cancel the effect.
    leaping_flames                  = {  93343, 369939, 1 }, -- Fire Breath causes your next Living Flame to strike 1 additional target per empower level.
    lush_growth                     = {  93347, 375561, 2 }, -- Green spells restore 5% more health.
    master_of_destiny               = {  94930, 431840, 1 }, -- Casting Essence spells extends all your active Threads of Fate by 1 sec.
    motes_of_acceleration           = {  94935, 432008, 1 }, -- Warp leaves a trail of Motes of Acceleration. Allies who come in contact with a mote gain 20% increased movement speed for 30 sec.
    natural_convergence             = {  93312, 369913, 1 }, -- Disintegrate channels 20% faster.
    obsidian_bulwark                = {  93289, 375406, 1 }, -- Obsidian Scales has an additional charge.
    obsidian_scales                 = {  93304, 363916, 1 }, -- Reinforce your scales, reducing damage taken by 30%. Lasts 12 sec.
    oppressing_roar                 = {  93298, 372048, 1 }, -- Let out a bone-shaking roar at enemies in a cone in front of you, increasing the duration of crowd controls that affect them by 50% in the next 10 sec.
    overawe                         = {  93297, 374346, 1 }, -- Oppressing Roar removes 1 Enrage effect from each enemy, and its cooldown is reduced by 30 sec.
    panacea                         = {  93348, 387761, 1 }, -- Emerald Blossom and Verdant Embrace instantly heal you for 35,196 when cast.
    potent_mana                     = {  93715, 418101, 1 }, -- Source of Magic increases the target's healing and damage done by 3%.
    primacy                         = {  94951, 431657, 1 }, -- For each damage over time effect from Upheaval, gain 3% haste, up to 9%.
    protracted_talons               = {  93307, 369909, 1 }, -- Azure Strike damages 1 additional enemy.
    quell                           = {  93311, 351338, 1 }, -- Interrupt an enemy's spellcasting and prevent any spell from that school of magic from being cast for 4 sec.
    recall                          = {  93301, 371806, 1 }, -- You may reactivate Deep Breath within 3 sec after landing to travel back in time to your takeoff location.
    regenerative_magic              = {  93353, 387787, 1 }, -- Your Leech is increased by 4%.
    renewing_blaze                  = {  93354, 374348, 1 }, -- The flames of life surround you for 8 sec. While this effect is active, 100% of damage you take is healed back over 8 sec.
    rescue                          = {  93288, 370665, 1 }, -- Swoop to an ally and fly with them to the target location. Clears movement impairing effects from you and your ally.
    reverberations                  = {  94925, 431615, 1 }, -- Upheaval deals 50% additional damage over 8 sec.
    scarlet_adaptation              = {  93340, 372469, 1 }, -- Store 20% of your effective healing, up to 40,315. Your next damaging Living Flame consumes all stored healing to increase its damage dealt.
    sleep_walk                      = {  93293, 360806, 1 }, -- Disorient an enemy for 20 sec, causing them to sleep walk towards you. Damage has a chance to awaken them.
    source_of_magic                 = {  93344, 369459, 1 }, -- Redirect your excess magic to a friendly healer for 1 |4hour:hrs;. When you cast an empowered spell, you restore 0.25% of their maximum mana per empower level. Limit 1.
    spatial_paradox                 = {  93351, 406732, 1 }, -- Evoke a paradox for you and a friendly healer, allowing casting while moving and increasing the range of most spells by 100% for 10 sec. Affects the nearest healer within 60 yds, if you do not have a healer targeted.
    tailwind                        = {  93290, 375556, 1 }, -- Hover increases your movement speed by 70% for the first 4 sec.
    temporal_burst                  = {  94955, 431695, 1 }, -- Tip the Scales overloads you with temporal energy, increasing your haste, movement speed, and cooldown recovery rate by 30%, decreasing over 30 sec.
    temporality                     = {  94935, 431873, 1 }, -- Warp reduces damage taken by 20%, starting high and reducing over 3 sec.
    terror_of_the_skies             = {  93342, 371032, 1 }, -- Deep Breath stuns enemies for 3 sec.
    threads_of_fate                 = {  94947, 431715, 1 }, -- Casting an empower spell during Temporal Burst causes a nearby ally to gain a Thread of Fate for 10 sec, granting them a chance to echo their damage or healing spells, dealing 15% of the amount again.
    time_convergence                = {  94932, 431984, 1 }, -- Non-defensive abilities with a 45 second or longer cooldown grant 5% Intellect for 15 sec. Essence spells extend the duration by 1 sec.
    time_spiral                     = {  93351, 374968, 1 }, -- Bend time, allowing you and your allies within 40 yds to cast their major movement ability once in the next 10 sec, even if it is on cooldown.
    tip_the_scales                  = {  93350, 370553, 1 }, -- Compress time to make your next empowered spell cast instantly at its maximum empower level.
    twin_guardian                   = {  93287, 370888, 1 }, -- Rescue protects you and your ally from harm, absorbing damage equal to 30% of your maximum health for 5 sec.
    unravel                         = {  93308, 368432, 1 }, -- Sunder an enemy's protective magic, dealing 197,312 Spellfrost damage to absorb shields.
    verdant_embrace                 = {  93341, 360995, 1 }, -- Fly to an ally and heal them for 141,237, or heal yourself for the same amount.
    walloping_blow                  = {  93286, 387341, 1 }, -- Wing Buffet and Tail Swipe knock enemies further and daze them, reducing movement speed by 70% for 4 sec. 
    warp                            = {  94948, 429483, 1 }, -- Hover now causes you to briefly warp out of existence and appear at your destination. Hover's cooldown is also reduced by 5 sec. Hover continues to allow Evoker spells to be cast while moving.
    zephyr                          = {  93346, 374227, 1 }, -- Conjure an updraft to lift you and your 4 nearest allies within 20 yds into the air, reducing damage taken from area-of-effect attacks by 20% and increasing movement speed by 30% for 8 sec.

    -- Devastation
    animosity                       = {  93330, 375797, 1 }, -- Casting an empower spell extends the duration of Dragonrage by 5 sec, up to a maximum of 20 sec.
    arcane_intensity                = {  93274, 375618, 2 }, -- Disintegrate deals 8% more damage.
    arcane_vigor                    = {  93315, 386342, 1 }, -- Casting Shattering Star grants Essence Burst.
    azure_celerity                  = {  93325, 1219723, 1 }, -- Disintegrate ticks 1 additional time, but deals 10% less damage.
    azure_essence_burst             = {  93333, 375721, 1 }, -- Azure Strike has a 15% chance to cause an Essence Burst, making your next Disintegrate or Pyre cost no Essence.
    burnout                         = {  93314, 375801, 1 }, -- Fire Breath damage has 16% chance to cause your next Living Flame to be instant cast, stacking 2 times.
    catalyze                        = {  93280, 386283, 1 }, -- While channeling Disintegrate your Fire Breath on the target deals damage 100% more often.
    causality                       = {  93366, 375777, 1 }, -- Disintegrate reduces the remaining cooldown of your empower spells by 0.50 sec each time it deals damage. Pyre reduces the remaining cooldown of your empower spells by 0.40 sec per enemy struck, up to 2.0 sec.
    charged_blast                   = {  93317, 370455, 1 }, -- Your Blue damage increases the damage of your next Pyre by 5%, stacking 20 times.
    dense_energy                    = {  93284, 370962, 1 }, -- Pyre's Essence cost is reduced by 1.
    dragonrage                      = {  93331, 375087, 1 }, -- Erupt with draconic fury and exhale Pyres at 3 enemies within 25 yds. For 18 sec, Essence Burst's chance to occur is increased to 100%, and you gain the maximum benefit of Mastery: Giantkiller regardless of targets' health.
    engulfing_blaze                 = {  93282, 370837, 1 }, -- Living Flame deals 25% increased damage and healing, but its cast time is increased by 0.3 sec.
    essence_attunement              = {  93319, 375722, 1 }, -- Essence Burst stacks 2 times.
    eternity_surge                  = {  93275, 359073, 1 }, -- Focus your energies to release a salvo of pure magic, dealing 149,519 Spellfrost damage to an enemy. Damages additional enemies within 25 yds when empowered. I: Damages 2 enemies. II: Damages 4 enemies. III: Damages 6 enemies.
    eternitys_span                  = {  93320, 375757, 1 }, -- Eternity Surge and Shattering Star hit twice as many targets.
    event_horizon                   = {  93318, 411164, 1 }, -- Eternity Surge's cooldown is reduced by 3 sec.
    eye_of_infinity                 = {  93318, 411165, 1 }, -- Eternity Surge deals 15% increased damage to your primary target.
    feed_the_flames                 = {  93313, 369846, 1 }, -- After casting 9 Pyres, your next Pyre will explode into a Firestorm. In addition, Pyre and Disintegrate deal 20% increased damage to enemies within your Firestorm.
    firestorm                       = {  93278, 368847, 1 }, -- An explosion bombards the target area with white-hot embers, dealing 55,401 Fire damage to enemies over 6 sec.
    focusing_iris                   = {  93315, 386336, 1 }, -- Shattering Star's damage taken effect lasts 2 sec longer.
    font_of_magic                   = {  93279, 411212, 1 }, -- Your empower spells' maximum level is increased by 1, and they reach maximum empower level 20% faster.
    heat_wave                       = {  93281, 375725, 2 }, -- Fire Breath deals 20% more damage.
    honed_aggression                = {  93329, 371038, 2 }, -- Azure Strike and Living Flame deal 5% more damage.
    imminent_destruction            = {  93326, 370781, 1 }, -- Deep Breath reduces the Essence costs of Disintegrate and Pyre by 1 and increases their damage by 10% for 12 sec after you land.
    imposing_presence               = {  93332, 371016, 1 }, -- Quell's cooldown is reduced by 20 sec.
    inner_radiance                  = {  93332, 386405, 1 }, -- Your Living Flame and Emerald Blossom are 30% more effective on yourself.
    iridescence                     = {  93321, 370867, 1 }, -- Casting an empower spell increases the damage of your next 2 spells of the same color by 20% within 10 sec.
    lay_waste                       = {  93273, 371034, 1 }, -- Deep Breath's damage is increased by 20%.
    onyx_legacy                     = {  93327, 386348, 1 }, -- Deep Breath's cooldown is reduced by 1 min.
    power_nexus                     = {  93276, 369908, 1 }, -- Increases your maximum Essence to 6.
    power_swell                     = {  93322, 370839, 1 }, -- Casting an empower spell increases your Essence regeneration rate by 100% for 4 sec.
    pyre                            = {  93334, 357211, 1 }, -- Lob a ball of flame, dealing 45,820 Fire damage to the target and nearby enemies.
    ruby_embers                     = {  93282, 365937, 1 }, -- Living Flame deals 6,613 damage over 12 sec to enemies, or restores 12,203 health to allies over 12 sec. Stacks 3 times.
    ruby_essence_burst              = {  93285, 376872, 1 }, -- Your Living Flame has a 20% chance to cause an Essence Burst, making your next Disintegrate or Pyre cost no Essence.
    scintillation                   = {  93324, 370821, 1 }, -- Disintegrate has a 15% chance each time it deals damage to launch a level 1 Eternity Surge at 50% power.
    scorching_embers                = {  93365, 370819, 1 }, -- Fire Breath causes enemies to take up to 40% increased damage from your Red spells, increased based on its empower level.
    shattering_star                 = {  93316, 370452, 1 }, -- Exhale bolts of concentrated power from your mouth at 2 enemies for 50,547 Spellfrost damage that cracks the targets' defenses, increasing the damage they take from you by 20% for 4 sec. Grants Essence Burst.
    snapfire                        = {  93277, 370783, 1 }, -- Pyre and Living Flame have a 15% chance to cause your next Firestorm to be instantly cast without triggering its cooldown, and deal 100% increased damage.
    spellweavers_dominance          = {  93323, 370845, 1 }, -- Your damaging critical strikes deal 230% damage instead of the usual 200%.
    titanic_wrath                   = {  93272, 386272, 1 }, -- Essence Burst increases the damage of affected spells by 15.0%.
    tyranny                         = {  93328, 376888, 1 }, -- During Deep Breath and Dragonrage you gain the maximum benefit of Mastery: Giantkiller regardless of targets' health.
    volatility                      = {  93283, 369089, 2 }, -- Pyre has a 15% chance to flare up and explode again on a nearby target.

    -- Scalecommander
    bombardments                    = {  94936, 434300, 1 }, -- Mass Disintegrate marks your primary target for destruction for the next 6 sec. You and your allies have a chance to trigger a Bombardment when attacking marked targets, dealing 73,725 Volcanic damage split amongst all nearby enemies.
    diverted_power                  = {  94928, 441219, 1 }, -- Bombardments have a chance to generate Essence Burst.
    extended_battle                 = {  94928, 441212, 1 }, -- Essence abilities extend Bombardments by 1 sec.
    hardened_scales                 = {  94933, 441180, 1 }, -- Obsidian Scales reduces damage taken by an additional 10%.
    maneuverability                 = {  94941, 433871, 1 }, -- Deep Breath can now be steered in your desired direction. In addition, Deep Breath burns targets for 174,419 Volcanic damage over 12 sec.
    mass_disintegrate               = {  94939, 436335, 1, "scalecommander" }, -- Empower spells cause your next Disintegrate to strike up to $s1 targets. When striking fewer than $s1 targets, Disintegrate damage is increased by $s2% for each missing target.
    melt_armor                      = {  94921, 441176, 1 }, -- Deep Breath causes enemies to take 20% increased damage from Bombardments and Essence abilities for 12 sec.
    menacing_presence               = {  94933, 441181, 1 }, -- Knocking enemies up or backwards reduces their damage done to you by 15% for 8 sec.
    might_of_the_black_dragonflight = {  94952, 441705, 1 }, -- Black spells deal 20% increased damage.
    nimble_flyer                    = {  94943, 441253, 1 }, -- While Hovering, damage taken from area of effect attacks is reduced by 10%.
    onslaught                       = {  94944, 441245, 1 }, -- Entering combat grants a charge of Burnout, causing your next Living Flame to cast instantly.
    slipstream                      = {  94943, 441257, 1 }, -- Deep Breath resets the cooldown of Hover.
    unrelenting_siege               = {  94934, 441246, 1 }, -- For each second you are in combat, Azure Strike, Living Flame, and Disintegrate deal 1% increased damage, up to 15%.
    wingleader                      = {  94953, 441206, 1 }, -- Bombardments reduce the cooldown of Deep Breath by 1 sec for each target struck, up to 3 sec.

    -- Flameshaper
    burning_adrenaline              = {  94946, 444020, 1 }, -- Engulf quickens your pulse, reducing the cast time of your next spell by 30%. Stacks up to 2 charges.
    conduit_of_flame                = {  94949, 444843, 1 }, -- Critical strike chance against targets above 50% health increased by 15%.
    consume_flame                   = {  94922, 444088, 1 }, -- Engulf consumes 2 sec of Fire Breath from the target, detonating it and damaging all nearby targets equal to 750% of the amount consumed, reduced beyond 5 targets.
    draconic_instincts              = {  94931, 445958, 1 }, -- Your wounds have a small chance to cauterize, healing you for 30% of damage taken. Occurs more often from attacks that deal high damage.
    engulf                          = {  94950, 443328, 1, "flameshaper" }, -- Engulf your target in dragonflame, damaging them for $443329s1 Fire or healing them for $443330s1. For each of your periodic effects on the target, effectiveness is increased by $s1%.
    enkindle                        = {  94956, 444016, 1 }, -- Essence abilities are enhanced with Flame, dealing 20% of healing or damage done as Fire over 8 sec.
    expanded_lungs                  = {  94956, 444845, 1 }, -- Fire Breath's damage over time is increased by 30%. Dream Breath's heal over time is increased by 30%.
    flame_siphon                    = {  99857, 444140, 1 }, -- Engulf reduces the cooldown of Fire Breath by 6 sec.
    fulminous_roar                  = {  94923, 1218447, 1 }, -- Fire Breath deals its damage in 20% less time.
    lifecinders                     = {  94931, 444322, 1 }, -- Renewing Blaze also applies to your target or 1 nearby injured ally at 50% value.
    red_hot                         = {  94945, 444081, 1 }, -- Engulf gains 1 additional charge and deals 20% increased damage and healing.
    shape_of_flame                  = {  94937, 445074, 1 }, -- Tail Swipe and Wing Buffet scorch enemies and blind them with ash, causing their next attack within 4 sec to miss.
    titanic_precision               = {  94920, 445625, 1 }, -- Living Flame and Azure Strike have 1 extra chance to trigger Essence Burst when they critically strike.
    trailblazer                     = {  94937, 444849, 1 }, -- Hover and Deep Breath travel 40% faster, and Hover travels 40% further.
} )

-- PvP Talents
spec:RegisterPvpTalents( { 
    chrono_loop          = 5456, -- (383005) Trap the enemy in a time loop for 5 sec. Afterwards, they are returned to their previous location and health. Cannot reduce an enemy's health below 20%.
    divide_and_conquer   = 5556, -- (384689) 
    dreamwalkers_embrace = 5617, -- (415651) 
    nullifying_shroud    = 5467, -- (378464) Wreathe yourself in arcane energy, preventing the next 3 full loss of control effects against you. Lasts 30 sec.
    obsidian_mettle      = 5460, -- (378444) 
    scouring_flame       = 5462, -- (378438) 
    swoop_up             = 5466, -- (370388) Grab an enemy and fly with them to the target location.
    time_stop            = 5464, -- (378441) Freeze an ally's timestream for 5 sec. While frozen in time they are invulnerable, cannot act, and auras do not progress. You may reactivate Time Stop to end this effect early.
    unburdened_flight    = 5469, -- (378437) Hover makes you immune to movement speed reduction effects.
} )

-- Support 'in_firestorm' virtual debuff.
local firestorm_enemies = {}
local firestorm_last = 0
local firestorm_cast = 368847
local firestorm_tick = 369374

local eb_col_casts = 0
local animosityExtension = 0 -- Maintained by CLEU

spec:RegisterCombatLogEvent( function( _, subtype, _,  sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName )
    if sourceGUID == state.GUID then
        if subtype == "SPELL_CAST_SUCCESS" then
            if spellID == firestorm_cast then
                wipe( firestorm_enemies )
                firestorm_last = GetTime()
                return
            elseif spellID == spec.abilities.emerald_blossom.id then
                eb_col_casts = ( eb_col_casts + 1 ) % 3
                return
            elseif spellID == 375087 then  -- Dragonrage
                animosityExtension = 0
                return
            end

            if state.talent.animosity.enabled and animosityExtension < 4 then
                -- Empowered spell casts increment this extension tracker by 1
                for _, ability in pairs( class.abilities ) do
                    if ability.empowered and spellID == ability.id then
                        animosityExtension = animosityExtension + 1
                        break
                    end
                end
            end
        end

        if subtype == "SPELL_DAMAGE" and spellID == firestorm_tick then
            local n = firestorm_enemies[ destGUID ]

            if n then
                firestorm_enemies[ destGUID ] = n + 1
                return
            else
                firestorm_enemies[ destGUID ] = 1
            end
            return
        end
    end
end )

spec:RegisterStateExpr( "cycle_of_life_count", function()
    return eb_col_cast
end )

-- Auras
spec:RegisterAuras( {
    -- Talent: The cast time of your next Living Flame is reduced by $w1%.
    -- https://wowhead.com/beta/spell=375583
    ancient_flame = {
        id = 375583,
        duration = 3600,
        max_stack = 1
    },
    -- Damage taken has a chance to summon air support from the Dracthyr.
    bombardments = {
        id = 434473,
        duration = 6.0,
        pandemic = true,
        max_stack = 1
    },
    -- Next spell cast time reduced by $s1%.
    burning_adrenaline = {
        id = 444019,
        duration = 15.0,
        max_stack = 2
    },
    -- Talent: Next Living Flame's cast time is reduced by $w1%.
    -- https://wowhead.com/beta/spell=375802
    burnout = {
        id = 375802,
        duration = 15,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Your next Pyre deals $s1% more damage.
    -- https://wowhead.com/beta/spell=370454
    charged_blast = {
        id = 370454,
        duration = 30,
        max_stack = 20
    },
    chrono_loop = {
        id = 383005,
        duration = 5,
        max_stack = 1
    },
    cycle_of_life = {
        id = 371877,
        duration = 15,
        max_stack = 1
    },
    --[[ Suffering $w1 Volcanic damage every $t1 sec.
    -- https://wowhead.com/beta/spell=353759
    deep_breath = {
        id = 353759,
        duration = 1,
        tick_time = 0.5,
        type = "Magic",
        max_stack = 1
    }, -- TODO: Effect of impact on target. ]]
    -- Spewing molten cinders. Immune to crowd control.
    -- https://wowhead.com/beta/spell=357210
    deep_breath = {
        id = 357210,
        duration = 6,
        type = "Magic",
        max_stack = 1
    },
    -- Suffering $w1 Spellfrost damage every $t1 sec.
    -- https://wowhead.com/beta/spell=356995
    disintegrate = {
        id = 356995,
        duration = function () return 3 * ( talent.natural_convergence.enabled and 0.8 or 1 ) * ( buff.burning_adrenaline.up and 0.7 or 1 ) end,
        tick_time = function () return spec.auras.disintegrate.duration / ( 4 + talent.azure_celerity.rank ) end,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Essence Burst has a $s2% chance to occur.$?s376888[    Your spells gain the maximum benefit of Mastery: Giantkiller regardless of targets' health.][]
    -- https://wowhead.com/beta/spell=375087
    dragonrage = {
        id = 375087,
        duration = 18,
        max_stack = 1
    },
    -- Releasing healing breath. Immune to crowd control.
    -- https://wowhead.com/beta/spell=359816
    dream_flight = {
        id = 359816,
        duration = 6,
        type = "Magic",
        max_stack = 1
    },
    -- Healing for $w1 every $t1 sec.
    -- https://wowhead.com/beta/spell=363502
    dream_flight_hot = {
        id = 363502,
        duration = 15,
        type = "Magic",
        max_stack = 1,
        dot = "buff"
    },
    -- When $@auracaster casts a non-Echo healing spell, $w2% of the healing will be replicated.
    -- https://wowhead.com/beta/spell=364343
    echo = {
        id = 364343,
        duration = 15,
        max_stack = 1
    },
    -- Healing and restoring mana.
    -- https://wowhead.com/beta/spell=370960
    emerald_communion = {
        id = 370960,
        duration = 5,
        max_stack = 1
    },
    enkindle = {
        id = 444017,
        duration = 8,
        type = "Magic",
        tick_time = 2,
        max_stack = 1
    },
    -- Your next Disintegrate or Pyre costs no Essence.
    -- https://wowhead.com/beta/spell=359618
    essence_burst = {
        id = 359618,
        duration = 15,
        max_stack = function() return talent.essence_attunement.enabled and 2 or 1 end
    },
    eternity_surge_x3 = { -- TODO: This is the channel with 3 ranks.
        id = 359073,
        duration = 2.5,
        max_stack = 1
    },
    eternity_surge_x4 = { -- TODO: This is the channel with 4 ranks.
        id = 382411,
        duration = 3.25,
        max_stack = 1
    },
    eternity_surge = {
        alias = { "eternity_surge_x4", "eternity_surge_x3" },
        aliasMode = "first",
        aliasType = "buff",
        duration = 3.25
    },
    feed_the_flames_stacking = {
        id = 405874,
        duration = 120,
        max_stack = 9
    },
    feed_the_flames_pyre = {
        id = 411288,
        duration = 60,
        max_stack = 1
    },
    fire_breath = {
        id = 357209,
        duration = function ()
            local base = 26 + 4 * talent.blast_furnace.rank
            base = base - 6 * empowerment_level
            return base * ( talent.fulminous_roar.enabled and 0.8 or 1 )
        end,
        -- TODO: damage = function () return 0.322 * stat.spell_power * action.fire_breath.spell_targets * ( talent.heat_wave.enabled and 1.2 or 1 ) * ( debuff.shattering_star.up and 1.2 or 1 ) end,
        type = "Magic",
        max_stack = 1,
        copy = { "fire_breath_damage", "fire_breath_dot" }
    },
    firestorm = { -- TODO: Check for totem?
        id = 369372,
        duration = 6,
        max_stack = 1
    },
    -- Increases the damage of Fire Breath by $s1%.
    -- https://wowhead.com/beta/spell=377087
    full_belly = {
        id = 377087,
        duration = 600,
        type = "Magic",
        max_stack = 1
    },
    -- Movement speed increased by $w2%.$?e0[ Area damage taken reduced by $s1%.][]; Evoker spells may be cast while moving. Does not affect empowered spells.$?e9[; Immune to movement speed reduction effects.][]
    hover = {
        id = 358267,
        duration = function () return talent.extended_flight.enabled and 10 or 6 end,
        tick_time = 1,
        max_stack = 1
    },
    -- Essence costs of Disintegrate and Pyre are reduced by $s1, and their damage increased by $s2%.
    imminent_destruction = {
        id = 411055,
        duration = 12,
        max_stack = 1
    },
    in_firestorm = {
        duration = 6,
        max_stack = 1,
        generate = function( t )
            t.name = class.auras.firestorm.name

            if firestorm_last + 6 > query_time and firestorm_enemies[ target.unit ] then
                t.applied = firestorm_last
                t.duration = 6
                t.expires = firestorm_last + 6
                t.count = 1
                t.caster = "player"
                return
            end

            t.applied = 0
            t.duration = 0
            t.expires = 0
            t.count = 0
            t.caster = "nobody"
        end
    },
    -- Your next Blue spell deals $s1% more damage.
    -- https://wowhead.com/beta/spell=386399
    iridescence_blue = {
        id = 386399,
        duration = 10,
        max_stack = 2
    },
    -- Your next Red spell deals $s1% more damage.
    -- https://wowhead.com/beta/spell=386353
    iridescence_red = {
        id = 386353,
        duration = 10,
        max_stack = 2
    },
    -- Talent: Rooted.
    -- https://wowhead.com/beta/spell=355689
    landslide = {
        id = 355689,
        duration = 15,
        mechanic = "root",
        type = "Magic",
        max_stack = 1
    },
    leaping_flames = {
        id = 370901,
        duration = 30,
        max_stack = function() return max_empower end
    },
    -- Sharing $s1% of healing to an ally.
    -- https://wowhead.com/beta/spell=373267
    lifebind = {
        id = 373267,
        duration = 5,
        max_stack = 1
    },
    -- Burning for $w2 Fire damage every $t2 sec.
    -- https://wowhead.com/beta/spell=361500
    living_flame = {
        id = 361500,
        duration = 12,
        type = "Magic",
        max_stack = 3,
        copy = { "living_flame_dot", "living_flame_damage" }
    },
    -- Healing for $w2 every $t2 sec.
    -- https://wowhead.com/beta/spell=361509
    living_flame_hot = {
        id = 361509,
        duration = 12,
        type = "Magic",
        max_stack = 3,
        dot = "buff",
        copy = "living_flame_heal"
    },
    --
    -- https://wowhead.com/beta/spell=362980
    mastery_giantkiller = {
        id = 362980,
        duration = 3600,
        max_stack = 1
    },
    -- $?e0[Suffering $w1 Volcanic damage every $t1 sec.][]$?e1[ Damage taken from Essence abilities and bombardments increased by $s2%.][]
    melt_armor = {
        id = 441172,
        duration = 12.0,
        tick_time = 2.0,
        max_stack = 1
    },
    -- Damage done to $@auracaster reduced by $s1%.
    menacing_presence = {
        id = 441201,
        duration = 8.0,
        max_stack = 1
    },
    -- Talent: Armor increased by $w1%. Magic damage taken reduced by $w2%.$?$w3=1[  Immune to interrupt and silence effects.][]
    -- https://wowhead.com/beta/spell=363916
    obsidian_scales = {
        id = 363916,
        duration = 12,
        max_stack = 1
    },
    -- Talent: The duration of incoming crowd control effects are increased by $s2%.
    -- https://wowhead.com/beta/spell=372048
    oppressing_roar = {
        id = 372048,
        duration = 10,
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $w1%.
    -- https://wowhead.com/beta/spell=370898
    permeating_chill = {
        id = 370898,
        duration = 3,
        mechanic = "snare",
        max_stack = 1
    },
    power_swell = {
        id = 376850,
        duration = 4,
        max_stack = 1
    },
    -- Talent: $w1% of damage taken is being healed over time.
    -- https://wowhead.com/beta/spell=374348
    renewing_blaze = {
        id = 374348,
        duration = function() return talent.foci_of_life.enabled and 4 or 8 end,
        max_stack = 1
    },
    -- Talent: Restoring $w1 health every $t1 sec.
    -- https://wowhead.com/beta/spell=374349
    renewing_blaze_heal = {
        id = 374349,
        duration = function() return talent.foci_of_life.enabled and 4 or 8 end,
        max_stack = 1
    },
    recall = {
        id = 371807,
        duration = 10,
        max_stack = function () return talent.essence_attunement.enabled and 2 or 1 end
    },
    -- Talent: About to be picked up!
    -- https://wowhead.com/beta/spell=370665
    rescue = {
        id = 370665,
        duration = 1,
        max_stack = 1
    },
    -- Next attack will miss.
    shape_of_flame = {
        id = 445134,
        duration = 4.0,
        max_stack = 1
    },
    -- Healing for $w1 every $t1 sec.
    -- https://wowhead.com/beta/spell=366155
    reversion = {
        id = 366155,
        duration = 12,
        max_stack = 1
    },
    scarlet_adaptation = {
        id = 372470,
        duration = 3600,
        max_stack = 1
    },
    -- Talent: Taking $w3% increased damage from $@auracaster.
    -- https://wowhead.com/beta/spell=370452
    shattering_star = {
        id = 370452,
        duration = function () return talent.focusing_iris.enabled and 6 or 4 end,
        type = "Magic",
        max_stack = 1,
        copy = "shattering_star_debuff"
    },
    -- Talent: Asleep.
    -- https://wowhead.com/beta/spell=360806
    sleep_walk = {
        id = 360806,
        duration = 20,
        mechanic = "sleep",
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Your next Firestorm is instant cast and deals $s2% increased damage.
    -- https://wowhead.com/beta/spell=370818
    snapfire = {
        id = 370818,
        duration = 10,
        max_stack = 1
    },
    -- Talent: $@auracaster is restoring mana to you when they cast an empowered spell.
    -- https://wowhead.com/beta/spell=369459
    source_of_magic = {
        id = 369459,
        duration = 3600,
        max_stack = 1,
        dot = "buff",
        friendly = true
    },
    -- Able to cast spells while moving and spell range increased by $s4%.
    spatial_paradox = {
        id = 406732,
        duration = 10.0,
        tick_time = 1.0,
        max_stack = 1
    },
    -- Talent:
    -- https://wowhead.com/beta/spell=370845
    spellweavers_dominance = {
        id = 370845,
        duration = 3600,
        max_stack = 1
    },
    -- Movement speed reduced by $s2%.
    -- https://wowhead.com/beta/spell=368970
    tail_swipe = {
        id = 368970,
        duration = 4,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Stunned.
    -- https://wowhead.com/beta/spell=372245
    terror_of_the_skies = {
        id = 372245,
        duration = 3,
        mechanic = "stun",
        max_stack = 1
    },
    -- Talent: May use Death's Advance once, without incurring its cooldown.
    -- https://wowhead.com/beta/spell=375226
    time_spiral = {
        id = 375226,
        duration = 10,
        max_stack = 1
    },
    time_stop = {
        id = 378441,
        duration = 5,
        max_stack = 1
    },
    -- Talent: Your next empowered spell casts instantly at its maximum empower level.
    -- https://wowhead.com/beta/spell=370553
    tip_the_scales = {
        id = 370553,
        duration = 3600,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Absorbing $w1 damage.
    -- https://wowhead.com/beta/spell=370889
    twin_guardian = {
        id = 370889,
        duration = 5,
        max_stack = 1
    },
    -- Movement speed reduced by $s2%.
    -- https://wowhead.com/beta/spell=357214
    wing_buffet = {
        id = 357214,
        duration = 4,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Damage taken from area-of-effect attacks reduced by $w1%.  Movement speed increased by $w2%.
    -- https://wowhead.com/beta/spell=374227
    zephyr = {
        id = 374227,
        duration = 8,
        max_stack = 1
    }
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

spec:RegisterStateExpr( "animosity_extension", function() return animosityExtension end )

spec:RegisterHook( "runHandler", function( action )
    local ability = class.abilities[ action ]
    local color = ability.color

    if color == "blue" then

        if buff.iridescence_blue.up then removeStack( "iridescence_blue" ) end
        if talent.charged_blast.enabled then
            addStack( "charged_blast", nil, ( min( active_enemies, ability.spell_targets ) ) )
        end

    elseif color == "red" then

       if buff.iridescence_red.up then removeStack( "iridescence_red" ) end

    else
        -- Other colors?
    end

    if ability.empowered then
        if talent.power_swell.enabled then applyBuff( "power_swell" ) end -- TODO: Modify Essence regen rate.
        if talent.animosity.enabled and animosity_extension < 4 then
            animosity_extension = animosity_extension + 1
            buff.dragonrage.expires = buff.dragonrage.expires + 5
        end
        if talent.iridescence.enabled and color then
                local iridescenceBuffType = "iridescence_" .. color -- Constructs "iridescence_red", "iridescence_blue", etc.
                applyBuff( iridescenceBuffType, nil, 2 ) -- Apply the dynamically determined buff with 2 stacks.
        end
        if talent.mass_disintegrate.enabled then
            addStack( "mass_disintegrate_stacks" )
        end
        if buff.tip_the_scales.up then
            removeBuff( "tip_the_scales" )
            setCooldown( "tip_the_scales", spec.abilities.tip_the_scales.cooldown )
        end
        removeBuff( "jackpot" )
    end

    if ability.spendType == "essence" then
        removeStack( "essence_burst" )
        if talent.enkindle.enabled then
            applyDebuff( "target", "enkindle" )
        end
        if talent.extended_battle.enabled then
            if debuff.bombardments.up then debuff.bombardments.expires = debuff.bombardments.expires + 1 end
        end
    end

    empowerment.active = false
end )

spec:RegisterGear({
    -- The War Within
    tww2 = {
        items = { 229283, 229281, 229279, 229280, 229278 },
        auras = {
            jackpot = {
                id = 1217769,
                duration = 40,
                max_stack = 2
            }
        }
    },
    -- Dragonflight
    tier31 = {
        items = { 207225, 207226, 207227, 207228, 207230 },
        auras = {
            emerald_trance = {
                id = 424155,
                duration = 10,
                max_stack = 5,
                copy = { "emerald_trance_stacking", 424402 }
            }
        }
    },
    tier30 = {
        items = { 202491, 202489, 202488, 202487, 202486, 217178, 217180, 217176, 217177, 217179 },
        auras = {
            obsidian_shards = {
                id = 409776,
                duration = 8,
                tick_time = 2,
                max_stack = 1
            },
            blazing_shards = {
                id = 409848,
                duration = 5,
                max_stack = 1
            }
        }
    },
    tier29 = {
        items = { 200381, 200383, 200378, 200380, 200382 },
        auras = {
            limitless_potential = {
                id = 394402,
                duration = 6,
                max_stack = 1
            }
        }
    }
})

local EmeraldTranceTick = setfenv( function()
    addStack( "emerald_trance" )
end, state )

local EmeraldBurstTick = setfenv( function()
    addStack( "essence_burst" )
end, state )

local ExpireDragonrage = setfenv( function()
    buff.emerald_trance.expires = query_time + 5 * buff.emerald_trance.stack
    for i = 1, buff.emerald_trance.stack do
        state:QueueAuraEvent( "emerald_trance", EmeraldBurstTick, query_time + i * 5, "AURA_PERIODIC" )
    end
end, state )

local QueueEmeraldTrance = setfenv( function()
    local tick = buff.dragonrage.applied + 6
    while( tick < buff.dragonrage.expires ) do
        if tick > query_time then state:QueueAuraEvent( "dragonrage", EmeraldTranceTick, tick, "AURA_PERIODIC" ) end
        tick = tick + 6
    end
    if set_bonus.tier31_4pc > 0 then
        state:QueueAuraExpiration( "dragonrage", ExpireDragonrage, buff.dragonrage.expires )
    end
end, state )

spec:RegisterHook( "reset_precast", function()
    animosity_extension = nil
    cycle_of_life_count = nil

    max_empower = talent.font_of_magic.enabled and 4 or 3

    if essence.current < essence.max and lastEssenceTick > 0 then
        local partial = min( 0.99, ( query_time - lastEssenceTick ) * essence.regen )
        gain( partial, "essence" )
        if Hekili.ActiveDebug then Hekili:Debug( "Essence increased to %.2f from passive regen.", partial ) end
    end

    if buff.dragonrage.up and set_bonus.tier31_2pc > 0 then
        QueueEmeraldTrance()
    end
end )

spec:RegisterStateTable( "evoker", setmetatable( {},{
    __index = function( t, k )
        if k == "use_early_chaining" then k = "use_early_chain" end
        local val = state.settings[ k ]
        if val ~= nil then return val end
        return false
    end
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

        -- Is this also impacting Eternity Surge?
        if settings.fire_breath_fixed > 0 then
            power_level = min( settings.fire_breath_fixed, power_level )
        end

        return stages[ power_level ] * ( talent.font_of_magic.enabled and 0.8 or 1 ) * ( buff.burning_adrenaline.up and 0.7 or 1 ) * haste
    end, state )
end
-- Support SimC expression release.dot_duration
spec:RegisterStateTable( "release", setmetatable( {},{
    __index = function( t, k )
        if k == "dot_duration" then
            return spec.auras.fire_breath.duration
        else return 0 end

    end
} ) )

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

        -- spend = 0.009,
        -- spendType = "mana",

        startsCombat = true,

        minRange = 0,
        maxRange = 25,

        damage = function () return stat.spell_power * 0.755 * ( debuff.shattering_star.up and 1.2 or 1 ) end, -- PvP multiplier = 1.
        critical = function() return stat.crit + conduit.spark_of_savagery.mod end,
        critical_damage = function () return talent.tyranny.enabled and 2.2 or 2 end,
        spell_targets = function() return talent.protracted_talons.enabled and 3 or 2 end,

        handler = function ()
            -- Many Color, Essence and Empower interactions have been moved to the runHandler hook
            if talent.azure_essence_burst.enabled and buff.dragonrage.up then addStack( "essence_burst", nil, 1 ) end
            if talent.charged_blast.enabled then addStack( "charged_blast", nil, min( active_enemies, spell_targets.azure_strike ) ) end
        end
    },

    -- Weave the threads of time, reducing the cooldown of a major movement ability for all party and raid members by 15% for 1 |4hour:hrs;.
    blessing_of_the_bronze = {
        id = 364342,
        cast = 0,
        cooldown = 15,
        gcd = "spell",
        school = "arcane",
        color = "bronze",

        spend = 0.01,
        spendType = "mana",

        startsCombat = false,
        nobuff = "blessing_of_the_bronze",

        handler = function ()
            applyBuff( "blessing_of_the_bronze" )
            applyBuff( "blessing_of_the_bronze_evoker")
        end
    },

    -- Talent: Cauterize an ally's wounds, removing all Bleed, Poison, Curse, and Disease effects. Heals for 4,480 upon removing any effect.
    cauterizing_flame = {
        id = 374251,
        cast = 0,
        cooldown = 60,
        gcd = "spell",
        school = "fire",
        color = "red",

        spend = 0.014,
        spendType = "mana",

        talent = "cauterizing_flame",
        startsCombat = true,

        healing = function () return 3.50 * stat.spell_power end,

        usable = function()
            return buff.dispellable_poison.up or buff.dispellable_curse.up or buff.dispellable_disease.up, "requires dispellable effect"
        end,

        handler = function ()
            removeBuff( "dispellable_poison" )
            removeBuff( "dispellable_curse" )
            removeBuff( "dispellable_disease" )
            health.current = min( health.max, health.current + action.cauterizing_flame.healing )
            if talent.everburning_flame.enabled and debuff.fire_breath.up then debuff.fire_breath.expires = debuff.fire_breath.expires + 1 end
        end
    },

    -- Take in a deep breath and fly to the targeted location, spewing molten cinders dealing 6,375 Volcanic damage to enemies in your path. Removes all root effects. You are immune to movement impairing and loss of control effects while flying.
    deep_breath = {
        id = function ()
            if buff.recall.up then return 371807 end
            if talent.maneuverability.enabled then return 433874 end
            return 357210
        end,
        cast = 0,
        cooldown = function ()
            return talent.onyx_legacy.enabled and 60 or 120
        end,
        gcd = "spell",
        school = "firestorm",
        color = "black",

        startsCombat = true,
        texture = 4622450,
        toggle = "cooldowns",
        notalent = "breath_of_eons",

        min_range = 20,
        max_range = 50,

        damage = function () return 2.30 * stat.spell_power end,

        usable = function() return settings.use_deep_breath, "settings.use_deep_breath is disabled" end,

        handler = function ()
            if buff.recall.up then
                removeBuff( "recall" )
            else
                setCooldown( "global_cooldown", 6 ) -- TODO: Check.
                applyBuff( "recall", 9 )
                buff.recall.applied = query_time + 6
            end

            if talent.terror_of_the_skies.enabled then applyDebuff( "target", "terror_of_the_skies" ) end
        end,

        copy = { "recall", 371807, 357210, 433874 }
    },

    -- Tear into an enemy with a blast of blue magic, inflicting 4,930 Spellfrost damage over 2.1 sec, and slowing their movement speed by 50% for 3 sec.
    disintegrate = {
        id = 356995,
        cast = function() return 3 * ( talent.natural_convergence.enabled and 0.8 or 1 ) * ( buff.burning_adrenaline.up and 0.7 or 1 ) end,
        channeled = true,
        cooldown = 0,
        gcd = "spell",
        school = "spellfrost",
        color = "blue",

        spend = function () return buff.essence_burst.up and 0 or ( buff.imminent_destruction.up and 2 or 3 ) end,
        spendType = "essence",

        cycle = function() if talent.bombardments.enabled and buff.mass_disintegrate_stacks.up then return "bombardments" end end,

        startsCombat = true,

        damage = function () return 2.28 * stat.spell_power * ( 1 + 0.08 * talent.arcane_intensity.rank ) * ( talent.energy_loop.enabled and 1.2 or 1 ) * ( debuff.shattering_star.up and 1.2 or 1 ) end,
        critical = function () return stat.crit + conduit.spark_of_savagery.mod end,
        critical_damage = function () return talent.tyranny.enabled and 2.2 or 2 end,
        spell_targets = function() if buff.mass_disintegrate_stacks.up then return min( active_enemies, 3 ) end
            return 1
        end,

        min_range = 0,
        max_range = 25,

        start = function ()
            -- Many Color, Essence and Empower interactions have been moved to the runHandler hook
            applyDebuff( "target", "disintegrate" )
            if buff.mass_disintegrate_stacks.up then
                if talent.bombardments.enabled then applyDebuff( "target", "bombardments" ) end
                removeStack( "mass_disintegrate_stacks" )
            end

            removeStack( "burning_adrenaline" )

            -- Legacy
            if set_bonus.tier30_2pc > 0 then applyDebuff( "target", "obsidian_shards" ) end

        end,

        tick = function ()
            if talent.causality.enabled then
                reduceCooldown( "fire_breath", 0.5 )
                reduceCooldown( "eternity_surge", 0.5 )
            end
            if talent.charged_blast.enabled then addStack( "charged_blast" ) end
        end
    },

    -- Talent: Erupt with draconic fury and exhale Pyres at 3 enemies within 25 yds. For 14 sec, Essence Burst's chance to occur is increased to 100%, and you gain the maximum benefit of Mastery: Giantkiller regardless of targets' health.
    dragonrage = {
        id = 375087,
        cast = 0,
        cooldown = 120,
        gcd = "off",
        school = "physical",
        color = "red",

        talent = "dragonrage",
        startsCombat = true,

        toggle = "cooldowns",

        spell_targets = function () return min( 3, active_enemies ) end,
        damage = function () return action.living_pyre.damage * action.dragonrage.spell_targets end,

        handler = function ()

            for i = 1, ( max( 3, active_enemies ) ) do
                spec.abilities.pyre.handler()
            end
            applyBuff( "dragonrage" )

            if set_bonus.tww2 >= 2 then
            -- spec.abilities.shattering_star.handler()
            -- Except essence burst, so we can't use the handler.
                applyDebuff( "target", "shattering_star" )
                if talent.charged_blast.enabled then addStack( "charged_blast", nil, min( action.shattering_star.spell_targets, active_enemies ) ) end
            end

            -- Legacy
            if set_bonus.tier31_2pc > 0 then
                QueueEmeraldTrance()
            end
        end
    },

    -- Grow a bulb from the Emerald Dream at an ally's location. After 2 sec, heal up to 3 injured allies within 10 yds for 2,208.
    emerald_blossom = {
        id = 355913,
        cast = 0,
        cooldown = function()
            if talent.dream_of_spring.enabled or state.spec.preservation and level > 57 then return 0 end
            return 30.0 * ( talent.interwoven_threads.enabled and 0.9 or 1 )
        end,
        gcd = "spell",
        school = "nature",
        color = "green",

        spend = 0.14,
        spendType = "mana",

        startsCombat = false,

        healing = function () return 2.5 * stat.spell_power end,   

        handler = function ()
            if state.spec.preservation then
                removeBuff( "ouroboros" )
                if buff.stasis.stack == 1 then applyBuff( "stasis_ready" ) end
                removeStack( "stasis" )
            end

            removeBuff( "nourishing_sands" )

            if talent.ancient_flame.enabled then applyBuff( "ancient_flame" ) end
            if talent.causality.enabled then reduceCooldown( "essence_burst", 1 ) end
            if talent.cycle_of_life.enabled then
                if cycle_of_life_count > 1 then
                    cycle_of_life_count = 0
                    applyBuff( "cycle_of_life" )
                else
                    cycle_of_life_count = cycle_of_life_count + 1
                end
            end
            if talent.dream_of_spring.enabled and buff.ebon_might.up then buff.ebon_might.expires = buff.ebon_might.expires + 1 end
        end
    },

    -- Engulf your target in dragonflame, damaging them for $443329s1 Fire or healing them for $443330s1. For each of your periodic effects on the target, effectiveness is increased by $s1%.
    engulf = {
        id = 443328,
        color = 'red',
        cast = 0.0,
        cooldown = 27,
        hasteCD = true,
        charges = function() return talent.red_hot.enabled and 2 or nil end,
        recharge = function() return talent.red_hot.enabled and 30 or nil end,
        gcd = "spell",

        spend = 0.050,
        spendType = 'mana',

        talent = "engulf",
        startsCombat = true,

        velocity = 80,

        handler = function()
            -- Assume damage occurs.
            if talent.burning_adrenaline.enabled then addStack( "burning_adrenaline" ) end
            if talent.flame_siphon.enabled then reduceCooldown( "fire_breath", 6 ) end
            if talent.consume_flame.enabled and debuff.fire_breath.up then debuff.fire_breath.expires = debuff.fire_breath.expires - 2 end
        end,

        impact = function() end,

        copy = { "engulf_damage", "engulf_healing", 443329, 443330 }
    },

    -- Talent: Focus your energies to release a salvo of pure magic, dealing 4,754 Spellfrost damage to an enemy. Damages additional enemies within 12 yds of the target when empowered. I: Damages 1 enemy. II: Damages 2 enemies. III: Damages 3 enemies.
    eternity_surge = {
        id = function() return talent.font_of_magic.enabled and 382411 or 359073 end,
        known = 359073,
        cast = empowered_cast_time,
        -- channeled = true,
        empowered = true,
        empowerment_default = function()
            local byCount = min( max_empower, active_enemies / ( talent.eternitys_span.enabled and 2 or 1 ) )
            local remainder = byCount % 1
            if remainder > 0 then byCount = byCount - remainder + 1 end
            return byCount
        end,
        cooldown = function() return 30 - ( 3 * talent.event_horizon.rank ) end,
        gcd = "off",
        school = "spellfrost",
        color = "blue",

        talent = "eternity_surge",
        startsCombat = true,

        spell_targets = function () return min( active_enemies, ( talent.eternitys_span.enabled and 2 or 1 ) * empowerment_level ) end,
        damage = function () return spell_targets.eternity_surge * 3.4 * stat.spell_power end,

        handler = function ()
            -- Many Color, Essence and Empower interactions have been moved to the runHandler hook

            -- TODO: Determine if we need to model projectiles instead.
            if talent.charged_blast.enabled then addStack( "charged_blast", nil, spell_targets.eternity_surge ) end

            if set_bonus.tier29_2pc > 0 then applyBuff( "limitless_potential" ) end
            if set_bonus.tier30_4pc > 0 then applyBuff( "blazing_shards" ) end
        end,

        copy = { 382411, 359073 }
    },

    -- Talent: Expunge toxins affecting an ally, removing all Poison effects.
    expunge = {
        id = 365585,
        cast = 0,
        cooldown = 8,
        gcd = "spell",
        school = "nature",
        color = "green",

        spend = 0.10,
        spendType = "mana",

        talent = "expunge",
        startsCombat = false,
        toggle = "interrupts",
        buff = "dispellable_poison",

        handler = function ()
            removeBuff( "dispellable_poison" )
        end
    },

    -- Inhale, stoking your inner flame. Release to exhale, burning enemies in a cone in front of you for 8,395 Fire damage, reduced beyond 5 targets. Empowering causes more of the damage to be dealt immediately instead of over time. I: Deals 2,219 damage instantly and 6,176 over 20 sec. II: Deals 4,072 damage instantly and 4,323 over 14 sec. III: Deals 5,925 damage instantly and 2,470 over 8 sec. IV: Deals 7,778 damage instantly and 618 over 2 sec.
    fire_breath = {
        id = function() return talent.font_of_magic.enabled and 382266 or 357208 end,
        known = 357208,
        cast = empowered_cast_time,
        -- channeled = true,
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
            if talent.mass_eruption.enabled then applyBuff( "mass_eruption_stacks" ) end -- ???

            applyDebuff( "target", "fire_breath" )
            applyDebuff( "target", "fire_breath_damage" )

            if set_bonus.tier29_2pc > 0 then applyBuff( "limitless_potential" ) end
            if set_bonus.tier30_4pc > 0 then applyBuff( "blazing_shards" ) end
        end,

        copy = { 382266, 357208 }
    },

    -- Talent: An explosion bombards the target area with white-hot embers, dealing 2,701 Fire damage to enemies over 12 sec.
    firestorm = {
        id = 368847,
        cast = function() return buff.snapfire.up and 0 or 2 end,
        cooldown = function() return buff.snapfire.up and 0 or 20 end,
        gcd = "spell",
        school = "fire",
        color = "red",

        talent = "firestorm",
        startsCombat = true,

        min_range = 0,
        max_range = 25,

        spell_targets = function () return active_enemies end,
        damage = function () return action.firestorm.spell_targets * 0.276 * stat.spell_power * 7 end,

        handler = function ()
            removeBuff( "snapfire" )
            applyDebuff( "target", "in_firestorm" )
            if talent.everburning_flame.enabled and debuff.fire_breath.up then debuff.fire_breath.expires = debuff.fire_breath.expires + 1 end
        end
    },

    -- Increases haste by 30% for all party and raid members for 40 sec. Allies receiving this effect will become Exhausted and unable to benefit from Fury of the Aspects or similar effects again for 10 min.
    fury_of_the_aspects = {
        id = 390386,
        cast = 0,
        cooldown = 300,
        gcd = "off",
        school = "arcane",

        spend = 0.04,
        spendType = "mana",

        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "fury_of_the_aspects" )
            applyDebuff( "player", "exhaustion" )
        end
    },

    -- Launch yourself and gain $s2% increased movement speed for $<dura> sec.; Allows Evoker spells to be cast while moving. Does not affect empowered spells.
    hover = {
        id = 358267,
        cast = 0,
        charges = function()
            local actual = 1 + ( talent.aerial_mastery.enabled and 1 or 0 ) + ( buff.time_spiral.up and 1 or 0 )
            if actual > 1 then return actual end
        end,
        cooldown = 35,
        recharge = function()
            local actual = 1 + ( talent.aerial_mastery.enabled and 1 or 0 ) + ( buff.time_spiral.up and 1 or 0 )
            if actual > 1 then return 35 end
        end,
        gcd = "off",
        school = "physical",

        startsCombat = false,

        handler = function ()
            applyBuff( "hover" )
        end
    },

    -- Talent: Conjure a path of shifting stone towards the target location, rooting enemies for 30 sec. Damage may cancel the effect.
    landslide = {
        id = 358385,
        cast = function() return ( talent.engulfing_blaze.enabled and 2.5 or 2 ) * ( buff.burnout.up and 0 or 1 ) end,
        cooldown = function() return 90 - ( talent.forger_of_mountains.enabled and 30 or 0 ) end,
        gcd = "spell",
        school = "firestorm",
        color = "black",

        spend = 0.014,
        spendType = "mana",

        talent = "landslide",
        startsCombat = true,

        toggle = "cooldowns",

        handler = function ()
        end
    },

    -- Send a flickering flame towards your target, dealing 2,625 Fire damage to an enemy or healing an ally for 3,089.
    living_flame = {
        id = 361469,
        cast = function() return ( talent.engulfing_blaze.enabled and 2.3 or 2 ) * ( buff.ancient_flame.up and 0.6 or 1 ) * haste end,
        cooldown = 0,
        gcd = "spell",
        school = "fire",
        color = "red",

        spend = 0.12,
        spendType = "mana",

        velocity = 45,
        startsCombat = true,

        damage = function () return 1.61 * stat.spell_power * ( talent.engulfing_blaze.enabled and 1.4 or 1 ) end,
        healing = function () return 2.75 * stat.spell_power * ( talent.engulfing_blaze.enabled and 1.4 or 1 ) * ( 1 + 0.03 * talent.enkindled.rank ) * ( talent.inner_radiance.enabled and 1.3 or 1 ) end,
        spell_targets = function () return buff.leaping_flames.up and min( active_enemies, 1 + buff.leaping_flames.stack ) end,

        handler = function ()
            -- Many Color, Essence and Empower interactions have been moved to the runHandler hook
            if buff.burnout.up then removeStack( "burnout" )
            else removeBuff( "ancient_flame" ) end

            if talent.ruby_essence_burst.enabled and buff.dragonrage.up then
                addStack( "essence_burst", nil, buff.leaping_flames.up and ( true_active_enemies > 1 or group or health.percent < 100 ) and 2 or 1 )
            end

            removeBuff( "leaping_flames" )
            removeBuff( "scarlet_adaptation" )

        end,

        impact = function() 
            if talent.ruby_embers.enabled then addStack( "living_flame" ) end
        end,

        copy = "living_flame_damage"
    },

    -- Talent: Reinforce your scales, reducing damage taken by 30%. Lasts 12 sec.
    obsidian_scales = {
        id = 363916,
        cast = 0,
        charges = function() return talent.obsidian_bulwark.enabled and 2 or nil end,
        cooldown = 90,
        recharge = function() return talent.obsidian_bulwark.enabled and 90 or nil end,
        gcd = "off",
        school = "firestorm",
        color = "black",

        talent = "obsidian_scales",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "obsidian_scales" )
        end
    },

    -- Let out a bone-shaking roar at enemies in a cone in front of you, increasing the duration of crowd controls that affect them by $s2% in the next $d.$?s374346[; Removes $s1 Enrage effect from each enemy.][]
    oppressing_roar = {
        id = 372048,
        cast = 0,
        cooldown = function() return 120 - 30 * talent.overawe.rank end,
        gcd = "spell",
        school = "physical",
        color = "black",

        talent = "oppressing_roar",
        startsCombat = true,

        toggle = "interrupts",

        handler = function ()
            applyDebuff( "target", "oppressing_roar" )
            if talent.overawe.enabled and debuff.dispellable_enrage.up then
                removeDebuff( "target", "dispellable_enrage" )
                reduceCooldown( "oppressing_roar", 20 )
            end
        end
    },

    -- Talent: Lob a ball of flame, dealing 1,468 Fire damage to the target and nearby enemies.
    pyre = {
        id = 357211,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "fire",
        color = "red",

        spend = function()
            if buff.essence_burst.up then return 0 end
            return 3 - talent.dense_energy.rank - ( buff.imminent_destruction.up and 1 or 0 )
        end,
        spendType = "essence",
        timeToReadyOverride = function()
            return buff.essence_burst.up and 0 or nil -- Essence Burst makes the spell ready immediately.
        end,

        talent = "pyre",
        startsCombat = true,

        handler = function ()
            -- Many Color, Essence and Empower interactions have been moved to the runHandler hook
            removeBuff( "feed_the_flames_pyre" )

            if talent.causality.enabled then
                reduceCooldown( "fire_breath", min( 2, true_active_enemies * 0.4 ) )
                reduceCooldown( "eternity_surge", min( 2, true_active_enemies * 0.4 ) )
            end
            if talent.feed_the_flames.enabled then
                if buff.feed_the_flames_stacking.stack == 8 then
                    applyBuff( "feed_the_flames_pyre" )
                    removeBuff( "feed_the_flames_stacking" )
                else
                    addStack( "feed_the_flames_stacking" )
                end
            end
            removeBuff( "charged_blast" )

            -- Legacy
            if set_bonus.tier30_2pc > 0 then applyDebuff( "target", "obsidian_shards" ) end
        end
    },

    -- Talent: Interrupt an enemy's spellcasting and preventing any spell from that school of magic from being cast for 4 sec.
    quell = {
        id = 351338,
        cast = 0,
        cooldown = function () return talent.imposing_presence.enabled and 20 or 40 end,
        gcd = "off",
        school = "physical",

        talent = "quell",
        startsCombat = true,

        toggle = "interrupts",
        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
        end
    },

    -- Talent: The flames of life surround you for 8 sec. While this effect is active, 100% of damage you take is healed back over 8 sec.
    renewing_blaze = {
        id = 374348,
        cast = 0,
        cooldown = function () return talent.fire_within.enabled and 60 or 90 end,
        gcd = "off",
        school = "fire",
        color = "red",

        talent = "renewing_blaze",
        startsCombat = false,

        toggle = "defensives",

        -- TODO: o Pyrexia would increase all heals by 20%.

        handler = function ()
            if talent.everburning_flame.enabled and debuff.fire_breath.up then debuff.fire_breath.expires = debuff.fire_breath.expires + 1 end
            applyBuff( "renewing_blaze" )
            applyBuff( "renewing_blaze_heal" )
        end
    },

    -- Talent: Swoop to an ally and fly with them to the target location.
    rescue = {
        id = 370665,
        cast = 0,
        cooldown = 60,
        gcd = "spell",
        school = "physical",

        talent = "rescue",
        startsCombat = false,
        toggle = "interrupts",

        usable = function() return not solo, "requires an ally" end,

        handler = function ()
            if talent.twin_guardian.enabled then applyBuff( "twin_guardian" ) end
        end
    },

    action_return = {
        id = 361227,
        cast = 10,
        cooldown = 0,
        school = "arcane",
        gcd = "spell",
        color = "bronze",

        spend = 0.01,
        spendType = "mana",

        startsCombat = true,
        texture = 4622472,

        handler = function ()
        end,

        copy = "return"
    },

    -- Talent: Exhale a bolt of concentrated power from your mouth for 2,237 Spellfrost damage that cracks the target's defenses, increasing the damage they take from you by 20% for 4 sec.
    shattering_star = {
        id = 370452,
        cast = 0,
        cooldown = 20,
        gcd = "spell",
        school = "spellfrost",
        color = "blue",

        talent = "shattering_star",
        startsCombat = true,

        spell_targets = function () return min( active_enemies, talent.eternitys_span.enabled and 2 or 1 ) end,
        damage = function () return 1.6 * stat.spell_power end,
        critical = function () return stat.crit + conduit.spark_of_savagery.mod end,
        critical_damage = function () return talent.tyranny.enabled and 2.2 or 2 end,

        handler = function ()
            applyDebuff( "target", "shattering_star" )
            if talent.arcane_vigor.enabled then addStack( "essence_burst" ) end
            if talent.charged_blast.enabled then addStack( "charged_blast", nil, min( action.shattering_star.spell_targets, active_enemies ) ) end
            if set_bonus.tww2 >= 4 then addStack( "jackpot" ) end
        end
    },

    -- Talent: Disorient an enemy for 20 sec, causing them to sleep walk towards you. Damage has a chance to awaken them.
    sleep_walk = {
        id = 360806,
        cast = function() return 1.7 + ( talent.dream_catcher.enabled and 0.2 or 0 ) end,
        cooldown = function() return talent.dream_catcher.enabled and 0 or 15.0 end,
        gcd = "spell",
        school = "nature",
        color = "green",

        spend = 0.01,
        spendType = "mana",

        talent = "sleep_walk",
        startsCombat = true,

        toggle = "interrupts",

        handler = function ()
            applyDebuff( "target", "sleep_walk" )
        end
    },

    -- Talent: Redirect your excess magic to a friendly healer for 30 min. When you cast an empowered spell, you restore 0.25% of their maximum mana per empower level. Limit 1.
    source_of_magic = {
        id = 369459,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "spellfrost",
        color = "blue",

        talent = "source_of_magic",
        startsCombat = false,

        handler = function ()
            active_dot.source_of_magic = 1
        end
    },

    -- Evoke a paradox for you and a friendly healer, allowing casting while moving and increasing the range of most spells by $s4% for $d.; Affects the nearest healer within $407497A1 yds, if you do not have a healer targeted.
    spatial_paradox = {
        id = 406732,
        color = 'bronze',
        cast = 0.0,
        cooldown = 180,
        gcd = "off",

        talent = "spatial_paradox",
        startsCombat = false,
        toggle = "cooldowns",

        handler = function()
            applyBuff( "spatial_paradox" )
        end,

    },

    swoop_up = {
        id = 370388,
        cast = 0,
        cooldown = 90,
        gcd = "spell",

        pvptalent = "swoop_up",
        startsCombat = false,
        texture = 4622446,

        toggle = "cooldowns",

        handler = function ()
        end
    },

    tail_swipe = {
        id = 368970,
        cast = 0,
        cooldown = function() return 180 - ( talent.clobbering_sweep.enabled and 120 or 0 ) end,
        gcd = "spell",

        startsCombat = true,
        toggle = "interrupts",

        handler = function()
            if talent.walloping_blow.enabled then applyDebuff( "target", "walloping_blow" ) end
        end
    },

    -- Talent: Bend time, allowing you and your allies to cast their major movement ability once in the next 10 sec, even if it is on cooldown.
    time_spiral = {
        id = 374968,
        cast = 0,
        cooldown = 120,
        gcd = "spell",
        school = "arcane",
        color = "bronze",

        talent = "time_spiral",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            applyBuff( "time_spiral" )
            active_dot.time_spiral = group_members
            setCooldown( "hover", 0 )
        end
    },

    time_stop = {
        id = 378441,
        cast = 0,
        cooldown = 120,
        gcd = "off",
        icd = 1,

        pvptalent = "time_stop",
        startsCombat = false,
        texture = 4631367,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "target", "time_stop" )
        end
    },

    -- Talent: Compress time to make your next empowered spell cast instantly at its maximum empower level.
    tip_the_scales = {
        id = 370553,
        cast = 0,
        cooldown = 120,
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

    -- Talent: Sunder an enemy's protective magic, dealing 6,991 Spellfrost damage to absorb shields.
    unravel = {
        id = 368432,
        cast = 0,
        cooldown = 9,
        gcd = "spell",
        school = "spellfrost",
        color = "blue",

        spend = 0.01,
        spendType = "mana",

        talent = "unravel",
        startsCombat = true,
        debuff = "all_absorbs",
        spell_targets = 1,

        usable = function() return settings.use_unravel, "use_unravel setting is OFF" end,

        handler = function ()
            removeDebuff( "all_absorbs" )
            if buff.iridescence_blue.up then removeStack( "iridescence_blue" ) end
            if talent.charged_blast.enabled then addStack( "charged_blast" ) end
        end
    },

    -- Talent: Fly to an ally and heal them for 4,557.
    verdant_embrace = {
        id = 360995,
        cast = 0,
        cooldown = 24,
        gcd = "spell",
        school = "nature",
        color = "green",
        icd = 0.5,

        spend = 0.10,
        spendType = "mana",

        talent = "verdant_embrace",
        startsCombat = false,

        usable = function()
            return settings.use_verdant_embrace, "use_verdant_embrace setting is off"
        end,

        handler = function ()
            if talent.ancient_flame.enabled then applyBuff( "ancient_flame" ) end
        end
    },

    wing_buffet = {
        id = 357214,
        cast = 0,
        cooldown = function() return 180 - ( talent.heavy_wingbeats.enabled and 120 or 0 ) end,
        gcd = "spell",

        startsCombat = true,

        handler = function()
            if talent.walloping_blow.enabled then applyDebuff( "target", "walloping_blow" ) end
        end,
    },

    -- Talent: Conjure an updraft to lift you and your 4 nearest allies within 20 yds into the air, reducing damage taken from area-of-effect attacks by 20% and increasing movement speed by 30% for 8 sec.
    zephyr = {
        id = 374227,
        cast = 0,
        cooldown = 120,
        gcd = "spell",
        school = "physical",

        talent = "zephyr",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "zephyr" )
            active_dot.zephyr = min( 5, group_members )
        end
    },
} )

spec:RegisterSetting( "dragonrage_pad", 0.5, {
    name = strformat( "%s: %s 缓冲", Hekili:GetSpellLinkWithTexture( spec.abilities.dragonrage.id ), Hekili:GetSpellLinkWithTexture( spec.talents.animosity[2] ) ),
    type = "range",
    desc = strformat( "如果设置大于0，则会分配额外的时间，以确保在 %s 持续时使用 %s 和 %s，减少无法延长它的风险。"
        .. "\n\n如果没有 %s 天赋支撑，这个设置将被忽略。", Hekili:GetSpellLinkWithTexture( spec.abilities.fire_breath.id ),
        Hekili:GetSpellLinkWithTexture( spec.abilities.eternity_surge.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.dragonrage.id ),
        Hekili:GetSpellLinkWithTexture( spec.talents.animosity[2] ) ),
    min = 0,
    max = 1.5,
    step = 0.05,
    width = "full",
} )

spec:RegisterStateExpr( "dr_padding", function()
    return talent.animosity.enabled and settings.dragonrage_pad or 0
end )

spec:RegisterSetting( "use_deep_breath", true, {
    name = strformat( "使用 %s", Hekili:GetSpellLinkWithTexture( spec.abilities.deep_breath.id ) ),
    type = "toggle",
    desc = strformat( "如果勾选，可能会推荐使用 %s，这将迫使你的角色选择一个目的地进行移动。"
        .. "默认情况下，&s 需要【爆发】开关处于激活状态。\n\n"
        .. "如果不勾选，|W%s|w 将永远不会被推荐，如果一直不使用，可能会导致DPS损失。",
        Hekili:GetSpellLinkWithTexture( spec.abilities.deep_breath.id ), spec.abilities.deep_breath.name, spec.abilities.deep_breath.name ),
    width = "full",
} )

spec:RegisterSetting( "use_unravel", false, {
    name = strformat( "使用 %s", Hekili:GetSpellLinkWithTexture( spec.abilities.unravel.id ) ),
    type = "toggle",
    desc = strformat( "如果勾选，若你的目标拥有减伤盾，%s 可能会被推荐。默认情况下，|W%s|w 需要|cFFFFD100【打断】|r 开关处于激活状态。",
        Hekili:GetSpellLinkWithTexture( spec.abilities.unravel.id ), spec.abilities.unravel.name ),
    width = "full",
} )

spec:RegisterSetting( "fire_breath_fixed", 0, {
    name = strformat( "%s: 授权", Hekili:GetSpellLinkWithTexture( spec.abilities.fire_breath.id ) ),
    type = "range",
    desc = strformat( "如果设置为 |cffffd1000|r，%s 将根据优先级列表被推荐不同的授权级别。\n\n"
        .. "要强制使用特定等级的 %s，请将其设置为 1、2、3 或 4。\n\n"
        .. "如果所选授权级别超过了您的最大值，则将使用最大值。", Hekili:GetSpellLinkWithTexture( spec.abilities.fire_breath.id ),
        spec.abilities.fire_breath.name ),
    min = 0,
    max = 4,
    step = 1,
    width = "full"
} )

spec:RegisterSetting( "use_early_chain", false, {
    name = strformat( "%s: 链接通道", Hekili:GetSpellLinkWithTexture( spec.abilities.disintegrate.id ) ),
    type = "toggle",
    desc = strformat( "如果勾选，%s 可能会在正在引导|W%s|w 时被推荐，用于延长通道。",
        Hekili:GetSpellLinkWithTexture( spec.abilities.disintegrate.id ), spec.abilities.disintegrate.name ),
    width = "full"
} )

spec:RegisterSetting( "use_clipping", false, {
    name = strformat( "%s: 中断通道", Hekili:GetSpellLinkWithTexture( spec.abilities.disintegrate.id ) ),
    type = "toggle",
    desc = strformat( "如果勾选，在 %s 期间可能会打断通道推荐其他技能。", Hekili:GetSpellLinkWithTexture( spec.abilities.disintegrate.id ) ),
    width = "full",
} )

spec:RegisterSetting( "use_verdant_embrace", false, {
    name = strformat( "%s: %s", Hekili:GetSpellLinkWithTexture( spec.abilities.verdant_embrace.id ), Hekili:GetSpellLinkWithTexture( spec.talents.ancient_flame[2] ) ),
    type = "toggle",
    desc = strformat( "如果勾选，%s 可能被推荐用于 %s。", spec.abilities.verdant_embrace.name, spec.auras.ancient_flame.name ),
    width = "full"
} )

spec:RegisterRanges( "azure_strike" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    gcdSync = false,

    nameplates = false,
    rangeChecker = 30,

    damage = true,
    damageDots = true,
    damageOnScreen = true,
    damageExpiration = 8,

    potion = "tempered_potion",

    package = "湮灭Simc",
} )

spec:RegisterPack( "湮灭Simc", 20250325, [[Hekili:S3ZAZXTns(BX1wrwAt8ynJKI9MkwBzBzN15YMKkJ2n1vxDIIdhmA4AoKC5djRuUMF7x3aGKaGaGyi5iBx79b)qIGnA0OF3naVA6vxE18L(fKR(5zhp7SJpz2ztME8SRMxCFk5Q5P(bV3)g4)e7Vb(7li36Nx4xeMeJp7(Oe)LiaYtkZcGNVUOin)7E6tVjSyD5IjbjBEAE4MYi6BeK5VQa)5GNUikzXtlwtUZp7oyOHXpLeFtym5Pbr(55EBswwgrYFQFAe(hpYTjVNKnjin9Q5lkdJkEx8vl0G2t)lNc4skj4QFE6PF7Za8jC5scBSK8GRMJJ9jhFYtMD23T965HBE92R)hPiy2(JB)XQho946hwYE41hwKfg)EsXrIJ74tyJlOEC1pC2tM9C4Hx(7)omcIFEs82RNPmStFYX)LNmBQYCLl(0PiA(YOOK72E9fz(3Ked)fGoHa4E5V8MMH(SNm7zFZ2RHx54t5)lo))doiVEvwYg(8i(o4c4Y1aa)D)m4VO7exnpkmVih3vj4F)ZuoesS)IiYYRE1vZ9dyB)KcswCyX9E5LzihcztAYDKmVIKRMp9Q5b3her8k8HNbq7NXFtwi8kH(mqClXJet2eIO33)ITxpD71F92Rl8JiXftQGDUxEQF8e(SV96p(ryVy7136dGb(ntc8J9iFOGeV0BjScoOga(XHBsYbii)U8NUbzYwgMhgxqUjdirnJ6ikuurWZPt7jIO4QK4cVKvEB8VjmO59HbC62R)ZDUsoIHqlkxTAYY6T2jzKn(HXijbOitE2zuqbC0rrERbjpcf7m(sNZOJAEfZKLdmrozYmzHPST73WxiaBeUFdCzL5aSZ8JF)2RbGwauT00OWaesWeMGtkDZFYvfGuAp4IMT7CrZO7aZCzhOlY)Sj9H6Rzpdx(N0JL)j7(YNXHEIRl)h1f38bUiYyNqIy1Kz9GuQH(JuYt7bL8u7us3wI6O3N6QapG5fxnF1cBkuxfMr8wKr8lw3woqfzZdsYca1134r2SGKLlTNb6QcssIwMChIa3ugTsEdzzzg1Imf7pgPZ4cu9vktRuhwT0y)EXzkJebM3itwMu41avCowfEZ6cp(0QOl5TWkD71VIUuLvKaQqYssHfAHKoee5kJlEkdrSRrrIm(5kD7qNjDokPEKQUdlkD(IGczB5QkDBrTGH16H0LYdI13J6Rby9QDytYr7M0NSVza56SXMCnAwlhmbRt2yDu1Zz(omaY6mKS(T7gzTtPAU)UwP9JPb29pXFau4tygrxsw5xgvyZsAAc7FLm6CbjYh8EfEglaQ5xc)7QTxFFsjWpGgK8xKuwWm7mF(2RFcZV2O7z47T(XWdxLaR0KuGXb(37wtW3JcH7Op(IF7jN)2x9KZNp)jNNLufPSKGuZMUWgJvNPAuxYE9A1P5R9lqad0ziQ8m6araSKqbHYJ94)6QrzwgGIej5505uXAeiRFYz6S)MabNNtkA2fQ4tW)xuj8p14Tw(4)AfREJ1cjx6AgkSX8CkEE(Fv(feeZ0m6Juyi(NC8d2pac12RjiAYIxg2yboKyG5giMIbEdpBbWpCxs27bYkWjqzyWqO34)HWnLqu2lif3rWxN(RfF7ay)1pEjLHb4E4825GhqH3eNKrb4RV43GNSAfjaXO8IWnignHsn9yjHbrlVg4QZsV19Ik4KcKnpGF2lCPg3ac3Sjmg(paxtErwjfon2FRecNFSMDxcjT1UaW28mk7ejpNehaI(KvHbHf1MnpGYAtzq5dXBrzwEbLDL7XKF4spYTuntlxMpbLIX3MTiLM3kKHQG74jNkh(pjQWZpBtsM(iDIjL3sY8xeg1kbc6KzobzT04cItBckHC3ABOLkyfM4)N3SeEJLm2Y53NfU6)LYYx)EmONtvWMrkkZWDdkRzCjQBg4HbLG1dcEykjd4k2GaLQTRynY23WWv5XEivrky1WFjdiuOgKSjnI8HTx)YF9NWFkgWpeU18j60UX2F1IZFpn(QJ050Ite4AU8Gf6n9UicS85Tcim(beDmewDiMpMG1yCkl9Oat3acZcX9nkRVMhl7aSD5lTA54r)FGf)ZpF71N1LiOg5pW0rW7P7dAEiO1ZJpGQ3wMuWFiAA5yDEijXm)BLPC7VB8FpHZqHs9G3clrw11q8H33SF)VlbpxUAoWnc(oTY7MGLOpbWS8mCwQgvjWNDljsCAHH8Cd(oe4dodX(bpmtOS8HYzM4PbohbWFrbaMZmdvjbWQcVDqbn3dvtwwzSX5YpHQAF6XgquBVBEbZxP0mcipUWxR3sDBWMVCNumDc4EOhsNXTyUY0pTpmmFYMWSmqWgCBEvgSgkZaUUIeqTEwYD56EHCWolH6NnWz5LMfMKDVOUc(O9MsNY8(5Lt9uoZ2c4tZd3rI2SDHOnRHOTtUJqjAK)DzyAkz5KfOppX5rjf5ItYDe)uGrVEgmyRnCLDJbCWKFFCGOaRPzhqnpsuo8Ihp5SACvBa09BjsDp5SPNYsy90Zu0h(3VhS9gagxJjOUVSLbjlr7gG99lbLKxa)jeT2UHGXEKNSHGvW5gw8n50ktHkt)xLy25PPrJQrLIqt0rxGaw8yORgv1c04gsxDWGkYov20feaBCqSoIVVsWCLGlbnda0CESsoK0oUVQRzQbqYQewNWSE4faK382bjCbjamCJreegSU(Lz01u)qmiWWI1ILNdCpcu7UcnxbBRGt0LyC1u)(N28Z1ws0Q(HXGAGvYel5Z6NmrJ8RQyrR92zg2BN9GT3QDM0S3oZWERvcOQlbDltlZlTGebQrH)kNQQmVmgDMGKPJVl((nLeqtnZ3eAi6PHXlXOr1y3k9(ny6zYY9UJSqTWCvbjcmzn8vCPCwCbOp5aQJAg4(OxfDuTB783dyExgEB4YQikyXWwtPRhoZ6c67yAwco(8jBV(V5ZWbSakW6gJGDtYYWvHij4WGsG2ettNY0jN9HJyYq3aEkrFP1H3Sghh1adToJ4Jfav1kBcVM1ANLCyppcXDCvU2p(gCHGOLWOBMHW4GmmpuWZXaDws4)imfVeZca8gS32xCoObfHzoYxqFWDH4ytYQ(FXyAMqbQkfev0C5y5Be5HWol9J05y5oWgoBhydNTlSHZ0XgQthsZYOLJRDVoowpPjbCShKHPo1(Zt3D3y1c2zkGDao6rLrZkxCV3DRjrPE5RPmoTLJbJi5PSeYbSE(qeNfeVWao0BTUjFiiQCjlkGD3Lk59UoqVz7m6ntc96P)yvaRsKujcDRoxy26eUY6Y2LS5l8rcjI(iQ7yhQfkmzA2ieGGSB3hv1YiYEa580mv)0OgsKIbTP1790Irm1GpQ7ZnfDpx)(slxoPl1wpMsgQPL79DTMSqVp32ATZ1csn0E(okTGUtn4sUlAbmgaSyhZiPoqFGFAIAspu1jI2y6LLselmD4YTNE0U0Fd4bP3EJp(azkv0TrSC8isRHFPDHZD3zZPtoUvdXOK)mApumTU0c8XcoF4Jrac(jkrNYMsn)5r)9ioPZZJmsNPyDzgqJjPu44HPTQj9LNASMluVOy1zbD0dlqfGIRbNKO(PwvCe(altbFyPpaRpcT)htEZeAKWVL2BJBqhgPbwdJ50CcifMtiBG3pkSovI53rahittq3CxGvUjS4XONYeKFfap1jWquenhqPvytrctWFRcNOyYMKmwfJaC4BXjbtXDoZx4fKBOzAfxqlWmVXCTf8eJ3Yk6CjYbcSuoSfsnmcsDUd5aiL2ZYfkR68NV32YMFjJkOZvlhq5wDNOeDqNdsoa007Zuw)mWTtfZHkEQs3yn)lOyDEbO2qCobhUZXvrXAabrYhDgn1sga35s)4cS4dz(bQI8)ag8XCkNgqGYIWF8Ll9tl4gR(vytUetsUM(8HoCp)6rxx(beDun1069XYqKxKKTrTbHAkTIAB9Goa08uQlPT6pGMfE9eqXhvBbA7II2OKqz)m3KrAWKg0icIhg8iEvKpvlzblZ8w6(aLYUBV3dpuF2p4ffRQiGzaVpX72WBelzP4sZqtEEG(2w8KQ(jW0wLctg2R58QSI6tZr9N)skQhGfBlUmrnERO6grXDQ(bFEO93eLSWpINdmUwd2l6JTMobg1BE12R3E9R8l38AAu7GhjFhMGZ4hJvGpHff(BznLXptklYyXyQQjPHUkuR4nj3sZqkTEXFpvRTqXMxdpnRIEdrek3Jm0wy7GMoWPvpIYQ(vUYgw)ALubEFkwPRYw26PpMWI8w3CyBclKB1JPjSjaMZxo)L)QibJU8YJ9tXHwTCeeTiyDca37OYb5IQkm16Dc1JxbPe3NPhackoEXRK5HWuSGB50)C5BP79F9jh)EMXKZUuBl8AO29cBn6l()Jm0gjnectTLsv70yNqzUyVsvj2wtxOPQdDT7)YaWh9Sk3FyrFilM9NWZaY)fStX8GHDqrOLAWN7mLaRZDRdJQag2HuSgkI1wmzLXXW4bFYE32RFFmEKv45AK3baSHDJF2cAZWW9)I1ln5Sn3zw3CTrz70SJTQIFQ(HWkKDUy(Lfd6tPnCysXSnepP2pz6KzQM(015xhX7YbRvi)hawBGcNfcVWVrtsBLaJaIG6wPnM0nzHKvmFZQAOIgEM2f6UffxhAEGvdwhU1AdpiiN0vlcAF7K7RjYWj1BLc1aF1I6IIuRrQPPPeOWAY8F1lueMYYHkqSiQDX(LHWA(nGya28ySgxN336I9SopPWuVMtJ8VNUD8wkh8A)uA)3aZq2DHyl1qb5BF142XGD34iD2XDCE)ohNeW0oDn66m1i7DS7FKUuKB01lJMDyUxO1VIpB8otVRz6sTUOKlY7nHgwxrc4dcH3)jZ076X519nKP3CkVj(T1qOhRvgtx26L2qEnnTeINgeytzo2FTawe(h0GsG9PFjglAelhgOtb8kjXXKQkUerF(ZZ)AMehO4bf)i0)lnaD03vcUgybVFYX5UPmS3sGMkTPOTNAZjQjrr1KH9t0i1KOxEy66KyvzPdnV3(CjGy)yrUtQDBvoLVaiNITynD()xGN9Pjf1t(JW09u4TijUmFsXD3nZ700G(tbvpXAM5ffiVKCTLdskAyDeVd012F0CWQZDDDL0PVH3sXME3sH7pDS4lRB78aLD)gKDMmpsF828772BZZPEBQ2hkSqKqNUzUsesJlMKtdqgdwCf9uI)Mx9nc()rjx4QeFx0d8xFHQ))0ZWonqDe20e39gkc12JCDLuQIPGTi6KxyzsHOIdpwM6vowkcuzZoBF(aD2wTnQfAD6FK1UujS(LiH3TZpE2JB1UZOJFx8QxJnw9ksgYdR22ZqOq4a)G2Q3Oe8T2gNLAbEwlx5mO(dZFbi)qPeN6iDOAleZeQ2QUuRGqqVM9D6rkvj1sA1Sbchzbb7egNjj)sTpuo5MvypLtX40T6o(i)dKR4V7JouCHaazUO86xHb2gxujDg4NQTQpDNRe60Cbna9kxKO3MexITHFmZHg80qu5geRQdvHfgw8y8xITdd8Ylb3O8VXhLNR6Hf2UasTF3ft0ecOTmsu5PUgL4LPAlOKeVM868xVhX3tV8RPYGNG)llhH)Ze86djIw1WNWegy7zmPqKsd)6Ff4my)avh2f)MIMhD(9Ek9nRmrPDLYdKsWqZT1OZogwBJLi9AbB0PjIN0JVcEkjBho3yPdqEegojd1HLPxwu2XjRI(1ITA9jGzaOZXmv0JggL7qQv9N44UP6REMdV6FUY40rAlMxfZTubd6YIydHhwIXGvBn(bx9KwobBmGErEGZeGKMA(iTL4hheIRCkUlKfb6dJi(P1lSCHm(ysfGrVoN2N1Xjnys)8Muvbol6ZF6TvkA4RpqdcDbIvWe1r(D8M5Ro5n8TJVP()XYSjoA2XLIuD0bX11cUsBCi5jabxBvBbPo8Q3zQck(FNGDuWsoqxkzMjk5gS3W5xTpxQJtdhDwwzAHh2Ye8BrjSMcbrHP4A9G2HkCqriiPE(lMDWH6RHY5Z(4hLQCcE1daSv37rxeQtLWJWjSpqxsGXuHDoxwXrtzDCsZLHkY0Tlg0zWGps6Q19URKOYWsvPzenOOOEOdg8A2v0P2vH5R5glRanV2qAlNE7Io)sMUcEYm5zsleB0u3sRsDG4IQC05zrBLscpuI3vks5BYiKyT1Y3nARAeE42fyu8pQhLXseBUw(()rjTDdYcFVQ)pVfivlO6PwXjITykOfFM3KrwVAUuBuxfpZ1M2(2z1B6jhlP)xaQzK0Km5yu4MzqVPmLOq02UAh)lCJGCGXqQ1dRtpM(e7(dXh3rv3GDkKgn1qUIigtGOaIWo6Zpf1JfdrmhqY6IA6M)wDI0NvHWMqdl1cMZIaArWdzK4p7cJWHD06B7qLs1D)eG7Ynnpx9qRx8hjO1vU8lYECyDsetmKA9dOWWENjoTMxEGlw(IXqs3LsMKCtP2Ktd6sXgbdhGtlhn7Q8w4wNrYMUIK1s)kysRUIfxtAU4IeEHgEEPB8JV94kYGLS90O5OJ8zO6tQgPZojwDtmuReOWjOPYyl1Jn6HAbncxDtoSKFUC(MQW1XiZb3KwsDwKEj6H5Qdpzz4Vt9SLHN9fU()TS7Se27I0YtLJl(nBiGEJL4lGkmeYwqTJSltkxG1ZhjuBfobqf0mmsp0HuhBPtH)kATuMp)PV9vCSuWtxwYfb07xAorCnnQPTUeHpTZ6VYPP7hLtt)mv50SpHkNMAt5Kocw3YBZmmOPUOCAMELtToAaDPCs7Xk8ZqLtZCHyOy2FMTghcjgEGhfs3am1qw8ux7Q7bh6G5QUP7ZoUM)u)sLpHDzxRBs6j6k3Govlh6aRE3w76yHn16cBAFxydutX(wN3dK(mxkR0dNS8jUmOPDBtQBGmZbVURuA0OqqtRO1DagknS6apXnn(EQSVz4e(i6T7UOeQ1zB1f1uVGvN2kCtU1H5LnITUsZi3IuKjtfVJQgx(rN0uAFjZWf7H6)915twXCknhaycd(ABlNJANf23Tc9EeBWhQdNiLLwVvoU2CaZPDloIDv3)uu3pPnph71Q3JyEHIv3kMeYEE3qBrsvP1QHtD)dA1TvfJT7OiWSop0z9qeyMJEMjmGUebSCPA85UiWuTIaAxYpuIa2A50ADP)NJUt94F95Z)HHn5ZrnLkMxT05Rn6F(ph9n6X)hy2Mpd1U0o(Vc6vcNMkgi3JzxU96xgWi1)e7uEXoGS41Fcjpx(uZEdPGDarwqqxXFuvcRF)A8MJiI8b2z1aZQLxeUwCRlfTF31Ys7Wbwld432ivygx0K4F9NCMCA)0SH2NpYfGTUn7UR6OYu15a4QOU1b2sp31tCROynm9TimU2qoD3xvi3LL(qTv3MAUzthVtzxB)MQix8JcN0UZFNpzaFkwf8Vbp5e42uEAygQ7IxB8nS(dpMGRA2gzXDeF8Q7vxkjn0ygM0gOJbUwJJ2azLkFv9i(I4qxyC7P7Jid7iYJNRfUt5sDtbIrSmwtXPVr68WuWoInt0LcRwvXTxh(pJ9)S5M1S7Dxnn5RP9o6qRnN5MSRUUwwm9gUGGpx1MNTgI3LLHZhLGoN2oxIDDgxSDsvMz6KQOgONeFSYh)OMMVH2RHc2FPnbrZH7YnL(gSeAMcDGrb1dm2t7vAIfpudhi4kr7pLwpsFz63vRhMc0X(z16Y1zy)SpNEYYzvx6BQpq48oQTQstVKE4a2E9)KE6aUA0o(bkCQApccwpoAJyxX7xzOhHy1ikO3AB0Z4IWT4J2Hgg7TI65dkXuDafpQTQhs87P3)BYIJigw)eSfUOQU186AVthQGGyBYuVeSam1K8kYL3mkJh00U)kiOoHgb1Qsq6nJW6nwo9UBZUFTCpK12vH6hjmXW0Sua56EriZLAKM50Yq9Tvl8z1KyRjNnWnlxgKPhBBSsU2CMBXX9IbDEqSrDSgTLIbsLcKijcR6tGwEgHtL3JCGElpoLzVTHChy1he)O0Yqs7K0k3iB2xl0YVNBaxK8pUUnU)EPgew9DKACCJ7123BaRJPKGcox(aifh5Sm7r1dwt7Vn9yftMxKGP1(MKL0gb5Ew3xSMaZCmgKEGpnp3ysZxr8XRPP7OhGj6L0aUsXz8VU96hKJcLAVZl3kK0aVRsrm1vRjBV(xPF(E8ZskXGjWoXKIv5RzxUVyKfq0450BRzeNU43M8f7Pj2A(QAsjN8D4LdUwlQiWKt9TTPqdW3BDsw4FiMRHDYDFDwafaG(ZVCJFUiZRF7dDJHWeyRrtHj0s9Q9tTBDmvoBkURQuFGXKFr)1AkYUir08J7GPQZGUSSnzj1aCfXoFYWBD0hefnQSo1vsUEKRBhgd8xK7YyMde4LgcySqCpYyciADe6DiI0VeutQEcKXSo)NWBbQFnRmgPwSe1vFvJVSK(vfgZ4AZxtiEhi6VKEtLxW(QgGND55EZXqyVS6Q1JhJo)QH8lav0UPvvurUP7KaDr8lH5TUhcDjOMDh)4JM9H8lhVu114XP4tLCZP2FW2kA6m1dTUMeKeH(DF6nEfYE82x9u8I8HDVDwFuzr2(C8(tJkb5hZ71GFapf93XUN5bcxzubJpNDDxrfiItqbsG9odLx41jbwscsD41jzWvw)Qo1WTEhGQA7qVD5dGEhMDe(1IzmRM(lw3jXBowAyw6SmvxRgJG)jDXSD(l6ZKELURVczQT(ez(Lcb3vAQP01EEVPQM6Ju5JZMCvfz3aHuPdM5IPmJfZOIs5vceS08Xo8t5mzrYhOxqC0K8ndVClYDiTP2OT6ZhOqk)EITegEeL(uV)unxcN)ohULh(KHWgofA6UXhuqzHBfYgGG)I6BNvJ3RbDZxuFOe53lL1vvLNKx2rYfMRKYSasUUS7QE(O7kMIURnNY5owWND9hc6hPDxOjRjM(I7jLveNXMR0D1k0QCyAtf7bg9J)GgMnr65bMtDRnCexy727vxcsE6R19MAtI9bkLOsUsfQ)(258Pf118X600j(xZ1zbN7oLERwGosaI2CVawbkLtKV8mrarVSC5FDyXRGt8NXwtjx5YUGD7FiUHZd5bPovcLk1qY2vNj9Dn)rBKogg(P8Pc(kThK9)tXlANGEhoSAoyKwUYA8GK31TYJ6rZNEa85zs87FXu2naGLJ3UYwApp(9DnlYHrB7gb6rc8fsFbJLBqKw3lp6pw76I9(ZJ7Fhd5lWKWyfN8HM)mjpLlm3i4KeF)h8Ii34hCFl2wlaIFOO6aiSljfZ9yJ5f4dCEGKKMnLiiJPPP1z9VLH4oxe2)Uwlxpl63YAlECygpT2qlnIuSVhcmQsloT6dKcBL1(Et4i7YOsgml0DR(R)Eq5c0ijVNlEdQqdmfUMkhX6YFcnnq0q5R9ueBOOyGRIQIcgFe2lr8tXk(Myeh8FSyDyggIsi96xO5R8r4gS1mPFy)xuwuKq)4T1NRzLD)wp5GdBlC8XpkzKAkAKApF5RSdOXyyMWaJJ5NfSO9ZQ(IEO1cjY0zkyLMqA06lx9JnEh6RtEHoJQoRV8Z0Btf79krLuVXpCisWQTE9hPp(cPasWPw5wwr3D6YjUD5BTu)1HJscWbl5VlUkfenz9ML3H3juOChmFXnDYCi3uLRphtTbjOSGiuDC1sS0Isii3ic5f4hZ3QPwB8WwcCT7GpRB)cvM7xWzUpXApLlCT2W0RYugymzefvBYD1S6)aoQTxph)axLxDjfGjncG0n0eVklsj0vwSBgbGWLKNNSPUvWREERp4onOa)ZQomc6DPper4SZo(eSs835NHQyZ5xgemlh8f9Jj5pgnmr7O8Lvf4WVSiHFLqW(sLMpz7p(tHyJSHvd51jXW0qF8JR4lkeVJBFmB5Q)Hv8mWGoC6hoQlixhbLcqBfzLJWRLl8kW1Ol(ocFP2ywb2ABXzhH7NHu4z7nm9KhAip4DndWD042o9td8hefF7pQrHtEXUPWXatMUixuqpBb34iR8(M82yHwbWTtkLJqCWmYMyeOg(vzaKsuRkKoZenvkq2wuuTH56kSRJHwfSTcUwfIF7EMdWa87TY3V0W3N9WaVEWN(CdyMqt1RICA63EvO(xmHFSwvVfgk3B7ocnHcPOaqnLyXryQeOLcCn0qOocBHGduGRMM(9tim3N0a1oMwf4gAOAhH(aSO8jbFLRMVcS1304oc5pB5lME8OV1zcK9w7Qjak1VTQ6W01lUUc4rZULPjqSK7kWwx14DfS1D)RcmB1vWUcW9oH4lc2SD3k(udr3oYbkyAAgGNNgb5y4O8xC4RHiXgcxRbq2FU29D0IFYMaHwDvb0AAr2wa1qoq6pD2qSO9hGgC1FO2g2hENBcO9q14mtMeLB9g1vU(gZPfWnOnyacSMazV33nbWrtEA)pb7BncZmi8k0cfkGwtZv8WaudAfgzd9MMMby40iihddNZmKsSXMSyiVqv9BHcOvBdJwGZGwoPsb3sCxtHKDfWTRqSkgBSeYUofk1ivRQ6wvqvf4Ny1Z4EdCTPKFjzLFz0oMx(XxTVbLfJmdSPc10FXAJL(zeKQhBpGmOKG2BTERkZI9BLTePNTJWDKYDKbOl1zWkGw73kohH7GYCKbyUtUTPvknnJeKSzH)qLt53dGS7lFE3zxaU1tcAOHn3vGAhKSJQdFcW(bdhypa9g6vv492W8MHmUaFayn8SC(NQrByU8Wg)jzaRG1iPXgUxnGXeWdaFXUJYg6YF(ic2DhzdZNSjmlljdls7Qm)GIYmmgSeW4twYD5AMihEf3N88WBIj0keJH9rVgv1X5yEKYUhzyQM5IEbddASNat7roaAt6g0oKXf4daRTPtW4Wg)jzaRa96h0mGXeWdaF1QHO9ZhrWU7iRdAruNihEf3NCNu8yBKstvRiuR1X16EBwJ2nDJzVc(9gG)0J3Wg26e2TZQxaEjFO3AsRXydVtsjmeiNDwjESPR96do0g6)vFvZVQjY0QN(IJ)4hT98V6RSbB8TTTcpQIm0tuFqy(Wq86DLwTFtT8C3Ct6hJ0M(yd(9gG)0J3DlKPFm2W7UfYM1Itvd6pAczAGTeVQMvOzHm3q9bH5ddXR3vAvUkrnRlirGPw4VYz9itzmEiCiz61XAz0smcwNY473usahmIP3zG0(CjvUB2KMtBd39jv(tvG(zQ1yKaFR80kk74mzSRr7(u6ozSZH7(K2bzu)yKJD0KpC0TaAjnVBnjk1lFTy9JL2O0mQDyoUBDyEkRbRcbcFwSFbXlmqRdlDmC5zTvkCfPCDUYmnQDyoCFL15WLN1wjqUEwXdk4e)479wMMBZOKPXn2ZdQu2BWWNvkdp6xY2oxmkdEVmJwtfKP5yQJunZJBSNN(T7OcFR0Qog8EzgTU70kv(7mpTB7odFESV74k8hpzNrAg71UJ780dB3X95PF7o7iN8iS7SJZO1DhRjfWP894CIMnox7HCln1sCyr3Q11a2V2nOmvpuMQfkM64JXSfhm0Th133akqU5sEAhb4ovEu7GAqDD3mdhRO(VGhVZPKjq1ZfmTeZRsIIsUlKEjIckOWRkisZ3U)6Rou25pF7149Da9chPAC0pysRyxOVnJE5sCWl9l8x4Nt(UT)i7UFmlSWqTT9tqfmdPQ28(FyyNzRh8JEDF4c0dPrRranDaPhJEfDF2)BJF76z6e2UhPe9GF4HPBinyQzuOfJrhZyfsdON0myJz8H4G65it9K5409vJNjBdTF)aOMMAO)HEk4na3ESMn1GRdZsLPwpD4wQgVJDGPZj0a2UnbYE3pKMa4qpri77ZdW))XKIOljqJISLjWoccxgbDpKUgFJDTdKE4G0qmlJhpGbn1JS)pMonw3Me5xOZR1MhSRGCKSABc8dzZ0aihCFyB6aQXVT4uaz1DiNjGzqTtFpHkgpvJd9eQyqxqFXtRQwg3dmcpXuJ0vh3UR7B8n(zU4C11VNF1dwd6Mu8Pzi7rGBgS9MEAgbXC8wHbAqoLh7iq7ZQEVc8obR7563PAkm8PXAjfmd(UBcjhAKWXg8DXqpaXAZvjSt2eTdzpcCZGT3I1MrqRI1TESJaTpR69kW7eSUxGvNeRh(0yvS2m47wUZHwxCSbFxm0dqS2C5L7KnPBtlJlW3fWUtK3DhR3jW3jG7NiPJyD)a(Ua2DYc1UJ17e4nd4ER6F8toGdl6DyRAVc8obB)eLDeN7hWRbR5MzOpGvbNhxG7ayhLgp1bSEN0TTNbVzapyHW9mH2CBP0j7r3Y4JlWDaSDtsCO3XDaR3jD97zWBgWdM3BptOnDga6NQP9kWDaSDtsCqC0bSENumTNbVzapyEV9mH20bNOFQM2Ra3bW2njXbXrhW6DsX0Eg8Mb8G592BeATPwFfoGHNu9XQis6HEpciXurzgh800xIKrdphCdLyi3MJ06FpwkGrA9)aDrwn2WBK2Fm1g1dLQo2FKg2xns22F8DuTCiqFUC7eJQYUAoOHBDs2vZNhU51xnpnlz1)x3D14BBJJL)VLGc4AN46yj7mBXEXErttYSDVzUPyCVzWHd34iBthRT2w6KKBAgeK)2V37XpejfPSCAANBhSyrNyrrr(47JFVpiz8A2Vn5fV4XBwvuKM)xp90BJlwTBgO7FZP5XB2TMu8pplAzb(3ZpfEWM4I8tlwXUlkdVH0I3E6BOV07XA5hM2)a(9oLFjeoDb7tGwzQx6HDWJ)d8R9FMYNBla1TY7znCqbeMFmcMLywWXewhEgVMMxm81N96aCgYNu59uNtxNm6u5EpUlEhXnsywqUl)7sBSIrL2tQES1uUtHREQu58zWkN8OxX5ZPd5eNpbRoB9heVNd4dR26AZtCi0KqN0exhLpLF4QhyooFMtAI9b)IZNyst2)HEIvBFQ0K7yrPjBniiiGG0u2IEZy5faoW1jf5hqxLF)25DtshLZkIxk6Ya()oLToNnQFVZ6opz7IySd981aPJF8EqQAoExeYW7b8SfZtOR3uqs4dGqZLjeCM109Ohh8ckfElFVbqczKW1)ChUncORiDAddqdKEhY8bKB57lPAOphFwWWWJdoJg5xYMtxRI3bJFqiwSoXhoPrXzsz9lv4b7I3LMSL411x4J3SjE7ouJaDnOhu(3IoQrlgLY)h46X(pNqCGj(56WxWrxRFeg46yc5qigHFXeJkNNdoCo95Iy4OR1jgUoohi2VRaUsebpEJCRX0W58F8Mz3t3o3PWudLwiHc5hIFvGs)K49aoZfXFkMK8W3KEMC4O1CKSG3Z30Lcl2EWw7n)9i(yqPpfV5lxeVmgz0BpFxwgi7I30Ob9o7ZD4ci3gJ34)WlTk(2vy7sfgu5pwRRKZm4dXDUX1xjhOqRxWV6X5(ZSGFRYQ16YVqmyKNfLJKo0dPfmXFcFI3q7xj8wmxmPk)glL3I5rAc78Rb9Km5)fT7Lq2pP0VKMN3iLrLsJBI2UlADfd6X(pWiSeG8EgpyBM1WxYdzqg6Eqw7PAHfJDdgKoc2YHmidMMC78ftXl5wX4S)H86HFzVEWu2NNVE3cMRfs7Z3bRfgVNidhYai0ZaW5bmHfr)zzaiL6SvhhQRooqtz8rEnn5tn9dp4xbUMgCNvmrNJB74Lrb4oh77v13eZDg3wZIzJ)ebwFI62N0hKTVQK74LL23CadCG(6qLXPQ7AY6t1NuDbQcARJR8iGWae1V6lCN)3(6VY9LS05sJHl4)NeESPQshTbzcu4zD1GQYwYrZObnzoSiAdGUz6xbHEVmvT0M1R)06X6uk4Vjms)C02psyRzBOBBgW0CkzCNFNNtxh5ny2LfqgaORVCjAYE9pM6RPKVE0x7xeVKaQaOyDlhndE1TbFUvasacmMy0KlA4Uu47spaVu2r)AEtYv9ixGUolzdGbbrfrEHaTzyodaxKZyBYXWD8rMaAw(DmaLuAcILJ2o1XfVeHdc(Ws(wqiDIr4B5WqAzug9b(7YXK4clpJ6Uiym8D4hbxHY5a(MXUngp82Wj0mKsXXVHxR4ncAZImGTGLseXPrjSUcrLrdrUKmgWN0KUjfWtnfgStNpt1d916HN11HjF4WNAaqb5461h0mBE0wWyDbB7IPlYCp3EHmqx11pySgW(bSxVEAASGHv5Kr8wmyvt53(sXBxUdVC3N2xP0BCJa4KEFMXu1Aj4d)6VcupWj3jfOhdnOdbuG54uVyf0l4kKyC)AQ)(EeR9eINBc)OMaesuN1epEZ7bY)oqW29hY8kUhvgQcZO9XwH7EqDMmO9UQFRv7JmId(dpi)BTdlbpwcwdoDbWROD1b23hz35aKm9(Uv1EgduifnI1rGGEk6)bN1L7SY9j7aMguSoAwYor4jMmHe(3KKt(Lb40zFkARmJrjPSTmUGd(EupCh94l)5xn(6lE14jtE14SelkgmDGVo8FHtefnP033hEGIaMMZW7s7aepfNP9LD5U0hEybJEjRhnv8ZylWV(NatkBzBIz5Jhf2b(qGsPwlbpllMkYY55doZs3aOLdMrmKlJ7fnxpXwq0buuQgKavmN7t8DjzFK0oWjJOo3nrFoEZUnOcXcq9R80Qq)TNVqeHhGmMvQYbusdMHtYOo8TO(g2YLKBQmPF990PSMcl4GCA5xXwexJelN(ayh1JLBSqWRSSYM8Qx3z8FRSrih40zGFXfR0ArhUsO3r6qE8MReQzabqU513j0NKZz(aQX9VK49(uu8AoDh0ZqtAnIKUInyUk0qP0HHl1sL)6kTq(SQSuToY5CW4bv508tRvgCIxOj97AN(zQmSecx56cdmsystp)V0ILNt7eF4TJNhxmEuqRJOPL4bW8plVaNaTZIIxmLUuu7fTyroOlF8i(42OVLFWJ73BOsbs5PtHujI1XGrvrPb8in9FFfGstgzOj3NfV8)HuFOY9d3SvoPjoJvSlJWjGscB3H6O4bqs1i4HGBLajDd2PKkNIvOu2c9iLUlNXbEauPcw0cTOqHX1An7ZGjG3)d4FjqrM7Fr002A5YOAkyUI5GRQTJz75d70a(gaOIMMDJ7(MwEs3L83n2QJYFu70BOLHXH9Y)5qM(8rdAvQyGNhxXJgFMlwthCMGi08pEUJhaQhNspK)wMBCt6bJc7ZbQVlvyAAtKcrlYTVgw5rgOvrPP3RtS)F3bGV7Ydl6YP3oFXOa9hlIOK(pHbGAk)pNIPj0W7ldENSDBR2qeYkiQhpVa8CbwqRiSS3EiVqyR(n)0vMzS8F7XB(Pu08bpMHOoj0MYscooACGqVgjcz6TRtMH6CjZkcmT8xeE4YmgQy(IhV5XBUiA3M3srdLxfcxMS9LOXTeE0nVMJc4)GTRilsd7emtHPGLoYUZVF(AWdpCjSiNtcA7YIdiRifU02z8L4ym2v7TmPIa3yNwMOPShwRsanwMR74qrtZ4gOfBibLTN)DcvP0BHdn4fu83ywaA1wMSpZnhoNVnxB2uPj26lpF0qU(YjWsjQytIHJcw(CGG)MjV592ZhdOLCSoYTLlAYsIh08CVH(m6RUyv1mH(QxEHjNdAggxOP))hUMwXpzq)pYrjE2hShpA2r00tAzQOvvBknWQRfUde8M7PxlNyEDzYLlonNQTjJuuysEEbwdk)7WmJBrzj5vnLSXiHx1Alw3TkETSZqGYCSMCCGGC9wO9GZ5V7XB(42K7uwKe2G4n72OSze6pHJ4CWJ5CIFOFIVt)mSOnv82WN67HvFexdCoMFPYiBzbM8CL9IJd6fw6mtzl6WzZ)EGBaOdG1iq)nbpqY2Pb)f1lr4LVnlMTK71TcSG1S3Tc6LZ0igLdIwE090UQvsfBMTzwBDnp8GaEoUeRXgxrgrh6k4SBmWxDfWPGoua2PYssJPA9GRSe5o2HEpvgmIuWxnIwCnTMcg3iqsWQC2DXiUhQlV(c7pCrCkpDkaPILFy(zvpkG94CaWVSNwCETWmKYWgLGKn5Vtf1ACJwpfRvF1SovRXjnaSeplU83JIkurcy7GbOecDaZULRwgCMB)y5aMElfaZRj1ExWzsV5YjOV7qNe)7KN5aX7N2I(3ZJ2jAjqKmwuFh0PYKwUME(RZpHZJcYmidlJ(pxiUVga(TCzObh0p)qKDBipQ7eMl1MPuxzhhXsnuke6L2v0oyL6GQgQsMFDPds2g470u9bUN8hKa6Z3KhdPc1))taatAsb15hbEdmDwY2D59kU7UWPdtN305TP4(EGlCKdpNSDIyahKeHwbTVYvjgtatz5ecveT2Y1O11RUORMresyfJln(UOX23EPTPE0s)ecPm23KZLxXLv3NX3Ma49P59ZxIgNhEO6sxlJ1x(aiStJrgCUFKbJ7lC5xZn))bV0Qs41rsIWZ8xg(YkUMJ2)U8I3Ibbyjldjf2UOdGMWg(zBAVWbwxK8fjf6YEt5PAQeepoX9HLz8(XYypsWaBRGI7WJvqXCylNMwKJi0fdyT)4HE(EyjHIuWFmc1OEPMGhxh9BVaHlUTqkimpkTIuN2l5IO9K9Pb4Hu0sTaFj0y5ThvyaQVz0)CCBzMgoPFVGoAeKlja6sRziZs4hWabTLB7bJ4L0Ifp9tsaNXfVe)rS4FGxEbyXl62iuixwXo8PlIr9Dx2RzE84YBdpXLJMbV)ECKm8dNqYmdW)L7t(VOo2UONees(Sph9girSA)km(PjR5)bPYc8CZdFzBB0ddFfxRKZZEma5Nstt55hMxaXs1pUL5gBfZJJ737VCwNVaHHYFZqqRtlNmHs7A1Wxl4tDOGEuynplqAJA8O2dE1EOMLn9SAB6XHcEBouTF4AjdXAwuk3NtUV83SdDlD5Fvu8ykFdehkzDv)xCFlXwZdzktMTcCPsGmHAsEcmcSzGms1KlfTQiuY)Ac6L8OrZaIItxiKl1NjEthNj8QviZJZm0)e6NfKg5P7l6oNNqHBdQiOPJUbpTiyYxk)VsWGfUqMMhdv3RtUfRJzESfMunUk1PYgy)J3c)ldOy3pL(RPyjBqBRGEyWU0EcqGAvedm8GTpJucOf4RXs2DzGV60f)6zz7slS655RJtrIElhq3EkFgGtQPn2NCEL4QTp7pqF5uutj4GWwwgNVsOEvgInzK5oqrfP2trV0YsqPmJ1VHZMl8Zx4hBmwhKnZfIBZySTgPRqtSrynYwuQLdm41obDmHmbsglpl)Oj21WiDgq1rcQRzs0VVJknGS4pwH4jI)9vcmVGCc6tHmzpzu16GjLMcJY645Im1MidLIELMWW4SB6CsxHBlGZDOqv1foBgRGtCIcxp6ygzoQLxpnR6eLfu(XThCIRGGCYWJDog6u1lrPUSaWSREXhvrYvHnoWOz2d(wUNKnMeh2esCiwFAUjY(MFH9A60ZIq04r(GMmYhCYaFJ8JCTswtIc8nthnOxydNRweLgpvhwJcSMKsdF8Ncrz9iqzkhZdeAMisOjwrd9uENQlqVCMic4sW4gSAAAPSbT22NFUJ0804SQ(8IwGmu01cleMOCavrsH6mt78rgbGRzJ3bFBgVTBWa2d3ANMnrg(TzI4Ae2Sbih7A7NzDLDAQYsBjMrbDE(4IcRFU9K1tEaZopl9Uk7QNV5nj94KRfSm7LC80vM(LtpA4KxK3mQsXMGF)C59IePGml(2BXOUBbBurZi4GO2(nSSO1O3Yj55G7gvAGvfpk(WyjbY39YagzeJPSgHXT5e43JzHdd6Q5PgDgddl6rLFLCSYfrxhIlyB4av)4kC7HSM9zEMkJbFNaySWC3xqHRVU(qLfT84fX3zMZx(XzXgkwAMoKPIA8DYK8k9uhZPBzkKPYaVN10RUq6xFELCg4i)gCRjs7W08hftCybdDVSlMzqC(MNgJjbt605gE2C2YkpGpkUJfrLRO586zU8jkZ)jVwXPKwsHCZmwgOqmpExKyCxJKDwWZFQ9sGvYoRmMByMv(xLuFAm3FIvHHDVKPNoY6jdg5eW90CyzggCWixnnfDasF9F0x7o)v7BGuto7CMnqNdnFzN1voxdD52AziFOi2QO1c381YSFZvT4kgm2MMmro5i7q2P)ZJXm9kZrIlBF6J(WQmmRCtOcuJNaUUQ6ktMScrWxEdLURhV5xOBgflIGR81)KcmN2cUw614Hd6Yem8Q3MWltU75j(Bfl6tO93zS5rK7k0LwilkJkbCmfwub9GmQO20)2348HruNVG0HX7hXkQ8PfuXqszngCh3ztI3oDjzXgfg4FsJmk(rX2Yf)(Y)QhgFqGmO1qTnMaVT6HAsnCQ8AwSdkTJgvXZ(2laLDNXRTChiVLX4PyGOb1RW(KHonJi(rTUg60f0NDFdSsEuRMSNbNDzQlgGD8N)gpChLasd67RnkJzN9fLqv3tjF9NUYEt79LC0dRp0(ujCCKx)uKpXS374Hx5jUeRgkAcAAJApRJNiYjXyNFvf8dHIVZfzUWUDIuy5KUxhDdmeKYMd64EktUoEzP7apY06jWZPfQizEQiBN9E8M3tBBPOm(f(kgMzsVAowDMIDrcaIpNoPvqTQx(Z9(JQsNQX6Dnf6Kxrj3f1tEHNA6XhOiD1lec(PRsYI)9KT1csQQcoNfnLAJiaMkJw7dmL3kRYlCrezyd0A6vcsLXqtSs0pzPhH6iVpWXcMdaKojxwi43FXI5czVQCvDwUb7NevXfGsxnn8vOJQWy3BtDoD7udc4)Lqk2QmXWyH8cSQ5FF2UTLEnR2Irl2r5FcJJG2(lIVLlIwSqLd4pHaHVAYuSC2M(b5ExvURMe7z7MObPMQf85qdsDjQQTZQdSAreQ(Cv2RU1dOQ(VT4z8G)LFhDmKqFATFPeCIWKz9LOiWP(RruH(JRcxFXPyXzZ336Qkec5UYXnQbXOgTLIhXJ389yffEh)WecMC7wx8y5TqoNVCBcY3VLIu3YyrqYGbNgZT1k(DWGPBoBETujC5VHzD0RQphrfvqWor116hMbh7sVif8npD3RQhj2H9r2lvYT7))rqO2p9W9yD8Hsrk3(qehhxtxaxpxiXEMRyYihW5jHpNZFZ(mTxti3VdXIN1g9IDI)pa6Jl3ZvEH)khpKx3mhlORvlscJbMrvd8nDGznqq(AV7hl91hvTLi2CxQWnlcdcVgVGolzx2C2(wiABrECJgRHL4K3QPY3(kU6(8SXLtLDKl9uAjAXfWohMwZ8w(IAq1VT)imuXErRJer9WvRDe7JQ520Oa4u57u3BlDAsjFskvyOO5gGRvyRyjORiXCNLXZNw5zfaU)0W)oSF16fLxASweEzbIkahIZjjRSwyeT3nzuBDVXCTlGLrH)zbiJ3EyFOkQwY22Y11wMFwL3hvDDc3KpxU1QRPg3i6AJRTU91B(RbCNvL3FGLPTl)MCLtXk8RGtMUoXecaEBjFvY27)801SBJMFpS67S5Fx)woA8EYyJRX3ZUVEACYMo71OSj5Cy4IaOc5x)Ed9wc8o1fvghrX5fuL6giqsBLwz9uuO845JkkfjD5kuwcuhUI4GOmocQ2uhOeL2DVbioWcajOaTFnMSXOLK3I4BI4Oe)zXQ4me4vmvCJLNhw8Rtb6aWz2UIcCwEis9FdkU3wvkkcKFXqzyafPM9xfWFv)4hI(l31gSJFD(m9FLZNPBawzg0Z(WVkSpBE0dRGERX24xq986pRhsbOkLBVRkbw8BAWTmqJfBuQVLLtTvWB6IN0psFqkJyd3XJ3vgGAB5Kkh3vU4CeBNf3HdFm7ZS57kyIqSFK7rVJa5pB9oE3xbOThSY1J)9m767DuGD1rZvGiQFd)E7OFq)lpmsQuFnMN)TECqQTzC3dg0xGcq7TbWvGUmogp(EmUTJeEdO)Cv1Ewi3TENH9DUN8lZJt)onyMcgYYIwJhYMrPOQXTRabcwM7PS7a4w7OquYkAN91s(wYHB64Og5LLhdxleNO2DLyAq4l8A2IkZjbID8aFh)n7J8D8uRwEcZWpg24VlcBAOjY(R4v1f(c4uwdsLQmAwKSJQiEUBdIXFxAOJWOWSThRkPmHvTjtofRjNivmf47ziEY7HH3pLPg1LN(K1VqHNf(YdoNaFmJUoEwX2L3KJkKQX7x74(u1kXIQm1SvIV)(oC5myN7uZzGk4oC7N0OUJRdvlmONQjJ(fJT(5VS9K0XHCS(WZbXwCWp3XXrOQ84fx)eN25jG7y7AjUS9LszQKldiL9N5yuLsvPv1Uv3sUUMjBDtOMZ3g2C(2GNf(2Q38AF95Bd)AX3g4HVT6KSULYqhpmOo(2Wk8TEoDO9Y3642w4BeFByDtOgW3ItKPGXWfgX)w)e9UoDUUUjlAgXjSpMSFFDCDAEQJAmqVitSf0CDhK0mnqEgSbEhSbnDW(KeJEEeWFwfIRR4EEUy1huR(7A0iwR8tDiaiqDVBP0DecjeIWHknpX7vENLqv8ooLK7yjcxKidG4RP6Fo8iE0fI5pF)92SezGXk7NALVnlT5kORoKdhDPHqTvzpNn7iQHMPuOY9VrTAmgbED0wVoX73lO1rPzSpHZpyrxlAuhoZyTQIQzilcsHhpHo)mRIwcCnAq)t8n26Shhz8VEg6E9mSMd7(gVEgwVz4YNvZ6PZBMPV1RNb2RNogYFtxp)ZGePRbM6QT55zD7)3jh(NbjpxdSN51T)aK3(Tc4)9B)Fp]] )