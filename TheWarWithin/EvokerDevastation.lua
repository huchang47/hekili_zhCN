-- EvokerDevastation.lua
-- August 2025
-- Patch 11.2

--- TODO
-- Hover while moving recommendation spec option

if UnitClassBase( "player" ) ~= "EVOKER" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State
local spec = Hekili:NewSpecialization( 1467 )

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

spec:RegisterResource( Enum.PowerType.Essence )
spec:RegisterResource( Enum.PowerType.Mana )

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
    natural_convergence            = {  93312,  369913, 1 }, -- Disintegrate channels $s1% faster
    obsidian_bulwark               = {  93289,  375406, 1 }, -- Obsidian Scales has an additional charge
    obsidian_scales                = {  93304,  363916, 1 }, -- Reinforce your scales, reducing damage taken by $s1%. Lasts $s2 sec
    oppressing_roar                = {  93298,  372048, 1 }, -- Let out a bone-shaking roar at enemies in a cone in front of you, increasing the duration of crowd controls that affect them by $s1% in the next $s2 sec
    overawe                        = {  93297,  374346, 1 }, -- Oppressing Roar removes $s1 Enrage effect from each enemy, and its cooldown is reduced by $s2 sec
    panacea                        = {  93348,  387761, 1 }, -- Emerald Blossom and Verdant Embrace instantly heal you for $s1 when cast
    potent_mana                    = {  93715,  418101, 1 }, -- Source of Magic increases the target's healing and damage done by $s1%
    protracted_talons              = {  93307,  369909, 1 }, -- Azure Strike damages $s1 additional enemy
    quell                          = {  93311,  351338, 1 }, -- Interrupt an enemy's spellcasting and prevent any spell from that school of magic from being cast for $s1 sec
    recall                         = {  93301,  371806, 1 }, -- You may reactivate Deep Breath within $s1 sec after landing to travel back in time to your takeoff location
    regenerative_magic             = {  93353,  387787, 1 }, -- Your Leech is increased by $s1%
    renewing_blaze                 = {  93354,  374348, 1 }, -- The flames of life surround you for $s1 sec. While this effect is active, $s2% of damage you take is healed back over $s3 sec
    rescue                         = {  93288,  370665, 1 }, -- Swoop to an ally and fly with them to the target location. Clears movement impairing effects from you and your ally
    scarlet_adaptation             = {  93340,  372469, 1 }, -- Store $s1% of your effective healing, up to $s2. Your next damaging Living Flame consumes all stored healing to increase its damage dealt
    sleep_walk                     = {  93293,  360806, 1 }, -- Disorient an enemy for $s1 sec, causing them to sleep walk towards you. Damage has a chance to awaken them
    source_of_magic                = {  93344,  369459, 1 }, -- Redirect your excess magic to a friendly healer for $s1 |$s2hour:hrs;. When you cast an empowered spell, you restore $s3% of their maximum mana per empower level. Limit $s4
    spatial_paradox                = {  93351,  406732, 1 }, -- Evoke a paradox for you and a friendly healer, allowing casting while moving and increasing the range of most spells by $s1% for $s2 sec. Affects the nearest healer within $s3 yds, if you do not have a healer targeted
    tailwind                       = {  93290,  375556, 1 }, -- Hover increases your movement speed by $s1% for the first $s2 sec
    terror_of_the_skies            = {  93342,  371032, 1 }, -- Deep Breath stuns enemies for $s1 sec
    time_spiral                    = {  93351,  374968, 1 }, -- Bend time, allowing you and your allies within $s1 yds to cast their major movement ability once in the next $s2 sec, even if it is on cooldown
    tip_the_scales                 = {  93350,  370553, 1 }, -- Compress time to make your next empowered spell cast instantly at its maximum empower level
    twin_guardian                  = {  93287,  370888, 1 }, -- Rescue protects you and your ally from harm, absorbing damage equal to $s1% of your maximum health for $s2 sec
    unravel                        = {  93308,  368432, 1 }, -- Sunder an enemy's protective magic, dealing $s$s2 Spellfrost damage to absorb shields
    verdant_embrace                = {  93341,  360995, 1 }, -- Fly to an ally and heal them for $s1, or heal yourself for the same amount
    walloping_blow                 = {  93286,  387341, 1 }, -- Wing Buffet and Tail Swipe knock enemies further and daze them, reducing movement speed by $s1% for $s2 sec
    zephyr                         = {  93346,  374227, 1 }, -- Conjure an updraft to lift you and your $s1 nearest allies within $s2 yds into the air, reducing damage taken from area-of-effect attacks by $s3% and increasing movement speed by $s4% for $s5 sec

    -- Devastation
    animosity                      = {  93330,  375797, 1 }, -- Casting an empower spell extends the duration of Dragonrage by $s1 sec, up to a maximum of $s2 sec
    arcane_intensity               = {  93274,  375618, 2 }, -- Disintegrate deals $s1% more damage
    arcane_vigor                   = {  93315,  386342, 1 }, -- Casting Shattering Star grants Essence Burst
    azure_celerity                 = {  93325, 1219723, 1 }, -- Disintegrate ticks $s1 additional time, but deals $s2% less damage
    azure_essence_burst            = {  93333,  375721, 1 }, -- Azure Strike has a $s1% chance to cause an Essence Burst, making your next Disintegrate or Pyre cost no Essence
    burnout                        = {  93314,  375801, 1 }, -- Fire Breath damage has $s1% chance to cause your next Living Flame to be instant cast, stacking $s2 times
    catalyze                       = {  93280,  386283, 1 }, -- While channeling Disintegrate your Fire Breath on the target deals damage $s1% more often
    causality                      = {  93366,  375777, 1 }, -- Disintegrate reduces the remaining cooldown of your empower spells by $s1 sec each time it deals damage. Pyre reduces the remaining cooldown of your empower spells by $s2 sec per enemy struck, up to $s3 sec
    charged_blast                  = {  93317,  370455, 1 }, -- Your Blue damage increases the damage of your next Pyre by $s1%, stacking $s2 times
    dense_energy                   = {  93284,  370962, 1 }, -- Pyre's Essence cost is reduced by $s1
    dragonrage                     = {  93331,  375087, 1 }, -- Erupt with draconic fury and exhale Pyres at $s1 enemies within $s2 yds. For $s3 sec, Essence Burst's chance to occur is increased to $s4%, and you gain the maximum benefit of Mastery: Giantkiller regardless of targets' health
    engulfing_blaze                = {  93282,  370837, 1 }, -- Living Flame deals $s1% increased damage and healing, but its cast time is increased by $s2 sec
    essence_attunement             = {  93319,  375722, 1 }, -- Essence Burst stacks $s1 times
    eternity_surge                 = {  93275,  359073, 1 }, -- Focus your energies to release a salvo of pure magic, dealing $s$s2 Spellfrost damage to an enemy. Damages additional enemies within $s3 yds when empowered. I: Damages $s4 enemies. II: Damages $s5 enemies. III: Damages $s6 enemies
    eternitys_span                 = {  93320,  375757, 1 }, -- Eternity Surge and Shattering Star hit twice as many targets
    event_horizon                  = {  93318,  411164, 1 }, -- Eternity Surge's cooldown is reduced by $s1 sec
    eye_of_infinity                = {  93318,  411165, 1 }, -- Eternity Surge deals $s1% increased damage to your primary target
    feed_the_flames                = {  93313,  369846, 1 }, -- After casting $s1 Pyres, your next Pyre will explode into a Firestorm. In addition, Pyre and Disintegrate deal $s2% increased damage to enemies within your Firestorm
    firestorm                      = {  93278,  368847, 1 }, -- An explosion bombards the target area with white-hot embers, dealing $s$s2 Fire damage to enemies over $s3 sec
    focusing_iris                  = {  93315,  386336, 1 }, -- Shattering Star's damage taken effect lasts $s1 sec longer
    font_of_magic                  = {  93279,  411212, 1 }, -- Your empower spells' maximum level is increased by $s1, and they reach maximum empower level $s2% faster
    heat_wave                      = {  93281,  375725, 2 }, -- Fire Breath deals $s1% more damage
    honed_aggression               = {  93329,  371038, 2 }, -- Azure Strike and Living Flame deal $s1% more damage
    imminent_destruction           = {  93326,  370781, 1 }, -- Deep Breath reduces the Essence costs of Disintegrate and Pyre by $s1 and increases their damage by $s2% for $s3 sec after you land
    imposing_presence              = {  93332,  371016, 1 }, -- Quell's cooldown is reduced by $s1 sec
    inner_radiance                 = {  93332,  386405, 1 }, -- Your Living Flame and Emerald Blossom are $s1% more effective on yourself
    iridescence                    = {  93321,  370867, 1 }, -- Casting an empower spell increases the damage of your next $s1 spells of the same color by $s2% within $s3 sec
    lay_waste                      = {  93273,  371034, 1 }, -- Deep Breath's damage is increased by $s1%
    onyx_legacy                    = {  93327,  386348, 1 }, -- Deep Breath's cooldown is reduced by $s1 min
    power_nexus                    = {  93276,  369908, 1 }, -- Increases your maximum Essence to $s1
    power_swell                    = {  93322,  370839, 1 }, -- Casting an empower spell increases your Essence regeneration rate by $s1% for $s2 sec
    pyre                           = {  93334,  357211, 1 }, -- Lob a ball of flame, dealing $s$s2 Fire damage to the target and nearby enemies
    ruby_embers                    = {  93282,  365937, 1 }, -- Living Flame deals $s1 damage over $s2 sec to enemies, or restores $s3 health to allies over $s4 sec. Stacks $s5 times
    ruby_essence_burst             = {  93285,  376872, 1 }, -- Your Living Flame has a $s1% chance to cause an Essence Burst, making your next Disintegrate or Pyre cost no Essence
    scintillation                  = {  93324,  370821, 1 }, -- Disintegrate has a $s1% chance each time it deals damage to launch a level $s2 Eternity Surge at $s3% power
    scorching_embers               = {  93365,  370819, 1 }, -- Fire Breath causes enemies to take up to $s1% increased damage from your Red spells, increased based on its empower level
    shattering_star                = {  93316,  370452, 1 }, -- Exhale bolts of concentrated power from your mouth at $s2 enemies for $s$s3 Spellfrost damage that cracks the targets' defenses, increasing the damage they take from you by $s4% for $s5 sec. Grants Essence Burst
    snapfire                       = {  93277,  370783, 1 }, -- Pyre and Living Flame have a $s1% chance to cause your next Firestorm to be instantly cast without triggering its cooldown, and deal $s2% increased damage
    spellweavers_dominance         = {  93323,  370845, 1 }, -- Your damaging critical strikes deal $s1% damage instead of the usual $s2%
    titanic_wrath                  = {  93272,  386272, 1 }, -- Essence Burst increases the damage of affected spells by $s1%
    tyranny                        = {  93328,  376888, 1 }, -- During Deep Breath and Dragonrage you gain the maximum benefit of Mastery: Giantkiller regardless of targets' health
    volatility                     = {  93283,  369089, 2 }, -- Pyre has a $s1% chance to flare up and explode again on a nearby target

    -- Flameshaper
    burning_adrenaline             = {  94946,  444020, 1 }, -- Engulf quickens your pulse, reducing the cast time of your next spell by $s1%. Stacks up to $s2 charges
    conduit_of_flame               = {  94949,  444843, 1 }, -- Critical strike chance against targets above $s1% health increased by $s2%
    consume_flame                  = {  94922,  444088, 1 }, -- Engulf consumes $s1 sec of Fire Breath from the target, detonating it and damaging all nearby targets equal to $s2% of the amount consumed, reduced beyond $s3 targets
    draconic_instincts             = {  94931,  445958, 1 }, -- Your wounds have a small chance to cauterize, healing you for $s1% of damage taken. Occurs more often from attacks that deal high damage
    engulf                         = {  94950,  443328, 1 }, -- Engulf your target in dragonflame, damaging them for $s1 Fire or healing them for $s2. For each of your periodic effects on the target, effectiveness is increased by $s3%. Requires Fire Breath to be active on the target
    enkindle                       = {  94956,  444016, 1 }, -- Essence abilities are enhanced with Flame, dealing $s1% of healing or damage done as Fire over $s2 sec
    expanded_lungs                 = {  94956,  444845, 1 }, -- Fire Breath's damage over time is increased by $s1%. Dream Breath's heal over time is increased by $s2%
    flame_siphon                   = {  99857,  444140, 1 }, -- Engulf reduces the cooldown of Fire Breath by $s1 sec
    fulminous_roar                 = {  94923, 1218447, 1 }, -- Fire Breath deals its damage $s1% more often
    lifecinders                    = {  94931,  444322, 1 }, -- Renewing Blaze also applies to your target or $s1 nearby injured ally at $s2% value
    red_hot                        = {  94945,  444081, 1 }, -- Engulf gains $s1 additional charge and deals $s2% increased damage and healing
    shape_of_flame                 = {  94937,  445074, 1 }, -- Tail Swipe and Wing Buffet scorch enemies and blind them with ash, causing their next attack within $s1 sec to miss
    titanic_precision              = {  94920,  445625, 1 }, -- Living Flame and Azure Strike have $s1 extra chance to trigger Essence Burst when they critically strike
    trailblazer                    = {  94937,  444849, 1 }, -- Hover and Deep Breath travel $s1% faster, and Hover travels $s2% further

    -- Scalecommander
    bombardments                   = {  94936,  434300, 1 }, -- Mass Disintegrate marks your primary target for destruction for the next $s2 sec. You and your allies have a chance to trigger a Bombardment when attacking marked targets, dealing $s$s3 Volcanic damage split amongst all nearby enemies
    diverted_power                 = {  94928,  441219, 1 }, -- Bombardments have a chance to generate Essence Burst
    extended_battle                = {  94928,  441212, 1 }, -- Essence abilities extend Bombardments by $s1 sec
    hardened_scales                = {  94933,  441180, 1 }, -- Obsidian Scales reduces damage taken by an additional $s1%
    maneuverability                = {  94941,  433871, 1 }, -- Deep Breath can now be steered in your desired direction. In addition, Deep Breath burns targets for $s$s2 Volcanic damage over $s3 sec
    mass_disintegrate              = {  94939,  436335, 1 }, -- Empower spells cause your next Disintegrate to strike up to $s1 targets. When striking fewer than $s2 targets, Disintegrate damage is increased by $s3% for each missing target
    melt_armor                     = {  94921,  441176, 1 }, -- Deep Breath causes enemies to take $s1% increased damage from Bombardments and Essence abilities for $s2 sec
    menacing_presence              = {  94933,  441181, 1 }, -- Knocking enemies up or backwards reduces their damage done to you by $s1% for $s2 sec
    might_of_the_black_dragonflight = {  94952,  441705, 1 }, -- Black spells deal $s1% increased damage
    nimble_flyer                   = {  94943,  441253, 1 }, -- While Hovering, damage taken from area of effect attacks is reduced by $s1%
    onslaught                      = {  94944,  441245, 1 }, -- Entering combat grants a charge of Burnout, causing your next Living Flame to cast instantly
    slipstream                     = {  94943,  441257, 1 }, -- Deep Breath resets the cooldown of Hover
    unrelenting_siege              = {  94934,  441246, 1 }, -- For each second you are in combat, Azure Strike, Living Flame, and Disintegrate deal $s1% increased damage, up to $s2%
    wingleader                     = {  94953,  441206, 1 }, -- Bombardments reduce the cooldown of Deep Breath by $s1 sec for each target struck, up to $s2 sec
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    chrono_loop                    = 5456, -- (383005) Trap the enemy in a time loop for $s1 sec. Afterwards, they are returned to their previous location and health. Cannot reduce an enemy's health below $s2%
    divide_and_conquer             = 5556, -- (384689) Deep Breath forms curtains of fire, preventing line of sight to enemies outside its walls and burning enemies who walk through them for $s$s2 Fire damage. Lasts $s3 sec
    dreamwalkers_embrace           = 5617, -- (415651) Verdant Embrace tethers you to an ally, increasing movement speed by $s1% and slowing and siphoning $s2 life from enemies who come in contact with the tether. The tether lasts up to $s3 sec or until you move more than $s4 yards away from your ally
    nullifying_shroud              = 5467, -- (1241352) Verdant Embrace wreathes you in arcane energy, preventing the next full loss of control effect against you. Lasts $s1 sec
    obsidian_mettle                = 5460, -- (378444) While Obsidian Scales is active you gain immunity to interrupt, silence, and pushback effects
    scouring_flame                 = 5462, -- (378438) Fire Breath burns away $s1 beneficial Magic effect per empower level from all targets
    swoop_up                       = 5466, -- (370388) Grab an enemy and fly with them to the target location
    time_stop                      = 5464, -- (378441) Freeze an ally's timestream for $s1 sec. While frozen in time they are invulnerable, cannot act, and auras do not progress. You may reactivate Time Stop to end this effect early
    unburdened_flight              = 5469, -- (378437) Hover makes you immune to movement speed reduction effects
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
    return eb_col_casts
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
            return base
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
    unrelenting_siege = {
        id = 441248,
        duration = 3600,
        max_stack = 15,
        meta = {
            stack = function( t )
                return max( t.count, min( 15, time ) )
            end
        }
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

    end

    if ability.empowered then
        if talent.animosity.enabled and animosity_extension < 4 then
            animosity_extension = animosity_extension + 1
            buff.dragonrage.expires = buff.dragonrage.expires + 5
        end

        if talent.enkindle.enabled then applyDebuff( "target", "enkindle" ) end

        if talent.iridescence.enabled and color then
            local iridescenceBuffType = "iridescence_" .. color -- Constructs "iridescence_red", "iridescence_blue", etc.
            applyBuff( iridescenceBuffType, nil, 2 ) -- Apply the dynamically determined buff with 2 stacks.
        end

        if talent.mass_disintegrate.enabled then
            addStack( "mass_disintegrate_stacks" )
        end

        if talent.power_swell.enabled then applyBuff( "power_swell" ) end -- TODO: Modify Essence regen rate.

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
end )

