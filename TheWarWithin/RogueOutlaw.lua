-- RogueOutlaw.lua
-- August 2025
-- Patch 11.2

-- Contributed to JoeMama.
if UnitClassBase( "player" ) ~= "ROGUE" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State
local PTR = ns.PTR
local spec = Hekili:NewSpecialization( 260 )

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
local IsSpellOverlayed = C_SpellActivationOverlay.IsSpellOverlayed
-- local IsSpellKnownOrOverridesKnown = C_SpellBook.IsSpellInSpellBook
-- local IsActiveSpell = ns.IsActiveSpell

-- Specialization-specific local functions (if any)
local GetUnitChargedPowerPoints = GetUnitChargedPowerPoints
local FindPlayerAuraByID = ns.FindPlayerAuraByID
local min = ns.safeMin

spec:RegisterResource( Enum.PowerType.ComboPoints )
spec:RegisterResource( Enum.PowerType.Energy, {
        blade_rush = {
            aura = "blade_rush",

            last = function ()
                local app = state.buff.blade_rush.applied
                local t = state.query_time

                return app + floor( t - app )
            end,

            interval = function() return class.auras.blade_rush.tick_time end,
            value = 5,
        },
    },
    nil, -- No replacement model.
    {    -- Meta function replacements.
        base_time_to_max = function( t )
            if buff.adrenaline_rush.up then
                if t.current > t.max - 50 then return 0 end
                return state:TimeToResource( t, t.max - 50 )
            end
        end,
        base_deficit = function( t )
            if buff.adrenaline_rush.up then
                return max( 0, ( t.max - 50 ) - t.current )
            end
        end,
    }
)

