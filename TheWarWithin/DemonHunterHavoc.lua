-- DemonHunterHavoc.lua
-- January 2025

if UnitClassBase( "player" ) ~= "DEMONHUNTER" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local strformat, wipe = string.format, table.wipe
local GetSpellInfo = ns.GetUnpackedSpellInfo
local GetSpellCastCount = C_Spell.GetSpellCastCount
local IsSpellOverlayed = IsSpellOverlayed
local spec = Hekili:NewSpecialization( 577 )

spec:RegisterResource( Enum.PowerType.Fury, {
    mainhand_fury = {
        talent = "demon_blades",
        swing = "mainhand",

        last = function ()
            local swing = state.swings.mainhand
            local t = state.query_time

            return swing + floor( ( t - swing ) / state.swings.mainhand_speed ) * state.swings.mainhand_speed
        end,

        interval = "mainhand_speed",

        stop = function () return state.time == 0 or state.swings.mainhand == 0 end,
        value = function () return state.talent.demonsurge.enabled and state.buff.metamorphosis.up and 10 or 7 end,
    },

    offhand_fury = {
        talent = "demon_blades",
        swing = "offhand",

        last = function ()
            local swing = state.swings.offhand
            local t = state.query_time

            return swing + floor( ( t - swing ) / state.swings.offhand_speed ) * state.swings.offhand_speed
        end,

        interval = "offhand_speed",

        stop = function () return state.time == 0 or state.swings.offhand == 0 end,
        value = function () return state.talent.demonsurge.enabled and state.buff.metamorphosis.up and 10 or 7 end,
    },

    -- Immolation Aura now grants 20 up front, then 4 per second with burning hatred talent.
    immolation_aura = {
        talent  = "burning_hatred",
        aura    = "immolation_aura",

        last = function ()
            local app = state.buff.immolation_aura.applied
            local t = state.query_time

            return app + floor( t - app )
        end,

        interval = 1,
        value = 4
    },

    student_of_suffering = {
        talent  = "student_of_suffering",
        aura    = "student_of_suffering",

        last = function ()
            local app = state.buff.student_of_suffering.applied
            local t = state.query_time

            return app + floor( t - app )
        end,

        interval = function () return spec.auras.student_of_suffering.tick_time end,
        value = 5
    },

    tactical_retreat = {
        talent  = "tactical_retreat",
        aura    = "tactical_retreat",

        last = function ()
            local app = state.buff.tactical_retreat.applied
            local t = state.query_time

            return app + floor( t - app )
        end,

        interval = function() return class.auras.tactical_retreat.tick_time end,
        value = 8
    },

    eye_beam = {
        talent = "blind_fury",
        aura   = "eye_beam",

        last = function ()
            local app = state.buff.eye_beam.applied
            local t = state.query_time

            return app + floor( ( t - app ) / state.haste ) * state.haste
        end,

        interval = function() return state.haste end,
        value = function() return 20 * state.talent.blind_fury.rank end
    },
} )

-- Talents
spec:RegisterTalents( {
    -- DemonHunter
    aldrachi_design          = {  90999, 391409, 1 }, -- Increases your chance to parry by 3%.
    aura_of_pain             = {  90933, 207347, 1 }, -- Increases the critical strike chance of Immolation Aura by 6%.
    blazing_path             = {  91008, 320416, 1 }, -- Fel Rush gains an additional charge.
    bouncing_glaives         = {  90931, 320386, 1 }, -- Throw Glaive ricochets to 1 additional target.
    champion_of_the_glaive   = {  90994, 429211, 1 }, -- Throw Glaive has 2 charges and 10 yard increased range.
    chaos_fragments          = {  95154, 320412, 1 }, -- Each enemy stunned by Chaos Nova has a 30% chance to generate a Lesser Soul Fragment.
    chaos_nova               = {  90993, 179057, 1 }, -- Unleash an eruption of fel energy, dealing 7,335 Chaos damage and stunning all nearby enemies for 2 sec.
    charred_warblades        = {  90948, 213010, 1 }, -- You heal for 3% of all Fire damage you deal.
    collective_anguish       = {  95152, 390152, 1 }, -- Eye Beam summons an allied Vengeance Demon Hunter who casts Fel Devastation, dealing 43,890 Fire damage over 2.2 sec. Dealing damage heals you for up to 3,188 health.
    consume_magic            = {  91006, 278326, 1 }, -- Consume 1 beneficial Magic effect removing it from the target.
    darkness                 = {  91002, 196718, 1 }, -- Summons darkness around you in an 8 yd radius, granting friendly targets a 15% chance to avoid all damage from an attack. Lasts 8 sec. Chance to avoid damage increased by 100% when not in a raid.
    demon_muzzle             = {  90928, 388111, 1 }, -- Enemies deal 8% reduced magic damage to you for 8 sec after being afflicted by one of your Sigils.
    demonic                  = {  91003, 213410, 1 }, -- Eye Beam causes you to enter demon form for 5 sec after it finishes dealing damage.
    disrupting_fury          = {  90937, 183782, 1 }, -- Disrupt generates 30 Fury on a successful interrupt.
    erratic_felheart         = {  90996, 391397, 2 }, -- The cooldown of Fel Rush is reduced by 10%.
    felblade                 = {  95150, 232893, 1 }, -- Charge to your target and deal 22,671 Fire damage. Demon Blades has a chance to reset the cooldown of Felblade. Generates 40 Fury.
    felfire_haste            = {  90939, 389846, 1 }, -- Fel Rush increases your movement speed by 10% for 8 sec.
    flames_of_fury           = {  90949, 389694, 2 }, -- Sigil of Flame deals 35% increased damage and generates 1 additional Fury per target hit.
    illidari_knowledge       = {  90935, 389696, 1 }, -- Reduces magic damage taken by 5%.
    imprison                 = {  91007, 217832, 1 }, -- Imprisons a demon, beast, or humanoid, incapacitating them for 1 min. Damage may cancel the effect. Limit 1.
    improved_disrupt         = {  90938, 320361, 1 }, -- Increases the range of Disrupt to 10 yds.
    improved_sigil_of_misery = {  90945, 320418, 1 }, -- Reduces the cooldown of Sigil of Misery by 30 sec.
    infernal_armor           = {  91004, 320331, 2 }, -- Immolation Aura increases your armor by 20% and causes melee attackers to suffer 2,212 Fire damage.
    internal_struggle        = {  90934, 393822, 1 }, -- Increases your mastery by 4.5%.
    live_by_the_glaive       = {  95151, 428607, 1 }, -- When you parry an attack or have one of your attacks parried, restore 2% of max health and 10 Fury. This effect may only occur once every 5 sec.
    long_night               = {  91001, 389781, 1 }, -- Increases the duration of Darkness by 3 sec.
    lost_in_darkness         = {  90947, 389849, 1 }, -- Spectral Sight has 5 sec reduced cooldown and no longer reduces movement speed. 
    master_of_the_glaive     = {  90994, 389763, 1 }, -- Throw Glaive has 2 charges and snares all enemies hit by 50% for 6 sec.
    pitch_black              = {  91001, 389783, 1 }, -- Reduces the cooldown of Darkness by 120 sec.
    precise_sigils           = {  95155, 389799, 1 }, -- All Sigils are now placed at your target's location.
    pursuit                  = {  90940, 320654, 1 }, -- Mastery increases your movement speed.
    quickened_sigils         = {  95149, 209281, 1 }, -- All Sigils activate 1 second faster.
    rush_of_chaos            = {  95148, 320421, 2 }, -- Reduces the cooldown of Metamorphosis by 30 sec.
    shattered_restoration    = {  90950, 389824, 1 }, -- The healing of Shattered Souls is increased by 10%.
    sigil_of_misery          = {  90946, 207684, 1 }, -- Place a Sigil of Misery at the target location that activates after 1 sec. Causes all enemies affected by the sigil to cower in fear, disorienting them for 15 sec.
    sigil_of_spite           = {  90997, 390163, 1 }, -- Place a demonic sigil at the target location that activates after 1 sec. Detonates to deal 120,957 Chaos damage and shatter up to 3 Lesser Soul Fragments from enemies affected by the sigil. Deals reduced damage beyond 5 targets.
    soul_rending             = {  90936, 204909, 2 }, -- Leech increased by 6%. Gain an additional 6% leech while Metamorphosis is active.
    soul_sigils              = {  90929, 395446, 1 }, -- Afflicting an enemy with a Sigil generates 1 Lesser Soul Fragment. 
    swallowed_anger          = {  91005, 320313, 1 }, -- Consume Magic generates 20 Fury when a beneficial Magic effect is successfully removed from the target.
    the_hunt                 = {  90927, 370965, 1 }, -- Charge to your target, striking them for 153,784 Chaos damage, rooting them in place for 1.5 sec and inflicting 119,447 Chaos damage over 6 sec to up to 5 enemies in your path. The pursuit invigorates your soul, healing you for 10% of the damage you deal to your Hunt target for 20 sec.
    unrestrained_fury        = {  90941, 320770, 1 }, -- Increases maximum Fury by 20.
    vengeful_bonds           = {  90930, 320635, 1 }, -- Vengeful Retreat reduces the movement speed of all nearby enemies by 70% for 3 sec.
    vengeful_retreat         = {  90942, 198793, 1 }, -- Remove all snares and vault away. Nearby enemies take 2,865 Physical damage.
    will_of_the_illidari     = {  91000, 389695, 1 }, -- Increases maximum health by 5%.

    -- Havoc
    a_fire_inside            = {  95143, 427775, 1 }, -- Immolation Aura has 1 additional charge, 30% chance to refund a charge when used, and deals Chaos damage instead of Fire. You can have multiple Immolation Auras active at a time.
    accelerated_blade        = {  91011, 391275, 1 }, -- Throw Glaive deals 60% increased damage, reduced by 30% for each previous enemy hit.
    blind_fury               = {  91026, 203550, 2 }, -- Eye Beam generates 40 Fury every second, and its damage and duration are increased by 10%.
    burning_hatred           = {  90923, 320374, 1 }, -- Immolation Aura generates an additional 40 Fury over 10 sec.
    burning_wound            = {  90917, 391189, 1 }, -- Demon Blades and Throw Glaive leave open wounds on your enemies, dealing 20,193 Chaos damage over 15 sec and increasing damage taken from your Immolation Aura by 40%. May be applied to up to 3 targets.
    chaos_theory             = {  91035, 389687, 1 }, -- Blade Dance causes your next Chaos Strike within 8 sec to have a 14-30% increased critical strike chance and will always refund Fury.
    chaotic_disposition      = {  95147, 428492, 2 }, -- Your Chaos damage has a 7.77% chance to be increased by 17%, occurring up to 3 total times.
    chaotic_transformation   = {  90922, 388112, 1 }, -- When you activate Metamorphosis, the cooldowns of Blade Dance and Eye Beam are immediately reset.
    critical_chaos           = {  91028, 320413, 1 }, -- The chance that Chaos Strike will refund 20 Fury is increased by 30% of your critical strike chance.
    cycle_of_hatred          = {  91032, 258887, 1 }, -- Activating Eye Beam reduces the cooldown of your next Eye Beam by 5.0 sec, stacking up to 20 sec.
    dancing_with_fate        = {  91015, 389978, 2 }, -- The final slash of Blade Dance deals an additional 25% damage.
    dash_of_chaos            = {  93014, 427794, 1 }, -- For 2 sec after using Fel Rush, activating it again will dash back towards your initial location.
    deflecting_dance         = {  93015, 427776, 1 }, -- You deflect incoming attacks while Blade Dancing, absorbing damage up to 15% of your maximum health.
    demon_blades             = {  91019, 203555, 1 }, -- Your auto attacks deal an additional 3,423 Shadow damage and generate 7-12 Fury.
    demon_hide               = {  91017, 428241, 1 }, -- Magical damage increased by 3%, and Physical damage taken reduced by 5%.
    desperate_instincts      = {  93016, 205411, 1 }, -- Blur now reduces damage taken by an additional 10%. Additionally, you automatically trigger Blur with 50% reduced cooldown and duration when you fall below 35% health. This effect can only occur when Blur is not on cooldown.
    essence_break            = {  91033, 258860, 1 }, -- Slash all enemies in front of you for 75,406 Chaos damage, and increase the damage your Chaos Strike and Blade Dance deal to them by 80% for 4 sec. Deals reduced damage beyond 8 targets.
    exergy                   = {  91021, 206476, 1 }, -- The Hunt and Vengeful Retreat increase your damage by 5% for 20 sec.
    eye_beam                 = {  91018, 198013, 1 }, -- Blasts all enemies in front of you, for up to 322,392 Chaos damage over 1.8 sec. Deals reduced damage beyond 5 targets. When Eye Beam finishes fully channeling, your Haste is increased by an additional 10% for 10 sec.
    fel_barrage              = {  95144, 258925, 1 }, -- Unleash a torrent of Fel energy, rapidly consuming Fury to inflict 9,316 Chaos damage to all enemies within 12 yds, lasting 8 sec or until Fury is depleted. Deals reduced damage beyond 5 targets.
    first_blood              = {  90925, 206416, 1 }, -- Blade Dance deals 60,036 Chaos damage to the first target struck.
    furious_gaze             = {  91025, 343311, 1 }, -- When Eye Beam finishes fully channeling, your Haste is increased by an additional 10% for 10 sec.
    furious_throws           = {  93013, 393029, 1 }, -- Throw Glaive now costs 25 Fury and throws a second glaive at the target.
    glaive_tempest           = {  91035, 342817, 1 }, -- Launch two demonic glaives in a whirlwind of energy, causing 80,232 Chaos damage over 3 sec to all nearby enemies. Deals reduced damage beyond 8 targets.
    growing_inferno          = {  90916, 390158, 1 }, -- Immolation Aura's damage increases by 10% each time it deals damage.
    improved_chaos_strike    = {  91030, 343206, 1 }, -- Chaos Strike damage increased by 10%.
    improved_fel_rush        = {  93014, 343017, 1 }, -- Fel Rush damage increased by 20%.
    inertia                  = {  91021, 427640, 1 }, -- The Hunt and Vengeful Retreat cause your next Fel Rush or Felblade to empower you, increasing damage by 18% for 5 sec.
    initiative               = {  91027, 388108, 1 }, -- Damaging an enemy before they damage you increases your critical strike chance by 10% for 5 sec. Vengeful Retreat refreshes your potential to trigger this effect on any enemies you are in combat with.
    inner_demon              = {  91024, 389693, 1 }, -- Entering demon form causes your next Chaos Strike to unleash your inner demon, causing it to crash into your target and deal 56,855 Chaos damage to all nearby enemies. Deals reduced damage beyond 5 targets.
    insatiable_hunger        = {  91019, 258876, 1 }, -- Demon's Bite deals 50% more damage and generates 5 to 10 additional Fury.
    isolated_prey            = {  91036, 388113, 1 }, -- Chaos Nova, Eye Beam, and Immolation Aura gain bonuses when striking 1 target.  Chaos Nova: Stun duration increased by 2 sec.  Eye Beam: Deals 30% increased damage.  Immolation Aura: Always critically strikes.
    know_your_enemy          = {  91034, 388118, 2 }, -- Gain critical strike damage equal to 40% of your critical strike chance.
    looks_can_kill           = {  90921, 320415, 1 }, -- Eye Beam deals guaranteed critical strikes.
    mortal_dance             = {  93015, 328725, 1 }, -- Blade Dance now reduces targets' healing received by 50% for 6 sec.
    netherwalk               = {  93016, 196555, 1 }, -- Slip into the nether, increasing movement speed by 100% and becoming immune to damage, but unable to attack. Lasts 6 sec.
    ragefire                 = {  90918, 388107, 1 }, -- Each time Immolation Aura deals damage, 30% of the damage dealt by up to 3 critical strikes is gathered as Ragefire. When Immolation Aura expires you explode, dealing all stored Ragefire damage to nearby enemies.
    relentless_onslaught     = {  91012, 389977, 1 }, -- Chaos Strike has a 10% chance to trigger a second Chaos Strike.
    restless_hunter          = {  91024, 390142, 1 }, -- Leaving demon form grants a charge of Fel Rush and increases the damage of your next Blade Dance by 50%.
    scars_of_suffering       = {  90914, 428232, 1 }, -- Increases Versatility by 4% and reduces threat generated by 8%.
    screaming_brutality      = {  90919, 1220506, 1 }, -- Blade Dance automatically triggers Throw Glaive on your primary target for 100% damage and each slash has a 50% chance to Throw Glaive an enemy for 35% damage.
    serrated_glaive          = {  91013, 390154, 1 }, -- Enemies hit by Chaos Strike or Throw Glaive take 15% increased damage from Chaos Strike and Throw Glaive for 15 sec.
    shattered_destiny        = {  91031, 388116, 1 }, -- The duration of your active demon form is extended by 0.1 sec per 12 Fury spent.
    soulscar                 = {  91012, 388106, 1 }, -- Throw Glaive causes targets to take an additional 80% of damage dealt as Chaos over 6 sec.
    tactical_retreat         = {  91022, 389688, 1 }, -- Vengeful Retreat has a 5 sec reduced cooldown and generates 80 Fury over 10 sec.
    trail_of_ruin            = {  90915, 258881, 1 }, -- The final slash of Blade Dance inflicts an additional 19,218 Chaos damage over 4 sec.
    unbound_chaos            = {  91020, 347461, 1 }, -- The Hunt and Vengeful Retreat increase the damage of your next Fel Rush or Felblade by 300%. Lasts 12 sec.

    -- Aldrachi Reaver
    aldrachi_tactics         = {  94914, 442683, 1 }, -- The second enhanced ability in a pattern shatters an additional Soul Fragment.
    army_unto_oneself        = {  94896, 442714, 1 }, -- Felblade surrounds you with a Blade Ward, reducing damage taken by 10% for 5 sec.
    art_of_the_glaive        = {  94915, 442290, 1, "aldrachi_reaver" }, -- Consuming 6 Soul Fragments or casting The Hunt converts your next Throw Glaive into Reaver's Glaive.  Reaver's Glaive: Throw a glaive enhanced with the essence of consumed souls at your target, dealing 46,361 Physical damage and ricocheting to 3 additional enemies. Begins a well-practiced pattern of glaivework, enhancing your next Chaos Strike and Blade Dance. The enhanced ability you cast first deals 10% increased damage, and the second deals 20% increased damage.
    evasive_action           = {  94911, 444926, 1 }, -- Vengeful Retreat can be cast a second time within 3 sec.
    fury_of_the_aldrachi     = {  94898, 442718, 1 }, -- When enhanced by Reaver's Glaive, Blade Dance casts 3 additional glaive slashes to nearby targets. If cast after Chaos Strike, cast 6 slashes instead.
    incisive_blade           = {  94895, 442492, 1 }, -- Chaos Strike deals 10% increased damage.
    incorruptible_spirit     = {  94896, 442736, 1 }, -- Each Soul Fragment you consume shields you for an additional 15% of the amount healed.
    keen_engagement          = {  94910, 442497, 1 }, -- Reaver's Glaive generates 20 Fury.
    preemptive_strike        = {  94910, 444997, 1 }, -- Throw Glaive deals 3,443 Physical damage to enemies near its initial target.
    reavers_mark             = {  94903, 442679, 1 }, -- When enhanced by Reaver's Glaive, Chaos Strike applies Reaver's Mark, which causes the target to take 7% increased damage for 20 sec. If cast after Blade Dance, Reaver's Mark is increased to 14%.
    thrill_of_the_fight      = {  94919, 442686, 1 }, -- After consuming both enhancements, gain Thrill of the Fight, increasing your attack speed by 15% for 20 sec and your damage and healing by 20% for 10 sec.
    unhindered_assault       = {  94911, 444931, 1 }, -- Vengeful Retreat resets the cooldown of Felblade.
    warblades_hunger         = {  94906, 442502, 1 }, -- Consuming a Soul Fragment causes your next Chaos Strike to deal 6,886 additional Physical damage. Felblade consumes up to 5 nearby Soul Fragments.
    wounded_quarry           = {  94897, 442806, 1 }, -- Expose weaknesses in the target of your Reaver's Mark, causing your Physical damage to any enemy to also deal 20% of the damage dealt to your marked target as Chaos. 

    -- Fel-Scarred
    burning_blades           = {  94905, 452408, 1 }, -- Your blades burn with Fel energy, causing your Chaos Strike, Throw Glaive, and auto-attacks to deal an additional 50% damage as Fire over 6 sec.
    demonic_intensity        = {  94901, 452415, 1 }, -- Activating Metamorphosis greatly empowers Eye Beam, Immolation Aura, and Sigil of Flame. Demonsurge damage is increased by 10% for each time it previously triggered while your demon form is active.
    demonsurge               = {  94917, 452402, 1, "felscarred" }, -- Metamorphosis now also causes Demon Blades to generate 5 additional Fury. While demon form is active, the first cast of each empowered ability induces a Demonsurge, causing you to explode with Fel energy, dealing 28,790 Fire damage to nearby enemies.
    enduring_torment         = {  94916, 452410, 1 }, -- The effects of your demon form persist outside of it in a weakened state, increasing Chaos Strike and Blade Dance damage by 15%, and Haste by 5%.
    flamebound               = {  94902, 452413, 1 }, -- Immolation Aura has 2 yd increased radius and 30% increased critical strike damage bonus.
    focused_hatred           = {  94918, 452405, 1 }, -- Demonsurge deals 50% increased damage when it strikes a single target. Each additional target reduces this bonus by 10%.
    improved_soul_rending    = {  94899, 452407, 1 }, -- Leech granted by Soul Rending increased by 2% and an additional 2% while Metamorphosis is active.
    monster_rising           = {  94909, 452414, 1 }, -- Agility increased by 8% while not in demon form.
    pursuit_of_angriness     = {  94913, 452404, 1 }, -- Movement speed increased by 1% per 10 Fury.
    set_fire_to_the_pain     = {  94899, 452406, 1 }, -- 5% of all non-Fire damage taken is instead taken as Fire damage over 6 sec. Fire damage taken reduced by 10%.
    student_of_suffering     = {  94902, 452412, 1 }, -- Sigil of Flame applies Student of Suffering to you, increasing Mastery by 18.0% and granting 5 Fury every 2 sec, for 6 sec.
    untethered_fury          = {  94904, 452411, 1 }, -- Maximum Fury increased by 50.
    violent_transformation   = {  94912, 452409, 1 }, -- When you activate Metamorphosis, the cooldowns of your Sigil of Flame and Immolation Aura are immediately reset.
    wave_of_debilitation     = {  94913, 452403, 1 }, -- Chaos Nova slows enemies by 60% and reduces attack and cast speed 15% for 5 sec after its stun fades. 
} )

