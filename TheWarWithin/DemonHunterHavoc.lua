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
    inertia = {
        id = 427641,
        duration = 5,
        max_stack = 1,
    },
    -- https://www.wowhead.com/spell=1215159
    -- Inertia Your next Fel Rush or Felblade increases your damage by 18% for 5 sec.
    inertia_trigger = {
        id = 1215159,
        duration = 12,
        max_stack = 1,
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
        duration = 20,
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
                -- bugs: Thrill of the Fight doesn't apply without Fury of the Aldrachi and (maybe) Reaver's Mark.
                if talent.thrill_of_the_fight.enabled and talent.reavers_mark.enabled and buff.rending_strike.down then
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
                removeBuff( "rending_strike" )
                -- Fun fact: Reaver's Mark's Blade Dance -> Chaos Strike -> 2 stacks doesn't work without Fury of the Aldrachi talented (note that Blade Dance doesn't light up as empowered in-game).
                local danced = talent.fury_of_the_aldrachi.enabled and buff.glaive_flurry.down
                applyDebuff( "target", "reavers_mark", nil, danced and 2 or 1 )

                if talent.thrill_of_the_fight.enabled and danced then
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
            if buff.inertia_trigger.up then
                removeBuff( "inertia_trigger" )
                applyBuff( "inertia" )
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
            if buff.inertia_trigger.up then
                removeBuff( "inertia_trigger" )
                applyBuff( "inertia" )
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
                applyBuff( "inertia_trigger" )
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
                applyBuff( "inertia_trigger" )
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

