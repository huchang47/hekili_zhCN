-- WarriorFury.lua
-- July 2024

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 72 )

-- Resources
spec:RegisterResource( Enum.PowerType.Rage )

spec:RegisterTalents( {
    -- Warrior Talents
    armored_to_the_teeth            = { 90366, 384124, 2 }, -- Gain Strength equal to $s2% of your Armor.
    avatar                          = { 92640, 107574, 1 }, -- Transform into a colossus for $d, causing you to deal $s1% increased damage$?s394314[, take $394314s2% reduced damage][] and removing all roots and snares.; Generates ${$s2/10} Rage.
    barbaric_training               = { 90340, 383082, 1 }, -- Slam, Cleave, and Whirlwind deal $s1% more damage and $s2% increased critical strike damage.; 
    berserker_shout                 = { 90348, 384100, 1 }, -- Go berserk, removing and granting immunity to Fear, Sap, and Incapacitate effects for $d.; Also remove fear effects from group members within $384102A1 yds.
    berserkers_torment              = { 90362, 390123, 1 }, -- Activating Avatar or Recklessness grants ${$s1/1000} sec of the other.
    bitter_immunity                 = { 90356, 383762, 1 }, -- Restores $s1% health instantly and removes all diseases, poisons and curses affecting you.; 
    blademasters_torment            = { 90363, 390138, 1 }, -- Activating Avatar grants ${$s1/1000} sec of Sweeping Strikes and while Avatar is active the cooldown of Cleave is reduced by ${$107574s8/-1000}.1 sec.
    bounding_stride                 = { 90355, 202163, 1 }, -- Reduces the cooldown of Heroic Leap by ${$m1/-1000} sec, and Heroic Leap now also increases your movement speed by $202164s1% for $202164d.
    cacophonous_roar                = { 90383, 382954, 1 }, -- Intimidating Shout can withstand $s1% more damage before breaking.
    champions_might                 = { 90323, 386284, 1 }, -- The duration of Champion's Spear is increased by ${$s1/1000} sec. You deal $376080s5% increased critical strike damage to targets chained to your Spear.
    champions_spear                 = { 90380, 376079, 1 }, -- Throw a spear at the target location, dealing $376080s1 Physical damage instantly and an additional $376080o4 damage over $376081d. Deals reduced damage beyond $<cap> targets.; Enemies hit are chained to the spear's location for the duration.; Generates $/10;376080s3 Rage.
    concussive_blows                = { 90354, 383115, 1 }, -- Cooldown of Pummel reduced by ${$s1/-1000}.1 sec. ; Successfully interrupting an enemy increases the damage you deal to them by $383116s2% for $383116d.
    crackling_thunder               = { 95959, 203201, 1 }, -- Thunder Clap's radius is increased by $s1%, and it reduces movement speed by an additional $s2%.
    cruel_strikes                   = { 90381, 392777, 2 }, -- Critical strike chance increased by $s1% and critical strike damage of Execute increased by $s2%. 
    crushing_force                  = { 90349, 382764, 2 }, -- $?c1[Mortal Strike deals an additional $s1% damage and deals $s2% increased critical strike damage.][Bloodthirst deals an additional $s4% damage and has a $s5% increased critical strike chance.]
    double_time                     = { 90382, 103827, 1 }, -- Increases the maximum number of charges on Charge by 1, and reduces its cooldown by ${$s2/-1000} sec.
    dual_wield_specialization       = { 90373, 382900, 1 }, -- Increases your damage while dual wielding by $s1%.
    endurance_training              = { 90339, 382940, 2 }, -- Stamina increased by $s1% and the duration of Fear, Sap and Incapacitate effects on you is reduced by ${$s6/10}.1%.
    fast_footwork                   = { 90344, 382260, 1 }, -- Movement speed increased by $s1%.
    frothing_berserker              = { 90370, 392790, 1 }, -- Revenge has a $h% chance to immediately refund $s1% of the Rage spent.
    heroic_leap                     = { 90346, 6544  , 1 }, -- Leap through the air toward a target location, slamming down with destructive force to deal $52174s1 Physical damage to all enemies within $52174a1 yards$?c3[, and resetting the remaining cooldown on Taunt][].
    honed_reflexes                  = { 95956, 391271, 1 }, -- Cooldown of $?c1[Die By the Sword]?c2[Enraged Regeneration][Shield Wall], Pummel, Intervene, Spell Reflection, and Storm Bolt reduced by $s1%.
    immovable_object                = { 90364, 394307, 1 }, -- Activating Avatar or Shield Wall grants ${$s1/1000} sec of the other.
    impending_victory               = { 90326, 202168, 1 }, -- Instantly attack the target, causing $s1 damage and healing you for $202166s1% of your maximum health.; Killing an enemy that yields experience or honor resets the cooldown of Impending Victory and makes it cost no Rage.
    intervene                       = { 90329, 3411  , 1 }, -- Run at high speed toward an ally, intercepting all melee and ranged attacks against them for $147833d while they remain within $147833A1 yds.
    intimidating_shout              = { 90384, 5246  , 1 }, -- $?s275338[Causes the targeted enemy and up to $s1 additional enemies within $5246A3 yards to cower in fear.][Causes the targeted enemy to cower in fear, and up to $s1 additional enemies within $5246A3 yards to flee.] Targets are disoriented for $d.
    leeching_strikes                = { 90371, 382258, 1 }, -- Leech increased by $s1%.
    menace                          = { 90383, 275338, 1 }, -- Intimidating Shout will knock back all nearby enemies except your primary target, and cause them all to cower in fear for $316595d instead of fleeing.
    onehanded_weapon_specialization = { 90324, 382895, 1 }, -- Damage with one-handed weapons and Leech increased by $s1%.
    overwhelming_rage               = { 90378, 382767, 2 }, -- Maximum Rage increased by ${$s1/10}.
    pain_and_gain                   = { 90353, 382549, 1 }, -- When you take any damage, heal for ${$m1/10}.2% of your maximum health. ; This can only occur once every $357946d.
    piercing_challenge              = { 90379, 382948, 1 }, -- Champion's Spear's damage increased by $s1% and its Rage generation is increased by $s2%.
    piercing_howl                   = { 90348, 12323 , 1 }, -- Snares all enemies within $A1 yards, reducing their movement speed by $s1% for $d.
    rallying_cry                    = { 90331, 97462 , 1 }, -- Lets loose a rallying cry, granting all party or raid members within $a1 yards $s1% temporary and maximum health for $97463d.
    reinforced_plates               = { 90368, 382939, 1 }, -- Armor increased by $s1%.
    rumbling_earth                  = { 90374, 275339, 1 }, -- Shockwave's range increased by $s3 yards and when Shockwave strikes at least $s1 targets, its cooldown is reduced by $s2 sec.
    second_wind                     = { 90332, 29838 , 1 }, -- Restores $202147s1% health every $202147t1 sec when you have not taken damage for $202149d.; While you are below $458245s3% health, restores ${$458245s4}.1% health every $458245t1 sec. The amount restored increases the closer you are to death.
    seismic_reverberation           = { 90354, 382956, 1 }, -- If Whirlwind $?c1[or Cleave ][]$?s436707[or Thunder Clap ][]$?a137048[or Revenge ][]hits $s1 or more enemies, it hits them $s2 additional time for $s5% damage.
    shattering_throw                = { 90351, 64382 , 1 }, -- Hurl your weapon at the enemy, causing $<damage> Physical damage, ignoring armor, and removing any magical immunities. Deals up to $?s329033[${($329033s3/100+1)*500}][500]% increased damage to absorb shields.
    shockwave                       = { 90375, 46968 , 1 }, -- Sends a wave of force in a frontal cone, causing $s2 damage and stunning all enemies within $a1 yards for $132168d.
    sidearm                         = { 95955, 384404, 1 }, -- Your auto-attacks have a $s2% chance to hurl weapons at your target and 3 other enemies in front of you, dealing an additional $384391s1 Physical damage.
    spell_reflection                = { 90385, 23920 , 1 }, -- Raise your $?c3[shield][weapon], reflecting $?a213915[the next $213915s3 spells cast][the first spell cast] on you, and reduce magic damage you take by $385391s1% for $d.
    storm_bolt                      = { 90337, 107570, 1 }, -- Hurls your weapon at an enemy, causing $s1 Physical damage and stunning for $132169d.$?s436162[ Also hits 2 additional nearby targets, stunning for 2 sec.][]
    thunder_clap                    = { 90343, 6343  , 1 }, -- Blasts all enemies within $A1 yards for $s1 Physical damage$?s199045[, roots them for $199042d,][] and reduces their movement speed by $435203s1% for $435203d. Deals reduced damage beyond $s5 targets.$?a137048|(a137050&a436707)[; Generates ${$s4/10} Rage.][]$?c1|c3[; If you have Rend, Thunder Clap affects $s5 nearby targets with Rend.; ][]
    thunderous_roar                 = { 90359, 384318, 1 }, -- Roar explosively, dealing $s1 Physical damage to enemies within $A1 yds and cause them to bleed for $397364o1 physical damage over $397364d.
    thunderous_words                = { 90358, 384969, 1 }, -- Increases the duration of Thunderous Roar's Bleed effect by ${$s1/1000}.1 sec and Thunderous Roar's Bleed effect causes enemies to take $397364s3% increased damage from all your bleeds.
    titans_torment                  = { 90362, 390135, 1 }, -- Activating Avatar casts Odyn's Fury and activating Odyn's Fury grants ${$s1/1000} sec of Avatar.
    twohanded_weapon_specialization = { 90322, 382896, 1 }, -- Increases your damage while using two-handed weapons by $s1%.; 
    unstoppable_force               = { 90364, 275336, 1 }, -- Avatar increases the damage of Thunder Clap and Shockwave by $s1% and reduces the cooldown of Thunder Clap by $s2%.
    uproar                          = { 90357, 391572, 1 }, -- Thunderous Roar's cooldown reduced by ${$s1/-1000} sec.
    war_machine                     = { 90386, 346002, 1 }, -- Your auto attacks generate $s2% more Rage.; Killing an enemy instantly generates ${$262232s1/10} Rage, and increases your movement speed by $262232s2% for $262232d.
    warlords_torment                = { 90363, 390140, 1 }, -- Activating Avatar grants ${$s1/1000} sec of Recklessness.; The additional Rage generation of this Recklessness is reduced to $s2%.
    wild_strikes                    = { 90360, 382946, 2 }, -- Haste increased by $s1% and your auto-attack critical strikes increase your auto-attack speed by $s2% for $392778d.
    wrecking_throw                  = { 90351, 384110, 1 }, -- Hurl your weapon at the enemy, causing $<damage> Physical damage, ignoring armor. Deals up to $?s329033[${($329033s3/100+1)*500}][500]% increased damage to absorb shields.

    -- Fury Talents
    anger_management                = { 90415, 152278, 1 }, -- Every $?c1[$s1]?c2[$s3][$s2] Rage you spend$?c1[ on attacks][] reduces the remaining cooldown on $?c1&s262161[Warbreaker, Bladestorm, and Ravager]?c1[Colossus Smash, Bladestorm, and Ravager]?c2[Recklessness, Bladestorm, and Ravager][Avatar and Shield Wall] by 1 sec.
    ashen_juggernaut                = { 90409, 392536, 1 }, -- $?a317320[Condemn][Execute] increases the critical strike chance of $?a317320[Condemn][Execute] by $392537s1% for $392537d, stacking up to $392537u times.
    avatar_of_the_storm             = { 94805, 437134, 1 }, -- Casting Avatar grants you $s1 charges of Thunder Blast and resets the cooldown of Thunder Clap.; While Avatar is not active, Lightning Strikes have a $s2% chance to grant you Avatar for $s3 secs.; $@spellicon435222$@spellname435222; Your next Thunder Clap becomes a Thunder Blast that deals Stormstrike damage.
    berserker_stance                = { 90325, 386196, 1 }, -- An aggressive combat state that increases the damage of your auto-attacks by $s1% and reduces the duration of Fear, Sap and Incapacitate effects on you by $s2%.; Lasts until canceled.
    bladestorm                      = { 90388, 227847, 1 }, -- Become an unstoppable storm of destructive force, striking all nearby enemies for $<dmg> Physical damage over $d. Deals reduced damage beyond $s1 targets.; You are immune to movement impairing and loss of control effects, but can use defensive abilities and can avoid attacks.; $?c2[; Generates ${$50622s3/10} Rage each time you deal damage.][]
    bloodborne                      = { 90401, 385703, 1 }, -- Bleed damage of Odyn's Fury, Thunderous Roar and Gushing Wound increased by $s1%.
    bloodcraze                      = { 90405, 393950, 1 }, -- Raging Blow increases the critical strike chance of your next Bloodthirst by $393950s1% until it critically strikes, stacking up to $s2 times.
    bloodthirst                     = { 90392, 23881 , 1 }, -- Assault the target in a bloodthirsty craze, dealing $s1 Physical damage and restoring $117313s1% of your health.; Generates ${$s2/10} Rage.
    brutal_finish                   = { 94786, 446085, 1 }, -- Your next $?c1[Mortal Strike][Rampage] after Bladestorm ends deals $446918s1% additional damage.
    burst_of_power                  = { 94807, 437118, 1 }, -- Lightning Strikes have a $h% chance to make your next $s1 $?a137048[Shield Slams][Bloodthirsts] have no cooldown$?a137050[, deal $437121s2% increased damage, and generate ${$437121s3/10} additional Rage][].
    cold_steel_hot_blood            = { 90402, 383959, 1 }, -- Bloodthirst critical strikes generate ${$383978s1/10} additional Rage, and inflict a Gushing Wound that leeches $385042o health over $385042d.
    crashing_thunder                = { 94816, 436707, 1 }, -- Stormstrike or Nature damage your abilities deal is increased by $s1%. Stormstrike damage ignores Armor.; Thunder Clap damage increased by $s3%$?a137050[, and it generates ${$s4/10} Rage][]. ; Seismic Reverberations$?a137048[ now affects][, Improved Whirlwind, Meat Cleaver, and Barbaric Training now affect] Thunder Clap in addition to Whirlwind.
    critical_thinking               = { 90425, 383297, 2 }, -- Critical Strike chance increased by ${$s1}% and Raging Blow's critical strikes deal ${$s2}% increased damage.
    cruelty                         = { 90428, 392931, 1 }, -- While Enraged, Raging Blow deals $s1% increased damage.
    culling_cyclone                 = { 94786, 444778, 1 }, -- Each strike of Bladestorm deals an additional $s1% damage evenly split across all targets.
    dancing_blades                  = { 90417, 391683, 1 }, -- Odyn's Fury increases your auto-attack damage and speed by $391688s1% for $391688d.
    death_drive                     = { 94813, 444770, 1 }, -- You heal for $s1% of damage dealt by Sudden Death.
    defensive_stance                = { 92538, 386208, 1 }, -- A defensive combat state that reduces all damage you take by $s1%$?a452494[ and all magic damage you take by an additional $s3%][]$?a137048[][, and all damage you deal by $s2%]. ; Lasts until canceled.
    deft_experience                 = { 90421, 383295, 2 }, -- Mastery increased by $s1% and if you are Enraged, Bloodthirst extends your Enrage by ${$s2/1000}.1 sec.
    depths_of_insanity              = { 90413, 383922, 1 }, -- Recklessness lasts ${$s1/1000}.1 sec longer.
    enraged_regeneration            = { 90395, 184364, 1 }, -- Reduces damage taken by $s1%, and Bloodthirst restores an additional $s2% health. Usable while stunned or incapacitated. Lasts $d.
    fierce_followthrough            = { 94787, 444773, 1 }, -- $?c1[Mortal Strike][Bloodthirst] critical strikes increase the damage of your next $?c1[Mortal Strike][Bloodthirst] by $458689s1%.; 
    flashing_skies                  = { 94797, 437079, 1 }, -- Thunder Blast calls down a Lightning Strike on an enemy it hits.
    focus_in_chaos                  = { 90403, 383486, 1 }, -- While Enraged, your auto-attacks can no longer miss.
    frenzied_enrage                 = { 90398, 383848, 1 }, -- Enrage increases your Haste by $184362s1% and increases your movement speed by $184362s2%.
    frenzy                          = { 90406, 335077, 1 }, -- Rampage increases your Haste by $335082s1% for $335082d, stacking up to $335082u times. This effect is reset if you Rampage a different primary target.
    fresh_meat                      = { 90399, 215568, 1 }, -- Bloodthirst always Enrages you the first time you strike a target, and it has a $s1% increased chance to trigger Enrage.
    gathering_clouds                = { 94792, 436201, 1 }, -- Your attacks trigger Lightning Strikes $s1% more often.
    ground_current                  = { 94800, 436148, 1 }, -- Lightning Strikes also deal $460670s1 to enemies near their target. Damage reduced beyond $460670s2 targets.
    hack_and_slash                  = { 90407, 383877, 1 }, -- Each Rampage strike has a $h% chance to refund a charge of Raging Blow.
    imminent_demise                 = { 94788, 444769, 1 }, -- Every $s1 Slayer's Strikes you gain Sudden Death.; Using Sudden Death accelerates your next Bladestorm, striking 1 additional time (max $445606u). Bladestorm's total duration is unchanged.
    improved_bloodthirst            = { 90397, 383852, 1 }, -- Bloodthirst damage increased by $s1%.
    improved_execute                = { 90430, 316402, 1 }, -- Execute no longer costs Rage and now generates ${$s3/10} Rage.
    improved_raging_blow            = { 90390, 383854, 1 }, -- Raging Blow has ${$s1+1} charges and has a $85288s1% chance to instantly reset its own cooldown.
    improved_whirlwind              = { 90427, 12950 , 1 }, -- Whirlwind $?s436707[and Thunder Clap cause][causes] your next $85739u single-target $lattack:attacks; to strike up to $85739s1 additional targets for $85739s3% damage.; Whirlwind generates $190411s1 Rage, plus an additional $190411s2 per target hit. Maximum $<maxRage> Rage.
    invigorating_fury               = { 90393, 383468, 1 }, -- Enraged Regeneration lasts ${$s1/1000} sec longer and instantly heals for $s2% of your maximum health.
    keep_your_feet_on_the_ground    = { 94798, 438590, 1 }, -- Physical damage taken reduced by $s2%.; Thunder Blast reduces damage you take by $438591s1% for $438591d.
    lightning_strikes               = { 94803, 434969, 1 }, -- Damaging enemies with Thunder Clap, $?a137048[Revenge, ][Raging Blow, ]or Execute has a $s1% chance to also strike one with a lightning bolt, dealing $435791s1 Nature damage$?s436152[ and generating ${$436152s3/10} Rage][].; Lightning Strikes occur $s2% more often during Avatar.
    massacre                        = { 90410, 206315, 1 }, -- $?a317320[Condemn][Execute] is now usable on targets below $s2% health, and its cooldown is reduced by ${$s3/1000}.1 sec.
    meat_cleaver                    = { 90391, 280392, 1 }, -- Whirlwind $?s436707[and Thunder Clap deal][deals] $s1% more damage and now $?s436707[affect][affects] your next ${$s2+$s3} single-target melee attacks, instead of the next $s3 attacks.
    odyns_fury                      = { 90418, 385059, 1 }, -- Unleashes your power, dealing ${$385060sw1+$385062sw1+$385061sw1+$385061sw1} Physical damage and an additional $385060o2 Physical damage over $385060d to all enemies within $385060A2 yards.; Generates ${$s5/10} Rage.; 
    onslaught                       = { 90424, 315720, 1 }, -- Brutally attack an enemy for $396718s1 Physical damage$?s388933[ and become Enraged for $184362d.][.]; Generates ${$m1/10} Rage.
    opportunist                     = { 94787, 444774, 1 }, -- $?c1[When Overpower has its cooldown reset by Tactician, your next Overpower deals $456120s3% additional damage and $456120s4% additional critical damage.][When Raging Blow resets its own cooldown, your next Raging Blow deals $456120s1% additional damage and $456120s2% additional critical damage.]
    overwhelming_blades             = { 94810, 444772, 1 }, -- Each strike of Bladestorm applies Overwhelmed to all enemies affected, increasing damage you deal to them by $445836s1% for $445836d, max $445836u stacks.
    powerful_enrage                 = { 90398, 440277, 1 }, -- Enrage increases the damage your abilities deal by an additional $184362s4% and Enrage's duration is increased by ${$s1/1000} sec.
    raging_blow                     = { 90396, 85288 , 1 }, -- A mighty blow with both weapons that deals a total of $<damage> Physical damage.$?s383854[; Raging Blow has a $s1% chance to instantly reset its own cooldown.][]; Generates ${$m2/10} Rage.
    rampage                         = { 90408, 184367, 1 }, -- Enrages you and unleashes a series of $s1 brutal strikes for a total of $<damage> Physical damage$?a396749[ and empowering your next Bloodthirst and Raging Blow][].
    ravager                         = { 90388, 228920, 1 }, -- Throws a whirling weapon at the target location that chases nearby enemies, inflicting $<damage> Physical damage to all enemies over $d. Deals reduced damage beyond $156287s2 targets.; Generates ${$334934s1/10} Rage each time it deals damage.
    reap_the_storm                  = { 94809, 444775, 1 }, -- $?c1[Mortal Strike and Cleave have][Bloodthirst has] a $h% chance to cause you to unleash a flurry of steel, striking all nearby enemies for $446005s1 damage and applying Overwhelmed. Deals reduced damage beyond $s1 targets.; 
    reckless_abandon                = { 90415, 396749, 1 }, -- Recklessness generates ${$s1/10} Rage and Rampage empowers your next Bloodthirst and Raging Blow.
    recklessness                    = { 90412, 1719  , 1 }, -- Go berserk, increasing all Rage generation by $s1% and granting your abilities $s4% increased critical strike chance for $d.$?a396749[; Generates ${$s3/10} Rage.][]
    relentless_pursuit              = { 94795, 444776, 1 }, -- Charge grants you $446044s1% movement speed for $446044d.; Charge removes all movement impairing effects, this effect cannot occur more than once every $458386d.; 
    show_no_mercy                   = { 94784, 444771, 1 }, -- Marked for Execution increases the critical strike chance and critical strike damage of your next Execute on the target by $445584s2%.
    singleminded_fury               = { 90400, 81099 , 1 }, -- While dual-wielding a pair of one-handed weapons, your damage done is increased by $s1%, your auto-attack damage with one-handed weapons is increased by $s5%, your movement speed is increased by $s3%, and your auto-attack critical strikes have a $H% chance to Enrage you.
    slaughtering_strikes            = { 90411, 388004, 1 }, -- Raging Blow causes every strike of your next Rampage to deal an additional $393931s1% damage, stacking up to $s2 times.
    slayers_dominance               = { 94814, 444767, 1 }, -- Your attacks against your primary target have a high chance to overwhelm their defenses and trigger a Slayer's Strike, dealing $445579s1 damage and applying Marked for Execution, increasing the damage they take from your next Execute by $445584s1%. Stacks $445584u times.
    slayers_malice                  = { 94801, 444779, 1 }, -- $?c1[Overpower][Raging Blow] damage increased by $s1%.
    snap_induction                  = { 94797, 456270, 1 }, -- Activating $?a137048[Demoralizing Shout][Recklessness] grants a charge of Thunder Blast.
    steadfast_as_the_peaks          = { 94798, 434970, 1 }, -- Stamina increased by $s1%.; $?s202168[Impending Victory][Victory Rush] increases your maximum health by $437152s3% for $437152d. When this health increase expires, you heal for any amount of the original $?s202168[Impending Victory][Victory Rush] that healed you in excess of your full health.
    storm_bolts                     = { 94817, 436162, 1 }, -- Storm Bolt also hits $s1 additional nearby $Ltarget:targets;, stunning them for $s2 sec, but its cooldown is increased by ${$s3/1000} sec.
    storm_of_steel                  = { 90389, 382953, 1 }, -- $?c3[Ravager's damage is reduced by $s1% but it now has $s4 charges and generates ${$s5/10} additional Rage each time it deals damage.][Bladestorm and Ravager's damage are reduced by $s1% but they now have $s4 charges and generate ${$s5/10} additional Rage each time they deal damage.]
    storm_shield                    = { 94817, 438597, 1 }, -- Intervening a target grants them a shield for $438598d that absorbs magic damage equal to $s1 times your Armor.
    strength_of_the_mountain        = { 94808, 437068, 1 }, -- Shield Slam damage increased by $s1%.$?a137048[; Demoralizing Shout reduces damage enemies deal to you by an additional ${-$s2}%.][; `s`; Bloodthirst and Rampage damage increased by $s4%.]
    sudden_death                    = { 90429, 280721, 1 }, -- Your attacks have a chance to reset the cooldown of $?a317320[Condemn][Execute] and make it usable on any target, regardless of their health.
    swift_strikes                   = { 90416, 383459, 2 }, -- Haste increased by $s1% and Raging Blow and Bloodthirst generate an additional ${$s2/10} Rage.
    tenderize                       = { 90423, 388933, 1 }, -- Onslaught Enrages you, and if you have Slaughtering Strikes grants you $s1 stacks of Slaughtering Strikes.
    thorims_might                   = { 94792, 436152, 1 }, -- Lightning Strikes generate ${$s1/10} Rage.; $?a137048[Revenge][Raging Blow] and Execute damage increased by $s2%.
    thunder_blast                   = { 94785, 435607, 1 }, -- Shield Slam and Bloodthirst have a $s1% chance to grant you Thunder Blast, stacking up to 2 charges.; $@spellicon435222$@spellname435222; Your next Thunder Clap becomes a Thunder Blast that deals $?a137048[$s2% increased damage as Stormstrike][Stormstrike damage] and generates ${$435222s4/10} Rage.
    titanic_rage                    = { 90417, 394329, 1 }, -- Odyn's Fury's Enrages you, deals $s2% increased damage and grants you $85739u stacks of Whirlwind.; 
    unbridled_ferocity              = { 90414, 389603, 1 }, -- Rampage has a $s1% chance to grant Recklessness for ${$s2/1000} sec.
    unhinged                        = { 90389, 386628, 1 }, -- Every other time Bladestorm or Ravager deal damage, you automatically cast a $?c1[Mortal Strike][Bloodthirst] at your target or random nearby enemy$?a134735[, dealing $s3% of normal damage.][.]; 
    unrelenting_onslaught           = { 94820, 444780, 1 }, -- When you Execute a target that you've Marked for Execution, you both reduce the cooldown of Bladestorm by $s1 sec and apply $s2 stacks of Overwhelmed to the target per stack of Marked for Execution consumed.; You can now use Pummel and Storm Bolt while Bladestorming.
    vicious_agility                 = { 94795, 444777, 1 }, -- Heroic Leap reduces the cooldown of Charge by $s1 sec and Charge reduces the cooldown of Heroic Leap by $s2 sec.
    vicious_contempt                = { 90404, 383885, 2 }, -- Bloodthirst deals $s1% increased damage to enemies who are below $<threshold>% health.
    warpaint                        = { 90394, 208154, 1 }, -- You take $s1% reduced damage while Enrage is active.
    wrath_and_fury                  = { 90387, 392936, 1 }, -- Raging Blow deals $386045s1% increased damage and while Enraged, Raging Blow has a $s1% increased chance to instantly reset its own cooldown.; 
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    barbarian             = 166 , -- (280745) For $280746d after casting Heroic Leap, you may cast the spell a second time without regard for its cooldown.; Increases the damage done by your Heroic Leap by $m2%.
    battle_trance         = 170 , -- (213857) You go into a trance causing you to regenerate $213858m2% of your health and generate ${$213858m1/10} Rage every $213858t1 sec for $213858d after $?s383916[striking a target with Annihilator $s1 times.][using Raging Blow twice in a row on a target.]; Attacking a new target with $?s383916[Annihilator][Raging Blow] will cancel this effect.
    battlefield_commander = 5628, -- (424742) Your Shout abilities have additional effects.; $@spellicon6673 $@spellname6673:; Increases Stamina by $s1%.; $@spellicon12323 $@spellname12323:; Radius increased by $s6%; $@spellicon384100 $@spellname384100:; Range increased by $s2 yds.; $@spellicon5246 $@spellname5246:; Cooldown reduced by ${$s3/-1000} sec.; $@spellicon97462 $@spellname97462:; Removes movement impairing effects and grants $s4% movement speed to allies.; $@spellicon384318 $@spellname384318:; Targets receive $s5% more damage from all sources while bleeding.
    death_wish            = 179 , -- (199261) Increases your damage taken and done by $m1% for $d at the cost of $m2% of your health. Stacks up to $u times.
    demolition            = 5373, -- (329033) Reduces the cooldown of your Shattering Throw or Wrecking Throw by $s1% and increases its damage to absorb shields by an additional ${$s3*5}%.
    disarm                = 3533, -- (236077) Disarm the enemy's weapons and shield for $d. Disarmed creatures deal significantly reduced damage.
    enduring_rage         = 177 , -- (411764) You have a chance to become Enraged while you are suffering movement impairing effects.; Suffering loss of control effects have a chance to grant you Recklessness for $s1 sec.
    master_and_commander  = 3528, -- (235941) Cooldown of Rallying Cry reduced by ${$s1/1000} sec, and grants $m3% additional health.
    rebound               = 5548, -- (213915) Spell Reflection reflects the next $s3 incoming spells cast on you and reflected spells deal $s1% extra damage to the attacker.; Spell Reflection's cooldown is increased by ${$s2/1000} sec.
    safeguard             = 5624, -- (424654) Intervene now has ${$s1+1} charges and reduces the ally's damage taken by $424655s1% for $424655d.; Intervene's cooldown is increased by ${$s2/1000} sec.
    slaughterhouse        = 3735, -- (352998) Rampage, Onslaught, and Odyn's Fury damage reduce healing the target receives by $354788s1% for $354788d, stacking up to $354788u times.
    warbringer            = 5431, -- (356353) Charge roots enemies for ${1+$s1/1000} sec and emanates a shockwave past the target, rooting enemies and dealing $356356s2 Physical damage in a $356356a1 yd cone.
} )