-- PvP Talents
spec:RegisterPvpTalents( { 
    blood_moon        = 5433, -- (355995) 
    cleansed_by_flame =  805, -- (205625) 
    cover_of_darkness = 1206, -- (357419) 
    detainment        =  812, -- (205596) 
    glimpse           =  813, -- (354489) 
    illidans_grasp    = 5691, -- (205630) You strangle the target with demonic magic, stunning them in place and dealing 120,508 Shadow damage over 5 sec while the target is grasped. Can move while channeling. Use Illidan's Grasp again to toss the target to a location within 20 yards.
    rain_from_above   =  811, -- (206803) You fly into the air out of harm's way. While floating, you gain access to Fel Lance allowing you to deal damage to enemies below. 
    reverse_magic     =  806, -- (205604) Removes all harmful magical effects from yourself and all nearby allies within 10 yards, and sends them back to their original caster if possible.
    sigil_mastery     = 5523, -- (211489) 
    unending_hatred   = 1218, -- (213480) 
} )

-- Auras
spec:RegisterAuras( {
    -- $w1 Soul Fragments consumed. At $?a212612[$442290s1~][$442290s2~], Reaver's Glaive is available to cast.
    art_of_the_glaive = {
        id = 444661,
        duration = 30.0,
        max_stack = 6
    },
    -- Dodge chance increased by $s2%.
    -- https://wowhead.com/beta/spell=188499
    blade_dance = {
        id = 188499,
        duration = 1,
        max_stack = 1
    },
    -- Damage taken reduced by $s1%.
    blade_ward = {
        id = 442715,
        duration = 5.0,
        max_stack = 1
    },
    blazing_slaughter = {
        id = 355892,
        duration = 12,
        max_stack = 20
    },
    -- Versatility increased by $w1%.
    -- https://wowhead.com/beta/spell=355894
    blind_faith = {
        id = 355894,
        duration = 20,
        max_stack = 1
    },
    -- Dodge increased by $s2%. Damage taken reduced by $s3%.
    -- https://wowhead.com/beta/spell=212800
    blur = {
        id = 212800,
        duration = 10,
        max_stack = 1
    },
    -- https://www.wowhead.com/spell=453177
    burning_blades = {
        id = 453177,
        duration = 6,
        max_stack = 1
    },
    -- Talent: Taking $w1 Chaos damage every $t1 seconds.  Damage taken from $@auracaster's Immolation Aura increased by $s2%.
    -- https://wowhead.com/beta/spell=391191
    burning_wound_391191 = {
        id = 391191,
        duration = 15,
        tick_time = 3,
        max_stack = 1
    },
    burning_wound_346278 = {
        id = 346278,
        duration = 15,
        tick_time = 3,
        max_stack = 1
    },
    burning_wound = {
        alias = { "burning_wound_391191", "burning_wound_346278" },
        aliasMode = "first",
        aliasType = "buff"
    },
    -- Talent: Stunned.
    -- https://wowhead.com/beta/spell=179057
    chaos_nova = {
        id = 179057,
        duration = function () return talent.isolated_prey.enabled and active_enemies == 1 and 4 or 2 end,
        type = "Magic",
        max_stack = 1
    },
    chaos_theory = {
        id = 390195,
        duration = 8,
        max_stack = 1
    },
    chaotic_blades = {
        id = 337567,
        duration = 8,
        max_stack = 1
    },
    cycle_of_hatred = {
        id = 1214887,
        duration = 3600,
        max_stack = 4
    },
    darkness = {
        id = 196718,
        duration = function () return pvptalent.cover_of_darkness.enabled and 10 or 8 end,
        max_stack = 1
    },
    death_sweep = {
        id = 210152,
        duration = 1,
        max_stack = 1
    },
    -- https://www.wowhead.com/spell=427901
    -- Deflecting Dance Absorbing 1180318 damage.
    deflecting_dance = {
        id = 427901,
        duration = 1,
        max_stack = 1
    },
    demon_soul = {
        id = 347765,
        duration = 15,
        max_stack = 1
    },
    -- https://www.wowhead.com/spell=452416
    -- Demonsurge Damage of your next Demonsurge is increased by 40%.
    demonsurge = {
        id = 452416,
        duration = 12,
        max_stack = 10
    },
    -- Fake buffs for demonsurge damage procs
    demonsurge_abyssal_gaze = {},
    demonsurge_annihilation = {},
    demonsurge_consuming_fire = {},
    demonsurge_death_sweep = {},
    demonsurge_hardcast = {},
    demonsurge_sigil_of_doom = {},
    -- TODO: This aura determines sigil pop time.
    elysian_decree = {
        id = 390163,
        duration = function () return talent.quickened_sigils.enabled and 1 or 2 end,
        max_stack = 1,
        copy = "sigil_of_spite"
    },
    -- https://www.wowhead.com/spell=453314
    -- Enduring Torment Chaos Strike and Blade Dance damage increased by 10%. Haste increased by 5%.
    enduring_torment = {
        id = 453314,
        duration = 3600,
        max_stack = 1
    },
    essence_break = {
        id = 320338,
        duration = 4,
        max_stack = 1,
        copy = "dark_slash" -- Just in case.
    },
    -- Vengeful Retreat may be cast again.
    evasive_action = {
        id = 444929,
        duration = 3.0,
        max_stack = 1,
    },
    -- https://wowhead.com/beta/spell=198013
    eye_beam = {
        id = 198013,
        duration = function () return 2 * ( 1 + 0.1 * talent.blind_fury.rank ) * haste end,
        generate = function( t )
            if buff.casting.up and buff.casting.v1 == 198013 then
                t.applied  = buff.casting.applied
                t.duration = buff.casting.duration
                t.expires  = buff.casting.expires
                t.stack    = 1
                t.caster   = "player"
                forecastResources( "fury" )
                return
            end

            t.applied  = 0
            t.duration = class.auras.eye_beam.duration
            t.expires  = 0
            t.stack    = 0
            t.caster   = "nobody"
        end,
        tick_time = 0.2,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Unleashing Fel.
    -- https://wowhead.com/beta/spell=258925
    fel_barrage = {
        id = 258925,
        duration = 8,
        tick_time = 0.25,
        max_stack = 1
    },
    -- Legendary.
    fel_bombardment = {
        id = 337849,
        duration = 40,
        max_stack = 5,
    },
    -- Legendary
    fel_devastation = {
        id = 333105,
        duration = 2,
        max_stack = 1,
    },
    furious_gaze = {
        id = 343312,
        duration = 10,
        max_stack = 1,
    },
    -- Talent: Stunned.
    -- https://wowhead.com/beta/spell=211881
    fel_eruption = {
        id = 211881,
        duration = 4,
        max_stack = 1
    },
    -- Talent: Movement speed increased by $w1%.
    -- https://wowhead.com/beta/spell=389847
    felfire_haste = {
        id = 389847,
        duration = 8,
        max_stack = 1,
        copy = 338804
    },
    -- Branded, dealing $204021s1% less damage to $@auracaster$?s389220[ and taking $w2% more Fire damage from them][].
    -- https://wowhead.com/beta/spell=207744
    fiery_brand = {
        id = 207744,
        duration = 10,
        max_stack = 1
    },
    -- Talent: Battling a demon from the Theater of Pain...
    -- https://wowhead.com/beta/spell=391430
    fodder_to_the_flame = {
        id = 391430,
        duration = 25,
        max_stack = 1,
        copy = { 329554, 330910 }
    },
    -- The demon is linked to you.
    fodder_to_the_flame_chase = {
        id = 328605,
        duration = 3600,
        max_stack = 1,
    },
    -- This is essentially the countdown before the demon despawns (you can Imprison it for a long time).
    fodder_to_the_flame_cooldown = {
        id = 342357,
        duration = 120,
        max_stack = 1,
    },
    -- Falling speed reduced.
    -- https://wowhead.com/beta/spell=131347
    glide = {
        id = 131347,
        duration = 3600,
        max_stack = 1
    },
    -- Burning nearby enemies for $258922s1 $@spelldesc395020 damage every $t1 sec.$?a207548[    Movement speed increased by $w4%.][]$?a320331[    Armor increased by $w5%. Attackers suffer $@spelldesc395020 damage.][]
    -- https://wowhead.com/beta/spell=258920
    immolation_aura_1 = {
        id = 258920,
        duration = function() return talent.felfire_heart.enabled and 8 or 6 end,
        tick_time = 1,
        max_stack = 1
    },
    immolation_aura_2 = {
        id = 427912,
        duration = function() return talent.felfire_heart.enabled and 8 or 6 end,
        tick_time = 1,
        max_stack = 1
    },
    immolation_aura_3 = {
        id = 427913,
        duration = function() return talent.felfire_heart.enabled and 8 or 6 end,
        tick_time = 1,
        max_stack = 1
    },
    immolation_aura_4 = {
        id = 427914,
        duration = function() return talent.felfire_heart.enabled and 8 or 6 end,
        tick_time = 1,
        max_stack = 1
    },
    immolation_aura_5 = {
        id = 427915,
        duration = function() return talent.felfire_heart.enabled and 8 or 6 end,
        tick_time = 1,
        max_stack = 1
    },
    immolation_aura = {
        alias = { "immolation_aura_1", "immolation_aura_2", "immolation_aura_3", "immolation_aura_4", "immolation_aura_5" },
        aliasMode = "longest",
        aliasType = "buff",
        max_stack = 5
    },
    -- Talent: Incapacitated.
    -- https://wowhead.com/beta/spell=217832
    imprison = {
        id = 217832,
        duration = 60,
        mechanic = "sap",
        type = "Magic",
        max_stack = 1
    },
    -- Damage done increased by $w1%.
    inertia_damage_buff = { -- find out what simc is gonna use
        id = 427641,
        duration = 5,
        max_stack = 1,
        copy = "inertia"
    },
    -- https://www.wowhead.com/spell=1215159
    -- Inertia Your next Fel Rush or Felblade increases your damage by 18% for 5 sec.
    inertia_prep_buff = { -- find out what simc is gonna use
        id = 1215159,
        duration = 12,
        max_stack = 1,
        copy = "inertia_trigger"
    },
    initiative = {
        id = 391215,
        duration = 5,
        max_stack = 1
    },
    initiative_tracker = {
        duration = 3600,
        max_stack = 1
    },
    inner_demon = {
        id = 337313,
        duration = 10,
        max_stack = 1,
        copy = 390145
    },
    -- Talent: Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=213405
    master_of_the_glaive = {
        id = 213405,
        duration = 6,
        mechanic = "snare",
        max_stack = 1
    },
    -- Chaos Strike and Blade Dance upgraded to $@spellname201427 and $@spellname210152.  Haste increased by $w4%.$?s235893[  Versatility increased by $w5%.][]$?s204909[  Leech increased by $w3%.][]
    -- https://wowhead.com/beta/spell=162264
    metamorphosis = {
        id = 162264,
        duration = 20,
        max_stack = 1,
        -- This copy is for SIMC compatibility while avoiding managing a virtual buff.
        copy = "demonsurge_demonic"
    },
    exergy = {
        id = 208628,
        duration = 30, -- extends up to 30
        max_stack = 1,
        copy = "momentum"
    },
    -- Agility increased by $w1%.
    monster_rising = {
        id = 452550,
        duration = 3600,
        max_stack = 1,
    },
    -- Stunned.
    -- https://wowhead.com/beta/spell=200166
    metamorphosis_stun = {
        id = 200166,
        duration = 3,
        type = "Magic",
        max_stack = 1
    },
    -- Dazed.
    -- https://wowhead.com/beta/spell=247121
    metamorphosis_daze = {
        id = 247121,
        duration = 3,
        type = "Magic",
        max_stack = 1
    },
    misery_in_defeat = {
        id = 391369,
        duration = 5,
        max_stack = 1,
    },
    -- Talent: Healing effects received reduced by $w1%.
    -- https://wowhead.com/beta/spell=356608
    mortal_dance = {
        id = 356608,
        duration = 6,
        max_stack = 1
    },
    -- Talent: Immune to damage and unable to attack.  Movement speed increased by $s3%.
    -- https://wowhead.com/beta/spell=196555
    netherwalk = {
        id = 196555,
        duration = 6,
        max_stack = 1
    },
    -- $w3
    pursuit_of_angriness = {
        id = 452404,
        duration = 0.0,
        tick_time = 1.0,
        max_stack = 1,
    },
    ragefire = {
        id = 390192,
        duration = 30,
        max_stack = 1,
    },
    rain_from_above_immune = {
        id = 206803,
        duration = 1,
        tick_time = 1,
        max_stack = 1,
        copy = "rain_from_above_launch"
    },
    rain_from_above = { -- Gliding/floating.
        id = 206804,
        duration = 10,
        max_stack = 1
    },
    reavers_glaive = {
        -- no id, fake buff
        duration = 3600,
        max_Stack = 1
    },
    restless_hunter = {
        id = 390212,
        duration = 12,
        max_stack = 1
    },
    -- Damage taken from Chaos Strike and Throw Glaive increased by $w1%.
    serrated_glaive = {
        id = 390155,
        duration = 15,
        max_stack = 1,
    },
    -- Taking $w1 Fire damage every $t1 sec.
    set_fire_to_the_pain = {
        id = 453286,
        duration = 6.0,
        tick_time = 1.0,
    },
    -- Movement slowed by $s1%.
    -- https://wowhead.com/beta/spell=204843
    sigil_of_chains = {
        id = 204843,
        duration = function() return 6 + talent.extended_sigils.rank + ( talent.precise_sigils.enabled and 2 or 0 ) end,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Suffering $w2 $@spelldesc395020 damage every $t2 sec.
    -- https://wowhead.com/beta/spell=204598
    sigil_of_flame = {
        id = 204598,
        duration = function() return ( talent.felfire_heart.enabled and 8 or 6 ) + talent.extended_sigils.rank + ( talent.precise_sigils.enabled and 2 or 0 ) end,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Sigil of Flame is active.
    -- https://wowhead.com/beta/spell=389810
    sigil_of_flame_active = {
        id = 389810,
        duration = function () return talent.quickened_sigils.enabled and 1 or 2 end,
        max_stack = 1,
        copy = 204596
    },
    -- Talent: Disoriented.
    -- https://wowhead.com/beta/spell=207685
    sigil_of_misery_debuff = {
        id = 207685,
        duration = function() return 15 + talent.extended_sigils.rank + ( talent.precise_sigils.enabled and 2 or 0 ) end,
        mechanic = "flee",
        type = "Magic",
        max_stack = 1
    },
    sigil_of_misery = { -- TODO: Model placement pop.
        id = 207684,
        duration = function () return talent.quickened_sigils.enabled and 1 or 2 end,
        max_stack = 1
    },
    -- Silenced.
    -- https://wowhead.com/beta/spell=204490
    sigil_of_silence_debuff = {
        id = 204490,
        duration = function() return 6 + talent.extended_sigils.rank + ( talent.precise_sigils.enabled and 2 or 0 ) end,
        type = "Magic",
        max_stack = 1
    },
    sigil_of_silence = { -- TODO: Model placement pop.
        id = 202137,
        duration = function () return talent.quickened_sigils.enabled and 1 or 2 end,
        max_stack = 1
    },
    -- Consume to heal for $210042s1% of your maximum health.
    -- https://wowhead.com/beta/spell=203795
    soul_fragment = {
        id = 203795,
        duration = 20,
        max_stack = 1
    },
    -- Talent: Suffering $w1 Chaos damage every $t1 sec.
    -- https://wowhead.com/beta/spell=390181
    soulscar = {
        id = 390181,
        duration = 6,
        tick_time = 2,
        max_stack = 1
    },
    -- Can see invisible and stealthed enemies.  Can see enemies and treasures through physical barriers.
    -- https://wowhead.com/beta/spell=188501
    spectral_sight = {
        id = 188501,
        duration = 10,
        max_stack = 1
    },
    -- Mastery increased by ${$w1*$mas}.1%. ; Generating $453236s1 Fury every $t2 sec.
    student_of_suffering = {
        id = 453239,
        duration = 6,
        tick_time = 2.0,
        max_stack = 1,
    },
    tactical_retreat = {
        id = 389890,
        duration = 8,
        tick_time = 1,
        max_stack = 1
    },
    -- Talent: Suffering $w1 $@spelldesc395042 damage every $t1 sec.
    -- https://wowhead.com/beta/spell=345335
    the_hunt_dot = {
        id = 370969,
        duration = function() return set_bonus.tier31_4pc > 0 and 12 or 6 end,
        tick_time = 2,
        type = "Magic",
        max_stack = 1,
        copy = 345335
    },
    -- Talent: Marked by the Demon Hunter, converting $?c1[$345422s1%][$345422s2%] of the damage done to healing.
    -- https://wowhead.com/beta/spell=370966
    the_hunt = {
        id = 370966,
        duration = 30,
        max_stack = 1,
        copy = 323802
    },
    the_hunt_root = {
        id = 370970,
        duration = 1.5,
        max_stack = 1,
        copy = 323996
    },
    -- Attack Speed increased by $w1%
    thrill_of_the_fight = {
        id = 442695,
        duration = 20.0,
        max_stack = 1,
        copy = "thrill_of_the_fight_attack_speed",
    },
    thrill_of_the_fight_damage = {
        id = 442688,
        duration = 10,
        max_stack = 1,
    },
    -- Taunted.
    -- https://wowhead.com/beta/spell=185245
    torment = {
        id = 185245,
        duration = 3,
        max_stack = 1
    },
    -- Talent: Suffering $w1 Chaos damage every $t1 sec.
    -- https://wowhead.com/beta/spell=258883
    trail_of_ruin = {
        id = 258883,
        duration = 4,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    unbound_chaos = {
        id = 347462,
        duration = 20,
        max_stack = 1,
        -- copy = "inertia_trigger"
    },
    vengeful_retreat_movement = {
        duration = 1,
        max_stack = 1,
        generate = function( t )
            if action.vengeful_retreat.lastCast > query_time - 1 then
                t.applied  = action.vengeful_retreat.lastCast
                t.duration = 1
                t.expires  = action.vengeful_retreat.lastCast + 1
                t.stack    = 1
                t.caster   = "player"
                return
            end

            t.applied  = 0
            t.duration = 1
            t.expires  = 0
            t.stack    = 0
            t.caster   = "nobody"
        end,
    },
    -- Talent: Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=198813
    vengeful_retreat = {
        id = 198813,
        duration = 3,
        max_stack = 1,
        copy = "vengeful_retreat_snare"
    },
    -- Your next $?a212612[Chaos Strike]?s263642[Fracture][Shear] will deal $442507s1 additional Physical damage.
    warblades_hunger = {
        id = 442503,
        duration = 30.0,
        max_stack = 1,
    },

    -- Conduit
    exposed_wound = {
        id = 339229,
        duration = 10,
        max_stack = 1,
    },

    -- PvP Talents
    chaotic_imprint_shadow = {
        id = 356656,
        duration = 20,
        max_stack = 1,
    },
    chaotic_imprint_nature = {
        id = 356660,
        duration = 20,
        max_stack = 1,
    },
    chaotic_imprint_arcane = {
        id = 356658,
        duration = 20,
        max_stack = 1,
    },
    chaotic_imprint_fire = {
        id = 356661,
        duration = 20,
        max_stack = 1,
    },
    chaotic_imprint_frost = {
        id = 356659,
        duration = 20,
        max_stack = 1,
    },
    -- Conduit
    demonic_parole = {
        id = 339051,
        duration = 12,
        max_stack = 1
    },
    glimpse = {
        id = 354610,
        duration = 8,
        max_stack = 1,
    },
} )

spec:RegisterStateExpr( "soul_fragments", function ()
    return GetSpellCastCount(232893) -- only works with Reaver hero tree
end )

spec:RegisterStateTable( "fragments", {
    real = 0,
    realTime = 0,
} )

spec:RegisterStateFunction( "queue_fragments", function( num, extraTime )
    fragments.real = fragments.real + num
    fragments.realTime = GetTime() + 1.25 + ( extraTime or 0 )
end )

spec:RegisterStateFunction( "purge_fragments", function()
    fragments.real = 0
    fragments.realTime = 0
end )

spec:RegisterStateExpr( "activation_time", function()
    return talent.quickened_sigils.enabled and 1 or 2
end )


local furySpent = 0

local FURY = Enum.PowerType.Fury
local lastFury = -1

spec:RegisterUnitEvent( "UNIT_POWER_FREQUENT", "player", nil, function( event, unit, powerType )
    if powerType == "FURY" and state.set_bonus.tier30_2pc > 0 then
        local current = UnitPower( "player", FURY )

        if current < lastFury - 3 then
            furySpent = ( furySpent + lastFury - current )
        end

        lastFury = current
    end
end )

spec:RegisterStateExpr( "fury_spent", function ()
    if set_bonus.tier30_2pc == 0 then return 0 end
    return furySpent
end )

local queued_frag_modifier = 0
local initiative_actual, initiative_virtual = {}, {}

local death_events = {
    UNIT_DIED               = true,
    UNIT_DESTROYED          = true,
    UNIT_DISSIPATES         = true,
    PARTY_KILL              = true,
    SPELL_INSTAKILL         = true,
}

spec:RegisterHook( "COMBAT_LOG_EVENT_UNFILTERED", function( _, subtype, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName )
    if sourceGUID == GUID then
        if subtype == "SPELL_CAST_SUCCESS" then
            if spellID == 198793 and talent.initiative.enabled then
                wipe( initiative_actual )
            end

        elseif spellID == 203981 and fragments.real > 0 and ( subtype == "SPELL_AURA_APPLIED" or subtype == "SPELL_AURA_APPLIED_DOSE" ) then
            fragments.real = fragments.real - 1

        elseif state.set_bonus.tier30_2pc > 0 and subtype == "SPELL_AURA_APPLIED" and spellID == 408737 then
            furySpent = max( 0, furySpent - 175 )

        elseif state.talent.initiative.enabled and subtype == "SPELL_DAMAGE" then
            initiative_actual[ destGUID ] = true
        end
    elseif destGUID == GUID and ( subtype == "SPELL_DAMAGE" or subtype == "SPELL_PERIODIC_DAMAGE" ) then
        initiative_actual[ sourceGUID ] = true

    elseif death_events[ subtype ] then
        initiative_actual[ destGUID ] = nil
    end
end, false )

spec:RegisterEvent( "PLAYER_REGEN_ENABLED", function()
    wipe( initiative_actual )
end )

spec:RegisterHook( "UNIT_ELIMINATED", function( id )
    initiative_actual[ id ] = nil
end )

-- Gear Sets
spec:RegisterGear( "tier29", 200345, 200347, 200342, 200344, 200346 )
spec:RegisterAura( "seething_chaos", {
    id = 394934,
    duration = 6,
    max_stack = 1
} )

-- Tier 30
spec:RegisterGear( "tier30", 202527, 202525, 202524, 202523, 202522 )
-- 2 pieces (Havoc) : Every 175 Fury you spend, gain Seething Fury, increasing your Agility by 8% for 6 sec.
-- TODO: Track Fury spent toward Seething Fury.  New expressions: seething_fury_threshold, seething_fury_spent, seething_fury_deficit.
spec:RegisterAura( "seething_fury", {
    id = 408737,
    duration = 6,
    max_stack = 1
} )
-- 4 pieces (Havoc) : Each time you gain Seething Fury, gain 15 Fury and the damage of your next Eye Beam is increased by 15%, stacking 5 times.
spec:RegisterAura( "seething_potential", {
    id = 408754,
    duration = 60,
    max_stack = 5
} )

spec:RegisterGear( "tier31", 207261, 207262, 207263, 207264, 207266, 217228, 217230, 217226, 217227, 217229 )
-- (2) Blade Dance automatically triggers Throw Glaive on your primary target for $s3% damage and each slash has a $s2% chance to Throw Glaive an enemy for $s1% damage.
-- (4) Throw Glaive reduces the remaining cooldown of The Hunt by ${$s1/1000}.1 sec, and The Hunt's damage over time effect lasts ${$s2/1000} sec longer.

spec:RegisterGear( "tww2", 229316, 229314, 229319, 229317, 229315 )
spec:RegisterAuras( {
    -- 2-set
    -- Winning Streak! Increase the DPS of Blade Dance and Chaos Strike by 3% stacking pu to 10 times. Blade Dance and Chaos Strike have 15% chance of removing Winning Streak! .
    winning_streak = {
        id = 1217011,
        duration = 3600,
        max_stack = 10
        },
    --4-set
    -- Winning Streak persists for 7s after being cancelled. Entering Demon Form sacrifices all Winning Streak! stacks to gain 0% (?) Crit Strike Chance per stack consumed. Lasts 15s
    necessary_sacrifice = {
    id = 1217055,
    duration = 15,
    max_stack = 10
    },
    -- https://www.wowhead.com/spell=1220706
    -- Winning Streak! Ending a Winning Streak! Blade Dance and Chaos Strike damage increased by 6%.
    winning_streak_temporary = {
        id = 1220706,
        duration = 7,
        max_stack = 10
    },

} )

spec:RegisterGear( "tww1", 212068, 212066, 212065, 212064, 212063 )
spec:RegisterAura( "blade_rhapsody", {
    id = 454628,
    duration = 12,
    max_stack = 1
} )

-- Abilities that may trigger Demonsurge.
local demonsurge = {
    demonic = { "annihilation", "death_sweep" },
    hardcast = { "abyssal_gaze", "consuming_fire", "sigil_of_doom" },
}

local demonsurgeLastSeen = setmetatable( {}, {
    __index = function( t, k ) return rawget( t, k ) or 0 end,
})

spec:RegisterHook( "reset_precast", function ()
    wipe( initiative_virtual )
    active_dot.initiative_tracker = 0

    for k, v in pairs( initiative_actual ) do
        initiative_virtual[ k ] = v

        if k == target.unit then
            applyDebuff( "target", "initiative_tracker" )
        else
            active_dot.initiative_tracker = active_dot.initiative_tracker + 1
        end
    end

    --[[ 20250301: Legacy items from Legion that reduce the cooldown of Metamorphosis.
    local rps = 0

    if equipped.convergence_of_fates then
        rps = rps + ( 3 / ( 60 / 4.35 ) )
    end

    if equipped.delusions_of_grandeur then
        -- From SimC model, 1/13/2018.
        local fps = 10.2 + ( talent.demonic.enabled and 1.2 or 0 )

        -- SimC uses base haste, we'll use current since we recalc each time.
        fps = fps / haste

        -- Chaos Strike accounts for most Fury expenditure.
        fps = fps + ( ( fps * 0.9 ) * 0.5 * ( 40 / 100 ) )

        rps = rps + ( fps / 30 ) * ( 1 )
    end
    --]]

    if IsSpellKnownOrOverridesKnown( 442294 ) then
        applyBuff( "reavers_glaive" )
        if Hekili.ActiveDebug then Hekili:Debug( "Applied Reaver's Glaive." ) end
    end

    if talent.demonsurge.enabled and buff.metamorphosis.up then
        local metaRemains = buff.metamorphosis.remains

        for _, name in ipairs( demonsurge.demonic ) do
            if IsSpellOverlayed( class.abilities[ name ].id ) then
                applyBuff( "demonsurge_" .. name, metaRemains )
                demonsurgeLastSeen[ name ] = query_time
            end
        end
        if talent.demonic_intensity.enabled then
            local metaApplied = buff.metamorphosis.applied - 0.2
            if action.metamorphosis.lastCast >= metaApplied or action.abyssal_gaze.lastCast >= metaApplied then
                applyBuff( "demonsurge_hardcast", metaRemains )
            end
            for _, name in ipairs( demonsurge.hardcast ) do
                if IsSpellOverlayed( class.abilities[ name ].id ) then
                    applyBuff( "demonsurge_" .. name, metaRemains )
                    demonsurgeLastSeen[ name ] = query_time
                end
            end

            -- The Demonsurge buff does not actually get applied in-game until ~500ms after
            -- the empowered ability is cast. Pretend that it's applied instantly for any
            -- APL conditions that check `buff.demonsurge.stack`.

            local pending = 0

            for _, list in pairs( demonsurge ) do
                for _, name in ipairs( list ) do
                    local hasPending = buff[ "demonsurge_" .. name ].down and abs( action[ name ].lastCast - demonsurgeLastSeen[ name ] ) < 0.7 and action[ name ].lastCast > buff.demonsurge.applied
                    if hasPending then pending = pending + 1 end
                    --[[
                    if Hekili.ActiveDebug then
                        Hekili:Debug( " - " .. ( hasPending and "PASS: " or "FAIL: " ) ..
                            "buff.demonsurge_" .. name .. ".down[" .. ( buff[ "demonsurge_" .. name ].down and "true" or "false" ) .. "] & " ..
                            "@( action." .. name .. ".lastCast[" .. action[ name ].lastCast .. "] - lastSeen." .. name .. "[" .. demonsurgeLastSeen[ name ] .. "] ) < 0.7 & " ..
                            "action." .. name .. ".lastCast[" .. action[ name ].lastCast .. "] > buff.demonsurge.applied[" .. buff.demonsurge.applied .. "]" )
                    end
                    --]]
                end
            end
            if pending > 0 then
                addStack( "demonsurge", nil, pending )
            end
            if Hekili.ActiveDebug then
                Hekili:Debug( " - buff.demonsurge.stack[" .. buff.demonsurge.stack - pending .. " + " .. pending .. "]" )
            end
        end

        if Hekili.ActiveDebug then
            Hekili:Debug( "Demonsurge status:\n" ..
                " - Hardcast " .. ( buff.demonsurge_hardcast.up and "ACTIVE" or "INACTIVE" ) .. "\n" ..
                " - Demonic " .. ( buff.demonsurge_demonic.up and "ACTIVE" or "INACTIVE" ) .. "\n" ..
                " - Abyssal Gaze " .. ( buff.demonsurge_abyssal_gaze.up and "ACTIVE" or "INACTIVE" ) .. "\n" ..
                " - Annihilation " .. ( buff.demonsurge_annihilation.up and "ACTIVE" or "INACTIVE" ) .. "\n" ..
                " - Consuming Fire " .. ( buff.demonsurge_consuming_fire.up and "ACTIVE" or "INACTIVE" ) .. "\n" ..
                " - Death Sweep " .. ( buff.demonsurge_death_sweep.up and "ACTIVE" or "INACTIVE" ) .. "\n" ..
                " - Sigil of Doom " .. ( buff.demonsurge_sigil_of_doom.up and "ACTIVE" or "INACTIVE" ) )
        end
    end

    fury_spent = nil
end )


spec:RegisterHook( "runHandler", function( action )
    local ability = class.abilities[ action ]

    if ability.startsCombat and not debuff.initiative_tracker.up then
        applyBuff( "initiative" )
        applyDebuff( "target", "initiative_tracker" )
    end
end )


spec:RegisterHook( "spend", function( amt, resource )
    if set_bonus.tier30_2pc == 0 or amt < 0 or resource ~= "fury" then return end

    fury_spent = fury_spent + amt
    if fury_spent > 175 then
        fury_spent = fury_spent - 175
        applyBuff( "seething_fury" )
        if set_bonus.tier30_4pc > 0 then
            gain( 15, "fury" )
            applyBuff( "seething_potential" )
        end
    end
end )




spec:RegisterGear( "tier19", 138375, 138376, 138377, 138378, 138379, 138380 )
spec:RegisterGear( "tier20", 147130, 147132, 147128, 147127, 147129, 147131 )
spec:RegisterGear( "tier21", 152121, 152123, 152119, 152118, 152120, 152122 )
    spec:RegisterAura( "havoc_t21_4pc", {
        id = 252165,
        duration = 8
    } )

spec:RegisterGear( "class", 139715, 139716, 139717, 139718, 139719, 139720, 139721, 139722 )

spec:RegisterGear( "convergence_of_fates", 140806 )

spec:RegisterGear( "achor_the_eternal_hunger", 137014 )
spec:RegisterGear( "anger_of_the_halfgiants", 137038 )
spec:RegisterGear( "cinidaria_the_symbiote", 133976 )
spec:RegisterGear( "delusions_of_grandeur", 144279 )
spec:RegisterGear( "kiljaedens_burning_wish", 144259 )
spec:RegisterGear( "loramus_thalipedes_sacrifice", 137022 )
spec:RegisterGear( "moarg_bionic_stabilizers", 137090 )
spec:RegisterGear( "prydaz_xavarics_magnum_opus", 132444 )
spec:RegisterGear( "raddons_cascading_eyes", 137061 )
spec:RegisterGear( "sephuzs_secret", 132452 )
spec:RegisterGear( "the_sentinels_eternal_refuge", 146669 )

spec:RegisterGear( "soul_of_the_slayer", 151639 )
spec:RegisterGear( "chaos_theory", 151798 )
spec:RegisterGear( "oblivions_embrace", 151799 )


do
    local wasWarned = false

    spec:RegisterEvent( "PLAYER_REGEN_DISABLED", function ()
        if state.talent.demon_blades.enabled and not state.settings.demon_blades_acknowledged and not wasWarned then
            Hekili:Notify( "|cFFFF0000WARNING!|r  Fury from Demon Blades is forecasted very conservatively.\nSee /hekili > Havoc for more information." )
            wasWarned = true
        end
    end )
end


local TriggerDemonic = setfenv( function( )
    local demonicExtension = 7

    if buff.metamorphosis.up then
        buff.metamorphosis.expires = buff.metamorphosis.expires + demonicExtension
        -- Fel-Scarred
        if talent.demonsurge.enabled then
            local metaExpires = buff.metamorphosis.expires

            for _, name in ipairs( demonsurge.demonic ) do
                local aura = buff[ "demonsurge_" .. name ]
                if aura.up then aura.expires = metaExpires end
            end

            if talent.demonic_intensity.enabled and buff.demonsurge_hardcast.up then
                buff.demonsurge_hardcast.expires = metaExpires

                for _, name in ipairs( demonsurge.hardcast ) do
                    local aura = buff[ "demonsurge_" .. name ]
                    if aura.up then aura.expires = metaExpires end
                end
            end
        end
    else
        applyBuff( "metamorphosis", demonicExtension )
        if talent.inner_demon.enabled then applyBuff( "inner_demon" ) end
        stat.haste = stat.haste + 20
        -- Fel-Scarred
        if talent.demonsurge.enabled then
            local metaRemains = buff.metamorphosis.remains

            for _, name in ipairs( demonsurge.demonic ) do
                applyBuff( "demonsurge_" .. name, metaRemains )
            end
        end
    end

end, state )

-- Abilities
spec:RegisterAbilities( {
    annihilation = {
        id = 201427,
        known = 162794,
        flash = { 201427, 162794 },
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 40,
        spendType = "fury",

        startsCombat = true,
        texture = 1303275,

        bind = "chaos_strike",
        buff = "metamorphosis",

        handler = function ()
            spec.abilities.chaos_strike.handler()
            -- Fel-Scarred
            if buff.demonsurge_annihilation.up then
                removeBuff( "demonsurge_annihilation" )
                if talent.demonic_intensity.enabled then addStack( "demonsurge" ) end
            end
        end,
    },

    -- Strike $?a206416[your primary target for $<firstbloodDmg> Chaos damage and ][]all nearby enemies for $<baseDmg> Physical damage$?s320398[, and increase your chance to dodge by $193311s1% for $193311d.][. Deals reduced damage beyond $199552s1 targets.]
    blade_dance = {
        id = 188499,
        flash = { 188499, 210152 },
        cast = 0,
        cooldown = 10,
        hasteCD = true,
        gcd = "spell",
        school = "physical",

        spend = function() return 35 * ( buff.blade_rhapsody.up and 0.5 or 1 ) end,
        spendType = "fury",

        startsCombat = true,

        bind = "death_sweep",
        nobuff = "metamorphosis",

        handler = function ()
            -- Standard and Talents
            applyBuff( "blade_dance" )
            removeBuff( "restless_hunter" )
            setCooldown( "death_sweep", action.blade_dance.cooldown )
            if talent.chaos_theory.enabled then applyBuff( "chaos_theory" ) end
            if talent.deflecting_dance.enabled then applyBuff( "deflecting_dance" ) end
            if talent.screaming_brutality.enabled then spec.abilities.throw_glaive.handler() end
            if talent.mortal_dance.enabled then applyDebuff( "target", "mortal_dance" ) end

            -- TWW
            if set_bonus.tww1 >= 2 then removeBuff( "blade_rhapsody") end

            -- Hero Talents
            if buff.glaive_flurry.up then
                removeBuff( "glaive_flurry" )
                if talent.thrill_of_the_fight.enabled and buff.rending_strike.down then
                    applyBuff( "thrill_of_the_fight" )
                    applyBuff( "thrill_of_the_fight_damage" )
                end
            end
        end,

        copy = "blade_dance1"
    },

    -- Increases your chance to dodge by $212800s2% and reduces all damage taken by $212800s3% for $212800d.
    blur = {
        id = 198589,
        cast = 0,
        cooldown = function () return 60 + ( conduit.fel_defender.mod * 0.001 ) end,
        gcd = "off",
        school = "physical",

        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "blur" )
        end,
    },

    -- Talent: Unleash an eruption of fel energy, dealing $s2 Chaos damage and stunning all nearby enemies for $d.$?s320412[    Each enemy stunned by Chaos Nova has a $s3% chance to generate a Lesser Soul Fragment.][]
    chaos_nova = {
        id = 179057,
        cast = 0,
        cooldown = 45,
        gcd = "spell",
        school = "chromatic",

        spend = 25,
        spendType = "fury",

        talent = "chaos_nova",
        startsCombat = true,

        toggle = "cooldowns",

        handler = function ()
            applyDebuff( "target", "chaos_nova" )
        end,
    },

    -- Slice your target for ${$222031s1+$199547s1} Chaos damage. Chaos Strike has a ${$min($197125h,100)}% chance to refund $193840s1 Fury.
    chaos_strike = {
        id = 162794,
        flash = { 162794, 201427 },
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "chaos",

        spend = 40,
        spendType = "fury",

        startsCombat = true,

        bind = "annihilation",
        nobuff = "metamorphosis",

        cycle = function () return ( talent.burning_wound.enabled or legendary.burning_wound.enabled ) and "burning_wound" or nil end,

        handler = function ()
            removeBuff( "inner_demon" )
            if buff.chaos_theory.up then
                gain( 20, "fury" )
                removeBuff( "chaos_theory" )
            end
            
            -- Reaver
            if buff.rending_strike.up then
                applyDebuff( "target", "reavers_mark" )
                removeBuff( "rending_strike" )
                if talent.thrill_of_the_fight.enabled and buff.glaive_flurry.down then
                    applyBuff( "thrill_of_the_fight" )
                    applyBuff( "thrill_of_the_fight_damage" )
                end
            end
            removeBuff( "warblades_hunger" )

            -- Legacy
            removeBuff( "chaotic_blades" )
        end,
    },

    -- Talent: Consume $m1 beneficial Magic effect removing it from the target$?s320313[ and granting you $s2 Fury][].
    consume_magic = {
        id = 278326,
        cast = 0,
        cooldown = 10,
        gcd = "spell",
        school = "chromatic",

        startsCombat = false,
        talent = "consume_magic",

        toggle = "interrupts",

        usable = function () return buff.dispellable_magic.up end,
        handler = function ()
            removeBuff( "dispellable_magic" )
            if talent.swallowed_anger.enabled then gain( 20, "fury" ) end
        end,
    },

    -- Summons darkness around you in a$?a357419[ 12 yd][n 8 yd] radius, granting friendly targets a $209426s2% chance to avoid all damage from an attack. Lasts $d.; Chance to avoid damage increased by $s3% when not in a raid.
    darkness = {
        id = 196718,
        cast = 0,
        cooldown = 300,
        gcd = "spell",
        school = "physical",

        talent = "darkness",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "darkness" )
        end,
    },


    death_sweep = {
        id = 210152,
        known = 188499,
        flash = { 210152, 188499 },
        cast = 0,
        cooldown = 9,
        hasteCD = true,
        gcd = "spell",

        spend = function() return 35 * ( buff.blade_rhapsody.up and 0.5 or 1 ) end,
        spendType = "fury",

        startsCombat = true,
        texture = 1309099,

        bind = "blade_dance",
        buff = "metamorphosis",

        handler = function ()
            setCooldown( "blade_dance", action.death_sweep.cooldown )
            spec.abilities.blade_dance.handler()
            applyBuff( "death_sweep" )

            -- Fel-Scarred
            if buff.demonsurge_death_sweep.up then
                removeBuff( "demonsurge_death_sweep" )
                if talent.demonic_intensity.enabled then addStack( "demonsurge" ) end
            end
        end,
    },

    -- Quickly attack for $s2 Physical damage.    |cFFFFFFFFGenerates $?a258876[${$m3+$258876s3} to ${$M3+$258876s4}][$m3 to $M3] Fury.|r
    demons_bite = {
        id = 162243,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "physical",

        spend = function () return talent.insatiable_hunger.enabled and -25 or -20 end,
        spendType = "fury",

        startsCombat = true,

        notalent = "demon_blades",
        cycle = function () return ( talent.burning_wound.enabled or legendary.burning_wound.enabled ) and "burning_wound" or nil end,

        handler = function ()
            if talent.burning_wound.enabled then applyDebuff( "target", "burning_wound" ) end
        end,
    },

    -- Interrupts the enemy's spellcasting and locks them from that school of magic for $d.|cFFFFFFFF$?s183782[    Generates $218903s1 Fury on a successful interrupt.][]|r
    disrupt = {
        id = 183752,
        cast = 0,
        cooldown = 15,
        gcd = "off",
        school = "chromatic",

        startsCombat = true,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
            if talent.disrupting_fury.enabled then gain( 30, "fury" ) end
        end,
    },

    -- Talent: Slash all enemies in front of you for $s1 Chaos damage, and increase the damage your Chaos Strike and Blade Dance deal to them by $320338s1% for $320338d. Deals reduced damage beyond $s2 targets.
    essence_break = {
        id = 258860,
        cast = 0,
        cooldown = 40,
        gcd = "spell",
        school = "chromatic",

        talent = "essence_break",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "essence_break" )
            active_dot.essence_break = max( 1, active_enemies )
        end,

        copy = "dark_slash"
    },

    -- Blasts all enemies in front of you,$?s320415[ dealing guaranteed critical strikes][] for up to $<dmg> Chaos damage over $d. Deals reduced damage beyond $s5 targets.$?s343311[; When Eye Beam finishes fully channeling, your Haste is increased by an additional $343312s1% for $343312d.][]
    eye_beam = {
        id = 198013,
        cast = function () return ( talent.blind_fury.enabled and 3 or 2 ) * haste end,
        channeled = true,
        cooldown = 40,
        gcd = "spell",
        school = "chromatic",

        spend = 30,
        spendType = "fury",

        talent = "eye_beam",
        startsCombat = true,
        nobuff = function () return talent.demonic_intensity.enabled and "metamorphosis" or nil end,

        start = function()
            applyBuff( "eye_beam" )
            if talent.demonic.enabled then TriggerDemonic() end
            if talent.cycle_of_hatred.enabled then
                reduceCooldown( "eye_beam", 5 * talent.cycle_of_hatred.rank * buff.cycle_of_hatred.stack )
                addStack( "cycle_of_hatred" )
            end
            removeBuff( "seething_potential" )
            setCooldown( "abyssal_gaze", action.eye_beam.cooldown )
        end,

        finish = function()
            if talent.furious_gaze.enabled then applyBuff( "furious_gaze" ) end
        end,

        bind = "abyssal_gaze"
    },

    abyssal_gaze = {
        id = 452497,
        known = 198013,
        cast = function () return ( talent.blind_fury.enabled and 3 or 2 ) * haste end,
        channeled = true,
        cooldown = 40,
        gcd = "spell",
        school = "chromatic",

        spend = 30,
        spendType = "fury",

        talent = "demonic_intensity",
        buff = "demonsurge_hardcast",
        startsCombat = true,

        start = function()
            applyBuff( "eye_beam" )
            if talent.demonic.enabled then TriggerDemonic() end
            if talent.cycle_of_hatred.enabled then
                reduceCooldown( "abyssal_gaze", 5 * talent.cycle_of_hatred.rank * buff.cycle_of_hatred.stack )
                addStack( "cycle_of_hatred" )
            end
            if buff.demonsurge_abyssal_gaze.up then
                removeBuff( "demonsurge_abyssal_gaze" )
                if talent.demonic_intensity.enabled then addStack( "demonsurge" ) end
            end
            removeBuff( "seething_potential" )
            setCooldown( "eye_beam", action.abyssal_gaze.cooldown )
        end,

        finish = function() spec.abilities.eye_beam.finish() end,

        bind = "eye_beam"
    },

    -- Talent: Unleash a torrent of Fel energy over $d, inflicting ${(($d/$t1)+1)*$258926s1} Chaos damage to all enemies within $258926A1 yds. Deals reduced damage beyond $258926s2 targets.
    fel_barrage = {
        id = 258925,
        cast = 3,
        channeled = true,
        cooldown = 90,
        gcd = "spell",
        school = "chromatic",

        spend = 10,
        spendType = "fury",

        talent = "fel_barrage",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "fel_barrage" )
        end,
    },

    -- Impales the target for $s1 Chaos damage and stuns them for $d.
    fel_eruption = {
        id = 211881,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "chromatic",

        spend = 10,
        spendType = "fury",

        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "fel_eruption" )
        end,
    },


    fel_lance = {
        id = 206966,
        cast = 1,
        cooldown = 0,
        gcd = "spell",

        pvptalent = "rain_from_above",
        buff = "rain_from_above",

        startsCombat = true,
    },

    -- Rush forward, incinerating anything in your path for $192611s1 Chaos damage.
    fel_rush = {
        id = 195072,
        cast = 0,
        charges = function() return talent.blazing_path.enabled and 2 or nil end,
        cooldown = function () return ( legendary.erratic_fel_core.enabled and 7 or 10 ) * ( 1 - 0.1 * talent.erratic_felheart.rank ) end,
        recharge = function () return talent.blazing_path.enabled and ( ( legendary.erratic_fel_core.enabled and 7 or 10 ) * ( 1 - 0.1 * talent.erratic_felheart.rank ) ) or nil end,
        gcd = "off",
        icd = 0.5,
        school = "physical",

        startsCombat = true,
        nodebuff = "rooted",

        readyTime = function ()
            if prev[1].fel_rush then return 3600 end
            if ( settings.fel_rush_charges or 1 ) == 0 then return end
            return ( ( 1 + ( settings.fel_rush_charges or 1 ) ) - cooldown.fel_rush.charges_fractional ) * cooldown.fel_rush.recharge
        end,

        handler = function ()
            setDistance( 5 )
            setCooldown( "global_cooldown", 0.25 )

            if buff.unbound_chaos.up then removeBuff( "unbound_chaos" ) end
            if buff.inertia_prep_buff.up then
                removeBuff( "inertia_prep_buff" )
                applyBuff( "inertia_damage_buff" )
            end
            if conduit.felfire_haste.enabled then applyBuff( "felfire_haste" ) end
        end,
    },

    -- Talent: Charge to your target and deal $213243sw2 $@spelldesc395020 damage.    $?s203513[Shear has a chance to reset the cooldown of Felblade.    |cFFFFFFFFGenerates $213243s3 Fury.|r]?a203555[Demon Blades has a chance to reset the cooldown of Felblade.    |cFFFFFFFFGenerates $213243s3 Fury.|r][Demon's Bite has a chance to reset the cooldown of Felblade.    |cFFFFFFFFGenerates $213243s3 Fury.|r]
    felblade = {
        id = 232893,
        cast = 0,
        cooldown = 15,
        hasteCD = true,
        gcd = "spell",
        school = "physical",

        spend = -40,
        spendType = "fury",

        talent = "felblade",
        startsCombat = true,
        nodebuff = "rooted",

        handler = function ()
            setDistance( 5 )
            if buff.unbound_chaos.up then removeBuff( "unbound_chaos" ) end
            if buff.inertia_prep_buff.up then
                removeBuff( "inertia_prep_buff" )
                applyBuff( "inertia_damage_buff" )
            end
            if talent.warblades_hunger.enabled then
                if buff.art_of_the_glaive.stack + soul_fragments >= 6 then
                    applyBuff( "reavers_glaive" )
                else
                    addStack( "art_of_the_glaive", soul_fragments )
                end
                addStack( "warblades_hunger", soul_fragments )
            end
        end,
    },

    -- Talent: Launch two demonic glaives in a whirlwind of energy, causing ${14*$342857s1} Chaos damage over $d to all nearby enemies. Deals reduced damage beyond $s2 targets.
    glaive_tempest = {
        id = 342817,
        cast = 0,
        cooldown = 25,
        gcd = "spell",
        school = "magic",

        spend = 30,
        spendType = "fury",

        talent = "glaive_tempest",
        startsCombat = true,

        handler = function ()
        end,
    },

    -- Engulf yourself in flames, $?a320364 [instantly causing $258921s1 $@spelldesc395020 damage to enemies within $258921A1 yards and ][]radiating ${$258922s1*$d} $@spelldesc395020 damage over $d.$?s320374[    |cFFFFFFFFGenerates $<havocTalentFury> Fury over $d.|r][]$?(s212612 & !s320374)[    |cFFFFFFFFGenerates $<havocFury> Fury.|r][]$?s212613[    |cFFFFFFFFGenerates $<vengeFury> Fury over $d.|r][]
    immolation_aura = {
        id = function() return buff.demonsurge_hardcast.up and 452487 or 258920 end,
        known = 258920,
        cast = 0,
        cooldown = 30,
        hasteCD = true,
        charges = function()
            if talent.a_fire_inside.enabled then return 2 end
        end,
        recharge = function()
            if talent.a_fire_inside.enabled then return 30 * haste end
        end,
        gcd = "spell",
        school = function() return talent.a_fire_inside.enabled and "chaos" or "fire" end,
        texture = function() return buff.demonsurge_hardcast.up and 135794 or 1344649 end,

        spend = -20,
        spendType = "fury",
        startsCombat = false,

        handler = function ()
            applyBuff( "immolation_aura" )
            if talent.ragefire.enabled then applyBuff( "ragefire" ) end

            if buff.demonsurge_consuming_fire.up then
                removeBuff( "demonsurge_consuming_fire" )
                if talent.demonic_intensity.enabled then addStack( "demonsurge" ) end
            end
        end,

        copy = { 258920, 427917, "consuming_fire", 452487 }
    },

    -- Talent: Imprisons a demon, beast, or humanoid, incapacitating them for $d. Damage will cancel the effect. Limit 1.
    imprison = {
        id = 217832,
        cast = 0,
        gcd = "spell",
        school = "shadow",

        talent = "imprison",
        startsCombat = false,

        handler = function ()
            applyDebuff( "target", "imprison" )
        end,
    },

    -- Leap into the air and land with explosive force, dealing $200166s2 Chaos damage to enemies within 8 yds, and stunning them for $200166d. Players are Dazed for $247121d instead.    Upon landing, you are transformed into a hellish demon for $162264d, $?s320645[immediately resetting the cooldown of your Eye Beam and Blade Dance abilities, ][]greatly empowering your Chaos Strike and Blade Dance abilities and gaining $162264s4% Haste$?(s235893&s204909)[, $162264s5% Versatility, and $162264s3% Leech]?(s235893&!s204909[ and $162264s5% Versatility]?(s204909&!s235893)[ and $162264s3% Leech][].
    metamorphosis = {
        id = 191427,
        cast = 0,
        cooldown = function () return ( 180 - ( 30 * talent.rush_of_chaos.rank ) )  end,
        gcd = "spell",
        school = "physical",

        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "metamorphosis", buff.metamorphosis.remains + 20 )
            setDistance( 5 )
            stat.haste = stat.haste + 20

            if talent.chaotic_transformation.enabled then
                setCooldown( "eye_beam", 0 )
                setCooldown( "abyssal_gaze", 0 )
                setCooldown( "blade_dance", 0 )
                setCooldown( "death_sweep", 0 )
            end

            if talent.demonsurge.enabled then
                local metaRemains = buff.metamorphosis.remains

                for _, name in ipairs( demonsurge.demonic ) do
                    applyBuff( "demonsurge_ " .. name, metaRemains )
                end

                if talent.violent_transformation.enabled then
                    setCooldown( "sigil_of_flame", 0 )
                    gainCharges( "immolation_aura", 1 )
                    if talent.demonic_intensity.enabled then
                        gainCharges( "consuming_fire", 1 )
                        setCooldown( "sigil_of_doom", 0 )
                    end
                end

                if talent.demonic_intensity.enabled then
                    removeBuff( "demonsurge" )
                    applyBuff( "demonsurge_hardcast", metaRemains )

                    for _, name in ipairs( demonsurge.hardcast ) do
                        applyBuff( "demonsurge_ " .. name, metaRemains )
                    end
                end
            end

            -- Legacy
            if covenant.venthyr then
                applyDebuff( "target", "sinful_brand" )
                active_dot.sinful_brand = active_enemies
            end
        end,

        -- We need to alias to spell ID 200166 to catch SPELL_CAST_SUCCESS for Metamorphosis.
        copy = 200166
    },

    -- Talent: Slip into the nether, increasing movement speed by $s3% and becoming immune to damage, but unable to attack. Lasts $d.
    netherwalk = {
        id = 196555,
        cast = 0,
        cooldown = 180,
        gcd = "spell",
        school = "physical",

        talent = "netherwalk",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            applyBuff( "netherwalk" )
            setCooldown( "global_cooldown", buff.netherwalk.remains )
        end,
    },


    rain_from_above = {
        id = 206803,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        pvptalent = "rain_from_above",

        startsCombat = false,
        texture = 1380371,

        handler = function ()
            applyBuff( "rain_from_above" )
        end,
    },


    reverse_magic = {
        id = 205604,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        -- toggle = "cooldowns",
        pvptalent = "reverse_magic",

        startsCombat = false,
        texture = 1380372,

        debuff = "reversible_magic",

        handler = function ()
            if debuff.reversible_magic.up then removeDebuff( "player", "reversible_magic" ) end
        end,
    },


    -- Talent: Place a Sigil of Flame at your location that activates after $d.    Deals $204598s1 Fire damage, and an additional $204598o3 Fire damage over $204598d, to all enemies affected by the sigil.    |CFFffffffGenerates $389787s1 Fury.|R
    sigil_of_flame = {
        id = function() return talent.precise_sigils.enabled and 389810 or 204596 end,
        known = 204596,
        cast = 0,
        cooldown = function() return ( pvptalent.sigil_of_mastery.enabled and 0.75 or 1 ) * 30 end,
        gcd = "spell",
        school = "fire",

        spend = -30,
        spendType = "fury",

        startsCombat = false,
        texture = 1344652,
        nobuff = "demonsurge_hardcast",

        flightTime = function() return activation_time end,
        delay = function() return activation_time end,
        placed = function() return query_time < action.sigil_of_flame.lastCast + activation_time end,

        impact = function()
            applyDebuff( "target", "sigil_of_flame" )
            active_dot.sigil_of_flame = active_enemies
            if talent.soul_sigils.enabled then addStack( "soul_fragments", nil, 1 ) end
            if talent.student_of_suffering.enabled then applyBuff( "student_of_suffering" ) end
            if talent.flames_of_fury.enabled then gain( talent.flames_of_fury.rank * active_enemies, "fury" ) end
        end,

        copy = { 204596, 389810 },
        bind = "sigil_of_doom"
    },

    sigil_of_doom = {
        id = function () return talent.precise_sigils.enabled and 469991 or 452490 end,
        known = 204596,
        cast = 0,
        cooldown = function() return ( pvptalent.sigil_of_mastery.enabled and 0.75 or 1 ) * 30 end,
        gcd = "spell",
        school = "chaos",

        spend = -30,
        spendType = "fury",

        talent = "demonic_intensity",
        buff = "demonsurge_hardcast",

        startsCombat = false,
        texture = 1121022,

        flightTime = function() return activation_time end,
        delay = function() return activation_time end,
        placed = function() return query_time < action.sigil_of_doom.lastCast + activation_time end,

        handler = function ()
            if buff.demonsurge_sigil_of_doom.up then
                removeBuff( "demonsurge_sigil_of_doom" )
                if talent.demonic_intensity.enabled then addStack( "demonsurge" ) end
            end
            -- Sigil of Doom and Sigil of Flame share a cooldown.
            setCooldown( "sigil_of_flame", action.sigil_of_doom.cooldown )
        end,

        impact = function()
            applyDebuff( "target", "sigil_of_doom" )
            active_dot.sigil_of_doom = active_enemies
            if talent.soul_sigils.enabled then addStack( "soul_fragments", nil, 1 ) end
            if talent.student_of_suffering.enabled then applyBuff( "student_of_suffering" ) end
            if talent.flames_of_fury.enabled then gain( talent.flames_of_fury.rank * active_enemies, "fury" ) end
        end,

        copy = { 452490, 469991 },
        bind = "sigil_of_flame"
    },

    -- Talent: Place a Sigil of Misery at your location that activates after $d.    Causes all enemies affected by the sigil to cower in fear. Targets are disoriented for $207685d.
    sigil_of_misery = {
        id = function () return talent.precise_sigils.enabled and 389813 or 207684 end,
        known = 207684,
        cast = 0,
        cooldown = function () return 120 * ( pvptalent.sigil_mastery.enabled and 0.75 or 1 ) end,
        gcd = "spell",
        school = "physical",

        talent = "sigil_of_misery",
        startsCombat = false,

        toggle = "interrupts",

        flightTime = function() return activation_time end,
        delay = function() return activation_time end,
        placed = function() return query_time < action.sigil_of_misery.lastCast + activation_time end,

        impact = function()
            applyDebuff( "target", "sigil_of_misery_debuff" )
        end,

        copy = { 207684, 389813 }
    },

    -- Place a demonic sigil at the target location that activates after $d.; Detonates to deal $389860s1 Chaos damage and shatter up to $s3 Lesser Soul Fragments from
    sigil_of_spite = {
        id = function () return talent.precise_sigils.enabled and 389815 or 390163 end,
        known = 390163,
        cast = 0.0,
        cooldown = function() return 60 * ( pvptalent.sigil_mastery.enabled and 0.75 or 1 ) end,
        gcd = "spell",

        talent = "sigil_of_spite",
        startsCombat = false,

        flightTime = function() return activation_time end,
        delay = function() return activation_time end,
        placed = function() return query_time < action.sigil_of_spite.lastCast + activation_time end,

        impact = function ()
            addStack( "soul_fragments", nil, talent.soul_sigils.enabled and 4 or 3 )
        end,

        copy = { 389815, 390163 }
    },

    -- Allows you to see enemies and treasures through physical barriers, as well as enemies that are stealthed and invisible. Lasts $d.    Attacking or taking damage disrupts the sight.
    spectral_sight = {
        id = 188501,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "physical",

        startsCombat = false,

        handler = function ()
            applyBuff( "spectral_sight" )
        end,
    },

    -- Talent / Covenant (Night Fae): Charge to your target, striking them for $370966s1 $@spelldesc395042 damage, rooting them in place for $370970d and inflicting $370969o1 $@spelldesc395042 damage over $370969d to up to $370967s2 enemies in your path.     The pursuit invigorates your soul, healing you for $?c1[$370968s1%][$370968s2%] of the damage you deal to your Hunt target for $370966d.
    the_hunt = {
        id = function() return talent.the_hunt.enabled and 370965 or 323639 end,
        cast = 1,
        cooldown = function() return talent.the_hunt.enabled and 90 or 180 end,
        gcd = "spell",
        school = "nature",

        startsCombat = true,
        toggle = "cooldowns",
        nodebuff = "rooted",

        handler = function ()
            applyDebuff( "target", "the_hunt" )
            applyDebuff( "target", "the_hunt_dot" )
            setDistance( 5 )

            if talent.exergy.enabled then
                applyBuff( "exergy", min( 30, buff.exergy.remains + 20 ) )
            elseif talent.inertia.enabled then -- talent choice node, only 1 or the other
                applyBuff( "inertia_prep_buff" )
            end
            if talent.unbound_chaos.enabled then applyBuff( "unbound_chaos" ) end

            -- Hero Talents
            if talent.art_of_the_glaive.enabled then applyBuff( "reavers_glaive" ) end

            -- Legacy
            if legendary.blazing_slaughter.enabled then
                applyBuff( "immolation_aura" )
                applyBuff( "blazing_slaughter" )
            end
        end,

        copy = { 370965, 323639 }
    },

    -- Throw a demonic glaive at the target, dealing $337819s1 Physical damage. The glaive can ricochet to $?$s320386[${$337819x1-1} additional enemies][an additional enemy] within 10 yards.
    throw_glaive = {
        id = 185123,
        known = 185123,
        cast = 0,
        charges = function () return talent.champion_of_the_glaive.enabled and 2 or nil end,
        cooldown = 9,
        recharge = function () return talent.champion_of_the_glaive.enabled and 9 or nil end,
        gcd = "spell",
        school = "physical",

        spend = function() return talent.furious_throws.enabled and 25 or 0 end,
        spendType = "fury",

        startsCombat = true,
        nobuff = "reavers_glaive",

        readyTime = function ()
            if ( settings.throw_glaive_charges or 1 ) == 0 then return end
            return ( ( 1 + ( settings.throw_glaive_charges or 1 ) ) - cooldown.throw_glaive.charges_fractional ) * cooldown.throw_glaive.recharge
        end,

        handler = function ()
            if talent.burning_wound.enabled then applyDebuff( "target", "burning_wound" ) end
            if talent.champion_of_the_glaive.enabled then applyDebuff( "target", "master_of_the_glaive" ) end
            if talent.serrated_glaive.enabled then applyDebuff( "target", "serrated_glaive" ) end
            if talent.soulscar.enabled then applyDebuff( "target", "soulscar" ) end
            if set_bonus.tier31_4pc > 0 then reduceCooldown( "the_hunt", 2 ) end
        end,

        bind = "reavers_glaive"
    },

    reavers_glaive = {
        id = 442294,
        cast = 0,
        charges = function () return talent.champion_of_the_glaive.enabled and 2 or nil end,
        cooldown = 9,
        recharge = function () return talent.champion_of_the_glaive.enabled and 9 or nil end,
        gcd = "spell",
        school = "physical",
        known = 442290,

        spend = function() return talent.keen_engagement.enabled and -20 or nil end,
        spendType = function() return talent.keen_engagement.enabled and "fury" or nil end,

        startsCombat = true,
        buff = "reavers_glaive",

        handler = function ()
            removeBuff( "reavers_glaive" )
            if talent.master_of_the_glaive.enabled then applyDebuff( "target", "master_of_the_glaive" ) end
            applyBuff( "rending_strike" )
            applyBuff( "glaive_flurry" )
        end,

        bind = "throw_glaive"
    },

    -- Taunts the target to attack you.
    torment = {
        id = 185245,
        cast = 0,
        cooldown = 8,
        gcd = "off",
        school = "shadow",

        startsCombat = false,

        handler = function ()
            applyBuff( "torment" )
        end,
    },

    -- Talent: Remove all snares and vault away. Nearby enemies take $198813s2 Physical damage$?s320635[ and have their movement speed reduced by $198813s1% for $198813d][].$?a203551[    |cFFFFFFFFGenerates ${($203650s1/5)*$203650d} Fury over $203650d if you damage an enemy.|r][]
    vengeful_retreat = {
        id = 198793,
        cast = 0,
        cooldown = function () return talent.tactical_retreat.enabled and 20 or 25 end,
        gcd = "off",

        startsCombat = true,
        nodebuff = "rooted",

        readyTime = function ()
            if settings.retreat_and_return == "fel_rush" or settings.retreat_and_return == "either" and not talent.felblade.enabled then
                return max( 0, cooldown.fel_rush.remains - 1 )
            end
            if settings.retreat_and_return == "felblade" and talent.felblade.enabled then
                return max( 0, cooldown.felblade.remains - 0.4 )
            end
            if settings.retreat_and_return == "either" then
                return max( 0, min( cooldown.felblade.remains, cooldown.fel_rush.remains ) - 1 )
            end
        end,

        handler = function ()

            -- Standard effects/Talents
            applyBuff( "vengeful_retreat_movement" )
            if cooldown.fel_rush.remains < 1 then setCooldown( "fel_rush", 1 ) end
            if talent.vengeful_bonds.enabled then
                applyDebuff( "target", "vengeful_retreat" )
                applyDebuff( "target", "vengeful_retreat_snare" )
            end

            if talent.tactical_retreat.enabled then applyBuff( "tactical_retreat" ) end
            if talent.exergy.enabled then
                applyBuff( "exergy", min( 30, buff.exergy.remains + 20 ) )
            elseif talent.inertia.enabled then -- talent choice node, only 1 or the other
                applyBuff( "inertia_prep_buff" )
            end
            if talent.unbound_chaos.enabled then applyBuff( "unbound_chaos" ) end

            -- Hero Talents
            if talent.unhindered_assault.enabled then setCooldown( "felblade", 0 ) end
            if talent.evasive_action.enabled then
                if buff.evasive_action.down then applyBuff( "evasive_action" )
                else
                    removeBuff( "evasive_action" )
                    setCooldown( "vengeful_retreat", 0 )
                end
            end

            -- PvP
            if pvptalent.glimpse.enabled then applyBuff( "glimpse" ) end
        end,
    }
} )


