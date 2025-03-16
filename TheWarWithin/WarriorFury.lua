-- WarriorFury.lua
-- August 2024
-- 11.0.2

if UnitClassBase( "player" ) ~= "WARRIOR" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class = Hekili.Class
local state = Hekili.State

local strformat = string.format

local FindPlayerAuraByID = ns.FindPlayerAuraByID
local IsActiveSpell = ns.IsActiveSpell

local spec = Hekili:NewSpecialization( 72 )

local base_rage_gen, fury_rage_mult = 1.75, 1.00
local offhand_mod = 0.50

spec:RegisterResource( Enum.PowerType.Rage, {
    mainhand_fury = {
        swing = "mainhand",

        last = function ()
            local swing = state.swings.mainhand
            local t = state.query_time

            return swing + floor( ( t - swing ) / state.swings.mainhand_speed ) * state.swings.mainhand_speed
        end,

        interval = "mainhand_speed",

        stop = function () return state.time == 0 or state.swings.mainhand == 0 end,
        value = function ()
            local baseAmt = base_rage_gen * fury_rage_mult * ( state.talent.war_machine.enabled and 1.2 or 1 ) -- "static" amount
            return ( baseAmt * ( state.buff.recklessness.up and 2 or 1 ) * state.swings.mainhand_speed ) -- Dynamic factors
        end
    },

    offhand_fury = {
        swing = "offhand",

        last = function ()
            local swing = state.swings.offhand
            local t = state.query_time

            return swing + floor( ( t - swing ) / state.swings.offhand_speed ) * state.swings.offhand_speed
        end,

        interval = "offhand_speed",

        stop = function () return state.time == 0 or state.swings.offhand == 0 end,
        value = function ()
            local baseAmt = base_rage_gen * fury_rage_mult * ( state.talent.war_machine.enabled and 1.2 or 1 ) -- "static" amount
            return ( baseAmt * ( state.buff.recklessness.up and 2 or 1 ) * state.swings.offhand_speed * offhand_mod ) -- Dynamic factors
        end,
    },

    battle_trance = {
        aura = "battle_trance",

        last = function ()
            local app = state.buff.battle_trance.applied
            local t = state.query_time

            return app + floor( ( t - app ) / 3 ) * 3
        end,

        interval = 3,

        value = 5,
    },

    conquerors_banner = {
        aura = "conquerors_banner",

        last = function ()
            local app = state.buff.conquerors_banner.applied
            local t = state.query_time

            return app + floor( t - app )
        end,

        interval = 1,

        value = 6, -- Fury 6, Arms 4, Prot 4
    },

    ravager = {
        aura = "ravager",

        last = function ()
            local app = state.buff.ravager.applied
            local t = state.query_time

            return app + floor( ( t - app ) / state.haste ) * state.haste
        end,

        interval = function () return state.haste end,

        value = function () return state.talent.storm_of_steel.enabled and 20 or 10 end,
    },
} )