-- Talents
spec:RegisterTalents( {

    -- Rogue
    acrobatic_strikes              = {  90752,  455143, 1 }, -- Auto-attacks increase auto-attack damage and movement speed by $s1% for $s2 sec, stacking up to $s3%
    airborne_irritant              = {  90741,  200733, 1 }, -- Blind has $s1% reduced cooldown, $s2% reduced duration, and applies to all nearby enemies
    alacrity                       = {  90751,  193539, 2 }, -- Your finishing moves have a $s1% chance per combo point to grant $s2% Haste for $s3 sec, stacking up to $s4 times
    atrophic_poison                = {  90763,  381637, 1 }, -- Coats your weapons with a Non-Lethal Poison that lasts for $s1 |$s2hour:hrs;. Each strike has a $s3% chance of poisoning the enemy, reducing their damage by $s4% for $s5 sec
    blackjack                      = {  90686,  379005, 1 }, -- Enemies have $s1% reduced damage and healing for $s2 sec after Blind or Sap's effect on them ends
    blind                          = {  90684,    2094, 1 }, -- Blinds all enemies near the target, causing them to wander disoriented for $s1 sec. Damage may interrupt the effect. Limit $s2
    cheat_death                    = {  90742,   31230, 1 }, -- Fatal attacks instead reduce you to $s1% of your maximum health. For $s2 sec afterward, you take $s3% reduced damage. Cannot trigger more often than once per $s4 min
    cloak_of_shadows               = {  90697,   31224, 1 }, -- Provides a moment of magic immunity, instantly removing all harmful spell effects. The cloak lingers, causing you to resist harmful spells for $s1 sec
    cold_blood                     = {  90748,  382245, 1 }, -- Increases the critical strike chance of your next damaging ability by $s1%
    deadened_nerves                = {  90743,  231719, 1 }, -- Physical damage taken reduced by $s1%
    deadly_precision               = {  90760,  381542, 1 }, -- Increases the critical strike chance of your attacks that generate combo points by $s1%
    deeper_stratagem               = {  90750,  193531, 1 }, -- Gain $s1 additional max combo point. Your finishing moves that consume more than $s2 combo points have increased effects, and your finishing moves deal $s3% increased damage
    echoing_reprimand              = {  90638,  470669, 1 }, -- After consuming a supercharged combo point, your next Sinister Strike also strikes the target with an Echoing Reprimand dealing $s$s2 Physical damage
    elusiveness                    = {  90742,   79008, 1 }, -- Evasion also reduces damage taken by $s1%, and Feint also reduces non-area-of-effect damage taken by $s2%
    evasion                        = {  90764,    5277, 1 }, -- Increases your dodge chance by $s1% for $s2 sec
    featherfoot                    = {  94563,  423683, 1 }, -- Sprint increases movement speed by an additional $s1% and has $s2 sec increased duration
    fleet_footed                   = {  90762,  378813, 1 }, -- Movement speed increased by $s1%
    forced_induction               = {  90638,  470668, 1 }, -- Increase the bonus granted when a damaging finishing move consumes a supercharged combo point by $s1
    gouge                          = {  90741,    1776, 1 }, -- Gouges the eyes of an enemy target, incapacitating for $s1 sec. Damage may interrupt the effect. Must be in front of your target. Awards $s2 combo point
    graceful_guile                 = {  94562,  423647, 1 }, -- Feint has $s1 additional charge
    improved_ambush                = {  90692,  381620, 1 }, -- Ambush generates $s1 additional combo point
    improved_sprint                = {  90746,  231691, 1 }, -- Reduces the cooldown of Sprint by $s1 sec
    improved_wound_poison          = {  90637,  319066, 1 }, -- Wound Poison can now stack $s1 additional times
    iron_stomach                   = {  90744,  193546, 1 }, -- Increases the healing you receive from Crimson Vial, healing potions, and healthstones by $s1%
    leeching_poison                = {  90758,  280716, 1 }, -- Adds a Leeching effect to your Lethal poisons, granting you $s1% Leech
    lethality                      = {  90749,  382238, 2 }, -- Critical strike chance increased by $s1%. Critical strike damage bonus of your attacks that generate combo points increased by $s2%
    master_poisoner                = {  90636,  378436, 1 }, -- Increases the non-damaging effects of your weapon poisons by $s1%
    nimble_fingers                 = {  90745,  378427, 1 }, -- Energy cost of Feint and Crimson Vial reduced by $s1
    numbing_poison                 = {  90763,    5761, 1 }, -- Coats your weapons with a Non-Lethal Poison that lasts for $s1 |$s2hour:hrs;. Each strike has a $s3% chance of poisoning the enemy, clouding their mind and slowing their attack and casting speed by $s4% for $s5 sec
    recuperator                    = {  90640,  378996, 1 }, -- Slice and Dice heals you for up to $s1% of your maximum health per $s2 sec
    rushed_setup                   = {  90754,  378803, 1 }, -- The Energy costs of Kidney Shot, Cheap Shot, Sap, and Distract are reduced by $s1%
    shadowheart                    = { 101714,  455131, 1 }, -- Leech increased by $s1% while Stealthed
    shadowrunner                   = {  90687,  378807, 1 }, -- While Stealth or Shadow Dance is active, you move $s1% faster
    shiv                           = {  90740,    5938, 1 }, -- Attack with your off-hand, dealing $s$s2 Physical damage, dispelling all enrage effects and applying a concentrated form of your active Non-Lethal poison. Awards $s3 combo point
    soothing_darkness              = {  90691,  393970, 1 }, -- You are healed for $s1% of your maximum health over $s2 sec after activating Vanish
    stillshroud                    = {  94561,  423662, 1 }, -- Shroud of Concealment has $s1% reduced cooldown
    subterfuge                     = {  90688,  108208, 2 }, -- Abilities requiring Stealth can be used for $s1 sec after Stealth breaks. Combat benefits requiring Stealth persist for an additional $s2 sec after Stealth breaks
    supercharger                   = {  90639,  470347, 2 }, -- Roll the Bones supercharges $s1 combo point. Damaging finishing moves consume a supercharged combo point to function as if they spent $s2 additional combo points
    superior_mixture               = {  94567,  423701, 1 }, -- Crippling Poison reduces movement speed by an additional $s1%
    thistle_tea                    = {  90756,  381623, 1 }, -- Restore $s1 Energy. Mastery increased by $s2% for $s3 sec. When your Energy is reduced below $s4, drink a Thistle Tea
    thrill_seeking                 = {  90695,  394931, 1 }, -- Grappling Hook has $s1 additional charge
    tight_spender                  = {  90692,  381621, 1 }, -- Energy cost of finishing moves reduced by $s1%
    tricks_of_the_trade            = {  90686,   57934, 1 }, -- Redirects all threat you cause to the targeted party or raid member, beginning with your next damaging attack within the next $s1 sec and lasting $s2 sec
    unbreakable_stride             = {  90747,  400804, 1 }, -- Reduces the duration of movement slowing effects $s1%
    vigor                          = {  90759,   14983, 2 }, -- Increases your maximum Energy by $s1 and Energy regeneration by $s2%
    virulent_poisons               = {  90760,  381543, 1 }, -- Increases the damage of your weapon poisons by $s1%
    without_a_trace                = { 101713,  382513, 1 }, -- Vanish has $s1 additional charge

    -- Outlaw
    ace_up_your_sleeve             = {  90670,  381828, 1 }, -- Between the Eyes has a $s1% chance per combo point spent to grant $s2 combo points
    adrenaline_rush                = {  90659,   13750, 1 }, -- Increases your Energy regeneration rate by $s1%, your maximum Energy by $s2, and your attack speed by $s3% for $s4 sec
    ambidexterity                  = {  90660,  381822, 1 }, -- Main Gauche has an additional $s1% chance to strike while Blade Flurry is active
    audacity                       = {  90641,  381845, 1 }, -- Half-cost uses of Pistol Shot have a $s1% chance to make your next Ambush usable without Stealth. Chance to trigger this effect matches the chance for your Sinister Strike to strike an additional time
    blade_rush                     = {  90664,  271877, 1 }, -- Charge to your target with your blades out, dealing $s$s2 Physical damage to the target and $s3 to all other nearby enemies. While Blade Flurry is active, damage to non-primary targets is increased by $s4%. Generates $s5 Energy over $s6 sec
    blinding_powder                = {  90643,  256165, 1 }, -- Reduces the cooldown of Blind by $s1% and increases its range by $s2 yds
    combat_potency                 = {  90646,   61329, 1 }, -- Increases your Energy regeneration rate by $s1%
    combat_stamina                 = {  90648,  381877, 1 }, -- Stamina increased by $s1%
    count_the_odds                 = {  90655,  381982, 1 }, -- Ambush, Sinister Strike, and Dispatch have a $s1% chance to grant you a Roll the Bones combat enhancement buff you do not already have for $s2 sec
    crackshot                      = {  94565,  423703, 1 }, -- Entering Stealth refreshes the cooldown of Between the Eyes. Between the Eyes has no cooldown and also Dispatches the target for $s1% of normal damage when used from Stealth
    dancing_steel                  = {  90669,  272026, 1 }, -- Blade Flurry strikes $s1 additional enemies and its duration is increased by $s2 sec
    deft_maneuvers                 = {  90672,  381878, 1 }, -- Blade Flurry's initial damage is increased by $s1% and generates $s2 combo point per target struck
    devious_stratagem              = {  90679,  394321, 1 }, -- Gain $s1 additional max combo point. Your finishing moves that consume more than $s2 combo points have increased effects, and your finishing moves deal $s3% increased damage
    dirty_tricks                   = {  90645,  108216, 1 }, -- Cheap Shot, Gouge, and Sap no longer cost Energy
    fan_the_hammer                 = {  90666,  381846, 2 }, -- When Sinister Strike strikes an additional time, gain $s1 additional stack of Opportunity. Max $s2 stacks. Half-cost uses of Pistol Shot consume $s3 additional stack of Opportunity to fire $s4 additional shot. Additional shots generate $s5 fewer combo point and deal $s6% reduced damage
    fatal_flourish                 = {  90662,   35551, 1 }, -- Your off-hand attacks have a $s1% chance to generate $s2 Energy
    float_like_a_butterfly         = {  90755,  354897, 1 }, -- Restless Blades now also reduces the remaining cooldown of Evasion and Feint by $s1 sec per combo point spent
    ghostly_strike                 = {  90644,  196937, 1 }, -- Strikes an enemy, dealing $s$s2 Physical damage and causing the target to take $s3% increased damage from your abilities for $s4 sec. Awards $s5 combo point
    greenskins_wickers             = {  90665,  386823, 1 }, -- Between the Eyes has a $s1% chance per Combo Point to increase the damage of your next Pistol Shot by $s2%
    heavy_hitter                   = {  90642,  381885, 1 }, -- Attacks that generate combo points deal $s1% increased damage
    hidden_opportunity             = {  90675,  383281, 1 }, -- Effects that grant a chance for Sinister Strike to strike an additional time also apply to Ambush at $s1% of their value
    hit_and_run                    = {  90673,  196922, 1 }, -- Movement speed increased by $s1%
    improved_adrenaline_rush       = {  90654,  395422, 1 }, -- Generate full combo points when you gain Adrenaline Rush, and full Energy when it ends
    improved_between_the_eyes      = {  90671,  235484, 1 }, -- Critical strikes with Between the Eyes deal four times normal damage
    improved_main_gauche           = {  90668,  382746, 1 }, -- Main Gauche has an additional $s1% chance to strike
    keep_it_rolling                = {  90652,  381989, 1 }, -- Increase the remaining duration of your active Roll the Bones combat enhancements by $s1 sec
    killing_spree                  = {  94566,   51690, 1 }, -- Finishing move that unleashes a barrage of gunfire, striking random enemies within $s1 yards for Physical damage. Number of strikes increased per combo point. Restores $s2 combo point every $s3 sec. $s4 point : $s5 million over $s6 sec $s7 points: $s8 million over $s9 sec $s10 points: $s11 million over $s12 sec $s13 points: $s14 million over $s15 sec $s16 points: $s17 million over $s18 sec $s19 points: $s20 million over $s21 sec $s22 points: $s23 million over $s24 sec
    loaded_dice                    = {  90656,  256170, 1 }, -- Activating Adrenaline Rush causes your next Roll the Bones to grant at least two matches
    opportunity                    = {  90683,  279876, 1 }, -- Sinister Strike has a $s1% chance to hit an additional time, making your next Pistol Shot half cost and double damage
    precise_cuts                   = {  90667,  381985, 1 }, -- Blade Flurry damage is increased by an additional $s1% per missing target below its maximum
    precision_shot                 = {  90647,  428377, 1 }, -- Between the Eyes and Pistol Shot have $s1 yd increased range, and Pistol Shot reduces the the target's damage done to you by $s2%
    quick_draw                     = {  90663,  196938, 1 }, -- Half-cost uses of Pistol Shot granted by Sinister Strike now generate $s1 additional combo point, and deal $s2% additional damage
    retractable_hook               = {  90681,  256188, 1 }, -- Reduces the cooldown of Grappling Hook by $s1 sec, and increases its retraction speed
    riposte                        = {  90661,  344363, 1 }, -- Dodging an attack will trigger Mastery: Main Gauche. This effect may only occur once every $s1 sec
    ruthlessness                   = {  90680,   14161, 1 }, -- Your finishing moves have a $s1% chance per combo point spent to grant a combo point
    sleight_of_hand                = {  90651,  381839, 1 }, -- Roll the Bones has a $s1% increased chance of granting additional matches
    sting_like_a_bee               = {  90755,  131511, 1 }, -- Enemies disabled by your Cheap Shot or Kidney Shot take $s1% increased damage from all sources for $s2 sec
    summarily_dispatched           = {  90653,  381990, 2 }, -- When your Dispatch consumes $s1 or more combo points, Dispatch deals $s2% increased damage and costs $s3 less Energy for $s4 sec. Max $s5 stacks. Adding a stack does not refresh the duration
    swift_slasher                  = {  90649,  381988, 1 }, -- Slice and Dice grants additional attack speed equal to $s1% of your Haste
    take_em_by_surprise            = {  90676,  382742, 2 }, -- Haste increased by $s1% while Stealthed and for $s2 sec after breaking Stealth
    thiefs_versatility             = {  90753,  381619, 1 }, -- Versatility increased by $s1%
    triple_threat                  = {  90678,  381894, 1 }, -- Sinister Strike has a $s1% chance to strike with both weapons after it strikes an additional time
    underhanded_upper_hand         = {  90677,  424044, 1 }, -- Blade Flurry does not lose duration during Adrenaline Rush. Adrenaline Rush does not lose duration while Stealthed

    -- Fatebound
    chosens_revelry                = {  95138,  454300, 1 }, -- Leech increased by $s1% for each time your Fatebound Coin has flipped the same face in a row
    deal_fate                      = {  95107,  454419, 1 }, -- Sinister Strike and Ambush generate $s1 additional combo point when they strike an additional time
    deaths_arrival                 = {  95130,  454433, 1 }, -- Grappling Hook may be used a second time within $s1 sec with no cooldown, but its total cooldown is increased by $s2 sec
    delivered_doom                 = {  95119,  454426, 1 }, -- Damage dealt when your Fatebound Coin flips tails is increased by $s1% if there are no other enemies near the target. Each additional nearby enemy reduces this bonus by $s2%
    destiny_defined                = {  95114,  454435, 1 }, -- Sinister Strike has $s1% increased chance to strike an additional time and your Fatebound Coins flipped have an additional $s2% chance to match the same face as the last flip
    double_jeopardy                = {  95129,  454430, 1 }, -- Your first Fatebound Coin flip after breaking Stealth flips two coins that are guaranteed to match the same outcome
    edge_case                      = {  95139,  453457, 1 }, -- Activating Adrenaline Rush flips a Fatebound Coin and causes it to land on its edge, counting as both Heads and Tails
    fate_intertwined               = {  95120,  454429, 1 }, -- Fate Intertwined duplicates $s1% of Dispatch critical strike damage as Cosmic to $s2 additional nearby enemies. If there are no additional nearby targets, duplicate $s3% to the primary target instead
    fateful_ending                 = {  95127,  454428, 1 }, -- When your Fatebound Coin flips the same face for the seventh time in a row, keep the lucky coin to gain $s2% Agility until you leave combat for $s3 seconds. If you already have a lucky coin, it instead deals $s$s4 Cosmic damage to your target
    hand_of_fate                   = {  95125,  452536, 1 }, -- Flip a Fatebound Coin each time a finishing move consumes $s2 or more combo points. Heads increases the damage of your attacks by $s3%, lasting $s4 sec or until you flip Tails. Tails deals $s$s5 Cosmic damage to your target. For each time the same face is flipped in a row, Heads increases damage by an additional $s6% and Tails increases its damage by $s7%
    inevitabile_end                = {  95114,  454434, 1 }, -- Cold Blood now benefits the next two abilities but only applies to Dispatch. Fatebound Coins flipped by these abilities are guaranteed to match the same outcome as the last flip
    inexorable_march               = {  95130,  454432, 1 }, -- You cannot be slowed below $s1% of normal movement speed while your Fatebound Coin flips have an active streak of at least $s2 flips matching the same face
    mean_streak                    = {  95122,  453428, 1 }, -- Fatebound Coins flipped by Dispatch are $s1% more likely to match the same face as the last flip
    tempted_fate                   = {  95138,  454286, 1 }, -- You have a chance equal to your critical strike chance to absorb $s1% of any damage taken, up to a maximum chance of $s2%

    -- Trickster
    cloud_cover                    = {  95116,  441429, 1 }, -- Distract now also creates a cloud of smoke for $s1 sec. Cooldown increased to $s2 sec. Attacks from within the cloud apply Fazed
    coup_de_grace                  = {  95115,  441423, 1 }, -- After $s1 strikes with Unseen Blade, your next Dispatch will be performed as a Coup de Grace, functioning as if it had consumed $s2 additional combo points. If the primary target is Fazed, gain $s3 stacks of Flawless Form
    devious_distractions           = {  95133,  441263, 1 }, -- Killing Spree applies Fazed to any targets struck
    disorienting_strikes           = {  95118,  441274, 1 }, -- Killing Spree has $s1% reduced cooldown and allows your next $s2 strikes of Unseen Blade to ignore its cooldown
    dont_be_suspicious             = {  95134,  441415, 1 }, -- Blind and Shroud of Concealment have $s1% reduced cooldown. Pick Pocket and Sap have $s2 yd increased range
    flawless_form                  = {  95111,  441321, 1 }, -- Unseen Blade and Killing Spree increase the damage of your finishing moves by $s1% for $s2 sec. Multiple applications may overlap
    flickerstrike                  = {  95137,  441359, 1 }, -- Taking damage from an area-of-effect attack while Feint is active or dodging while Evasion is active refreshes your opportunity to strike with Unseen Blade. This effect may only occur once every $s1 sec
    mirrors                        = {  95141,  441250, 1 }, -- Feint reduces damage taken from area-of-effect attacks by an additional $s1%
    nimble_flurry                  = {  95128,  441367, 1 }, -- Blade Flurry damage is increased by $s1% while Flawless Form is active
    no_scruples                    = {  95116,  441398, 1 }, -- Finishing moves have $s1% increased chance to critically strike Fazed targets
    smoke                          = {  95141,  441247, 1 }, -- You take $s1% reduced damage from Fazed targets
    so_tricky                      = {  95134,  441403, 1 }, -- Tricks of the Trade's threat redirect duration is increased to $s1 hour
    surprising_strikes             = {  95121,  441273, 1 }, -- Attacks that generate combo points deal $s1% increased critical strike damage to Fazed targets
    thousand_cuts                  = {  95137,  441346, 1 }, -- Slice and Dice grants $s1% additional attack speed and gives your auto-attacks a chance to refresh your opportunity to strike with Unseen Blade
    unseen_blade                   = {  95140,  441146, 1 }, -- Sinister Strike and Ambush now also strike with an Unseen Blade dealing $s1 damage. Targets struck are Fazed for $s2 sec. Fazed enemies take $s3% more damage from you and cannot parry your attacks. This effect may occur once every $s4 sec
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    boarding_party                 =  853, -- (209752)
    control_is_king                =  138, -- (354406) Cheap Shot grants Slice and Dice for $s1 sec and Kidney Shot restores $s2 Energy per combo point spent
    dagger_in_the_dark             = 5549, -- (198675) Each second while Stealth is active, nearby enemies within $s1 yards take an additional $s2% damage from you for $s3 sec. Stacks up to $s4 times
    death_from_above               = 3619, -- (269513) Finishing move that empowers your weapons with energy to perform a deadly attack. You leap into the air and Dispatch your target on the way back down, with such force that it has a $s1% stronger effect
    dismantle                      =  145, -- (207777) Disarm the enemy, preventing the use of any weapons or shield for $s1 sec
    drink_up_me_hearties           =  139, -- (354425)
    maneuverability                =  129, -- (197000) Sprint has $s1% reduced cooldown and $s2% reduced duration
    preemptive_maneuver            = 5699, -- (1219122) Feint decreases your damage taken by an additional $s1% while stunned and its energy cost is reduced by $s2%
    smoke_bomb                     = 3483, -- (212182) Creates a cloud of thick smoke in an $s1 yard radius around the Rogue for $s2 sec. Enemies are unable to target into or out of the smoke cloud
    thick_as_thieves               = 1208, -- (221622) Tricks of the Trade now increases the friendly target's damage by $s1% for $s2 sec
    turn_the_tables                = 3421, -- (198020)
} )

