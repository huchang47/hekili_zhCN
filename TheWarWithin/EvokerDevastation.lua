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
        max_stack = 1,
    },
    -- Next spell cast time reduced by $s1%.
    burning_adrenaline = {
        id = 444019,
        duration = 15.0,
        max_stack = 2,
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
        max_stack = 1,
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
        max_stack = function() return talent.essence_attunement.enabled and 2 or 1 end,
    },
    --[[ Your next Essence ability is free. TODO: ???
    -- https://wowhead.com/beta/spell=369299
    essence_burst = {
        id = 369299,
        duration = 15,
        max_stack = function() return talent.essence_attunement.enabled and 2 or 1 end,
    }, ]]
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
        duration = 3.25,
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
            return 4 * empowerment_level + talent.blast_furnace.rank * 4 * ( talent.fulminous_roar.enabled and 0.8 or 1 )
        end,
        -- TODO: damage = function () return 0.322 * stat.spell_power * action.fire_breath.spell_targets * ( talent.heat_wave.enabled and 1.2 or 1 ) * ( debuff.shattering_star.up and 1.2 or 1 ) end,
        max_stack = 1,
    },
    -- Burning for $w2 Fire damage every $t2 sec.$?$W3=1[ Silenced.][]
    -- https://wowhead.com/beta/spell=357209
    fire_breath_dot = {
        id = 357209,
        duration = 12,
        type = "Magic",
        max_stack = 1,
        copy = "fire_breath_damage"
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
        max_stack = 2,
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
        max_stack = function() return max_empower end,
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
        max_stack = 1,
    },
    -- Damage done to $@auracaster reduced by $s1%.
    menacing_presence = {
        id = 441201,
        duration = 8.0,
        max_stack = 1,
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
        max_stack = function () return talent.essence_attunement.enabled and 2 or 1 end,
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
        max_stack = 1,
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
        max_stack = 1,
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

-- TheWarWithin
spec:RegisterGear( "tww2", 229283, 229281, 229279, 229280, 229278 )
spec:RegisterAuras( {
    jackpot = { -- Need the ID and name
        id = 1217769,
        duration = 40,
        max_stack = 2
    }
} )

-- Dragonflight
spec:RegisterGear( "tier29", 200381, 200383, 200378, 200380, 200382 )
spec:RegisterAura( "limitless_potential", {
    id = 394402,
    duration = 6,
    max_stack = 1
} )
spec:RegisterGear( "tier30", 202491, 202489, 202488, 202487, 202486, 217178, 217180, 217176, 217177, 217179 )
spec:RegisterAura( "obsidian_shards", {
    id = 409776,
    duration = 8,
    tick_time = 2,
    max_stack = 1
} )
spec:RegisterAura( "blazing_shards", {
    id = 409848,
    duration = 5,
    max_stack = 1
} )
spec:RegisterGear( "tier31", 207225, 207226, 207227, 207228, 207230 )
spec:RegisterAura( "emerald_trance", {
    id = 424155,
    duration = 10,
    max_stack = 5,
    copy = { "emerald_trance_stacking", 424402 }
} )
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
        local power_level = args.empower_to or max_empower

        if settings.fire_breath_fixed > 0 then
            power_level = min( settings.fire_breath_fixed, max_empower )
        end

        return stages[ power_level ] * ( talent.font_of_magic.enabled and 0.8 or 1 ) * ( buff.burning_adrenaline.up and 0.7 or 1 ) * haste
    end, state )