spec:RegisterRanges( "disrupt", "felblade", "fel_eruption", "torment", "throw_glaive", "the_hunt" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    cycle = false,

    nameplates = true,
    nameplateRange = 10,
    rangeFilter = false,

    damage = true,
    damageExpiration = 8,

    potion = "tempered_potion",

    package = "浩劫Simc",
} )


spec:RegisterSetting( "demon_blades_text", nil, {
    name = function()
        return strformat( "|cFFFF0000警告！|r  如果使用 %s 天赋，来自自动攻击的怒气将被保守地预测，并只在实际获得时更新。"
            .. "这样预测可能会导致怒气消耗突然出现，因此不能保证在下一次近战攻击有足够的怒气。"
            .. "", Hekili:GetSpellLinkWithTexture( 203555 ) )
    end,
    type = "description",
    width = "full"
} )

spec:RegisterSetting( "demon_blades_acknowledged", false, {
    name = function()
        return strformat( "我明白来自 %s 的怒气是不可预测的。", Hekili:GetSpellLinkWithTexture( 203555 ) )
    end,
    desc = function()
        return strformat( "如果勾选，在战斗时 %s 将不会触发警告。", Hekili:GetSpellLinkWithTexture( 203555 ) )
    end,
    type = "toggle",
    width = "full",
    arg = function() return false end,
} )