local rtb_buff_list = {
    "broadside", "buried_treasure", "grand_melee", "ruthless_precision", "skull_and_crossbones", "true_bearing", "rtb_buff_1", "rtb_buff_2"
}

-- Auras
spec:RegisterAuras( {
    -- Talent: Energy regeneration increased by $w1%.  Maximum Energy increased by $w4.  Attack speed increased by $w2%.  $?$w5>0[Damage increased by $w5%.][]
    -- https://wowhead.com/beta/spell=13750
    adrenaline_rush = {
        id = 13750,
        duration = 20,
        max_stack = 1
    },
    -- Talent: Each strike has a chance of poisoning the enemy, reducing their damage by ${$392388s1*-1}.1% for $392388d.
    -- https://wowhead.com/beta/spell=381637
    atrophic_poison = {
        id = 381637,
        duration = 3600,
        max_stack = 1
    },
    -- Talent: Damage reduced by ${$W1*-1}.1%.
    -- https://wowhead.com/beta/spell=392388
    atrophic_poison_dot = {
        id = 392388,
        duration = 10,
        type = "Magic",
        max_stack = 1
    },
    alacrity = {
        id = 193538,
        duration = 15,
        max_stack = 5
    },
    audacity = {
        id = 386270,
        duration = 10,
        max_stack = 1,
    },
    -- $w2% increased critical strike chance.
    between_the_eyes = {
        id = 315341,
        duration = function() return 3 * effective_combo_points end,
        max_stack = 1
    },
    -- Talent: Attacks striking nearby enemies.
    -- https://wowhead.com/beta/spell=13877
    blade_flurry = {
        id = 13877,
        duration = function () return talent.dancing_steel.enabled and 13 or 10 end,
        max_stack = 1
    },
    -- Talent: Generates $s1 Energy every sec.
    -- https://wowhead.com/beta/spell=271896
    blade_rush = {
        id = 271896,
        duration = 5,
        tick_time = 1,
        max_stack = 1
    },
    coup_de_grace = {
        id = 462127,
        duration = 3600,
        max_stack = 1
    },
    disorienting_strikes = {
        duration = 3600,
        max_stack = 2
    },
    echoing_reprimand = {
        id = 470671,
        duration = 30,
        max_stack = 1
    },
    escalating_blade = {
        id = 441786,
        duration = 3600,
        max_stack = 4
    },
    -- Taking 5% more damage from $auracaster.
    fazed = {
        id = 441224,
        duration = 10,
        max_stack = 1
    },
    flawless_form = {
        id = 441326,
        duration = 12,
        max_stack = 20
    },
    -- Talent: Taking $s3% increased damage from the Rogue's abilities.
    -- https://wowhead.com/beta/spell=196937
    ghostly_strike = {
        id = 196937,
        duration = 10,
        max_stack = 1
    },
    -- Suffering $w1 damage every $t1 sec.
    -- https://wowhead.com/beta/spell=154953
    internal_bleeding = {
        id = 154953,
        duration = 6,
        tick_time = 1,
        mechanic = "bleed",
        max_stack = 1
    },
    -- Increase the remaining duration of your active Roll the Bones combat enhancements by 30 sec.
    keep_it_rolling = {
        id = 381989
    },
    -- Killing Spree Blasting nearby enemies every $s1 sec. $s2 seconds remaining
    -- https://www.wowhead.com/spell=51690
    killing_spree = {
        id = 51690,
        duration = function () return 0.5 * effective_combo_points * haste end,
        tick_time = function () return 0.5 * haste end,
        max_stack = 1
    },
    -- Suffering $w4 Nature damage every $t4 sec.
    -- https://wowhead.com/beta/spell=385627
    kingsbane = {
        id = 385627,
        duration = 14,
        max_stack = 50
    },
    -- Talent: Leech increased by $s1%.
    -- https://wowhead.com/beta/spell=108211
    leeching_poison = {
        id = 108211,
        duration = 3600,
        max_stack = 1
    },
    -- Talent: Your next $?s5171[Slice and Dice will be $w1% more effective][Roll the Bones will grant at least two matches].
    -- https://wowhead.com/beta/spell=256171
    loaded_dice = {
        id = 256171,
        duration = 45,
        max_stack = 1,
        copy = 240837
    },
    -- Suffering $w1 Nature damage every $t1 sec.
    -- https://wowhead.com/beta/spell=286581
    nothing_personal = {
        id = 286581,
        duration = 20,
        tick_time = 2,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Your next Pistol Shot costs $s1% less Energy and deals $s3% increased damage.
    -- https://wowhead.com/beta/spell=195627
    opportunity = {
        id = 195627,
        duration = 12,
        max_stack = 6
    },
    -- Movement speed reduced by $s3%.
    -- https://wowhead.com/beta/spell=185763
    pistol_shot = {
        id = 185763,
        duration = 6,
        max_stack = 1
    },
    -- Incapacitated.
    -- https://wowhead.com/beta/spell=107079
    quaking_palm = {
        id = 107079,
        duration = 4,
        max_stack = 1
    },
    riposte = {
        id = 199754,
        duration = 10,
        max_stack = 1
    },
    sharpened_sabers = {
        id = 252285,
        duration = 15,
        max_stack = 2
    },
    soothing_darkness = {
        id = 393971,
        duration = 6,
        max_stack = 1
    },
    -- Movement speed increased by $w1%.$?s245751[    Allows you to run over water.][]
    -- https://wowhead.com/beta/spell=2983
    sprint = {
        id = 2983,
        duration = 8,
        max_stack = 1
    },
    subterfuge = {
        id = 115192,
        duration = function() return 3 * talent.subterfuge.rank end,
        max_stack = 1
    },
    -- Damage taken increased by $w1%.
    stinging_vulnerability = {
        id = 255909,
        duration = 6,
        max_stack = 1
    },
    summarily_dispatched = {
        id = 386868,
        duration = 8,
        max_stack = 5
    },
    -- Talent: Haste increased by $w1%.
    -- https://wowhead.com/beta/spell=385907
    take_em_by_surprise = {
        id = 385907,
        duration = function() return combat and 10 * talent.take_em_by_surprise.rank + 3 * talent.subterfuge.rank or 3600 end,
        max_stack = 1
    },
    -- Talent: Threat redirected from Rogue.
    -- https://wowhead.com/beta/spell=57934
    tricks_of_the_trade = {
        id = 57934,
        duration = 30,
        max_stack = 1
    },
    unseen_blade = {
        id = 459485,
        duration = 20,
        max_stack = 1
    },
    -- Real RtB buffs.
    broadside = {
        id = 193356,
        duration = 30
    },
    buried_treasure = {
        id = 199600,
        duration = 30
    },
    grand_melee = {
        id = 193358,
        duration = 30
    },
    ruthless_precision = {
        id = 193357,
        duration = 30
    },
    skull_and_crossbones = {
        id = 199603,
        duration = 30
    },
    true_bearing = {
        id = 193359,
        duration = 30
    },
    -- Fake buffs for forecasting.
    rtb_buff_1 = {
        duration = 30
    },
    rtb_buff_2 = {
        duration = 30
    },
    supercharged_combo_points = {
        -- todo: Find a way to find a true buff / ID for this as a failsafe? Currently fully emulated.
        duration = 3600,
        max_stack = function() return combo_points.max end,
        copy = { "supercharge", "supercharged", "supercharger" }
    },
    -- Roll the dice of fate, providing a random combat enhancement for 30 sec.
    roll_the_bones = {
        alias = rtb_buff_list,
        aliasMode = "longest", -- use duration info from the buff with the longest remaining time.
        aliasType = "buff",
        duration = 30
    },
    lethal_poison = {
        alias = { "instant_poison", "wound_poison" },
        aliasMode = "first",
        aliasType = "buff",
        duration = 3600
    },
    nonlethal_poison = {
        alias = { "numbing_poison", "crippling_poison", "atrophic_poison" },
        aliasMode = "first",
        aliasType = "buff",
        duration = 3600
    },

    -- Legendaries (Shadowlands)
    concealed_blunderbuss = {
        id = 340587,
        duration = 8,
        max_stack = 1
    },
    deathly_shadows = {
        id = 341202,
        duration = 15,
        max_stack = 1
    },
    greenskins_wickers = {
        id = 340573,
        duration = 15,
        max_stack = 1,
        copy = 394131
    },
    master_assassins_mark = {
        id = 340094,
        duration = 4,
        max_stack = 1,
        copy = "master_assassin_any"
    },

    -- Azerite
    snake_eyes = {
        id = 275863,
        duration = 30,
        max_stack = 1
    },
} )

local lastShot, numShots = 0, 0
local lastUnseenBlade, disorientStacks = 0, 0
local lastRoll = 0
local rollDuration = 30
local rtbApplicators = {
    roll_the_bones = true,
    ambush = true,
    dispatch = true,
    keep_it_rolling = true,
}
local restless_blades_list = {
    "adrenaline_rush",
    "between_the_eyes",
    "blade_flurry",
    "blade_rush",
    "ghostly_strike",
    "grappling_hook",
    "keep_it_rolling",
    "killing_spree",
    "roll_the_bones",
    "sprint",
    "vanish"
}

local killing_spree_cp

spec:RegisterCombatLogEvent( function( _, subtype, _,  sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName )
    if sourceGUID ~= state.GUID then return end

    local now = GetTime()

    -- SPELL_CAST_SUCCESS
    if subtype == "SPELL_CAST_SUCCESS" then

        if spellID == 185763 and state.talent.fan_the_hammer.enabled then
            -- Opportunity: Fan the Hammer can queue 1-2 extra Pistol Shots.
            if now - lastShot > 0.5 then
                local oppoStacks = ( select( 3, FindPlayerAuraByID( 195627 ) ) or 1 ) - 1
                lastShot = now
                numShots = min( state.talent.fan_the_hammer.rank, oppoStacks, 2 )

                Hekili:ForceUpdate( "FAN_THE_HAMMER", true )
            else
                numShots = max( 0, numShots - 1 )
            end
        end

        if spellID == 51690 and state.talent.disorienting_strikes.enabled then -- Killing Spree grants 2 stacks of Disorienting Strikes (hidden aura)
            disorientStacks = 2
        end

        if spellID == 193315 or spellID == 8676 then -- Sinister Strike (193315) or Ambush (8676) consumes 1 Disorienting Strike stack.
            disorientStacks = disorientStacks - 1

        end
        if spellID == 315508 then
            -- 1. ‑‑ compute pandemic before we overwrite rollDuration
            local elapsed    = now - lastRoll           -- time since previous roll
            local remaining  = max( 0, rollDuration - elapsed )   -- container time left
            local pandemic   = min( 9, max( 0, remaining ) )
            -- 2. ‑‑ reset container
            lastRoll     = now                          -- real start‑time
            rollDuration = 30 + pandemic                -- 30 s + up‑to‑9 s
        end
    end

    -- SPELL_DAMAGE
    if subtype == "SPELL_DAMAGE" then
        if spellID == 441144 then  -- Unseen Blade damage event.
            if disorientStacks < 0 then
                lastUnseenBlade = now
            end
        end
    end

    -- SPELL_AURA_APPLIED / SPELL_AURA_REFRESH
   --[[ if spellID == 315508 then
        if subtype == "SPELL_AURA_APPLIED" then
            lastRoll = now
            rollDuration = 30
        elseif subtype == "SPELL_AURA_REFRESH" then
            local pandemicExtension = min( 9, 60 - ( now - lastRoll ) )
            rollDuration = 30 + pandemicExtension
            lastRoll = now
        end

        if Hekili.ActiveDebug then
            Hekili:Debug( "Updated lastRoll to %.2f, rollDuration to %.2f", lastRoll, rollDuration )
        end
    end ]]
end)

spec:RegisterStateExpr( "rtb_buffs", function ()
    return buff.roll_the_bones.count
end )

spec:RegisterStateExpr( "last_unseen_blade", function ()
    return lastUnseenBlade
end )

spec:RegisterStateExpr( "disorient_stacks", function ()
    return disorientStacks
end )

spec:RegisterStateExpr( "unseen_blades_available", function ()
    local count = 0

    -- add 1 if the ICD is cooled down
    if state.query_time - lastUnseenBlade >= 20 then count = count + 1 end

    -- add the # of bypasses that are available
    if disorientStacks > 0 then count = count + disorientStacks end

    return count
end )

local TriggerUnseenBlade = setfenv( function( )

    if unseen_blades_available > 0 then
        -- Handle ICD vs bypass
        if buff.disorienting_strikes.remains then
            removeStack( "disorienting_strikes" )
        else
            last_unseen_blade = query_time
            applyDebuff( "player", "unseen_blade" )
        end

        addStack( "escalating_blade" )
        if buff.escalating_blade.stack == 4 then applyBuff( "coup_de_grace" ) end
        applyDebuff( "target", "fazed" )
        unseen_blades_available = unseen_blades_available - 1
    end

end, state )

spec:RegisterStateExpr( "rtb_primary_remains", function ()
    local baseTime = max( lastRoll or 0, action.roll_the_bones.lastCast or 0 )
    return max( 0, baseTime + rollDuration - query_time )
end )

--[[   local remains = 0

    for rtb, appliedBy in pairs( rtbAuraAppliedBy ) do
        if appliedBy == "roll_the_bones" then
            local bone = buff[ rtb ]
            if bone.up then remains = max( remains, bone.remains ) end
        end
    end

    return remains
end ) ]]