end


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
        end,
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
        end,
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
        end,
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

        copy = { "recall", 371807, 357210, 433874 },
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
        end,
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

        healing = function () return 2.5 * stat.spell_power end,    -- TODO: Make a fake aura so we know if an Emerald Blossom is pending for a target already?
                                                                    -- TODO: Factor in Fluttering Seedlings?  ( 0.9 * stat.spell_power * targets impacted )

        -- o Cycle of Life (?); every 3 Emerald Blossoms leaves a tiny sprout which gathers 10% of healing over 15 seconds, then heals allies w/in 25 yards.
        --    - Count shows on action button.

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
        end,
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

        handler = function()
            -- Assume damage occurs.
            if talent.burning_adrenaline.enabled then addStack( "burning_adrenaline" ) end
            if talent.flame_siphon.enabled then reduceCooldown( "fire_breath", 6 ) end
            if talent.consume_flame.enabled and debuff.fire_breath.up then debuff.fire_breath.expires = debuff.fire_breath.expires - 2 end
        end,
    },

    -- Talent: Focus your energies to release a salvo of pure magic, dealing 4,754 Spellfrost damage to an enemy. Damages additional enemies within 12 yds of the target when empowered. I: Damages 1 enemy. II: Damages 2 enemies. III: Damages 3 enemies.
    eternity_surge = {
        id = function() return talent.font_of_magic.enabled and 382411 or 359073 end,
        known = 359073,
        cast = empowered_cast_time,
        -- channeled = true,
        empowered = true,
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
        end,
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
        end,
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
        end,
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
        end,
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
        end,
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

        startsCombat = true,

        damage = function () return 1.61 * stat.spell_power * ( talent.engulfing_blaze.enabled and 1.4 or 1 ) end,
        healing = function () return 2.75 * stat.spell_power * ( talent.engulfing_blaze.enabled and 1.4 or 1 ) * ( 1 + 0.03 * talent.enkindled.rank ) * ( talent.inner_radiance.enabled and 1.3 or 1 ) end,
        spell_targets = function () return buff.leaping_flames.up and min( active_enemies, 1 + buff.leaping_flames.stack ) end,

        handler = function ()
            -- Many Color, Essence and Empower interactions have been moved to the runHandler hook
            if buff.burnout.up then removeStack( "burnout" )
            else removeBuff( "ancient_flame" ) end
            if talent.ruby_embers.enabled then addStack( "living_flame" ) end

            if talent.ruby_essence_burst.enabled and buff.dragonrage.up then
                addStack( "essence_burst", nil, buff.leaping_flames.up and ( true_active_enemies > 1 or group or health.percent < 100 ) and 2 or 1 )
            end

            removeBuff( "leaping_flames" )
            removeBuff( "scarlet_adaptation" )

        end,

        copy = { 361469, "chrono_flame", 431443 }
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
        end,
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
        end,
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
        end,
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
        end,
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
        end,
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
        end,
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
        end,
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
        end,
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
        end,
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

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DISPEL_RESIST, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': ANIM_REPLACEMENT_SET, 'value': 1013, 'schools': ['physical', 'fire', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- #5: { 'type': APPLY_AURA, 'subtype': MOD_ATTACKER_RANGED_CRIT_CHANCE, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }
        -- #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
        -- #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- #8: { 'type': DUMMY, 'subtype': NONE, 'attributes': ["Don't Fail Spell On Targeting Failure"], 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #9: { 'type': APPLY_AURA, 'subtype': PERIODIC_DUMMY, 'tick_time': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }

        -- Affected by:
        -- spatial_paradox[406732] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
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
        end,
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
        end,
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
        end,
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
        end,
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
        end,
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
        end,
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
        end,
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
        end,
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


spec:RegisterPack( "湮灭Simc", 20250303, [[Hekili:S33dZTTnYJ(zjZBQJDsSILSDBUoX(MK4K7AN761Pk)AN38BEMIIcsIxOi5X)yhFtg9z)T7cqsqqasqjkN25U5UMeBaUyXIDxS7IDbUD8TF82PlCZy3(ttoBYLND(zNpA84jxm(2PzpeZUDASR3NCxb)Jq3nWFEd7o30m3m)OqSThcICxGGinkpXdAFDwwC63)YxUYpBD(8rErBEzQ)M8a6l8sCxMH)S3lNhen)LzRz37MCp0v)WxYcx5hYEPxGBAQZMOf5bS0x6ghG)Nd7UOpXsg5fhF7055(bz)q4TZ1H4tg)DaYeZ8U9NgFX3c)71(lwW4DML6D7uSZNE25W))73oBkGkBNLhJWz7pU9h5no50jVcA8J)2Vb9G5MgfUD2eLUDXPN9NoDYyomExrJPYTo(sO13eeeD)2z3K4Ukke(d22z(a4EZ)49vD97oDY39ITZGp5Sle)no()pcqoBzs0gX4i)n4e4JRba(BUjWFquXBNg4NMLIRim8p)jA9Lf6opGT423E7uxp(shlJLe6N9GtAEcU6Y2ehDplXjl62PWAV3dEbmNmxOnaA)e(Bs8HpX3LdI7yoSq2gFe9E9vBNnE7SNVDwMBalmBubStDsJDdhjg9TZ(Yx2oBE(YLJwusngLW246hIqbaYOV7YTZE22zW6xqGZAGrdMDh1YhDnFOv)eDduEmbQJ3otf)VM(TNlpdwgfM5eT0zJ7kFVQjWj0qDSLt3tO)pIlngraT)wcDEshqHZ1M4hZx1EVOta3aUSbml5PW8nXn8tBNTjkndgR44aFp8JbqhHGNwdhDBgiOSdmdt6pZWeI6mHiw7jlXKr7chHg(iC6F(om9pV)tFoN052o9FsxCDTtJWbC0KDGkPH0IePluisYeJlmtZAqKYG)30LZBth0s)eMZ8eMB26MkGkjXh)iP04e6RelfUH(G4em)QwgGgVZfWi4Ng55g6W(CglCHZIe9Y44GOi9(by(UD2BPjCDrxqOnjkgaEwnP2TZ8IYdZEjhPAxgUgX0mdkx8er4oORdMK3EtzfFyQxuIhSf3kh2M5SK0AF)X1uLgUkpyzDbirtZbRlYCwMNe66XAih6fffSi6(Wcii2ZOcYERX1LfoeyK00RQYSfLngwNSslqRlzdPIG)iSMDIQIAnkV6utZfC9ulylDZdYAtzvCe)VRjrFdlWf2mgAJBw30pc)9YTZEikheQrPD35r5zCz6Pt3o7u(20bWhLWcaBPdHgxgbuTOyqgf(77xZWVJGW9uZ38lNE9hE7PxpD6PxNevy7DnfKv0rPf5w3abzTprAzOK1pDTBgcyyndSZpH6icGfmcekn7i(1f9sNLotkTdAEuAknMl9xToZrwDZ5xQt5weyUFklRAvOGNd)xb54(of4TwzI)mn9owwYU2(wvDfwyEfHNx)NR)bsSoA69jkme)Qa)G1dGqTDgdrtUv8WclWHecckaXmrYDaOT5a)W9rjFciRaNaXWGg2VX9ZGVtGT)Zzz3ZWpN(1YFThS(6gUGyyaUhbVDkS9I)QWOecGV7MFbAz5sMhIrPz(BqmAernD4U1HOLtfC1PaR11Ic4edKnhGF2XFHmlQG50FZgWfpq9gqZYsYj4iBPlxiC6zAwDzS4gRcaBZ3rStS0uwiOBaGGVNFw5w8CD3edQOloZZtan3vodK46Va8UK0YTyr6iukg)A(KS24wGmKYYZgDrnLuBybzoUjBIsQPJROv3qw(DSe35(b1uJAsM5CK1sJcnRweQPpwZYqd15kmX)VVFb8fl4SLtFiXF5)pILV874qp1hDmoHLbAMtfSMH5OEEGhgucw2jOXywcWvSbbkPTd8vnvMrUWCiFsrkSdK7coqiO6fTjoG9zWT5F(VH)uiGFiCl5tAXzpD4mW4CHGaF5UqGl5Y9MRFpCdBzDKDBm2UXgvDWpXhx3iwFnnxFl12LV0QLt4mZrnnmQY(HTZUSlrqnYFWwhEFIwh00iO1Zr0HIVUoPq0iU1Yz4A43QSgwJz(xYJf7)UX9tmbdfk1ha8yiR6AW47hQwV)x5Gvq3of4gbJWw6SYBb3BMF67WrPOx5aF2DSa5Hf6YRmy7GNlyyf)hCW4ZWJsJGzkdus)j0Pjaa)jfay2oEsjbWQcFTxg5uAXGLKhACSCJiv7JpZaI223MMXTvkoHbYJZD1ATu3BylMUJYgpcm10bPZ4sSqz6x3g9thTXpjbeSb7VxMaZH8eGRllcuRNeDFQSoaXN5mMav6Uz9s5ypPne7RtJ7cXysfXOxMpqed2)k3poMTy0C0gLW0GOSAdY9m3yGXSCemS3O)Y2vElat6dHEYcyMgDa1CybPWhE2OllX1X9EVdJtrYCIlhFbpEzJVur)1F)byVspyZWqgQRkzHx0cuppSF8hbLA3a)NpU74gg6RqA0gggh4vC)rsP4BJk)(N5yWbPykqAajeAKo6c4GHdhD1OAvIgxr6kDeurMOypyjjSkd6Ytihz2o7BK2ErAl8QoaA6oJZD2E)(MUgPkavxMFDexBVJhqEtBAu)nmpyJw0cEFV1LFmNUg76JoT5NTwoi)G5mGAYL42lWYky0Bo6tnzN(4QFUuZVw1kCgudSsMyj)UDtMOs(vvSOXA7edRTtE0wB1osAwBNyyTTvcO6w4DltxNxAolaupc)rQdiNbEzgIB(Zs0X3f(WMCgObMBlb5sDSF4IaMUoNg)Wgm0mjPo3ZMREUafo1bmzv8vcPCUD8On0UC)bf2ux4ntPz2IVdyEx4FN)Icpa4(CwsPl7oFxd0wV4KiS)PJ2o7V6YXb)WmWokYJZnrl8x6JKGJ9YbAtif(JXJU8ZNWLHwbw2qF0A)vRX(fN4dUUIhZb2SeOkMzJeN8L2rjfwZdqChNLRDdxHteeTK6D1i4h6bM9MIKo0XKfmXpcdXBqV2HVG)1UYJb5edgPhxj9b37J9nkP4FfIHfcfOkuquqZR77DLip4MyUBGodb7bB4KEWgoPpSHt0XgQths10OHHMDppotpPjcmehKHjJq)PX93StTGDIcy3dd4iz0K85p4C)AwqSt6AIXPPCmSjsAmpaAaRNl4HygZX3ta9gZB2N9cYxWTAV)MuvFTRd0BsVrVj1qVD0EScGvisQ4rDRgxyE3jCM11Ex13(cBYPsnx5z9QbkCzAEpKGqDZPpP4KLRBbK1dZy9dJQlmkBOnUCTNofIXgSr9qUOORD9Rlnm5KMQnAMidL0Yd(QwvuJpKlBnw5AaPkAVyfLoIJXTysEBROlC3aMu5CWwypQUMKG7c4bPqw7h8lBNB1G5RTOHB8OZACk2kbaIoH1XLXgx0xy3yx0LiWWPA0PKX0(bo0VhXjDweMW6mgHlsaAmlMGJdg3LQ4VDHXdnGmRGFqbOLp4jSaO4AWQbYWTIO7l6yEmyuh1agGFkTIIE)iY1WpqPm0g0ckYttOpxKYa2YugBd89b(LXcl9EgyrvCeA33C8Oh8ZEkA6il5bYvfYQiFKNnfqPLyUgbdWFTaNimztuc)ipcPeBbgPOq0AB04W5SvuOcXj0Cm0rCB9att4hO9yD26ybbUwqyLITjgigDMDybiRTMLkDUGtF1bBjB6h5hRVotASaLvI1VcDO)g0u6ALFiMYDo8Jk1pCzog6CNZKC5c0ixZQkubhIkGndboX(ecy6uWbURfUHzy0VtC9ufz)lO10tjofycMeG)4Bw4gNjg5FgwKYXO024Ons5D3XTS3LX)grhvtuA89yCWtZIs20VtQUQvYgl1y6Fs1eVCai8rD3zT5dqtus6CNuXMJAdtQqJaWbpWeVLbUKwUmEOHB54Vvo332ZkkD(YlosMIJGkbyCzo35Vs(aZKNxgYyQJAEEzVMhk8ACqy(vkodpuzxkQC7FeJcPCpXW5aQoAjP4cLfjHxxHJORcIM7giIyJqKM)HUy6yYGE9(3QlKVv0aPdwCt0Du45Odx81sP(hD2gRHwtkipG7i1toJZgDzbli17ny2XUWpf9LDvcACoDAiPk03gDR9JCejHxuJpLWkDhdsB51cNXU(kXuGQJN6xrZu0c8GX8ntFZpltWOPxAOBm21MPEZsgg8zWxwINnvwSUtPAJh)Qebt)53(edzcqf6zkZcYJROnsNISU4g3fj8nE)RC)KI9Rr6KonxMPpTE(y)fGQSD2pK4dt4FHc5tHqHuwgG8(uAjSkXNTKVXwXXPwH)npMRgyPU0t5i9b)R6mCB74oLuzy(mvfPFIyVyOhJQLqqshY1Y5LrrTCXRkRiKiIAcvyXhK5hZd6cqpyPkK7p6dtR3pfebZks7prw)jNXFIOirwveh4(arX)aTWU2nMoGDyesU3hpZCcKF4TdBkb19jd3zk1y6KOT(CW1LoE1cvSPr(1DH)wUNUje4jwG)NisWavRBRXn8oYfe58cfK7MIjdgycQ))MmG57HDUcXiMY9xbd6OimQI8OQiCJbu7Vk95CUhqobzLy0)Kmgh3kKHzGf3q9Zpl1oz3DMBYuC9LtFGspkvDysLuRjjeLe(jTEoP(XRJQNc(fQqqPRreSZIGDgz8TxFvnG0YUM9vfsJiFkRkupUC(e9BoFDzAyy6lhFPynOL8R7mTA00fmvnCOk1DW)LjThmPn5CuZDEjMhwQ2arRZqcDRt38woTpSiHurlBjJyPFZQi(5)aM6IM3TKknPIm3rX7dDKkT55dA8TUOtVtEoqJ6oNRqpsoxmLSOftNx(o0izyreln8PzYe23)2xiz5eHnyOrWVf9k5D3OnQ5fKn(woTtTogh3mznro8W8PKG3skcl5KvY4t5SE0PwMooE0evUCDIxQhA()RuId(J8KpOI7JY1VNo5Pns2pxIj(DyAfUKLGl0Qj932zFc74N1gDBfgjTPngPWCsd7Cmi5JoKbmzeL4clPdflHXpKW0gY2sXzPTASqUy)99R0UNs2aPe2vsfPXrQMfGT3vb5MhM8QOg9C0N2XAtE6)hKR4V7Ik)VrcGCvAV7TykshMviJ55gRnKX1i(1H)p)aAN1fF85et554FZDQ)xJW6tnG2G7uo3bFsWzlXHg(1)mqQ4)afkVB(ffrrD7BFb9LfoVRn)NfMDlPE6Us0PN(5uP)sVAHkHCz8KYMzSUDAA8)qjuuVhMQIMcxQ1ZCwY72TSqjFS2DsQkbQw7Zy5974uUJjdXo1Yvt1p9sl(0NvOT(eTN9G2W311wesPLCEsiSzKgBIkAPHbrgD)tMh4sjiPjcS1wsCd98XzoH7s(CsngWCJlNyPsHaO104xNnjJ3L5X5vyYUzdIQgnUvz)TpuOOrm)ani0eeppau723lSpR0vFXYXlk)x8Yeb7np75zfvscoVMl8Ce7sAeqW1ESkGuhwF4QfL4)3i885wia6IA6DdIwHPEOO(Z)OoonS3jj5Xzo4bqkktFmQHEb(X4C9OMgsEuMpiPE9vto6y9rj96jF5l1InkwRxaB1do0KqDOKAchWDb61eymf62RRR4OkWTwP5Yqmx7EpxAemy0GUd7Q)kjk2yPi4RYBOOOEOdg8s2v0kVL(PRfBwwaAr0F1EIxnpcO3W1vic9fpnS(GpMht25tyPtzYQCKNCpXOsjPgRX7wZBTvjmwO2dAZoARAaOWLlytX)DzVmEGnMpzn3)DEcY6K4)jv7F(aqQMt6PwkiI6RABXr2369hHAEGPyQQ2442mQeJp)SA6)LGk4LDusDJ2fBZCClb6GQjefv)1lMxZHKudSU4S6bIuR9qI(DsXvKIcPrZPevgPyoHgKfXmbx(NTHCQplxW(NwWDz7zxOROprAvvcDu21Y59js6UQhY767B36Gi7uUYkcNTWywXuyJMGJypNSN0AO3orA6OK5qvUkttL2iyyhSA6OzvvKND62QPktD45DPcM0i1LW5KcRUYhOj9QrHHV9ScYqlbrOs(Rd3KvTSttu56Ky1nXq90xKsZ5ITSi7EOmpg3kRO8yxisE6xue4smBIbJnwqMCrx0kyGCW0)h)DQfaaMGYcTOB5fco)BrA5f19U89ByjUy(k)XeyBiQsid5raT0CWfr5Zdeh93wP00oJc)evziK5H0q4UKcN60PV8dVvGLs2lYJ8eGE)JQYwOk5HA7aEfd7KDx504dJYPX)ov50KVIkNg3MYjDeSUL3MyOtJTr50e9kNAK)MDPCsBTF87qLttSHyOST)eD5YqH0hsmCwdsZ3QR4CKlnoBnp4yl2UQB6(KZk5p1pvfdyx7R1nj9CDrXwNQLJTGvV7D76yInU1j24DDITNAko068EK0NzZPv84jlFUnDAC37j1nqMyHv3fknQui0sgfjaLghmusSR9mlWRS9uzDZqwNlBTBFuc1OaKSrn1vuPbwYhupf7eNgbFEfNWUdPiJglFXFmS8JwPPS9PmhxA3H5xxgvwLTtjpPr3UFEBtNtAglZFyjA9iEg)KbNiLLogpbUwvfGussIyxXL6bz(jLWs8pRCnIBfkDG1mFE7DdT5r4ssn4Olj3AA2QYMT9ueysNfcXoicmXslZK6qxIaTu5Z)ExeySwraTt5hlrGSMLuDtDR)NJUt94Fzru(4WM87rnLkBV2w2HwQ)5)C03Oh)FKzB(DO2LM()Lr3ZoAI7E9eq6JBN9gpoP(VXlUbErBH1OolnTELCTILXRaS5m0u8NueN6pTglV3a2N5PnogvlNaCUyxMG1(fcipSdh16HP9TvsfMXLhPISOP5afOMOsiQTa83fdgq(XJi9fysyJhqvASFcksko40n8mFmKH8LPu9mLbUQZVM)4WhZtMNF1l5vCg91VWF5v6NxV(8JkL14tiXS46Ro)ONuBE2AG86m)051VhMu5sPtyz0iXlOuEOlPRO0xulz0Z453(Obj1mlvlO1BZANutzpmLt44yCSf9RgWmL84fjDSXRj8JKNYnCKwxGEACIH7urRyDnNuB1PdYB55uxmT1MR1vOLNBEQBZ0xQBspnqLBzKckTNhfMNok7(7h7CrSNQ6)2Zx7sUhBMHVAiMHvyM(8a(ilzblrhDKGJSz6Bd2CIawTNn6TLt5tmLt5QoJ15jgygrpYOy0rk0NjL0NcT()tyN64OY8eQC3yLlS4JQhYkLI9OLe32Coi0iLUn5frJSJw58QsWmjEkvTI8JU5f4D(vOuwqwCmoVHY65TZ(vkTNvKWjYXULttkSsAZT6tAZI3duMmlRF9t09vtD2FeELTG5eeT5LMpxBj7wab58UOaLAdyQX7uMBTQxglLTUVLLvhqJGAzoWuMW4jBjvWc2S52ZRNusn3qUSjPbggMfsix3tI68ugPzwnnu)A1ZaSyqAlRznW7v)ebgFwB9TMbexANlnxTxzCFBuNwD8qzBiLZkOMa3fkBDRLNrQJpXc6D9(Pm6YBqPX5k(6WxHsnO1Y4JxaFfHkJm(F02z)mD3W7MeLJ2sJ51fHuPR53eDOH1r5zP0vliIs38lJ(dBHv1QF7vHMO(9RHDMPCuJJCQrLwRciYZjN1rj()7iLxBfRnDY0zfTFwiQZGLY5yhfPOT29wA0R16H7606oYyqaOFTMdBuMiAU5oyQALZOJLPw8(QHzD7CLCEC1UWTCZ2xS3VDlhflX729jVeV0(aMwiUNy0fZ2lK0gLq6)vn5WPMSHQL(4ROSowD6NKzgK9OYo1PASrMFNcLIxTM1Nc0qi3AT99lRuJMsW9VIARXB(BUyvJqjQ(hE7lXBNb(LvfABG7Ih48tP4fzcpYDHIdZ8V8UBWIsJUTrtyP5bzCgi(fSkXPfgHC6HROlnuFrGyHPKe7mELmH35UTyJvfl49aQQnfGA6tRz2Lo0Nl9RLD3VK(lhyB5RlnY4vDQ8ldgSrWFQn2y2)b9wDfMCDQT(GW8hfcUT0utHA66DMQAkr1Qx1jl0CvarshC9WJ5AHNqIsPfce8qDWRrHuUSi7Z(LjS7eS0QtTiOsTrB1htePWECABbn5eI(uU(umwsLjJfvN8xne2qXIORsLvq5AxptI9fe2V4hIhBJ4MkREu9mC1e1CJHoSkNgNol8Zo55RTxs3E3wFRNkAx5S9wDLH8WeoFjsKM1wvdTT3sn7QRuDcVLf4L4w8Q8(nqensE5ncug69aovxyivR10U8OQhlpptkBkPXsFbLAMCYj3MEmB6jZYZQEhNAwnMQ8hAJc5rg9I5OkncY0ZJmh1s1auHtgR675sNOfNrr73GkaOJSf9DL7kBlLVMPIwutz7l48IPQ3hTed4WfMrTeKWJkubXlccEwLUT8rrdF0mWFgtEGuLI6h3MzYhLxm2pLz03A(TkI6JUSELY87g1d5)13clGEhoc0JtOPrnCw)e)BCTuizJy97Xd1kvMQhzrimF9vJpQRTXuw53XQrURrXYfqUyFj7tT33pUqonhfYnZXhgQKfiowgi5BBRAvnFHgrxgi3anxDZOXfxLkqk8f7RWXE(flCXLxOF2tlkAlHlCURCrQwX72aFMJZWF4glV6J0k5wWFFS5NsWXcj)kPSOWh(StaBLRxZ7jQwaKOgx6ai0(nTCt3AEc(ihoRAY4MINLrByA5UZ12jr7V9J1ptg69ESfthmJNnmPw)9WWn4MxI8g69OgeylQ1ellp)Oz07XcfJIsRRWmWjewajDcq)dWKVru)FL3(x8FmBTFc67Lpv(3v3z3(BWKAJENzNNNLfrVnj7Y18q)V1fo64M8HF5ln3Q5aF5p0d0yi0lBqBQ52WR3CTB0GmxMsRGkNt0AlvzZgVnEBOSdFoZXru11HFVERn0(rOlgdZxx41GvtvLprVT31mwhhALBZbT3DeQUgyHZyvx7gkHgh2C8hclIHsv8W5bo5hKsval2rqSBe3GyLd7xoasSpZ8YZko9zDh(sdkHK8HmKNJVjDfdTwFfBXPUUDmR8u5vzUVsWCFUQxjMU(m46p5c9gJMswXICxPZ7FjHEBNNIplfPfLXng1lasROihxxKsk1A41ooq4IstJ2uMSSfT34A2VcfeVMNqpOlXzWJSjxE2eq8E69UjOQ0ur5YZ3HqmPFkl9P4gq0fs9IIKA1nplsu088hCR0rB)X)MpMnsJ)EyFPOqyyOMFAbFrM8nW4t5tx9nwWZaD64XF(KUGCTCYubWAZxtlH7HdJhaip5Gb5ZFSH8ES(T9h1WWMM1pgwdOvLUrfCQP74h(jA7lnKkx1LKAHpsfsxOhskwLRasd2SBlSlDiqfSn8uqfIxAGEkf)qvYPMqlAjulZJdfq2i)oSeEnC1Ubv1GR4wc))yqfkdZKc8Ae(jlH3HMQUZ473(4aVDqM)7mGzs53RkYPj1FvH6RmHF88WTbgwpXDTeAsHkxbGAcIULWuXDbf4AidvTe2sM4QaxnjV7xryEiPbQPdQkWnKTOwc99y35Vk4B9dvxb26Ziwvi)NgCkHbiUZ6QmaVAjNPQcbDjUPLWDW2dWa83ZDwna1DEN1VsuH)aWF1)9chFMbLSAIGSQ22wcYSTdZEylSrqoeMU)ho81Gd27bpRjqUZmTMa4Gj3(vBaKYBtfqRjFpBaudrWy3PZg8oE3bObtVvYhafWAiBbSf4d3IMbZ9hg5otaFp0tyWWP9Ct4Xg2ZyV8OWeq3HnIMyq94GWKnz4vpAcK7SuMjaoycch(bWGMSHBamOztkFauaTMmf4XbOgI93aBwLPHzpu)yeKdH6YjgcY0qtwmOcT2PM2q(uZzUAlGBEyQkq38PTA7qOCCIA1T24WgBa8w1xVZax7PpiEpUFAVocIHxpTbP7bMJZWOShYHMG4qigAqeFN36YGunLgOolZtcDBeQUAT1t4oqbOYua)LtIvfqR95BYs4UxHT0am7LDwALsJtyEyMlUVYPIlvm(LVTirIZaVEyEv0WQlEmTDQULL7)aGPif2XDa0BO79ShAdZR6YWc89aRH2sfVEATH5172Wpi7XmynsAAd3l6Wqc49aFXejQn0v0(ac2(JS(PJ24NKeLGNQ(YexVS8e0PPiyZNKO7t1mqw8j1nRWWGpXgHvdDAOhateolaTjbwTDzyb(EG1TjOASBd)GShZa9cTA6Wqc49aF1k22S9beS9hzTq0wDGS4tQn4ncOxPQOgxxQA09ORphuWFWa8xF8gw5whXVCpD8W7uc966B0N2W7Oyghbs5jA)tnDBZE0XTH(FZ3u9RQ8HRO1Ro7lFPT2)MVPnyJFDBZWtkid7iQVxy((H4LRknI7CPeE3Ct67tTf9Hg8hma)1hV7witFFAdV7wiBsdovnO)GjKPb214v1mdnlKzhQVxy((H4LRkncfNSM15Say)p4ps5PSsEiwzhSe96yBP31yeADidFytod21hMT3XcO0rkUEYLvBmBR72pO1VHW1psn6tnW3iOJYYowtg7Q32pK2tg7S72pODqg13N6U4zYQoAjGoTU7xZcIDsxlFq01wO00REmg3V2pnMNhC(aHpjelRwFpTgS0r3RpQnc2PmLRZzMPE1JXW(zwNDV(O2iuRLJkw9zJCdFWzrCABBkzQFd94GkLD2B4Zd6Vd9as25KrPZhKrS1GMyAmgBjvZC)g6Xz3wDuHFR0Qo68bzeBD1PrqV7npTDRo7)40(QJTWF4KDgOrCNwDSNNE)wDSFC2TvNEYjpaRo9CeBD1XuqbGTVcUt7wO8FTDqzSEOmwlumLGfd5HMB4enll2BfixDd30ta2RdCRDqTxjELPePy3NWdXjm2oO2XjmDOLlJccIU3NUckbbz8QpHv90sxEXtYl(3TZWInNUvhk6h9mUSKFpRw17flWoVWnZDUBk773(J8BoWe)mdNwQBekiUpNtQ4e13Vsn6rVAAhSm4YubHoej53HmXLg(8SYKa8qqjmKsT7rw0yaI7vonyaMdu2D8OvUu7GgYVkfE1V7WZ)WwMn7zMyFOlFP)quliMQrH9CJXd3D2qtpE3FQQH9a2hq(1QAkUlkWnt3gSvn0xqoqQzmb(9HkBaK7DQdAQ2pe3fqkGS4gcYKTCgQOIIBYyv6zXfCSjWzuhW(Mu1gm6CxXtt3imhGCCw457aDXa1)nOnNNhLh7L4AGQeSvE8RPlhqGBgShGzpgAKcmqdYP0SLaDxM1huG3jyTpezwfkU9FyAnsCMbF3NDVf5FZqd(UyO3J9xmDuvnFZQBdtnWdoSa3my3zXAZiyRI1nA2sGUlZ6dkW7eS2FUewjwV)dtRI1MbF3YDwKXpdn47IHEpeRnFIMDYM09wldlW7dy7f5T)yDVaFNaE3ejTeR3nG3hW2RDO6pw3lWBgW7SQ)H3hBlM09yP6Gc8ob7UjkBjoVBaVeSMpX5DbSk48WcCla7GKVwwG19s32bg8Mb8EleEGj0wKz99qm8GcClaB3Kels5slW6EPR)adEZaEV59oWeAls48EOA6GcClaB3KelehTaR7LIPdm4nd49M37atOnN22DYE0TEVHf4wa2UjjwioAbw3lfthyWBgW7nV3bJqRnq4lXoS)HaFNppXH(ouZ0rsmmhj1bme48pAVV5nma39(aUEKVq4351FJPS4GS(FaJv6EV(V9h)bsYgb3RQNrDO47TtbP61rj3oDQ)M3D704KOL(bLVlhPJkVqrE(vVSO0VEb(UVCLq9srrw(ckVwVQsVuZs5VQqTAE9zOTnGouuo6ABNk8BTTGj9NCd(Du0ZB)r7NWt0oH1D3fuHbnVHa02M2jSALURTL6t4URYBBMW3ZCJJcRnBXTeIJzlgnNLMbwceeL1hqL(qO3lIIVkLL5VuaYX8)2HfKYU6Srx(cVOWf(ianmA)F2o7V)q2A85flcfAWNxFVi6rf70TZ(iiBCteTHwa9Q2W3(kBTp)H2e(r)nECzO)zoMxPRWN6jkdsjezuFMpzUIe6Uf6ZZUC8ftE24ljm)gMh9ihDpG)R3otSGXrNyx)KIx4OBkTi4f4lBfBjJ)6sVXpmpJjEuqhx9Zcaz1IrLKBpxp6UaR1yv0qv1QAaTCTFQR(Q7dXyYEtmAuiSACpzOigAaTmXqxDWsSFVh4krB4WNCsjMgoN)2zZFGE(jJHPgkTWF9)fde)H5I(vIVd4mx4FNpj5HFj1wb6i1DKSGpKL0t0g2FyNNz)vxoouQSeFhQw4V0hz0p2lpjbKDX39RXJU8ZNWfqwXFpCbrE)vRX(fN4hbk(EG3SeOkMzWaXnVv3OKcuOGf83wtUfTl4VXBs9UAe8d9syUPiPdTrEbt8JWq8gkb2XNPtXKQAmww8mD6kjSZFNpJsk(xu6SJSFfs)f08uRugvjnUXnm3nOXwX(MR0wfbiJfhRs)Q7nrFqYj6rYwlhyfgBlqsnUB3hKCSt0kVfo4toNappRpF(K97Zh7W(Sxq(cMUfs1cJvzHXyPS2heyIbeqBL5Qq0heeOqQtvD8ez1XJLug)eJBnzsn9x(Izf4sAW1EM5N8SJ18XOa8jpZ0Nkx9xNC9Xs7yA9qmwziARaZ61EFnj3(lR2FtJzGNlVo0aplbNnRpnBP5cudRTEwJMacdqup4lCV(pF4x5SAPJ)u17CaeymUGCKKCEWDbxlRxc(zY(IFXn8tKDPIxYCyBTyAJr(R3j9WAAXSlzmP8KEiolSeB0zpJGLd5eenA)Q4JeBZckLc5wcGpRpWWTg2fLmKrGnPIoMhdJl1a(8II(e8MO3pICF4djrBG9Vrlkil4H(CrkZdFZ3zBW31y)pXeM1KEpdSWiocTdIQnn)SNIMsbo3r2Ltwj4JM(KcO0s3eAa(Rf4K0txCgy8X2zFloi4kuk3yP5Sv(4ngdoHMZ4Vk4U4lRCQDMfu7bY3nI9cbB2vxGCjjmGpXgWi989wcHZKGWGUom9J9FQbBYwGxVQxZmp3qyJUmw4cNfjANBDdd0bCegW(CboX(cM1sJZ9dX33zh(7gHF4YC8jk15SsLfxFgraPxB4P0k8uEvYcSKLLj72z)mmzZbXi9iu9Ngvu3DzaSuR4w9qOSCsL(2YF3rh)KAXU6lFP4NLQZtd6SKF4Fry)evGdgpid7JAczmewKFZbUGyvmAPmNrHBw9dr5Gubke5opkx4i90PKO2MOuYdcWIs2D0ddoX1ffZczC2u87iiCp18n)YPx)H3E61tNE61jrkumy6aJo8VWjsjnPYlnXRXTKBB0tY9tk5fuF2XWhN7UE65)YxWrV6f(96RMCcmqGkGJwc(aL5iorMxF(LksIGofygXq(rU)ECPYqGzfulvIKavmL7929rjFIKf5Krud3g3p7VjFdQ(j7E6L9L7IN0x7TqelcGmMujGdQe9xbAaja(ou6MTCj5qfRWd0rYu26cvis6unkQcvsK4IP)F()F3DT3BBBDf)ZIXayKSvufPKtd6S8qsCCrgArdQZ6WWWQTSeLnxue1iPQJ7F4p77Co33pjLJAsrq)JulEj59EE(784EzVEYll2aqq8dvQH80N3)0)MAqE(0kdJads(VGF4PrTwiAzUInOaYCM9gUgCnt4dOg3)es273MvSIr3bnBArRrKONPATYTjiTAGSAHPwDZeOCMRivYbExdgxWvslmTw7l3UM2VVdlDtlKG9rh(soys2KMEY3MKxxtBBu4UlMx0C600KdOLf)cW6VQg)UyB8HUF2If14h5(PS5TXZw8cpC0WjsdiQTORWiI1Eb2vvAmlNi)7xdyIe5W4I7Rkw(FiZhYQkWCsutwIRYB2wrELrnH1BrBuSuDiheCriaiGK(b8HsMCAUf1YwONtVT15m38avQjF2cT8LGzGzv(hbxaV9hW)IJzRomt00tMInkxcMCmpsv98SApzs)oi3aWc0SSBuoIKafsjXxnMe)O2wnoXW5qRYFE0Ppz64eLHbwTx4x60J9jA6rYeuHM)(t8CbW84L0fz3LzfZOlmnJ5F)N3UH7A6dZK4hrP9vaNhfGUD2Mn3RtS)FBbOUdyjWB5L3mFX0u9lZZ9H(pHPk5s2FEjwEhJq8mKDQ2U2DGiar8d((8giobGH6OS06tOUH7R(f)0RnR00F9HR(PnO7dw2TqBsOpLLe4x05aHvCgp5E3SQ8A0Ml5wHJGKDJWfxwLJgMFPcVbmXHzKLjVbZVF(ki8iKJ0uZwr(8Fas(cvfT9JQcvIXEjnXKMCIgnHplUTeS3yY1W3SMDnX3AFW22jpJBiKUlCQa3Gu6eZ2CsprfJm3nNmPUATzVZqST2DY0jmRDxamc0SKabgLu25G1PxCXlER96XayidPIy76HoCeO5mpgdSFiAMU1mnzzDoX1mEhC0z5Qh9ZHYFZPgxqp7ZXwxHwfiUCy6bE9blsGom5Iqi0QbbcLnjmt3uvKVKfNJ0HH1l2Vs6YR1MhkPZKasS9CTukLyTn1cOf5yYGFtNq6WL0XR8WvVRydOMb4OruKGXPQYnfZOcnrQuOBPTiKzv8EBaa60I)CI(bw0ipJafT6Uc0zh9ip3rZ18Je7UbUoUP)wqeM4n0dhFv2Upqq5T8Kpj28Yt8u(EfheIHYuJFfLpLZjX8xYyOxD2fyWna86IFNcD57aZURXaGyjFbrSYRRcQ)drpiQ)Wk66pV(ig)eeOqMBo9)UGFM1c8MArMkgpYrjpMGDh5N(R9LWEOmRu2P1qrQKqyKAd6NFd9r9gu2DiDNnLG9Y8tN(CfcsBBOpcDhMES7BzCMh4Nj(gz6X(JVBKgB)1CPoWAok29Nro)oPjV)48MSmtTtnc4zVKruwlsNaccHWBq)YnLSYFcOsqxZlxvEhg4kdSylU3oWd4ABCMJzEIjhXyUkygqXGbwuMxV(jn6V3x)YbA(yi8jyIcX7fXx9QZEeqHECOC)0qkHrAPfD1FN17fkknfq0tYEIterZig2RWyVwMxHZm7iJE4Q3Jd8J2ucECdEia9wu2ORrFjlF6k0xzG5cPGNv(iov6z5W0HzkPq1i6Bpt2CFvUKW7jqbqVptZDMhTaeBiWkoCsG3hqE)hif8hNHARNPzgJjQ)QxIP4zDJq4A(SnosYA3uqPMhdyuWLNKwQLVbUPGGprPJ84dJ(Nd7jsP6rJgMYDs(27r3JtE3rKe3y8Fzbs8lYtXe6kPzuGgWdJjZH0QNIj9PCf7pOG4bBeb4Q9SnTp5PmK7E)MZbixKQnQJtLGi4e6s(Lyp1kqTdhn8BpU)NGOK63met7N4LfcC22Kk4CzpwBMMf5APcRMNoT34N2c1un0JJo0dZmGp9dNleiG4W3WQkdd8)vqOeGAZ3XDiiX2YpJwgi))y5pfhnlpp5IuSISkoAbAi1LWmWwaYi)4(mtjtRc7TXPxItkgdpNEHaly1hZVtpNbNsoK5P7cIVM(zoPrCg1HXFei)D2U5s76SB8JlTlmw5)QeZWXcrUPnm8TQ8gSnbxsf17I3Ttg8aX)I1W)MduS7VK(RlbwsoM8wiADigFTRaeOKMcqGh8CyKhtT49pviUlI3V)a8TxvTDtJ1tE(QInirpXdyIhZRbKK66GdPN7KoH2SEdplVQAsfh0P)YI6B5MxfzwqKqIDuvry9K)usSuuuLz7fmXCECQSw268cSnJ6gY2BQYZxBKJvn1gEgDSvLs8Gkm6c0ZcYmQXcXrBeTWohMPxduDKG6BLm733wHmMQI37q84jTZkMcrgQROc6JvsJsdWQI58YlvksfGEXOZXKdAI6EahpoeGdQu5Y4SfSspYlKs34geMrsbpE6TgGJsJeuxQ(W8fiITy(P9glMng7BH(h2lW0SFF3a9EMI3zm2ot3Y6cDl7OSd3rkx2WUs4SiXDEMpUlZ8Xhno0m)aFu)WlOPJhM1XLK1AVZROjb0F0tfJPYdl7zv80NvALcTVHTc11IwEnpfLIWknuHqJ57zvH(j2XrRABoJslzlBRvuIOZ6mx2oc(l464rlyUdRKqWTDspNacMELT8M0Ue)iN7gjASEv0Se3dsNE8Y7FUiuDC1pHRf99vuBgCborRfNh4KotvXn3G5LYY9T8PtULrn3pKxnBfs7lRRbyFodWQDz4VySFsEXCwYe(b0xVODUWU5gWFA2JxG6lR3WUoht1YbQ3sn22lieUIM8pWam8(BXUGDv(hzvxOaWWcWjU52MqPlkEtHGYCjbqZ9mAT8J8Fbwji(3byQ3rKo1BkQWcRXrf)bwIaxNR2INn3LpJ1eigRhwBwr3DKYzPvPvgAsPS3yRcDzrU2Zvntv)cw70rfDqLUpzSCOsglEFsnBGrXkAy1)yO1u9lwXkaJaTv0HOfcpXlmglqL9TwTpYk3z)uQ0ZoECYWeVPUx2VaZ2wpJLSK2igtaZt1qGUxxUEB9WM7Ul9YjBMRau4MSFGdfFU98Uo3CZkDsRmp4H7oDJuDx33rFVLtal8GVYjKzXKILfFFbHA78WqokXyPKrlfMs7)fcsztjLTa)UBs8wmS450)D3wHjk)cQTcy5eFaUjaxRNRtE0NVGsE9dx9l05oTfrWoZ5sOw7AMj04pAjlV)N5KGtRPpXCGRmq8E(wSbVlXFnetgbm51gOwRBYgRECTIxH7Tzr6LgMmQXDBDlP6XzCBl3cY2v5muzu1JIBR8OjETGZ)rThn8qxqV22MyALZ1CiTm5SBKp(eSFyqzb4PIKJdHxpk0yK(ro(tQ2h(xsHEE6MgnDUQKdNeppI0acvUC1vmF6aj00Iiqy0IJtK5wcQ0WhU6Tu3hpRI9jNbt8cPYwJ79yEZGwUTPM2AVOc7z)8WVuvLnI58iLJpi)2F1xRB87MlsR5OUbct3L3wwv87LRdx(D4gC1c7QpyxpqHR)FymbaKGoOAhuDvMdDtNN0pzjStpOGxWddZH6hGCzHWR9wAWhYpzhh5PSkjh0ojsqGBRhD7l7TPwhQ3LBFFPY8RnT4iXDSp0I3jGO9THzNXHzBH2lst2OCAZYgq9D0MkLEaA)ItvJATvp(NZWoQGQTW5V8BWEzJTtQqmuZwCpJ1vJTdjlI31u4FpC13)QZWsLtBn8Q86TRAEq9rgJX0xxIcvRPesSSGNlayYPj5yXkVdMmdG4rJc8a5RbGfBZLcAxXtwI4eSJKpA9Tx3H(m6q5yiWJ7PX9fVBVKwPs(dx6lbHQD6H)56P7kfr1KUKehZmskZisgjEwlfYOWDy18HVtbZ)yrJiyNmS7HSnQyxNPDG(4lyizmppnuKs9pKtxDRjNXeZOivFwNywteJUdM5At11ZGTnUJTI1xkhPwmXw9rSY8Mhao0ZjAVt0wEdewd7yP23tz4julaeXPmxKww9xExNlBSnEC6SUWaOQLBRMN3MSBpljk)Od7eL5WXb73HqBxj3Tpsh5cho2MpeO4VAbtBLHf7vEsOqTvr1foCC5yaAWbS5L3XHs8uMRr0ZIQyb)Ng)Dd1YvONvG7ZDlUeKClXtmfCoZ6ggwTGuBDqChWG)D2i3oXcnXL9olcMO1R2nDrAS(3NowTS4Pt3LmK9vdyS2Wu52DH2QOg9udtgbBUfiUHVJZRUg3DWvlW85ldY3UlBOMCHhB(jITLvedL7wlU02tlCJm6T5yunF5zG5uv)4ZeCXIbVMHZh3uJIOdy7NFX(jPO5j4pQboD2nZqqNIJpi2mcRuZBoZoTLDOdKDeUHiB9TBltbfbHqy567)4LRYVz2CSTQ9o8NnkXZGBXjJV53EpatnzCZim7KdqVtdFeazYWgnCsa)eK0XzOrpED3EnkQdM2ULyWuDPaZuY9kQY33vWChOpKCmm(vyjPMTKIGu2Z6S)S52IkeVyb1cqQdwc2P6kT32VEBtdUQJPU(fOf4sCQTnYoDn61HEL7p0x(UyEXFh055xNFTURtPdSaBjpxSPwA1P7wtUfXR2NqpUfo588NLBlO6R744)Mgahd8pfgT)MQfdTsFZaCl7lcusLZgw0rVr7BAClWX8MznElEBvoaruF5FmF(2gw6VTZcNC27PKcxJhbLYEYvhABa0PXrCECFlB)ttT7yqM5cEldeoKmSrjexuSRID61bZJCTarX1ZmZ7PJhXDjRD3aSiWYfdDgBtr1ZtzmbCB6HijBehtSYw3ZKrE3yLQQjmQpVSI5pOFM9HYmue50PpikhjollwWpafhiCUJ(Xz9Uc1UhCCU457j(B2NWN4HuOyBAZolty3lIFyIjE4xZ6Uf8ga9VCnSfY2Ayr5wQdnzGT5Z)b0uhXtGf)Sq2AnC)hxCX3G9iXmzshy9WoRwQW07NQKZA1bMuCXb8OpvS7Ztdji4704chxDx28VUzBx7eQsokvjZOjGt21B7eAXquQV7XjN4K3cd(R3JAw7PJrhtzfvUy0)s4PFC7zVi9CM2Pp98qS5NZF99CQFjonj1pGb9EGND6udfm9XR0ZK1FeGmgU4IO6SBOu9fPBWYaCKfBSfu3LBZ6UCB6ErU19tTWF8YTz)rj3MgqU1DrgJvM55IPXKBZCKBdCyaguU1ZHR7Nj52SylOoi3IlKlVfmJBKGC9dWXy2C9DWf3nIt2iqyOlNKJowEIrngR3hc2kA(oYP7MfOat20Gt20UozFuQr7hf89QsCS()yFjQpoQ97iweJQ)edbabQ7nlfHcqiHqeoupxXVp1run15V4ss0m)eUiEjcXBt(8zWJyXXxWUE7pTRlfzis9CIQFB2ESoOR2LZZtHJqnUCGJtue1q3mk4CClh1IXuaXFp9(2D0W0Kd2uL)B46dy6APLz3fgJAkkYuMNoGarHCYXwTmeewY4rhfAUPNfSDJFM5NFMf58zTZ8ZS4UHvxlc)07bX)NB(zQn)0Zu(Zk)8RbnsFtm5jz((HV9No9WVg088nX2Z8TVa6B)Ad8F)6))p]] )