-- Auras
spec:RegisterAuras( {
    -- $?a317320[Condemn][Execute]'s critical strike chance increased by ${$s1}%.
    ashen_juggernaut = {
        id = 392537,
        duration = 15.0,
        max_stack = 1,
    },
    -- Damage done increased by $s1%.
    avatar = {
        id = 401150,
        duration = 20.0,
        max_stack = 1,

        -- Affected by:
        -- unstoppable_force[275336] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- unstoppable_force[275336] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- recklessness[1719] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },
    -- Able to Heroic Leap an additional time.
    barbarian = {
        id = 280746,
        duration = 3.0,
        max_stack = 1,
    },
    -- Attack power increased by $w1%.$?$w3>0[; Stamina increased by $w3%.][]
    battle_shout = {
        id = 6673,
        duration = 3600.0,
        max_stack = 1,

        -- Affected by:
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- battlefield_commander[424742] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },
    -- Healing $w2% health and generating ${$w1/10} Rage every $t1 sec.
    battle_trance = {
        id = 213858,
        duration = 18.0,
        max_stack = 1,
    },
    -- Immune to Fear, Sap, and Incapacitate effects.
    berserker_rage = {
        id = 18499,
        duration = 6.0,
        max_stack = 1,

        -- Affected by:
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
    },
    -- Immune to Fear, Sap, and Incapacitate effects.
    berserker_shout = {
        id = 384100,
        duration = 6.0,
        max_stack = 1,

        -- Affected by:
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
    },
    -- Auto-attack damage increased by $s1% and the effects of Fear, Sap and Incapacitate are reduced by $s2%.
    berserker_stance = {
        id = 386196,
        duration = 3600,
        max_stack = 1,

        -- Affected by:
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
    },
    -- Dealing damage to all nearby enemies every $t1 sec.; Immune to crowd control.
    bladestorm = {
        id = 227847,
        duration = 6.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- fury_warrior[137050] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #10: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- recklessness[1719] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- recklessness[1719] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- storm_of_steel[382953] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- storm_of_steel[382953] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -90000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- storm_of_steel[382953] #6: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },
    -- Your next Bloodthirst is greatly empowered.
    bloodbath = {
        id = 461288,
        duration = 12.0,
        max_stack = 1,
    },
    -- Your Bloodthirst critical strike chance is increased by $w1%.
    bloodcraze = {
        id = 393951,
        duration = 20.0,
        max_stack = 1,
    },
    -- Movement speed increased by $s1%.
    bounding_stride = {
        id = 202164,
        duration = 3.0,
        max_stack = 1,
    },
    -- $?c1[Mortal Strike][Rampage] damage increased by $w1%.
    brutal_finish = {
        id = 446918,
        duration = 10.0,
        max_stack = 1,
    },
    -- Your next $U $?a137048[Shield Slams][Bloodthirsts] have no cooldown$?a137050[, deal $s2% increased damage, and generate ${$s3/10} additional Rage][].
    burst_of_power = {
        id = 437121,
        duration = 15.0,
        max_stack = 1,
    },
    -- Tethered by chains and taking $w4 Physical damage every $t4 sec.$?e4[; Taking $w5% additional critical strike damage from $@auracaster.][]
    champions_spear = {
        id = 376080,
        duration = 4.0,
        tick_time = 1.0,
        max_stack = 1,

        -- Affected by:
        -- champions_might[386284] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- piercing_challenge[382948] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- piercing_challenge[382948] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- piercing_challenge[382948] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },
    -- Rooted.
    charge = {
        id = 105771,
        duration = 1.0,
        max_stack = 1,

        -- Affected by:
        -- warbringer[356353] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'trigger_spell': 105771, 'points': 1000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- Taking $s2% more damage from $@auracaster.
    concussive_blows = {
        id = 383116,
        duration = 10.0,
        max_stack = 1,
    },
    -- Your next Raging Blow is greatly empowered.
    crushing_blow = {
        id = 396752,
        duration = 12.0,
        max_stack = 1,
    },
    -- Auto-attack damage and speed increased by $s1%.
    dancing_blades = {
        id = 391688,
        duration = 10.0,
        pandemic = true,
        max_stack = 1,
    },
    -- Damage increased by $m1%.; Damage taken increased by $m2%.
    death_wish = {
        id = 199261,
        duration = 15.0,
        max_stack = 1,
    },
    -- Bleeding for $w1 every $t1 sec.
    deep_wounds = {
        id = 115767,
        duration = 15.0,
        tick_time = 3.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- bloodborne[385703] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- thunderous_roar[397364] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'radius': 12.0, 'target': TARGET_DEST_CASTER, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
    },
    -- Damage taken reduced by $s1%.; $?a452494[Magic damage taken reduced by an additional $s3%.][]; $?a137048[][Damage done reduced by $s2%.]
    defensive_stance = {
        id = 386208,
        duration = 3600,
        max_stack = 1,

        -- Affected by:
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- protection_warrior[137048] #16: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -1.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- protection_warrior[137048] #17: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- fight_through_the_flames[452494] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },
    -- Disarmed!
    disarm = {
        id = 236077,
        duration = 5.0,
        max_stack = 1,
    },
    -- Damage done increased by $76856s1%$?s383848[, Haste increased by $m1%,; Movement speed increased by $m2%.]?s440277[, ability damage increased by an additional $m4%][.]$?s208154[; Damage taken reduced by $208154m3%.][]
    enrage = {
        id = 184362,
        duration = 4.0,
        max_stack = 1,

        -- Affected by:
        -- powerful_enrage[440277] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- warpaint[208154] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'pvp_multiplier': 0.5, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },
    -- Damage taken reduced by $s1%. Bloodthirst restores an additional $s2% health.
    enraged_regeneration = {
        id = 184364,
        duration = 8.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- honed_reflexes[391271] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- invigorating_fury[383468] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 3000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- $?c1[Mortal Strike][Bloodthirst] damage increased by $w1%.
    fierce_followthrough = {
        id = 458689,
        duration = 12.0,
        max_stack = 1,
    },
    -- Haste increased by $w1%.
    frenzy = {
        id = 335082,
        duration = 12.0,
        max_stack = 1,
    },
    -- Bleeding for $w1 Physical damage every $t1 sec, and healing the Warrior for the same amount.
    gushing_wound = {
        id = 288091,
        duration = 6.0,
        pandemic = true,
        max_stack = 1,
    },
    -- Movement slowed by $s1%.
    hamstring = {
        id = 1715,
        duration = 15.0,
        max_stack = 1,

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },
    -- Your next Bladestorm will strike $s1 additional $Ltime:times;.
    imminent_demise = {
        id = 445606,
        duration = 60.0,
        max_stack = 1,
    },
    -- Melee and ranged attacks made against you will be made against $@auracaster instead.
    intervene = {
        id = 147833,
        duration = 6.0,
        max_stack = 1,

        -- Affected by:
        -- honed_reflexes[391271] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- Disoriented.
    intimidating_shout = {
        id = 316595,
        duration = 15.0,
        max_stack = 1,

        -- Affected by:
        -- battlefield_commander[424742] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- Damage taken reduced by $w1%.
    keep_your_feet_on_the_ground = {
        id = 438591,
        duration = 5.0,
        max_stack = 1,
    },
    -- Execute damage$?e1[, critical strike chance, and critical strike damage][] from $@auracaster increased by $w1%.
    marked_for_execution = {
        id = 445584,
        duration = 30.0,
        max_stack = 1,
    },
    -- Healing effects received reduced by $w1%.
    mortal_wounds = {
        id = 115804,
        duration = 10.0,
        max_stack = 1,
    },
    -- Critically blocking all incoming attacks, and dealing $203526s1 Shadowflame damage to all enemies in a $203526A1 yard cone every $t2 sec.
    neltharions_fury = {
        id = 203524,
        duration = 3.0,
        max_stack = 1,
    },
    -- Suffering $o3 Physical damage over $d.
    odyns_fury = {
        id = 385062,
        duration = 0.0,
        max_stack = 1,

        -- Affected by:
        -- titanic_rage[394329] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- titanic_rage[394329] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },
    -- $?c1[Overpower damage increased by $w3% and critical strike damage increased by $w4%.][Raging Blow damage increased by $w1% and critical strike damage increased by $w2%.; ]
    opportunist = {
        id = 456120,
        duration = 8.0,
        max_stack = 1,
    },
    -- Your next Mortal Strike $?s845[or Cleave ][]will deal $w2% increased damage.
    overpower = {
        id = 7384,
        duration = 15.0,
        max_stack = 1,

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- slayers_malice[444779] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- opportunist[456120] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- opportunist[456120] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
    },
    -- Taking $w1% more damage from $@auracaster.
    overwhelmed = {
        id = 445836,
        duration = 20.0,
        max_stack = 1,
    },
    -- Movement slowed by $s1%.
    piercing_howl = {
        id = 12323,
        duration = 8.0,
        max_stack = 1,

        -- Affected by:
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- battlefield_commander[424742] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
    },
    -- Reduces healing received from critical heals by $w1%.$?$w2>0[; Damage taken increased by $w2.][]
    pvp_rules_enabled_hardcoded = {
        id = 134735,
        duration = 20.0,
        max_stack = 1,
    },
    -- Health increased by $97462s1% of maximum.$?a424742[; Movement speed increased by $424742s4%.][]
    rallying_cry = {
        id = 97463,
        duration = 10.0,
        max_stack = 1,

        -- Affected by:
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- battlefield_commander[424742] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- master_and_commander[235941] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -90000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- Ravager is currently active.
    ravager = {
        id = 228920,
        duration = 12.0,
        tick_time = 2.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- storm_of_steel[382953] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- storm_of_steel[382953] #1: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- storm_of_steel[382953] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -90000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- Rage generation increased by $w1%.; Critical strike chance of all abilities increased by $w4%.
    recklessness = {
        id = 1719,
        duration = 12.0,
        max_stack = 1,

        -- Affected by:
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- depths_of_insanity[383922] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- reckless_abandon[396749] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 500.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },
    -- Movement speed increased by $s1%.
    relentless_pursuit = {
        id = 446044,
        duration = 3.0,
        max_stack = 1,
    },
    -- Bleeding for $w1 damage every $t1 sec.
    rend = {
        id = 388539,
        duration = 15.0,
        tick_time = 3.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- bloodborne[385703] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- thunderous_roar[397364] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'radius': 12.0, 'target': TARGET_DEST_CASTER, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
    },
    -- Damage taken reduced by $w1%.
    safeguard = {
        id = 424655,
        duration = 5.0,
        max_stack = 1,
    },
    -- Healing $202147s1% health every $202147t1 sec.
    second_wind = {
        id = 351077,
        duration = 3600,
        max_stack = 1,
    },
    -- Block chance increased by $s1%.
    shield_block = {
        id = 132404,
        duration = 6.0,
        max_stack = 1,
    },
    -- Stunned.
    shockwave = {
        id = 132168,
        duration = 2.0,
        max_stack = 1,

        -- Affected by:
        -- avatar[401150] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- rumbling_earth[275339] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
        -- recklessness[1719] #8: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
        -- protection_warrior[137048] #14: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Healing received reduced by $w1%.
    slaughterhouse = {
        id = 354788,
        duration = 20.0,
        max_stack = 1,
    },
    -- Every strike of your next Rampage will deal an additional $s1% damage.
    slaughtering_strikes = {
        id = 393931,
        duration = 12.0,
        max_stack = 1,
    },
    -- Magical damage taken reduced by $s1%.
    spell_reflection = {
        id = 385391,
        duration = 5.0,
        max_stack = 1,

        -- Affected by:
        -- neltharions_fury[203524] #3: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- honed_reflexes[391271] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- rebound[213915] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'amplitude': 1.0, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_TAKEN_BY_PCT, }
        -- protection_warrior[137048] #18: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Maximum health increased by $s3%.
    steadfast_as_the_peaks = {
        id = 437152,
        duration = 5.0,
        max_stack = 1,
    },
    -- Stunned.
    storm_bolt = {
        id = 132169,
        duration = 4.0,
        max_stack = 1,
    },
    -- Absorbs $w1 magic damage.
    storm_shield = {
        id = 438598,
        duration = 5.0,
        max_stack = 1,
    },
    -- Taunted.
    taunt = {
        id = 355,
        duration = 3.0,
        max_stack = 1,

        -- Affected by:
        -- neltharions_fury[203524] #3: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
    },
    -- Your next Thunder Clap becomes a Thunder Blast that deals Stormstrike damage and generates ${$435222s4/10} Rage.
    thunder_blast = {
        id = 435615,
        duration = 15.0,
        max_stack = 1,
    },
    -- Bleeding for $w1 damage every $t1 sec.$?a424742[; Damage taken increased by $w2%.][]
    thunderous_roar = {
        id = 397364,
        duration = 8.0,
        tick_time = 2.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- thunderous_words[384969] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- uproar[391572] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -45000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- bloodborne[385703] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- battlefield_commander[424742] #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- thunderous_roar[397364] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'radius': 12.0, 'target': TARGET_DEST_CASTER, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
    },
    -- Rooted.
    thunderstruck = {
        id = 199042,
        duration = 4.0,
        max_stack = 1,
    },
    -- Bleeding for $w1 every $t1 sec.
    trauma = {
        id = 215537,
        duration = 6.0,
        tick_time = 2.0,
        pandemic = true,
        max_stack = 1,
    },
    -- Movement speed increased by $s2%.
    war_machine = {
        id = 262232,
        duration = 8.0,
        max_stack = 1,

        -- Affected by:
        -- recklessness[1719] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Rooted.
    warbringer = {
        id = 356356,
        duration = 2.0,
        max_stack = 1,
    },
    -- Your next single-target attack strikes up to $w1 additional targets for $w3% damage.
    whirlwind = {
        id = 85739,
        duration = 20.0,
        max_stack = 1,

        -- Affected by:
        -- meat_cleaver[280392] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': MAX_STACKS, }
    },
    -- Auto attack speed increased.
    wild_strikes = {
        id = 392778,
        duration = 10.0,
        max_stack = 1,
    },
} )

-- Abilities
spec:RegisterAbilities( {
    -- Transform into a colossus for $d, causing you to deal $s1% increased damage$?s394314[, take $394314s2% reduced damage][] and removing all roots and snares.; Generates ${$s2/10} Rage.
    avatar = {
        id = 107574,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "none",

        talent = "avatar",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'resource': rage, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_AUTOATTACK_DAMAGE, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': APPLY_AURA, 'subtype': MOD_RESISTANCE_PCT, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #5: { 'type': SCRIPT_EFFECT, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #6: { 'type': APPLY_AURA, 'subtype': MOD_SCALE, 'points': 30.0, 'target': TARGET_UNIT_CASTER, }
        -- #7: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -1500.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }

        -- Affected by:
        -- unstoppable_force[275336] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- unstoppable_force[275336] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- recklessness[1719] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },

    -- Transform into a colossus for $d, causing you to deal $s1% increased damage$?s394314[, take $394314s2% reduced damage][] and removing all roots and snares.; Generates ${$s2/10} Rage.
    avatar_401150 = {
        id = 401150,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "none",

        talent = "avatar_401150",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'resource': rage, }
        -- #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- #4: { 'type': APPLY_AURA, 'subtype': MOD_RESISTANCE_PCT, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #5: { 'type': APPLY_AURA, 'subtype': MOD_AUTOATTACK_DAMAGE, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, }
        -- #6: { 'type': SCRIPT_EFFECT, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #7: { 'type': APPLY_AURA, 'subtype': MOD_SCALE, 'points': 30.0, 'target': TARGET_UNIT_CASTER, }
        -- #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- unstoppable_force[275336] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- unstoppable_force[275336] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- recklessness[1719] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        from = "class_talent",
    },

    -- Increases the attack power of all raid and party members within $a1 yards by $s1% for $d.
    battle_shout = {
        id = 6673,
        cast = 0.0,
        cooldown = 15.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_ATTACK_POWER_PCT, 'points': 5.0, 'radius': 100.0, 'target': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_RANGED_ATTACK_POWER_PCT, 'points': 5.0, 'radius': 100.0, 'target': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_TOTAL_STAT_PERCENTAGE, 'radius': 100.0, 'target': TARGET_UNIT_CASTER_AREA_RAID, 'modifies': unknown, }

        -- Affected by:
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- battlefield_commander[424742] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },

    -- Go berserk, removing and granting immunity to Fear, Sap, and Incapacitate effects for $d.
    berserker_rage = {
        id = 18499,
        cast = 0.0,
        cooldown = 60.0,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'mechanic': 5, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 14, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 30, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 23, }

        -- Affected by:
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
    },

    -- Go berserk, removing and granting immunity to Fear, Sap, and Incapacitate effects for $d.; Also remove fear effects from group members within $384102A1 yds.
    berserker_shout = {
        id = 384100,
        cast = 0.0,
        cooldown = 60.0,
        gcd = "none",

        talent = "berserker_shout",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'mechanic': 5, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 14, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 30, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 23, }
        -- #4: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 384102, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
    },

    -- An aggressive combat state that increases the damage of your auto-attacks by $s1% and reduces the duration of Fear, Sap and Incapacitate effects on you by $s2%.; Lasts until canceled.
    berserker_stance = {
        id = 386196,
        cast = 0.0,
        cooldown = 3.0,
        gcd = "none",

        talent = "berserker_stance",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_AUTOATTACK_DAMAGE, 'points': 15.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MECHANIC_DURATION_MOD, 'points': -10.0, 'value': 14, 'schools': ['holy', 'fire', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MECHANIC_DURATION_MOD, 'points': -10.0, 'value': 30, 'schools': ['holy', 'fire', 'nature', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MECHANIC_DURATION_MOD, 'points': -10.0, 'value': 23, 'schools': ['physical', 'holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': APPLY_AURA, 'subtype': MECHANIC_DURATION_MOD, 'points': -10.0, 'value': 5, 'schools': ['physical', 'fire'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
    },

    -- Become an unstoppable storm of destructive force, striking all nearby enemies for $<dmg> Physical damage over $d. Deals reduced damage beyond $s1 targets.; You are immune to movement impairing and loss of control effects, but can use defensive abilities and can avoid attacks.; $?c2[; Generates ${$50622s3/10} Rage each time you deal damage.][]
    bladestorm = {
        id = 227847,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "global",

        talent = "bladestorm",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_TRIGGER_SPELL, 'tick_time': 1.0, 'trigger_spell': 50622, 'triggers': bladestorm, 'points': 8.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY_MASK, 'value': 1733, 'schools': ['physical', 'fire', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- fury_warrior[137050] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #10: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- recklessness[1719] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- recklessness[1719] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- storm_of_steel[382953] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- storm_of_steel[382953] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -90000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- storm_of_steel[382953] #6: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- Assault the target in a bloodthirsty craze, dealing $s1 Physical damage and restoring $117313s1% of your health.; Generates ${$s2/10} Rage.
    bloodthirst = {
        id = 23881,
        cast = 0.0,
        cooldown = 4.5,
        gcd = "global",

        talent = "bloodthirst",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 1.035, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 80.0, 'target': TARGET_UNIT_CASTER, 'resource': rage, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- crushing_force[382764] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- crushing_force[382764] #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- improved_bloodthirst[383852] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- recklessness[1719] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- strength_of_the_mountain[437068] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- swift_strikes[383459] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- bloodcraze[393951] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- burst_of_power[437121] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 35.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- burst_of_power[437121] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- fierce_followthrough[458689] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Throw a spear at the target location, dealing $376080s1 Physical damage instantly and an additional $376080o4 damage over $376081d. Deals reduced damage beyond $<cap> targets.; Enemies hit are chained to the spear's location for the duration.; Generates $/10;376080s3 Rage.
    champions_spear = {
        id = 376079,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "global",

        talent = "champions_spear",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': TRIGGER_MISSILE, 'subtype': NONE, 'trigger_spell': 376080, 'radius': 5.0, 'target': TARGET_DEST_DEST, }
        -- #1: { 'type': TRIGGER_MISSILE, 'subtype': NONE, 'trigger_spell': 376081, 'radius': 5.0, 'target': TARGET_DEST_DEST, }
    },

    -- Charge to an enemy, dealing $126664s2 Physical damage, rooting it for $105771d$?s103828[, and stunning it for $7922d][].; Generates $/10;s2 Rage.
    charge = {
        id = 100,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "none",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 200.0, 'target': TARGET_UNIT_CASTER, 'resource': rage, }

        -- Affected by:
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- double_time[103827] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- recklessness[1719] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },

    -- Strikes all enemies in front of you for $s1 Physical damage, inflicting Deep Wounds. Cleave will consume your Overpower effect to deal increased damage. Deals reduced damage beyond $s2 targets.
    cleave = {
        id = 845,
        cast = 0.0,
        cooldown = 4.5,
        gcd = "global",

        spend = 200,
        spendType = 'rage',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'attributes': ['Add Target (Dest) Combat Reach to AOE', 'Area Effects Use Target Radius'], 'ap_bonus': 1.00309, 'variance': 0.05, 'radius': 8.0, 'target': TARGET_UNIT_CONE_CASTER_TO_DEST_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #7: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -1500.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- barbaric_training[383082] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- barbaric_training[383082] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- overpower[7384] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.33, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Increases your damage taken and done by $m1% for $d at the cost of $m2% of your health. Stacks up to $u times.
    death_wish = {
        id = 199261,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 4.0,
        gcd = "global",


        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'points': 10.0, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MOD_AUTOATTACK_DAMAGE, 'points': 10.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- A defensive combat state that reduces all damage you take by $s1%$?a452494[ and all magic damage you take by an additional $s3%][]$?a137048[][, and all damage you deal by $s2%]. ; Lasts until canceled.
    defensive_stance = {
        id = 386208,
        cast = 0.0,
        cooldown = 3.0,
        gcd = "none",

        talent = "defensive_stance",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'pvp_multiplier': 0.66666, 'points': -15.0, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_DONE, 'pvp_multiplier': 1.5, 'points': -10.0, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'schools': ['holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- protection_warrior[137048] #16: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -1.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- protection_warrior[137048] #17: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- fight_through_the_flames[452494] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },

    -- A direct strike, dealing $s1 Physical damage.
    devastate = {
        id = 20243,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.6405, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': rage, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shield_block[132404] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Disarm the enemy's weapons and shield for $d. Disarmed creatures deal significantly reduced damage.
    disarm = {
        id = 236077,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DISARM, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_DISARM_RANGED, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MOD_DISARM_OFFHAND, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Reduces damage taken by $s1%, and Bloodthirst restores an additional $s2% health. Usable while stunned or incapacitated. Lasts $d.
    enraged_regeneration = {
        id = 184364,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "none",

        talent = "enraged_regeneration",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'points': -30.0, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }

        -- Affected by:
        -- honed_reflexes[391271] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- invigorating_fury[383468] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 3000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },

    -- Attempt to finish off a wounded foe, causing ${$280849s1+$163558s1} Physical damage. Only usable on enemies that have less than 20% health.$?s316402[; Generates ${$m3/10} Rage.][]; 
    execute = {
        id = 5308,
        cast = 0.0,
        cooldown = 6.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 280849, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 163558, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': rage, }

        -- Affected by:
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- cruel_strikes[392777] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- improved_execute[316402] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- improved_execute[316402] #1: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': -200.0, 'value': 1, 'schools': ['physical'], 'target': TARGET_UNIT_CASTER, }
        -- improved_execute[316402] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 200.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- recklessness[1719] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- ashen_juggernaut[392537] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- protection_warrior[137048] #13: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- marked_for_execution[445584] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- marked_for_execution[445584] #1: { 'type': APPLY_AURA, 'subtype': MOD_CRIT_CHANCE_FOR_CASTER_WITH_ABILITIES, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- marked_for_execution[445584] #2: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Attempts to finish off a foe, causing up to $<damage> Physical damage based on Rage spent. Only usable on enemies that have less than 20% health.$?s316405[; If your foe survives, $s2% of the Rage spent is refunded.][]
    execute_163201 = {
        id = 163201,
        cast = 0.0,
        cooldown = 6.0,
        gcd = "global",

        spend = 200,
        spendType = 'rage',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 260798, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- cruel_strikes[392777] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- improved_execute[316402] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- improved_execute[316402] #1: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': -200.0, 'value': 1, 'schools': ['physical'], 'target': TARGET_UNIT_CASTER, }
        -- improved_execute[316402] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 200.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- recklessness[1719] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- ashen_juggernaut[392537] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- protection_warrior[137048] #13: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- marked_for_execution[445584] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- marked_for_execution[445584] #1: { 'type': APPLY_AURA, 'subtype': MOD_CRIT_CHANCE_FOR_CASTER_WITH_ABILITIES, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- marked_for_execution[445584] #2: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        from = "class",
    },

    -- [5308] Attempt to finish off a wounded foe, causing ${$280849s1+$163558s1} Physical damage. Only usable on enemies that have less than 20% health.$?s316402[; Generates ${$m3/10} Rage.][]; 
    execute_offhand = {
        id = 163558,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 1.46049, 'pvp_multiplier': 1.8, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- cruel_strikes[392777] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- thorims_might[436152] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- ashen_juggernaut[392537] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- protection_warrior[137048] #13: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- marked_for_execution[445584] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- marked_for_execution[445584] #1: { 'type': APPLY_AURA, 'subtype': MOD_CRIT_CHANCE_FOR_CASTER_WITH_ABILITIES, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- marked_for_execution[445584] #2: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Maims the enemy for $s2 Physical damage, reducing movement speed by $s1% for $d.
    hamstring = {
        id = 1715,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 100,
        spendType = 'rage',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DECREASE_SPEED, 'chain_targets': 1, 'mechanic': snared, 'points': -50.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 0.15, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Leap through the air toward a target location, slamming down with destructive force to deal $52174s1 Physical damage to all enemies within $52174a1 yards$?c3[, and resetting the remaining cooldown on Taunt][].
    heroic_leap = {
        id = 6544,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "none",

        talent = "heroic_leap",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'variance': 1.0, 'radius': 3.0, 'target': TARGET_DEST_DEST, }
        -- #1: { 'type': UNKNOWN, 'subtype': NONE, 'points': 5.0, 'value': 17, 'schools': ['physical', 'frost'], 'target': TARGET_DEST_DEST, }

        -- Affected by:
        -- barbarian[280745] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 200.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- barbarian[280746] #1: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- Throws your weapon at the enemy, causing $s1 Physical damage. Generates high threat.
    heroic_throw = {
        id = 57755,
        cast = 0.0,
        cooldown = 6.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.35, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- protection_warrior[137048] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- Instantly attack the target, causing $s1 damage and healing you for $202166s1% of your maximum health.; Killing an enemy that yields experience or honor resets the cooldown of Impending Victory and makes it cost no Rage.
    impending_victory = {
        id = 202168,
        cast = 0.0,
        cooldown = 25.0,
        gcd = "global",

        spend = 100,
        spendType = 'rage',

        talent = "impending_victory",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 0.59, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
    },

    -- Run at high speed toward an ally, intercepting all melee and ranged attacks against them for $147833d while they remain within $147833A1 yds.
    intervene = {
        id = 3411,
        cast = 0.0,
        cooldown = 1.5,
        gcd = "none",

        talent = "intervene",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- honed_reflexes[391271] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- safeguard[424654] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- $?s275338[Causes the targeted enemy and up to $s1 additional enemies within $5246A3 yards to cower in fear.][Causes the targeted enemy to cower in fear, and up to $s1 additional enemies within $5246A3 yards to flee.] Targets are disoriented for $d.
    intimidating_shout = {
        id = 5246,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "global",

        talent = "intimidating_shout",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_FEAR, 'points': 5.0, 'value': 1, 'schools': ['physical'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_ROOT_2, 'points': 5.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_FEAR, 'value': 1, 'schools': ['physical'], 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MOD_ROOT_2, 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #4: { 'type': APPLY_AURA, 'subtype': USE_NORMAL_MOVEMENT_SPEED, 'points': 7.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #5: { 'type': APPLY_AURA, 'subtype': USE_NORMAL_MOVEMENT_SPEED, 'points': 7.0, 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }

        -- Affected by:
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- battlefield_commander[424742] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- A vicious strike that deals $s1 Physical damage and reduces the effectiveness of healing on the target by $115804s1% for $115804d.
    mortal_strike = {
        id = 12294,
        cast = 0.0,
        cooldown = 6.0,
        gcd = "global",

        spend = 300,
        spendType = 'rage',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 2.50774, 'pvp_multiplier': 1.35, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- crushing_force[382764] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- crushing_force[382764] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- fierce_followthrough[458689] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- overpower[7384] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.33, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brutal_finish[446918] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Enter a defensive posture, critically blocking all attacks while a stream of shadowflame erupts from Scale of the Earth-Warder, dealing ${6*$203526s1} Shadowflame over $d to all enemies in front of you. You can use defensive abilities while this is active.
    neltharions_fury = {
        id = 203524,
        color = 'artifact',
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_BLOCK_PERCENT, 'points': 300.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': PERIODIC_TRIGGER_SPELL, 'tick_time': 0.5, 'trigger_spell': 203526, 'points': 50.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_BLOCK_CRIT_CHANCE, 'points': 100.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
    },

    -- Unleashes the fiery power Odyn bestowed the Warswords, dealing ${$205546sw2+$205547sw2} Fire damage and an additional $205546o3 Fire damage over $205546d to all enemies within $205546A2 yards.
    odyns_fury = {
        id = 205545,
        color = 'artifact',
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 205546, 'value': 200, 'schools': ['nature', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 205547, 'value': 200, 'schools': ['nature', 'arcane'], 'target': TARGET_UNIT_CASTER, }
    },

    -- Unleashes your power, dealing ${$385060sw1+$385062sw1+$385061sw1+$385061sw1} Physical damage and an additional $385060o2 Physical damage over $385060d to all enemies within $385060A2 yards.; Generates ${$s5/10} Rage.; 
    odyns_fury_385059 = {
        id = 385059,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        talent = "odyns_fury_385059",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 385060, 'value': 100, 'schools': ['fire', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 385061, 'value': 200, 'schools': ['nature', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 385062, 'value': 300, 'schools': ['fire', 'nature', 'shadow'], 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 385061, 'value': 400, 'schools': ['frost'], 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': ENERGIZE, 'subtype': NONE, 'points': 150.0, 'target': TARGET_UNIT_CASTER, 'resource': rage, }

        -- Affected by:
        -- recklessness[1719] #8: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
        from = "spec_talent",
    },

    -- Brutally attack an enemy for $396718s1 Physical damage$?s388933[ and become Enraged for $184362d.][.]; Generates ${$m1/10} Rage.
    onslaught = {
        id = 315720,
        cast = 0.0,
        cooldown = 18.0,
        gcd = "global",

        talent = "onslaught",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': ENERGIZE, 'subtype': NONE, 'points': 300.0, 'target': TARGET_UNIT_CASTER, 'resource': rage, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 396718, 'value': 20, 'schools': ['fire', 'frost'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- recklessness[1719] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
    },

    -- Brutally attack an enemy for $s1 Physical damage$?388933[; and become Enrage for 5 sec.][.]; Generates ${$m2/10} Rage.
    onslaught_396718 = {
        id = 396718,
        cast = 0.0,
        cooldown = 18.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 2.1224, 'pvp_multiplier': 1.35, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- recklessness[1719] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        from = "triggered_spell",
    },

    -- Overpower the enemy, dealing $s1 Physical damage. Cannot be blocked, dodged, or parried.$?s316440&s845[; Increases the damage of your next Mortal Strike or Cleave by $s2%, stacking up to $u times]?s316440[; Increases the damage of your next Mortal Strike by $s2%, stacking up to $u times.][]$?s400801[; Generates ${$7384s3/10} Rage.][]; 
    overpower = {
        id = 7384,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 1.40184, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.33, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- slayers_malice[444779] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- opportunist[456120] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- opportunist[456120] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
    },

    -- Snares all enemies within $A1 yards, reducing their movement speed by $s1% for $d.
    piercing_howl = {
        id = 12323,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "global",

        talent = "piercing_howl",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DECREASE_SPEED, 'mechanic': snared, 'points': -70.0, 'radius': 12.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }

        -- Affected by:
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- battlefield_commander[424742] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
    },

    -- Pummels the target, interrupting spellcasting and preventing any spell in that school from being cast for $d.
    pummel = {
        id = 6552,
        cast = 0.0,
        cooldown = 15.0,
        gcd = "none",

        startsCombat = true,
        interrupt = true,

        -- Effects:
        -- #0: { 'type': INTERRUPT_CAST, 'subtype': NONE, 'mechanic': interrupted, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- concussive_blows[383115] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -1000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- honed_reflexes[391271] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- A mighty blow with both weapons that deals a total of $<damage> Physical damage.$?s383854[; Raging Blow has a $s1% chance to instantly reset its own cooldown.][]; Generates ${$m2/10} Rage.
    raging_blow = {
        id = 85288,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        talent = "raging_blow",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'attributes': ['No Immunity'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 120.0, 'target': TARGET_UNIT_CASTER, 'resource': rage, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 96103, 'triggers': raging_blow, 'points': 80.0, 'value': 50, 'schools': ['holy', 'frost', 'shadow'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 85384, 'triggers': raging_blow, 'points': 80.0, 'value': 100, 'schools': ['fire', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- improved_raging_blow[383854] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- recklessness[1719] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- swift_strikes[383459] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },

    -- Lets loose a rallying cry, granting all party or raid members within $a1 yards $s1% temporary and maximum health for $97463d.
    rallying_cry = {
        id = 97462,
        cast = 0.0,
        cooldown = 180.0,
        gcd = "global",

        talent = "rallying_cry",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'radius': 40.0, 'target': TARGET_UNIT_CASTER_AREA_RAID, }

        -- Affected by:
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- battlefield_commander[424742] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- master_and_commander[235941] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -90000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- master_and_commander[235941] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },

    -- Enrages you and unleashes a series of $s1 brutal strikes for a total of $<damage> Physical damage$?a396749[ and empowering your next Bloodthirst and Raging Blow][].
    rampage = {
        id = 184367,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 800,
        spendType = 'rage',

        talent = "rampage",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 184707, 'value': 10, 'schools': ['holy', 'nature'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 184709, 'value': 150, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 201364, 'value': 450, 'schools': ['holy', 'arcane'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #4: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 201363, 'value': 500, 'schools': ['fire', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- strength_of_the_mountain[437068] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brutal_finish[446918] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- slaughtering_strikes[393931] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Throws a whirling weapon at the target location that chases nearby enemies, inflicting $<damage> Physical damage to all enemies over $d. Deals reduced damage beyond $156287s2 targets.; Generates ${$334934s1/10} Rage each time it deals damage.
    ravager = {
        id = 228920,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "global",

        talent = "ravager",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 30.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'radius': 8.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': PERIODIC_DUMMY, 'tick_time': 2.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- storm_of_steel[382953] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- storm_of_steel[382953] #1: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- storm_of_steel[382953] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -90000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- Go berserk, increasing all Rage generation by $s1% and granting your abilities $s4% increased critical strike chance for $d.$?a396749[; Generates ${$s3/10} Rage.][]
    recklessness = {
        id = 1719,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "none",

        talent = "recklessness",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_RAGE_FROM_DAMAGE_DEALT, 'points': 100.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': SCRIPT_EFFECT, 'subtype': NONE, 'points': 1.0, 'radius': 10.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ALLY, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': rage, }
        -- #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- #8: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }

        -- Affected by:
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- depths_of_insanity[383922] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- reckless_abandon[396749] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 500.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },

    -- Wounds the target, causing $s1 Physical damage instantly and an additional $388539o1 Bleed damage over $388539d.$?s6343[; Thunder Clap affects $6343s5 nearby targets with Rend.; ][]
    rend = {
        id = 772,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 200,
        spendType = 'rage',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 0.871194, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 388539, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Swing in a wide arc, dealing $s1 Physical damage to all enemies in front of you. Deals reduced damage beyond $<cap> targets.; Your successful dodges and parries have a chance to make your next Revenge cost no Rage.
    revenge = {
        id = 6572,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 200,
        spendType = 'rage',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'attributes': ['Add Target (Dest) Combat Reach to AOE', 'Area Effects Use Target Radius'], 'ap_bonus': 0.52155, 'variance': 0.05, 'radius': 8.0, 'target': TARGET_UNIT_CONE_CASTER_TO_DEST_ENEMY, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- barbaric_training[390675] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- barbaric_training[390675] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'modifies': POWER_COST, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- thorims_might[436152] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Hurl your weapon at the enemy, causing $<damage> Physical damage, ignoring armor, and removing any magical immunities. Deals up to $?s329033[${($329033s3/100+1)*500}][500]% increased damage to absorb shields.
    shattering_throw = {
        id = 64382,
        cast = 1.5,
        cooldown = 180.0,
        gcd = "global",

        talent = "shattering_throw",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': TRIGGER_MISSILE, 'subtype': NONE, 'trigger_spell': 64380, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': TRIGGER_MISSILE, 'subtype': NONE, 'attributes': ['No Immunity'], 'trigger_spell': 394352, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- demolition[329033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Raise your shield, blocking all melee attacks against you for $132404d.$?s76857[ These blocks can be critical blocks.][]$?c3[ Increases Shield Slam damage by $132404s2% while active.][]
    shield_block = {
        id = 2565,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "none",

        spend = 300,
        spendType = 'rage',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- neltharions_fury[203524] #3: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
    },

    -- Slams the target with your shield, causing $s1 Physical damage.$?s231834[; Devastate, Thunder Clap, Revenge, and Execute have a $231834s1% chance to reset the cooldown of Shield Slam.][]; Generates $/10;s3 Rage.
    shield_slam = {
        id = 23922,
        cast = 0.0,
        cooldown = 9.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 0.97722, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': rage, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'points': 150.0, 'target': TARGET_UNIT_CASTER, 'resource': rage, }
        -- #3: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 15.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- crushing_force[390642] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- crushing_force[390642] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- recklessness[1719] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- strength_of_the_mountain[437068] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- shield_block[132404] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shield_block[132404] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Sends a wave of force in a frontal cone, causing $s2 damage and stunning all enemies within $a1 yards for $132168d.
    shockwave = {
        id = 46968,
        cast = 0.0,
        cooldown = 40.0,
        gcd = "global",

        talent = "shockwave",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'radius': 10.0, 'target': TARGET_UNIT_CONE_CASTER_TO_DEST_ENEMY, }
        -- #1: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.2, 'variance': 0.05, 'radius': 10.0, 'target': TARGET_UNIT_CONE_CASTER_TO_DEST_ENEMY, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, }
        -- #3: { 'type': SCRIPT_EFFECT, 'subtype': NONE, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- rumbling_earth[275339] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- recklessness[1719] #8: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- protection_warrior[137048] #14: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Slams an opponent, causing $s1 Physical damage.$?s388903[; Generates ${$388903s6/10} Rage.][]
    slam = {
        id = 1464,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 200,
        spendType = 'rage',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 0.805, 'pvp_multiplier': 1.85, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': rage, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- barbaric_training[390674] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- barbaric_training[390674] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- barbaric_training[383082] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- barbaric_training[383082] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- recklessness[1719] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- storm_of_swords[388903] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 9000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- storm_of_swords[388903] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- storm_of_swords[388903] #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -200.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- storm_of_swords[388903] #5: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Raise your $?c3[shield][weapon], reflecting $?a213915[the next $213915s3 spells cast][the first spell cast] on you, and reduce magic damage you take by $385391s1% for $d.
    spell_reflection = {
        id = 23920,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "none",

        talent = "spell_reflection",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': REFLECT_SPELLS, 'amplitude': 1.0, 'points': 100.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 385391, }

        -- Affected by:
        -- neltharions_fury[203524] #3: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- honed_reflexes[391271] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- rebound[213915] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'amplitude': 1.0, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_TAKEN_BY_PCT, }
        -- rebound[213915] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': MAX_STACKS, }
        -- protection_warrior[137048] #18: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },

    -- Hurls your weapon at an enemy, causing $s1 Physical damage and stunning for $132169d.$?s436162[ Also hits 2 additional nearby targets, stunning for 2 sec.][]
    storm_bolt = {
        id = 107570,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "global",

        talent = "storm_bolt",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.285, 'variance': 0.05, 'radius': 10.0, 'target': TARGET_DEST_TARGET_ENEMY, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- honed_reflexes[391271] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- storm_bolts[436162] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- storm_bolts[436162] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- Taunts the target to attack you.
    taunt = {
        id = 355,
        cast = 0.0,
        cooldown = 8.0,
        gcd = "none",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': ATTACK_ME, 'subtype': NONE, 'sp_bonus': 0.25, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_TAUNT, 'points': 400.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_INCREASE_SPEED, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- neltharions_fury[203524] #3: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- bladestorm[227847] #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
    },

    -- Blasts all enemies within $A1 yards for $s1 Stormstrike damage$?s199045[, roots them for $199042d,][] and reduces their movement speed by $435203s1% for $435203d. Deals reduced damage beyond $s5 targets.$?a137048|(a137050&a436707)[; Generates ${$s4/10} Rage.][]
    thunder_blast = {
        id = 435222,
        cast = 0.0,
        cooldown = 6.0,
        gcd = "global",

        spend = 300,
        spendType = 'rage',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.491, 'variance': 0.05, 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': ENERGIZE, 'subtype': NONE, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'resource': rage, }
        -- #4: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- fury_warrior[137050] #9: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 45.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- barbaric_training[390674] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- barbaric_training[390674] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- crackling_thunder[203201] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
        -- crashing_thunder[436707] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- crashing_thunder[436707] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- crashing_thunder[436707] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- crashing_thunder[436707] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- meat_cleaver[280392] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- recklessness[1719] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- thunder_blast[435607] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- thunder_blast[435615] #0: { 'type': APPLY_AURA, 'subtype': OVERRIDE_ACTIONBAR_SPELLS, 'attributes': ['Suppress Points Stacking'], 'spell': 435222, 'target': TARGET_UNIT_CASTER, }
        -- protection_warrior[137048] #19: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- protection_warrior[137048] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Blasts all enemies within $A1 yards for $s1 Physical damage$?s199045[, roots them for $199042d,][] and reduces their movement speed by $435203s1% for $435203d. Deals reduced damage beyond $s5 targets.$?a137048|(a137050&a436707)[; Generates ${$s4/10} Rage.][]$?c1|c3[; If you have Rend, Thunder Clap affects $s5 nearby targets with Rend.; ][]
    thunder_clap = {
        id = 6343,
        cast = 0.0,
        cooldown = 6.0,
        gcd = "global",

        spend = 200,
        spendType = 'rage',

        talent = "thunder_clap",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.491, 'variance': 0.05, 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': rage, }
        -- #4: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #9: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 45.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- barbaric_training[390674] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- barbaric_training[390674] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- crackling_thunder[203201] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- crashing_thunder[436707] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- crashing_thunder[436707] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- crashing_thunder[436707] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- meat_cleaver[280392] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- recklessness[1719] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- thunder_blast[435615] #0: { 'type': APPLY_AURA, 'subtype': OVERRIDE_ACTIONBAR_SPELLS, 'attributes': ['Suppress Points Stacking'], 'spell': 435222, 'target': TARGET_UNIT_CASTER, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- protection_warrior[137048] #19: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- protection_warrior[137048] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Roar explosively, dealing $s1 Physical damage to enemies within $A1 yds and cause them to bleed for $397364o1 physical damage over $397364d.
    thunderous_roar = {
        id = 384318,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "global",

        talent = "thunderous_roar",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 1.728, 'variance': 0.05, 'radius': 12.0, 'target': TARGET_DEST_CASTER, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 397364, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- thunderous_words[384969] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- uproar[391572] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -45000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- recklessness[1719] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },

    -- Strikes the target, causing $s1 damage and healing you for $118779s1% of your maximum health.; Only usable within $32216d after you kill an enemy that yields experience or honor.
    victory_rush = {
        id = 34428,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 0.472, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mastery_unshackled_fury[76856] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_unshackled_fury[76856] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.4, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fury_warrior[137050] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fury_warrior[137050] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[107574] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[107574] #3: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- avatar[401150] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- avatar[401150] #8: { 'type': APPLY_AURA_ON_PET, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.75, 'points': 20.0, 'value': 22, 'schools': ['holy', 'fire', 'frost'], 'target': TARGET_UNIT_CASTER, }
        -- dual_wield_specialization[382900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dual_wield_specialization[382900] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- onehanded_weapon_specialization[382895] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twohanded_weapon_specialization[382896] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- recklessness[1719] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- singleminded_fury[81099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- singleminded_fury[81099] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- death_wish[199261] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_wish[199261] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- champions_spear[376080] #4: { 'type': APPLY_AURA, 'subtype': MOD_CRITICAL_DAMAGE_TAKEN_FROM_CASTER, 'points': 25.0, 'radius': 5.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- enrage[184362] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enrage[184362] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- whirlwind[85739] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- protection_warrior[137048] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- protection_warrior[137048] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- [34428] Strikes the target, causing $s1 damage and healing you for $118779s1% of your maximum health.; Only usable within $32216d after you kill an enemy that yields experience or honor.
    victory_rush_118779 = {
        id = 118779,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': HEAL_PCT, 'subtype': NONE, 'points': 10.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_SCALE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- victory_rush[319158] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- protection_warrior[137048] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': THREAT, }
        from = "class",
    },

    -- Stomp the ground, causing a ring of corrupted spikes to erupt upwards, dealing $sw1 Shadow damage and applying the Colossus Smash effect to all nearby enemies.
    warbreaker = {
        id = 209577,
        color = 'artifact',
        cast = 0.0,
        cooldown = 60.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': WEAPON_PERCENT_DAMAGE, 'subtype': NONE, 'points': 119.0, 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #1: { 'type': NORMALIZED_WEAPON_DMG, 'subtype': NONE, 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
    },

    -- Unleashes a whirlwind of steel, striking all nearby enemies for $<damage> Physical damage. Deals reduced damage beyond $s3 targets.$?s12950[; Causes your next $85739u single-target melee $lattack:attacks; to strike up to $85739s1 additional targets for $85739s3% damage.][]$?s12950[; Generates $s1 Rage, plus an additional $s2 per target hit.][]
    whirlwind = {
        id = 190411,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'radius': 8.0, 'target': TARGET_DEST_CASTER, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 199667, 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 44949, 'target': TARGET_UNIT_CASTER, }
        -- #5: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 199852, 'value': 200, 'schools': ['nature', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #6: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 199851, 'value': 200, 'schools': ['nature', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #7: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 199852, 'value': 400, 'schools': ['frost'], 'target': TARGET_UNIT_CASTER, }
        -- #8: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 199851, 'value': 400, 'schools': ['frost'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- recklessness[1719] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- recklessness[1719] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- storm_of_swords[388903] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 7000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- storm_of_swords[388903] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 80.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Unleashes a whirlwind of steel, $?s202316[hitting your primary target with Slam and ][]striking all nearby targets for $<baseDmg> Physical damage. Deals reduced damage beyond $s1 targets.
    whirlwind_1680 = {
        id = 1680,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 200,
        spendType = 'rage',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'attributes': ['Is Harmful'], 'trigger_spell': 199658, 'points': 5.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'attributes': ['Is Harmful'], 'trigger_spell': 199850, 'value': 200, 'schools': ['nature', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'attributes': ['Is Harmful'], 'trigger_spell': 411547, 'value': 400, 'schools': ['frost'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- warrior[137047] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- warrior[137047] #1: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'sp_bonus': 0.25, 'points': 100.0, 'value': 11, 'schools': ['physical', 'holy', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- barbaric_training[390674] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- barbaric_training[390674] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- barbaric_training[383082] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- barbaric_training[383082] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- meat_cleaver[280392] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- storm_of_swords[388903] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 7000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- storm_of_swords[388903] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 80.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        from = "class",
    },

    -- Hurl your weapon at the enemy, causing $<damage> Physical damage, ignoring armor. Deals up to $?s329033[${($329033s3/100+1)*500}][500]% increased damage to absorb shields.
    wrecking_throw = {
        id = 384110,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        talent = "wrecking_throw",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': TRIGGER_MISSILE, 'subtype': NONE, 'trigger_spell': 394354, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- demolition[329033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

} )