-- Fel Rush
spec:RegisterSetting( "fel_rush_head", nil, {
    name = Hekili:GetSpellLinkWithTexture( 195072, 20 ),
    type = "header"
} )

spec:RegisterSetting( "fel_rush_warning", nil, {
    name = strformat( "当 %s, %s, 或者 %s 天赋需要使用 %s。如果不希望|W%s|w 被推荐来触发这些天赋的收益，你可能需要考虑使用其他的天赋。"
        .. "\n\n"
        .. "你可以保留|W%s|w的资源，以确保总是留给你可使用的资源，但如果不使用|W%s|w，最终可能会导致损失DPS。"
        .. "", Hekili:GetSpellLinkWithTexture( 388113 ), Hekili:GetSpellLinkWithTexture( 206476 ), Hekili:GetSpellLinkWithTexture( 347461 ),
        Hekili:GetSpellLinkWithTexture( 195072 ), spec.abilities.fel_rush.name, spec.abilities.fel_rush.name, spec.abilities.fel_rush.name ),
    type = "description",
    width = "full",
} )

spec:RegisterSetting( "fel_rush_charges", 0, {
    name = strformat( "储存 %s 资源", Hekili:GetSpellLinkWithTexture( 195072 ) ),
    desc = strformat( "如果设置大于0，当使用 %s 将使你剩余很少的资源，它将不会被推荐。", Hekili:GetSpellLinkWithTexture( 195072 ) ),
    type = "range",
    min = 0,
    max = 2,
    step = 0.1,
    width = "full"
} )