-- Talents
spec:RegisterTalents( {
    -- Warrior
    armored_to_the_teeth         = {  90366, 384124, 2 }, -- Gain Strength equal to 5% of your Armor.
    avatar                       = {  90365, 107574, 1 }, -- Transform into a colossus for 20 sec, causing you to deal 20% increased damage and removing all roots and snares. Generates 10 Rage.
    barbaric_training            = {  90340, 383082, 1 }, -- Slam, Thunder Clap, and Whirlwind deal 20% more damage and 10% increased critical strike damage.
    berserker_shout              = {  90348, 384100, 1 }, -- Go berserk, removing and granting immunity to Fear, Sap, and Incapacitate effects for 6 sec. Also remove fear effects from group members within 12 yds.
    berserker_stance             = {  90325, 386196, 1 }, -- An aggressive combat state that increases the damage of your auto-attacks by 15% and reduces the duration of Fear, Sap and Incapacitate effects on you by 10%. Lasts until canceled.
    berserkers_torment           = {  90362, 390123, 1 }, -- Activating Avatar or Recklessness grants 8 sec of the other.
    bitter_immunity              = {  90356, 383762, 1 }, -- Restores 20% health instantly and removes all diseases, poisons and curses affecting you. 
    bounding_stride              = {  90355, 202163, 1 }, -- Reduces the cooldown of Heroic Leap by 15 sec, and Heroic Leap now also increases your movement speed by 70% for 3 sec.
    cacophonous_roar             = {  90383, 382954, 1 }, -- Intimidating Shout can withstand 200% more damage before breaking.
    champions_might              = {  90323, 386284, 1 }, -- The duration of Champion's Spear is increased by 2 sec. You deal 25% increased critical strike damage to targets chained to your Spear.
    champions_spear              = {  90380, 376079, 1 }, -- Throw a spear at the target location, dealing 43,399 Physical damage instantly and an additional 48,350 damage over 4 sec. Deals reduced damage beyond 5 targets. Enemies hit are chained to the spear's location for the duration. Generates 10 Rage.
    concussive_blows             = {  90354, 383115, 1 }, -- Cooldown of Pummel reduced by 1.0 sec. Successfully interrupting an enemy increases the damage you deal to them by 5% for 10 sec.
    crackling_thunder            = {  95959, 203201, 1 }, -- Thunder Clap's radius is increased by 50%, and it reduces movement speed by an additional 20%.
    cruel_strikes                = {  90381, 392777, 2 }, -- Critical strike chance increased by 1% and critical strike damage of Execute increased by 5%. 
    crushing_force               = {  90347, 382764, 2 }, -- Bloodthirst deals an additional 5% damage and deals 5% increased critical strike damage.
    defensive_stance             = {  92538, 386208, 1 }, -- A defensive combat state that reduces all damage you take by 15%, and all damage you deal by 10%. Lasts until canceled.
    double_time                  = {  90382, 103827, 1 }, -- Increases the maximum number of charges on Charge by 1, and reduces its cooldown by 3 sec.
    dual_wield_specialization    = {  90373, 382900, 2 }, -- While dual wielding your damage is increased by 3% and movement speed is increased by 2%.
    fast_footwork                = {  90344, 382260, 1 }, -- Movement speed increased by 5%.
    frothing_berserker           = {  90352, 392792, 1 }, -- Rampage has a 20% chance to immediately refund 10% of the Rage spent.
    heroic_leap                  = {  90346,   6544, 1 }, -- Leap through the air toward a target location, slamming down with destructive force to deal 4,263 Physical damage to all enemies within 8 yards.
    honed_reflexes               = {  95956, 391271, 1 }, -- Cooldown of Enraged Regeneration, Pummel, Intervene, Spell Reflection, and Storm Bolt reduced by 5%.
    impending_victory            = {  90326, 202168, 1 }, -- Instantly attack the target, causing 10,702 damage and healing you for 30% of your maximum health. Killing an enemy that yields experience or honor resets the cooldown of Impending Victory and makes it cost no Rage.
    intervene                    = {  90329,   3411, 1 }, -- Run at high speed toward an ally, intercepting all melee and ranged attacks against them for 6 sec while they remain within 10 yds.
    intimidating_shout           = {  90384,   5246, 1 }, -- Causes the targeted enemy to cower in fear, and up to 5 additional enemies within 8 yards to flee. Targets are disoriented for 8 sec.
    leeching_strikes             = {  90371, 382258, 1 }, -- Leech increased by 3%.
    menace                       = {  90383, 275338, 1 }, -- Intimidating Shout will knock back all nearby enemies except your primary target, and cause them all to cower in fear for 15 sec instead of fleeing.
    overwhelming_rage            = {  90378, 382767, 1 }, -- Maximum Rage increased by 30.
    pain_and_gain                = {  90353, 382549, 1 }, -- When you take any damage, heal for 2.00% of your maximum health. This can only occur once every 10 sec.
    piercing_challenge           = {  90379, 382948, 1 }, -- Champion's Spear's damage increased by 50% and its Rage generation is increased by 100%.
    piercing_howl                = {  90348,  12323, 1 }, -- Snares all enemies within 12 yards, reducing their movement speed by 70% for 8 sec.
    rallying_cry                 = {  90331,  97462, 1 }, -- Lets loose a rallying cry, granting all party or raid members within 40 yards 10% temporary and maximum health for 10 sec.
    reinforced_plates            = {  90368, 382939, 2 }, -- Stamina increased by 5% and Armor increased by 5%.
    rumbling_earth               = {  90374, 275339, 1 }, -- Shockwave's range increased by 6 yards and when Shockwave strikes at least 3 targets, its cooldown is reduced by 15 sec.
    second_wind                  = {  90332,  29838, 1 }, -- Restores 6% health every 1 sec when you have not taken damage for 5 sec. While you are below 35% health, restores 1.0% health every 1 sec. The amount restored increases the closer you are to death.
    seismic_reverberation        = {  90354, 382956, 1 }, -- If Whirlwind or Thunder Clap hits 3 or more enemies, it hits them 1 additional time for 30% damage.
    shattering_throw             = {  90351,  64382, 1 }, -- Hurl your weapon at the enemy, causing 19,717 Physical damage, ignoring armor, and removing any magical immunities. Deals up to 500% increased damage to absorb shields.
    shockwave                    = {  90375,  46968, 1 }, -- Sends a wave of force in a frontal cone, causing 3,628 damage and stunning all enemies within 10 yards for 2 sec.
    sidearm                      = {  90340, 384404, 1 }, -- Your auto-attacks have a 20% chance to hurl weapons at your target and 3 other enemies in front of you, dealing an additional 4,535 Physical damage.
    spell_reflection             = {  90385,  23920, 1 }, -- Raise your weapon, reflecting the first spell cast on you, and reduce magic damage you take by 20% for 5 sec.
    storm_bolt                   = {  90337, 107570, 1 }, -- Hurls your weapon at an enemy, causing 5,170 Physical damage and stunning for 4 sec.
    thunder_clap                 = {  90343,   6343, 1 }, -- Blasts all enemies within 8 yards for 33,823 Physical damage and reduces their movement speed by 20% for 10 sec. Deals reduced damage beyond 5 targets. Generates 8 Rage.
    thunderous_roar              = {  90359, 384318, 1 }, -- Roar explosively, dealing 45,451 Physical damage to enemies within 12 yds and cause them to bleed for 66,880 physical damage over 8 sec. Deals reduced damage beyond 5 targets.
    thunderous_words             = {  90358, 384969, 1 }, -- Increases the duration of Thunderous Roar's Bleed effect by 2.0 sec and Thunderous Roar's Bleed effect causes enemies to take 20% increased damage from all your bleeds.
    titans_torment               = {  90362, 390135, 1 }, -- While Avatar is active Rampage's Rage cost is reduced by 20 and Bloodthirst's cooldown is reduced by 1.5 sec.
    uproar                       = {  90357, 391572, 1 }, -- Thunderous Roar's cooldown reduced by 45 sec.
    war_machine                  = {  90328, 262231, 1 }, -- Your auto attacks generate 20% more Rage. Killing an enemy instantly generates 5 Rage, and increases your movement speed by 30% for 8 sec.
    wild_strikes                 = {  90360, 382946, 2 }, -- Haste increased by 1% and your auto-attack critical strikes increase your auto-attack speed by 10% for 10 sec.
    wrecking_throw               = {  90351, 384110, 1 }, -- Hurl your weapon at the enemy, causing 19,717 Physical damage, ignoring armor. Deals up to 500% increased damage to absorb shields.

    -- Fury
    anger_management             = {  90415, 152278, 1 }, -- Every 20 Rage you spend reduces the remaining cooldown on Recklessness, Bladestorm, and Ravager by 1 sec.
    ashen_juggernaut             = {  90409, 392536, 1 }, -- Execute increases the critical strike chance of Execute by 10% for 15 sec, stacking up to 5 times.
    bladestorm                   = {  90388, 227847, 1 }, -- Become an unstoppable storm of destructive force, striking all nearby enemies for 155,542 Physical damage over 3.3 sec. Deals reduced damage beyond 8 targets. You are immune to movement impairing and loss of control effects, but can use defensive abilities and can avoid attacks. Generates 10 Rage each time you deal damage.
    bloodborne                   = {  90401, 385703, 1 }, -- Bleed damage of Odyn's Fury, Thunderous Roar, Bloodbath, and Gushing Wound increased by 20%.
    bloodcraze                   = {  90405, 393950, 1 }, -- Raging Blow increases the critical strike chance of your next Bloodthirst by 15% until it critically strikes, stacking up to 5 times.
    bloodthirst                  = {  90392,  23881, 1 }, -- Assault the target in a bloodthirsty craze, dealing 80,155 Physical damage and restoring 3% of your health. Generates 8 Rage.
    cold_steel_hot_blood         = {  90402, 383959, 1 }, -- Bloodthirst critical strikes generate 4 additional Rage, and inflict a Gushing Wound that leeches 26,447 health over 6 sec.
    critical_thinking            = {  90425, 383297, 2 }, -- Critical Strike chance increased by 1% and Raging Blow's critical strikes deal 5% increased damage.
    cruelty                      = {  90428, 392931, 1 }, -- While Enraged, Raging Blow deals 15% increased damage.
    dancing_blades               = {  90417, 391683, 1 }, -- Odyn's Fury increases your auto-attack damage and speed by 30% for 10 sec.
    deft_experience              = {  90421, 383295, 2 }, -- Mastery increased by 1% and if you are Enraged, Bloodthirst extends your Enrage by 0.5 sec.
    depths_of_insanity           = {  90413, 383922, 1 }, -- Recklessness lasts 4.0 sec longer.
    enraged_regeneration         = {  90395, 184364, 1 }, -- Reduces damage taken by 30%, and Bloodthirst restores an additional 20% health. Usable while stunned or incapacitated. Lasts 8 sec.
    focus_in_chaos               = {  90403, 383486, 1 }, -- While Enraged, your auto-attacks can no longer miss.
    frenzied_enrage              = {  90398, 383848, 1 }, -- Enrage increases your Haste by 15% and increases your movement speed by 10%.
    frenzy                       = {  90406, 335077, 1 }, -- Rampage increases your Haste by 2% for 12 sec, stacking up to 4 times. This effect is reset if you Rampage a different primary target.
    fresh_meat                   = {  90399, 215568, 1 }, -- Bloodthirst always Enrages you the first time you strike a target, and it has a 15% increased chance to trigger Enrage.
    hack_and_slash               = {  90407, 383877, 1 }, -- Each Rampage strike has a 25% chance to refund a charge of Raging Blow.
    improved_bloodthirst         = {  90397, 383852, 1 }, -- Bloodthirst damage increased by 10%.
    improved_execute             = {  90430, 316402, 1 }, -- Execute no longer costs Rage and now generates 20 Rage.
    improved_raging_blow         = {  90390, 383854, 1 }, -- Raging Blow has 2 charges and has a 25% chance to instantly reset its own cooldown.
    improved_whirlwind           = {  90427,  12950, 1 }, -- Whirlwind and Thunder Clap cause your next 4 single-target attacks to strike up to 4 additional targets for 55% damage. Whirlwind generates 3 Rage, plus an additional 1 per target hit. Maximum 8 Rage.
    invigorating_fury            = {  90393, 383468, 1 }, -- Enraged Regeneration lasts 3 sec longer and instantly heals for 10% of your maximum health.
    massacre                     = {  90410, 206315, 1 }, -- Execute is now usable on targets below 35% health, and its cooldown is reduced by 1.5 sec.
    meat_cleaver                 = {  90391, 280392, 1 }, -- Whirlwind and Thunder Clap deal 25% more damage and now affect your next 4 single-target melee attacks, instead of the next 2 attacks.
    odyns_fury                   = {  90418, 385059, 1 }, -- Unleashes your power, dealing 81,570 Physical damage and an additional 39,272 Physical damage over 4 sec to all enemies within 12 yards. Deals reduced damage beyond 5 targets. Generates 15 Rage. 
    onslaught                    = {  90424, 315720, 1 }, -- Brutally attack an enemy for 75,074 Physical damage. Generates 30 Rage.
    powerful_enrage              = {  90398, 440277, 1 }, -- Enrage increases the damage your abilities deal by an additional 15% and Enrage's duration is increased by 1 sec.
    raging_blow                  = {  90396,  85288, 1 }, -- A mighty blow with both weapons that deals a total of 56,918 Physical damage. Raging Blow has a 25% chance to instantly reset its own cooldown. Generates 12 Rage.
    rampage                      = {  90408, 184367, 1 }, -- Enrages you and unleashes a series of 4 brutal strikes for a total of 128,125 Physical damage and empowering your next Bloodthirst and Raging Blow.
    ravager                      = {  90388, 228920, 1 }, -- Throws a whirling weapon at the target location that chases nearby enemies, inflicting 130,080 Physical damage to all enemies over 9.8 sec. Deals reduced damage beyond 8 targets. Generates 10 Rage each time it deals damage.
    reckless_abandon             = {  90415, 396749, 1 }, -- Activating Recklessness generates 50 Rage and while Recklessness is active, Raging Blow and Bloodthirst are replaced by Crushing Blow and Bloodbath.  Crushing Blow Strike a mighty blow with both weapons that deals a total of 68,301 Physical damage. Crushing Blow has a 25% chance to instantly reset its own cooldown and its critical strikes deal 20% additional damage. Generates 12 Rage.  Bloodbath Assault the target in a bloodthirsty craze, dealing 96,187 Physical damage and restoring 3% of your health. Bloodbath causes the target to bleed for 13,060 damage over 6 sec. Using Bloodbath on a target that is affected by Bloodbath extends the bleed by 6 sec. Generates 8 Rage.
    recklessness                 = {  90412,   1719, 1 }, -- Go berserk, increasing all Rage generation by 100% and granting your abilities 20% increased critical strike chance for 12 sec. Generates 50 Rage.
    singleminded_fury            = {  90400,  81099, 1 }, -- While dual-wielding a pair of one-handed weapons, your damage done is increased by 5%, your auto-attack damage with one-handed weapons is increased by 30%, your movement speed is increased by 5%, and your auto-attack critical strikes have a 50% chance to Enrage you.
    slaughtering_strikes         = {  90411, 388004, 1 }, -- Raging Blow causes every strike of your next Rampage to deal an additional 20% damage, stacking up to 5 times.
    storm_of_steel               = {  90389, 382953, 1 }, -- Bladestorm and Ravager's damage are reduced by 30% but they now have 2 charges and generate 10 additional Rage each time they deal damage.
    sudden_death                 = {  90429, 280721, 1 }, -- Your attacks have a chance to reset the cooldown of Execute and make it usable on any target, regardless of their health.
    swift_strikes                = {  90416, 383459, 2 }, -- Haste increased by 1% and Raging Blow and Bloodthirst generate an additional 1 Rage.
    tenderize                    = {  90423, 388933, 1 }, -- Onslaught Enrages you, and if you have Slaughtering Strikes grants you 3 stacks of Slaughtering Strikes.
    titanic_rage                 = {  90417, 394329, 1 }, -- Odyn's Fury's Enrages you, deals 10% increased damage and grants you 4 stacks of Whirlwind. 
    unbridled_ferocity           = {  90414, 389603, 1 }, -- Rampage has a 6% chance to grant Recklessness for 4 sec.
    unhinged                     = {  90389, 386628, 1 }, -- Every other time Bladestorm or Ravager deal damage, you automatically cast a Bloodthirst at your target or random nearby enemy. 
    vicious_contempt             = {  90404, 383885, 2 }, -- Bloodthirst deals 25% increased damage to enemies who are below 35% health.
    warpaint                     = {  90394, 208154, 1 }, -- You take 10% reduced damage while Enrage is active.
    wrath_and_fury               = {  90387, 392936, 1 }, -- Raging Blow deals 15% increased damage and while Enraged, Raging Blow has a 10% increased chance to instantly reset its own cooldown. 

    -- Mountain Thane
    avatar_of_the_storm          = {  94805, 437134, 1 }, -- Casting Avatar grants you 2 charges of Thunder Blast and resets the cooldown of Thunder Clap. While Avatar is not active, Lightning Strikes have a 10% chance to grant you Avatar for 4 secs. Thunder Blast Your next Thunder Clap becomes a Thunder Blast that deals Stormstrike damage.
    burst_of_power               = {  94807, 437118, 1 }, -- Lightning Strikes have a 15% chance to make your next 2 Bloodthirsts have no cooldown, deal 35% increased damage, and generate 2 additional Rage.
    crashing_thunder             = {  94816, 436707, 1 }, -- Stormstrike or Nature damage your abilities deal is increased by 5%. Stormstrike damage ignores Armor. Thunder Clap damage increased by 40%, and it generates 8 Rage. Seismic Reverberations, Improved Whirlwind, Meat Cleaver, and Barbaric Training now affect Thunder Clap in addition to Whirlwind.
    flashing_skies               = {  94797, 437079, 1 }, -- Thunder Blast calls down a Lightning Strike on an enemy it hits.
    gathering_clouds             = {  94792, 436201, 1 }, -- Your attacks trigger Lightning Strikes 30% more often.
    ground_current               = {  94800, 436148, 1 }, -- Lightning Strikes also deal 8,516 to enemies near their target. Damage reduced beyond 5 targets.
    keep_your_feet_on_the_ground = {  94798, 438590, 1 }, -- Physical damage taken reduced by 2%. Thunder Blast reduces damage you take by 8% for 5 sec.
    lightning_strikes            = {  94803, 434969, 1, "mountain_thane" }, -- Damaging enemies with Thunder Clap, Raging Blow, or Execute has a 25% chance to also strike one with a lightning bolt, dealing 38,403 Nature damage. Lightning Strikes occur 30% more often during Avatar.
    snap_induction               = {  94797, 456270, 1 }, -- Activating Recklessness grants a charge of Thunder Blast.
    steadfast_as_the_peaks       = {  94798, 434970, 1 }, -- Stamina increased by 5%. Victory Rush increases your maximum health by 10% for 5 sec. When this health increase expires, you heal for any amount of the original Victory Rush that healed you in excess of your full health.
    storm_bolts                  = {  94817, 436162, 1 }, -- Storm Bolt also hits 2 additional nearby targets, stunning them for 2 sec, but its cooldown is increased by 10 sec.
    storm_shield                 = {  94817, 438597, 1 }, -- Intervening a target grants them a shield for 5 sec that absorbs magic damage equal to 3 times your Armor.
    strength_of_the_mountain     = {  94808, 437068, 1 }, -- Shield Slam damage increased by 10%. Bloodthirst and Rampage damage increased by 25%.
    thorims_might                = {  94792, 436152, 1 }, -- Lightning Strikes generate 3 Rage. Raging Blow and Execute damage increased by 25%.
    thunder_blast                = {  94785, 435607, 1 }, -- Shield Slam and Bloodthirst have a 35% chance to grant you Thunder Blast, stacking up to 2 charges. Thunder Blast Your next Thunder Clap becomes a Thunder Blast that deals Stormstrike damage and generates 10 Rage.

    -- Slayer
    brutal_finish                = {  94786, 446085, 1 }, -- Your next Rampage after Bladestorm ends deals 50% additional damage.
    culling_cyclone              = {  94786, 444778, 1 }, -- Each strike of Bladestorm deals an additional 10% damage evenly split across all targets.
    death_drive                  = {  94813, 444770, 1 }, -- You heal for 15% of damage dealt by Sudden Death.
    fierce_followthrough         = {  94787, 444773, 1 }, -- Bloodthirst critical strikes increase the damage of your next Bloodthirst by 20%.
    imminent_demise              = {  94788, 444769, 1 }, -- Every 3 Slayer's Strikes you gain Sudden Death. Using Sudden Death accelerates your next Bladestorm, striking 1 additional time (max 3). Bladestorm's total duration is unchanged.
    opportunist                  = {  94787, 444774, 1 }, -- When Raging Blow resets its own cooldown, your next Raging Blow deals 20% additional damage and 20% additional critical damage.
    overwhelming_blades          = {  94810, 444772, 1 }, -- Each strike of Bladestorm applies Overwhelmed to all enemies affected, increasing damage you deal to them by 1% for 20 sec, max 10 stacks.
    reap_the_storm               = {  94809, 444775, 1 }, -- Bloodthirst has a 20% chance to cause you to unleash a flurry of steel, striking all nearby enemies for 51,783 damage and applying Overwhelmed. Deals reduced damage beyond 8 targets. 
    relentless_pursuit           = {  94795, 444776, 1 }, -- Charge grants you 70% movement speed for 3 sec. Charge removes all movement impairing effects, this effect cannot occur more than once every 30 sec. 
    show_no_mercy                = {  94784, 444771, 1 }, -- Marked for Execution increases the critical strike chance and critical strike damage of your next Execute on the target by 15%.
    slayers_dominance            = {  94814, 444767, 1, "slayer" }, -- Your attacks against your primary target have a high chance to overwhelm their defenses and trigger a Slayer's Strike, dealing 60,496 damage and applying Marked for Execution, increasing the damage they take from your next Execute by 15%. Stacks 3 times.
    slayers_malice               = {  94801, 444779, 1 }, -- Raging Blow damage increased by 30%.
    unrelenting_onslaught        = {  94820, 444780, 1 }, -- When you Execute a target that you've Marked for Execution, you both reduce the cooldown of Bladestorm by 5 sec and apply 2 stacks of Overwhelmed to the target per stack of Marked for Execution consumed. You can now use Pummel and Storm Bolt while Bladestorming.
    vicious_agility              = {  94795, 444777, 1 }, -- Heroic Leap reduces the cooldown of Charge by 5 sec and Charge reduces the cooldown of Heroic Leap by 2 sec.
} )


