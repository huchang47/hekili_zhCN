-- WarriorProtection.lua
-- August 2025
-- Patch 11.2

if UnitClassBase( "player" ) ~= "WARRIOR" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State
local spec = Hekili:NewSpecialization( 73 )

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
local FindPlayerAuraByID = ns.FindPlayerAuraByID
local LSR = LibStub("SpellRange-1.0")
local base_rage_gen = 2


spec:RegisterResource( Enum.PowerType.Rage, {
    mainhand = {
        swing = "mainhand",

        last = function ()
            local swing = state.swings.mainhand
            local t = state.query_time

            return (  swing + floor( ( t - swing ) / state.swings.mainhand_speed )  * state.swings.mainhand_speed )
        end,

        interval = "mainhand_speed",

        stop = function () return state.time == 0 or state.swings.mainhand == 0 end,
        value = function ()
                return ( base_rage_gen * ( state.talent.war_machine.enabled and 1.5 or 1 ) ) + ( state.talent.instigate.enabled and 2 or 0 ) -- 2 Rage for instigate
        end
    },

    conquerors_banner = {
        aura = "conquerors_banner",

        last = function ()
            local app = state.buff.conquerors_banner.applied
            local t = state.query_time

            return app + floor( t - app )
        end,

        interval = 1,

        value = 4,
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
    armored_to_the_teeth           = {  90366,  384124, 2 }, -- Gain Strength equal to $s1% of your Armor
    avatar                         = {  90365,  107574, 1 }, -- Transform into a colossus for $s1 sec, causing you to deal $s2% increased damage and removing all roots and snares. Generates $s3 Rage
    barbaric_training              = {  90340,  383082, 1 }, -- Revenge deals $s1% increased damage. Thunder Clap deals $s2% increased damage
    battle_stance                  = {  90261,  386164, 1 }, -- A balanced combat state that increases the critical strike chance of your abilities by $s1% and reduces the duration of movement impairing effects by $s2%. Lasts until canceled
    berserker_shout                = {  90348,  384100, 1 }, -- Go berserk, removing and granting immunity to Fear, Sap, and Incapacitate effects for $s1 sec. Also remove fear effects from group members within $s2 yds
    bitter_immunity                = {  90356,  383762, 1 }, -- Restores $s1% health instantly and removes all diseases, poisons, and curses affecting you
    bounding_stride                = {  90355,  202163, 1 }, -- Reduces the cooldown of Heroic Leap by $s1 sec and Heroic Leap also increases your movement speed by $s2% for $s3 sec
    cacophonous_roar               = {  90383,  382954, 1 }, -- Intimidating Shout can withstand $s1% more damage before breaking
    champions_might                = {  90323,  386284, 1 }, -- The duration of Champion's Spear is increased by $s1 sec. You deal $s2% increased critical strike damage to targets chained to your Spear
    champions_spear                = {  90380,  376079, 1 }, -- Throw a spear at the target location, dealing $s$s2 Physical damage instantly and an additional $s3 damage over $s4 sec. Deals reduced damage beyond $s5 targets. Enemies hit are chained to the spear's location for the duration. Generates $s6 Rage
    concussive_blows               = {  90354,  383115, 1 }, -- Cooldown of Pummel reduced by $s1 sec. Successfully interrupting an enemy increases the damage you deal to them by $s2% for $s3 sec
    crackling_thunder              = {  95959,  203201, 1 }, -- Thunder Clap's radius is increased by $s1% and it reduces affected target's movement speed by an additional $s2%
    cruel_strikes                  = {  90381,  392777, 2 }, -- Critical strike chance increased by $s1% and critical strike damage of Execute increased by $s2%
    crushing_force                 = {  90347,  382764, 2 }, -- Shield Slam deals an additional $s1% damage and deals $s2% increased critical strike damage
    defensive_stance               = {  90330,  386208, 1 }, -- A defensive combat state that reduces all damage you take by $s1% and all magic damage you take by an additional $s2%. Lasts until canceled
    double_time                    = {  90382,  103827, 1 }, -- Charge gains $s1 additional charge and its cooldown is reduced by $s2 sec
    fast_footwork                  = {  90344,  382260, 1 }, -- Movement speed increased by $s1%
    frothing_berserker             = {  90352,  392792, 1 }, -- Revenge has a $s1% chance to immediately refund $s2% of the Rage spent
    heroic_leap                    = {  90346,    6544, 1 }, -- Leap through the air toward a target location, slamming down with destructive force to deal $s$s2 Physical damage to all enemies within $s3 yards and resetting the remaining cooldown on Taunt
    honed_reflexes                 = {  95956,  391271, 1 }, -- Cooldown of Shield Wall, Pummel, Intervene, Spell Reflection, and Storm Bolt reduced by $s1%
    immovable_object               = {  90364,  394307, 1 }, -- Activating Avatar or Shield Wall grants $s1 sec of the other
    impending_victory              = {  90326,  202168, 1 }, -- Instantly attack the target, causing $s1 damage and healing you for $s2% of your maximum health. Killing an enemy that yields experience or honor resets the cooldown of Impending Victory and makes it cost no Rage
    intervene                      = {  90329,    3411, 1 }, -- Run at high speed toward an ally, intercepting all melee and ranged attacks against them for $s1 sec while they remain within $s2 yds
    intimidating_shout             = {  90384,    5246, 1 }, -- Causes the targeted enemy to cower in fear and up to $s1 additional enemies within $s2 yards to flee. Targets are disoriented for $s3 sec
    leeching_strikes               = {  90371,  382258, 1 }, -- Leech increased by $s1%
    menace                         = {  90383,  275338, 1 }, -- Intimidating Shout will knock back all nearby enemies except your primary target and cause them all to cower in fear for $s1 sec instead of fleeing
    onehanded_weapon_specialization = {  90324,  382895, 2 }, -- While wielding one-handed weapons your damage is increased by $s1% and Leech increased by $s2%
    overwhelming_rage              = {  90378,  382767, 1 }, -- Maximum Rage increased by $s1
    pain_and_gain                  = {  90353,  382549, 1 }, -- When you take any damage, heal for $s1% of your maximum health. This can only occur once every $s2 sec
    piercing_challenge             = {  90379,  382948, 1 }, -- Champion's Spear's damage increased by $s1% and its Rage generation is increased by $s2%
    piercing_howl                  = {  90348,   12323, 1 }, -- Snares all enemies within $s1 yards, reducing their movement speed by $s2% for $s3 sec
    rallying_cry                   = {  90331,   97462, 1 }, -- Lets loose a rallying cry, granting all party or raid members within $s1 yards $s2% temporary and maximum health for $s3 sec
    reinforced_plates              = {  90368,  382939, 2 }, -- Stamina increased by $s1% and Armor increased by $s2%
    rumbling_earth                 = {  90374,  275339, 1 }, -- Shockwave's range increased by $s1 yards and when it strikes at least $s2 targets its cooldown is reduced by $s3 sec
    second_wind                    = {  90332,   29838, 1 }, -- Restores $s1% health every $s2 sec when you have not taken damage for $s3 sec. Restores $s4% health every $s5 sec while you are below $s6% health. The amount restored increases the closer you are to death
    seismic_reverberation          = {  90354,  382956, 1 }, -- If Whirlwind or Revenge hits $s1 or more enemies it hits them $s2 additional time for $s3% damage
    shattering_throw               = {  90351,   64382, 1 }, -- Hurl your weapon at the enemy, removing any magical immunities and causing $s$s2 Physical damage, ignoring armor. Deals up to $s3% increased damage to absorb shields
    shockwave                      = {  90375,   46968, 1 }, -- Sends a wave of force in a frontal cone, causing $s1 damage and stunning all enemies within $s2 yards for $s3 sec
    sidearm                        = {  90340,  384404, 1 }, -- Your auto-attacks have a $s2% chance to hurl weapons at your target and $s3 other enemy in front of you, dealing $s$s4 Physical damage
    spell_reflection               = {  90385,   23920, 1 }, -- Raise your shield, reflecting the first spell cast on you and reducing magic damage you take by $s1% for $s2 sec
    storm_bolt                     = {  90337,  107570, 1 }, -- Hurls your weapon at an enemy, causing $s$s2 Physical damage and stunning for $s3 sec
    thunder_clap                   = {  90343,    6343, 1 }, -- Blasts all enemies within $s2 yards for $s$s3 Physical damage and reduces their movement speed by $s4% for $s5 sec. Deals reduced damage beyond $s6 targets. Generates $s7 Rage. If you have Rend, Thunder Clap affects $s8 nearby targets with Rend
    thunderous_roar                = {  90359,  384318, 1 }, -- Roar explosively, dealing $s$s3 Physical damage to enemies within $s4 yds and cause them to bleed for $s$s5 physical damage over $s6 sec. Deals reduced damage beyond $s7 targets
    thunderous_words               = {  90358,  384969, 1 }, -- Increases the duration of Thunderous Roar's Bleed effect by $s1 sec and Thunderous Roar's Bleed effect causes enemies to take $s2% increased damage from all your bleeds
    unstoppable_force              = {  90364,  275336, 1 }, -- Avatar increases the damage of Thunder Clap and Shockwave by $s1% and reduces the cooldown of Thunder Clap by $s2%
    uproar                         = {  90357,  391572, 1 }, -- Thunderous Roar's cooldown reduced by $s1 sec
    war_machine                    = {  90328,  262231, 1 }, -- Your auto-attacks generate $s1% more Rage. Killing an enemy instantly generates $s2 Rage and increases your movement speed by $s3% for $s4 sec
    wild_strikes                   = {  90360,  382946, 2 }, -- Haste increased by $s1% and your auto-attack critical strikes increase your auto-attack speed by $s2% for $s3 sec
    wrecking_throw                 = {  90351,  384110, 1 }, -- Hurl your weapon at the enemy, causing $s$s2 Physical damage, ignoring armor. Deals up to $s3% increased damage to absorb shields

    -- Protection
    anger_management               = {  90433,  152278, 1 }, -- Every $s1 Rage you spend reduces the remaining cooldown on Avatar and Shield Wall by $s2 sec
    armor_specialization           = {  90306, 1234769, 1 }, -- Armor increased by $s1%
    battlescarred_veteran          = {  90435,  386394, 1 }, -- When your health is brought below $s1%, you take $s2% less damage for $s3 sec and healing you receive is increased by $s4%. Cannot occur more than once every $s5 min
    best_served_cold               = {  90296,  202560, 1 }, -- Your dodges and parries make your Revenge cost no Rage $s1% more frequently and increase the damage your free Revenges deal by $s2%. Revenge increases the damage of your next Thunder Clap by $s3%
    bloodborne                     = {  90264,  385704, 1 }, -- Your Deep Wounds and Rend deal $s1% increased damage
    bloodsurge                     = {  90300,  384361, 1 }, -- Damage from Deep Wounds has a chance to generate $s1 Rage
    bolster                        = {  90320,  280001, 1 }, -- Last Stand's cooldown is reduced by $s1 sec and it grants you the Shield Block effect for its duration
    booming_voice                  = {  90314,  202743, 1 }, -- Demoralizing Shout also generates $s1 Rage and increases damage you deal to affected targets by $s2%
    brace_for_impact               = {  90304,  386030, 1 }, -- Using Shield Slam increases the damage of Shield Slam by $s1% and the block value of your shield by $s2% for $s3 sec. Stacking up to $s4 times
    brutal_vitality                = {  90451,  384036, 1 }, -- $s1% of damage you deal adds to your active Ignore Pain or the next Ignore Pain you activate. Your next Ignore Pain can be increased by up to $s2
    defenders_aegis                = {  90318,  397103, 1 }, -- Shield Wall gains $s1 additional charge and its cooldown is reduced by $s2 sec
    demoralizing_shout             = {  90305,    1160, 1 }, -- Demoralizes all enemies within $s1 yards, reducing the damage they deal to you by $s2% for $s3 sec. Generates $s4 Rage
    devastator                     = {  90297,  236279, 1 }, -- Your auto-attacks deal an additional $s$s2 Physical damage and have a $s3% chance to reset the remaining cooldown on Shield Slam
    disrupting_shout               = { 107579,  386071, 1 }, -- Taunts all enemies within $s1 yds to attack you for $s2 sec, interrupts all spellcasting within $s3 yds and prevents any spell in that school from being cast for $s4 sec
    enduring_alacrity              = { 107577,  384063, 1 }, -- Increases Stamina by $s1% and your Haste by $s2%
    enduring_defenses              = {  90311,  386027, 2 }, -- Shield Block lasts $s1 sec longer
    fight_through_the_flames       = {  90299,  452494, 1 }, -- Defensive Stance additionally reduces magic damage you take by $s1%
    focused_vigor                  = { 107578,  384067, 1 }, -- Increases Strength by $s1% and your critical strike chance by $s2%
    fueled_by_violence             = {  90451,  383103, 1 }, -- You are healed for $s1% of the damage dealt by Deep Wounds
    heavy_handed                   = { 107575, 1235088, 1 }, -- Execute hits up to $s1 additional targets for $s2% damage
    heavy_repercussions            = {  90312,  203177, 1 }, -- Shield Slam generates $s1 more Rage and extends the duration of Shield Block by $s2 sec
    hunker_down                    = {  90450, 1235022, 1 }, -- Damage you take from area of effect attacks is reduced by $s1%. Spell Reflection reduces magic damage taken by an additional $s2%
    ignore_pain                    = {  90295,  190456, 1 }, -- Fight through the pain, ignoring $s2% of damage taken until $s3 damage has been prevented. Repeated uses of Ignore Pain accumulate, up to $s$s4 total damage prevented
    impenetrable_wall              = {  90318,  384072, 1 }, -- Shield Slam reduces the remaining cooldown of Shield Wall by $s1 sec
    indomitable                    = {  90434,  202095, 1 }, -- Your maximum health is increased by $s1% and every $s2 Rage you spend heals you for $s3% of your maximum health
    instigate                      = {  90301,  394311, 1 }, -- Devastate deals $s1% increased damage and generates $s2 Rage. Devastator deals $s3% increased damage and generates $s4 Rage
    into_the_fray                  = {  90312,  202603, 1 }, -- You gain $s1% Haste for each enemy or ally within $s2 yards, up to $s3% Haste
    last_stand                     = {  90309,   12975, 1 }, -- Increases maximum health by $s1% for $s2 sec and instantly heals you for that amount
    massacre                       = { 107576,  281001, 1 }, -- Execute is usable on targets below $s1% health
    punish                         = {  90448,  275334, 1 }, -- Shield Slam deals $s1% increased damage and reduces enemies' damage against you by $s2% for $s3 sec. Multiple punishments may overlap
    ravager                        = {  90432,  228920, 1 }, -- Throws a whirling weapon at the target location that chases nearby enemies, inflicting $s$s2 Physical damage to all enemies over $s3 sec. Deals reduced damage beyond $s4 targets. Generates $s5 Rage each time it deals damage
    red_right_hand                 = {  90310, 1235038, 1 }, -- Execute damage increased by $s1%
    rend                           = {  90302,  394062, 1 }, -- Wounds the target, causing $s$s3 Physical damage instantly and an additional $s$s4 Bleed damage over $s5 sec. Thunder Clap affects $s6 nearby targets with Rend
    revenge                        = {  90298,    6572, 1 }, -- Swing in a wide arc, dealing $s$s2 Physical damage to all enemies in front of you. Deals reduced damage beyond $s3 targets. Your successful dodges and parries have a chance to make your next Revenge cost no Rage
    shield_charge                  = {  90317,  385952, 1 }, -- Charge to an enemy with your shield, granting you Shield Block and dealing $s$s3 Physical damage to it and $s$s4 Physical damage to all enemies within $s5 yards. Also stuns the primary target for $s6 sec. Generates $s7 Rage
    shield_specialization          = {  90315,  386011, 1 }, -- Increases Block chance by $s1% and your Block value by $s2%
    shield_wall                    = {  90319,     871, 1 }, -- Reduces all damage you take by $s1% for $s2 sec
    spellbreaker                   = {  90450, 1235023, 1 }, -- You have a $s1% chance to disrupt magic damage dealt to you, reducing the damage it deals by $s2%
    strategist                     = {  90303,  384041, 1 }, -- Devastate, Thunder Clap, Revenge, and Execute have a $s1% chance to reset the remaining cooldown on Shield Slam
    sudden_death                   = {  90264,   29725, 1 }, -- Your attacks have a chance to make your next Execute cost no Rage, be usable on any target regardless of their health, and deal damage as if you spent $s1 Rage
    thunderlord                    = {  90308,  385840, 1 }, -- Increases the radius of Demoralizing Shout by $s1 yards. Each enemy hit by Thunder Clap reduces the remaining cooldown on Demoralizing Shout by $s2 sec, up to $s3 sec
    tough_as_nails                 = {  90313,  385888, 1 }, -- Blocking an attack deals $s$s2 Physical damage to the attacker. Critical blocks deal double damage. Generates high threat
    unnerving_focus                = {  90320,  384042, 1 }, -- Last Stand increases your Rage generation by $s1%
    unyielding_stance              = {  90449, 1235047, 1 }, -- Defensive Stance reduces damage taken by an additional $s1%
    violent_outburst               = {  90265,  386477, 1 }, -- Every $s1 rage you spend triggers a Violent Outburst, causing your next Shield Slam or Thunder Clap to deal $s2% increased damage, generate $s3% more Rage and grant Ignore Pain
    whirling_blade                 = {  90432, 1235113, 1 }, -- Your attacks have a chance to target a nearby enemy with Ravager for $s1 sec

    -- Colossus
    arterial_bleed                 = {  94799,  440995, 1 }, -- Colossal Might increases the damage of your Rend and Deep Wounds by $s1% per stack
    boneshaker                     = {  94789,  429639, 1 }, -- Shockwave's stun duration is increased by $s1 sec and reduces the movement speed of affected enemies by $s2% for $s3 sec after the stun ends
    colossal_might                 = {  94819,  429634, 1 }, -- Colossal Might increases damage dealt by your next Demolish by $s1%, stacking up to $s2 times. Shield Slam grants a stack of Colossal Might and Revenge grants a stack of Colossal Might when it strikes $s3 or more targets
    demolish                       = {  94818,  436358, 1 }, -- Unleash a series of precise and powerful strikes against your target, dealing $s1 damage to it, and $s2 damage to enemies within $s3 yds of it. Deals reduced damage beyond $s4 targets. While channeling Demolish, you take $s5% less damage and are immune to stuns, knockbacks, and forced movement effects. You can block, parry, dodge, and use certain defensive abilities while channeling Demolish
    dominance_of_the_colossus      = {  94793,  429636, 1 }, -- Colossal Might now stacks up to $s1 times. If you would gain a stack of Colossal Might and are at max stacks, the cooldown of Demolish is reduced by $s2 sec. Enemies affected by Demolish take up to $s3% more damage from you and deal up to $s4% less damage to you for $s5 sec based on the number of stacks of Colossal Might consumed by Demolish
    earthquaker                    = {  94789,  440992, 1 }, -- Shockwave also knocks enemies into the air and its cooldown is reduced by $s1 sec
    martial_expert                 = {  94812,  429638, 1 }, -- Critical strike damage of your abilities is increased by $s1% and the amount of damage blocked by your critical blocks is increased by $s2%
    mountain_of_muscle_and_scars   = {  94806,  429642, 1 }, -- You deal $s1% more damage and take $s2% less damage. Size increased by $s3%
    no_stranger_to_pain            = {  94815,  429644, 1 }, -- Damage prevented by each use of Ignore Pain is increased by $s1%
    one_against_many               = {  94799,  429637, 1 }, -- Shockwave, Revenge, and Whirlwind deal $s1% more damage per target affected up to $s2
    practiced_strikes              = {  94796,  429647, 1 }, -- Shield Slam and Revenge damage increased by $s1%. Shield Slam generates an additional $s2 Rage
    precise_might                  = {  94794,  431548, 1 }, -- Shield Slam critical strikes grant an additional stack of Colossal Might
    tide_of_battle                 = {  94811,  429641, 1 }, -- Colossal Might increases the damage of your Revenge by $s1% per stack
    veteran_vitality               = {  94815,  440993, 1 }, -- When your health is brought below $s1%, you gain a Second Wind, healing you for $s2% of your max health over $s3 sec. This effect cannot occur more than once every $s4 sec

    -- Mountain Thane
    avatar_of_the_storm            = {  94805,  437134, 1 }, -- Casting Avatar grants you $s1 charges of Thunder Blast and resets the cooldown of Thunder Clap. While Avatar is not active, Lightning Strikes have a $s2% chance to grant you Avatar for $s3 secs. Thunder Blast Your next Thunder Clap becomes a Thunder Blast that deals Stormstrike damage
    burst_of_power                 = {  94807,  437118, 1 }, -- Lightning Strikes have a $s1% chance to make your next $s2 Shield Slams have no cooldown
    crashing_thunder               = {  94816,  436707, 1 }, -- Stormstrike or Nature damage your abilities deal is increased by $s2%$s$s3 Stormstrike damage ignores Armor. Thunder Clap damage increased by $s4%. Seismic Reverberations now affects Thunder Clap in addition to Whirlwind
    flashing_skies                 = {  94797,  437079, 1 }, -- Thunder Blast calls down a Lightning Strike on an enemy it hits
    gathering_clouds               = {  94792,  436201, 1 }, -- Your attacks trigger Lightning Strikes $s1% more often
    ground_current                 = {  94800,  436148, 1 }, -- Lightning Strikes also deal $s$s2 Nature damage to enemies near their target. Damage reduced beyond $s3 targets
    keep_your_feet_on_the_ground   = {  94798,  438590, 1 }, -- Physical damage taken reduced by $s1%. Thunder Blast reduces damage you take by $s2% for $s3 sec
    lightning_strikes              = {  94803,  434969, 1 }, -- Damaging enemies with Thunder Clap, Revenge, or Execute has a $s2% chance to also strike one with a lightning bolt, dealing $s$s3 Nature damage. Lightning Strikes occur $s4% more often during Avatar
    snap_induction                 = {  94797,  456270, 1 }, -- Activating Demoralizing Shout grants a charge of Thunder Blast
    steadfast_as_the_peaks         = {  94798,  434970, 1 }, -- Stamina increased by $s1%. Impending Victory increases your maximum health by $s2% for $s3 sec. When this health increase expires, you heal for any amount of the original Impending Victory that healed you in excess of your full health
    storm_bolts                    = {  94817,  436162, 1 }, -- Storm Bolt also hits $s1 additional nearby targets, stunning them for $s2 sec, but its cooldown is increased by $s3 sec
    storm_shield                   = {  94817,  438597, 1 }, -- Intervening a target grants them a shield for $s1 sec that absorbs magic damage equal to $s2 times your Armor
    strength_of_the_mountain       = {  94808,  437068, 1 }, -- Shield Slam damage increased by $s1%. Demoralizing Shout reduces damage enemies deal to you by an additional $s2%
    thorims_might                  = {  94792,  436152, 1 }, -- Lightning Strikes generate $s1 Rage. Revenge and Execute damage increased by $s2%
    thunder_blast                  = {  94785,  435607, 1 }, -- Shield Slam and Bloodthirst have a $s1% chance to grant you Thunder Blast, stacking up to $s2 charges. Thunder Blast Your next Thunder Clap becomes a Thunder Blast that deals $s5% increased damage as Stormstrike and generates $s6 Rage
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    battlefield_commander          = 5629, -- (424742) Your Shout abilities have additional effects.  Battle Shout: Increases Stamina by $s3%.  Piercing Howl: Radius increased by $s6%  Berserker Shout: Range increased by $s9 yds.  Intimidating Shout: Cooldown reduced by $s12 sec.  Rallying Cry: Removes movement impairing effects and grants $s15% movement speed to allies.  Thunderous Roar: Targets receive $s18% more damage from all sources while bleeding
    berserker_roar                 = 5703, -- (1227751)
    bodyguard                      =  168, -- (213871) Protect an ally, causing $s1% of all Physical damage they take to be transfered to you. When the target takes Physical damage, your Shield Slam cooldown has a $s2% chance to be reset. Bodyguard is cancelled if the target is further than $s3 yards from you. Lasts $s4 min. Only one target can be Bodyguarded at a time
    demolition                     = 5374, -- (329033) Reduces the cooldown of your Shattering Throw or Wrecking Throw by $s1% and increases its damage to absorb shields by an additional $s2%
    disarm                         =   24, -- (236077) Disarm the enemy's weapons and shield for $s1 sec. Disarmed creatures deal significantly reduced damage
    dragon_charge                  =  831, -- (206572) Run at high speed at a distance in front of you. All enemies in your path will take $s$s2 Physical damage and be knocked back
    morale_killer                  =  171, -- (199023) Reduces the cooldown of Demoralizing Shout by $s1 sec, and Demoralizing Shout now reduces the damage enemies deal to all targets, not just you
    oppressor                      =  845, -- (205800) You focus the assault on this target, increasing their damage taken by $s1% for $s2 sec. Each unique player that attacks the target increases the damage taken by an additional $s3%, stacking up to $s4 times. Your melee attacks refresh the duration of Focused Assault
    power_through_adversity        = 5715, -- (1234791) Second Wind reduces damage taken by $s1% to $s2%, with larger attacks being reduced by more. While Shield Wall or Last Stand are active, healing reductions do not apply to you
    rebound                        =  833, -- (213915) Spell Reflection reflects the next $s1 incoming spells cast on you and reflected spells deal $s2% extra damage to the attacker. Spell Reflection's cooldown is increased by $s3 sec
    safeguard                      = 5626, -- (424654) Intervene now has $s1 charges and reduces the ally's damage taken by $s2% for $s3 sec. Intervene's cooldown is increased by $s4 sec
    shield_bash                    =  173, -- (198912) When Shield Slam is used on targets that are casting, it reduces their damage done by $s1% for $s2 sec and the cooldown is instantly reset
    storm_of_destruction           = 5627, -- (236308) Bladestorm, Ravager, and Demolish now snare all targets you hit by $s1% for $s2 sec and decrease their healing taken by $s3% for $s4 sec
    thunderstruck                  =  175, -- (199045) After casting Avatar, Shockwave, or Stormbolt, your next Thunder Clap roots all targets it damages for $s1 sec
} )

-- Auras
spec:RegisterAuras( {
    avatar = {
        id = 107574,
        duration = 20,
        max_stack = 1,
        copy = 107574
    },
    battering_ram = {
        id = 394313,
        duration = 20,
        max_stack = 1,
    },
    battle_stance = {
        id = 386164,
        duration = 3600,
        max_stack = 1
    },
    battlescarred_veteran = {
        id = 386397,
        duration = 8,
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
    best_served_cold = {
        id = 1234772,
        duration = 12,
        max_stack = 1
    },
    bodyguard = {
        id = 213871,
        duration = 60,
        tick_time = 1,
        max_stack = 1
    },
    bounding_stride = {
        id = 202164,
        duration = 3,
        max_stack = 1,
    },
    brace_for_impact = {
        id = 386029,
        duration = 16,
        max_stack = 3
    },
    burst_of_power = {
        id = 437121,
        duration = 12,
        max_stack = 2,
    },
    challenging_shout = {
        id = 1161,
        duration = 6,
        max_stack = 1
    },
    charge = {
        id = 105771,
        duration = 1,
        max_stack = 1,
    },
    colossal_might = {
        id = 440989,
        duration = 24,
        max_stack = function() return 5 + ( talent.dominance_of_the_colossus.enabled and 5 or 10 ) end
    },
    concussive_blows = {
        id = 383116,
        duration = 10,
        max_stack = 1
    },
    dance_of_death = {
        id = 393966,
        duration = 120,
        max_stack = 1,
    },
    deep_wounds = {
        id = 115767,
        duration = 15,
        tick_time = 3,
        max_stack = 1
    },
    defensive_stance = {
        id = 386208,
        duration = 3600,
        max_stack = 1
    },
    demoralizing_shout = {
        id = 1160,
        duration = 8,
        max_stack = 1
    },
    disarm = {
        id = 236077,
        duration = 6,
        max_stack = 1
    },
    disrupting_shout = {
        id = 386071,
        duration = 6,
        max_stack = 1
    },
    dragon_charge = {
        id = 206572,
        duration = 1.2,
        max_stack = 1
    },
    champions_spear = {
        id = 376080,
        duration = function() return 4 + ( talent.champions_might.enabled and 2 or 0 ) end,
        max_stack = 1
    },
    champions_might = {
        id = 386286,
        duration = 6,
        max_stack = 1
    },
    -- Target Swapping
    execute_ineligible = {
        duration = 3600,
        max_stack = 1,
        generate = function( t )
            if buff.sudden_death.down and target.health_pct > ( talent.massacre.enabled and 35 or 20 ) then
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
    },
    focused_assault = {
        id = 206891,
        duration = 6,
        max_stack = 5
    },
    hamstring = {
        id = 1715,
        duration = 15,
        max_stack = 1
    },
    ignore_pain = {
        id = 190456,
        duration = 12,
        max_stack = 100
    },
    indelible_victory = {
        id = 336642,
        duration = 8,
        max_stack = 1
    },
    intimidating_shout = {
        id = function () return talent.menace.enabled and 316593 or 5246 end,
        duration = function () return talent.menace.enabled and 15 or 8 end,
        max_stack = 1
    },
    into_the_fray = {
        id = 202602,
        duration = 3600,
        max_stack = 5
    },

    keep_your_feet_on_the_ground = {
        id = 438591,
        duration = 5,
        max_stack = 1
    },
    last_stand = {
        id = 12975,
        duration = 15,
        max_stack = 1
    },
    piercing_howl = {
        id = 12323,
        duration = 8,
        max_stack = 1
    },
    punish = {
        id = 275335,
        duration = 9,
        max_stack = 5
    },
    rallying_cry = {
        id = 97463,
        duration = 10,
        max_stack = 1,
        shared = "player",
    },
    ravager = {
        id = 228920,
        duration = function () return ( buff.dance_of_death.up and 14 or 12 ) * haste end,
        tick_time = 2,
        max_stack = 1
    },
    rend = {
        id = 388539,
        duration = 15,
        tick_time = 3,
        max_stack = 1
    },
    revenge = {
        id = 5302,
        duration = 6,
        max_stack = 1
    },
    -- Damage taken reduced by $w1%.
    safeguard = {
        id = 424655,
        duration = 5.0,
        max_stack = 1,
    },
    seeing_red = {
        id = 386486,
        duration = 30,
        max_stack = 100
    },
    shield_bash = {
        id = 198912,
        duration = 8,
        max_stack = 1
    },
    shield_block = {
        id = 132404,
        duration = function () return 6 + talent.enduring_defenses.rank end,
        max_stack = 1
    },
    shield_charge = {
        id = 385954,
        duration = 4,
        max_stack = 1,
    },
    shield_wall = {
        id = 871,
        duration = 8,
        max_stack = 1
    },
    shockwave = {
        id = 132168,
        duration = function() return 2 + ( talent.boneshaker.enabled and 1 or 0 ) end,
        max_stack = 1
    },
    spell_reflection = {
        id = 23920,
        duration = function () return legendary.misshapen_mirror.enabled and 8 or 5 end,
        max_stack = 1
    },
    spell_reflection_defense = {
        id = 385391,
        duration = 5,
        max_stack = 1
    },
    stance = {
        alias = { "battle_stance", "berserker_stance", "defensive_stance" },
        aliasMode = "first",
        aliasType = "buff",
        duration = 3600,
    },
    storm_bolt = {
        id = 107570,
        duration = 4,
        max_stack = 1
    },
    -- Movement slowed by $s1%.
    storm_of_destruction = {
        id = 424597,
        duration = 6.0,
        max_stack = 1,
    },
    sudden_death = {
        id = 52437,
        duration = 10,
        max_stack = 2
    },
    taunt = {
        id = 355,
        duration = 3,
        max_stack = 1
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
    unnerving_focus = {
        id = 384043,
        duration = 15,
        max_stack = 1
    },
    victorious = {
        id = 32216,
        duration = 20,
        max_stack = 1
    },
    violent_outburst = { -- Renamed from Outburst to violent Outburst in build 45779
        id = 386478,
        duration = 30,
        max_stack = 1
    },
    war_machine = {
        id = 262232,
        duration = 8,
        max_stack = 1
    },
    wild_strikes = {
        id = 392778,
        duration = 10,
        max_stack = 1
    },
    wrecked = {
        id = 447513,
        duration = 10,
        max_stack = 1
    }
} )

spec:RegisterGear({
    -- The War Within
    tww3 = {
        items = { 237610, 237608, 237613, 237611, 237609 },
        auras = {
            -- Colossus
            critical_conclusion = {
                id = 1239144,
                duration = 12, -- 8 for arms?
                max_stack = 1
            },
            deeper_wounds = {
                id = 1239153,
                duration = 8,
                max_stack = 1
            },
            -- Mountain Thane
            severe_thunder = {
                id = 1252096,
                duration = 12,
                max_stack = 1
            },
        }
    },
    tww2 = {
        items = { 229235, 229233, 229238, 229236, 229234 },
        auras = {
            luck_of_the_draw = {
                id = 1218163,
                duration = 10,
                max_stack = 1
            }
        }
    },
    -- Dragonflight
    tier31 = {
        items = { 207180, 207181, 207182, 207183, 207185, 217218, 217220, 217216, 217217, 217219 },
        setBonuses = {
            tier31_2pc = 422927,
            tier31_4pc = 422928
        },
        auras = {
            fervid = {
                id = 425517,
                duration = 10,
                max_stack = 1
            },
            fervid_opposition = {
                id = 427413,
                duration = 5,
                max_stack = 1
            }
        }
    },
    tier30 = {
        items = { 202446, 202444, 202443, 202442, 202441 },
        setBonuses = {
            tier30_2pc = 405581,
            tier30_4pc = 405582
        },
        auras = {
            earthen_tenacity = {
                id = 410218,
                duration = 5,
                max_stack = 1
            }
        }
    },
    tier29 = {
        items = { 200426, 200428, 200423, 200425, 200427 },
        setBonuses = {
            tier29_2pc = 393710,
            tier29_4pc = 393711
        },
        auras = {
            vanguards_determination = {
                id = 394056,
                duration = 5,
                max_stack = 1
            }
        }
    }
} )

local rageSpent_10 = 0
local rageSpent_20 = 0

spec:RegisterStateExpr( "rageSpent_10", function () return rageSpent_10 end ) -- Glory (Shadowlands) and Anger Management talent
spec:RegisterStateExpr( "rageSpent_20", function () return rageSpent_20 end ) -- Indomitable talent

local RAGE = Enum.PowerType.Rage
local lastRage = -1

spec:RegisterUnitEvent( "UNIT_POWER_FREQUENT", "player", nil, function( event, unit, powerType )
    if powerType == "RAGE" then
        local current = UnitPower( "player", RAGE )
        if current < lastRage - 3 then -- Spent Rage, -3 is used as a Hack to avoid Rage decaying
            if state.talent.anger_management.enabled or ( state.legendary.glory.enabled and FindPlayerAuraByID( 324143 ) ) then -- Glory and Anger Management
                rageSpent_10 = ( rageSpent_10 + lastRage - current ) % 10
            end
            if state.talent.indomitable.enabled then -- Indomitable
                rageSpent_20 = ( rageSpent_20 + lastRage - current ) % 20
            end
        end
        lastRage = current
    end
end )

-- model rage expenditure and special effects
spec:RegisterHook( "spend", function( amt, resource )
    if resource == "rage" and amt > 0 then
        if talent.anger_management.enabled or ( legendary.glory.enabled and buff.conquerors_banner.up ) then
            rageSpent_10 = rageSpent_10 + amt
            local rage10activations = floor( rageSpent_10 / 10 )
            rageSpent_10 = rageSpent_10 % 10

            if rage10activations > 0 then
                if legendary.glory.enabled and buff.conquerors_banner.up then
                    buff.conquerors_banner.expires = buff.conquerors_banner.expires + ( rage10activations * 0.5 )
                end
                if talent.anger_management.enabled then
                    if talent.shield_wall.enabled then cooldown.shield_wall.expires = cooldown.shield_wall.expires - rage10activations end
                    if talent.avatar.enabled then cooldown.avatar.expires = cooldown.avatar.expires - rage10activations end
                end
            end
        end

        if talent.indomitable.enabled then
            rageSpent_20 = rageSpent_20 + amt
            local rage20activations = floor( rageSpent_20 / 20 )
            rageSpent_20 = rageSpent_20 % 20

            if rage20activations > 0 then
                gain( ( 0.01 * rage20activations ) * health.max, "health" ) -- Restores 1% max health
            end
        end

        if talent.violent_outburst.enabled then
            buff.seeing_red.v1 = buff.seeing_red.v1 + amt
            if buff.seeing_red.v1 >= 250 then
                applyBuff( "violent_outburst" )
            end
            buff.seeing_red.v1 = buff.seeing_red.v1 % 250
            if buff.seeing_red.v1 == 0 then
                removeBuff( "seeing_red" )
            else
                applyBuff( "seeing_red", nil, floor( buff.seeing_red.v1 / 250 * 100 ), buff.seeing_red.v1)
            end
        end
    end
end )

spec:RegisterCombatLogEvent( function(  _, subtype, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID, spellName, school, amount, interrupt, a, b, c, d, critical )
    --TODO: Deepdive to see if beneficial or not.
    if sourceGUID == state.GUID then
        if state.talent.colossal_might.enabled and spellID == 440989 and ( subtype == "SPELL_AURA_APPLIED" or subtype == "SPELL_AURA_REMOVED" or subtype == "SPELL_AURA_REFRESH" or subtype == "SPELL_AURA_APPLIED_DOSE" or subtype == "SPELL_AURA_REMOVED_DOSE" ) then
            Hekili:ForceUpdate( "COLOSSALMIGHT_CHANGED", true )
        elseif state.talent.thunder_blast.enabled and spellID == 435615 and ( subtype == "SPELL_AURA_APPLIED" or subtype == "SPELL_AURA_REMOVED" or subtype == "SPELL_AURA_REFRESH" or subtype == "SPELL_AURA_APPLIED_DOSE" or subtype == "SPELL_AURA_REMOVED_DOSE" ) then
            Hekili:ForceUpdate( "THUNDERBLAST_CHANGED", true )
        elseif state.talent.burst_of_power.enabled and spellID == 437121 and ( subtype == "SPELL_AURA_APPLIED" or subtype == "SPELL_AURA_REMOVED" or subtype == "SPELL_AURA_REFRESH" or subtype == "SPELL_AURA_APPLIED_DOSE" or subtype == "SPELL_AURA_REMOVED_DOSE" ) then
            Hekili:ForceUpdate( "BURSTOFPOWER_CHANGED", true )
        end
    end
end )

spec:RegisterStateExpr( "cycle_for_execute", function ()
    if active_enemies == 1 or target.health_pct < ( talent.massacre.enabled and 35 or 20 ) or not settings.cycle or buff.execute_ineligible.down or buff.sudden_death.up then return false end
    return Hekili:GetNumTargetsBelowHealthPct( talent.massacre.enabled and 35 or 20, false, max( settings.cycle_min, offset + delay ) ) > 0
end )

local TriggerEarthenTenacity = setfenv( function()
    applyBuff( "earthen_tenacity" )
end, state )

spec:RegisterHook( "reset_precast", function ()
    if set_bonus.tier30_4pc > 0 and buff.last_stand.up then
        state:QueueAuraExpiration( "last_stand_earthen_tenacity", TriggerEarthenTenacity, buff.last_stand.expires )
    end
end )

spec:RegisterStateExpr( "last_stand_damage_taken", function ()
	return ( settings.last_stand_amount or 0 ) * health.max * 0.01
end )
spec:RegisterStateExpr( "last_stand_health_pct", function ()
    return ( settings.last_stand_health or 0 )
end )
spec:RegisterStateExpr( "rallying_cry_damage_taken", function ()
	return ( settings.rallying_cry_amount or 0 ) * health.max * 0.01
end )
spec:RegisterStateExpr( "rallying_cry_health_pct", function ()
    return ( settings.rallying_cry_health or 0 )
end )
spec:RegisterStateExpr( "shield_wall_damage_taken", function ()
	return ( settings.shield_wall_amount or 0 ) * health.max * 0.01
end )
spec:RegisterStateExpr( "shield_wall_health_pct", function ()
    return ( settings.shield_wall_health or 0 )
end )
spec:RegisterStateExpr( "victory_rush_health_pct", function ()
	return ( settings.victory_rush_health or 0 )
end )

-- Abilities
spec:RegisterAbilities( {
    avatar = {
        id = 107574,
        cast = 0,
        cooldown = 90,
        gcd = "off",

        spend = function () return buff.unnerving_focus.up and -15 or -10 end,
        spendType = "rage",

        talent = "avatar",
        startsCombat = false,
        texture = 613534,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "avatar" )
            if talent.immovable_object.enabled then
                applyBuff( "shield_wall", 4 )
            end
            if talent.avatar_of_the_storm.enabled then
                setCooldown( "thunder_clap", 0 )
                setCooldown( "thunder_blast", 0 )
                applyBuff( "thunder_blast", 15, 2 )
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

        nobuff = "battle_shout",
        essential = true,

        handler = function ()
            applyBuff( "battle_shout" )
        end,
    },


    battle_stance = {
        id = 386164,
        cast = 0,
        cooldown = 3,
        gcd = "off",

        talent = "battle_stance",
        startsCombat = false,
        nobuff = function() return settings.stance_weaving and "battle_stance" or "stance" end,

        handler = function ()
            applyBuff( "battle_stance" )
            removeBuff( "defensive_stance" )
        end,
    },


    berserker_rage = {
        id = 18499,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        startsCombat = false,
        texture = 136009,

        --Not yet Implemented in LossOfControl via Classes.lua
        --toggle = "defensives",
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
            removeBuff( "dispellable_disease" )
            removeBuff( "dispellable_poison" )
            removeBuff( "dispellable_curse" )
            gain( 0.2 * health.max, "health" )
        end,
    },


    bodyguard = {
        id = 213871,
        cast = 0,
        cooldown = 15,
        gcd = "spell",

        pvptalent = "bodyguard",
        startsCombat = false,
        texture = 132359,

        handler = function ()
            applyBuff( "bodyguard" )
        end,
    },


    challenging_shout = {
        id = 1161,
        cast = 0,
        cooldown = 120,
        gcd = "off",

        notalent = "disrupting_shout",
        startsCombat = true,
        texture = 132091,

        toggle = "cooldowns",

        handler = function ()
            applyDebuff( "target", "challenging_shout" )
            active_dot.challenging_shout = active_enemies
        end,
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
            if talent.champions_might.enabled or legendary.elysian_might.enabled then applyBuff( "champions_might" ) end
        end,

        copy = { "spear_of_bastion", 307865, 376079 }
    },

    charge = {
        id = 100,
        cast = 0,
        charges  = function () return talent.double_time.enabled and 2 or 1 end,
        cooldown = function () return talent.double_time.enabled and 17 or 20 end,
        recharge = function () return talent.double_time.enabled and 17 or 20 end,
        gcd = "off",
        icd = 1,

        spend = function () return -20 * ( buff.unnerving_focus.up and 1.5 or 1 ) end,
        spendType = "rage",

        startsCombat = true,
        texture = 132337,

        usable = function () return target.minR > 10 and ( query_time - action.charge.lastCast > gcd.execute ), "target too close" end,
        handler = function ()
            setDistance( 5 )
            applyDebuff( "target", "charge" )
            if legendary.reprisal.enabled then
                applyBuff( "shield_block", buff.shield_block.remains + 4 )
                applyBuff( "revenge" )
                gain( 20, "rage" )
            end
        end,
    },


    defensive_stance = {
        id = 386208,
        cast = 0,
        cooldown = 3,
        gcd = "off",

        talent = "defensive_stance",
        startsCombat = false,
        essential = true,
        nobuff = function() return settings.stance_weaving and "defensive_stance" or "stance" end,

        handler = function ()
            removeBuff( "battle_stance" )
            applyBuff( "defensive_stance" )
        end,
    },

    demolish = {
        id = 436358,
        cast = function () return 2 * haste end,
        channeled = true,
        breakable = false,
        cooldown = 45,
        gcd = "spell",

        startsCombat = true,

        handler = function()
            removeBuff( "colossal_might" )
            active_dot.wrecked = active_enemies
        end,
    },


    demoralizing_shout = {
        id = 1160,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        spend = function () return ( talent.booming_voice.enabled and -20 or 0 ) * ( buff.unnerving_focus.up and 1.5 or 1 ) end,
        spendType = "rage",

        talent = "demoralizing_shout",
        startsCombat = false,
        texture = 132366,

        handler = function ()
            applyDebuff( "target", "demoralizing_shout" )
            active_dot.demoralizing_shout = max( active_dot.demoralizing_shout, active_enemies )
        end,
    },


    devastate = {
        id = 20243,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return ( talent.instigate.enabled and -2 or 0 ) * ( buff.unnerving_focus.up and 1.5 or 1) end,
        spendType = "rage",

        startsCombat = true,
        notalent = "devastator",

        handler = function ()
            applyDebuff( "target", "deep_wounds" )
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


    disrupting_shout = {
        id = 386071,
        cast = 0,
        cooldown = 90,
        gcd = "off",

        talent = "disrupting_shout",
        startsCombat = false,
        texture = 132091,

        toggle = "cooldowns",

        handler = function ()
            applyDebuff( "target", "disrupting_shout" )
            active_dot.disrupting_shout = active_enemies
        end,
    },


    dragon_charge = {
        id = 206572,
        cast = 0,
        cooldown = 20,
        gcd = "off",

        pvptalent = "dragon_charge",
        startsCombat = false,
        texture = 1380676,

        handler = function ()
        end,
    },


    execute = {
        id = function () return talent.massacre.enabled and 281000 or 163201 end,
        known = 163201,
        copy = { 163201, 281000 },
        noOverride = 317485, -- Condemn
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        hasteCD = true,
        spell_targets = function() return max( active_enemies, ( talent.heavy_handed.enabled and 3 or 1 ) ) end,

        spend = 0,
        spendType = "rage",

        startsCombat = true,
        texture = 135358,

        usable = function ()
            if buff.sudden_death.up then return true end
            if cycle_for_execute then return true end
            return target.health_pct < ( talent.massacre.enabled and 35 or 20 ), "requires < " .. ( talent.massacre.enabled and 35 or 20 ) .. "% health"
        end,

        cycle = "execute_ineligible",

        indicator = function () if cycle_for_execute then return "cycle" end end,

        timeToReady = function()
            if buff.sudden_death.up then return 0 end
            local threshold = settings.reserve_rage + 40
            return ( tanking and rage.current < threshold ) and rage[ "time_to_" .. threshold ] or 0
        end,

        handler = function()
            if not buff.sudden_death.up then
                local cost = min( rage.current, 40 )
                spend( cost, "rage", nil, true )
            else
                removeBuff( "sudden_death" )
            end
        end,
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
            applyDebuff( "target", "hamstring" )
            setCooldown( "global_cooldown", 0.75 )
        end,
    },


    heroic_leap = {
        id = 6544,
        cast = 0,
        cooldown = function () return talent.bounding_stride.enabled and 30 or 45 end,
        charges = function () return legendary.leaper.enabled and 3 or nil end,
        recharge = function () return legendary.leaper.enabled and ( talent.bounding_stride.enabled and 30 or 45 ) or nil end,
        gcd = "off",
        icd = 0.8,

        talent = "heroic_leap",
        startsCombat = false,
        texture = 236171,

        handler = function ()
            if talent.bounding_stride.enabled then applyBuff( "bounding_stride" ) end
        end,
    },


    heroic_throw = {
        id = 57755,
        cast = 0,
        cooldown = 1,
        gcd = "spell",

        startsCombat = true,

        usable = function () return target.minR > 7, "requires 8 yard range or more" end,
        handler = function ()
        end,
    },


    ignore_pain = {
        id = 190456,
        cast = 0,
        cooldown = 1,
        gcd = "off",

        spend = 35,
        spendType = "rage",

        talent = "ignore_pain",
        startsCombat = false,
        texture = 1377132,

        toggle = "defensives",

        handler = function ()
            -- Magic constants from Wowhead 2025-04-22.
            local onCastAbsorb = stat.attack_power * 5.75 * ( 1 + 0.2 * talent.no_stranger_to_pain.rank ) * ( 1 + stat.versatility_atk_mod ) * 2
            local maxAbsorb = 0.3 * health.max
            buff.ignore_pain.v1 = min( maxAbsorb, buff.ignore_pain.v1 + onCastAbsorb )
            -- The stack count for Ignore Pain is the percent of the maximum absorb.
            applyBuff( "ignore_pain", nil, floor( buff.ignore_pain.v1 / maxAbsorb * 100 ), buff.ignore_pain.v1 )
        end,
    },


    impending_victory = {
        id = 202168,
        cast = 0,
        cooldown = 25,
        gcd = "spell",

        spend = function() return buff.victorious.up and 0 or 10 end,
        spendType = "rage",

        talent = "impending_victory",
        startsCombat = true,

        handler = function ()
            removeBuff( "victorious" )
            gain( health.max * 0.2, "health" )
            if conduit.indelible_victory.enabled then applyBuff( "indelible_victory" ) end
            if talent.steadfast_as_the_peaks.enabled then
                gain( health.max * 0.1, "health" )
                applyBuff( "steadfast_as_the_peaks" )
            end
        end,
    },


    intervene = {
        id = 3411,
        cast = 0,
        cooldown = function ()
            if pvptalent.safeguard.enabled then return 40 - ( talent.honed_reflexes.enabled and 40*0.05 or 0 ) end
            return 30 - ( talent.honed_reflexes.enabled and 30*0.05 or 0 )
        end,
        charges = function () if pvptalent.safeguard.enabled then return 2 end end,
        recharge = function () if pvptalent.safeguard.enabled then return 40 - ( talent.honed_reflexes.enabled and 40*0.05 or 0 ) end end,
        gcd = "off",
        icd = 1.5,

        talent = "intervene",
        startsCombat = false,

        handler = function ()
            if legendary.reprisal.enabled then
                applyBuff( "shield_block", buff.shield_block.remains + 4 )
                applyBuff( "revenge" )
                gain( 20, "rage" )
            end

            if pvptalent.safeguard.enabled then
                applyBuff( "safeguard" )
            end
        end,
    },


    intimidating_shout = {
        id = function() return talent.menace.enabled and 316593 or 5246 end,
        cast = 0,
        cooldown = 90,
        gcd = "spell",

        talent = "intimidating_shout",
        startsCombat = true,
        texture = 132154,

        toggle = "interrupts",

        handler = function ()
            applyDebuff( "target", "intimidating_shout" )
            active_dot.intimidating_shout = max( active_dot.intimidating_shout, active_enemies )
        end,

        copy = { 316593, 5246 },
    },


    last_stand = {
        id = 12975,
        cast = 0,
        cooldown = function() return 180 - ( talent.bolster.enabled and 60 or 0 ) end,
        gcd = "off",

        talent = "last_stand",
        startsCombat = false,
        texture = 135871,

        toggle = function()
            if talent.unnerving_focus.enabled or conduit.unnerving_focus.enabled or set_bonus.tier30_2pc > 0 then
                return "cooldowns"
            end
            return "defensives"
        end,

        handler = function ()
            applyBuff( "last_stand" )

            if talent.bolster.enabled then
                applyBuff( "shield_block", buff.shield_block.remains + buff.last_stand.duration )
            end

            if talent.unnerving_focus.enabled then
                applyBuff( "unnerving_focus" )
            end

            if set_bonus.tier30_4pc > 0 then
                state:QueueAuraExpiration( "last_stand_earthen_tenacity", TriggerEarthenTenacity, buff.last_stand.expires )
            end
        end,
    },


    oppressor = {
        id = 205800,
        cast = 0,
        cooldown = 20,
        gcd = "spell",

        pvptalent = "oppressor",
        startsCombat = false,
        texture = 136080,

        handler = function ()
            applyDebuff( "target", "focused_assault" )
        end
    },


    piercing_howl = {
        id = 12323,
        cast = 0,
        cooldown = 30,
        gcd = "spell",

        talent = "piercing_howl",
        startsCombat = false,
        texture = 136147,

        handler = function ()
            applyDebuff( "target", "piercing_howl" )
            active_dot.piercing_howl = max( active_dot.piercing_howl, active_enemies )
        end,
    },


    pummel = {
        id = 6552,
        cast = 0,
        cooldown = function () return 15 - ( talent.concussive_blows.enabled and 1 or 0 ) - ( talent.honed_reflexes.enabled and 15*0.05 or 0 )  end,
        gcd = "off",

        startsCombat = true,
        texture = 132938,

        toggle = "interrupts",
        interrupt = true,

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
            if talent.concussive_blows.enabled then applyDebuff( "target", "concussive_blows" ) end
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

        toggle = "defensives",

        handler = function ()
            applyBuff( "rallying_cry" )
            gain( 0.10 * health.max, "health" )
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
        toggle = "cooldowns",

        handler = function ()
            applyBuff( "ravager" )
        end,
    },


    rend = {
        id = 394062,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 20,
        spendType = "rage",

        talent = "rend",
        startsCombat = true,
        texture = 132155,

        handler = function ()
            applyDebuff( "target", "rend" )
        end,
    },


    revenge = {
        id = 6572,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function ()
            if buff.revenge.up then return 0 end
            return 20
        end,
        spendType = "rage",

        talent = "revenge",
        startsCombat = true,
        texture = 132353,

        readyTime = function()
            if buff.revenge.up then return 0 end
            local threshold = settings.reserve_rage + 20
            return ( tanking and rage.current < threshold ) and rage[ "time_to_" .. threshold ] or 0
        end,

        handler = function ()
            if set_bonus.tier29_2pc > 0 then applyBuff( "vanguards_determination" ) end
            if buff.revenge.up then removeBuff( "revenge" ) end
            applyDebuff( "target", "deep_wounds" )
            if talent.best_served_cold.enabled then applyBuff( "best_served_cold" ) end

            if talent.demolish.enabled and active_enemies > 2 then
                if talent.dominance_of_the_colossus.enabled and buff.colossal_might.stack == 10 then reduceCooldown( "demolish", 2 ) end
                if talent.colossal_might.enabled then addStack( "colossal_might" ) end
             end
        end,
    },


    shattering_throw = {
        id = 64382,
        cast = 1.5,
        cooldown = 180,
        gcd = "spell",

        talent = "shattering_throw",
        startsCombat = true,
        toggle = "cooldowns",

        handler = function ()
            removeDebuff( "target", "all_absorbs" )
        end,
    },


    shield_bash = {
        id = 198912,
        cast = 0,
        cooldown = 10,
        gcd = "spell",
        spend = -3,
        spendType = "rage",

        pvptalent = "shield_bash",
        startsCombat = false,
        texture = 132357,

        handler = function ()
            applyDebuff( "target", "shield_bash" )
        end,
    },


    shield_block = {
        id = 2565,
        cast = 0,
        charges = 2,
        cooldown = 16,
        recharge = 16,
        hasteCD = true,
        gcd = "off",

        toggle = "defensives",
        equipped = "shield",
        defensive = true,

        spend = 30,
        spendType = "rage",

        startsCombat = false,
        texture = 132110,

        nobuff = function()
            if not settings.stack_shield_block then return "shield_block" end
        end,

        handler = function ()
            applyBuff( "shield_block", buff.shield_block.remains + buff.shield_block.duration )
        end,
    },


    shield_charge = {
        id = 385952,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        spend = -20,
        spendType = "rage",

        talent = "shield_charge",
        equipped = "shield",
        startsCombat = true,

        handler = function ()
            applyBuff( "shield_block", buff.shield_block.remains + buff.shield_block.duration )
        end,
    },


    shield_slam = {
        id = 23922,
        cast = 0,
        cooldown = function () return 9 - ( talent.honed_reflexes.enabled and 1 or 0 ) end,
        hasteCD = true,
        gcd = "spell",

        spend = function ()
            local reduction = 0
            -- The Wall Legendary overtakes the new Impenetrable Wall talent, they do not stack in 10.0
            if legendary.the_wall.enabled then reduction = reduction - 5
            end

            return
            ( -15 + reduction + ( talent.heavy_repercussions.enabled and -2 or 0 ) - ( 3 * talent.practiced_strikes.rank ) )
            * ( buff.violent_outburst.up and 1.5 or 1 ) -- Build 45969
            * ( buff.unnerving_focus.up and 1.5 or 1 )
        end,
        spendType = "rage",

        equipped = "shield",
        startsCombat = true,
        texture = 134951,

        readyTime = function()
            if buff.burst_of_power.up then return 0 end
        end,

        handler = function ()

            -- Core
            if buff.violent_outburst.up then
                class.abilities.ignore_pain.handler()
                removeBuff( "violent_outburst" )
            end
            if talent.brace_for_impact.enabled then applyBuff( "brace_for_impact" ) end
            if talent.heavy_repercussions.enabled and buff.shield_block.up then
                buff.shield_block.expires = buff.shield_block.expires + 1
            end
            if talent.punish.enabled then applyDebuff( "target", "punish" ) end

            -- Hero / TWW
            if talent.dominance_of_the_colossus.enabled and buff.colossal_might.stack == 10 then reduceCooldown( "demolish", 2 ) end
            if talent.colossal_might then addStack( "colossal_might" ) end
            if set_bonus.tww3_colossus >= 4 then removeStack( "critical_conclusion" ) end

            -- Legacy

            if ( legendary.the_wall.enabled or talent.impenetrable_wall.enabled ) and cooldown.shield_wall.remains > 0 then
                reduceCooldown( "shield_wall", 6 )
            end
            if set_bonus.tier30_2pc > 0 then
                reduceCooldown( "last_stand", buff.last_stand.up and 4 or 2 )
            end
            if buff.fervid.up then
                removeDebuff( "target", "deep_wounds" )
                removeDebuff( "target", "rend" )
                removeDebuff( "target", "thunderous_roar" )
                if set_bonus.tier31_4pc > 0 then applyBuff( "fervid_opposition" ) end
            end


        end,
    },


    shield_wall = {
        id = 871,
        cast = 0,
        charges = function () return 1 + ( talent.defenders_aegis.enabled and 1 or 0 ) + ( legendary.unbreakable_will.enabled and 1 or 0 ) end,
        cooldown = function() return 180 - ( talent.honed_reflexes.enabled and 210*0.05 or 0 ) - ( conduit.stalwart_guardian.enabled and 20 or 0 ) - ( talent.defenders_aegis.enabled and 60 or 0 ) end,
        recharge = function() return 180 - ( talent.honed_reflexes.enabled and 210*0.05 or 0 ) - ( conduit.stalwart_guardian.enabled and 20 or 0 ) - ( talent.defenders_aegis.enabled and 60 or 0 ) end,
        gcd = "off",

        talent = "shield_wall",
        startsCombat = false,
        texture = 132362,

        toggle = "defensives",

        handler = function ()
            applyBuff( "shield_wall" )
            if talent.immovable_object.enabled then applyBuff( "avatar", 4 ) end
        end,
    },


    shockwave = {
        id = 46968,
        cast = 0,
        cooldown = function () return
            ( ( ( talent.rumbling_earth.enabled and active_enemies >= 3 ) and 25 or 40 )
            - ( conduit.disturb_the_peace.enabled and 5 or 0 )
            - ( talent.earthquaker.enabled and 5 or 0 )
            ) end,
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

        spend = 20,
        spendType = "rage",

        startsCombat = true,
        texture = 132340,

        handler = function ()
        end,
    },

    spell_reflection = {
        id = 23920,
        cast = 0,
        cooldown = function() return 25 - ( talent.honed_reflexes.enabled and 25 * 0.05 or 0 ) end,
        gcd = "off",

        talent = "spell_reflection",

        toggle = "defensives",
        debuff = "casting",

        usable = function()
            if not settings.spell_reflection_filter then return true end

            local zone = state.instance_id
            local npcid = target.npcid or -1
            local t = debuff.casting

            -- Only use on a reflectable spell targeted at the player.
            if not t.up then
                return false, "Target is not casting"
            end
            if not state.target.is_dummy and not class.reflectableFilters[ t.v1 ] then
                return false, "spell[" .. t.v1 .. "] in zone[" .. zone .. "] by npc[" .. npcid .. "] is not reflectable"
            end
            if not UnitIsUnit( "player", t.caster .. "target" ) then
                return false, "Player is not target of cast"
            end
            return true
        end,

        handler = function()
            applyBuff( "spell_reflection" )
            applyBuff( "spell_reflection_defense" )
        end,
    },

    storm_bolt = {
        id = 107570,
        cast = 0,
        cooldown = function() return 30 - ( talent.honed_reflexes.enabled and 30 * 0.05 or 0 ) + ( talent.storm_bolts.enabled and 10 or 0 ) end,
        gcd = "spell",

        talent = "storm_bolt",
        startsCombat = true,

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


    thunder_clap = {
        id = 6343,
        cast = 0,
        cooldown = function () return haste * ( ( buff.avatar.up and talent.unstoppable_force.enabled ) and 3 or 6 ) end,
        gcd = "spell",
        hasteCD = true,

        spend = function () return -5
            * ( buff.violent_outburst.up and 1.5 or 1 )
            * ( buff.unnerving_focus.up and 1.5 or 1 ) end,
        spendType = "rage",

        talent = "thunder_clap",
        nobuff = "thunder_blast",
        startsCombat = true,
        texture = 136105,
        bind = "thunder_blast",

        handler = function ()
            applyDebuff( "target", "thunder_clap" )
            active_dot.thunder_clap = max( active_dot.thunder_clap, active_enemies )

            if ( talent.thunderlord.enabled or legendary.thunderlord.enabled ) and cooldown.demoralizing_shout.remains > 0 then
                reduceCooldown( "demoralizing_shout", 1.5 * min( 3, active_enemies ) )
            end

            if talent.rend.enabled then
                applyDebuff( "target", "rend" )
                active_dot.rend = min( active_enemies, 5 )
            end

            if buff.violent_outburst.up then
                class.abilities.ignore_pain.handler()
                removeBuff( "violent_outburst" )
            end

            removeBuff( "best_served_cold" )
        end,
    },

    thunder_blast = {
        id = 435222,
		known = 6343,
        flash = 6343,
        cast = 0,
        cooldown = function () return haste * ( ( buff.avatar.up and talent.unstoppable_force.enabled ) and 3 or 6 ) end,
        gcd = "spell",
        hasteCD = true,

        spend = function () return ( ( talent.thorims_might.enabled and talent.flashing_skies.enabled ) and -11 or -8 )
            * ( buff.violent_outburst.up and 1.5 or 1 )
            * ( buff.unnerving_focus.up and 1.5 or 1 ) end,
        spendType = "rage",

        talent = "thunder_clap",
        buff = "thunder_blast",
        startsCombat = true,
        texture = 460957,
        bind = "thunder_clap",

        handler = function ()
			class.abilities.thunder_clap.handler()
            removeStack( "thunder_blast" )
            if set_bonus.tww3 >= 4 then removeBuff( "severe_thunder" ) end
        end,
        copy = { 6343 }
    },


    thunderous_roar = {
        id = 384318,
        cast = 0,
        cooldown = function() return talent.uproar.enabled and 90 or 45 end,
        gcd = "spell",

        spend = 0,
        spendType = "rage",

        talent = "thunderous_roar",
        startsCombat = true,

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
        buff = "victorious",

        handler = function ()
            removeBuff( "victorious" )
            gain( health.max * 0.2, "health" )
            if conduit.indelible_victory.enabled then applyBuff( "indelible_victory" ) end
        end,
    },

    whirlwind = {
        id = 1680,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 20,
        spendType = "rage",

        startsCombat = false,
        texture = 132369,

        handler = function ()
        end,
    },

    wrecking_throw = {
        id = 384110,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        talent = "wrecking_throw",
        startsCombat = true,

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

spec:RegisterSetting( "shockwave_interrupt", true, {
    name = "|T236312:0|t震荡波仅用于打断",
    desc = "如果勾选，|T236312:0|t震荡波将只在你的目标施法时被推荐（拥有天赋）。",
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "stack_shield_block", false, {
    name = "叠加|T132110:0|t盾牌格挡",
    desc = function()
        return "如果勾选，插件将会推荐叠加|T132110:0|t盾牌格挡。\n\n" ..
        "此设置可避免在盾牌格挡有2层充能时被错误使用，浪费冷却恢复的时间。"
    end,
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "stance_weaving", false, {
    name = "允许改变姿态",
    desc = function()
        return "如果勾选，在自定义优先级中可以推荐在不同的姿态中转换。"
            .. "比如在使用进攻型爆发技能时使用战斗姿态，想要使用防御型技能时使用防御姿态。\n\n"
            .. "如果不勾选，你处于某个姿态时，插件就不会推荐你改变姿态。"
            .. "这样能够避免你不想改变姿态时，插件无休止地推荐你改变姿态。"
    end,
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "reserve_rage", 35, { -- Ignore Pain cost is 35, Shield Block is 30.
    name = "|T135726:0|t保留怒气",
    desc = "如果设置大于0，插件将不会推荐|T132353:0|t复仇和|T135358:0|t斩杀，除非施放之后怒气剩余量大于该值。\n\n"
        .. "当设置为|cFFFFD10035|r或更高时，这个功能确保你总是可以使用|T1377132:0|t无视苦痛和|T132110:0|t盾牌格挡，来保证伤害和仇恨。",
    type = "range",
    min = 0,
    max = 100,
    step = 1,
    width = "full",
} )

spec:RegisterSetting( "shield_wall_amount", 20, {
    name = "|T132362:0|t盾墙伤害阈值",
    desc = "如果设置大于0，插件将不会推荐|T132362:0|t盾墙，除非你在5秒内受到大于此百分比最大生命值的伤害。\n\n"
        .. "例如设置为|cFFFFD10050%|r，你最大生命值为50000，只有在5秒内你受到超过25000伤害时，插件才会推荐盾墙。\n\n"
        .. "单人游戏时，该值会减少 50%。",
    type = "range",
    min = 0,
    max = 200,
    step = 1,
    width = "full",
} )

spec:RegisterSetting( "shield_wall_health", 75, {
    name = "|T132362:0|t盾墙生命阈值",
    desc = "如果设置小于100，当你的生命值小于此百分比，插件才会推荐使用|T132362:0|t盾墙。",
    type = "range",
    min = 0,
    max = 100,
    step = 1,
    width = "full",
} )

spec:RegisterSetting( "rallying_cry_amount", 25, {
    name = "|T132351:0|t集结呐喊伤害阈值",
    desc = "如果设置大于0，插件将不会推荐|T132351:0|t集结呐喊，除非你在5秒内受到大于此百分比最大生命值的伤害。\n\n"
        .. "例如设置为|cFFFFD10050%|r，你最大生命值为50000，只有在5秒内你受到超过25000伤害时，插件才会推荐集结呐喊。\n\n"
        .. "单人游戏时，该值会减少 50%。",
    type = "range",
    min = 0,
    max = 200,
    step = 1,
    width = "full",
} )

spec:RegisterSetting( "rallying_cry_health", 80, {
    name = "|T132351:0|t集结呐喊生命阈值",
    desc = "如果设置小于100，当你的生命值小于此百分比，插件才会推荐使用|T132351:0|t集结呐喊。",
    type = "range",
    min = 0,
    max = 100,
    step = 1,
    width = "full",
} )

spec:RegisterSetting( "last_stand_amount", 25, {
    name = "|T135871:0|t破釜沉舟伤害阈值",
    desc = "如果设置大于0，插件将不会推荐|T135871:0|破釜沉舟，除非你在5秒内受到大于此百分比最大生命值的伤害。\n\n"
        .. "例如设置为|cFFFFD10050%|r，你最大生命值为50000，只有在5秒内你受到超过25000伤害时，插件才会推荐破釜沉舟。\n\n"
        .. "单人游戏时，该值会减少 50%。",
    type = "range",
    min = 0,
    max = 200,
    step = 1,
    width = "full",
} )

spec:RegisterSetting( "last_stand_health", 70, {
    name = "|T135871:0|t破釜沉舟生命阈值",
    desc = "如果设置小于100，当你的生命值小于此百分比，插件才会推荐使用|T135871:0|t破釜沉舟。",
    type = "range",
    min = 0,
    max = 100,
    step = 1,
    width = "full",
} )

spec:RegisterSetting( "victory_rush_health", 75, {
	name = "|T589768:0|t 乘胜追击生命阈值",
	desc = "如果设置大于0，插件只会在你生命低于该百分比时推荐使用 |T589768:0|t 乘胜追击。",
	type = "range",
	min = 0,
	max = 100,
	step = 1,
	width = "full",
} )

spec:RegisterRanges( "hamstring", "devastate", "execute", "storm_bolt", "charge", "heroic_throw", "taunt" )

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
    damageExpiration = 8,

    potion = "tempered_potion",

    package = "防战Simc",
} )

spec:RegisterPack( "防战(黑科研)", 20250822, [[Hekili:nRxAtUX1rc(BzIjcgOI1dDDcuydsfbUkGchfqHcxvnHzZ6cfkG6c1nqWGHKLLfLmTS0mYE1yRyK0Azljpws2Z6vwM66hZ0aDRpn)f2ho6Ubqd0Dtk7zwYoiBGx(YmF5DMV39qUxR7XPi6REpguyucysu0BJGHJtGDpo)joQ3JZruEKOg4xSenb)73(w)7ZF0BL4B)I34Kp4no5DFtOfqmXWwuzbM8SdCLbqn79)G5F5hn)ZEV5)8)W8F6Nm)Z)0OOOBhzhbiL4TLTUhNuGUHpT19K2p5ra4Yrv(EmPamYaDff1vGQ6jFpUt)M)LJ)8F38x95p9f)QJ)Y3A2l9OtEYh8TV0p9KV6tM9op54N8ALuhPBOp)p(kZE8V4Kx5rZE0ND8x92)hp)p8HLFy5tEZ3z2h)wZE93y2F8pE8N)wZE)p60)V)K)ZV8x(WY5gviJRKE8OVVqLOwkocf7usDIHzvy0mG)eXBgxBATHXEcMccr81eb)xT8t9QffHwBkFrE(mR(ZWSzmfKYhLrkAIEZHczQvnUMuuT8lO)PF9)8Sx(jpD0p3cSAkS(VXEm8slOFTQdf4nPQLh1uO40AMcRzanJSz4lwntr(8D7calVMqz(HcMzxq))XvQUzV6VcO9o5J(S5VYZ)do9fFV5F2p8ECg6E(ElTiu7lgy4d(vMLwiQwIsgQk3l794KD19vD1fb2h6MQp8(39H3h(ECIY(62a1Q8arxGXIpqFEW9nqv0WFWTDK9F49Vdy7KBSFDthvlfDlTJc1L9TDNSavy7GQfwbU6oR2XSF7pC()6BF8x9UZFX)pN(Y)Uz)5)48x7XZFTpy(R8to5vE8)5x(4V9h(Rp(V8Ot(TVWjV5ho)JF)V99(lBWUIgghT6dhT4WVseC0kt95)83y2B8vlya8DyGZ2UVTP6r29bBvBGV3rkQH2RX75hwPG(9VTULLQ7rUQEaRsvlz1Bh4CM)0HqbGQehucUeP(dcSuaOvYq0Z)2k2rwp8(p4bp8(7zrpFGt8kHn6fCVyiWz0DbLsEyDSOHQL)T1nnTdxS8r2sdvL9V9AGF49V1AcUczlzJlOG3aDvdLJIas5fKj1cYC2Asg22kh1paOI3G0aOi3ckvxpv3radIDGk9Mqj6klAPEeWEXfWT7ajc8MGUwopmqrZCpWISjS91DvxYM7cf6wehOq98DfnoAH10UGIT1PruBHU23vxEK3UqURr2oQ71c4aNn0YB8Da9G)cxp)BVR7f6gUxoNBCHSR115EGAw2UQh5iQBTTHWLq(ZTe5ljDIhEFxqsIBdIBOlRVMWielxt222yHzXTxBn4ziAEBxvrLjRojxEJ4W7DJRITC1Bf9zFRy7SvfvtBGwvF6IOrEdSd8pB)lL1l9lKSTnxgSYwh4vFUtXnJ3wR9UArbXF1yQZ8uxer4iqeblLlmCwUVGfrPcxSZ(2YbEx3Xzx512hN)AtTfcVNkRLnnZoJzc1Txq7JaInPaxqGXTzjGXD4eqyAhvxah5bCh82s8DEWqqokvGh)I4HlITDD8oX17iCDC4ZOS8V9NnKu3KZ2nHjoa(jFkW)vW9qRiW6avRcELcEJyPEQQleGUQkNLUCbelX(f7aJyjMomdzccB6TMZVqXTggqUe5rxa0ceIVeipv)JKSTaAoFDvxmKJqDaL5g4TOYG(hPjRSOmSfbTpCI6e7n()csKg(gzQSqqCWmi3imaDgswhfYWdWBBtGDoOWloOhyf8fIGZZAFUL)sXWwfs4cc8OP6UB6uYRRMM9gM8c0E5iTlr7w1DasRy6SWk(iqZkI7YcOWhKfaGdk8CL42B7I1wNx9cJN9wk32vYTfilj9HRAFjoLTnS98aLSyUOCOZq6sl8TLaGYHhSeHBvYZA6zh4DKR9Lp3BvZZwzG3fYRPMN973S05c(suyjulX6HlCE)YDzdrNlD6DdSoyNbN81V)838lwsRD9iVrDwm7Z)85p)lCVfQkohxvzBtjX92S1ffo67dcPTYmC7(FUC7CGEEM)wF6XF(ZVGnF7xz13FY)(xFYV5FD2)0JN9OF8Xp5FB1hp5x(Jo51(OzFYNDYx8JM)Oxh8rWEp9L)taSb6IEvNQZ)v)jqp2N8bppy1v9vV67pVX7fi5la)8YlAW((N3o2Sp9Va6MlWqCbBMZvSVpGxo(j)4t)GFnGiGvxHSzF9V7Kx7tN)JENzV0F60pBXsZ)9)Vp9BETzV67o7L(nZF0BC8x87bFjll4Wa6sgbgNafdJKees60p9pp)N96h)1)Q5V6pF2R)tp5v)maaGJ9XF(V70x8RM9(VZ8p(xFY79jN(nV(PV3JpN7pNVbS7Lm42uoVQxML6O1DcELDdVBqtm4df(6M3zmo8MH5mmMSiwK8(Bk(WyH4Y(kR7iZ)CtXR8OL46IeDrWQLfTSOhhh7iqW)nA8CJ0H722Y60kE(2ooltD332DZkxHUQiDxlxVFw6geJDnxFEfc7T2mOlkCz1osTvYYZIHE58lBu3WvRoVC9kBveZvx(76qMhMH2K9FULgl3a0bTzDtblgo3rkQIaBUTvPBT0LeaQXQYb(lNve(EsySuWSD6Idhx)Q7oD1myUOV2vk4Jw5GSZ8N2O73RCWik2l68cuj(wPLqVIk53E0ixYqo1EsWUE19mFK)MYtlYhEVZMXYH8TUYuPN74CTML)DxPZ1viVqoC1v)3h3DMKd5kdMEH3g5zblUS57fT8UKdCvdvT0uV2z9SrdlxF7tRpOpfeznBTVUPUYZYIgNEkiZDw3R1FRplx0p36qwMIGYILD3t)aRX39U08)olo2vn4VZ28nEKFxNj8DV52WpvgWx4ED4GT)3fVDUZvYTsxCP8e(NxG(vwvZ(JwI8mvRXngxNDgoC6(RCmq7vUFHyh9zTgRR4qFyB0TzM1UbBYij2TWIdx0WwoHRgt0aq5YQkxzDdpLn6Dw)QxQxVD7N9kZ8)DrbH)SQG2eizxrG)eOtG1OF7s5EMzVhE)KpRC3HTZtDdlRDJIgv19m1LpAritxjv3L9pULyy7dX6qRxU)9lIxF4kMUi5ss4VBIV7CU29A0shSdG030ca3(cT2sIVdGho43gJ0eE3waW3sFij6c(bOq8Dbr2ahONIuJrd0DnI0Tu2nan4ib0Ulga8zx8psAa4IUliGhOH7p(9xDF(Z)fV8XFXNDYx(Kz)H3y2N(x(2N)xEYB(HF7V5pm7F(faD0p)n)05p(fanYp7lEYPFYNm)t)zGE)V4fb8IF13(2p)P)2xy2JFP5)KF)Y7y)H3)F4H3)F84V6BaO5Kx5JaO5hSyAep(LM96)Bh)fFXXF1pF()(7n)TFLvFZS3(dphBh)5FmGIRi9IPu8OFXPp)lDgcx91i)Gz)tpE9VJUaVN(n)lZF3)8Sx4xo7p8JN)AF4P)0xhCgM9K3CfiN(RFPzV)lp)D)zBI6LVsH5p61N9QVZSp9lN9s)MJFYpM48x7WSh9)6037dxcdqkh4pW29SjaDY7(M)dNDp(oU291naLB83)W7))FnFOY)9)x5iIwqTV7tjAXRMyLfT3TpFAD3DZrf9907F39p)On27)J7(9xne0fqV4TtCx4nw7sp8HfqDr1Q35URpopdp3HT4GDgl53BXajV7Q5BTjClU7bqScZvRFGhPW5h798(g2ezRsMCo0BpSLfsPh8GdnfM7Cx0nX0gJVAPu8QFDc3AZuzR0gxGQlE)bB9TN)Ed26aS17lyZv255eS5sN)6b2ctB9yb2IYB(2a2CbNTL1NNzETq78pFRl1Idq4TPj23FJHBSs6Td8pha(BLyZ7G7o3fH4wh(U3EWd2gyC4lb8M38(UGJ(0bo2gGFO7b)wx1L7Cv0FZBV(shlIVJeELH4wxF7TU6Bt7Qo7BYQF3Xmk8nqlEHk)whQaPBD93X7TUURPDxoH4Qm(omN8ult(BbVJK6Q49RNGxcFK3a8DqUd6bpyPJ9ZD3uWRdCS7fEF3u3AfeyeqhIulBUfWlReX7765EU7IFR9DD2FVnUn77ISvi0ZvulckLyprLsdFT207n231SlOfBBTt7w3v9dEW(UN698T4oYBEswFt0B(vxoCXg5T2)d1z76f28(L3CPTYvUaNxXvkdIRFRdLGD78RND7aNNTzFxumWczpCY5nxF501RcQVNfwA5CoT2N5eWwBRuy7CRSRkpz10EoSqyrRr7W07VoOvxg2M17TQYODns30mddExOxAjCXL1T7gW33g2PWMnHNaEtgA1z9Uxs9V7eOUZgozR30gwnlKip976CIDWiVhSb5Znb3SCLRzKhxMrwp6NlRPxVWcQSomhX5H52Eutq36kgY0Hp7NzDFqJSZayt7Sdl3FweG4pTcWBDntIyTa6PJns(0Yf7rASEEbleeNLt6w3KP)CR9o5N9lX3iV1z05o3nj8ZYzg4YEDIYRZP5AmjUjYiS11P9ClQp76MnZEq45ZIzZOjRc4D5OjjoC6Iv6)9DP6NxxWn34aAxw5YAUehKExrwnaRCynn0kb5D2WS7s3k(LzRnI9CrHujoxJCvfmDiQCMcL4Q3o0(JKDUlZEUL9RwSUNvVrTgUQx)9Dp63HeEpi9gKKc9avXVv36haJxX6ho)23fcU0C8kkXayZDLMb)Dh0I8gCu(VmcVrKN1M3KWxE2cph6zXsV4Iw3)eiU1kNTd3)YsE8gGmajVOnM9Ytye3a0akzJ4VE80IMLw7iU7DhF4GihwQ)D1e8UxNPWtJLWtJj4Fvj8QGupS8QzX()0QzVmoT6fIsz0mAObhAawVoYQdn9QulVpgxjDKQSTKJdZQ5uquBIMtKGP2a6XrvQ4PuXRE3ipmy4616QLrOmQQxs0QE4U8o1soLJWpDNUfAlyq1rWeBk3WHPApSUiEkIcfGswWUXyEzQjLCney7fJl3yIx1QtlwHzKezAZPgMSO5cjmmZeg1E6eg1eLgX51fQaCRedlxTDi1GwqjBvOBYwTX065o2KPUz2PQ0bvB2OR04gDqumTXD1sX1ONfvTEwfy71oBCNcPvrQ2ujG2skUQC5i2AfRJs12RKNKB6kMPvWzh5exYaMkPCz7QJj4jJkY3KpCcmANKnZ2ovzR2jKB1jzjlh8OKgTdAMUqxxJcLJgKiiDQ2XcPJsNMGXDCqxCcJMD4JrYqufoodtTbfyOYxQjmEol74MwTBMWVD1ezA2eIKblhwwaBxoduhisQufZIHNRdMjuVsHJgMR30cyKqvtsnHGLWjfvkaf8dssA2qtlHF6EvAJRhNPsJo1ZuObjrthuDUUyAeMXE5RKeX3IVkqwu2cTBe00K(oCbj8yAKOBvwhMUu5tsQ4Wt0bxh8z(PJH7K2aYlDZwXDCHWukf2GefknnB8eop9KaizSHM4b1W12FudsM0EL1RIvtQwajSId6uhOUm55eiDPufrNwZeIqlBsspgnxihuE4guP7iXvOvbyBnJoDzGtWMndNq4it26fzRX2qrcsLdrfPifPCnBDYWjgd5JB3THH5ig6IADOfnWP017HnHmNLgtJU15YLrMV40Qzhf1V7uxfoMGoybKC0z8RwFetu5EduBNqCcw8y2ruv5LdRXHZjNld)iHsJdZ4uxMOFD9aKKAjPGcntGMcMSBQP5qGct1m9K0ueeAnBt3J1P7ecNoi8njZoGJ3nMiHfvpVwjsyGLP8GmKvAzNriUyV2C009BLOkTEjmV(bW8Hy41A2StIs6A6LhO1LizgEpY(vzeBNSIFJgrCMqC8O4iGJByw6HE6bnK7452Vqy3Mv6ipGIotyEAM6LKlYoTbRKLllAacBG24SdDJcBPwTAZ4g9WfCOk3tbFCOLUoQ3ugwfmbq8bt2I1Hh2iB5P9jAwV64XEEfIG71VQHLLdtKC2IznlyMvotjtF06k9dy8kgZLRxYIrAU1s4wPhbNhnpFvdBxRUQLDZiYkPxKo2TA8uTUL6QeWipai)Trhr2xcQF)Iztlo1tl34wic(XnjR4jjM1l3eMXJlHvXkTC4izAfTGqR(r9O17mStXA1gNb4UpTjsGkEnxeJkfYZtoPDRWUiS0tR2lHzxBGeinShUf5O(r4HHXmnRuiD7CLfz4O5KP6XYjhQNxLSezjt32dBKQzp8rJDPvhxqrYwkRmJztIP545P1XOvrlOWsZ5nmaFQHdt1k4q0tNitshrejdX2WorSvlMMr1I904yLJLRA5LFerMm2yybXz1Id8II4nNwLtunmLwaCEYATqmYf6IInXSQFLrJkp2vV84Q85ZLZStSvqe7uxSCYtBNH1DODbK4k0czZWwkOq6kyYTZwtrWSzrtA0(sirnYmAmTRxKCU2m5T1TYhwOFXYbL6kfkJWKLFCDT(oQ9kZpGMVv)(DySskwQoE3YnAt2QdxvoO2UOj1QvuoXG6d6sPNJkNH8eM68JicHmNq4fsq4oAC)e82vnChpHoTnME(iFtxMsvkcxdejUWafglZXTuBpnPOQCPPMsEvJBoziXOIv99lgpmppDdw5wer(9rM2vTptLMMSwMbEzt2NnLrxsiDVCJQ1MpuQHE9iPgn7oo3Gkty67f0h3Ytg3D80XYJQ6ZxmqQDyR8PjTcbfG7vxCyHAvI7LLawIMLPMOVpQuRecWzOJOtyxKFKxOBHE9lnOz3Kv771BC1(IDlP50kaJTIvZPXXTkl4xSfVl6Wbs61QuRqCQA4v8JcIc7NzQRmIDffpR0DhIioovx)P0JPJkW1GjNfc9i(evZsxOGoRyQ(86jjgIJRju0qJkOR6iFoVo9ikIKkhnxy6HPhHWooDvPwfiI0YY1zylsnx0WoCJPWYBfHZ3FCnw3MSDfgAesBrpi7uwhX6WfnZgHKEyweniDd1SqKvh3JftpnSjmnrYemcvlj5GgeKZoqunUBNkLTJ4tIjMfYu2koDCD6ik3(jGhklW5zW2JKLhPKz0KorYgdAJvOvlH(SSdJBXonDTHvc7MfBuHjLyC5rKe8Y7slLTnAlUOIwbQD8rIAMf2XvRaJif0W(9gH2VnbmLBe9OoLWeQLpNDEnzM0d4HN2WyCCos60iJ9dKl0YYaxWnJ3qBEg5Iq0K5qGnh01TMip)u2j6c9CDMgmDAGqQXc5uNI613tOyLsKjY10EQir9wovRWKeQLTtjVgrDj6rcdsPyLLRz2CvShc1ECEefxQ8SqoviYfKBydmsr3kWI2UTtKkDtHY1mje7NykrtZHuv8neBwfREwrSOXPKONiejH4uOoVmlsQcfnvYG1kr2StBiyiZjqP3t2kQxd1XdQII3SyhctIkbd5AysKJaK0bUhFF7ySuky(2DB7gxYCCtiGDzBP4Pd5ZNYOrRAznkucL2T7qd)cCJiXqW5D1QNLqj)yzjwSu1r9ZNll(q1s1AtjouyYaTIc6PjAnYj9iCvPsrkzMmQowiobzPq1odOylkyuGmDgPoD09m4kXcLCsr(C5SgJl2Rrx5E(JZsGwNHRdBzRuiti9lKJWozcc4uHL4g4ZzJJ3pOQk(iAVPSb0XL6xAImIyJXtyYGaziMQsNAfYAMFu7CE1IDqWk2octNZli7aOG8zHOQ0uT04YPKgNCiuxTrALXs0ty8eNr9yfPK0uT6RlOPpUeO8J6CXPBOgO20iObhMkCr9qMqPswH4nA7m1OjcugYW4MejsbNSyAyk0KjZcrxochTfkEPbPZ74dz0jxZSqnaUpT6nkorCm(OKP6eNIjrq5wq01sLa32yCc2bfGZhvpng100HrW4cqUcH8OtiXazaPYjOq1VyTidiDrlk(o57osumzZ0kwyuqGYW8ltLXVCkooeM6umdss3cGx1I0rv0a549Oct1pcgOnOYX74c1PdDAhg5sylkb0QnwN6uezBcX5imbzaAcTMs8ftui7ejVuP6upruSaEbkjBwRy2w98AcQ3jfBN0sjnsK3clLaFY25YLUAIbTWilvRRilCMm(dBgmjaledY2Uz6wS0KQY0J70hkHwzq1ED1BdfLfuIy)Xvv7iWhrvOjvYQTs0UtFCkaU4QLkTse0OUHTIs7M0jptukOgIosqJ8Q3g1rzstIcnZ0cpB5oems5dAoGtmhlsMKTsKlU)a5HPuOYB5JQHRJ1NuEuz3(vyhMrZbQWio)6sCk6DAr1nTRw1wuLaXAOikNTvsunQK5rIjzY2rjPEzksk0eHnzbNyPKdkxnQdrII9Yx1bxrKqYKF4u(kwHjHvaAf66rPAb1VCNjTQ1HmRz7ewiXP0A1oHTOzXUkjdQiNVzkqfvPWYiWSaVifecZvvkUnwcOksrT7Wom3G2(2Kec5KlnKVpjzUUTtrPJLkJLGPkC9WwmLLszsLce6pKjYFGjtl8CMO22sdWNokIr0cInxKFK8aB46SLuv8Iy8NYG2MoVytLbdMgfANRuTCMd0Bbtk4NnXaLAg9Tbn9KRsJitYQthO0PD1Qi1vytY1odTds(0WQYI9swVNtpbuMEo85NkOoHEcgVAGgvip(GGQbXPI0qJAaCg6rMUG2yIsPOt3EswzuVuesjkjIxgzqIrz1mJ556vVdBncggvCtZeIAuUTki5e2rQqgZUnAHcpPulJIDR7asINEy0ukRHCvlR3dnbniVESSpAVPiXuMm0nm4OZBs0RoIvax94Ht4QJYYeBpm7eBkyIkfIyirlI5JsnHSaSk8GeA1n6oiSTrcsHSAtCcANykNFo88q1js6uRVAdbngTgMudn6AeXIxeTMaOTjvJ6TOkiZvLQMXq3rbXk9h1iGsQsyYat3K(dM0UJE7WCWiCkzgg1IGuyaCglfCFHGQkXECX5gMyaHtEPO8nlcbHinfsgVzzviD6mv1ZPXRPxImzV6HfRYLGvihr(MOQWf6l5urexfl2lvNCTc9slA3fwOx1ijcBPezuR2LKt1PjQpNwlL8vftMFCHjjlMsHpJvaE6utrMwjMjihghSjiwoSFDHm8KfkzkLxYXcTOcvKgG4ErcecKPYNZxHUFLPudn7OvrRbwNQg9QxJOAYMLYNxQx24H0ezXzC5yektz0kTKo7eMAgnZMXMNyuFNiD)a62CPWZ7JmuqsmhKzYKPlxw20VdRy5(9MmGlCCATS54lu1qEC2jo5eRq3TrTaU2tdC6jNZ0rQzVESzjgZijK3Rw5YMkL4CBmQ8O6dLJPB7cYN12PvPXPz6JuCISyP2kaRNS0HYoqt9twUaHSrkQXnfqB1PyBmc92Xr96uTPdlSrf2mInhJ5naZZ1wVwwMoPDtX0QlFA4gUSjY1sVesxvlw8jJf0sGuEqUAMyJRjI2jpolIODldwMk0EkyQoC1K1uiYLSkDH861BW4RNxrS9Gsz6LiFq(cjLDjGYOQzmSulgCrtGJw3XnY5LczQuDjhUItI61hMIT0qh0(6k6tzIZPQ7u1oBCrT6Py56qGpeovgUYtjB7hNSxkyKKDA3UibnFy9ys1K9J7IvhuVpOQV(JiPsOS8jtEV)F]] )
spec:RegisterPack( "防战Simc", 20250903, [[Hekili:nVrAVnoU1FldwaJy0zDKVItwehG2TFzhumDb8w0VzzAjABTrsuGIYPUiq)27JK6GKMuwohdkMbjXsp(UVi5ZRhV(pwVkeXWR)(eVjZ9EWB6iVhM4n7U1RyNYWRxLHcEgTh(Juuc8ZFNsy4awejTCZ)grPrekhMtXeuihx5KcAaa3bgll)xU929rSdfBhfqsUnpkPigXxAafTJX)CWTBJjBVLDa)cI(caAu6T)vb2)DoMJyN(hr5S8BdX7qfXSBFrsr)SgUyehlRxTTikM9BPR3AxAMcmwgoy93xa)1HOWqSeuCoSwoO)S3d)S30FPCZ)khxUbabhhYfW4y4tyglkDFoiNuYUOyq6(PFcGmlNrXOeyr)qf2YVXP(Qg8)RC8xU5xjjjrWVxDknayPTblMUy2CjW)DqLapRvql)w53qcuMpkJIbgElI9xwEl8twm2pNHsdWFLr2VpgVem1Dc8bsbtbHWBYkssWXQpj4aIUh)1ODlzrj4LEV(Ac5iobNYgfgjj3t3RUGICSFedN8vUB3sgjb7t25hhT)al3peFKWbKJVTf72nkknft9P48O4imGRrfz2qwU6drhrmeTbfGLlneqY2yuoWuKxsF9vlVa41GNFC5evmLlCx8Fb8w(kNuKD783heUCSqErPpdEpdIsbfh8h(HOeiEYFE(tkRR(Pm0Z40bhWOy2HrzbShxQcK85(WZh8LBemNYBbzUIJ5mQWgg2(mkaXjo5dONAFAMqnk(mdfZTgrjGHbTfSRKT)j41ncNY)u4ab8sDMq7muvdao2Kq)Df0tApftZXuU0RP3PbOuqsjukqq13uzD)ZIW9jgVAxefliIgMalnedII9d4bQQugTN7UWOrbpRz0Z09BQKNg9rZNhW4(RSrQwIjEQykAFkHI9ZqrPsZSb8pbWp4gkyuhbb0rbraggpFqaHeZvF1wU8yuYiins4PxFvh4zENbSmksc(Gkdg8SKmop5VTigsz8CTfZeFt6gFMGpvb8qCcbuZr)xUdKiExNh2sKU2hjrqSxpOFLE2UCp)Ds4bNheudFbppXr(k2rckYDXQtDWQVFmpXRhM5wFcjbpgr40Whe)Tfuijulzb)TJNGeFzykq1Cro6A1qteDgofdHj8GArIch828U8oDZjxTo5ZG3hVOlE)Ye8m8DFpWNtUB4RVkI8FA5cVQml5ymxrqXHYsilxmqcX05dDrQei3soWldut1dzbdEU(LpTC2GCmZFljf0VSimD6y)jzb6LH0YX2yOUQsvTlZDLkfy(8kuPv2rf2liaQG6we0G6hKqCmkaQfc(Lf5h4cHc)O(kv2r1)luK)tciVxkHdOwHktOEVePYjx3qCeuOu1hDEQBPfYDEBJ(fRQQb9TJ0qSw)yCCYF1rSpekMeHHqIjdC13MEBBComosQ0fRiGetYZH2js4nIixceGAH4KICFkrNV0QPA5fIa3gAzlAgc11AXGwK6l)e04liRIwHre8xZ5n2WKbTMsVg7Y7l6CuShagqG6MaaSAt1gs4fCbp7wo01AcIrzx5sAiJZAlomTQTPvvPjNrYYejI3rOw8PQin()GdkyInIaowGYr23guhq(cojQsDpVj1DbF)IWMoqqede8Qxo5ae4dj1DqptTtVL0zxRK20pifb(wqSvfPBRW1xAF31sAtHMIpItL72RUkynoYXr5jrb(CqOW(de7GTreC7lxHzL6J1y)XL351BzdA36s6PoDw7Y8ErTW0QE)EI3ZxDIqef(pOqGUiIsb2PLnAXxv8QTiNBCNQtAffkc(EHYiVacz12xhFTM4H24gdRXnojyhPKbEXT1BOuH9OIduDs7ZnxT8LsqEBxy30O67QBlxKP2YnV7Lp0EkJgVF1h3HaOG5E5fCEo3jo6xNZ4xeLDbG708Vlsk8Fmc)bhJonvFXPBtFeGpxQPe8x54DV35NPWttQtDvbVZtEyGmoW92semzpqgqY2DNyLNMoVhOb2J88poEIVhOQqKee0bwa1sTLZIV7qV)M83wEjxGRYd4s(BFSuleFeKk(jFVckSY3AB1rGF)4jRx9cIMkpb7FljJqzGADZSYns0uUH3zy(OYVTEfQGDGFG(gNU86vBr54W)zQJZ)xGa(P)dv(GF9DXTkuzax)3wVkGgXagfTELzAJYnpUSCZyyLcCUELMvAndKI3pU4MaoQM6evU01LBgivtTgUYnpbuzI4n6frfp6sfs7qsN5K9S2QQkJCt5gEWO8rZ9k386RvCNrLOYndvztBTW2YHveIZBZ)4uDZERQovGC29wRK3BEQCZDVvwYTV2DovyTgQfEQePZwJDQnN2Ycv5(4uFXfOopq5oV3GY6Xgd4fmeTSLsUnoRDVipH1yafoga8bBakuV6Wn2RhQ6PvcB7tMPP8D2hUn1lWPvzE7oz3nvkxlT9wUrpjITUMRYN9w9nHq93uA1B6KL0zBRswfx3TV1qv7XJNfmy2)Tt3j3501JZ4e7gl2)Ukb3fdz6onVpOByxjMvYeyzBcwZkptnervXOhH4o5T9sOkgyRDZ3HB1D9n62DgQpkEQot89D5PBPyqLR7fDm(sNU3DOJE4)tyOAfuhjq1IyUVoc1O9DbtorTAsBZ(UwHWKkXxBkGX33JyORGivS1qlr)DkltNFvKHZ68L8zllCAO19M5ELS2kW4XQHK1jpmkHorfM6fBaJ7mT2CBx2F)2RYPTjkAS72L)rYpnbrZvvHkBhtvjY4VrmCpnnouVc5iZyOZDxKMpfnIIXvHDNnnncpM7BXV8AjSvXSrISpJnN1RVLzTPE4WCHcZsvnZJtVluzPBdX5k1gc5SvKjT0v2av3TNxDhIcpHZVhrHAv5Aa1UkrXAmZmOcC7TRvNWUUzl9BwurS0UDr1mg63WOYBAULr5ZAUgp7Z1ZzDxkvRdpRVcoRjTCv3zm3bUUqEnSTZbKHLvRR)25cQRw(1NtiRn9xdQXGdzcRwGwZKe1zoq9rlYAQWgPrDwJmH0DskZo6BSFMD57O2PsQJMGSXMbq1GOmSs6(6NxNPTWCvbZ6HIOQU28UQRHcp12yS(cD0VT6iiPwBZ5yn5c)t6d(TV0Pgl11uhPYF2Vb7EYBQZuKt918pmMAG9Cjdu2dP1b1PV6lDX5JMAt8UsxkvFXolNpW4CWSozqQG5CGFCXHZVC0YL4W3OU8Zx2gVOpYwFych4VZoOnWFhCVT2)xODePgJMLOVkPWPCasnnF3D)JghztfmAJ5H6XGAB4TSvLD87QHfhtVLyjMvwSofxci)0BxrPPJw8yvB4(0d6H2W5OGzvF4yKW(HRruHxOdCFUgAIq5ghd41zHpwNKSwgqfncgW95y8rWa1iUThgtqe7qsRpWQXqZCxuUpH2UQBQUBoZsVc0Q1WOXaRzYcU38STDQEPtyvFxnNF2UxORtBZ52z3Mq9bEkqO2MBROx9mWzkQAhbOwxyMq6okUJCNIeSENrbbucS6oUWMQM)ndsmnD8ulTos6tEN8go9LBYLFhNC6y6(34jymZDAlU(EdeNfqZxMMMtdq(nUz9kXwqA2FHY3jhBhqGjGchuJZDq(V1)Vd]] )