spec:RegisterPack( "浩劫Simc", 20250407, [[Hekili:S3ZAZTXXr(BrvQaJLuecybHKSpbMYpoFX(8PKl0j3hUkCXsGfK7raSi7drZuSWV9RNzFnp6EMzbaPKDuLQIfXoB390t)A6PNEVA0v)8vxUimp6Q37p0FYWZh(Mb(dh9w)ZV6Y8h2gD1LBdNFx4nW)yt4A4))pg(HK5SF9HvjHlyVDwsr6C4jxgVUyvyECYMVnnCz(vxEDr8Q8FyZvxJJbF4v3gn)Q3p5nV5QlVnEXIOYXgLbiGn2ZgE(zdF9xTB23Vk6x2n7pTnAtuA2UFC3pw(0XNn6C4Px(WM57MDFC(TW)oE93koGHJmoa)Z8zWV)64njPE6JeMOPjlJxbtVF3VB3SBZZ3M9vV6v3adO46bZtw)QSMz9C2SM93ZF11RsU(v53gDFykdwXBE1xpNnK)CACsAC(d)uCwE2RweTozZTfBYJsdULXwhWE5D)idt)1T7MLNSBgJXjsqaX(FfMoh(RVC3m2Cy3SZG)9OLJ8NeYMxHCeLnyBAeqExhMF60x9HW04WRxf9s2s40804n3fLpkidqCs8ISx(HWvfn)(GrdIZgeVgM4FiolArqwu4sGQlwhaIcrRdVlkTdOXNcn(UGgGt8nRabWvadB3m45axP89Zk5p3MSArZVTB28e4VtUFtw1G)HnX5XWQZhaMy4gyKVpAEuwwy6da7eER7GFFv8MOZka(DsrEw8c4xYYHXgMkcyGqxfToAtoFPUdZ)rbZHvCmw86Wfb)JIOOnzbRz4lp6XhLgW)xXM7whgLLNMadj6MqyC3Sjkxzy3efMEd8dlaDJGSTHPrb3f9qMYOsd)q0MKISGBt2e9qW1f)Z)zuQkKsJxhmpzbOS5(e0hBc6BBc672e03PjOVdtq)UpbtVjaKAxeTmSyv(0HVmz700OmqAa9DZIVjEvqYYGLRGxgFmXRxNuASiiSivuFfE4I4S0IT5L6))V)XO7Ixf)33nBwAuom)JYHxjpjimph0hMbsKGm(MerrZOfdyVm82GvROqq89Bks3eV5MDZ(Fsk2SOwPaqsmqHZI3SBgy8kpUe(GC)8OnahijRKgAjnms4Lm9MG5lMo6LvpmE5uWo6xTi66ILlhCDjUdUNH6bPGgD8MSxcJjpCfqSYpVx1pYnjgC9QqWjqpg()quWIeLb)U(GFJvRckrB2f)HXEheb)IY)eeqcUoj74qJtrPrWtwbZ0ZnmhzG(aSeTfmZnlderaRtccdYsIlH3kaEjMiiiawRSPtpN0F0VVV)GxFs5ugCRawF9oPFFXXMva0up(I0AGpTojD7TjzG6rXwVtgF6iFpVt5pvrCDqgdMN86YhMZi25HRcaEniTLdV9jJgYNK)CmBsnEmy)mUC6XmnFB087KTHxA7TyBwPhUmzZZHGDLLXZJOzlmOpECW5BJHxRIP0VKYBS7dK1Jp(IQPF7p71RCGBQryqwn(kFdGMbPHnfzde9JZ8sLbSdFaPZlxr)UKcGGaVhG2urwKWKJ5BIR9vQ1LX)3HC3lcUQeEbUhQWncWAriyruaMKSIfCQiain49QyfVi6FueVDlywaSnbMvzgNGjtWwwuip0R9X3cMnJypDo40dSR2xYRG6tLEigK961oK6zzTbGl8hkaFFtW33o89XGpFv5VYxjybqfbHFaA5m7Dlb5moZeCvKMX0(IGvvMeAc8i4Fb)dEmMmbticTbTwXdt1y58HUOIxVmCfGrgMVmc8qXJAR8D5qQsgikKf5gGXegvejjANwaAz8)kG9kL4im9LG3X455GrlWSe7ndyV4GWvlsbGfdAFSjtLtJlFaeH)78qc)(WvRUoSrJBBuYwMu6QOpaMLysI2q9Ymju)cd4M9)a0)1v)(Uz)LQh0Y9MQ5AnEZCzZzC9X0OnmDMGmEWzdylTLwQUzviZq7YvfPPpaQO9Aw55w(cweUHR627M5nEBMcYA14Dqjk7bEg)qaBmJaJHH53gKDFu0wnNUBJbRNfBdwMgEdZ3QjhUnoEkLsuF1xwkEVKH1sEjZC(7M(LdnkETmAvW1HPaqIqn7l88E9Bygc)Anx4DSz76WF5K30RFL7kqWDDCu2ftbxgXPqW3vUPonnmEraiIaWpCXImq9c2EYJpQ(ZXBAbk2tV4lh6jquYEzQiRhFuHy89E8r(sT4CaCj17fkK90r9EHkoJ(fMAMNchD(THqKLLYsmgpMigiYGlG1xu0zr2uFekUhlsQlgPUsgUzt8TXLUoFsWRQ86Fb8RZ2JtLK4GsnZSGsGpyfegaZXWIzn(HZVL5eIPnWfKB8pvQ6(fGS()b)DbH7L5mlIcMhvTlkJTMjS8mRvvMuhp)204vRQn2Vm(MBZdk9aQjlF(PASjVtBL4yVpBN1AV3yweoTJl6HOGRJcxRpU6O9Ya(em)bDeqxjpEZdaa0wIuSZSGjIsyFsBK(4JSIGQJtXaRHhUcUzn4bk2)86jll9UX9QIxhcdkcqCW1WQ5DLlkLOomTX)BL4epoWlgxPUIQDFbi1sZLhbmSY5q7VOQ7(mkuD(tmtMXmSXkvzhQwYa35yHhe0egPIfH3NW3Bb48FntEc88dBTPCpFzXRZy2bc3Ctz4PPjRbf)c4rLPPA3SFINVfw8tFlGy5F)FRYgc)D)2VJNiMBUzfpnvSXEB0QT7MDhZR6S5aOl46rUoFkTWW3dgyA9DJM0Re6nr6L1dr9LT8q4UH9OkDzjr8w1ozjFWJJcT2SZ(STX5CjrdQm1B1Ow8DDy6DngWzBtu8bxa6bvWs8NBuIM6Fwf4Gq1NFhlEZao1O5PJi6XaXOiacVrqvm6bvFPfBvaUY(azasvaV2CjdGlHqkAzecysyncjoLlsJazsioKa2kVNv7sYlZShy0G0evw2(mR0zvA)uJk8eQhDXe65MEG8)LO7tsVtkhNGLo(8OudT8XLPiMhgexXKXeYd57mfmjwmpVinsnEZOnW0QOzh86bQQTTzmDV6zfmHfI9(Ddhaw1K)bbxDAUeMkm0EMJCeI3cCl2A0nxnH290EwBwOf8)Q)E17RmF0GBdzbogcRCBEiyXwTNvtI96l8a1DJ2gor72Arg2fJh6Ptx(i0L)(qx67sUd0vviU(dB1OHntNcYdLUxl2CnlFxb8qTf1cRgfSLX4BUbIzS1JSUI7r0AwBYEKYth2MMq2SbHfk2UqiiDfkhElog5BzwHFPTlgegy9UcKsGLbtHDNQqxCaCOqSg0uhoyITn3vdTvjj3bYKHBcGWswPTrMrUUWZqsdXR6F)WNSIdRKVAkMCw8I0MbNqZ6UazbVz3WwmncARTaw1YT2qpDK2weFFclNuST99YAVfBttMNb)1djfGBfwIh5hdalTrNLNCwz6J(Hg3KqyGGFYmEcSQppng8yBweCkblg5atTg489lcHA(vThB693F)aMpXRtYZQp8u4FdH6Vnjn)vl8NpEt8)5hwC5F7HV76)7fzHFxw638Q2df1M776ig1u0QwUddyoXHi0zhZxp0C87M(egUDgfW6gBHtiwNgZX(96JKmf9xqtrsjpoDpuhfaCeZuec57a5PSDOjgvivdt75miQATvgr33OvdKmLX8R85azCMUoSazG4sGTa3ZYgTfw5ylP02YN2MQiQeqSxzJKAZN8JvgrZDCZwiX2nbPNrwoOHqKwgppo)IPNp802GPQoSXty(5FbHhufixLvM8O1BJa326u5by)qpxik8r0PVgjMFBAY9cztsnuKMqelsJzLraF8zTr9MnhG7A2s11PfWVfN)a40MBuJNJweZ6Mmhylv10cEnoly4m9HlERk)rCzwZv4lqDu5QeeILANS4BZHLwcZSQfWP3KcE(0sdHWHkJBZHmZ4Ecj8NOs3UF0dLN0EW1X5QEmufej2gvpczjv5bttzAHO32i7YoNko5fU6IrdgoQANo6SwvfgDPUG0ISB)KCkzH2dtHOFbQkjfmhNVxIx8Z0B0WHI1GNq6zbKifvjpCH(gMntzhuELe78hMVIFc5qW2GsJHnymD0yVwjDjYKWnrZwBfvakz1iA2NZo9EQ0A9229Elam9KH71ooMSrE8CWXs4MmEUQzCoup1Gl869PbEJc46xA5CnlFfm9cklQsJXmEHqKd4513ZRN6o4rzScNguzjbaRB8tfuoJJMffmgEB)(uN8qZV7t87JL)D09pJTPhL4R8OL56Q4wJuT(jR9RhbX(esIurc2IifzuAHpajYsF4hJH3Ei(TnH9RCZCitpWPhwc2zRCKwqAogCLYOiEZhsUd44)cmvbRXbSx31sPqKIXGtzYH2MCpSgeVzzrwSWHTRt7it1P(dPyrY1IbRo1Jb0wTfd56XOPmQWQ31MhYYtZCwn0WcTKjKTooNV(3wKw3fMU4b4LVb8Ej(Qy1aLWJPRI2MHqwbTT0ol5nPbRsMF3gyxzRUt4zevwBl0rQQwzUj7GfGaHwxYn15tLEd1RsVMujlvnFCHTjEOhduTjGjO26yKJxp5YBtNA6juFAnM9waH7YMA8ZUg551iM94x0(C2oz5ecSlxpLABZeMhzbZi7XvcZJKXSNSK)fJyrxGUDyLFGMfB4a6upn7jUjxqOIWtLUBkzM5O4SCdCuPzH9fpdsfsqYtH)a7ZWngKSfcUsJzgJkAulUsj4ThCIrgGInUaQSSnTmHNJEImY76NMtkxZPYrGjvubO4apvs0otuwfrmN3K9AKZzt(80QqpACCvNu3brDuEtyuyBI9el86En)SuriRAeWvcGWx1Zh(B8MThO0AggPXlQxwUKjbn0xsSOm(ZwHyjJY1HQBWInAq8EQolrjYNl)LwqUnZiFc4YeXXOsaZl41ynMBWG8WmJ37hQyNTasZjBC0etNm5K91ut2QK8MBixz0F0yP(4pvtIdL1z0nmAqk5m2KKCVKEKIi4t(jS0gifZHAO16NQt5Leu59u8Rk)qIvuXttsztlg1c9hsUzr01m)N11meZkUVM53X1mFhxZ8vwZWIOs(HhYAg6nPr7m()E2v9yzb)yklps(frL8RxUB2x)N)PDZsJ(qmBJYzTvaEYIcw9HEDuoVoVtJYkwLx(8nnLfo)08BkpZAtnL3tMYQk9R)t)7c3GqJwKQRoBYdVP0z2rPuk5fUl5DxXRN0BuvuULOFF3Dzx3gB5)9yuEvEMy6FkwfRMxAAK4rZjQHSEjzktidGA51P6EyMKguSvoPon4U(W0uTSj4wu(WPuhO7eZ8fbahiw5wE2KNAFdqc9cNiMEsLngj)2I1Wa)n1tbRQDCKkHf9WBpxXXIcIff9OXU9n6jdwH8OscudVoYHCQo)9jUQsgoqhPZ(60XMyl6NMooFrDrXaivkRHUYswkx4L8ZDE0WHOET)YHMUWy0ETpxp)8MPiRv5hYsKbiQFgZs1iX5d7i80Oq53SNc0DxEM9IN1y(RXSXzJNCXqKQAT2E0yHkZr0Wxtzei886Aa5IrVTBcQK02WNBAtrI)thMM(HnFyYzIrtXjkachXY37TgTGR64HInF(qEjK)CYNvROglKMOhFvYRNPhYZaqLbru3c0t7t0MtNro0X(ExyCPqQItKghZ1jHBrJN6l5b(9RP9DGm5BAeitAY7QyfMkkt3gVjE(HB(v9dCeTwbisqNYLoRMO3RBOdvGXceRaZOEcA9(AtEo)MZ5i76c8ABdIDJEmWl71fwPiEjkyetBSOTe6hoysZIOYP27u5qCq7JtxwqmCcmmGe)JnoeXLuwLtCIVLlKv7ihJr5Ar5ZTwoD8WE2QBhnbH(gM5dK70l8FZ8MiBOBmQgDlv7J5YAbdtp8DSAT1eP2iTiULoARj0SqBIwuYskmEB2kOZm4uUELnrt5bHU2nzWe9eRiUKuBzt)6a8TjRVM3sy8b3wrRaNpfz3w2nIYiyqY12ODguFBMt12SZJpA((d0wV5DfYO2tq2LBt1mRTZs3kqyJQokIU2ZDS4efvJWIrPgWGo91mkvF8RCI1EtdOP(bp3q5ZDHDtOI6QiULBV8xkM6CAoXn0kfCRrblcnoEIni8IPwIK6hwns5eRGyHASxTKanC4txCU3H1vfqImeLPkKCml3dt1anWaN(wMDPyNnvaR13dGxZQlXJ3((u6ih10V17JIF3SvOwn81scjfRYMhMsCRmC3(eWepK7OHYXZYiRMg7uMZNglHDrZM3QwuF8rzKoipb4jxm0uZo4DtK2XAzcSXTzSN00rb3e3QdCtPtiUxc2cOrn5kUCJMOjqlwaCI6q88I)Yk3xcdUm)d0mUJQrbl3LtmHkBXt9r7oHqWZvnTG7YGkvlL5P406ASg)zIzSJtfyN)i)bDOBhHJQ9jdc88fGgwdlUnJo8L3g7ES9BLwiYi8zvx6VAgcLJMTT0qBCO6pLIfcBt(DTvoil49UP(KKwJUZhhs7ccktDvPH4Aw)1fimTjwCSOfKRCDWHMeaCrzNsnWZ2zH7zxsKWZL6wpTLvf3twWHW4SpDCmlwi15ikzzQJrTh6wpJuxF9aMAI4sv1ZbXehPClRTObt4yS9OE6WVur9ilaeYoWyRcU2JOH2Jp2(iGzX2Bb8EeLRdHloSY3X(Yb)MHwFQEy(j7ktnvRZiIzXzFGSBDOahDhGvYbAn7u3a1b1Vvqe7O5asJJyhjwSa2UXCI4FOUVQK3fqB11nv1BJpf1leSJJloZ1)Ifdle0QwLjPVoAO9xqX)nVhxmwPRNBhDukUKbUEVaZgvpARDOcNgYzMLfb8Pcv(XqJ7JceOndbHTPivjCLhCzZNuKIOQgm(3hT6SllzkwBy3oMCMLztDRFD32RuglKfXLS2NoEVmDzMqVz1TXxYo4w3(y17tR811(DIOmxQVB8P1cH5flG)l3(bmYOuWq7PygJ9uM1irO4Y(uu3IJwKCnNjigLrFoTN1yL(DyTRIgRb01NQ(8tn2XdF(DX4N0PN6CG4dbGRTFpom2Nmo880vrTCIC8BdKlMPpzSNqCJyRlwloyRU0fp8DNeaWXJTdA9IPJeAwcyyWADHWzBgQI7QlLOIuIEMvDAwIVaZ3MUf(z7ANttiNKd8v1FedxX57bqdQu1CewKgAWeVNLJ3dVVZz9UkYNqkXWtRM2iUEUHIgt2lyx7Ix83QJ7eioJnAiIjiY6hAoljMih3AOENI0(m0GBnLJAaPLQ1F4Gj)(kajUUrV0xIS2edu)kSYtsnXpQZgTmHzqr1MLcpBzgWaNdi1tRLpCZDgXvQOEnqvVtvwY(QitoTFzDi9MHNnEOz6QVRegTHFqLZRS4olj28BJs4Bb(e)HNPjOOob33(UMdYZN0FKPy7owZ9dOdWPPNXzJ6NCdDcw(KHly1liXuJElUM8DVV98o3)E7OoHupn)F9C4EAXWJe1mheF0MswO9NOEyNW2yXspMLwyxxBoy)kQfG1TC75wgdpc9Iodo4v2zFGy5MXin3ALy2eimnrrVuTshbiz1u7M8dDZLJk)))QrEJQLZ11Kj3HglNbzP(2eMOYnjYpRSTQ6PQaWLUrgCr19rw1ABVJGKD8sWCan7oz68zOz3jJq5SV(5MDNwtMHIX95(A3N7RD2Ll(CFTZcd6Z91UU0x7mYjpc9woRXOPFKry9ak0m)UF9DoDJLUbtdTsomq6CR4AFCQ)rTlCrWK(xPUWLXUPfIrVNV2TLdlo)wVDBzSTzzAX5jRVAHV44yJRQAvW9cNrS9G3(GFJ1CQSNBcekgFRmJjTT1LUCvZkpAMkCQ)svD24tpETwbP9TlbcnSkoDxKKS22POYXNWUQLEzB5g085J0hnzueHmulOoE4z6jn38PHFQIyO9tqJ)QyY4EThjfTD1MdCIfxerg3ODBlFUTgaUCE0pOU)WnQflHchJMAVrSuj48lLV7iLLc006EFf(t51grdsWpQq753rtwvlxLuTMbWufwI(0Z(jAoLokM5iszPfTbwHy4Iwq1FOOjCYObtSvtkLSDSNjxhc4NWf4nWZydoZymQIKo24KkKYwvaf7QOLhjQwPj5hTQ2x(6OJU6in(M5bEz3A9MPpDc9zvQTJmTPs41pKLbXYCt4)mQChBycTMphu66nOossjQG9oylpDVhzy(UJq)(hyV1G2AHrZcm1c67NqflAJWLzYBFULnUWz7Jk6BH4jUjqM0IFkB(cTZU94sn5qyCeoBi8hqYcSvpvSgpsV9jGNQUAY(5EaNpvpjntWNl9bB28Yjkaa62d)RoGit5uQZEtPq5oGUQYZQuG6z3rEfIAaI613YbbIxJYACPdQyAjZjn8dujwAkvx(BYDBe8nO2H6Ru2rTlokv8rl8zAL6EH(K0Asif40ZqJfULHVN4mSWNceHIJUThZhIb1(knkSTxL6c)dCiTu602td2CuTQ(aL3vlrCLuTGbH79GXleTksz98Wc(hhwwrOAt7SnkldSN6HivuPJqkQuuDZkWzobiAwvy)kQ5iHqo3dqAA7KV7C7U(8BsuWjgffAGd(oymvi92ic8spLyBk2Mpn23mvYHNyptrOrsCu6zn0EImhgXb1ZACXrOJOVRO53QTKf8qU7Jp3k5FDOa29COz6GVuI98F79Drgpu3Fns)en8ML13zXPc1wLwihIbEv)ZiWqriTzowFOldeUTCYx2JQBypomfpZg54)Wp5J9HwDjbmAx29PJWpPF6efyi5c4(DvdtrlNNKtTo3gmi3dKEiVw7hlFSM3A7ObNoTxefhxYAFohGJxpCIo9QeH5jOpv6vr(ijgzUN8E0u2qtygTnvZ5ZbpPcYc2S7ISLiqXNCAB2cVuFRwLKmGBSVYGJnTmlQHmKBbUAMfPpJhY4snUQ7HtRUK(Fvkvjt)eLhTB8gNqOAsxPo)he(mX0UJxYXo2UtO0RQ7tnw3CNPdwqvyahTsJI2q7EAfDpSViUFzcg4h7(msRCLKqqP7vaLkcndQcdC6qcHSdCp9wvyTRHrbcHqnrDhAUxHC1LSQLbERREV)q)jdpF4BU6Y7d5QizxD5pZ(GsaB8njf2a8s23TIVyzBfK8fSVdf)Jc2wX2bBCEn7JprrEYA2DiE3mGLcgDzFJj(Pyw3dFYxXAL4Ba8XF8xyPMYaGNNimSC6X1F0V4zfni1PLgkWhZtk47cGRugmb32H0vQUda3bWkwwBiGu5XosRoauwWESH4oqDt4JECoHgKk4er(EVf(2xW3fatjFGoKUs1Da4oawJYjAp2rA1bGsj896NhlF0OzF4ZpPa3kypY6L0OXk1B346Xf4nG9nMynY1amoBrBmsunf43Vf0NuG7ayTZsWhJtu9(Tq(KcCRGDFDj4ivVVG3kG334OCKU3xW3a4rJoYCefc)OdFxGSd(2OCyEyqLYJPbOEu00ndFh874OlzZ4H4QyGJm6b7gg3p7mpTqVfU(2HBN0xvP7Jn8DbYoSDfsTQdcQKAv0q1UwLdHuyg(oOv5y0CMXJRAvwgSByC)cO5Pf6aC55TzzYQvj3Z)WGYYXv2Uz3hX(KJcIhlk)AGw(9cLN1O6psOxxKxpoEvpSKLMuXrVybBWWYs41HzrF1UFK)nIdegzh1jA(I(IoLMivMrY2QpoQzLuXx0XJD3HB9sN6BCdI2WWME3WtRI5Qh5N49rUMjudSS1p5QfcDBL4vFEL4PBLyaHw320O5jRVomVJkFMcxbWqAYhIZyFeoIcb8exSoyl4hyD4DurTy9DKmeA0UUvqHyE367iH(XppbfAenu3SFCKzy0UJsIl(pogPhS7ieTRXGJoQH6oYaIDDW8Kfr)cXes85sG98NNOzmIgNfhSnA3rPRIdwgS7i0nXbJd1DKzqCq)5vGf1cl43lSyvhTVAl2MkNd8t1lG7amR2PWj9h9777p41NeMZQe4aiq)8iVtAUmXcfJDTBe0Zj27KXNoY3Z70YdQu5Cq5vz8jVU8H5mhRZdB9sxS9KrdB4BgP1x9PbTAvOGBd42KYIekyoS9gcdFAJXjzUYCrG0NzWrcXiDev7ZMfEsbUvW67a3hFmor1(oZ9nnshrLvgK90RCCboLLRW0pFc(hrW3fa3HvVUt1Da4oawhYZuxpevNa6Npb)Ua(Ua4oy4U7uDhaUdG1HJoORcFob0pFc(UcCRG9iRxECpK9NuG3a2pFc(oZsosNRNdh7BhwiFsbUvWUVUeCKQ3xWBfW7BCuos37l4Ba8ON1CtrIT9DE8ud)ob5oiVVh0DhGUlW1HGpjpp2dcQKNhlnuDws090IzqU3UKIdgAo6WVtqUdoJ2d6Udq3f46qKODws0jOskj6qEF60A3tn8DbYoWpi5Yheu3dUmlgy1(SpUxhSH1bSC4Xyzg(Uw9fDQMMoU5f7Pf6TW1Hu20jpZQ09Xg(Uazh82rQtDqqLuNYCEHSQtroSoGLdFRCMHVR6uDQIMoU505Pf6d(eRIM4n6HVOt5oF0BL5iAh93tFBgPMtFGy6voGPbKh9qh5Au2MXLbDrq6JgGpu3jpvuSpveL)keWhip(jGI39J)axdGbUrJKTnXKZV6s()6QF(QlfUzTWF((rSFR64XV6BU6Y5PXGD84WRUSpyTf0vQXMAbNTB2ftH5YWDZ6Xh4lakf52txF077M94JG5pIpBxZ84GH)q1p8B1iqVplbKWUzNpSe0iJOLs3n7TLJQLkfrtdnwsgYv6h)195ptgc4FS4KNWSoLphMsn4VDZE3UzJhknT1Um3A8vL2LqlI6jSmHD96ztGkZP7MDcG5sAd)JrhNOkPRwuhlxHJkpLybVK(jRfYkgeBUt0QikzdE1qsP7)x((SMQcFcoAcm0RUSuY)QlLkYJRYV69(Me0nZ(krpNs16LcsmFDDKJHUbFAwvpNQD8szqG1Bm(xCDR(hU6LDDLgurPUiSesib45O(sFxuz6rkT2OYHwEXCExJLczgOXEKKet4W0thtQNAA9Ec5uREwtOE1sjLTlngjCUcjKaJklkVDO1Zq2)AfR9wy4lJwj2T9zyuzuY7Jt9HifqKYqOkrtLHruxLkJsBFRkphnVWCMuaRDGa8o5V0pmw8efwCJ4Gg)tpKer3snT1kzldLA8IFjXKfcNOkDtOououcjlf3tcHOHEwZAJdj7iCH5rvwDnemzPM0WwRM4PXOXWQsIiStBizdfN20JhLK2gPtBEy6ZSx3FOvB8Jgs8atlOLiKU9CXrQoiNC1LLIYiYNG08RjKMju2ffPFHOIMnJhoTWrVaBBrtzE7SGJnbvf46HYLzbc0WMPyCaV(ne8AztMkwnCHlJrpymbvBZhiJfjx47dtLsP0zllAd0JooI6LjfEoS68wQvheFwIRrLwMFh(gkrdNsmPq1BHumajlrQJgLTbRn(nCKgNi(dB4dyZoGB8LeCdk3Zsr7O5dRgBKVnGXrdjqjHRE3Wi1lZqOAceAT9XLXg1Pukig(j(MfgzmqpplBOXSgYzLrNYGVLT74z37Mn5PjI7Y2MXaTXqyjwBCKHB2OJr99y0Tyq4QfGcWQKCHLCMCH6(TvKl8)0uUa1G4bjxOgr2Ejxq54rBmoixy68B6UCbHhpm5cFUCb9(7mevwjvvTSR(n8KJWkpB4FlpBxvQ3QVWJv2cU07l899SMiowBx4yUlgXFXQZZ65OEBCx3XQuhf19KuyA2Bu(Fkl1nc2kQ6t4Cbh1DL7QGJl52RtPSq(7z6vmQ7YLzyjtFrugqLBlFTVpA1zxwMtUwynpC1QGY)iGLI(RU8)N9UwAUnYnc)BrxMI0QKwYrsR3uLetLu5sUShIsUkkUu02SSmPYqY44l63EWJby6gOFGzKKT2S6YwA9aoaOrJ(Xx)yS)3w)MHq1lIGz06PPEgG9B)4hVVRQ2JBZCjSbEQ4tObprfOxndRWii5lQopYnpE7XX3Vu5QdhhQBRcUaxoD135sLXBQDYW3tuUg1ANP81Vu1xw2(6WzurKIkrTLNGH7V2pdeRwK3dc3Pbe2qltGcNSFaKUzooOFGuomPX1I(PW3kXk7ChQcVKMdBK4BT)qkehYi9ukv4ecGqEXlbb0F4DxtNCABqJYFqTgr1scr)SK1bVY0G)QYIWVml6wJj1ZkZyGMhMwfF3BLrEx2EgWjvv4cPQG1bAXYSeSHNDAwOzKN789N(HJKCdS1j1av7P9MLBUg8fuWQjLaQNmM8YjK8CLbFkk5qLIrR30REXmxtB5HJDGcVLuuVgOjMX1ixl0PL9kDlj45L62(90EybG2rem4oQu4SMcbMo6JKyWKlVNJ8TGpcsGDgjwmkwScFvoTmZ3zm)(ZRiHzj7UaJnrDsDwVZ2xdwD38hAw9nQb4yQCk5ev5ELZzB5lxaky3EkPZkqIsq32cMMyU7p2GrFmWu943Ap7r0iRMiJQRFIk(LfYn7xN5nfk306E7v9Y2KRIOsOaLPI3uAILgJpnyKaPFG52IhJz9hIzvCkTqsCzmPuaEGYy3GxynlEltI)5VFIZ8oBMb0V91O(U1KSK4qmNboPv6R)MUXt3Tg(D7JFNh9Ktiz1hliIG3CCguVY)m1vcBsc7X0YDG7LJyAhfHRbjFb)48GOwwgLIT8zP4QBAeqr53JKyMBR8UHiqAKHRPutvtTUNmNJqBn4iGgMfcZ3ibDDhLByYQ)RnLktjp5MOnL3m2K7ExkYyOs5u9TR1zG8pgHE7tpDYueiO0NEuyVdrSR7dgPBZZBGkliKv2K3(vkHrE3draykVPNd(UHxBMZCxG9UlAwUyJHuTTPzLdRuJZuXoZifSK65ZeoisY93qyM(eIa0CBgdTD9DKzEzpM(6bn91OPp1IIEm9SHAZHjkAuYzCfESIPDfEOK5wf57m2r5sGD(VE)ILF2xJkUQJO9NT7rxIL)jZ1I4)w31KDTd(V39b382f26z5xxT0WBUWYgETZYdBoMVz1jw9egoARVhpE7U9w6ud8fh)SgVisZtzzS3pOqvShNxSHadrVQ7X5Lu7hKAOLCEvNEErWahigP2EyjgnRyjhH3tZhNBy(VUT7bEZ1tIygYONcmhbGx4mjcnu76OzoqZ6WK3a1rJ(sLIbePim6Ue46zhf5Jw8(xyKro34M9GekHG(Pg9UxE3CJFBR3ihpHwtc3a(ydceIdYPwzS1DVgUe5Ms)KxJkbSkuWTaY87X0qQOyom5ktb0BK6oz4TjNJU3eixOLrqKMwvdGfdoj0izrAlrIPlh7Xju0ddfBKiPOYgI4naB((vF5bJiozGWuOOLdQvRV2oRtc0kg2R)0eEUV0l8sPCX5SU0LfzMG8jzW0iDBRnYueCfmUf1tuT0E3e(uOiLjL3T12XKzMz1Zl6XFcdrMik6ZdUYfU3C80pBTafs3gqPUxfqcT)rrgQFzsYy7aezMpihJzfbi4(U62zYRGTt(vzbVUv3rVgoGsLOWlKEq3wYChsYj04o48jSQqVIaiPJZLlT04i7ErLQ)cwPkk7w4LpRDMEUNlT(h7HAQ9l1A6j6XgsgbNkTbaQvaKgkwn9AKX3rstor5NCMVo38x)eWXTEk06BWNExklVD5dGyz8sy6fRT1QHLkr2QqgjPLfc6zCfYyFynULe4JcI(AvcwHcvHPwWwU0fOKFUSbp7XqM0JgnzQPp0uSkFLvfrFMOKhJVf6WWcXfoe1l3jtiXjzQrYKyqPxiSpRPLiWRTcsRa1m(IDTXyyyjNmt7l1pM0iAm3P)QZOnRtZQUzx5n4Ps)WMFr1j9SqsjrY5M9tg3psNGBL9kRS6Nusv0OHVUqWKL3taUEiMbsSCPpL3L7u91kECZW5lCkRX2wP5l9LxbK)uYvS8bZYQCXPxGOVrTuPh6D6AOVvXB76ajBJkvHgJtV(T1ivIqwQmv2rg7SYKhK8wE3gSfxm2Q5E3t5VpHrPGavffepiUuPWpksYyVbRrujsQm(BPcOVKwbDUn5(p1S(Eh0bwNn8Pn1Dl(sAeqtYDIksa76(b9rnvQejsd5sZfVenecs0fGYjASpHJefENGvyccpqwZwQuZ8NmvHCHFLCrwLytLs3brG32dL2yWIArtSEgBlcM2C2FwKYOKfEzhv1y)A68Ka5xZWRqisJEVHed7bxmjQmrZYUBG8P(NNayCE5qAy6enmK4nfIweFzIHjqQunt13T9GRx1qMsIhAw7krnBAfStmB701wepaXAE8Np5zc1LAh1iOCss7bE7c01yGywIxi5vFKylzmeAsM7PLxgIf4gPekvgbzeUOG57iw3UOngtaZPcKC0RDtTcGl0z3rohMIjh)z5d)VdssOUzihnRAKCEeJhwqFnVG(xT5)JWHlLajAJIRpVue(cbWpGWx83SExZHh2NsqtON6X0Uvml1xxpqYh(tU)O2ITK5Fd(12ZrwExWRf4Bd9D3JZKYwlEExOmaN26lH7)XF1N6RXN7x8ZDdI4RYNBiwZrWLGPtYAlK32L1d2KZy3QLB3ChmG(bqDPqlsNOok3TskuoYrgfBr5MqQ2mF3cZwWiDe9EmRH5)22nh2zmYF1xx08117)06n2mKANHyvp)8hw6UPIia)Z12n8zNzHA1V1Tj9ZNwzPPWSdYNvphEWWgBFV7Wj(ty5GYCfZ77SZmZ66vljXBsNUDKApUQc3jxWFU(IE(ItmkQbHhb9C5pmaJmkcbk5i0NIgLMFpItl73bWSPLTTlKCW(32EWqkF8wB7kWmXGdsBgE56LXUZ3d7891yxsAbs4lWpWLNxl2aExEpgJdbESFNBENB44mJKcIn0Q86vpSOXLqwEMG79zqRBLz7hb(sHWorRw1XOKvsK2yLS0AsbuLbBruGkHYfnYGDDKq1yGMy2fhQEnJXPjqNLJvZOm8F476Qau5x(TL3741m()z04xAfW5QGlyrSvuasERfU2z59FqAHR6XQ7fTXRoIFFIOb1cp7S8NXypcTLkK4V07GEnKRvG75c478h6lFJuU)5EyZQnw9GTbAheyXcUDQFvlUqKq7tMly8ZZ1TNu)tDe71Ice93TebWa(wxv95SRQMotKjr(BTB13A3Q7FRDR(w7wnEgqqLT6KFRDR()RTBvm6dC2CN1fW4HOtr4qxRqnzMjIdpau9VtTewEl9bTMMESh5A3RSnF1s63RrR(qiP5wlXhHqBHt4z36uSrXY13wlOrX(cSuL6WSCDsuO1pp5fNsVLPDv2nJubQoIjeDdXhDjuyzokHtMoog9l7ZOC3H3pegJSymj91IDwLT8kwy9V)m1sXykA2sQSHOZGk3g8TE4mJgb(E4mH3D(H1DVVL26k1x6xsjnc6NTg5BVBWZC(u2oO3AWZ9HPH(dekhttnnttXDj6NnMME29N9XcPT3RMgt7wKIKdPDsAw0W0NMDpSnRN(W9hAS5xc6zeObc4GbfMvbflazjUeTSKnFk7s60EywlzdzMh8tv41r548L2COgeBRskMcL6upHodbyxi3uXhhP5UeFQRjhTJ2hnKMslfcxvAPDsQqmxB(9gYmxsmGKVI3sZs3rXCCrT3Dc5xZwX9PIh4zueBoMzolInoMPku4VhlFvJOBJcJ7av7O3UEAP39TJ33jl2NIJNeNQ)9H1l)SnQcZD50gGzb2ThstDx1uPVVv5GwaxKoVXpT0a413tj67Ps5Fp)UvIiX6SNOHo97wQGGh9(k6RHn0iQ0BfHfhtihPLnj0Fgg4MUago(AQPG8Q(dL1Im5dFxLyxgT7gPsjeCujduEUSVgPVtPffXPcmxsoAu0g7P26lUe3ccOnkBahP8M0qjEVptd2cz3KPuQF0MSjR5pRxKQuxCytZlAks7Ae8k3BzouBiY)2HMn2n6xZA5XexIWuvQ2eQIsYbOoAgvDwLzFeuk5tpxgQkcMXYas8g(Suqiv9Fznn6a92Kk1D0eDt11pdFsyulqaQyBdwZsfQa3HVmZeqSjFYEjy0ft3aRMxxQITwydIpItRqv5ADyUNz35pLtAbdJ9LWq4X810goJ)LQjIlWVqMsd4xRtfIRNnn7BoGYyBF2ffqL5Mb13((WI73TkjjF)xU0pERLv2Cu9fJoYhVD9hE82V6YGy3vr751Q1gnVg7b2AEK5Vm)HdwiBMNVB)UtjxPdOchOuPHVorQlIK3T9zimtUkkTjczwZhnkDw6gkTG2ec2FP1ePhV9F0MNX)hyJC08UOaIsFR3ENHmr9QYmQMSV5av)8(WVktp9ZtXgLpDCJCMVbYLlgNrqTGdcatgt7cqrqAj2Yf1xOrvucUd0nCuZi5whH5(UBhS2gz35vpsNYEPgZP01m(ESy5X4rXy2EIbC3dlPY5VmRY5pwy7no84i7AW1d23Op58JLhv5Hqj2Fc01BogmA61oH8T72r9DajvwjZVQUatFJ3T1omai3jLK4hriF2phzGLeigQqs4ECb1jpHzjOGLOAHci600blESK)E9YvSN)BiN)d7KSJ2w6jLChniN0YL(vIF9bHvdKi2QVQ)QooU8DB33AX((frIZ12NzFcFIWLN78NaQQrExGfbUTyEdAgW5juKzjTFBz4nPVI0PNW(kSOMKAOyhXN0AseVgPTKZYk(9cX9v0zzfjRyG(OWSHhk1brPOAY2e)ZibmxipKzHoUqby9rTdv)gD(k)dfPMT9ZGzp7iMuSj85GWniY8POBeiJwOFd7X5lKTsApDXMVn)UhiFEylewIIzprUvCoj1kjCrBTqrT2Rzw71pT1ov6c9Kw7joKuus)gmfza9mYkbrl9SFskGEpT0(wZyA3v0nFHkzjUaHJP(TYkmUZPwMD(Gv4m00xG1TAItvOFL9nTfu3VOGX8S3t)ue5f6gKfGKr38C)2TF2C9CXM5F2yqnPzqjzphthmSFDcOEyvI9hwsGr6p9e(Z6oKvHB(8YuSDH2z2ms(teAtfOKla8DCOPIAy(jhlDykewLNEuXyAsw5HOAuV6MqmCSzikQ01H4n5UKxE1ljYMmBC6n0)R9Uc2TTrIH(TKlcsPOOiwBlYHiFz)e27jijfUTanja1jh2EOF71sYsdjh(i5O40w32BboYwJOi5q(ECi5Trj1hiL0uJ0pzRGbVAVqmR3axRo7X6B1FdA7ipOTH4SkFWmVcNyILR3onqoryvLUZIIhyvPqAJbhpJiot)oTmqiSYLtPLZfEoz05mSKNc44eqeYW(RhouHxopNufO8(y5kCWfGUva(vzlEZt9iQsoun6tLSmy2E7UvXD9Qw38LN29zF6rzpA9LV3u2I3P0oOhXg9JRT5zfIHCnoEuuE1CdyjGvev7T1ODdgFt7OrRu5vptk7026ql4sgzOhiW7MoB2wVWmicf7vRnybp06q03X2GK14fQMZgdZzN0vp2em2p90Y4T1jZ1LyUSj8e2DZ2FmdFNX)jHrmET0rmDkB084oDThwnPE55vZ2UV)HhUlQ8SoT1N39RME1fZjLm40xlKUEFnzo2gWpuxEs7eWizixnwta0nwD44VJ3(X2h)DDGQX03kTlrZCzlHgDF896jd2PEQIykiGSlSm02wNZVWekQYEO4EUH74CiJVQwci2XaYRo3eJwClc0ljxfDekmErnmHI1PQP2OslNFkTxrn8e39WPBbyZR8ZduQJyz3VbY5XU0mcOmCe03FHta3Esq)C7TwhE4vVYme8rJ541tTvlv1oeYMbnUN)a9RxuaarijbhAlSSFD9NzzyKk2mgAXPp2txyT4BYejUkMncrhkgGowd1x3CqATWOcHAREZ)VD71F(QpC9xN3DXXxPXDTk0UCRfOzZwN9Fxyakp)zXvLxsWxOY8d7fPA0lUX9Y3sk4iYlGl)jJF7JQ1Ez89StiBJvWrYIAgZPt8YRS2OG9DFiR8fxr8PPwYJ26eHSkZRctSe6GZwODa1ER9a7XBiqZf6WZj7BtB(56O2ZxlB6T56BnYo59(LuL)ubL)d5)OqnRVAf8NB4zKaBULJUjrCkeeJI49uLJ76mWxoPjFKQHQHUM07P6PlD(hFt2jjoSQ67Kc7zqjCj7(EyJnarAxP(ap4U4ImZ)vgYA2vSvalMmiNBy7IUGOLYcMtHqjUpOm9Fe8DOquQdE(1C07xpnH2cy(OZwre1I1bk)b6AyqmyMum51He5J()LA7kBspKzcoOigG6cKvKlovwc)UVn3HiTmffqJK923n1qzGtCm3ePDLb0IrH)k(HlOSPiRMB7)Jb2RgkEGq(VKji4iLPxA2yb7maPMMKQ8l94eu9EWCYbmUglNPOrcTsai6PfOso)7JaIOAj)yrqHLUJej12bboo7rVBHY0l9vbFcoTee7DcJfMxSrXu6hcAXJoqJn9DsS5p4jCNrjtwRfAqkWe1jDiSonQ3NXWBYqCVQ8I3ySmmvFBZzA1OgchUHhBekAOTwgtRgLy4VFp80CAwTkeh9JKIk6UJwPcv04XlTasJuKa9EI5Zy7(OvIuyjKE9JUTuagTeznGcdo(tnTpff4q9eeR39sfPUqhRq8Zp9GvWujK)xvGiXH9id5mJ)j9xi4WbwOaXgNaCswnhbsTz7ANsQrDjwBMCSAY3nhUvFwgHbAZK)0BpRUWJ6Nfa5Pifmro54NLXdGsKILXBNBB2QulliPb27j6ke9G2qXl3fDznJa9KC0D6GH6Rg(oDwHHTNCYkjqnnMN2VzV0kBHmTTJPzxAfHr0lyMoUkK2ypIJIim9tk8cFIhbu48ZWbDeEbPXhwDabjXDJG9pdbOBWkpJJeKIFtUYAzhjzztwme4jEKxJj7CtSwWiEZHNXEAUwfPLjVG)SHia8cXaVcP4uFxiFOhI7cip4gfSsbkLtrETB5jhn40sNN3tuyq1HJyybIhdeQoNNZeQZWvyA5UjHLNLAGgfgUZW1)1E6Xp(WxU8)2zl)VdFYLF)p]] )