-- PvP Talents
spec:RegisterPvpTalents( { 
    battlefield_commander = 5629, -- (424742) Your Shout abilities have additional effects.  Battle Shout: Increases Stamina by 3%.  Piercing Howl: Radius increased by 50%  Berserker Shout: Range increased by 8 yds.  Intimidating Shout: Cooldown reduced by 15 sec.  Rallying Cry: Removes movement impairing effects and grants 30% movement speed to allies.  Thunderous Roar: Targets receive 5% more damage from all sources while bleeding.
    bodyguard             =  168, -- (213871) Protect an ally, causing 40% of all Physical damage they take to be transfered to you. When the target takes Physical damage, your Shield Slam cooldown has a 30% chance to be reset. Bodyguard is cancelled if the target is further than 20 yards from you. Lasts 1 min. Only one target can be Bodyguarded at a time.
    demolition            = 5374, -- (329033) Reduces the cooldown of your Shattering Throw or Wrecking Throw by 50% and increases its damage to absorb shields by an additional 250%.
    disarm                =   24, -- (236077) Disarm the enemy's weapons and shield for 5 sec. Disarmed creatures deal significantly reduced damage.
    dragon_charge         =  831, -- (206572) Run at high speed at a distance in front of you. All enemies in your path will take 7,883 Physical damage and be knocked back.
    morale_killer         =  171, -- (199023) Reduces the cooldown of Demoralizing Shout by 15 sec, and Demoralizing Shout now reduces the damage enemies deal to all targets, not just you.
    oppressor             =  845, -- (205800) You focus the assault on this target, increasing their damage taken by 3% for 6 sec. Each unique player that attacks the target increases the damage taken by an additional 3%, stacking up to 5 times. Your melee attacks refresh the duration of Focused Assault.
    rebound               =  833, -- (213915) Spell Reflection reflects the next 2 incoming spells cast on you and reflected spells deal 50% extra damage to the attacker. Spell Reflection's cooldown is increased by 10 sec.
    safeguard             = 5626, -- (424654) Intervene now has 2 charges and reduces the ally's damage taken by 20% for 5 sec. Intervene's cooldown is increased by 10 sec.
    shield_bash           =  173, -- (198912) When Shield Slam is used on targets that are casting, it reduces their damage done by 15% for 8 sec and the cooldown is instantly reset.
    storm_of_destruction  = 5627, -- (236308) Bladestorm and Ravager now snare all targets you hit by 60% for 6 sec and decrease their healing taken by 50% for 10 sec.
    thunderstruck         =  175, -- (199045) Thunder Clap roots all targets it damages for 4 sec.
    warbringer            = 5432, -- (356353) Charge roots enemies for 2 sec and emanates a shockwave past the target, rooting enemies and dealing 5,631 Physical damage in a 20 yd cone.
    warpath               =  178, -- (199086) When landing with Heroic Leap, all targets are stunned for 3 sec.
} )

-- Auras
spec:RegisterAuras( {
    ashen_juggernaut = {
        id = 392537,
        duration = 15,
        max_stack = 5
    },
    avatar = {
        id = 107574,
        duration = 20,
        max_stack = 1
    },
    battle_trance = { --PvP Talent
        id = 213858,
        duration = 18,
        max_stack = 1
    },
    berserker_rage = {
        id = 18499,
        duration = 6,
        max_stack = 1
    },
    berserker_shout = {
        id = 384100,
        duration = 6,
        max_stack = 1
    },
    berserker_stance = {
        id = 386196,
        duration = 3600,
        max_stack = 1
    },
    bladestorm = {
        id = 46924,
        duration = function () return ( buff.dance_of_death.up and 9 or 6 ) * haste end,
        max_stack = 1,
        onCancel = function()
            setCooldown( "global_cooldown", 0 )
        end,
        copy = { 227847, 389774, 446035 }
    },
    bloodbath_dot = {
        id = 113344,
        duration = 6,
        max_stack = 1
    },
    bloodcraze = {
        id = 393951,
        duration = 20,
        max_stack = 5
    },
    bloodrage = {
        id = 329038,
        duration = 4,
        tick_time = 1,
        max_stack = 1
    },
    bloodthirst = {
        id = 23881,
        duration = 20,
        max_stack = 1
    },
    brutal_finish = {
        id = 446918,
        duration = 10,
        max_stack = 1
    },
    burst_of_power = {
        id = 437121,
        duration = 15,
        max_stack = 2
    },
    charge = {
        id = 105771,
        duration = 1,
        max_stack = 1,
    },
    concussive_blows = {
        id = 383116,
        duration = 10,
        max_stack = 1
    },
    dancing_blades = {
        id = 391688,
        duration = 10,
        max_stack = 1
    },
    death_wish = {
        id = 199261,
        duration = 15,
        max_stack = 10
    },
    defensive_stance = {
        id = 386208,
        duration = 3600,
        max_stack = 1
    },
    disarm = {
        id = 236077,
        duration = 6,
        max_stack = 1
    },
    elysian_might = {
        id = 386286,
        duration = 8,
        max_stack = 1,
        copy = 311193 -- Covenant version.
    },
    enrage = {
        id = 184362,
        duration = function() return talent.powerful_enrage.enabled and 5 or 4 end,
        max_stack = 1,
    },
    enraged_regeneration = {
        id = 184364,
        duration = function () return state.talent.invigorating_fury.enabled and 11 or 8 end,
        max_stack = 1,
    },
    frenzy = {
        id = 335082,
        duration = 12,
        max_stack = 4,
    },
    gushing_wound = {
        id = 385042,
        duration = 6,
        tick_time = 2,
        max_stack = 1,
    },
    hamstring = {
        id = 1715,
        duration = 15,
        max_stack = 1,
    },
    imminent_demise = {
        id = 445606,
        duration = 60,
        max_stack = 3,
    },
    indelible_victory = {
        id = 336642,
        duration = 8,
        max_stack = 1
    },
    intimidating_shout = {
        id = function () return talent.menace.enabled and 316593 or 5246 end,
        duration = function () return talent.menace.enabled and 15 or 8 end,
        max_stack = 1,
    },
    marked_for_execution = {
        id = 445584,
        duration = 30,
        max_stack = 3,
    },
    odyns_fury = {
        id = 385060,
        duration = 4,
        tick_time = 1,
        max_stack = 1,
        copy = { "odyns_fury_torment", "odyns_fury_torment_mh" }
    },
    opportunist = {
        id = 456120,
        duration = 8,
        max_stack = 1,
    },
    overwhelmed = {
        id = 445836,
        duration = 20,
        max_stack = 10
    },
    piercing_howl = {
        id = 12323,
        duration = 8,
        max_stack = 1,
    },
    quick_thinking = {
        id = 392778,
        duration = 10,
        max_stack = 1
    },
    raging_blow = {
        id = 85288,
        duration = 12,
        max_stack = 1
    },
    rallying_cry = {
        id = 97463,
        duration = 10,
        max_stack = 1,
    },
    ravager = {
        id = 228920,
        duration = 12,
        tick_time = 2,
        max_stack = 1
    },
    recklessness = {
        id = 1719,
        duration = function() return state.talent.depths_of_insanity.enabled and 16 or 12 end,
        max_stack = 1,
        copy = "recklessness_warlords_torment"
    },
    slaughterhouse = {
        id = 354788,
        duration = 20,
        max_stack = 12
    },
    slaughtering_strikes_raging_blow = {
        id = 393931,
        duration = 12,
        max_stack = 5,
        copy = "slaughtering_strikes"
    },
    spell_reflection = {
        id = 23920,
        duration = function () return legendary.misshapen_mirror.enabled and 8 or 5 end,
        max_stack = 1,
    },
    stance = {
        alias = { "battle_stance", "berserker_stance", "defensive_stance" },
        aliasMode = "first",
        aliasType = "buff",
        duration = 3600,
    },
    sudden_death = {
        id = 280776,
        duration = 10,
        max_stack = 2
    },
    steadfast_as_the_peaks = {
        id = 437152,
        duration = 5,
        max_stack = 1
    },
    taunt = {
        id = 355,
        duration = 3,
        max_stack = 1,
    },
    thunder_blast = {
        id = 435615,
        duration = 15,
        max_stack = 2
    },
    thunder_clap = {
        id = 6343,
        duration = 10,
        max_stack = 1
    },
    thunderous_roar = {
        id = 397364,
        duration = function () return talent.thunderous_words.enabled and 10 or 8 end,
        tick_time = 2,
        max_stack = 1
    },
    victorious = {
            id = 32216,
            duration = 20,
            max_stack = 1,
        },
    war_machine = {
        id = 262232,
        duration = 8,
        max_stack = 1
    },
    meat_cleaver = {
        id = 85739,
        duration = 20,
        max_stack = function ()
            if talent.meat_cleaver.enabled then return 4
            elseif talent.improved_whirlwind.enabled or talent.titanic_rage.enabled then return 2
            else return 0 end
        end,
        copy = "whirlwind"
    },
} )

-- The War Within
spec:RegisterGear( "tww2", 229235, 229233, 229238, 229236, 229234 )
spec:RegisterAuras( {
    -- 2-set
    -- https://www.wowhead.com/ptr-2/spell=1216561/winning-streak
    -- Rampage damage increased by 2%.
    winning_streak = {
        id = 1216561,
        duration = 30,
        max_stack = 10,
        copy = "winning_streak_fury"
    },
    -- https://www.wowhead.com/ptr-2/spell=1216565/double-down
    -- Bloodthirst damage increased by 15% and critical strike chance increased by 25%.
    double_down_bt = {
        id = 1216565,
        duration = 12,
        max_stack = 1
    },
    --https://www.wowhead.com/ptr-2/spell=1216569/double-down
    --Raging Blow damage increased by 15% and Rage generated increased by (w2 / 10).
    double_down_rb = {
        id = 1216569,
        duration = 12,
        max_stack = 1
    },
} )