spec:RegisterStateExpr( "rtb_buffs_shorter", function ()
    local n = 0
    local primary = rtb_primary_remains

    for _, rtb in ipairs( rtb_buff_list ) do
        local bone = buff[ rtb ]
        if bone.up and bone.remains < primary - 0.2 then -- Slightly larger threshold
            n = n + 1
        end
    end
    return n
end )

spec:RegisterStateExpr( "rtb_buffs_normal", function ()
    local n = 0
    local primary = rtb_primary_remains
    local tolerance = 0.2  -- Threshold for "close enough"

    for _, rtb in ipairs( rtb_buff_list ) do
        local bone = buff[ rtb ]
        if bone.up and abs( bone.remains - primary ) <= tolerance then
            n = n + 1
        end
    end
    return n
end )

spec:RegisterStateExpr( "rtb_buffs_min_remains", function ()
    local r = 3600

    for _, rtb in ipairs( rtb_buff_list ) do
        local bone = buff[ rtb ].remains
        if bone > 0 then r = min( r, bone ) end
    end

    return r == 3600 and 0 or r
end )

spec:RegisterStateExpr( "rtb_buffs_max_remains", function ()
    local r = 0

    for _, rtb in ipairs( rtb_buff_list ) do
        local bone = buff[ rtb ]
        r = max( r, bone.remains )
    end

    return r
end )

spec:RegisterStateExpr( "rtb_buffs_longer", function ()
    local n = 0
    local primary = rtb_primary_remains

    for _, rtb in ipairs( rtb_buff_list ) do
        local bone = buff[ rtb ]
        if bone.up and bone.remains > primary + 0.2 then -- Slightly larger threshold
            n = n + 1
        end
    end
    return n
end )

spec:RegisterStateExpr( "rtb_buffs_will_lose", function ()
    local count = 0
    count = count + ( rtb_buffs_will_lose_buff.broadside and 1 or 0 )
    count = count + ( rtb_buffs_will_lose_buff.buried_treasure and 1 or 0 )
    count = count + ( rtb_buffs_will_lose_buff.grand_melee and 1 or 0 )
    count = count + ( rtb_buffs_will_lose_buff.ruthless_precision and 1 or 0 )
    count = count + ( rtb_buffs_will_lose_buff.skull_and_crossbones and 1 or 0 )
    count = count + ( rtb_buffs_will_lose_buff.true_bearing and 1 or 0 )
    return count
end )

spec:RegisterStateTable( "rtb_buffs_will_lose_buff", setmetatable( {}, {
    __index = function( t, k )
        return buff[ k ].up and buff[ k ].remains <= rtb_primary_remains + 0.1
    end
} ) )

spec:RegisterStateTable( "rtb_buffs_will_retain_buff", setmetatable( {}, {
    __index = function( t, k )
        return buff[ k ].up and not rtb_buffs_will_lose_buff[ k ]
    end
} ) )

spec:RegisterStateExpr( "cp_max_spend", function ()
    return combo_points.max
end )

spec:RegisterUnitEvent( "UNIT_POWER_UPDATE", "player", nil, function( event, unit, resource )
    if resource == "COMBO_POINTS" then
        Hekili:ForceUpdate( event, true )
    end
end )

spec:RegisterStateExpr( "mantle_duration", function ()
    return legendary.mark_of_the_master_assassin.enabled and 4 or 0
end )

spec:RegisterStateExpr( "master_assassin_remains", function ()
    if not legendary.mark_of_the_master_assassin.enabled then
        return 0
    end

    if stealthed.mantle then
        return cooldown.global_cooldown.remains + 4
    elseif buff.master_assassins_mark.up then
        return buff.master_assassins_mark.remains
    end

    return 0
end )

spec:RegisterStateExpr( "cp_gain", function ()
    return ( this_action and class.abilities[ this_action ].cp_gain or 0 )
end )

spec:RegisterStateExpr( "effective_combo_points", function ()
    local c = combo_points.current or 0

    if c > 0 and buff.supercharged_combo_points.up then
        c = c + ( talent.forced_induction.enabled and 3 or 2 )
    end

    return c
end )

-- We need to break stealth when we start combat from an ability.
spec:RegisterHook( "runHandler", function( ability )
    local a = class.abilities[ ability ]

    -- if ability ~= "coup_de_grace" then coup_de_bug = false end

    if stealthed.all and ( not a or a.startsCombat ) then
        if buff.stealth.up then
            setCooldown( "stealth", 2 )
            if buff.take_em_by_surprise.up then
                buff.take_em_by_surprise.expires = query_time + 10 * talent.take_em_by_surprise.rank
            end
            if talent.subterfuge.enabled then
                applyBuff( "subterfuge" )
            end
        end

        if legendary.mark_of_the_master_assassin.enabled and stealthed.mantle then
            applyBuff( "master_assassins_mark" )
        end

        removeBuff( "stealth" )
        removeBuff( "shadowmeld" )
        removeBuff( "vanish" )
    end
    if buff.cold_blood.up and ( ability == "ambush" or not talent.inevitable_end.enabled ) and ( not a or a.startsCombat ) then
        removeStack( "cold_blood" )
    end

    class.abilities.apply_poison = class.abilities[ action.apply_poison_actual.next_poison ]
end )

spec:RegisterHook( "spend", function( amt, resource )
    if amt > 0 and resource == "combo_points" then
        if amt >= 5 and talent.ruthlessness.enabled then gain( 1, "combo_points" ) end

        local cdr = amt * ( buff.true_bearing.up and 1.5 or 1 )

        for _, action in ipairs( restless_blades_list ) do
            reduceCooldown( action, cdr )
        end

        if talent.float_like_a_butterfly.enabled then
            reduceCooldown( "evasion", amt * 0.5 )
            reduceCooldown( "feint", amt * 0.5 )
        end

        if legendary.obedience.enabled and buff.flagellation_buff.up then
            reduceCooldown( "flagellation", amt )
        end
    end
end )

local ExpireAdrenalineRush = setfenv( function ()
    gain( energy.max, "energy" )
end, state )

for i = 1, 7 do
    spec:RegisterStateExpr( "supercharge_" .. i, function ()
        return buff.supercharged_combo_points.stack >= i
    end )
end

spec:RegisterHook( "reset_precast", function()

    local now = query_time

    -- Supercharged Combo Point handling
    local cPoints = GetUnitChargedPowerPoints( "player" )
    if talent.supercharger.enabled and cPoints then
        local charged = 0
        for _, point in pairs( cPoints ) do
            charged = charged + 1
        end
        if charged > 0 then applyBuff( "supercharged_combo_points", nil, charged ) end
    end

    if buff.killing_spree.up then setCooldown( "global_cooldown", max( gcd.remains, buff.killing_spree.remains ) ) end

    if buff.adrenaline_rush.up and talent.improved_adrenaline_rush.enabled then
        state:QueueAuraExpiration( "adrenaline_rush", ExpireAdrenalineRush, buff.adrenaline_rush.expires )
    end

    if buff.cold_blood.up then setCooldown( "cold_blood", action.cold_blood.cooldown ) end

    class.abilities.apply_poison = class.abilities[ action.apply_poison_actual.next_poison ]

    if talent.unseen_blade.enabled then

        -- Sync CDG availabilty with gamestate
        if talent.coup_de_grace.enabled and IsSpellOverlayed( 2098 ) then
            applyBuff( "coup_de_grace" )
        end

        -- Sync unseen blade ICD with gamestate
        local unseenBladeCD = 20 - ( now - last_unseen_blade )
        if unseenBladeCD > 0 then
            applyDebuff( "player", "unseen_blade", unseenBladeCD )
        else
            removeDebuff( "player", "unseen_blade" )
        end

        -- sync disorienting strike stacks with gamestate
        if disorient_stacks > 0 then
            applyBuff( "disorienting_strikes", nil, disorient_stacks )
        else
            removeBuff( "disorienting_strikes" )
        end
        if Hekili.ActiveDebug then
            Hekili:Debug( "UB-Status: unseen_blades_available=%d DS=%d  ICD=%.1f",
              unseen_blades_available,
              buff.disorienting_strikes.stack or 0,
              unseenBladeCD
            )
        end
    end

    -- Debugging for Roll the Bones
    if Hekili.ActiveDebug and buff.roll_the_bones.up then
       -- local elapsed = query_time - lastRoll
       -- local remaining = max( 0, rollDuration - elapsed )
       -- local pandemic = min( 9, remaining )
       -- Hekili:Debug( "RTB: elapsed=%.2f  pandemic=%.2f  duration=%.2f",
       --               elapsed, pandemic, rollDuration )
        Hekili:Debug( "RTB   queueBase=%.2f (lastRoll=%.2f / lastCast=%.2f)  rollDur=%.2f",
                      max( lastRoll or 0, action.roll_the_bones.lastCast or 0 ),
                      lastRoll or 0,
                      action.roll_the_bones.lastCast or 0,
                      rollDuration )
        Hekili:Debug( "\nRoll the Bones Debugging:" )
        Hekili:Debug( " - lastRoll: %.2f", lastRoll )
        Hekili:Debug( " - rollDuration: %.2f", rollDuration )
        Hekili:Debug( " - rtb_primary_remains: %.2f", rtb_primary_remains )
        Hekili:Debug( " - Totals  | longer: %d  normal: %d  shorter: %d  willLose: %d",
        rtb_buffs_longer, rtb_buffs_normal, rtb_buffs_shorter, rtb_buffs_will_lose )

        local lenTol = 0.2                             -- length tolerance for "longer" and "shorter"
        local primary  = rtb_primary_remains
        Hekili:Debug(" - Buff Status (vs. %.2f):", rtb_primary_remains)

        for i = 1, #rtb_buff_list do
            local name = rtb_buff_list[i]
            local b = buff[name]
            if b.up then
                local diff = b.remains - primary
                local label = diff > lenTol and "longer"
                             or diff < -lenTol and "shorter"
                             or                     "normal"
                local lose = rtb_buffs_will_lose_buff[name] and "*" or " "  -- mark with * what buff will be lost
                Hekili:Debug("   %s %-20s %5.2f [%s]", lose, name, b.remains, label)
            end
        end
    end

    -- Fan the Hammer.
    if query_time - lastShot < 0.5 and numShots > 0 then
        local n = numShots * ( action.pistol_shot.cp_gain - 1 )

        if Hekili.ActiveDebug then Hekili:Debug( "Generating %d combo points from pending Fan the Hammer casts; removing %d stacks of Opportunity.", n, numShots ) end
        gain( n, "combo_points" )
        removeStack( "opportunity", numShots )
    end

    if talent.underhanded_upper_hand.enabled and buff.adrenaline_rush.up then
        -- Revisit for all Stealth effects (and then resume countdown upon breaking Stealth).
        if buff.subterfuge.up then
            buff.adrenaline_rush.expires = buff.adrenaline_rush.expires + buff.subterfuge.remains
        end
        if buff.blade_flurry.up then
            buff.blade_flurry.expires = buff.blade_flurry.expires + buff.adrenaline_rush.remains
        end
    end

end )