-- Throw Glaive
spec:RegisterSetting( "throw_glaive_head", nil, {
    name = Hekili:GetSpellLinkWithTexture( 185123, 20 ),
    type = "header"
} )

spec:RegisterSetting( "throw_glaive_charges_text", nil, {
    name = strformat( "你可以保留 %s 的层数，以确保它始终对于 %s 或者 |W|T1385910:0::::64:64:4:60:4:60|t |cff71d5ff%s (词缀)|r|w 的触发有效。 "
        .. "如果设置为你的最大层数（使用 %s 时为2层，否则为1层），|W%s|w 将永远不会被推荐。在某些时候不使用 |W%s|w 可能会影响你的DPS。",
        Hekili:GetSpellLinkWithTexture( 185123 ), Hekili:GetSpellLinkWithTexture( 391429 ), GetSpellInfo( 396363 ) or "Thundering", Hekili:GetSpellLinkWithTexture( 389763 ),
        spec.abilities.throw_glaive.name, spec.abilities.throw_glaive.name ),
    type = "description",
    width = "full",
} )

spec:RegisterSetting( "throw_glaive_charges", 0, {
    name = strformat( "保留 %s 的资源", Hekili:GetSpellLinkWithTexture( 185123 ) ),
    desc = strformat( "如果设置为零以上，如果 %s 会减少你的资源，它将不会被推荐。", Hekili:GetSpellLinkWithTexture( 185123 ) ),
    type = "range",
    min = 0,
    max = 2,
    step = 0.1,
    width = "full"
} )