-- Dragonflight
spec:RegisterGear( "tier29", 200426, 200428, 200423, 200425, 200427 )
spec:RegisterSetBonuses( "tier29_2pc", 393708, "tier29_4pc", 393709 )

spec:RegisterGear( "tier30", 202446, 202444, 202443, 202442, 202441, 217218, 217220, 217216, 217217, 217219 )
spec:RegisterSetBonuses( "tier30_2pc", 405579, "tier30_4pc", 405580 )
spec:RegisterAura( "merciless_assault", {
    id = 409983,
    duration = 14,
    max_stack = 10
} )

spec:RegisterGear( "tier31", 207180, 207181, 207182, 207183, 207185 )
spec:RegisterSetBonuses( "tier31_2pc", 422925, "tier31_4pc", 422926 )
spec:RegisterAura( "furious_bloodthirst", {
    id = 423211,
    duration = 20,
    max_stack = 3
} )
-- Legacy
spec:RegisterGear( 'tier20', 147187, 147188, 147189, 147190, 147191, 147192 )
    spec:RegisterAura( "raging_thirst", {
        id = 242300,
        duration = 8
        } ) -- fury 2pc.
    spec:RegisterAura( "bloody_rage", {
        id = 242952,
        duration = 10,
        max_stack = 10
        } ) -- fury 4pc.

spec:RegisterGear( 'tier21', 152178, 152179, 152180, 152181, 152182, 152183 )
    spec:RegisterAura( "slaughter", {
        id = 253384,
        duration = 4
    } ) -- fury 2pc dot.
    spec:RegisterAura( "outrage", {
        id = 253385,
        duration = 8
    } ) -- fury 4pc.

spec:RegisterGear( "ceannar_charger", 137088 )
spec:RegisterGear( "timeless_stratagem", 143728 )
spec:RegisterGear( "kazzalax_fujiedas_fury", 137053 )
    spec:RegisterAura( "fujiedas_fury", {
        id = 207776,
        duration = 10,
        max_stack = 4
    } )
spec:RegisterGear( "mannoroths_bloodletting_manacles", 137107 ) -- NYI.
spec:RegisterGear( "najentuss_vertebrae", 137087 )
spec:RegisterGear( "valarjar_berserkers", 151824 )
spec:RegisterGear( "ayalas_stone_heart", 137052 )
    spec:RegisterAura( "stone_heart", { id = 225947,
        duration = 10
    } )
spec:RegisterGear( "the_great_storms_eye", 151823 )
    spec:RegisterAura( "tornados_eye", {
        id = 248142,
        duration = 6,
        max_stack = 6
    } )
spec:RegisterGear( "archavons_heavy_hand", 137060 )
spec:RegisterGear( "weight_of_the_earth", 137077 ) -- NYI.

spec:RegisterGear( "soul_of_the_battlelord", 151650 )

state.IsActiveSpell = IsActiveSpell

local whirlwind_consumers = {
    crushing_blow = 1,
    bloodbath = 1,
    bloodthirst = 1,
    execute = 1,
    impending_victory = 1,
    raging_blow = 1,
    rampage = 1,
    onslaught = 1,
    victory_rush = 1
}

local rageSpent = 0
local gloryRage = 0

local fresh_meat_actual = {}

local last_rampage_target = nil

local RemoveFrenzy = setfenv( function()
    removeBuff( "frenzy" )
end, state )

local ExpireBladestorm = setfenv( function()
    applyBuff( "merciless_bonegrinder" )
end, state )

spec:RegisterCombatLogEvent( function(  _, subtype, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID, spellName, school, amount, interrupt, a, b, c, d, critical )
    if sourceGUID ~= state.GUID then return end

    if subtype == "SPELL_CAST_SUCCESS" then
        local ability = class.abilities[ spellID ]

        if not ability then return end
        if ability.key == "rampage" and last_rampage_target ~= destGUID and state.talent.frenzy.enabled then
            RemoveFrenzy()
            last_rampage_target = destGUID
        end

    elseif subtype == "SPELL_DAMAGE" then
        local ability = class.abilities[ spellID ]
        if not ability then return end

        if ( ability.key == "bloodthirst" or ability.key == "bloodbath" ) and state.talent.fresh_meat.enabled and not fresh_meat_actual[ destGUID ] then
            fresh_meat_actual[ destGUID ] = true
        end
    elseif ( subtype == "SPELL_AURA_APPLIED" or subtype == "SPELL_AURA_REMOVED" or subtype == "SPELL_AURA_REFRESH" or subtype == "SPELL_AURA_APPLIED_DOSE" or subtype == "SPELL_AURA_REMOVED_DOSE" ) then
        if state.talent.thunder_blast.enabled and spellID == 435615 then Hekili:ForceUpdate( "THUNDERBLAST_CHANGED", true ) end
        if state.talent.burst_of_power.enabled and spellID == 437121 then Hekili:ForceUpdate( "BURSTOFPOWER_CHANGED", true ) end
    end
end )

local wipe = table.wipe

spec:RegisterEvent( "PLAYER_REGEN_ENABLED", function()
    wipe( fresh_meat_actual )
end )

spec:RegisterHook( "UNIT_ELIMINATED", function( id )
    fresh_meat_actual[ id ] = nil
end )

local RAGE = Enum.PowerType.Rage
local lastRage = -1

spec:RegisterUnitEvent( "UNIT_POWER_FREQUENT", "player", nil, function( event, unit, powerType )
    if powerType == "RAGE" then
        local current = UnitPower( "player", RAGE )
        if current < lastRage - 3 then -- Spent Rage, -3 is used as a Hack to avoid Rage decay triggering
            if state.talent.anger_management.enabled then
                rageSpent = ( rageSpent + ( lastRage - current ) ) % 20
            end
            if state.legendary.glory.enabled and FindPlayerAuraByID( 324143 ) then
                gloryRage = ( gloryRage + lastRage - current ) % 25
            end 
        end
        lastRage = current
    end
end )

spec:RegisterStateExpr( "rage_spent", function ()
    return rageSpent
end )

spec:RegisterStateExpr( "glory_rage", function ()
    return gloryRage
end )

spec:RegisterHook( "prespend", function( amt, resource, overcap, clean )
    if buff.recklessness.up and resource == "rage" and amt < 0 then
        return amt * 2, resource, overcap, true
    end
end )

spec:RegisterHook( "spend", function( amt, resource )
    if resource == "rage" then
        if talent.anger_management.enabled then
            rage_spent = rage_spent + amt
            local reduction = floor( rage_spent / 20 )
            rage_spent = rage_spent % 20
            if reduction > 0 then
                cooldown.recklessness.expires = cooldown.recklessness.expires - reduction
                cooldown.ravager.expires = cooldown.ravager.expires - reduction
                cooldown.bladestorm.expires = cooldown.bladestorm.expires - reduction
            end
        end

        if legendary.glory.enabled and buff.conquerors_banner.up then
            glory_rage = glory_rage + amt
            local addition = floor( glory_rage / 10 ) * 0.5
            glory_rage = glory_rage % 10
		  if addition > 0 then buff.conquerors_banner.expires = buff.conquerors_banner.expires + addition end
        end
    end
end )


local WillOfTheBerserker = setfenv( function()
    applyBuff( "will_of_the_berserker" )
end, state )

spec:RegisterHook( "reset_precast", function ()
    rage_spent = nil
    glory_rage = nil

    if legendary.will_of_the_berserker.enabled and buff.recklessness.up then
        state:QueueAuraExpiration( "recklessness", WillOfTheBerserker, buff.recklessness.expires )
    end

    active_dot.hit_by_fresh_meat = 0

    for k, v in pairs( fresh_meat_actual ) do
        if k == target.unit then
            applyDebuff( "target", "hit_by_fresh_meat" )
        else
            active_dot.hit_by_fresh_meat = active_dot.hit_by_fresh_meat + 1
        end
    end

    -- Will need to revisit this if `cancel_buff` is added to the APL.
    if buff.bladestorm.up then
        -- channelSpell( "bladestorm", buff.bladestorm.expires - class.auras.bladestorm.duration, class.auras.bladestorm.duration, class.abilities.bladestorm.id )
        setCooldown( "bladestorm", buff.bladestorm.remains )
    end
end )




spec:RegisterStateExpr( "cycle_for_execute", function ()
    if active_enemies == 1 or target.health_pct < ( talent.massacre.enabled and 35 or 20 ) or not settings.cycle or buff.execute_ineligible.down or buff.sudden_death.up then return false end
    return Hekili:GetNumTargetsBelowHealthPct( talent.massacre.enabled and 35 or 20, false, max( settings.cycle_min, offset + delay ) ) > 0
end )


spec:RegisterStateExpr( "cycle_for_condemn", function ()
    if active_enemies == 1 or target.health_pct < ( talent.massacre.enabled and 35 or 20 ) or target.health_pct > 80 or not settings.cycle or not action.condemn.known or buff.condemn_ineligible.down or buff.sudden_death.up then return false end
    return Hekili:GetNumTargetsBelowHealthPct( talent.massacre.enabled and 35 or 20, false, max( settings.cycle_min, offset + delay ) ) > 0 or Hekili:GetNumTargetsAboveHealthPct( 80, false, max( settings.cycle_min, offset + delay ) ) > 0
end )