spec:RegisterGear( {
    -- The War Within
    tww3 = {
        items = { 237667, 237665, 237663, 237664, 237662 },
        auras = {
            tww3_trickster_4pc = {
                -- id = 999998,
                duration = 5,
                max_stack = 1,
                generate = function( t )
                    local cdg = buff.coup_de_grace
                    if set_bonus.tww3 >= 4 and cdg.up and cdg.remains <= 10 then
                        -- Only treat this as the "trickster window" version if it's the 5s duration .. use 10s just as a safety net. The other version of the aura is 3600
                        t.name = "tww3_trickster_4pc"
                        t.count = 1
                        t.expires = cdg.expires
                        t.applied = cdg.expires - 5
                        t.caster = "player"
                    else
                        t.name = "tww3_trickster_4pc"
                        t.count = 0
                        t.expires = 0
                        t.applied = 0
                        t.caster = "nobody"
                    end
                end
            }
        },
    },
    tww2 = {
        items = { 229290, 229288, 229289, 229287, 229292 },
        auras = {
            -- 2-set
            winning_streak = {
                id = 1217078,
                duration = 3600,
                max_stack = 10
            }
        }
    },

    -- Dragonflight
    tier31 = {
        items = { 207234, 207235, 207236, 207237, 207239, 217208, 217210, 217206, 217207, 217209 }
    },
    tier30 = {
        items = { 202500, 202498, 202497, 202496, 202495 },
        auras = {
            soulrip = {
                id = 409604,
                duration = 8,
                max_stack = 1
            },
            soulripper = {
                id = 409606,
                duration = 15,
                max_stack = 1
            }
        }
    },
    tier29 = {
        items = { 200372, 200374, 200369, 200371, 200373 },
        auras = {
            vicious_followup = {
                id = 394879,
                duration = 15,
                max_stack = 1
            },
            brutal_opportunist = {
                id = 394888,
                duration = 15,
                max_stack = 1
            }
        }
    },

    -- Legion Legendary
    mantle_of_the_master_assassin = {
        items = { 144236 },
        auras = {
            master_assassins_initiative = {
                id = 235027,
                duration = 3600
            }
        }
    }
} )