-- Vengeful Retreat
spec:RegisterSetting( "retreat_head", nil, {
    name = Hekili:GetSpellLinkWithTexture( 198793, 20 ),
    type = "header"
} )

spec:RegisterSetting( "retreat_warning", nil, {
    name = strformat( "当 %s, %s, 或者 %s 天赋需要使用 %s。如果不希望|W%s|w 被推荐来触发这些天赋的收益，你可能需要考虑使用其他的天赋。"
        .. "", Hekili:GetSpellLinkWithTexture( 388108 ),Hekili:GetSpellLinkWithTexture( 206476 ),
        Hekili:GetSpellLinkWithTexture( 389688 ), Hekili:GetSpellLinkWithTexture( 198793 ), spec.abilities.vengeful_retreat.name ),
    type = "description",
    width = "full",
} )

spec:RegisterSetting( "retreat_and_return", "off", {
    name = strformat( "%s: %s 和 %s", Hekili:GetSpellLinkWithTexture( 198793 ), Hekili:GetSpellLinkWithTexture( 195072 ), Hekili:GetSpellLinkWithTexture( 232893 ) ),
    desc = function()
        return strformat( "启用后，使用 %s 或 %s 能够快速返回你当前的目标，%s |cFFFF0000才会|r 被推荐。"
            .. "适用于所有|W%s|w 和 |W%s|w 的推荐，无论天赋如何。\n\n"
            .. "如果|W%s|w 没有天赋支撑，将忽略它的冷却时间。\n\n"
            .. "该选项并不保证|W%s|w 和 |W%s|w 会在|W%s|w 后被首先推荐，但会确保其中之一立即可用。",
            Hekili:GetSpellLinkWithTexture( 198793 ), Hekili:GetSpellLinkWithTexture( 195072 ), Hekili:GetSpellLinkWithTexture( 232893 ),
            spec.abilities.fel_rush.name, spec.abilities.vengeful_retreat.name, spec.abilities.felblade.name,
            spec.abilities.fel_rush.name, spec.abilities.felblade.name, spec.abilities.vengeful_retreat.name )
    end,
    type = "select",
    values = {
        off = "禁用（默认）",
        fel_rush = "需要 " .. Hekili:GetSpellLinkWithTexture( 195072 ),
        felblade = "需要 " .. Hekili:GetSpellLinkWithTexture( 232893 ),
        either = "其中之一 " .. Hekili:GetSpellLinkWithTexture( 195072 ) .. " 或 " .. Hekili:GetSpellLinkWithTexture( 232893 )
    },
    width = "full"
} )

spec:RegisterSetting( "retreat_filler", false, {
    name = strformat( "%s：填充和移动", Hekili:GetSpellLinkWithTexture( 198793 ) ),
    desc = function()
        return strformat( "启用后，%s 可被推荐为填充技能或用于运动战。\n\n"
            .. "这种推荐可能发生在有天赋支撑时，其他技能处于冷却，或你在攻击范围之外时。",
            Hekili:GetSpellLinkWithTexture( 198793 ), Hekili:GetSpellLinkWithTexture( 203555 ) )
    end,
    type = "toggle",
    width = "full"
} )