-- Abilities
spec:RegisterAbilities( {
    avatar = {
        id = 107574,
        cast = 0,
        cooldown = 90,
        gcd = "off",

        spend = -10,
        spendType = "rage",

        talent = "avatar",
        startsCombat = false,
        texture = 613534,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "avatar" )
            if talent.berserkers_torment.enabled then applyBuff( "recklessness", 8 ) end
            if talent.titans_torment.enabled then
                applyBuff( "odyns_fury" )
                active_dot.odyns_fury = max( active_dot.odyns_fury, active_enemies )
                if talent.titanic_rage.enabled then
                    applyBuff ( "enrage" )
                    applyBuff ( "whirlwind", nil, talent.meat_cleaver.enabled and 4 or 2 )
                end
            end
            if talent.avatar_of_the_storm.enabled then
                addStack( "thunder_blast" , nil,  2 )
                reduceCooldown( "thunder_clap", 6) -- resets cooldown of TC entirely
            end
        end,
    },


    battle_shout = {
        id = 6673,
        cast = 0,
        cooldown = 15,
        gcd = "spell",

        startsCombat = false,
        texture = 132333,

        essential = true,
        nobuff = "battle_shout",

        handler = function ()
            applyBuff( "battle_shout" )
        end,
    },


    berserker_rage = {
        id = 18499,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        startsCombat = false,
        texture = 136009,

        --toggle = "defensives",
        --Not yet Implemented in LossOfControl via Classes.lua
        --usable = function () return ( debuff.sap.up or debuff.incapacitate.up or debuff.fear.up ) , "requires fear/incapacitate/sap debuff" end,

        handler = function ()
            applyBuff( "berserker_rage" )
        end,
    },


    berserker_shout = {
        id = 384100,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        talent = "berserker_shout",
        startsCombat = false,
        texture = 136009,

        --Not yet Implemented in LossOfControl via Classes.lua
        --toggle = "defensives",
        --usable = function () return ( debuff.sap.up or debuff.incapacitate.up or debuff.fear.up ) , "requires fear/incapacitate/sap debuff" end,

        handler = function ()
            applyBuff( "berserker_shout" )
        end,
    },


    berserker_stance = {
        id = 386196,
        cast = 0,
        cooldown = 3,
        gcd = "off",

        talent = "berserker_stance",
        startsCombat = false,
        essential = true,

        nobuff = "stance",

        handler = function ()
            applyBuff( "berserker_stance" )
            removeBuff( "defensive_stance" )
        end,
    },


    bitter_immunity = {
        id = 383762,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        talent = "bitter_immunity",
        startsCombat = false,
        texture = 136088,

        toggle = "cooldowns",

        handler = function ()
            gain( 0.2 * health.max, "health" )
        end,
    },

    bladestorm = {
        id = function() return talent.unrelenting_onslaught.enabled and 446035 or 227847 end,
        cast = 0,
        cooldown = 90,
        gcd = "spell",

        talent = "bladestorm",
        startsCombat = true,
        texture = 236303,
        range = 8,
        charges = function () if talent.storm_of_steel.enabled then return 2 end end,

        spend = -20,
        spendType = "rage",

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "bladestorm" )
            setCooldown( "global_cooldown", class.auras.bladestorm.duration )
            if talent.blademasters_torment.enabled then applyBuff( "avatar", 4 ) end
            if talent.merciless_bonegrinder.enabled then
                state:QueueAuraExpiration( "bladestorm_merciless_bonegrinder", ExpireBladestorm, buff.bladestorm.expires )
            end
            if talent.overwhelming_blades.enabled then applyDebuff( "target", "overwhelmed", nil, 10 ) end

            if talent.brutal_finish.enabled then applyBuff( "brutal_finish" ) end
            removeBuff( "imminent_demise" )
        end,

        copy = { 227847, 389774, 446035 }
    },


    bloodbath = {
        id = 335096,
        known = 23881,
        flash = 23881,
        cast = 0,
        cooldown = function () return buff.burst_of_power.up and 0 or ( 4.5 ) * haste end,
        gcd = "spell",

        spend = function()
            return -8
            + ( -2 * buff.merciless_assault.stack )
            + ( talent.cold_steel_hot_blood.enabled and action.bloodthirst.crit_pct_current >= 100 and -4 or 0 )
            + ( buff.burst_of_power.up and -2 or 0 )
            + ( -1 * talent.swift_strikes.rank )
            + ( buff.double_down_rb.up and -2 or 0 )
        end,
        spendType = "rage",

        cycle = function () return talent.fresh_meat.enabled and "hit_by_fresh_meat" or nil end,

        startsCombat = true,
        texture = 236304,
        talent = "reckless_abandon",
        buff = "recklessness",
        bind = "bloodthirst",

        critical = function()
            return stat.crit
            + ( 15 * buff.bloodcraze.stack )
            + ( 12 * buff.merciless_assault.stack )
            + ( 20 * buff.recklessness.stack )
            + ( talent.crushing_force.enabled and talent.crushing_force.rank * 2 or 0 )
        end,

        handler = function()
            removeStack( "whirlwind" )
            if buff.enrage.up and talent.deft_experience.enabled then
                buff.enrage.remains = buff.enrage.remains + ( 0.5 * talent.deft_experience.rank )
            end

            if talent.cold_steel_hot_blood.enabled and action.bloodthirst.crit_pct_current >= 100 then
                applyDebuff( "target", "gushing_wound" )
                gain( 4, "rage" )
            end

            if set_bonus.tier31_4pc > 0 and action.bloodthirst.crit_pct_current >= 100 then
                reduceCooldown( "odyns_fury", 2.5 )
            end

            removeBuff( "merciless_assault" )
            if talent.bloodcraze.enabled then
                if action.bloodthirst.crit_pct_current >= 100 then removeBuff( "bloodcraze" )
                else addStack( "bloodcraze" ) end
            end

            -- Always extends by 6 seconds or applies a 6 second one
            applyDebuff( "target", "bloodbath_dot", debuff.bloodbath_dot.remains + 6 )

            gain( health.max * ( buff.enraged_regeneration.up and 0.23 or 0.03 ) , "health" )

            if talent.fresh_meat.enabled and debuff.hit_by_fresh_meat.down then
                applyBuff( "enrage" )
                applyDebuff( "target", "hit_by_fresh_meat" )
            end

            if legendary.cadence_of_fujieda.enabled then
                if buff.cadence_of_fujieda.stack < 5 then stat.haste = stat.haste + 0.01 end
                addStack( "cadence_of_fujieda" )
            end

            removeBuff( "double_down_bt" )
        end,
    },


    bloodrage = {
        id = 329038,
        cast = 0,
        cooldown = 20,
        gcd = "off",

        spend = function() return 0.05 * health.max end,
        spendType = "health",

        pvptalent = "bloodrage",
        startsCombat = false,
        texture = 132277,

        handler = function ()
            applyBuff ( "bloodrage" )
        end,
    },


    bloodthirst = {
        id = 23881,
        cast = 0,
        cooldown = function () return buff.burst_of_power.up and 0 or ( 4.5 - ( talent.titans_torment.enabled and buff.avatar.up and 1.5 or 0 ) ) * haste end,
        gcd = "spell",

        spend = function()
            return -8
            + ( -2 * buff.merciless_assault.stack )
            + ( talent.cold_steel_hot_blood.enabled and action.bloodthirst.crit_pct_current >= 100 and -4 or 0 )
            + ( buff.burst_of_power.up and -2 or 0 )
            + ( -1 * talent.swift_strikes.rank )
        end,
        spendType = "rage",

        cycle = function () return talent.fresh_meat.enabled and "hit_by_fresh_meat" or nil end,

        talent = "bloodthirst",
        texture = 136012,
        nobuff = function() if talent.reckless_abandon.enabled then return "recklessness" end end,
        startsCombat = true,
        bind = "bloodbath",

        critical = function()
            return stat.crit
            + ( 15 * buff.bloodcraze.stack )
            + ( 12 * buff.merciless_assault.stack )
            + ( 20 * buff.recklessness.stack )
            + ( talent.crushing_force.enabled and talent.crushing_force.rank * 2 or 0 )
        end,
        handler = function()
            removeStack( "whirlwind" )
            if buff.enrage.up and talent.deft_experience.enabled then
                buff.enrage.remains = buff.enrage.remains + ( 0.5 * talent.deft_experience.rank )
            end

            if talent.cold_steel_hot_blood.enabled and action.bloodthirst.crit_pct_current >= 100 then
                applyDebuff( "target", "gushing_wound" )
            end

            if talent.bloodcraze.enabled and action.bloodthirst.crit_pct_current >= 100 then removeBuff( "bloodcraze" ) end

            gain( health.max * ( buff.enraged_regeneration.up and 0.23 or 0.03 ) , "health" )

            if talent.fresh_meat.enabled and debuff.hit_by_fresh_meat.down then
                applyBuff( "enrage" )
                applyDebuff( "target", "hit_by_fresh_meat" )
            end

            -- Legacy
            if set_bonus.tier30_4pc > 0 then removeBuff( "merciless_assault" ) end
            if set_bonus.tier31_4pc > 0 and action.bloodthirst.crit_pct_current >= 100 then
                reduceCooldown( "odyns_fury", 2.5 )
            end
            if legendary.cadence_of_fujieda.enabled then
                if buff.cadence_of_fujieda.stack < 5 then stat.haste = stat.haste + 0.01 end
                addStack( "cadence_of_fujieda" )
            end
            removeBuff( "double_down_bt" )
        end,

        auras = {
            cadence_of_fujieda = {
                id = 335558,
                duration = 12,
                max_stack = 5,
            },
            hit_by_fresh_meat = {
                duration = 3600,
                max_stack = 1,
            }
        },
    },

    
    champions_spear = {
        id = function() return talent.champions_spear.enabled and 376079 or 307865 end,
        cast = 0,
        cooldown = 90,
        gcd = "spell",

        spend = function () return ( -10 * ( talent.piercing_challenge.enabled and 2 or 1 ) ) * ( 1 + conduit.piercing_verdict.mod * 0.01 ) end,
        spendType = "rage",

        startsCombat = true,
        toggle = "cooldowns",
        velocity = 30,

        handler = function ()
            applyDebuff( "target", "champions_spear" )
            if talent.champions_might.enabled or legendary.elysian_might.enabled then applyBuff( "elysian_might" ) end
        end,

        copy = { "spear_of_bastion", 307865, 376079 }
    },


    charge = {
        id = 100,
        cast = 0,
        charges = function () return talent.double_time.enabled and 2 or nil end,
        cooldown = function () return talent.double_time.enabled and 17 or 20 end,
        recharge = function () return talent.double_time.enabled and 17 or 20 end,
        gcd = "off",

        spend = -20,
        spendType = "rage",

        startsCombat = true,
        texture = 132337,

        usable = function () return target.minR >= ( settings.charge_min_range or 8 ) and ( query_time - action.charge.lastCast > gcd.execute ), "target too close" end,
        handler = function ()
            applyDebuff( "target", "charge" )
            setDistance( 5 )
        end,
    },


    crushing_blow = {
        id = 335097,
        known = 85288,
        flash = 85288,
        cast = 0,
        charges = function () return
              ( talent.raging_blow.enabled and 1 or 0 )
            + ( talent.improved_raging_blow.enabled and 1 or 0 )
        end,
        cooldown = function() return 7 * haste end,
        recharge = function() return 7 * haste end,
        gcd = "spell",

        spend = function () return -12 - talent.swift_strikes.rank end,
        spendType = "rage",

        startsCombat = true,
        texture = 132215,

        talent = "reckless_abandon",
        buff = "recklessness",
        bind = "raging_blow",

        handler = function ()
            removeStack( "whirlwind" )
            removeBuff( "opportunist" )
            spendCharges( "raging_blow", 1 )
            if buff.will_of_the_berserker.up then buff.will_of_the_berserker.expires = query_time + 12 end

            removeBuff( "double_down_rb" )
        end,
    },


    death_wish = {
        id = 199261,
        cast = 0,
        cooldown = 5,
        gcd = "spell",

        spend = 6777,
        spendType = "health",

        pvptalent = "death_wish",
        startsCombat = false,
        texture = 136146,

        handler = function ()
            addStack( "death_wish" )
        end,
    },


    defensive_stance = {
        id = 386208,
        cast = 0,
        cooldown = 3,
        gcd = "off",

        startsCombat = false,
        nobuff = "stance",

        handler = function ()
            applyBuff( "defensive_stance" )
            removeBuff( "berserker_stance" )
        end,
    },


    disarm = {
        id = 236077,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        pvptalent = "disarm",
        startsCombat = false,
        texture = 132343,

        handler = function ()
            applyDebuff( "target", "disarm" )
        end,
    },


    enraged_regeneration = {
        id = 184364,
        cast = 0,
        cooldown = function () return 120 - ( conduit.stalwart_guardian.enabled and 20 or 0 ) - ( talent.honed_reflexes.enabled and 15*0.05 or 0 ) end,
        gcd = "off",

	    toggle = "defensives",

        talent = "enraged_regeneration",
        startsCombat = false,
        texture = 132345,

        handler = function ()
            applyBuff( "enraged_regeneration" )
            if ( talent.invigorating_fury.enabled ) then gain( health.max * 0.10 , "health" ) end
        end,
    },


    execute = {
        id = function () return talent.massacre.enabled and 280735 or 5308 end,
	    known = 5308,
        noOverride = 317485,
        cast = 0,
        cooldown = function () return ( talent.massacre.enabled and 4.5 or 6 ) end,
	    hasteCD = true,
        gcd = "spell",

        spend = function () return ( talent.improved_execute.enabled and -20 or 0 ) end,
        spendType = "rage",

        startsCombat = true,
        texture = 135358,

        usable = function ()
            if buff.sudden_death.up then return true end
            if cycle_for_execute then return true end
            return target.health_pct < ( talent.massacre.enabled and 35 or 20 ), "requires target in execute range"
        end,

        cycle = "execute_ineligible",

        indicator = function () if cycle_for_execute then return "cycle" end end,

        handler = function ()
            removeDebuff( "target", "marked_for_execution" )
            if not buff.sudden_death.up and not buff.stone_heart.up and not talent.improved_execute.enabled then -- Execute costs rage
                local cost = min( rage.current, 40 )
                spend( cost, "rage", nil, true )
            else
                removeBuff( "sudden_death" )
                if talent.imminent_demise.enabled then
                    addStack( "imminent_demise" )
                end
            end

            removeStack( "whirlwind" )
            if talent.ashen_juggernaut.enabled then applyBuff( "ashen_juggernaut" ) end
        end,

        copy = { 280735, 5308 },

        auras = {
            -- Target Swapping
            execute_ineligible = {
                duration = 3600,
                max_stack = 1,
                generate = function( t, auraType )
                    if buff.sudden_death.down and buff.stone_heart.down and target.health_pct > ( talent.massacre.enabled and 35 or 20 ) then
                        t.count = 1
                        t.expires = query_time + 3600
                        t.applied = query_time
                        t.duration = 3600
                        t.caster = "player"
                        return
                    end
                    t.count = 0
                    t.expires = 0
                    t.applied = 0
                    t.caster = "nobody"
                end
            }
        }
    },


    hamstring = {
        id = 1715,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 10,
        spendType = "rage",

        startsCombat = true,
        texture = 132316,

        handler = function ()
            applyDebuff ( "target", "hamstring" )
        end,
    },


    heroic_leap = {
        id = 6544,
        cast = 0,
        cooldown = function () return talent.bounding_stride.enabled and 30 or 45 end,
        charges = function () return legendary.leaper.enabled and 3 or nil end,
        recharge = function () return legendary.leaper.enabled and ( talent.bounding_stride.enabled and 30 or 45 ) or nil end,
        gcd = "off",

        talent = "heroic_leap",
        startsCombat = false,
        texture = 236171,

        usable = function () return ( query_time - action.heroic_leap.lastCast > gcd.execute ) end,
        handler = function ()
            setDistance( 15 ) -- probably heroic_leap + charge combo.
            if talent.bounding_stride.enabled then applyBuff( "bounding_stride" ) end
        end,

        copy = 52174
    },


    heroic_throw = {
        id = 57755,
        cast = 0,
        cooldown = 1,
        gcd = "spell",

        startsCombat = true,
        texture = 132453,

        handler = function ()
        end,
    },


    impending_victory = {
        id = 202168,
        cast = 0,
        cooldown = 25,
        gcd = "spell",

        spend = 10,
        spendType = "rage",

        startsCombat = true,
        texture = 589768,

        talent = "impending_victory",

        handler = function ()
            gain( health.max * 0.3, "health" )
            removeStack( "whirlwind" )
            if conduit.indelible_victory.enabled then applyBuff( "indelible_victory" ) end
            if talent.steadfast_as_the_peaks.enabled then applyBuff( "steadfast_as_the_peaks" ) end
        end,
    },


    intervene = {
        id = 3411,
        cast = 0,
        cooldown = function() return 30 - ( talent.honed_reflexes.enabled and 30*0.05 or 0 ) end,
        gcd = "off",

        talent = "intervene",
        startsCombat = false,
        texture = 132365,

        handler = function ()
        end,
    },


    intimidating_shout = {
        id = function () return talent.menace.enabled and 316593 or 5246 end,
        copy = { 316593, 5246 },
        cast = 0,
        cooldown = 90,
        gcd = "spell",

        talent = "intimidating_shout",
        startsCombat = true,
        texture = 132154,

        toggle = "cooldowns",

        handler = function ()
            applyDebuff( "target", "intimidating_shout" )
            active_dot.intimidating_shout = max( active_dot.intimidating_shout, active_enemies )
        end,
    },


    odyns_fury = {
        id = 385059,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        talent = "odyns_fury",
        startsCombat = false,
        texture = 1278409,

        spend = 15,
        spendType = "rage",

        handler = function ()
            applyDebuff( "target", "odyns_fury" )
            active_dot.odyns_fury = max( active_dot.odyns_fury, active_enemies )
            if talent.dancing_blades.enabled then applyBuff( "dancing_blades" ) end
            if talent.titanic_rage.enabled then
                applyBuff( "enrage" )
                applyBuff( "whirlwind", nil, talent.meat_cleaver.enabled and 4 or 2 )
            end
            if talent.titans_torment.enabled then applyBuff( "avatar", 4 ) end

            if state.spec.fury and set_bonus.tier31_2pc > 0 then
                applyBuff( "furious_bloodthirst", nil, 3 )
            end

            -- PvP
            if pvptalent.slaughterhouse.enabled then applyDebuff( "target", "slaughterhouse", nil, debuff.slaughterhouse.stack + 1 ) end
        end,
    },


    onslaught = {
        id = 315720,
        cast = 0,
        cooldown = 18,
        hasteCD = true,
        gcd = "spell",

        spend = -30,
        spendType = "rage",

        talent = "onslaught",
        startsCombat = true,
        texture = 132364,

        handler = function ()
            removeStack( "whirlwind" )
            if pvptalent.slaughterhouse.enabled then applyDebuff( "target", "slaughterhouse", nil, debuff.slaughterhouse.stack + 1 ) end
            if talent.tenderize.enabled then
                applyBuff( "enrage" )
                addStack( "slaughtering_strikes", nil, 3 )
            end
        end,
    },


    piercing_howl = {
        id = 12323,
        cast = 0,
        cooldown = function () return 30 - ( conduit.disturb_the_peace.enabled and 5 or 0 ) end,
        gcd = "spell",

        talent = "piercing_howl",
        startsCombat = true,
        texture = 136147,

        handler = function ()
            applyDebuff( "target", "piercing_howl" )
            active_dot.piercing_howl = max( active_dot.piercing_howl, active_enemies )
        end,
    },


    pummel = {
        id = 6552,
        cast = 0,
        cooldown = function () return 15 - ( talent.concussive_blows.enabled and 1 or 0 ) - - ( talent.honed_reflexes.enabled and 15*0.05 or 0 ) end,
        gcd = "off",

        startsCombat = true,
        texture = 132938,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
            if talent.concussive_blows.enabled then
                applyDebuff( "target", "concussive_blows" )
            end
        end,
    },


    raging_blow = {
        id = 85288,
        cast = 0,
        charges = function () if talent.improved_raging_blow.enabled then return 2 end end,
        cooldown = 8,
        hasteCD = true,
        recharge = function () if talent.improved_raging_blow.enabled then return 8 * haste end end,
        gcd = "spell",

        spend = function () return -12 - talent.swift_strikes.rank - ( buff.double_down_rb.up and 2 or 0 )end,
        spendType = "rage",

        talent = "raging_blow",
        texture = 589119,
        startsCombat = true,
        nobuff = function() if talent.reckless_abandon.enabled then return "recklessness" end end,
        bind = "crushing_blow",

        handler = function ()
            removeStack( "whirlwind" )
            spendCharges( "crushing_blow", 1 )
            removeBuff( "opportunist" )
            if buff.will_of_the_berserker.up then buff.will_of_the_berserker.expires = query_time + 12 end
            if talent.slaughtering_strikes.enabled then addStack( "slaughtering_strikes_raging_blow" ) end
            removeBuff( "double_down_rb" )
        end,
    },


    rallying_cry = {
        id = 97462,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        talent = "rallying_cry",
        startsCombat = false,
        texture = 132351,

        toggle = "cooldowns",
        shared = "player",

        handler = function ()
            applyBuff( "rallying_cry" )

            gain( 0.10 * health.max, "health" )
        end,
    },


    rampage = {
        id = 184367,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return 80 - ( talent.titans_torment.enabled and buff.avatar.up and 20 or 0 ) end,
        spendType = "rage",

        startsCombat = true,
        texture = 132352,
        talent = "rampage",

        handler = function ()
            applyBuff( "enrage" )
            removeStack( "whirlwind" )
            removeBuff( "slaughtering_strikes" )
            if talent.frenzy.enabled then addStack( "frenzy" ) end -- TODO: resets on target swap
            removeBuff( "brutal_finish" )

            -- PvP
            if pvptalent.slaughterhouse.enabled then applyDebuff( "target", "slaughterhouse", nil, debuff.slaughterhouse.stack + 1 ) end

            -- Legacy
            if set_bonus.tier30_4pc > 0 then addStack( "merciless_assault" ) end
        end,
    },


    ravager = {
        id = 228920,
        cast = 0,
        charges = function () return ( talent.storm_of_steel.enabled and 2 or 1 ) end,
        cooldown = 90,
        recharge = 90,
        gcd = "spell",

        talent = "ravager",
        startsCombat = true,
        texture = 970854,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "ravager" )
        end,
    },


    recklessness = {
        id = 1719,
        cast = 0,
        cooldown = 90,
        gcd = "off",

        toggle = "cooldowns",
        spend = function() return talent.reckless_abandon.enabled and -50 or 0 end,
        spendType = "rage",

        talent = "recklessness",
        startsCombat = false,
        texture = 458972,

        handler = function ()
            applyBuff( "recklessness" )
            if talent.berserkers_torment.enabled then applyBuff( "avatar", 8 ) end

            if talent.snap_induction.enabled then addStack( "thunder_blast " ) end
            if legendary.will_of_the_berserker.enabled then
                state:QueueAuraExpiration( "recklessness", WillOfTheBerserker, buff.recklessness.expires )
            end
        end,

        auras = {
            will_of_the_berserker = { -- Shadowlands Legendary
                id = 335597,
                duration = 12,
                max_stack = 1
            }
        }
    },

    shattering_throw = {
        id = 64382,
        cast = 1.5,
        cooldown = 180,
        gcd = "spell",

        talent = "shattering_throw",
        startsCombat = true,
        texture = 311430,

        range = 30,
        toggle = "cooldowns",
    },


    shockwave = {
        id = 46968,
        cast = 0,
        cooldown = function () return ( ( talent.rumbling_earth.enabled and active_enemies >= 3 ) and 25 or 40 ) end,
        gcd = "spell",

        talent = "shockwave",
        startsCombat = true,
        texture = 236312,

        toggle = "interrupts",
        debuff = function () return settings.shockwave_interrupt and "casting" or nil end,
        readyTime = function () return settings.shockwave_interrupt and timeToInterrupt() or nil end,

        usable = function () return not target.is_boss end,

        handler = function ()
            applyDebuff( "target", "shockwave" )
            active_dot.shockwave = max( active_dot.shockwave, active_enemies )
            if not target.is_boss then interrupt() end
        end,
    },


    slam = {
        id = 1464,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        startsCombat = true,
        texture = 132340,

        handler = function ()
            removeStack( "whirlwind" )
        end,
    },


    storm_bolt = {
        id = 107570,
        cast = 0,
        cooldown = function() return 30 + ( talent.storm_bolts.enabled and 10 or 0 ) - ( talent.honed_reflexes.enabled and 30*0.05 or 0 ) end,
        gcd = "spell",

        startsCombat = true,
        texture = 613535,

        talent = "storm_bolt",

        -- Add usable check for Unrelenting Onslaught talent
        usable = function()
            if buff.bladestorm.up and not talent.unrelenting_onslaught.enabled then 
                return false, "can't use during bladestorm without unrelenting onslaught" 
            end
            return true
        end,

        handler = function ()
            applyDebuff( "target", "storm_bolt" )
        end,
    },


    taunt = {
        id = 355,
        cast = 0,
        cooldown = 8,
        gcd = "off",

        startsCombat = true,
        texture = 136080,

        handler = function ()
            applyDebuff( "target", "taunt" )
        end,
    },

    thunder_blast = {
        id = 435222,
        flash = 6343,
        cast = 0,
        cooldown = 6,
        gcd = "spell",
        hasteCD = true,

        spend = 10,
        spendType = "rage",

        talent = "thunder_blast",
        buff = "thunder_blast",
        startsCombat = true,
        texture = 460957,

        handler = function ()
            if ( talent.crashing_thunder.enabled ) then
                if ( talent.improved_whirlwind.enabled ) then
                    applyBuff ( "whirlwind", nil, talent.meat_cleaver.enabled and 4 or 2 )
                end
            end
            applyDebuff( "target", "thunder_clap" )
            active_dot.thunder_clap = max( active_dot.thunder_clap, active_enemies )
            removeStack( "thunder_blast" )
        end,

        bind = "thunder_clap"
    },

    thunder_clap = {
        id = 6343,
        cast = 0,
        cooldown = 6,
        gcd = "spell",
        hasteCD = true,

        spend = 8,
        spendType = "rage",

        talent = "thunder_clap",
        nobuff = "thunder_blast",
        startsCombat = true,
        texture = 136105,

        handler = function ()
            if talent.crashing_thunder.enabled and talent.improved_whirlwind.enabled then
                applyBuff ( "whirlwind", nil, talent.meat_cleaver.enabled and 4 or 2 )
            end

            applyDebuff( "target", "thunder_clap" )
            active_dot.thunder_clap = max( active_dot.thunder_clap, active_enemies )
        end,

        bind = "thunder_blast",
    },


    thunderous_roar = {
        id = 384318,
        cast = 0,
        cooldown = function() return 90 - ( talent.uproar.enabled and 45 or 0 ) end,
        gcd = "spell",

        spend = -10,
        spendType = "rage",

        talent = "thunderous_roar",
        startsCombat = true,
        texture = 642418,

        toggle = "cooldowns",

        handler = function ()
            applyDebuff( "target", "thunderous_roar" )
            active_dot.thunderous_roar = max( active_dot.thunderous_roar, active_enemies )
        end,
    },



    victory_rush = {
        id = 34428,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        startsCombat = true,
        texture = 132342,

        notalent = "impending_victory",
        buff = "victorious",

        handler = function ()
            removeBuff( "victorious" )
            removeStack( "whirlwind" )
            gain( 0.2 * health.max, "health" )
            if conduit.indelible_victory.enabled then applyBuff( "indelible_victory" ) end
            if talent.steadfast_as_the_peaks.enabled then applyBuff( "steadfast_as_the_peaks" ) end
        end,
    },


    whirlwind = {
        id = 190411,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        startsCombat = true,

        spend = function() return talent.improved_whirlwind.enabled and ( -3 - min( 5, active_enemies ) ) or 0 end,
        spendType = "rage",

        texture = 132369,

        usable = function ()
            if settings.check_ww_range and target.distance > 8 then return false, "target is outside of whirlwind range" end
        end,

        -- Modify Syrif's solution; in multi-target using WW while Meat Cleaver is up is fine; the restriction was only intended for single-target.
        -- Checking both active_enemies and true_active_enemies lets WW slip through with Meat Cleaver up when single-target mode is active but there are actually more targets.
        nobuff = function()
            if max( active_enemies, true_active_enemies ) > 1 then return end
            return "meat_cleaver"
        end,

        handler = function ()
            if talent.improved_whirlwind.enabled then
                applyBuff( "meat_cleaver", nil, talent.meat_cleaver.enabled and 4 or 2 )
            end
        end,
    },


    wrecking_throw = {
        id = 384110,
        cast = 0,
        cooldown = function () return pvptalent.demolition.enabled and 22.5 or 45 end,
        gcd = "spell",

        talent = "wrecking_throw",
        startsCombat = true,
        texture = 460959,

        handler = function ()
        end,
    },
} )