-- Abilities
spec:RegisterAbilities( {
    -- Talent: Increases your Energy regeneration rate by $s1%, your maximum Energy by $s4, and your attack speed by $s2% for $d.
    adrenaline_rush = {
        id = 13750,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        talent = "adrenaline_rush",
        startsCombat = false,
        texture = 136206,

        toggle = "cooldowns",

        cp_gain = function () return talent.improved_adrenaline_rush.enabled and combo_points.max or 0 end,

        handler = function ()
            applyBuff( "adrenaline_rush" )
            if talent.improved_adrenaline_rush.enabled then
                gain( action.adrenaline_rush.cp_gain, "combo_points" )
                state:QueueAuraExpiration( "adrenaline_rush", ExpireAdrenalineRush, buff.adrenaline_rush.remains )
            end

            if talent.edge_case.enabled then
                addStack( "fatebound_coin_heads" )
                addStack( "fatebound_coin_tails" )
            end

            energy.regen = energy.regen * 1.6
            energy.max = energy.max + 50
            forecastResources( "energy" )

            if talent.loaded_dice.enabled then
                applyBuff( "loaded_dice" )
            end
            if talent.underhanded_upper_hand.enabled and buff.subterfuge.up then
                buff.adrenaline_rush.expires = buff.adrenaline_rush.expires + buff.subterfuge.remains
            end
            if azerite.brigands_blitz.enabled then
                applyBuff( "brigands_blitz" )
            end
        end
    },

    -- Finishing move that deals damage with your pistol, increasing your critical strike chance by $s2%.$?a235484[ Critical strikes with this ability deal four times normal damage.][];    1 point : ${$<damage>*1} damage, 3 sec;    2 points: ${$<damage>*2} damage, 6 sec;    3 points: ${$<damage>*3} damage, 9 sec;    4 points: ${$<damage>*4} damage, 12 sec;    5 points: ${$<damage>*5} damage, 15 sec$?s193531|((s394320|s394321)&!s193531)[;    6 points: ${$<damage>*6} damage, 18 sec][]$?s193531&(s394320|s394321)[;    7 points: ${$<damage>*7} damage, 21 sec][]
    between_the_eyes = {
        id = 315341,
        cast = 0,
        cooldown = function () return talent.crackshot.enabled and stealthed.rogue and 0 or 45 end,
        gcd = "totem",
        school = "physical",

        spend = function() return 25 * ( talent.tight_spender.enabled and 0.94 or 1 ) end,
        spendType = "energy",

        startsCombat = true,
        texture = 135610,

        usable = function() return combo_points.current > 0, "requires combo points" end,

        handler = function ()
            if talent.alacrity.rank > 1 and effective_combo_points > 9 then addStack( "alacrity" ) end

            applyBuff( "between_the_eyes" )

            if stealthed.rogue and talent.crackshot.enabled then
                spec.abilities.dispatch.handler()
            end

            if set_bonus.tier30_4pc > 0 and ( debuff.soulrip.up or active_dot.soulrip > 0 ) then
                removeDebuff( "target", "soulrip" )
                active_dot.soulrip = 0
                applyBuff( "soulripper" )
            end

            if azerite.deadshot.enabled then
                applyBuff( "deadshot" )
            end

            if legendary.greenskins_wickers.enabled or talent.greenskins_wickers.enabled and effective_combo_points >= 5 then
                applyBuff( "greenskins_wickers" )
            end

            spend( combo_points.current, "combo_points" )
            removeStack( "supercharged_combo_points" )
        end
    },

    -- Strikes up to $?a272026[$331850i][${$331850i-3}] nearby targets for $331850s1 Physical damage$?a381878[ that generates 1 combo point per target][], and causes your single target attacks to also strike up to $?a272026[${$s3+$272026s3}][$s3] additional nearby enemies for $s2% of normal damage for $d.
    blade_flurry = {
        id = 13877,
        cast = 0,
        cooldown = 30,
        gcd = "totem",
        school = "physical",

        spend = 15,
        spendType = "energy",

        startsCombat = false,

        cp_gain = function() return talent.deft_maneuvers.enabled and true_active_enemies or 0 end,
        handler = function ()
            applyBuff( "blade_flurry" )
            if talent.deft_maneuvers.enabled then gain( action.blade_flurry.cp_gain, "combo_points" ) end
            if talent.underhanded_upper_hand.enabled and buff.adrenaline_rush.up then buff.blade_flurry.expires = buff.blade_flurry.expires + buff.adrenaline_rush.remains end
        end
    },

    -- Talent: Charge to your target with your blades out, dealing ${$271881sw1*$271881s2/100} Physical damage to the target and $271881sw1 to all other nearby enemies.    While Blade Flurry is active, damage to non-primary targets is increased by $s1%.    |cFFFFFFFFGenerates ${$271896s1*$271896d/$271896t1} Energy over $271896d.
    blade_rush = {
        id = 271877,
        cast = 0,
        cooldown = 45,
        gcd = "totem",
        school = "physical",

        talent = "blade_rush",
        startsCombat = true,

        usable = function () return not settings.check_blade_rush_range or target.distance < ( talent.acrobatic_strikes.enabled and 9 or 6 ), "no gap-closer blade rush is on, target too far" end,

        handler = function ()
            applyBuff( "blade_rush" )
            setDistance( 5 )
        end
    },

    death_from_above = {
        id = 269513,
        cast = 0,
        cooldown = 30,
        gcd = "off",
        icd = 2,

        spend = function() return talent.tight_spender.enabled and 22.5 or 25 end,
        spendType = "energy",

        pvptalent = "death_from_above",
        startsCombat = true,

        usable = function() return combo_points.current > 0, "requires combo points" end,

        handler = function ()
            spend( combo_points.current, "combo_points" )
            removeStack( "supercharged_combo_points" )
        end
    },

    dismantle = {
        id = 207777,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        spend = 25,
        spendType = "energy",

        pvptalent = "dismantle",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "dismantle" )
        end
    },

    dispatch = {
        id = 2098,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "physical",

        spend = function() return 35 * ( talent.tight_spender.enabled and 0.94 or 1 ) - ( 5 * buff.summarily_dispatched.stack ) end,
        spendType = "energy",

        startsCombat = true,

        usable = function() return combo_points.current > 0, "requires combo points" end,
        nobuff = "coup_de_grace",

        handler = function ()
            removeBuff( "brutal_opportunist" )

            if talent.alacrity.rank > 1 and effective_combo_points > 9 then addStack( "alacrity" ) end

            if talent.summarily_dispatched.enabled and combo_points.current > 5 then
                addStack( "summarily_dispatched", ( buff.summarily_dispatched.up and buff.summarily_dispatched.remains or nil ), 1 )
            end


            if buff.slice_and_dice.up then
                buff.slice_and_dice.expires = buff.slice_and_dice.expires + combo_points.current * 3
            else applyBuff( "slice_and_dice", combo_points.current * 3 ) end

            if set_bonus.tier29_2pc > 0 then applyBuff( "vicious_followup" ) end

            spend( combo_points.current, "combo_points" )
            removeStack( "supercharged_combo_points" )
        end,

        bind = "coup_de_grace"
    },

    -- Finishing move that dispatches the enemy, dealing damage per combo point:     1 point  : ${$m1*1} damage     2 points: ${$m1*2} damage     3 points: ${$m1*3} damage     4 points: ${$m1*4} damage     5 points: ${$m1*5} damage$?s193531|((s394320|s394321)&!s193531)[     6 points: ${$m1*6} damage][]$?s193531&(s394320|s394321)[     7 points: ${$m1*7} damage][]
    coup_de_grace = {
        id = 441776,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "physical",
        known = 2098,

        spend = function() return 35 * ( talent.tight_spender.enabled and 0.94 or 1 ) - ( 5 * buff.summarily_dispatched.stack ) end,
        spendType = "energy",

        startsCombat = true,

        usable = function() return combo_points.current > 0, "requires combo points" end,
        buff = "coup_de_grace",
        talent = "coup_de_grace",

        handler = function ()

            spec.abilities.dispatch.handler()

            if debuff.fazed.up then addStack( "flawless_form", nil, 5 ) end

            if set_bonus.tww3 >= 4 and buff.tww3_trickster_4pc.down  then
                applyBuff( "coup_de_grace", 5 ) -- recast within 5 seconds
                applyBuff( "tww3_trickster_4pc" )
                applyBuff( "escalating_blade", 5, 4 )
            else
                removeBuff( "coup_de_grace" )
                removeBuff( "escalating_blade" )
                removeBuff( "tww3_trickster_4pc" )
            end

            setCooldown( "global_cooldown", 1.2 * ( buff.adrenaline_rush.up and haste or 1) )

        end,

        bind = "dispatch"
    },

    -- Talent: Strikes an enemy, dealing $s1 Physical damage and causing the target to take $s3% increased damage from your abilities for $d.    |cFFFFFFFFAwards $s2 combo $lpoint:points;.|r
    ghostly_strike = {
        id = 196937,
        cast = 0,
        cooldown = 90,
        gcd = "off",
        school = "physical",

        spend = 30,
        spendType = "energy",

        talent = "ghostly_strike",
        startsCombat = true,

        cp_gain = function () return 1 + ( buff.broadside.up and 1 or 0 ) end,

        handler = function ()
            applyDebuff( "target", "ghostly_strike" )
            gain( action.ghostly_strike.cp_gain, "combo_points" )
        end
    },

     -- Talent: Launch a grappling hook and pull yourself to the target location.
    grappling_hook = {
        id = 195457,
        cast = 0,
        cooldown = function () return ( 1 - conduit.quick_decisions.mod * 0.01 ) * ( talent.retractable_hook.enabled and 45 or 60 ) end,
        gcd = "off",
        school = "physical",

        startsCombat = false,
        texture = 1373906,

        handler = function ()
        end
    },

    -- Talent: Increase the remaining duration of your active Roll the Bones combat enhancements by $s1 sec.
    keep_it_rolling = {
        id = 381989,
        cast = 0,
        cooldown = 360,
        gcd = "off",
        school = "physical",

        talent = "keep_it_rolling",
        startsCombat = false,

        toggle = "cooldowns",
        buff = "roll_the_bones",

        handler = function ()
           for _, v in pairs( rtb_buff_list ) do
                if buff[ v ].up then
                    -- Add 30 seconds but cap the total duration at 60 seconds.
                    local newExpires = buff[ v ].expires + 30
                    buff[ v ].expires = min( newExpires, query_time + 60 )

                    -- Optional Debugging
                    if Hekili.ActiveDebug then
                        Hekili:Debug( "Keep It Rolling applied to '%s': New expires = %.2f (capped at 60 seconds).", v, buff[ v ].expires )
                    end
                end
            end
        end
    },

    -- Talent: Teleport to an enemy within 10 yards, attacking with both weapons for a total of $<dmg> Physical damage over $d.    While Blade Flurry is active, also hits up to $s5 nearby enemies for $s2% damage.
    killing_spree = {
        id = 51690,
        cast = function () return 0.5 * effective_combo_points * haste end,
        channeled = true,
        cooldown = function() return 180 * ( talent.disorienting_strikes.enabled and 0.9 or 1 ) end,
        gcd = "totem",
        school = "physical",
        texture = 6735718,

        spend = function() return 45 * ( talent.tight_spender.enabled and 0.94 or 1 ) end,
        spendType = "energy",

        talent = "killing_spree",
        startsCombat = true,

        toggle = "cooldowns",
        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()

        end,

        start = function ()
            applyBuff( "killing_spree" )
            killing_spree_cp = effective_combo_points
            spend( combo_points.current, "combo_points" )
            removeStack( "supercharged_combo_points" )

            if talent.disorienting_strikes.enabled then
                applyBuff( "disorienting_strikes" )
                unseen_blades_available = unseen_blades_available + 2
            end

            if talent.flawless_form.enabled then addStack( "flawless_form" ) end
        end,

        finish = function()
            gain ( killing_spree_cp, "combo_points" )
        end
    },

    -- Draw a concealed pistol and fire a quick shot at an enemy, dealing ${$s1*$<CAP>/$AP} Physical damage and reducing movement speed by $s3% for $d.    |cFFFFFFFFAwards $s2 combo $lpoint:points;.|r
    pistol_shot = {
        id = 185763,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "physical",

        spend = function () return 40 - ( buff.opportunity.up and 20 or 0 ) end,
        spendType = "energy",

        startsCombat = true,

        cp_gain = function () return buff.shadow_blades.up and combo_points.max or ( 1 + ( buff.broadside.up and 1 or 0 ) + ( talent.quick_draw.enabled and buff.opportunity.up and 1 or 0 ) + ( buff.concealed_blunderbuss.up and 2 or 0 ) ) end,

        handler = function ()
            gain( action.pistol_shot.cp_gain, "combo_points" )

            removeBuff( "deadshot" )
            removeBuff( "concealed_blunderbuss" ) -- Generating 2 extra combo points is purely a guess.
            removeBuff( "greenskins_wickers" )
            removeBuff( "tornado_trigger" )

            if buff.opportunity.up then
                removeStack( "opportunity" )
                if set_bonus.tier29_4pc > 0 then applyBuff( "brutal_opportunist" ) end
            end

            -- If Fan the Hammer is talented, let's generate more.
            if talent.fan_the_hammer.enabled then
                local shots = min( talent.fan_the_hammer.rank, buff.opportunity.stack )
                gain( shots * ( action.pistol_shot.cp_gain - 1 ), "combo_points" )
                removeStack( "opportunity", shots )
            end
        end
    },

    -- Talent: Roll the dice of fate, providing a random combat enhancement for $d.
    roll_the_bones = {
        id = 315508,
        cast = 0,
        cooldown = 45,
        gcd = "totem",
        school = "physical",

        spend = 25,
        spendType = "energy",

        startsCombat = false,

        handler = function ()
            local pandemic = 0

            for _, name in pairs( rtb_buff_list ) do
                if rtb_buffs_will_lose_buff[ name ] then
                    pandemic = min( 9, max( pandemic, buff[ name ].remains ) )
                    removeBuff( name )
                end
            end

            if talent.supercharger.enabled then
                addStack( "supercharged_combo_points", nil, talent.supercharger.rank )
            end

            if azerite.snake_eyes.enabled then
                applyBuff( "snake_eyes", nil, 5 )
            end

            applyBuff( "rtb_buff_1", nil, 30 + pandemic )

            if buff.loaded_dice.up then
                applyBuff( "rtb_buff_2", nil, 30 + pandemic )
                removeBuff( "loaded_dice" )
            end

            if pvptalent.take_your_cut.enabled then
                applyBuff( "take_your_cut" )
            end

        end
    },


    shiv = {
        id = 5938,
        cast = 0,
        cooldown = 25,
        gcd = "totem",
        school = "physical",

        spend = function () return legendary.tiny_toxic_blade.enabled and 0 or 20 end,
        spendType = "energy",

        talent = "shiv",
        startsCombat = true,

        cp_gain = function () return 1 + ( buff.shadow_blades.up and 1 or 0 ) + ( buff.broadside.up and 1 or 0 ) end,

        handler = function ()
            gain( action.shiv.cp_gain, "combo_points" )
            removeDebuff( "target", "dispellable_enrage" )
        end
    },

    shroud_of_concealment = {
        id = 114018,
        cast = 0,
        cooldown = 360,
        gcd = "totem",
        school = "physical",

        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            applyBuff( "shroud_of_concealment" )
        end
    },

    ambush = {
        id = 8676,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 50,
        spendType = "energy",

        startsCombat = true,
        usable = function () return stealthed.ambush or buff.audacity.up, "requires stealth or audacity/blindside/sepsis_buff" end,

        cp_gain = function ()
            return 2 + ( buff.broadside.up and 1 or 0 ) + talent.improved_ambush.rank + ( buff.cold_blood.up and not talent.inevitable_end.enabled and 1 or 0 )
        end,

        handler = function ()
            gain( action.ambush.cp_gain, "combo_points" )
            if buff.audacity.up then removeBuff( "audacity" ) end
            if talent.unseen_blade.enabled then TriggerUnseenBlade() end

        end,

        copy = 430023,
        bind = "sinister_strike"
    },

    sinister_strike = {
        id = 193315,
        known = 1752,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 45,
        spendType = "energy",

        startsCombat = true,
        texture = 136189,


        cp_gain = function () return 1 + ( buff.broadside.up and 1 or 0 ) end,

        handler = function ()
            gain( action.sinister_strike.cp_gain, "combo_points" )
            removeStack( "snake_eyes" )
            if talent.unseen_blade.enabled then TriggerUnseenBlade() end
            if talent.echoing_reprimand.enabled then removeBuff( "echoing_reprimand" ) end

        end,

        copy = 1752,

        bind = "ambush"
    },

    smoke_bomb = {
        id = 212182,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        pvptalent = "smoke_bomb",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "smoke_bomb" )
        end
    },
} )

-- Override this for rechecking.
spec:RegisterAbility( "shadowmeld", {
    id = 58984,
    cast = 0,
    cooldown = 120,
    gcd = "off",

    usable = function () return boss and group end,
    handler = function ()
        applyBuff( "shadowmeld" )
    end
} )

spec:RegisterRanges( "pick_pocket", "kick", "blind", "shadowstep" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    cycle = false,

    nameplates = true,
    nameplateRange = 10,
    rangeFilter = false,

    damage = true,
    damageExpiration = 6,

    potion = "tempered_potion",

    package = "狂徒Simc",
} )

local assassin = class.specs[ 259 ]