spec:RegisterPack( "浩劫Simc", 20250301, [[Hekili:S3txVnoos(BPXIXTLthps2X90ZG4S4UbyV9gCyFy7f4E4WfzfB5eHyB5rsU7jhm8V9RO(MKvrs9HDNE38YmPLOkwSy9DvK(EN7)h3)5vEj(3)3MypzM9u7PJDM4yFZpF)NtEzV)9FEV3YN9Ee(JDEBH)7F17lHlzp9LnHERyFDC4HOLWB(CW2dB8scc39RrERtU)ZpCiytY)5U7FaFgUb(09(lV)Vn7N(P7)8tbRw5Nnw)yycyJ9A7PxB78lNw85x2T80IVgK8e83bB)1t)2PFlBatUEYhHbmCBWUWil5rcyAu46Gna(5TKHBXJ3h5VmC7dEjxn)h)IxuG3dB8)aBXnpjky3Z(joUXj(rHbRI)Wx82CO85JDg)Kxm8sVKXE7EXD1(4t)MXqDcfuN0kOg9OlaPv(R9oSjzU9hc3ppYp2pb)BJdEmyJB4A31BGpgFmbB3gMT)56DiYJrJZhg8YvbXrh2dq)p9NoT4)5V6)CWMG)3tlwe5N4f9OFc8jjHUEjja3YItlcIpTyxyc8hB3VXFR)Ue)vJzFm81WoIV3Qtl(3peTly3JNw8FhEy3k4dwhgDAbmjbagUiy3Pfa)usqg8pTiEP)oGcegNHdvOggk8Hnb78DxUAUZhYFzW65apYVSY)HdRxp(HS529RSPECK)wVGDXFagtI3gaz5F)G8hUYFlqBEyJhWHoGn)FX3DvOWGVDiWuVzJB20gF3FEQvNq43L9phhe7(qyC)GJZXWXk8JNrB9HOxCF0FhJdd4VkyELNUrdD(HHtg)XrzRixGRoX3A0WH1hB8bykhKUhSfidBdJ2)uyCq84d7Tgn9kNjwwxL(wbUXXXmyo6JzVmHHSl924cKsGzkb(6ro2aDg4U837fbABki4BcItk4T89wcQfEcKcpTa(o)6l6OdWeL(VCzFs2A3lIrVzFGlB8J92SkcGramVEFXps73VoM)7x7VjEPxuK)kM0fGT)B5a80I)opeh7fnxsGpy3s(DHuIrK)UvST2yqHYZ(Jxf(1Dze4h34X2(xV5qu0lajAWYWWnSxpoDdZDL3UL(SN)4YszG52hpwmVJZMYbG86xCzJXb2d9sEYn(R((7LufSpa20pS3DDK3JmjEvQbkfhG1jq8e)0pCi2h0wTMnRGebqdzCH3o)NTRtGKzv934(aqEbZvOCR1E)GHLeJApTGkClB1U17pg9tdgMle5VZFBGF8DZbo9aydSq45QiVGvU(FHbFVvRIhVeKWsoEu8Xb7Qak2BV7NTTQHu8ch5O1XJciZeRJht3QRVgajPbVtaTN7m4DIZP)FWenSeOOlFYlmoNxIr4XyXawgCgSH1zDwfpFccgpGPF)ohXDsVD7cEkitI)SmVI8R)DqD0xa1e5CIJZePJDZa(4nG2lxGnCfWgV8j)LpdQmEYdyLzsdPmYGTQ4u7xzIUVh41)ps)wG5EnyQN9bWFhUhWHOXclx(zRCbZVYQeLjLXtEkkytQLDyYCxh84tjGC9wmE5BUsImzDvfhh77FcyDL(UPmfZvJZ)fF3h892kpUcBqXaDcw)GmciRKeS7faasBrc6zwXyrj0pjnYj4JmhHaXiDKggmFhUAn4fc6)SgWZlD70b5Er4hh7dtS7dWU5ZzBkdrmTLJx3bCL0urhGGKHJvpru28cY0CZzMiYigIlxrnrEWeJys2TGiksDWTG7MjaYOwimXSfbHsxUxXVvZuXYuJDRZSbdr0LFJ0wxPd4X7dss36O5HYFtXU9wVONl5HMp56CPSF)ay0ewzRCtHDSHuJ62ibSOCBQUTrXv0H9caxW5mgGe3ElugWa4AWG5GHVt2kCncmIv47GGtEIzL1LrRTAOuh7f5whXfhNjUh1MvLmPs6rLm4ZOE1DZOxBIMT(lb)byZAWaWSusi7VwiAAbapGChkDow2zQ8frWUGKap2cCaT697a0UM)H3ApE6XJ8pOM6yj1AZRn0bQ9Ub8jWQIljo5Wk4)NkYaugFiy5hRXUWhqBLQ)CNla4uYzlfv)aP3vfBEnBnYF3WQebuIiswbpEKEu3nX2sEgMGmdtmAgKhfmdWRPSdNtFMyxrNHWoJaUGmddh29al(q3uNaRlbLpkikMGhFe8MPYwISqNKvR2RjcSJGfxlM78iUbtODHP8Ma1fWC4RsNrg6jsVK8VgHaw4VALGg7r0QXAowHU5aZHaYQq(0E8mDHDuaTnHHph7U0BNlOlAJKl2oMUXZMKsKx0MB3xS1hwgDvL3ImpDOv(nJM0DhYgEzCAAuicIXvawuFT0qVsIYIyPkNi45YmlbECfhSYFaAMIGPInx1mTwQAzcQ3mYFG0EVqqXgGVQbqpg2nc6Ba6j4B6mL8qIEfq57xQTQABwy24uiRwW5mKWRurdf3uP(KBGAZZWDSGruk0ufB4)kBP1sKrQylJpydmcisoGy2L(xAIP2icRrizuyAvZZRYjbvKWTkTx6mojB7EalXLG3lRdwgKaXfoidaJl(0skblLYltg8os3TeM78G(t83UhCUdrJAh0ykr4L1GjmzthO2V90vv4H0hh5b27YiofgTIskYWq2YsZMdQhuk3DgIJaahh)2Jv72FKM7KNIc)AT80i6QuPlShIccpe7MoEXq4LP6eKrApkvTRWZAoDIgIoT0wP3dzKZ7(Ki7dI9vJStRZndPCkDHjGTiLgtMD8O55Mx0(swj0CFiiruerKHJiCUb8(9rUNQkxl0mcFcw8PqpMvjNu0ZBZDoJTDYJ4sMYlkyild7gDi(PxLljn4UxeeQeGvHrGDKKwX9Lw1lhB7A1IFCTeGoNZEtQEUHkwlZRLBGLVSCdlRqUp5bbDSsryoZDMwlTmCi5XJeAIZ3URlaKrOrZvkirqLySpv5cBnGjNmzRQXX4mscwc6M92fVomABQIhrFlMABveOiOl3nvWkhhlaueyxDdSYsRkIFKYiaURMxo4Pe3YAGykeqPP5zWAg6goWvjVLRmYKHdPYqF5ZNq88P8phnADSuwi44NfnVvtzRiZhFzClZ((GZBibRhLZQvZHatjn3gmj8SBLI(cXcQHFBFi7PYHepDgblb5UNuddeS7lHpdKY)awiGwvx2xzAtduhfXGtwYM2h(vGchSB9H4GALvwgL5xBGIskYbFdhW6FTaygZdSHVPd8)9db737Zecw5(7h893XQLZowRWD8y5lzP8zjRdryEbYyC2gKKUXwoI4N9Iw9c8XpcgG8Pqmws(b3c2MHyYtzM1HkvqfzKSmbV1srjWQWykMzPSCM4mam0XQEiNWZKXg0igxb(gYwAP1cvrSISx)UQ3Z6EUueXB3lw1)qnZSJMzgjoyUz2HFMTgWXeDNZeKk6YpMBPPUkQ2LiujfD5zjiy0sZTTzSQQjM4uBfetUvH(9nfmeCqsmncGl3MrG4LZsLxutyeNgH1ap8AbLWrbu0rfqzJ1jGv79OLibrh(Q0oBdJXccslwzRGsPoxdivhlQZmvjFFMOSdTI(sEJ4nHjLDgCMwu6jOifTIHgqyR0c1Vef7CxZwFKUSyrQDsADpJ5oQc(S3PtWMFaeBy1ZNPGTsDzdSr7ltUO7lismMVVmX89fmTiVtNAs(b0L9f88atTVu0(yK5NlZdxHnGoKKY0(LeRvzs7ljYE21Aa3xK3TFzixBD2PPEvL9)7JAWtUD0K(ncLkwSWPB4i1uzLrLwgZbh6xlolHEF(rwhC5Leg5EypVt2LttzcBfe512ZifdKcvKC6VRneVZKrdhI1t4uTfV94PtVYPtngVHlnGu4c7JbcRTYKBmrbKqBG36H4YNKCHVUELZs)s5i4f1DJ07vOkkeAgpr0(HxIJbc2JE)F(x8jNtyKE2jCfJeS1seajqv85iPRxC9pHOVZvK9rU00E1uvKf5ABHtxe3uuasHsh2usYA(EvkTmho22OUj8Z2Q6(FA3eUro3sQXiTngdYwKcikxTeXAxIapJBypj(HPkLmkrMvHHBnexAc1syv0SQ0AUOhdUxx6QvP61RNo7oBKEwRWK00AvBVUTVYcSv79fMJUZ5tntMIe3SV04MGW5RhIMCjC6gByDNKtrkac9OlXFsTLobd0uK5BStBq0ljDwSwZAqT6o9jIEdu9Y0mWLR7g1cg9YEK0A6AYHoDI1Dk3k4QJl34yw5NJz)wznwKaXvDTnWXBeuDDE2C7XFuFrASP6lnfhfJbKHAmWaCIOuFQIrPQ7lThpRS2jI1eC47WCKpN1Q6aV6wx2llWnJklwFfyyolrDRGyZaIle6iUoMSXOI8oAIMJfq1iNITMKCHov(E(u7b6kJRel2qf0KSSkWpa1b5wI3yynAWskfXjkRwblJQxElRhVvHQ0S3k5JzKe6DFjrow8beSt1z0ugNdcJmfNRWMPonBecYKcPQI1jTR61PhuCqOSqZgptovs15mkWgcQeFZZ0zQKyak99SQSvJBZEKUDD5WAXMcuQlsuY5Dk08jsrMQ68DzO2bErjvCFvum1c9A07wcg0LVKE30UVAITPNW0YoM5gf9qYD6Tsux1rn)MK0clQn3O1uQTeopovYHsinNMyect4InfeVj9XLTsfxxJjmX1Ibx8eFPka8BSiLOezF1XRO6CYOPTUlO9C3SeiBn1YpOMdqLOBEyGtoAyt6oqvn(vrZV(rwzj6Vq6eoe4f4V2gYEsZ04i2(Of8tHhszkWBx5gOLdiIf6gz0jPdGKksS0n3WcgAvExHeBCnMj0UQwjz(M6XJ8t64KqGMCNTQty8TZ4cgnlts4AEAjo1lZnrxstjOlRoIIPA9zOb8nBbOrdHrypI9D8pwObKvyy(ptty7vLgAoXBymD68K7BwtwtqZfv9GBsHkllzxjeZZ6TrK3ulvD4VTnjxjTONOE7upn6O(bWhApr2mQfoaeXhXTPs(aWxvRVSN3zCKqYjSHcEeHehoonvDOvc(fQWNHsuZa)YRUh3S1tJr3ILdpsxImmpwAnb0NPrgLG0jASEkHHzJINvOsHUiAPO7j7nCrd9avlFtrR61laR7uuMxu6ycidxGgAebgJ37leQYW6fg9BhPNbgTLKdFBIMYgjDvkH1emPCynCpZStsQ6uPucmHkJLclPB)mZavNUZaq49OPaCJJWFsnQoQcRIWyh1P0H8arOR2fu1KaFjk3Ev4bsJ3FAvyVWXWsr46A0SqGNsTvJ8EirILRuUkt7vhDcgzK2yffIl6fGjzGzaA6mgqRUdLX84rAxvrQStT(hk3sP6Dk81lv6pq99GceCU7cX((x83C9NlUVr1CBDAyy0RJNB2L1zzmDZNwZtO1SRkv8l2T1XixSBRvC1QEEUy3K2HZAWUBNEvbxesFUCfMM0QRio0(ctyrI4bcNZ1e(BR2n9BNpPSQwn7Yg56sfW3IDWBlfhO7au51xzWK9267UPN1LN4AGIrKXErANtagTjYXlZTZwpEPW097XnTDAqLdcgXaGpp6Qr3DZDQDoqXMbZUlDu0N05xiBcCj91vguzuU6ON1QHbUFqgTonI9yIOyvDNumUx6lNkrbQA7D2kmbyPPOo4xqpQQLr6ArWHDAb3sg4BuCGz5nB20BbL0VQHU9heZgn4Ie4g9lLP9NXeMQFuonq6xHkm0jK83RK6XQrdThp7hYbu9Tm6D9SjtoorwF8iMzfXvJuQLui6Qt3Ho)avr5au9Qc(dZmWrC2gk2def5m)YDPoF6WSER5NSVEQTA8AOPigTPaqAZkRf7Yq2KN8dtJ3D0e7RLyuexGT9kNXa(5rdDu5lyFT27WLFJKCwkzuoj6K5m51dvqRDrIL23b3OpPliXcV(9tDwK8QhXp6uq8nBjPb3pt3pp1IJf7(5rHKv9RLxUj7T7zNseTMFQD8E2zOcl7Ij5PEJfXqnKBnLAB7yPavZT0JMmKs3HWMXNqFLqtLx)Vh4ROUfDAAQHn)UYrfpJuP1ezAOY2iYJfczYYG62zPLN8v5n5dpkEEVjF4NRxr3Kp8i2B3KpVDt(OKLGGrJXx8Vo3KpQiqVDt(0R3KpTrt(3QlXhc2I3UeF(gFj(yW(YBxIpFdUeF43xE7s8XChQ6XlXh9XIIGXsU6oLunytUmGugNkY92tE5pB(zwwrWQ1ItJdesZ6vixueQsVNyuuCFSUK9OoH3drtYqLYm0Ylo1(A5SGQUGNxjWUPVKiPFkgVSvvngOv6wwbbGHdpRdQsphFn4uaC(eJ2PZW(JI1dxGIrJTpwVA4P0lH(ZkRxqMxC73G)20YFxoj41(rF88s8Qs5G6SCO07h1zezNsJ0aRw7MifK)peKeg5mEMU2oiJSJ9o(AkJxYcqRVLYR4iLUTwh1XghxRWvjciOxfTb3qLkvX)i1k18hOu0DhUXxUoWBwaDNxWBNpJU4tshbsPLcxp3LwvEmMw1f2IUaYfUzYHfSVbB7P5hKF1Tmp933XlaGVtoJ)0uwfxzE0ipXzNq5H3VSedk3P0YIxcguX6wCmqmWNncJnn)CZRU3yyxlbdAJdp535bTZ8aoDQyrQgHVH7x5q1BNOaaWBllL5QNruUIQmlcn9uhUReUOCbILPH8uGucK1cxdNgWq8rusJbN1k1XQyIeEhfI5wsf9Ze)9faEGOnOx54nuBIHsbB01(XqJ6KZ9D8LlamlPlbcxXrd7rDA3PIRujZwR6DH0FpEO5sNxv9p1E1kAdKpQwc)kPoEZ1A8DvNDtjdVlz)Xw2jgI1vH6KoR8Ysb5PyiCDjOdsxcIkBMdo1z7qsRc7POQJeUMyBiivfo5T3O303KYefmsjRqjCWJGrvVsRdjW7LqIWu0TEk1VPQhYgPptrOEs0l3xe0wIu7grNUVimXqOHtFtNM)z96oa3LBtVok01rYwg8dcj(wj27)NVFe)WD197r8N4YKyDm)Ljrnxv5QAGC1fqGHatA5ASOSmJRDGO47E)8djnomRxvhE))WRWrBWvtsaJ0rvU4wKqmDa0jkqrYfWT7k6MIuopjxAINwnDln6yGq(LY)166wkIgC8u9TvY4YgtTVqR2uhG(76wHo9QeU5vtEkZQcFjjCuFXH2BcBOjmJwNQ685GNubEgB2XnvJhO4loPGTWBTZ8Djof4gEzFuF2KYSO0KHCmGfZSiDnEi9lv5UUfoUAs6)fXuHm9t0oSMrBmAcft6kv9FqOZel7gEQ1A4LvbLCvXvnI2G7uvybrMb8PLBu0kABPw0wOFPE8YeeWV13uev8vCmbzMxHPu8xgNC3aNBtWK1Xy61kWQxcJceLUAE)Nzn4cmI7)BtSNmZEYKz3)5V6LYThF)N)hp5NgdByeel76WOtlE)6Qo)49NweXA7r21)aed8wySEhsc3YoFNNwauhq)zme27)fWqFAHZVCAXVgUdMV0x)ESnhaIjHeVBS)owGsRGXm05pS0b3AhhabOw)uh0myIF0beap(GA4mjOlvykeEBdHDU6fbyw4BvZGvN39MCzHRuoMfGT07Bi87exhbmpdCDeZuVW1ra7wX1DU4oMrHJf(vlHMLoCBkev3zSLWpFyj0JZOPbPBtLMc8XCwbFtaCUvBvWTAinfRBaWnaS1Boxeqk8AdXvdaklQu2qmhOMX8rpoJMgKwqhH)U1mFTf8nbWu8hOdPPyDdaUbGvjFI0RnexnaOumFF8YO5JEAAdD(ScCTGTNLlPNgTyVELR9lWlb7pPI0WFCgWjlsJHdRPaF72qpRa3aWQNKGpgJW62TrEwbUwW2wtcgI1Tf8AbCB9JYq8UTGVeWFQNjic4DFdEdaSbg2OSw2jGszTKgO9IqUsWBGfhdngRCAiooz4Zf9GnAcBN(LZkWlb7pRhSnskvaR7BWBaGniefkHPobukHjAGQxyYaNiucEdeMm09nLtJPctAgSrty78F5Sc8sW6ylc3oNYgAq63KmvLMJ81HB2e(1GDpYsbEKx8PfF1pcEoW5cqoyhal2WYYg)PfSB31tlE4qsX4sBwS1SQlvF0RwXgmWZ49GxS)VC63oT4A4X7EH1HiO5M)9nkL8ujjfPx5eOgOhXPMLepUASiaEU3rb3P4WLRFMeGlFVo1m42q2cLWQNPW3CMOeeWTvuccy1ZucPOv7SwcciEzW7VlNfPOtUKZsNlnGKZGDMdYHO2zDwbifG5UJDfr36VRPaU6E6vaQvVGeK9zzHUiaRN5xfNMW9(zoEhNzX)9nSZGn4G53O7Q4c8w)DwCXiFLF3fxUGkHLU7W4IDxZ2j(X32joF7evInxgpOCUmUN4qu45(EAUmg6PMMw2eeeH0K33sVVrr2q26lT2k(fokMwzkJewTEv3Nraq20fTawK(53cyr4jzhOAKqS)WUZNFUTahjGvNXrQm00DaFwB7UZvxlrzlSZ6GOamxBplayU31uleDNuqa4oqkqn)arjTmC7dEjVVBMFIQx6O4eWZqVDV4UApwsqrgIAlrr1tLUsGJoevR)8FSJB2QNm6SwRq9Cjr99sFq2NojqysVxwZ9P7c9jSiC9OxwZxexrAbS6td8xMeU0x9MTdvgidpKEeJeHB(JBk4wFikiTsBStvTy(15FPHwBw5V27WMgARHGAMEipCtt2GiUv)vnu7v1HccdMzxRhMbrP8FPa5gn05hgoz8hhbmaElF2fmIL4BnQ8oXuEYXpwMwJMELZelRRYoVnchNN0llJrFm7LjSKVS0Rktoh2pYX2acjGR)4RdCvHn9IeX0monQtfd)LoIans8kjHsi7mzH)TthudHD7uPFM29UW(91jUI3o9ogcRoV792P3PzhGI2c(Ma4g0GCnhRBaWnaSg0Wzn9auyeqF7070eW3ea3GgkR5yDdaUbG1GwhUPmFgb03o9oMcCTGTNLl73dyZzf4LG9TtVJXKKEQX(n4iF0GnYZkW1c22AsWqSUTGxlGBRFugI3Tf8LaUVpEnc4DFdEdaSbg2E707imf6T482P3XaLx99XRraR7BWBaGnieL3o9octHEHP3o9o0aVeSVEp9o5aJibM)(HGLp7VZFv2DEUyHueFTm4FfD4G8IAvN01)9u2fOy2Tcw9z)P1NfYLaw9s6E7ZIelP7OdWIs6U)Qr83QjOdco9Rkpc29o0bvQb8zRzY6fbHZxNQri(2pvn9S15LecZ9G4bLXj(IV1aluxKgGOhAxbNjJgQ4hzm5gaWE80Px50Lwaq)YMODf(gGRv8EN7ZIb1bnO360XEdtFfmlDwvY3dvu(1TtUeWQxS7DbWZZ3Ut)HJ9SSeHgSotjUWWTvu4Vb9ABVa7lqiBDEF6cd3EWBVm43NHz2VrbD2ddKiZs9ScNZUptx2P5cDmzjMMolojgwMuWdN)FEWkq7oot)ObZeLh1EnmtJNJMYKIrQVeVjctUZ5nwTYd2kMLjgbWw84McUorHPonhTfh7FxXVuxHasttNQDY5f6Nl4kG1))S3vwpUrUr4Fl(Lgs2W2QBnJTxGzMGKaeGKh8dr5zDSJKTfSSLGo2CGf63E4r3KfjRd2TAnJxS7t76PPilwSo)yvD3ZZU882Tl9nxQUBZ(1AEF2O6E2gkTkFxcOJicLlenqQP9YmD2N34efa296KTz72VEy2Jl((SVUEZMO5m8H5gB0LrNe(FV8lXGyIV4lXOQFDPx9eHn41c4T0j(ICqCDN9R18(Ct1DZbrUuD3M9R18(ur19BGpXuD)o7xR595MQ72zyUuD3M9R18(ur1eEV7B)nelZI9MFV(doT9RyE0AK8CQfymvQWxsp9xp1pnUKh)0Grg1Y0XaFp)p(7gmI0tvzzynVPrcA6KfNo(LT7NozY6V9xNoX83N(VMob8zNu9p)yP(Vvp7t)ltN84(1QCnwVy6KbQ168CNeC8BTWZZF4EL81OZZlmd8fkINjELZZ)1F98C0pCNN2DE(qZ0yEiCBRx5Mfy)I1lNT6xmsNlxE4nA8)E488BgzNAKr4P0ZZ)GDuEQeH72qgHVUin)8kZZcNb(En2o6pT(ZF54mhHCNsoyuWUn5BvAc7K4wxmd0D6G91Jvt31OoEE(lvRSLK2TF1VO)CCR8wa)eOQjklD5x6OKgIEkX5SL(jFpAAjcZEN4lHSLnyPf93gCZgP8wLeTrgF6KGIMy6XPFSItiMNhzPw0AXiKdNk)3hY96h2ymHknF7OWQHKFFQ3m4YvDK1dClfLQa4KJ4GFyM6cdYrDOGui1PoH(AN1W7CwbczGSFE)9mH80bhtQdICwEljz3SJi0y8eWUTM)RALVjAL3Qg1Hvh9dT5gz0)FBoP(p6Rsz3Uvlr6kb7Q7garReenQW(NWSGZ((IVP()oSB1JRxSzwDmHAY92iY1XrtOLuVXqtZXO1dyPGh6mY0CiEBSuaHyJDOeNsqt0ADeF2fOT6rY4qA8gJGrzTrjMqOTsIJ8gv8df2Jmo7oGNNhTH0HD40wAQuK0wzkTzzEr6g6FE1iktGLJW(n3XFoAxhYVy6uRLsv3kbJiwQeIFhHqmH(cus(fafhr9VSoVOpxLoRI23zlVijFgnVdr5YA3Jo2mfJtXRFpbVo2QtGXIC4Yy0dgtiCHUygls)B2fMkLUy2gusg4qA3Snhtr8C1PZhi1emRyzRsPc6RgpGQswpNdfc6JNF9ATlE78les4qztC4MvQUfMLHKerYyiuhtghPBBxeIUQ0iYdDE(F02OhQKg2S9i4Kwjn8t8sdv)yknGQuCrsdXoJBJ0aLnNKXKH0ax)G2EPbcJDysdvAPHYrKbfZ4q2svjN23R9IFqxcqZoUqfZ(r1F8vPNnpUvLRd(Xw9X(pbZKQMoS5JO5J79jM(c2uxawlB(11qfc3g9viM9zKVW)s6SNc5HzMd)oF5dDQEzxfumxreFoGHqS7XuCUxNnmW2YxwzsW1iXrJNhVeNikjOzb6(8JCy3AtGHh1amIHROs0vrk7S)S)2QnVEIfcd)C94InBMz)hZ0OvAXSSopkiQLzd4JZIAJOG7j45C6)HO40eLZSTxCS5ZA0eZauy44qV(8qr07SMGlyaXXZ)2F67CSpBllZNPEnLH(jTJstOgNmEnOyJzAr4QgTJS4BfSEkFDisNv2vaHAdIEKZ4MNV28LgcdQHNbw3dgXTNroxiRz2(th(cgSgEwdra1zk3Q)HyzCMW6X8luifI1donmnxagBYO3uJxE6dQKyQAwyWplIoO9h2KVcV547sa2FiQRsEbJG1b)djfywjmoMSNbssfzsifzqhm2N98V71vfLpy0Cw709N8HJyqroFLva7ZXFsZMorhE82p9jni0AhMiP6NiKNpJKwQSjFICourVbjXR8Olm1wjXxfygkuMblP8yOr6yOKoAK6ZtxTmy8wIj1mXT97XJLVEsWZRQei21ihGLDQNTWzImsX(g7Qkcqpyd1LCHGtLXd0SdQOR)6kHOC5dUYBrc9Z3jCaPFjorDhFVjjCEfpah0VNI6SBZ2IoSwytMuh5NjwYKMnXCenq7Ls5w7Tyx9tMcXw6m97SOzznZErRIB5EhAfmX7iyDnhNaddpnim8iFGz2IVku0VlHCr5qlWAmr4ML0HQNN4guHvr8AHe7ZF)itOF6lvTD7RbTDRXfLXj31T(6AJUwnDvgTBvY76h)sl8kVgvuFiJjc6q1jYLsPjOvfutK(crTUWLftIepkZptWRhZupkK0gsqpcp7IkEBucX5N0GCMLHbKKFlYIj0wPtrHH1WdltUHXgh5pAvAeS1GJagpwZvaHabPZx3lsJhz1)rxGzXSN0iZkPdXns37owbdroNyEF1jkyxZdZ(0ElrVyJnS03mQmaJt8tpmm5HiZTF7)UgvuZMNoUusmgl0T(5pOmg(DpeDGs6qp7SUH1BMjCxq8Ul2)4IVRyvB3VFLbt0Jq4VyR4rQW(5syaRGuOdJZX4BWSnfdi6ixD7xiQFqdqIa7HgV1LTRHGplIogj46XUgQ5kKgGqHuIlWVKQ5lbH3cUQklc630YLc)aH2xzhzidcnGBJmpaJemvYZC3S9pmCnNTcb3OOKi)D4aeZTpXNcEVq9b8LSWXHaSshWr3iCG1U9l69sXdHdlRzqQvd7ZWXlTmjRmeWoAhqz0os7OMfE51k6dsKjMrIOXQS(lhriYvCJo0EAhqEM6eyc8d71sizciH6TC72Vja4dgHqClBHQD4qNHFBEIOukiqgeilKkeqGIuskENblY3KWaikDzpfb(1cyhLnbLWQJn0WuH7ONNCmqXGveHWdTnHPSBgkSILylD0lGaVYWKaJHxopTe5u2YRv7s9PjQv4jZKkaxk)xSkCGej5y2jUxiE9x9KNVjG0GBqUrncHYMiVuKx8BSZ60OmbVokqLaImptAXDG9au7(5)7Hdl2m7Zl(FGmqXSHawCx(AOkVHdSAu4eQfTM9ZR1fVoCC6QXhn7l5I13Sdv5YTuRRBb4lA7BtWw5B80(AudPeIRFwqik2Zf9jOdHX9FwDc)OzO4Djsu9S8NRbQ(88)PbPAyhayNlS0cL36CG5uKKnqkCor3A27B(vjjj0p1ww6YrnY4QqtkkjImB8DxKroaYd86VVO7yzbphbtoFU2yYRqdZOsRdcL(wAPWkHDEbiJb4D(fdgoTRTNmILosabpCHuqOIpRvHJFz)6nMis1yuyVK0Ll(gNcYngPEYT3WMhNcJd1mAlnJx2uIy8yVL(B9b7W0DGdbJgN2rSVT8a2DxgBRK4xvjgMaq3w6WaeVovl5v)4e7Z4OqExdZqehuKWscGcpcYC0tSs221bi3VpOizZaOJRTK)npBNqEElFTlKYYO6fg2Ihf8DANh7au1ZMDVq6MIXrgxsNdyBnxOGdtbY5(w0WN5pVMawnGhCdCvMlGT2se17CreOaAQkyoSa8xRR3bRHQsR4LSzjr(QzswhxY0B2n(1gvZjxFCtBrxRJaslm2S8Psjyq72a5Q2vbkDItHv1si)5a9F8cEoABWXP43HI4o8dEDKkfQCDj1HK7AVvnOGyobRItrUPFOuoNwTF76Lw6gzevGreePb(mOwg2oXbVyfZQ5DWx)k61hRVWewFMwjdaubFCEr8FS3(k9zdSuWyUbyijha7zGxd3dqDef17kSxTKqRpmPiJMAiPb6OBgIdeXw6eIopN21aaHxckAhfuFKgCLUI(we3VTPwxiULfMTPGzWMkomdWc8Rd(lstY8ulptwAp0WZHW2ArKknD3GuLH0E(j8NLh0UHjfW7S7wPZShqLpda0jdhFnLQUBO01SAWp5vShM0XjF5x9awveMw86fCH)JnfesSjG2XhExfDy45m5fxtWdj24cBi6i7rYS82mubkidOLNqOdCoROVemaEPnUXnX(tFUACJXHrM(hXm25ygLk0Yk6eDgKXHgFBN8hhGzU(chG5acg8AcROJIMZx89yaltHJOFLJ6GNkbK6tUgb6lKOQdxvCHTcit6cMc6Evr34ipESrsKmrh8WeQOJ5765ceEWxJ)7XvFBNkvqdjrhLiI)7XnB8S8a5sfeVuCBImI69clRPOwcmjNKZy5Qkczdy0YWeEgEPYpufUX4wH5yjKhJ)2X1VmXvv(y6ypyoq7T(oiHVoUItyyC36PPKqOBosnp7dmx(54EPtGYna8Io0tnJ7up10BhG9eC2x5ghzSXLrZZjl0Kpowiv9FR1Jfmsaygsymt872Mpz8ZAZN0GYJCRNqKRLpetO8Fq1FkM9zgxQbnAA5KVPbIU3fdSd(GbjpMtgPbtjAbpY0YWfYKJJ2l4Q2qHmMIqFYaxjawFUxI3w7V4vPRlQSmFx9YRBE1UOGwEzazChCTR69Z5iUSnIkYhYVmPmyOuFJZ(cpGrPYpwNJXyB6ozitXRVmqwia2PmHkQj)KHTJ1bYSnUTzAvXoJMcUMurnCl6IcoDnx2a)EkF1Bwn4gomVKzIHjpsmec)XQg03rrCf5D9UBhwFmSgbzmSLcAjZviLJ)j8btkxF7BUnWaPZtBSeQNIXnbie56vHVZNScmkQE)gQe4SyywDXsjzWrWUIdxgNeFfgW5ymVUDanfqf15qjTXk9wGnLsMcUc1sISce2XHS9rj(nY1dqBxI71(ttYj1LeHztMtDq(qYfLuiugvTjiGyBWWw(cpaHu)Vm(lfEHb5GAo60nt9nsRFbxcaxUJmbnehqzCHxeKtgkrwefpRW3pf(0oVj8AnOTWGRNMJO(dzCR55DHajIbJdHgHSPEOJXmJsdHUjJcAKj6y4YhzaububiaFhSO3soL6ra6dmrLIrptLXG7wjpB8T6nPsJgX2tgHx0cMcfK5o6kYDag6wZE(Gwpe8h1dPrXIPqzK9gfiS4Sar7AksF1D)aCbpl9MorY6qQ1pjbbMQ64ADLi4XVYungzyFPD75oDNhPYHcb98N4frEcS30HAIjWBaxRBYCXi)Oc6lZHlMzl84YTxKT3FjDpRQ0nwCAZrh2TUFZ6d7pT7ymdnIFMDdEIxDRUx3zV988)F7D1SCBBde(zjx0WynovHsjtoyPxcFVQQkwPZuNApYQhYf)SxsccGDxS)rjzfNAojhYercqSyXI93VT5Fu36IYM)VgTC2S9Vx)xBE6qOQbcpx2NoaikhkwNHrUxNRu5P9X6OReNgV0NunZ9yEEZB858dDOD9TDtoP8Ah3RckTakGYEy7JZbGOQP927ECZ(UM5qGUDFiar7Ey)Z)rBJCiOEwBswC3DzABrIwM5Mf9ScjBm1DdhNoHktpcfRtrciEoqpAavXDuTJnllYD8T)y79TUATH3O578REZUSoiRLKyw6oLx0lBeL439wPLeYQGCj50LhB9O87LRvE6R5)5RFmiLWLbEDTslm9B1k)28YFtqMhV0qwRmhCyvoMJmECk5QqcS(w80vLXbSUFKTIyXFhVgAhO(opn2mnhBMMJnttHVTXMPzMt(DoAZJJntZXMP5ahtNhAhBMMY0RtQ9jo2mn5IFkHBySzA6GBySzA(Y6F2XMP5LQzAcJj0zOHxkSDLPNEX9g)BVMocXDp2md7pupt3BjhJJPlOE4NXroz(thYQL9cak9QUPh0Pni5aBADKZQYogwNFNk65fa(g4JgNCG4RWKA)54P8MRoRTqgUiMpb0eCWmHeHjZKuSVUVzrTUz782Mlsyme4KtNnlNmnr0hFwzQjs8VEIGdogrpLC22c5z3o7iYoLlnDwxvbTbEiXekig6xTd6RCQhoWpEhiSo7xIEMg7lDQENNhuFUAhgH8PK7cdEfvCCFIUsmdwTckAGhED1Ihv8InH9v5WPWPYs6GHd2N9fiQOcGO1pvCGdlNN)ZZcTemvs8SU5GfLz1NcGqQUzWSvRCcy6cZjjmvLlbChufU7se8kUepvwLOQZrOpMqmRMp2uybcsX)qjEhk5YMCQykzTfDTlgw82brpYEwYS5Qy1mOxAKX8CMObwxdjxml2OSkyf5a(QOJIe217OTYAMYXtiMqTd3Qk8EDJWzR2vUU7Hs3xa1VcaE(iLO0zluuKLIw(szQBnYMoTC4QgpGAWVpcr6okO4pTU3v07POfHv6rfB6Ia9jZH47BTg1U5Wd7x)VSf2Q93ypBYjNsvT5cvkZQ0BHksjv1SpmFEclY6(7foTQSPwOKkPgTtST5e2(M9kDJF9BaMQjPDdJucnWOjqWeAo0jsXxDeCvgkdZ426l8xgTRDyyRk7xhlNPIOjJlROZbVumvlQ4Px1azV7ybItDb3RksR3P06i6iQpkwsk3UDEwykfaJ69xMMs1U1rD(8XzPc9rXv1s8GuX3AbPyHO65ptReoi(NAyNHM90y(cbJM0lGAoyJILNJQ9OnQjPZCoFgVAI564qwQ4a(WzMHuJyBac36PahhqBjSXil9kW8c7T3PBDcTN8p1n5jg7IpxO2e95ezEOaQse(jaCbrE2ClfV9K0xq7y0gTMSGsZLZSxblhgXuYISnxrVg2GiclvkhMJ68ubMUOI6OXvWIzI6iC2I94xMj6)kL6JXApDrGlT(N7Mkv1rf4SCWliOzmLlQjwpai5Xqx(kQgJfz8kwAY1gVY8qQ2UI2w5kWAXfEnrC3tNnKksXtgr(cGxNW(dssYRjihzI0zud8rxv6WpQXTsVZxf8PhSlxOArCTKj2cVgftIuIOb8qbnyOcdyIBN4G9GvUq7k11FhnObRK79wJPhfTTny5ZLWuSRpH3ZR0wuLQJny5vCrQEoYZCQiLHiWicLEfL1q97zVtgwIT5s(PMhPee6SC8RQy8HgBhgL(uqCri5Onar5sbFwvVyzVs5WRuOiwNS7VU0ZJw0czuee06BPpWKgp2Maf34zFYOaFtxcUkMwrSSDS8(fi6J4HBKNElFEI)TpTmcr0DHMYZ0oyiex88)TfVWkYBIijMmMVNq6K0byjQs25poqpTGS2xYd893UyiRuzwN46wUvAWXc2nnefuoD4lBIviCmQpbrLUGsP9b)z(L(QkGnE4)xb0nRYYr)AlYj2KlpY0UPOqpn5jCDQSyyvS16SNAu6kuB9T74oEfcAjrxm)M(u(Yptb1wYAryiNPSvp3K3kxIL(dju2lYfmnsjB2kXHRBnMvBxvqxKep1tWCVIXFYos2SFL5qLJoIrAsLg8DfXL1nR6NPeBhWyhRyBtUWJqg4zxeNs8F0qon5CV)O6go1G9WJvBPcL5y62hyzqAj37Bwyxl9n0rgunkgSDq98r7pXw(Nr(WIWUQeJqZtrM(PsJ4dGpeTJIllWcHbAAivXjSp3iMDvg7kdCEcG1n9hkCK9uGVMTT)JV3M2FDT6lxYVOgiyqLHpAraiAfBmLX9V6bVw29tow9oXXVZkwbIeYjC46MuBkZ6cRiV71ybDUzjtJVKJiMCmdMhVWQKJhkHb2AkyGK0Poxbxnep2BOgRCitLn5Ywf0bJzFkx6ByyZByqJtjQ2vCQgKvmHnMQCI0IXcOZIHFRWJ7tY3(wQ(oVvaHaxZUBJcTLwiH7MWF1A9jkCRCkkbdrmgnnvIK9))w8qBA8N3Sp2qiE47)5MdCHf1oblpGlP)M76AoQ(p)y9xF8jy2wgl79uZhKlGNdy2Q9mB1OzJl5r3FN48fhR9FBDZ7NqkXBNLCnEHsDHuEcF0ebfJubtK9IWF(9)l]] )