local NewFeature = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0|t"

spec:RegisterSetting( "spell_reflection_filter", true, {
    name = format( "%s 大秘境 |T132361:0|t 法术反射", NewFeature ),
    desc = "如果勾选，插件只会在可反射的法术目标是你时，推荐使用 |T132361:0|t 法术反射。",
    type = "toggle",
    width = "full",
} )

spec:RegisterSetting( "check_ww_range", false, {
    name = "监测|T132369:0|t旋风斩攻击范围",
    desc = "如果勾选，当你的目标超出|T132369:0|t旋风斩的攻击范围时，将不会推荐此技能。",
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "shockwave_interrupt", true, {
    name = "|T236312:0|t震荡波仅用于打断（天赋支持时）",
    desc = "如果勾选，|T236312:0|t震荡波将只在你的目标施法时被推荐。",
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "charge_min_range", 10, {
    name = strformat( "%s 最小距离", Hekili:GetSpellLinkWithTexture( spec.abilities.charge.id ) ),
    desc = strformat( "如果目标比设置的距离更近，|W%s|w将不会被推荐。", Hekili:GetSpellLinkWithTexture( spec.abilities.charge.id ) ),
    type = "range",
    min = 8,
    max = 25,
    step = 1,
    width = "full",
} )


spec:RegisterSetting( "t30_bloodthirst_crit", 95, {
    name = strformat( "%s 爆击阈值（T30）", Hekili:GetSpellLinkWithTexture( spec.abilities.bloodthirst.id ) ),
    desc = strformat( "默认情况下，如果你装备了四件T30套装，当爆击阈值几率为|cFFFFD10095%%|r或更高时，将会推荐|W%s|w 和 |W%s|w。\n\n"
            .. "你的套装效果、%s 都可以超过95%%的阈值。如果有|W%s|w 的天赋支撑，还会产生 %s 的额外伤害。"
            .. "如果你的爆击几率很低，稍微降低此处的百分比可能会有帮助。然而如果设置得太低，你可能在使用这些技能时，无法形成爆击。"
            .. "",
            spec.abilities.bloodthirst.name, spec.abilities.bloodbath.name, Hekili:GetSpellLinkWithTexture( spec.auras.recklessness.id ),
            Hekili:GetSpellLinkWithTexture( spec.auras.bloodcraze.id ), Hekili:GetSpellLinkWithTexture( spec.auras.gushing_wound.id ) ),
    type = "range",
    min = 0,
    max = 100,
    step = 1,
    width = "full",
} )

spec:RegisterStateExpr( "bloodthirst_crit_threshold", function()
    return settings.t30_bloodthirst_crit or 95
end )

spec:RegisterSetting( "heroic_charge", false, {
    name = "使用英勇冲锋连击",
    desc = "如果勾选，优先级配置将检查此项的状态，以确定是否能连续使用英勇飞跃+冲锋的连携。\n\n" ..
    "这样做通常会增加DPS，但不稳定的移动可能会破坏战斗手感的流畅性。",
    type = "toggle",
    width = "full",
} )



local LSR = LibStub( "SpellRange-1.0" )

spec:RegisterRanges( "hamstring", "bloodthirst", "execute", "storm_bolt", "charge", "heroic_throw", "taunt" )

spec:RegisterRangeFilter( strformat( "使用%s在不能使用%s时（8码）", Hekili:GetSpellLinkWithTexture( spec.abilities.taunt.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.charge.id ) ), function()
    return LSR.IsSpellInRange( spec.abilities.taunt.name ) == 1 and LSR.IsSpellInRange( class.abilities.charge.name ) ~= 0
end )

spec:RegisterOptions( {
    enabled = true,

    aoe = 2,

    nameplates = true,
    nameplateRange = 10,
    rangeFilter = true,

    damage = true,
    damageDots = false,
    damageExpiration = 8,

    potion = "tempered_potion",

    package = "狂暴Simc",
} )

spec:RegisterPack( "狂暴Simc", 20250308, [[Hekili:D31EVnUrs(plghII1ooAePSMXjWYa7T4oGm4qU)q5VffLeTf3HIulFmZ4ad9z)QUB(OFuv3uVMK9WUXXMDZFD117QjzLfEl(9fZ3ewgT438h7pD8KXpmAS30798wmV819rlMVpC9NdFb(L0WDWp)VRYFLDXxtYc3WU5ISQ81WaBll3x8lV)9VexUTA1O1z7EFr8UQKWY4S015HpxY(71VFX8vvXjL)A6IvOR84FEX8WQYTz5lMppE3)aqoEZMiX0JkwVyoB6)04j)04h(LdlN)A66dl)kSOWVdt)WNo8jXe8)jF2e(7B2eZiHWK6jSC92W0xIkuM5hqGc2M5zphNaBUW1mikgTppc2yRclF3S3d)SmjkOyBwv5HpHoJO8IO8phLhuugMUo6UYSxEjjAwwk(8)syEC4QKO7yS6zL5rHR3gLNvveuMhMwSlUSeWQ9ocwhwuE3xctQIM5JJyvruqCz0oRiIFRWV(5KOIIu4FUl(5z3e9VQI3VpAZONFnpeeRBdk3gfSbWCxEu6gkCc)syziXy6B440phvg4fe9T1jvBIQ3B1xFK3O4Irh1EahFFc89TI))XHL)xS5dASfhwgEyz9Tb)X6SSKnzFn9Udl3e)L4nrBoSC1RWKeB9LzS)zZRPWuFUkF0HL)6Zhwgx(JWFZPGdl3gc)EA2HL5r7cJ5mt4xlRYtpS0dGnkPiQ7kJhnD0XSH9ckav77Y2pRiQm(56TTN4FhWWEga5DRZsfMksCCGWcykrRQE(5b32D9MT8Onv5Cl8F4hAVKyB3oYSXV9w)UropkayrVkDZdpMDQ)PUt9j2P(N6o1(nE(7upoHwyyIiVnE7TBvhaCdvokm91Gn7lgCtdWJmm8okkXhLs8POe)(qj(NeLSppolpU8vD5VVS83ts6JXc4BMbiueFG3EJAKb3AvPPBmiOY6MTE74d)B36nA67uzsmChvaEKsFPClmdKLMPUpC4t3A10SBS(S2E9BT9Qx7Jra5fSlmTkmbZXEyYlrLBdH4Bv)XFaXvxL9TJbAFCO9pdOJ(w06QYOG9a)OjwXTLHjrPLJ2fwueUopAuuk7g2ma8dalYOTrHjLBhTFD5JtMoeChyCz)X9zTZsdEz9MG8W1XHjn2wCzICC5rm58a(LBCfXUqoKV2Jpmwmqrfl7PGnrqeBXW30QHSkjesPQmlFhaB4MxhCB3y17EXaV9wNPIcBzillQ6TdSj2xTBxuclDH6n(MiorWYujo9fgyRlLVbixmyE8BiEx0JmVZV92USVeTJXL3elsC6PPY3dl6C86GKOW9SB0C2(ktFFg73yZCvwbyM(C8lBldebAlEAYyWPnFaLRdsVbMS7Q9OZ1F6q5fSNjDbPua5u87cfvi8)VVnQnPIM0qlzxBlSyGucYcayI7G8p2uN3WDSPLa51UcMfSQW1FooNnZWu433hgNZUMaQ)UqbbLqlsYkBmz8yCks)IyEmfgEGUJSIy1(bsUKaXFata)eWSVb96dhOD3yE7QdkiHHWrzJslA43APeIN7M4fZ8gkNIcQtYNMPiZDYg9rzJ(KSrFNSrFc2O)rYg9qyJEeSrVJIn6puwa0p2iZgGLoCwAYRSFgX(bxBwYyaGILwTiVB2g8UMzWSpYGFMlUTwQ9WY)x4sXaWPrXIXDJ2QmMHIkoUKZCZf68iUfvzFGMmM2OWQ9M7vfZmat3JFBdvYx8ui33Etp146vfu52hTg8C9K)yCFLg2oKKPYURxePVlEQVfEQXQIztqkkgQK57PqUNlpLn3GTqaH(ve)GUPSIfVjLbsHfLnBolgAHHAZxTLWPseLuAgmEvqzwWM4ON88hp4wcE2tSXSjiTqtKccoOKUsjcvnSl5qjI)XzmQhlxYbul(dtRZjbbnpLeHsyEElc(NvBEHLVepJO)sMrzhjVk8LGSNH8MIx)5I)TGGfh5hKRlo1wTxz2jzzB4hdG8vHC4I4JiFrwITq5yHjbRdHu(4Xn7gno9lzFgkW9BqMLPWC4r142l7Z(AuEqC6ZvfnzblXRAuI8MQMs7tZ8MmvkuVYgEGUNl1SHNPM(DEvAG4VcsGe0fuvrs4Rr53vWeSLZeXqRRSIRLMcmWa2OFoQWjyqPDPrkyrdvxTxcs4DQh0jYWI9jdvjpcssu9ec7UZAMwhpVylOf(pRE5fMqQQKLEg(aTSsOgqeGHIM2TNDPGI9rcAJJtuktTNN1hU(DTS1xYvg24EFyqDDB7cZ)CeOHMLhi2nWQocQYA9NNnzicL1HggrvlwAyFbHRGWszPKU2M5FpZjj)MyhzFolmnagZ71aRsd2TIrFDN7gJ(UvLaBxRYyOosOct21hsrDiO)1TX5jFnweQLn6xatY0ODXrmcAqZrheXo6EO61VarBfCzPRW9p1dLjfFAcjIpI3UgnPpESq2OBIIM)PIw8UDXPataU8U4IibH)4KbwuhFuYDc6QztvTzDxLxbC)GNJtJl4ut9nLbC8VUnkzhKUJGw8gJP2ajCewbotKCUuYtxk(pIWxbmhnGvBO4WoUrxZtWYelcGANllbz90S7X8dKxvSLnxiAXxB05GDnGAZvhjoGLcMnpoN42BAoJMwVk7y(n5Kf5qdigPX(dCCHz)vUTIX1yNfsEgQNRB6l3889Uo501RQDbI6becCVc05Bjm(vwNh(hrnYspwrbcTOQ9m(WGnzLJAVZa2F1qK3pUXVHy8S80OH1YYoUM8F2CN4XoK0n6OqDDchAJpo97RwJKHdTgoK6mpRpG9oULNze1GV8g5psjhl3YoonP6mutjVEr(s86yMg96SuOmL9LeUCWezM6gGDQEKdm)FsSK6n9emhxMtZRLSncdBYBCRk8KBJGBj2PqS915XLbaZmyDvou(z5tZEykMcGIJoxR3XiQSHvpnEY2VplVScKYL4oQoFnjtLKEjQpkZG(q6hNG0o)Z(Qz3ZSnwyZdMX1JEbJV14toDvE8MeMtFiu164YxPVnAc9ytJWv(K1ZpEh74lbARDqKBKNavWQSezXwBIvmrD3nXRE6DuLb1mQ(BXr7Dbd8seYa1r6bzDOKYtN7pKKHPbzDI4r9iciRNTmAI16or9jrNozeZBXzLxM3YvPKJo2FRYRmWQX0AMSIfKWVGwQr9OC0bU2VM2tDQEwZZNJoDAfMRK1InBTLzXnI2GD3UtudrP57Be1w9o8aGg7fe1V(5ZrB7rSeYrXWdyH6AMovNB4P6k8H0Oiqn9jMzg9bSnasiM(Bb4WrMv(c56z3X2I5G)k2HZv)Iq67)WI5FnmNDWvflMZFSWGxFijJdlFM9QK9JCu(r27d2)Qs8iElY2bZcO)S6NpC9744OdF6)jM9m1U)xoS8FKLcReF4FeXLjayzg(qnVLdWuU17BdBrD6vb1hWrv2fPgQYdrHQ3yCy11a0G2Wzif8E4W35KsdyjpGuq6JdzJpnnaBUmjCe6a6ET0GvFys4)iHyRXzJUmR56Ka(Z4aQ7Zrdx9HPG3NqGD26dh(eIjRi1SJZMLW66cjViqxVub9TV2WuO)HRInmHk2z6VHYo701Cj8GjoShDZw(fpwO6omid3kndqQ4t5i8Yi5PSRUuMTtUQwf(ekUxkQ)66tBY1v0oHklI6AU1T90EhjnGJWfKz936MmgtGCjOYL4unTNqianllxdzZj0ZihBIEoSkHjYoIqhgAXMVUoT0x9qLQJz3B(1bo13qcdengUNGQ)MCGamYuUIG7ewI3breEm186f13)LHvswaf8grLnFpMW4kuAhFNGZZUYMXW9euN6dOt5kcUtyjEtnr4X9sz78xgRkBgo0ppxrFNG708tCvb3jSxywWjcNr82ZZBW3j4ont1Rk4oH9cZcor4mpMMZAxFDr3nUNMTzFP6td9oCnkv7S4g6u9LfD34EACJ(s1Ng6UX9SYdXc1EgPstDOdgVpLT4sm(XE0ExGfaTgQ2VZUF8OQIIorm6puCebO1j3RyN2(Y0rKT9FbPdXi)17sOuknCpbT18WsPgyZ5Qc)vd4)KO7S9rIzuaMbP0ITUpecm473x5UJ7e)ZC3H6Kd66KjlxuvFc3A1QWy4JoiULIICQEDXX)6H8FAuoTPbv)Fad)EAAy)o7PPXrrxNmz5IQCNVXzfWWbQY9kccK1MIk6gpENlI5SDuTsZOtrfDJNYXzAsCTXVpi33Z)PxhZ0fyDSEotwWFRE7XGqaRpNln(KQMuqFQzACTXVpi3pHAppq8lW6CAkpi9wfcpANMYt)XVVkpgHmVs9mh04sugRADSgn7HE2PCqtsKscRVIEoxXM(Jtd))7iF79F35BV)kW36ujnESZTA74n3hevEYjQQ8B8ePRrGQncH4z21kD4t)k)Sjy4FFZ3W7HLSpNv2jpSyEX(O1l(Tp6Vyo)ASESy75xa)XVXBzJIBBXC5Mq4I51NgYI)ZfLl(nF28eDCWfZzZT9E0AlHA33e291DL5z7bAkQS7(BezSFlPc(x(8RfiAqK9RTfYwO71wiR3F3YtnbaXPAiY(SeIaIDX8BoS0zRpOBjKFLDz4(bzwUi5AnM2hpAMMQYj5UwMX2yGu3)wyR7dN(6A7CIWwxF519NXx34NLz6ew9hwoaSgoS0MdLdl)bPUWIw9mhwo7WYXhw(2Bhdii120a0qrRfnpEVGP9xPg9iUkaZhjPqM3O7wmhU7wPUhtO5nMwQHbLPgGyzrKW(2LWibPoEjStqSlHTZA8oDdjDTBgrRQERxUhN)CdtPWi4xTnwnfBk45X)5uS)PtX6slDk2Savsk23bf7lrXerw6R6xtFMsZVovEvCsMkdkXEMEuH(Rtv43RmbLmFa(XHL)nogqgqhw(od(Bh)VDMe5FXNb8)FYGQq969ELj0BQsxpMMQ8KOkvdlpPKcyIC9y8hHskvsB42fIg4eFn1Zc4iwtQ03W1SLwZpC0RjtkI)EsY1(m(qAoS8r2RmjNPZDlIob)XYKQsBBHtNhFEk8Ijn)IPz0iFiPUUd)IS3FBoP8W4Ujz0bEA8N0Q9Q3hEAmbLNJs)4rWfKT)v2TAUJu7NMly5FoV(nRSnNA0ehlP7JLDmnrBVSnPBCGIzpTXhNXJQliEJoxj3cFAhUIpTDSKY7WfheFjuK6xMyPD3bfRns1W3vBtFmiNmUoGC700MtT(zJmx)Zl2196pLlZA5P822jww9NFDc6wRD3c302tMPyn8cE4hHFbjnyzdfgNyGQh8M3fgoBECRITTPm0WaSgx8GiTXO1Hw9fbGoHRwbfAyZMiZ8ST86Crrge6PzAAaGxOKSsjjasnvAsjFRsjFhsj)Jtk57wkHmLJsk5rlL8SjLmFxz6JuY3ukzKaJlPKpwfO2SLCLT2T2v6hGkM6T1spnw7nfszEGRUvJXqS6dUO7u2S0RRQM(ABzKIyeI6Imn80lU3MHN1nRjd702OKMw90YU3uiLTKv1cer6fENEwIuF0s)BKPmq4Th0J90YA2ryTl0Ezn50j2WEjbDgXQLF0TvXk4V70rB3gi5bYem1Dxtod3ZFCdvsiGALl9uvZ(EXQUG2s5kcIT8agQxNHYgNLfBZoNUqLb2j0hMQLsi6kXou(Mu(KfnyNaIuMS)BCrlnkIATRv0tq5)FTJv62ROhFGT9B1EJhXbuQw3jc0owBtxv7m89uoM)2UWQ(S(OYddqPTSQpv9CJu8W66DAfCBX4emCKEYeQnavXZiQUgxX3yoFH1JGl7h7cVQ8MrHOG6Acq)zuP80uu5q0wWs((mBVNl0FymwRqwO)B2EaLmoi64ncpDVSEZODHFRBrR1GDumnd4U(KJEqcZgGJiFBFnp8uZZ7dCiD2Kc5j7prXmtRjgHvITRTHJVQAh((zBZ7BIUy9lqwfi0(UBlCYosAzAyv73T5UTw(lT)KikSosqtwjeBUosO7zrGvkBhjWMFxlTPvhyqlvG1bd60CnAgwDuq7hAmwvAAcyZUjBtrIOHgKp2MpIAxq7aYenzlrYLXhDzmsRTVRdAJOvK5IQ8fZ(7r1ZxtMEOpir7TP2okZO1NkzMB0UAfjingNwSCwKeFT70uHKIDtdLYrcj3GBBjelKD)kHbW9sbpenKkhzdiMnwBbTrpUDTr5VImyO79y8B3YWdihvoJ36ajQoJL7SxDjR0xFX34uEP1L76s05YhRemEW1ePD)1Z4x4W6WPMEleRoWzx161DtcLgWIqws1oE5BY7hl7F2SHR0w6eI8s(sYyAKJr7Y7iFoADANwAWYo9pzTFjdwE6G0UZTzH)OqS2wvdxmpwrkznbdoPBu7eQpiFNpPi8cHD0ixC4(NsrcxdV2BhwMft1uWenUo(gJoAHetDYyCUcDyaPB2tHvyn3rtjsFvQFs1DHmrsh(4wR8Z6uvztxUh3kg8HPAzEkz26Ru3PQNET6GO9iFoQvu01hnQhMpKgn5W9QAJpM2M2wTON(wZPraPM(eANmxk3hQSJwnWj0opoD1p69PVsr4ssfv58KjgAd1GOnpA7N(iinFlhKoDrK3IbKa(tOtnYzNHcxG8bvwKyaTTTIXsd1OnhAtfQuTjsOEIZtUHUrs1bPsPF37OgjLodDhgD9q6f8d3rCoph7z70mp0xA2jQCFExGvBkh15RyPIzJ8Hf9Zv2s4iFBZ)JZIJLIpowWxFtIG3)xlTDefQBtdeKtRNolBkqqojiAn5VBhwIJKDL6X1Og1wotGgV5e9WZEvKZmPmznsnd1TLLdfOTgc9EbRkFd9qi0ieBzWJZNC84tqTT0BYSYboKpZnxpPI(f0UT(hA3a)1j)sVENTN6dAGk)llvnFKbvefkBpmN7hzG1mXSMbG7AvUruZTwNa31npHUqNpqMwKOgt3PfzTspRUrqDc4ReouniK2c3Z8Xe1ZypXe1kqu764YtS5)T4)l]] )