spec:RegisterGear({
    -- The War Within
    tww3 = {
        items = { 237658, 237656, 237655, 237654, 237653 },
        auras = {
            -- Flameshaper
            inner_flame = {
                id = 1236776,
                duration = 12,
                max_stack = 2
            },
            -- Scalecommander
            draconic_inspiration = {
                id = 1237241,
                duration = 30,
                max_stack = 1
            },
        }
    },
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
} )

-- Pets
spec:RegisterPets({
    dracthyr_commando = {
        id = 219827,
        spell = "deep_breath",
        duration = 30,
    },
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

-- Perhaps a bit overkill for current Devastation, but scalable and easy to modify
local GenerateEssenceBurst = setfenv( function ( baseChance, targets )

    local burstChance = baseChance or 0
    if not targets then targets = 1 end

    burstChance = burstChance * ( 1 + ( buff.inner_flame.stack * 0.5 ) ) -- TWW3 Flameshaper set

    if buff.dragonrage.up then
        burstChance = burstChance + 1
    end

    if burstChance >= 1 then
        addStack( "essence_burst" )
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

    empowered_cast_time = setfenv( function( n )
        if buff.tip_the_scales.up then return 0 end
        local power_level = n or args.empower_to or class.abilities[ this_action ].empowerment_default or max_empower

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
        if k == "dot_duration" then return spec.auras.fire_breath.duration
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
            if talent.azure_essence_burst.enabled then GenerateEssenceBurst( 0.15, 1 ) end
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
                setCooldown( "global_cooldown", 4 * haste ) -- TODO: Check.
                applyBuff( "recall", 9 )
                buff.recall.applied = query_time + 6
            end

            if talent.terror_of_the_skies.enabled then applyDebuff( "target", "terror_of_the_skies" ) end

            if set_bonus.tww3_scalecommander >= 4 then applyBuff( "draconic_inspiration" ) end
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
        spell_targets = function() if buff.mass_disintegrate_stacks.up then return min( active_enemies, ( buff.draconic_inspiration.up and 5 or 3 ) ) end
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
        recharge = function() return talent.red_hot.enabled and 27 or nil end,
        gcd = "spell",

        spend = 0.050,
        spendType = 'mana',

        talent = "engulf",
        debuff = "fire_breath",
        startsCombat = true,

        velocity = 80,

        handler = function()
            -- Assume damage occurs.
            if talent.burning_adrenaline.enabled then addStack( "burning_adrenaline" ) end
            if talent.flame_siphon.enabled then reduceCooldown( "fire_breath", 6 ) end
            if talent.consume_flame.enabled and debuff.fire_breath.up then debuff.fire_breath.expires = max( query_time, debuff.fire_breath.expires - 2 ) end
            if set_bonus.tww3 >= 2 then addStack( "inner_flame" ) end
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
            local n = min( max_empower, active_enemies / ( talent.eternitys_span.enabled and 2 or 1 ) )
            if n % 1 > 0 then n = n + 0.5 end
            if Hekili.ActiveDebug then Hekili:Debug( "Eternity Surge empowerment level, cast time: %.2f, %.2f", n, empowered_cast_time( n ) ) end
            return n
        end,
        cooldown = function() return 30 - ( 3 * talent.event_horizon.rank ) end,
        gcd = "spell",
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
        cooldown_estimate = function()
            if not talent.flame_siphon.enabled then return end
            if not talent.red_hot.enabled and cooldown.engulf.remains < action.fire_breath.cooldown then return action.fire_breath.cooldown - cooldown.engulf.remains end
            if cooldown.engulf.time_to_max_charges < action.fire_breath.cooldown then return action.fire_breath.cooldown - 12 end
            return action.fire_breath.cooldown - 6
        end,
        gcd = "spell",
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
            -- applyDebuff( "target", "fire_breath_damage" ) -- This was causing Fire Breath durations to be wonky.

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
            if buff.snapfire.up then
                removeBuff( "snapfire" )
                setCooldown( "firestorm", max( 0, action.firestorm.cooldown - action.firestorm.time_since ) ) -- Attempt to avoid (false) CD reset from Snapfire
            end
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

            if talent.ruby_embers.enabled then applyDebuff( "target", "living_flame" ) end

            if talent.essence_burst.enabled then GenerateEssenceBurst( 0.2, max( 2, ( group or health.percent < 100 and 2 or 1 ), action.living_flame.spell_targets ) ) end

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
            if talent.arcane_vigor.enabled then GenerateEssenceBurst( 1, 1 ) end
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
            if talent.menacing_presence.enabled then applyDebuff( "target", "menacing_presence" ) end
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
            if talent.menacing_presence.enabled then applyDebuff( "target", "menacing_presence" ) end
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
    name = strformat( "%s: 蓄力", Hekili:GetSpellLinkWithTexture( spec.abilities.fire_breath.id ) ),
    type = "range",
    desc = strformat( "如果设置为 |cffffd1000|r，%s 将根据优先级列表被推荐不同的蓄力等级。\n\n"
        .. "要强制使用特定等级的 %s，请将其设置为 1、2、3 或 4。\n\n"
        .. "如果所选蓄力等级超过了你的最大值，则将使用最大值。", Hekili:GetSpellLinkWithTexture( spec.abilities.fire_breath.id ),
        spec.abilities.fire_breath.name ),
    min = 0,
    max = 4,
    step = 1,
    width = "full"
} )

spec:RegisterSetting( "use_early_chain", false, {
    name = strformat( "%s: 持续引导", Hekili:GetSpellLinkWithTexture( spec.abilities.disintegrate.id ) ),
    type = "toggle",
    desc = strformat( "如果勾选，%s 可能会在正在引导|W%s|w 时被推荐，实现持续引导。",
        Hekili:GetSpellLinkWithTexture( spec.abilities.disintegrate.id ), spec.abilities.disintegrate.name ),
    width = "full"
} )

spec:RegisterSetting( "use_clipping", false, {
    name = strformat( "%s: 中断引导", Hekili:GetSpellLinkWithTexture( spec.abilities.disintegrate.id ) ),
    type = "toggle",
    desc = strformat( "如果勾选，在 %s 期间可能会打断引导推荐其他技能。", Hekili:GetSpellLinkWithTexture( spec.abilities.disintegrate.id ) ),
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

spec:RegisterPack( "湮灭Simc", 20250806, [[Hekili:K3xBZTnosc)Bj1wJIvCSSeLDMSZtSNkoo52m38sQOS7uxT1zzkrizUHIKljLD8uP0V9NUBaqcacqsjlpZS19Heljcc0Or)oA04Qrx9PRMe4xWU6N9g6D6Wxo8fdg5n6LJp9Qjf3NYUAsQ)8p7Ve(qS)k4)VKDRFEHFrysm(S7Js8dW(ipzD2C453uuKM)DhF8YWIBwpBW8KvhNhUADe9gZZ8xuGFF(XZIsMDCXnS78ZUdAAy8XVEo2KpKfMKfwC)pgMxKFCaBH)6OIJz3M8zw20GQbFa2lxnz26WOI3hF1mBZIxm8LaGLYMF1pp6Kx8TaWfgeW4nMLdV9rhT56pDdBZ1)QFg8FeCS56jm)8e4VJ38dyVD0WxE0Wx8DBU(9XHfH(rBU(1F4h38dB(HMFBp5BFYrJgdV9p5)zOPVnE56OfBUErwiloi6(nxtVZNKnE8rJhcnEs4Q3S56)EkoNQEK3PoF0OQ3An)rxFqrwy8Nzf9RA1WX8wnVSvIh5DK3lHh9PF9xvNaQn6KJg(xpYBKXOKx9SriW96OOK72C9Lz(ltIH)JXNFV(xERSHF7rEF7Z3Cn8cdpr8xCK)7IUdqmjReJr1BGGTjM(Qjrijcs7XW))NjszwS)SiwWvxC1e)5CIuwbldw5UFA(6mKoMTkn5oGyQi5QjJUAY87NhXMw4dpd6TFg)fG(JLf6Z7IBztzXSvHiW9QZ2C9OnxF4MRl8JyXfdK9D(08u)4bIrFZ1F9Ra(FZ136dDd8ldM7hpL9LcyjFAamd6v2b(XHRsYHEq)DfpDLFE(0GW8W4c2Ymabv1Q(uVycGNtd7yvqCrsCX0Kftx5VmCE17dn4Knx)SwNj95a0S1lwmiOCzDqgBLFymIsamYGV9uQRawTOOP3aSOmc6C(sNZXJwEf3OLEUqNCM5SWu(Y9BfteGicxVbAS15qFN5h)5nxdDAbG1stJcNJ9emGj4Gsl(dUQaKFSdurEBpvKhTc41LvG2q)Ed2fSVL1mC6pEhM(J3(PpNcDCxN(pPnQ5EDHLPzejcvd82buPf8pIjpzhWKN0mMSBtrB47t6kdpa5fxnzzgdutArMQgN2)f2kGndN35eBwGGFklC5sgiN71XZb1Cah37IiJhkXbRyz(rbtbJaYZtwvY3jF(TSSaFyHMTAwMpAvrfiqWNWSGMK6NMW)RgeFjlYhemapRuV71HG247twd4TmyX2FwY6c(SyYKnxFexKbQNoJfbwFGtMfjWuljfqWWFV7gg(EupCh94l)4rN)Ulo68jto68SePPsvRIhOspRqu1iD66uPiF(Rppjjki5oWmOB8lWooE5uWYOmQHyheWOUW4Xtf)SSv10FWfnje6N5hY5TMblt0hweU8MIPQsFadfTi1mjfm8IvOSIkeDJFkAn8NYjGvMXVNMNhOmp1zBQAkSc9scGp)71FHfHzSPZYy(f3yP19nOm(hc4dwyam2MRziyYTibwHbsLyqFdGvvnSbE2mGW4UKSpd4xGKGOCqZuw5)fWMxWoMzSI7iMe6NvF75aM1poGOCaYiHuGCqDv4Y4KmQdFZLFeEYIfS5ieLxeUcHObe2Ck3CCeSMw1V2eH34AHSFsb02uGWEAyGfjoHRwfgdFaiFYlYwt9tPeJsUXjdTS6YyP1wfaYMVLiNy55S45mOvlcNhwuAyqpIgNOufnz6S1z5feDlNhaPnNYULmwiiiFaYoJVnFsQnUsGHK(nCWj6MyXIkM6NTkjZU2Ky2AqAK)SWOAgPzJ5zmsAzr6FNwemmRP2YqnRImiI)NVnaEJaoz5K7Zcx8)sK8LVhV3ZdrZ7ZyfRZWvdI0mE9QzO4SeqAyzJGhMYYaQIvyNsI9alVZvjKLMxfssubvF(b8oH6vW7V0i2x4EmbFlgGpSFlPtSjMJV(AfMFfPdJqWNUni42L4GRDlNhal4FHitkn1miBAAgqlbmFm1LKs6toJlWVkb(gnH1PyFt6aaRov03409fnPi(JRtf6Swrozs4EKbjcwoWv1BalEVVc18VxdASVAcoejlwmfM3OEuyu(wvLWRb47wwKUY3F(LQaYmfv6FjDD8snuKqxdyPcAHa(gtttcbFlbmf2v)vJUQBVPM6n1wmhKqWAQbWNbxBXMyY383yFg4VbMLFobPvFpq(DRFyexHar3ha6FGzkkvg(rwqE1mFU)AeS)nuh7cYohyUnAOZj3QKBP(rAx5njGaMbiLPtW6JmGtAfixqAHvui6ndzRvYYLazkAlywgqhGkSa)Jb()BqpXNWs9rterlykP0KqonYe06YkQ5(GjT8VmfD3M70TGmveFHCQhmTaWT9)GpQGdtGEKW5fKbUYblBDSZXYpHJwnvU1GBgGW4TEyYl4gycS8agFMVvtmBxuJaZmOy0aWFaIxgxQfkE(J9HH5dwfMLbQ6b3OwaMxdQbybG7hGkWSK7YT9c5GnjmYVlq0cipmmj7EvbwIwpDenK57MfHLdPxttG)yE4wI082gKMxfsBRmDJqAS)96W0uwWGzO9HX5rjf5QdYDm)uGqVCeCyxs4IMTmr0n53hpxLNZ1OdG2uwuo8IdhCAjSoA30BBBqiD0No6eEaugDQHKZF6EWoL5GHiXmu5xwW8es0jgWwqM5LW)crltwroNcEGYWikUK7uyofFuu26)AngTiWrCHkvcGgydVaE5nLdUw0vRGJRqDLgyyW7iT)rHbSYWL1zK3KBU(BuC0rXwIQgaMZmKtu2C7(M2gPQosxKWnjCZhMohqV51DO6s28Wag69u48BkFzoEn1pmtQM6svtjbXUlq7vGLvWHJ1y0xiFKgv99sLowf)WjqDqk5IK8B3nEIk(xt2IARTEowB9(DBT16izzT1ZXABJiWxU18060sZyrGyu4)YjrL5RJr7oqcH60DX3VAndKuZnoLIRrAyCaAOMf9wP3VcJhxw(07yZmduS0HAGiRIUsWLZ9Hc9FbaDuYGWFgPNKLU4iEpG4ni82WaP3xC)9lX0LnNRDb9wknlbBF(Gnx)385WaAehmVrV9xLeeUierbha21MbYPql4gn40V0NZdTem2HEPBcxEd2UuXgNXFSsxjNzde7HI1rjhwZJqyhNL34dwYJXNixR1vJqy88m0uA45CJJfFfgIxJgGcVb)T9vhdYqAmCB(kYdUleBBsM8tXyS5qgkPacjoxpUhvS8Gl6R9JQ5pX2rg6TfKHEBdzONnYqBYqQMg6Uo0P5Xq7OMeWZoGhMmQTUn(7y36z0Tpad9iE0S1ZUF6D3WIsNMFdr4uNpguIaUXHmItbsp)SyGTDA4CrVxBEZ(Y8O1b2DyylapVoaEEBn45PbE7O9yYotYsAezIgnUWT2jCM1MUlD1x4JMwjMRpzo2bw7fopnVfk9GUz39LBHPUfqDEygzFymDjYqH2OY1EpArXHnQpMlk2EU91LAMCQhVkfl1vWLp6RAvrS)XCzR2kxTEQc3lwrhtROomjVlsbC6aS6o4QjoWUJFw8AYEVAJfTs17zuynAGOdNU7OfTb(RaliN(Orh3thtfDBepWRQ4A4hBM5C7n2C0GH12GwJaOsjhWOYTHr0wW4dF0dqESFRWtzJi1F8ycJWKnlpYyTgVF9ylxUnkVW5EtrwqX3pk0ipCh9aW7gWajYgv5MijA46uW(v6b4(ir5HtYBhqEb)oklBwHglsovdT5KCgWbMZyRYX4lwgh587yGXJPjOjUZWD4kS4POvYmKwf6EYaWqK9mhaPfyc6adWFtcteKSkjJVZAam8cCqWTciNBh8m2skc84eAgg1nUzT4odZtidBMdTLi3Py4dRqWNq9Rn7H6q)wl3tk38lSt3kRHCfV)QoDKbVxZznuh3wzTTSOIlHGFBMl1bKI)85S0c8xNYOmCBkU(PmriXWEUYjIA73VEEgG(jmHimauvwe(1xh4Nwi0R8byzEnUHg12WSCEZN6x2AL8C4N9m1Zx)9JctZlaFBwPTjoewSkS90VzDhpr0RCowgSDptLr1gwCRRZlsY0hvT8gGJLDT8tgTYWD0lxjtUQGLYbGGhtTf2O4SaskBIQj00RjiPcmIcVvDttk4H5VHK6WiBgAoBzoWE8rm2LUmG5Jn92WLQBaS6uZAAYyn57ej2uFPIqRihdABmZif7znk1nhLY(lPOaEU3V40eLlUGKGIYXjb)(cN)xgLmdZivkkzc1b8x0htLsg0Q3EXMR3C9f(Rx9gYVEWMLVddbA8tX8ziH7N(7456YpZwxKX9c19(5OSZ7RaA6vuccW3C2xOT19Coeb(g3CvTDBDiM2uCYAQ11YQjCjE(NZnwW2TKFQVjFOLn)0vQVvXSOV0nbwMWTfx(ykKoZHX81tE9hury00lp2pfBQC6OWAXWDsamaK4dYvLq5sEPImgdGsDDMswxcgV8cDAimim4so9Vp9oAT)WXd)m3kHt)KfzsoZecLLg7PsXtCKuovicxj5JCVCBgrPccUfe1ykSyzFjAB1)1ZbR4ZKgjX9prf5)xWCw()gwN4w5WtRzARi8fgCPq4C3nHrYUct7m(MxZtXOS1XXOQ6nx)(nx)5yCtDfXIuKnf8MT0pBgLyrcB045LuoFP1RXL2MWRTQ0PATJ)WkECIXZwtMFdkVoxn(ZQofAKstCEy(YXuTu5z0aVUy3tFrgJS9(agKuOsXoL7FK2u8GYmosm5kOacswDQ4GOEBcJbunMjDk50N7P)5pWPVQDAcJZkPDST9hg54P)mGYldteWpsb3wkgrbcrnouYVTmlKTG7kImPDQqV1ZLGAuI2G)EnQg)Gkg8mmA6ZP8jZMI885jzZXD5RUHrTOWwj)awmZ2(DiNHfHP8ihdtvwUbM8tHae)wG5gtVq)uqxrAiDon4wVGZY14Urw5IxAK)9eYKYEwW2NukdTGri7UqmPROU8DxC1En5sBobkrEXwZjtbhDRTtRZSoCvYVDK43nV2j48nDp))anNSl2sw3gpxg3vBlgknSOCIPZDIiKbKN0fjG1xcPsJ9SB0Liri7jPTR)MJoL)MDkdJhAzHX2gAOHmEdf5M3rQOVGOQaeYemVTbGj83iNbbC0VeJ7RgpmpOvrInBtahYnLkIE(lZpKZEcYyqEvg9rkogOX7mCgWJXX4H5nj3tjPK2dCUU2iyv1uLAxmJkIPgKMppsKbctZdtVjj2Kh8a3R2VuRtA6qnzryBdzw2FArzQzQpn()lWtM0KIYb)jyqWkMoljED(GI7UZB6jPZ3cSuB0wtXq9(Nx0J2Yml36g1PffcBqzpB5pofDCBUjzBZ22v9a8OOPLy6KVQK4klpCL)xMkAWJQQc8LTrw1ZGkScy90Pv3f78Fv725FozNVzgcXDnfD3HBUtifpcwofyc0j9f0zj9Tx8Cflmj0folX3f995nxAgEd6mUsbib7Bk(ZYtDRPVq22SpjrbFs0mTqjtqn7QDNjVhLXUnKoQu6kNK(8XrSKDFya15hhf64frwjodw6oQi5Oz0siFIbOyMFEilBG1n7Yise8Lf8Wx5xr4skL9QzdOdMF1mL)Ko6eIeVMEFgZ6MuvY1Qi0Rz0)EkUrLK)LlNkNggfPKohjndABUPc0nFFqR2A0dX4HnAJTtM0FhT0)N8rJlUuPd5MR8Mlq)8JlKSmZ9tTUjzTh4iAyUKIxHKIKoe4FcpHhXCJBWdAJ0Ki(g1i9gmS4P4pIzpe8YbGjv(l9rMmzk)WxfqS97VCGfp)Ak8mst8TizLFqcQT)BA0A6ZZpCpcVN8PdjPbJX)Ydy6)ibRrbr0MSEeNzGVMXZEletd)8hakd(xiblx(rdvd2mf(e6nL6nSotfEGPi9)2sWzl9MTs9G9Wxufqbv4Kozu4rcUUFG7lza6TqxkKHLto5f1TQQrw)s2wRkQ5NZXwBZivZm4yUdivTh1XvtZx90o8QptQxUV19)usCRT7jTzYsfIhMIXGQulwbkFsntaDgjavAGtv6jl77M2sIp)CbZHDLWpqpmI5NwoXYvc0JlraonfC0Umpgxbj7MjEMcW5EI(JVtkOrm)aji0ee3NEug53jY9XYO(iwoEE5N4b6fBn)K4XKNkvCEnti0gBsEcGWTUh3axhw5mgzaI)pjycyei60an1mrjlXuPxuxo(KnkTYdFe52bVwTma3GL5rHP4CTxD737vecCQNFMxVdSVHsN791VsVMCBKa8kdiRUFknjmhkLhHd4U07AmmU2LRZ1fCuThxDsYLnd3pPlMyqJGdBKSL3bBVqcPIf5(uPQqXq8qle4LKR4wvUim)gHYszxl2OSQ8nWYETunvAkVb0ND1tAa96pGiAyH8C6L3h5daxwp8SJnDK(5OVPNr1bHNhU4SsFzvKB17jwLLj(znI9UINnDbdNCGcYFR6uIAlTfKyd)FBDgsWKf(ztSX7GPh3JHf003Ae1kuosFnTj8gzZCDxJTeoHMnnONwG8BZuWM1EQpAT2zvn122xQgqg77UP4CMQ8uHWGsdPQhrZrJhQQ2nkjjiATqvMIIqfeDglnjt3znH(wldaABJ5ber4sUUprw2Tul91jdPN0S9GI21xwMWmisSKqbsYPyg4fueMaO(POC8yWn(5SSA(5T1evThflaOpvcWUaJgsmabZciffptAQFVzqVNmvzBmtjFs332CB1aeCvUkxllBA5KVVcfO((wPBXvJdcNyT5SvDujD6dCgjGyhB2GwyS0tu5QDnLyNBcRGnOtthllDI063MLavzkl)yEyaj1YuACozWjA8cve2LVeYR(IHs0qd7NCL4HwcAJPH3wybBfz1oYWCFsvovvslkiZsPd6eAPHSsOeSHFwTEUmMey4h4vHiG8Ik0xyucXtBi(BMN3q88qju3THx8F4VlIlpr35)3YRxr4lGsfucjsP16bjRNH5WbIO2OCQWkOyBshevY6DAi8xqBE0Kjh)UleqPI588WAcG3VuDkjRsG3MYliXW6T7sGg94ibA0FKsG8(duc0OMKazdR0otLNJgnQlsG8SlbQ2zcPnjqwppP)jucKxxqggkW9AkFWqKXuW2GaR7dG6XTVRk6pOd6KAhVJi0(L4u3dyBkVAhLQsQ3O8Jd6aPE7Q0AzInQXj2ODDI9aLu8WfSrih7MP3)3n5z1xN)JKxECxA0O2v80EN41b7NLcnQeiyjhdB3vbJ8qwFBVBt9CdgyASU54ODPAs72ieQ2HAUlIPoJVnWsytpJWfBagFELMXUfXidgPECk2V0JDsszZtzoS0SV6VQmY4gQtjN4XabCytthAxa0nq(9lqteX0wISQeXSujytaRvvwa6qaGqNSiTr2ys5pi)1kxJ4MAI7txmlK)827TzjYnjSSFSLoP1Tn1qz7wYc416PnChyb86OLzknOnwGgQMk)zNfyKvwaRt5FVybAkRBlLL()DKDAh(llmd)(qM8NrjLgQxBi5FRK)8)DK3yh()DMS5pHsxQ7)xbL(PnSlikMBFvTIbFTn7PPS14GMsUUZQLLqIjR5Rufme3b3hlH1ybWmiPyQUtwAOoZ9osjn10RM(8tXqM4ymuwi9rGBDCXXCaP5YQVgA8pR4Td6mQZKVW1Pw4kJcOFd7YW)rGHAA6ELrjUVH4x6yUEqLyaB7JZ(8kOqBIUn3cfCCNPR0NPed8oscDLXfusdXIANrx7TRmIhmcRvYyBy1ZvdS3oHw9AYzDhO1w5QrqTnC)z7XBzIhFK)dadp2MVGg31f2r4wtmHCRvI3AIdB6ukRLz8JXmJ3rEXQNotk(OD2qzEf9YE60KNnQjLCMx5hvGDDyIa1kl5Ym33gtPZlwdKdzmE6uko2PVYiJ2SisXuBJEc9CPCtOuWqLqInb4DFgztpe7lS5RlKq)ZKXFJ4hCLdEEwzzmrsoZ4V6dPJSkYI43Qj7(SuiOYqAVSJy79Qh9e5SquNd0nLlYpf3sX4L52ea26Mg2oETADUW2z(0n424zN9IQ6c0cYja5vqaiTLFBSGrctqK3VPOqv7O(OnoxMexLi9LjgoDcDSLNt7w(HQBHO9JbuPFyghNhp5Pe7jDq6TE7SDOECCa3rHCHIsuVJMySPFLk)8Lzyf30XCCWMsSeFFZKpGUPu2CAt953ur9RYZPgd)tZkpQD9kPUi2kgSrBEDpvTAAD)6QJvQ5t1Sx3C)AAXW9dPfHJue8BqLy0DAKbDsNYzow)KWs9fqdMl5HWcpptF8KYRPac5pOPi10nxTBeZADpNmGVpcQuwSoo(EOTIGTUmjjatXpQiwjYI1jVHFkRCLw(oSE0f4zr3SZBJb5rsZXzl7N4vA3aUV401ieSW9X1y9i(TeLTO87MMgXtALqroLVmH(k(A3XTSK2QaJdOgijWGbQdfidT6HrPyn8fvvZ26B2G0kvhBe8KQD9GYs1h)wr0O(CuQ7TIxXE1Zsf0zXFMk2VndVQYEfTVE3v1iNfWcIYv5PaRzGIx5h0DTbBJWCNNiF0fg1Gk28nnwJyihgVkwfRTL1vIy7M3leZu3YmEDZnKjWoMt78dq6fCwh6c56lPeFbEkl6Gntn5hUDdjuSv4OMS0Opz4APaF5yPKN(fwox1Y5Fdzl(RN8FmtBAk2u4KSw5UIX7djEHXywii4lD9Q0AZjTk2LZWqqaGZZqCrZxAOzwpHw82KJvrDlccuFQdJc0f(S1xISNj9UsrawHZZIUBfBA48F9M7XJQkvK5PtZCaD4MrTpOAh8wWlNb2ES56prdjgPdSuAKXRdhRyj3z)0n3fCT7td3V346oITORUwyLHQn(adOCYjsw0CEf2xyFZbuj)Io8yiZ63Xnt474I)AS6o93lZka8K)I91f2IMOubvJNLcfrYTDskCfKM(sQoBHQPlrLrRvRwXccPZqoU8J5TBuJVQTybv0WzPUbfi)y5r8JkxmYZakjglxA57N(1FDmxgevfYmK(y)uq6wQiFN(KnjmogiCRoEL9Qe6Q(ivLZ6rerqw3KWD1JlkFLZYYwrdNo72oO)MN2pAPsyiYRoBe)qf2WjMZGkEhprFTnkQEj2CrgqDZq1UVn1ODQDu)rsO0KBPam6YPdlh09j4LYbEi8y49VZbbuOnaQQp3322iz70O5iS7vtxLZOoFdbRAHMqwUPga)hlZ15z3zniKFgOD5ruBKq6cnSWACLYrIDFqT0T1yhRUMMQ2(bAS8Yl(gQGN8w5PgeeKJhBqH6cq1G86TcMGYc(nQ6fVyiz4bMTcL2HY0N(rE0GeNql1pG3kpSH7K4EkM17Q0n72HETNOkEQNrCCcRDUkvlir8B)6clvd7Ui6)D1eLBEU6LsITiIVKUY1jKVbYsvb4e07YS4gT8xf6DlaqXHtdjh0iBApCnmKRqTxR2yRVVez37ywiU2gbErQMtcck9oD4jJoDaWwFNFwmfXB(rlkCfM9icvZpT8IE8P4(CrL0v0(kE0MxxKioNr8ReP8bB(HFmed1mwADFtsmmE0JFQmnw4h3dHCgXfN0t5w4(uLuDXAJoy0x6Vpha59MXo018mT5(MG8QMSF78hauJR(c9rnb56nB)pipGzaTTUnb7YgSp74ha8IIkAcCfpFp2TBpW22v3PLbQdVs3hCBxYl2hthTuBO8CmuEDrUGJgTVhaxRrDORDjBWAt2VD(daQBsMGZMT)hKhWmWU8blnyF2Xpa41QeI6pFp2TBpW2bPiMduhELUp4DsWttTuBOEHtzC1s7yls3S1Mh1U)rRJ)JhURDbTAxBsT20eCNKY4aqo)CM)uxzTDVdAc8)MVXwMljF6zd)6xB65FZ30uFJVDtZW(s0Woc6pii)Hb4LRkFRt(52PMS3gTf99D3)O1X)Xd3TZKzVnnb3TZK5vJs1c4V3yYS03A0QwMHUzY6gO)GG8hgGxUQ8YMKS66oa2Um2gATgHqJdPZRsy7JztnV7dQ(jTX(ivRnAD)FTjENoJgBR1DFi7oAS1M39bTf0O92O77OlB4SE5iBFHYsR2IXW5TxS9bRPMRpQJBcZ16mZvR2IXO7ZSwBU(OEIZrfRSHd8JVFAqAEtkLC1U994GcLN(G7FEcWXVUHBDYy04hLrSXqb5Amg1rSM72TVhNDB1XS)Bex1sJFugXgxDoTJuapuENh(408Qtx7)9hVZEAe3PvNUtt)WwD6(4SBRoBjL8Ey1zlhXgxDAmOaDkEpDoqZohRhHylnQb)WIU1QPb8FUB9Yi79YiJEH2DWfjrrj3r7pUpqBHjRdRQ0aIETrPlfFti53yR4o2wiBhLfwlswhR16GaSXb(f(Z8ZzF3MFGsXrmAJWh)blBlPairpk3IDL0TXqL(ljY4hlOulnrd9UF78o0TiNG89Cigt5XpIW6JAN3A32DjIDsY7dFyAuWR7UV9q10HWTUV7(Yo2TLpTUOATjAq9(TZ7q32iRtTh)icRpQDERDB3n1RtSop8HPrwh3DF702DiiQ77UVSJDBwARlQTlSD)25Bt3UviJThQ3QUV1oE3yG6iuVBD(20TBLm7ThQ3QUFB64TaDS9q9w05T2T7g7shH5DRZl7w3oASlDRbmVF78o0T7LGc3bOERKF8i39DOJ3lOf3o416Iz7CK73oVdDB7OKoSlmDaQ3kPFpYDFh649cAX1EFTBS9pQDEh622rjDG5Pdq9wX0)i39DOJ3lOfxBV3UX2)O25DOBBhL0bMNoa1Bft)JC33Ho(bIw28dVNIoh2RVup4FyW3UAc4)3IWi2vt(l)LnxFtrrA(3D8XldlUz9maGxDCE4Q1re0opZFrb(95hplkz2Xf3WUZpdpqGHXh)AQJ)GOqH(Jy3FSiEXhZVQ7MgWUfGqQRgG9YMFahYjL9)BW(hrdRwHf3Hj3hphWkdpXF44xgWB8L(fSVdlINENE0WxE0WtXjiFoLpO88qC4zhlZXd(DHMavjZMQNtbW(SkCC90dUkJmQN9)wF2TvP4Q1NtjtQ1NGHsv9bHTKiLgT1wqQ3gCINvCITuMUAGRNyYwFMvCIzc2A9j64K2tUuJ2UR4e1RadbcbJGDAklyWm6SNHfB18TORYbI4NNKEwoRiCHOlhX)7uwuo7SHdo95Lx92ognGW)NUh4YMlkwu34NfmpjazPpAZ1FcegCzcff(i6qvXJ2E5XMd(kYSrcn(xRXy(t15uk6(eGmyBMpa)lF)FAa)8SthDI3ZgDkb5xYMhI3Hf3bWpEDiXxN4GdE9gv)Yn65ufeFbEKU92C9QW41yvDHonGJQ(UOJ60Irf))wUE0E(yArQ((kj3S01QPkMT0XCBqgEpyKrT8MZIXq7lKHLUwfzylT5iYV3kUWTYPkWwjrdNYFZ1y9fcWtPWuJQIqitHCG4LVGcL70RNJxWS4nkqa)nPNjbhLMJOfEfkkvCdemyZ1)nFomukpfOL5v9iSoimFDwgW7IxncJgC6x6ZzqwgIhnwFXfigECBlRe34Jv6k5mdlcf0EYzBuYVHxelWlBm(gWbFXpxR1vJqiOXhlEM58lT3aM4RWq8AAZfX64GysvnglKxB6(km7874SKm5NOTAej)KC)sCEENegvXnYRF51uOh6oX8myGCMlDMQz1lV3Bbq6zhiBm7bniS7aqAXDHTbivka)c4C4286EpSxV8QoY2cPzE0zSW4mZ32gaWZbaynr(mq67faqY1zko2tvC8ifHXpXPQjxIP)6xDlaxrcU19dQ)ZoWYlJmW9FMRxvnzr6F(bkAm78qmYyiAkFu2kDF1r3HlQ0VzXmWXQRd1GZYURlRp1Fs9fOAwB9SApcqmas9rFH7vF)J)k3dzPZMedBM)FO3Z0fvAPnirqP9S2AqDElj0C24UmhCCTAShy6Dsu1tzwhDB05Qyk47KnsFKkakJkRcTIk1nOv2hDxGQQoDy2LnAAz9kuAn5GHptTQFJJ2)q8sctfUJUKrrRzWcQbmC3awcqgJjGMCrdxNcJl9aLBu0bKlqVJUG)xHwfjRqiNKZMJv1h2QCmAhFMjmnl)ogyLuAcAlhL7tHfpfnhe8HL8TGS0jenFlpbRyVz0a83KWebjROItzXnyn(6f4GGRq5Cd(MXwgglkmyZQk9VGg(UzAtqgqwWs5irbBYzVaPqYyanY22ft9tQ6Mt2QUrRORx2hdv6dmImT3pOt9y)akgJMMgkOmkTMpmgJo0uE5klmEXASkymDyP0LZ7KLegLKSsNzKG9iK3(jMvB(V(v5pv57Xx)kfbcrhbl6yfmPdqG)85S0c87t5fQLP4AEjamwfVT5AQI4mHOoMWRwma5Cz5IzZ1FawaxdSG2hywwGFCbw0iZ8NZuUK)Rx5z4Rs)Zj3NfU4)LhVaQW1XRBLuSaYXe1BX6yYTgyCkqJ)Pcyf3lhSOITPSUYk4xPXdFbW1bK3TSSFl5R8dO(JN4FW6FMpALVqswUKJpjLZ2SG4GxMfYwug2IG1GdkyBTIeOQxK6uVec4fxlE1ncjX6v55yv5rZ5QAzHxuPVl)TEh8eTIXtfbKsHx1H6m16fJk1yzNd2vQ239Q3Zy0oPqQe5Fpw6Lk4iQjFsPAkr3g0(ZOAakIJNmHw1bcEY5s8cr4w)yz2AMKYIzCPW47r9WD0JV8JhD(7U4OZNm5OZZsKetIjgmDGrh(eoroWjtKwfoQpG8kxjQFLE(1V2CXyfBbo6vf1NZpZR)x)kwvH6Hf81EAf71xn(udTnG8AyAXqjd84bWPK53B1vqkV4snJQ4Jz8sjohxIApw5)LWvRxHI2lafjYKKv9TNhiIvfwwiRuIbSfuvnM6W3qfL0flihULxj4k6hQjCX4QFYugA9AvkA2w5JTxp7p6L9p)7RAKL6Ao0I(C5hVNesV563kKJdcO4gk8EHa7CofiGnU)Peb4T(HrC8oiiNM0kijvnhWCvOcOujbUEZN36AfqIT60v9EI15G2dSCdY6exRu6ZuebyRasQRuSYyuRYBKlmFBprnqencoCEyX5NnQ3t46C0koIWe4aLsMfipnhuwE(zC4wRVLd4Zgo4KsPivvYYE2lEL15NgZJz2)8TGuAzmUu0CuQ3KBxqoPPc0xSoJeOt3c8RrbvIc)PSrWdbhKbu6kStj5o8QNAGAmFxJf0tQQEhdMk6hOepnmcDrSVaQi)WpQPfX5IOUXlvlJLtb9vmluvhyz2(Qt638qQAcIdsIASQNFMOEax5JNMrGOQI6MK0ZCc1RMqyUT9Rtfkcw5xAemswfbOyCL6gQEcRmR(3Rb71F(6Q76IZgP(yrqOu)j2xsrv1pxu7Za2baMfITdcj7)j7IstcZbkxK5dPYkl(7)CcUY(EnPgl4HCSaersspGFKfOTGp3FnYs)Bvkv784xQRr9PZXQ4RRhcFMUhHQb7FevWVIXnEcrZrHOZu4NkswUewmlRJJLvp1j3KCh8)SuFWexgQvwwEavMEC7B0MsRsqlimnVrhNOxae1CDwd7LToUEdrNfWQs3CHbZgYh8ATdG)6(9F1yH9lV(xER(or))BZ1)skQnLJFqr0Ok2fKFwOUsYyrFrSWxgLmdvbXlNWCNg5ViEhRKXy8I)9MRVWF9Q3qH5MxUzUmj(Pf8Q3mg263XTm6NzRbJtvm1gWcW8ZqLXZ1kqN8P3b24QvynvUEuQSTRqTAuBCvm9kqcCpDlmnblozHg3jck2RTIV6fcnlYs9zpLci8542707a5U46QgX2Zv9H1u9XRo7eU6JjWsjkNxAxlTliZbe(RN86pyoF0m3MB)xvTlVexyuIvPHrD1fRIztOr9Yl0PCqRsWfA6FF6D0k(HJh(zULZN(jt4rrTQIAddnN9QRITdgHyyggkPX(0RNv)aSzbcNDAoDkR027jvKZFbp5j)3KtCvUAr7HSViyjklv3DtyKSRqxh4Yc5gfdS8y1OCay23MR)CmketOEwOqM3SL(zZitHfXxHBjDoh175g1B1Zldmtn)VQWUAxoxNFs9hXD5nh32WQawAyz9Rk1u)Srd8SfFa1OvYHBDZaeo)xItega08faY5hiSQtaQk32eh69m9Nfgdid0vhWHkxtJZBFAWddbqrdRMzHbOMSafwhfpAqzRKlqvUNxz)NbUWUcOfZuwsRGHEoKFEGKIV6EdPKvX8kZOU8syA9PqGw)Ta1l6Xh)MEvCrVQEjVk2qsYlWuWJAAMrfNyq2pvr5P7B(7crdtPU8DxyoF1V6V2oVHBY1Rk6qhEVb0WT0cLUWYaiLQODFqAIm7xtqlxn6FQ1F2O6tfpoSaq8VmGcCArcOTdyKg7zXpPE2A5OtBiAedju5BOaQRF3eD5emmmqpf(Buqwam8VeJgfYJ(oQatKCaI7Zg5MOhrp)L5hYjKb2eKQMrFmquNMaIYCzOQhpmVZSRQwX1rkA7zYHuaNvFBWOtxjCsjSSsIt6(vkpm9MK4(OyH6i9xw5VRPbk1euBF2cST8z70)iMR9)dbdJXIJ6))fyLxAsb15pX4c77K05BbY1WWPNyXLAZaFmMBUiz3gARbxuCizIolNSvhTBDreAPXBV45kQIiHc4wVGVl)((00IF0QNjKpdtkVtGexJBTyisxeDzjGnKjZVYYdkVDGEqs2(6xRV(0tBrKdaE97SvsVYTvsNpSFnpDpkJDBivmbmUD1e2iY7vsnkU5z8aUsHuMu6odGUJksoAgDPFWxlYXDAipeCoXCrGdo2W9Le6MMAz2f4nlrPBf85vaw78LRvGiBVEwvcj5PKrM5e3Mqr3dn1U4lyCb3V5c0434cjPmE1CAY3O8s2MT7S)zavqjMsjMMcblo7XsRhAUz0FE2bYDP7WHdg1xbHCj5UHKabzq9(egJVyUcjmyMs1y89ivA4zyXtXFeZqn4LdWBnOL(iBQmTY4txKi89xwJOXU3B28CYrixPzWhUhHKt(0HKKIX4FfxNQLxAi0tg5rXFyo6BtIy1(im04jr8VqcDaVqDqxEGPDfNCexUI1BRiWMXszfv3EjonmwkaXUJhNBeBMNnCW3EA)haZq1VPXO1VNvIqP6NgORL7dBDrSN51WZgj1YC(zhm(OwWMvn90gB6Z8e02C73WRwpobru5LLepUexJ32fHl(orgow6vH4A045LFI7Pm2AE0WzYnIcxQKB1k2e8kRRgzU2wjAt7KCTqmAc8v1L5HIyFRoFixQpv8MwUrtkxHmVUp6Zvkv7gcrUMxBxomnlyuxHUX92jTW8LY)NemOObYDWtt0DuYsmz75rkzs9ye1KiB6o5b(R(na1z8ZaZaAdcQEcgoxXT4LN2U9OeeVZLK7YG4bMmQC1aP2ZZJcttldrSHtv7WWausDTXU4ZRfJW20)a9LvwTsghmwWlcZVriEvgUqzug3swfP0trV0ZGrXzmQQYIdZ71iY14qmlERYoMM8)GUYE02Ikf(jHAktESEwmVUXzULzQUnIHYRviAI9oas5MPTGptm6B1lWgtSQii)VTqET)rxiGYn4JFzBHzJafzMOW5IDNprgDg18KIrBVKw4nEE1LJiYTvFf1KIB0HwnWwniGA7wyTDwRbNGmSs)8dglhmT4QC4jpZkm0VUxEsHCJa9XQPoxnw6YO4psRzMaFp7tYoJI96ck2dZUs7izxZpVbDD6zGi6mKpUlq(4dh7cYFITvYg2nexZ0ZgpWRJZvdKsNNQN0GKTUSVnUOpfSYQE7PZhZJTAMi4Qjgby9yENQYqVyMqiQ0kDnsnfPuMwZEGlxyptXfKtR7olQAstqxpmdOWTYfmmUSEg9QZ0VPO7e8o(3h49GoaWoOw73TjYj)(mrSbHDda5g1EWEwwz)UkS0KJ5Sr93FurEnp32z5KBXSZXsVT8TB)nVjUhRuTGMzNOJDxy6dhFShN81fyle1(FLrzv4eeUZLLUtsWAw4YLOjLgMBwoCKzKOwIvSm)i097K8CW)LAnWi7Hvpb95foJHI5oGx)(Y95L3tXNz)AkUNjxKXa3KDEqNwFeDT)HMIIQFv9)Qsxi5(ACzzqKnWfL9RXdmnUUjGZuUP6LD5Z8C7dRNn34A2Zy9UMR8oYpf9HkEzUXCypNkjv8nvzITzB47Ny1XIybDAfLjc4MRpGNuY4HCxS833aOn2W1Aq)wJYAzxu5jCnDbeldGRmyGy07hyaEMBDWoVvbkBAJYMf0V3bgBcGhUjnpXPeCZncWrAiGSOyCdC84kzDVaeoZNWL65ZPeKdOq((Mq0G81u28cwWHN0h3QuXPZwSHm4gf8XtkZpoAAyIAvfLAk900yMdCznJUfjUMjAM20xxpHskEQyBKzcgB1iPdFXrc5oklz6VyD7OSi8Y(g7lhjvmnpfq9agT1XX3xDiowMKeG7BdL(YIaPm5nnHXnTyXjoPXit0u3oQPU1yVO(j(XnxOBKsSEgMRRycl)w(rLGFg0ttJ4rGnueY1Lj0xXx7oYhlE8)m2qlGnWu5eF7OqARwsLhLC3byxXgRQSOHw7K7usmjixv7UbLN4UdvZzisCSTJMchGyXFMo(42HIkzg8wPSFIAzKdTqR8lavAWa(58WP8OUiGXs6tC24HiO34beX6CXc3Jalw7ibi5(DB)hx7LmoKyOj57Q8fCIn6qD8LuIscdBFlMmyrtLlRETPcPutXrU0V0)zcPn1dQjM1Gt2oWxlKF)Uc(8SeiMYtDkPJMfcCW))7URLDBAUGWplDtuSavSD6QQM)fGks)siXIuPUlqG4QerZf5K0URp7mZCUFoZzStjTGQyNJTzoEUF7RBpSIZWs2zjLjBg6fF7cAvFiCXG6v98nM1tansGBXZUgWo8tF)gsSaxowCAAAvJIZQMnpMyRqOAA(DNrD5DpsykarVExj1fItZSZcroU2vE3WXkq0alvPwWQjbwh4gCyRHRAwRvq(HEhHhsJ3j1Nlu85sLfYlJdyRJO6Fr(yiEiP(ttg9XMuJNeTzFX0GSZKithczw5gVAghK3uXGZyYCYRFoRw1mhlNg(1XVlp8Pu1zox0j(l2UusZjMsvJ6OYo3sjCZT3osPEfSFW5nDL2GVCAYa9O8vSEnWqT9WyyYfnMW9tJby05m14SOvWKpkD0tgmd8lW2npeZSL6OxuN8OpTAptxnUsrkcTZ64AJwxVT8J7bBd40ty1pBji3QbrGlica0kgW((vSUQzWemoanTkkXYPHkCZHW5ybHP2lAZBHCyasNnTbZ0x4eDRCQ(NXGmTCnqHHrI744e5)EY22p7c4UGM5SRnDvdmVqTvtzcfmxAWLnGwnGva6Sb3dRgA4Pcp5N8MgMD)AhyJ7jUz)Cb1RVMthmm3QW(jcXk1dlk(ZNWqEBmzN5GmSvFljMWEKJRjvw)Si1HUprQIk5J5Gj)x5x2nZ(zb3c6SA5(Mv61PkapNCftiGrWnnodKCxPngZpQlU3g)utj4PZTmmArk3vqweeaFyq9vJkndMY9q(O3Fy3ENjqVJEBdcGPNBgzpiZMOx046sU(peLSF0ZCrjB5dTvR6IYIEWHaN7TZUhb7MzBX4mwVaDi3YhGm)CtjsfQkMDJhg0z8xtrWqWch2kDZsKpxJSDV3mDD4G0PQImi6snDhndHaViETyOxeJY1SSGkKeq9SyT5UiCy3UwvNz8bWJS3W9zN6P5Boq92h)s8Khg6TNMZxQkFlTf5E2DuLaNm5dF(JAQ0BSOuvNfiVV2APAhkWiZOqmP0SdK5Qr4qoyscVVD9zZUsxVCpy3XExAMQPP)HvYKicP3yHa4dvbQeplYSGBhWrx4wQ3)V3o(aFw8PIbDX8jpMVUAexRGb7Im46NpuVXc9u)xCBqD3VtTYvBHsHnMcTHWmJVMPwlsrw4WkDG6VGAD)fuRojcQPG29lGGA9lLGAvgb10tLeVRM5hRKeuRteuZGdBzfuzW10xjb1APdupeuXdY3a3DZdQBRp25jzvLdZy73hN6sqyOpGOxIPgPVgJ83MYynlo0(TFMCYqSvzj2Q(sSpl1ONNgDeWevCsvIL2I1tLO(ird2cMaf1FK8XtHT9)3HbUGRYhfRdgddn7u6NZHoWuVqXJKz6QOiFOTpv9y23VkaimxZ1nlv)E3VTFSXSegU3JO(DyxvtIF6yGHqJNppUCguqedtOFgfsq6wrlgJXwh43i6YZRgC222MhWZhW09Q03XlmkAksGK1v)ktAoxbj5e4WaY7zu57YrBfDKQsE(znp)Swawj7n)Sw2nS73e4NSyG(Rn)SkMFYqYVQ8Z3cAKCeMfePpn8T)50dFlO5XryNy(2Fb9TPtMDy)InTtNmz5QpnDp8VP)(d]])