spec:RegisterSetting( "check_blade_rush_range", true, {
    name = strformat( "%s：仅限近战", Hekili:GetSpellLinkWithTexture( spec.abilities.blade_rush.id ) ),
    desc = strformat( "如果勾选，%s 将不会推荐在近战范围外使用。", Hekili:GetSpellLinkWithTexture( spec.abilities.blade_rush.id ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "allow_shadowmeld", false, {
    name = strformat( "%s: 在队伍中使用", Hekili:GetSpellLinkWithTexture( 58984 ) ),
    desc = strformat( "如果勾选，%s 在满足条件时可推荐给暗夜精灵。即使你的动作条没有变化，你的隐身能力也能在 %s 内使用。" ..
    "%s 只能在打 BOSS 或组队时推荐使用，以避免脱离战斗。", Hekili:GetSpellLinkWithTexture( 58984 ), Hekili:GetSpellLinkWithTexture( 58984 ), Hekili:GetSpellLinkWithTexture( 58984 ) ),
    type = "toggle",
    width = "full",
    get = function () return not Hekili.DB.profile.specs[ 260 ].abilities.shadowmeld.disabled end,
    set = function ( _, val )
        Hekili.DB.profile.specs[ 260 ].abilities.shadowmeld.disabled = not val
    end,
} )

spec:RegisterSetting( "solo_vanish", true, {
    name = strformat( "允许单人战斗时使用 %s", Hekili:GetSpellLinkWithTexture( 1856 ) ),  -- Vanish
    desc = strformat( "如果启用，即使你在单人战斗时也会推荐使用 %s，|cFFFF0000这可能会重置战斗|r。", Hekili:GetSpellLinkWithTexture( 1856 ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "vanish_charges_reserved", 0, {
    name = strformat( "预留 %s 的消耗", Hekili:GetSpellLinkWithTexture( 1856 ) ),
    desc = strformat( "如果设置大于0，如果导致剩余的点数充能次数减少，则不会推荐 %s。", Hekili:GetSpellLinkWithTexture( 1856 ) ),
    type = "range",
    min = 0,
    max = 2,
    step = 0.1,
    width = 1.5
} )

spec:RegisterSetting( "sinister_clash", -0.5, {
    name = strformat( "%s: 偏移冲突", Hekili:GetSpellLinkWithTexture( spec.abilities.sinister_strike.id ) ),
    desc = strformat( "如果设置小于0，如果在指定时间内有更高优先级的技能可用，则不会推荐 %s。\n\n"
        .. "例如：%s 将在3秒后准备就绪。|W%s|w 已经就绪。偏移冲突值设置为|cFF00B4FF-0.5|r秒。"
        .. "不会推荐使用|W%s|w，因为会假装在0.5秒内不可用。\n\n"
        .. "推荐： |cFF00B4FF-0.5|r秒", Hekili:GetSpellLinkWithTexture( spec.abilities.sinister_strike.id ),
        Hekili:GetSpellLinkWithTexture( assassin.abilities.ambush.id ), spec.abilities.sinister_strike.name, spec.abilities.sinister_strike.name ),
    type = "range",
    min = -3,
    max = 3,
    step = 0.1,
    get = function () return Hekili.DB.profile.specs[ 260 ].abilities.sinister_strike.clash end,
    set = function ( _, val )
        Hekili.DB.profile.specs[ 260 ].abilities.sinister_strike.clash = val
    end,
    width = 1.5,
} )

spec:RegisterPack( "狂徒Simc", 20250805, [[Hekili:L3ZAZTTTw(BXtNrrQ2wrs(rtZA5zssVTn92BB340TFyN1uuKqsSMIuLpIR3XJ(TVNZbaKaGauu2o520DMonwI4XbN3Va11JV(9xFvOFb76FAYOjNn6fJoB44Zh9vJMC9vf3THD9vB8dUXFj8hj(RH))pxwe7Fl(13fN6hItppTmlaE0QIIn5V85pFzuXQY5ddsx)88O1LX(frPjbz(lkWph885XPZFEXk2T(z3cdnk55VkahYVKfLMfvC3pgLxK)8q2c)Y4INNLUSK5LsB7qC(xF18YO4I3MC9CBG(5NcGUFzXQ0SRV6QO1VbaSOWqgF4SCy(hF82zVFfB7SFZpd(FemSD2vm)8u4Fpz7pGR3XJEXXJo7LBN9Trz5fBN9QF5h3(dB)H2N7e5Cp94j4CX9F7SFDdcM1pA8eNpA05MpAgSH)u62zRtZGp8M0YnBNfc)13L5ha)ZRlxkN9jhp5ehl8jhpUgCk1E04JhHGZR2Sj(oyxIYZzH6JmF7S(fR8tUb(J3(w273KgmyinD4OmIVPJhpC0WZeF5OVgqEhTDg8VJhj(xRBpFO48)L0iabMl)2xaOp(ehnUAIzfZ9YyzPXXBNvClZ)gLrJhH3XY3Wcas1p(nBN9ZByjmGcLZkkIswwpucs(x()Ek8Wm2hIYJW9D2IS01InQAOJ(6xwtgweLeLVcxYG0KWOIwM25QaZ)LpopGYba1TRyj08ZJczziyn71f)d47b2iyeaf9M8vPfYL6RoEYlEzt2TRVkgLqqrVpqlo8x)ejiZs8NhZcV(1GeajsvncIZplAd)lLWuzoizdhcexKx4Ne6Nb0Eu8keoBaRpCYNNwMaFjoe5dqWfei3o7FgfhtNIR2KXGfYVOGTEd8GcGHDvACy9XN2d(5NoYrW6KsidyyP3c)LpUnVdeCJz5Wd)LmwarC4JfppFGn86RGtrbG78V(Q(BNDaSv(XSKIHLj5mwI38y)q2qbEy7S7VxDm3WbxVCeARh0GTZ6rdtcldNZa(ly1aLuES7y5dZy(H3rdBE5IfdZeqP3gjqcJyTFeYrC52zNEDbOtAFii7lIg4skrSRFCEAnooAbmGYnSSGv(zlrw15mqlm7tb6lVEF9gJN)t2NZ)7ZIaw)cMXz39bx9iBogKDjbKIMHQkZtbIdxYbKK(TF7e4)l3SJm4y9JJwMuV2CiWhvteaNFu9yjPC0qjSgwTv8zVDHl7PWeQpev(RtgrJeiGfrR5wi4yxWMB5gVqM3scUI9Zl84G8ftbD0JQOOGwrV5PjL5dlU92t8kKyeVt3eauuK(D6(q)ujhrfcj25eRlIyd8b8fN5iNZHdgYbmyzg5BaF8mqRksfjkMkkTcJW36HlkJJbdbcMnok4c44Dg)4L5hXXKZtr9i9qv3lxv4vHbVqbw(YTZEbCAlU(k0UcjWd4fwEBQungPoM4Fb7rHp6tW74gQqL3VghiOjNB7IZxnIRljx7OIM4OVD7mGGnQn9iTcfvS7ta2espCrelBWrsqaPt3LwIWc(X40CgbriPzSeWqlpiHjkjiUmeXw4KjAu061SWiqPfkuao2HcU)Z3(oykVvUYWhFwij(K4xaeAyBoJVchryfadDRpYRuMueXru4ATztwQFaa8Ba7bS1rbibnzPUqMg77eotBpUdceO7Hhlp(PI48LYlFWhMpGjhYhgWI(bMx9oDbbJetu1sT2)p1yDoDIqaXLcUhfHbGNm0u4DOVKv0HV)NR1lYv53cz8KJpvmZJqlUrXmIyOOzTn0(27hpcP00jgO1DbV3xbFXr4t4yX(THihpUHbggBJxeiPYzZmnXyN8sKSAfRk2HY00Rwp7K0S1i74LelFRk72jTKuXHKZDkAjPikIysvb)ieifcLFte6rVWu9dq6tLuzQKVdsjKRnXeS4fcGYWYniU5SNoCdN7M9NWseRWH7apGEdP6othpF7IrWYXuhViyHXZ(5pfNDvP3kp609tlWprhhTdudXIiqrCMT0KNvi52EnilhIHyCKvhQfmHVpRehlZpZum3nUTdYQAJ6rteKRhn(5YZLC0h42FCJruahwV5IZkXxxWZJqyBw69xpVSHVoVgNfllhdq67bplatvIexarrttqs0(EkVdySOBsZkktGHyZxrE6j8svgvduLFzOFa(eUmPlNcYXGur)4Ybx6UHza5)CzbI9aY)cmEpMFCXQJu8hUMnv6MT4Kf9)YWGC5Rn8x0IldN7xjxDboj0xxURCll9bJ2fmwyTASCmfg5KCFcRSaCi45rzzSyg4vxHi(qlimjmPH4iusyuoaBacKCsMaPCfYU48bGGpkwXntrteqj(ysPGPX9phc9n4gYEWKAmUk5qmGlS8i0QM4X6gZAJQoOEBCbmxicJ0LxgBaArAShMUaRUy8kbdZ2zh6aVEigFFIWd1V3hSPGbeHjNOe9OwBSOt8GhcbQRl5Kc37BjBFvKx(FWpkMC0Yc)(cFEK1RO90w0rvC7wEwxKwuFOHIadbjxg(jAH3I4YSS7CPE3cw9iDrgI1Lmz)MFPsvUqo5BP1gJafO0hIhpqjzb51DT8ixomhxv2c8lqcrjQJVGKQ8jD(3kw)YeUM(x9oKuqgeSe3VapgYwua(KbYIGbNCnCiFsESeWRy0XJlbnXNkfHcsxpp1BtkeMJUZEvy4WmyXaJcmVmGRGia6Ig2doEqBoB0c94vfy2hY5bDDsfIea2jYpiuVOKLLXF77)E0RBdIbzhEotgOpITjAOabJ(2DlA3ftflMQ0AAl7pkrFkXzqcu(RHnQGhnm3tWL7pHqfxJJlkaxoaLNVHHoGipPh6YaPX4qc5ju(cKctGheEPl8waygBcBgIQGs9BO9FCBohTlvttOq6UH8TDp0b5liaippO1LYyzaUkiPvM4boQM9NBIY6IUNQdKdf)c0yF32eUC6Unk045QHbjdN8REGyZoJ)0rrKAA0xtk3malSWRqUoQX4xjq1Gz)1LR7aYSlQH77IPgXJ9Pn(qEMT4BXFuc6c9cZ8VTE5TZTpGsMt)2zDpK2Hb0)HuMMkZeZw6rj4DFUHkQxS3ekmNi8esYvyyHKvuvzGMeU5(KYimpzynnwE3rsxVu54fXuzsoPXj23)tezcXqGytd)9FuuuouneHtVAcA13NXwIabqDgp8SM49AEarQAStFXP1ctHYJT69Gf7)c65x7GEQLlvdk6VIMGBuloDRXu24B6Zm3X6ualNDBeUmsZnncbt1bweqhpYfNxAkMquzDynQSqC8CsteokIn43lX6zIzrQj4rEWX(apMu4rH8ZHQdEv(21EyoGfxVe2FIWnb8MXyThHb1iGmC9OqGCg3t9grr6jkMSTy90WwVJjW68J9MuWepDs7NaORpugdC08JELZrrjC2z)Ibdvai(YylwnDvdquszzLyfi0RggVEee3uE06188(GdMVdvEtwSYVqzFVbKmSf2q6gk7DQPXNNju8VIlzu5G2jHOnH3l5wrpSAzIwdrm8bi(EorRd6V7jvzWxTZgrGPhVXd4RIxvXxT59(UpL6k8XDjydLzsWtj0VWJjnqhtQ1AgbP4KfiluRoEP)oCRsrf1Iy)BPewasjRnJlSdKbfFs0uOz1Bdb2DGnDyYQAR4B1XJLL1M8YIWyOOaIYewvoEcNV)kPWIrbSRk4gzKdwE0R4mgdNFlX4ltUnhOeqZeHgOQ4oraq3XMCL4CQzy4RIodJRWlGyWJ94FWdlUoVe7Ifkim3M7UAitZebvPgbxNJKwPx4ZljuwA5sHkguVIAdfWdTGPkt3e4qTCbKMv1KZRzVq9aOOmY0lZ6PxvAKg4n1TRtim(k0MVsToDEA5SyzUgyT7XXuErapu3ZdfRhGZUquPfPzqeQf1MunE(MY4CdticZxYbgJfum373ldxUgxjJXQzAAU)suvaVeRnmmHjSKmEuzAQcyWgYb1uLJFsBdmTOWrBG(ww2cwqHNFEaOmZpj4oVCww566fTLX0sUMK8p1qlmhK)aoptAllkgPcWXc00vGAthg5sqvbyhseTyiQ5zMz6sR5wGMFTLX3klU)tyd5UE)o(wEOEY5HZiWbbY5VQALX0WJk0MZwqDXLzPH5M7R8(xF90Q2de1iqmc5PWnvggb6NLwftH1FyB67mRFHrQvTJtCr9DLhGgu)hgDE)GOXC5kyJwBTi(MTDsYnSI8Uic5238U22bOdst6QSORm8V2p07pkzSeSGQju7p(0aANjrcw2btDdZFI2ZXvBAqzgece4(oWp6ffMg3qTI2EQxXzr(j3RIjlDFs0tjntszE5CyZwuUuVvN68zBYidMTRihm)1K7IyIKc)tmmkqWPH81ORpPjl5LNXxThKscXyaQRYl3FhraJCKxz1AcrCvTK2K)1aOFetmkP)yT)Ye6dC5brQ14nqvD0IOkVWuuBfLmJWOCEGla4oH6CTKJ5PMMVkvG3VxMCZAFiYQSuGLIT03JVFnu70OT7ePyGEORvrT6nDUdG487szkNa4U867B4HvA0sOOdQL54mqCgOhQzTRSEsP4de4UIXqqe5yselg6NCNx4M894SH8E5XPOInXcQ46w130sshfJzYdaWN80c4t46ZrFWBRqTMMAC0twMMKRcu5TclryXtW2vGHz)WmJoSpqjDdJtkw0rOvXDOPp0zDq4kEoqPrKm922un0UnroqjSph7zNxREwRVtB2JwUIkQR9coBgv03Tsubyz6MOC6xWvPLUyXXldWkgdbG(TV)7RJkuT4xI8OY4ZRQwaa9XONb1ofMH5RgkUT8eFPOeho9igotjMP5LcO(k6jCyDrzwXkEB4MabPuiJRM05calVFpa2P)vkggr5AvDNAg7uuleLpmNMkgvX6QjAid6yukfEM6Is5tE4vdTw2YsDnNOuxtTqvBwwkLcWOUBALkb5oaIyBo2Ay13gfQH)7gUylA7xS62GtfV79VMdw5IMB0OHgXhX5FXTKf6S5gP0AGt6CC5RNw6Ce9HcFCMJ3WRBinJFom0z)Hwxu2MD2MsvzT02BtLTmNE3ME(on39g)QWwq9xPL52cLjRmML3A6luI13iqelMKSabKr16OP4(kDexBsE6Aw1iKTXcP0OUSUi3AvcAOEOAL)hyQkQ4nHLymD9SWJ5OLSEyT1PPIdXcy55(zyLDAEpmu7OarLCKUhIczeNkwToEtAGgPkSf8jgYe2Ug2Bx9qwgM1sW4q5giUep8d2IL2MBXUcsRTMXX6emQlApLUH35qP(H3w2ISxcoeJbEhFdxXBCkhFAITqxakt0spAvNxyEDdq39AwkOCstXkWaiYjvZzHxKkj9tHXc2nD(Q2IVQNOoQoUOaYRQImqi7x1GkFgC2ou1rvrJR5nfqjV9TK9qRjgSrTSEKuRacXSiM9N861ifqiLrCIxT8pUQ1xNlURdULW3bLWDnbQF4hvXRUH6f6EkSujUwvpvx)qTBYLu3um8iIMKIedKijcOetCqAMAMW5NqPzuzP1oYyHj3VvQok)lLTvjzzTUuaAn5KO2ekZTUR1EVp6T5ZyG91xJUFwsHileEvAlOaWHX8wleRu6RZoWBHXyGsGaDKdz35MO77AhIuWbB4EaS9noG7gK31QUpfhZA1(LYr7FNDQkLzwhYQJB3A9ZEQ1jSayl9yR9MdXpjyjTwUWW0s478(Dw6gWZa9gjv8F1fEWIKD(kFWsXAwCOH093HfkbZyCGFrWQJ5krrzIRQMb2qISGvjrOMr0bfXLgfDI6BktwYsta9mbczjX38U0s8oZMhHEHfWDcBDuwgoeJlFkIbX7yUUyxlIx90VRMIe4vB2ZARt4kqoESgwYzafQGiKgU)tvndf6eTSo1PwAP6HUQuf69LxrQhfX6Ls33TcVMrIzMgM400W4Y8I6Q(6(YUDYOwZqqnYytk9V4(FMwjSWDZdIM9oZkDDU2Wa)Kyz3qHDPpSVsDylIYy0kAoQxOv(RKamHC(XEbu5m1hAR(69328A2cnUJzZCsRUD9VH0zUFjd0rwmN4YJMpcPXC)ayr2lLfqTLmygaQZ8eIf6Lnqw81oOCSTe11wtI9psaZpm13abZEnhdjeK(h3rT6Kuej)MiWaDOs(rfQ5A02xo17Aqa2rIdTbneJzfeFe2dKbmuUvifNX4Dej1R(O6zfBADcBUB377x7PrTj2kEPAT607Wehx1Woai1Onq30g0sDBPaRL(qnHBRkV6Q)mrlpRu3VBVhujK93LHvfeuWR3SWAnJ9Hkx)STvxuTdvmDAMQ2UeaL9K06UVTvcH9Cn3EB0H8nt39yfRLlRoXE3cb(I9NFvFJAMQSgNO9QHglQIoExfT(BL5KWQYdlAaufjDOoOfjvT0hC9vrYgw0lAr1j1iRR9urQxovn17gNfl5I18kOfGEceB5DncVIOGFFbROVxwha69ka9nKYcFKTd3THQa)Y405(X82fGlswJl1A7xn)oCE7uAxBMJ7Dh5uHnnByCRRRYRo9aKButOZ6lkfTaHRJ(TwUfl3fXglB(SQONhA9EasAe4nLxov4e6D3IANQAwPcsSXX9XSsSYY7xfLlyVzGHRzG0p4odZ)g7Xq3MOQ(szzq1RyLqTnBYA8bA(ZwPtwBmKenEHEWXWFbvD6eWlTB9ZWRvpWIqVwFIwJkhe6xFgpwMNHC1)rjyaluMpB)YIuGlg)IGv4RdH8HB)HFKsag(Mp6nPjWwrp(zCRrQVnwa8WZ4Sdpt77HVS)4)eFvorGYIuSDJjbh)YmmbM3YqNcQZzoxEkGBBeZTeI6lKJJyMwWZJs9OddXbh6x4JHa9YT)a1DTAWb(A1YcYG81C)Wf4BsQFfmFrACXbaWUhUo1G9)nmlZEn5)5)aDGPaZwfqmjAy1sEANws7DGrBR75gKnPJNnDuws7AXx6AkjFX)khlEtNABS4whIyXTsMccFaej7NCRfT0YX3140WbU2gh1g1cIOtBZKrFmjKtg)XIs(21sg6VwxMgjuufAda1wNpcBGvqA5NtuE1)LLUic7P(V4l2o7t0l9VT)aUzxvTYVbxze1SEn69Wv3Le8s0C1xpzb7e(G)gG97Libs(U8dp28tA(WQoh8WPpxTtBTpcPm)ryG)tD34E2NT0IFJUvC6easXxHFFo2EPoWL6PxY2z(OOft3rdP0ZHFLIVwPFE7znPw0vOXk8PxVzxG3EUO7(qpUlh6w2vIp5rE5KQG9AwsAzFAUcsQRoEjKu)SmWwU4Jzc0pIUAot77mQP7V32no6YPtoSbgLw6dBeP3GE88tC50ZgrN5)oE3xCJXnZNGaJ7okTJhFCFTCs3Zmi97VVIEPCxNU)Ez86Q3VPb9CsA713Smn3FFJG5b63a1dNzjA5hsWpeI0(0FtC29El1WZVOmCPD9QgUZLGtJ0wb3jMANRg)LwGYW0V6l4QB5k0C50XNDO2L2T5kqxog1V34UWO(iTR(Iqj2J7TNtT(x6eIGfnhf1RwyYAukqeq(S(LHtt8GXnGTYkMJ3so9oqx(UFlTcYLt6zpbBx4UMP3F)boPhd61YMDXPe15VwVeBAIUvsYQcVNEAkLQ9KCETOg0IoVEhyLT9ZX3(mnrFQT4Pc(t)vHsp(0LVhAUC6P96RAZ6IPta2mhv1SMbu9TnZach(z1BmMhkYZMptt1A82M(j1t75xo9KJTyKVN7CYpDSIW7NSxZlpmPtoaBr1gGg6BxF3LtBtHxJNjsQ5ftgOGv6mE4r(6A5HHuSJnS7(D)Xhk9bS(fYHfFV)Y(UX)hoEWaD37VqcyQVbw4iW)k(AuzNO5d2d8SnxYuDh7lhp8m7bdDX0XnX8vEJ389Ls1JmFxP00QZG6aMEQFHN0e5Pv8fc9z4g9xGK9)T8gnXcLwTeAhjRYgQd8b4K6o9Ot4)8h)7YunKaHuzj7givXHr3E9pWzql1gKDLaKbcDOww3DL6ed3cSgi4h3lFKjwt)ErHinnyunA76OMBQG8YX1IFprxTitiLFxMqiS)osfpaOTNeDHN9MxTidg3DCrHmHpt3Dm8rryb32Lg6cGIwJ((C7E)yIhmsgkIkQUapOVXvFyi)M(qUhB(Lxo9S6bo9Cc7SpxRhtGYE6h0ZYQYM8P(M70nWLVNvUy8j9Y4ycH8saRyQWEBrl1iw3w12tFCZi9ToSkxv7TRlCZLNms3zSoFfn(uCHAmXMgxRgTuT1W7c0rx3xPMQAsO(iHflh5nz6PINB9QZmOxlj47bHHFKxcMUjSuZGEq7PiU3tfdC7OP))4fuXTsdto6o4owfbBa4(wR0S65ut1SVo7WpofI(o2W(9BBlTpR2Q3qJWB2)uB2Z5vbbax3z9SNmmylx6JkpanUOhdgmGh(1FPUNgnCGScgATQf9oW6D2ONLq8Emx(c7UpkJCXX1X4YtBag6Rc)QruLvD17FbOJhuv0tRFWV4KrodMPjakVDfnEs1fQW8jv3HIgbRPDTjiK5h7RdHjiO3SeUUnc1OYMTIpxMS9lgXLtoZkI)m6m31BYGlyp)iQp(NkoJJBdARJkQz)8yfeNozuh33jDBFB2PpU3xUnZkVWQGdU0kLcgztpA5HUt5XxynaRpEnZRfGtZZSJuBuzPV0DVpLpYSvHvtRJcUsjDvTvvX)E0QVwWaM8LuAeiowR9aSqPOR()9ItRTTR01VOJj08S2JV1tP5JhSVm4YM5viOiFbXvpsskTHwo3TewtNYGGY9Jc7zvaDYU2OMVC22Rn4SDT(n6n29A5hZ1(E1t(B6SDb227)wIzunhj1SkgAcKUSw92GZMRUdAJYn6tSTw74HpQwBBJR6bzZ18m80z1Tv6uh3(hHX3w3EJSH21FMiRHB9SRDyJMAunXGthPu7X)w97b5EHpA(ZzMs6sR(zWduGPeXm9qJFIiV4m1uQQ8lA4fNQvL3pN(bE8XIiR1WszCUVD8Z4XTO81gT4S6Kfu)BixJKCF5Ob6TfZFv(TyCVWQh0v(tsDKXpBEUp(pYFUfF0hbBeqlNGEQmqwpoFw8lO4JgD5q8O3bpe8OitxAD3ZbUDmx8mJFMefgRKT6C1bu4pOMZ0TM7hAzEYUL52aKwJm9J91j3gazlYi35gRrYZfr8ODTYV)(AhXPBiZaBBSmeMDtq(RZ9b3kf1A)k1O8c2kAUT26susMZfE6RjyO3(aJfrPAnAtRO8o1Fhek3iPQeASzrg1s5VA1mQu(1ibkQ)o2Vkv9Ni)f1nWefspv85e1l6bPe0AwgSD9cebjDOAzh6BRzlvm4RMzMbkjc2sIaWuc7spLSgKNkQ8Z(HJKjHI7GL6pz96MsMJ3Eh2hLtoxM24Y5kZ0Gzgze3hmhNcv43CmvQqXOnPFp9vCm9eLn7idoh)4OLjQXKt1zN6Hi40GQ)4fp0O8STJISGGSwm1Eol)QSYZ96J5S)y(Enul7BdJ9Zl8qOdeGhbeandSgvFDGMSOStljM95eRdDF5WwaKtMY5Cy5rRP8rszGKpEwcpbhCKCBybZIFqnjdGx58b456IXTeKTaq(Yxq3S8R))(d]] )
