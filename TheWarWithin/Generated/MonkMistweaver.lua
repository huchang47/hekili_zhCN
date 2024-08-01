-- MonkMistweaver.lua
-- July 2024

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 270 )

-- Resources
spec:RegisterResource( Enum.PowerType.Energy )
spec:RegisterResource( Enum.PowerType.Mana )
spec:RegisterResource( Enum.PowerType.Chi )

spec:RegisterTalents( {
    -- Monk Talents
    ancient_arts                  = { 101184, 344359, 2 }, -- Reduces the cooldown of Paralysis by ${$abs($s0/1000)} sec and the cooldown of Leg Sweep by ${$s2/-1000} sec.
    bounce_back                   = { 101177, 389577, 1 }, -- When a hit deals more than $m2% of your maximum health, reduce all damage you take by $s1% for $390239d.; This effect cannot occur more than once every $m3 seconds.
    bounding_agility              = { 101161, 450520, 1 }, -- Roll and Chi Torpedo travel a small distance further.
    calming_presence              = { 101153, 388664, 1 }, -- Reduces all damage taken by $s1%.
    celerity                      = { 101183, 115173, 1 }, -- Reduces the cooldown of Roll by ${$m1/-1000} sec and increases its maximum number of charges by $m2.
    celestial_determination       = { 101180, 450638, 1 }, -- While your Celestial is active, you cannot be slowed below $s2% normal movement speed.
    chi_proficiency               = { 101169, 450426, 2 }, -- Magical damage done increased by $s1% and healing done increased by $s2%.
    chi_torpedo                   = { 101183, 115008, 1 }, -- Torpedoes you forward a long distance and increases your movement speed by $119085m1% for $119085d, stacking up to 2 times.
    clash                         = { 101154, 324312, 1 }, -- You and the target charge each other, meeting halfway then rooting all targets within $128846A1 yards for $128846d.
    crashing_momentum             = { 101149, 450335, 1 }, -- Targets you Roll through are snared by $450342s1% for $450342d.
    diffuse_magic                 = { 101165, 122783, 1 }, -- Reduces magic damage you take by $m1% for $d, and transfers all currently active harmful magical effects on you back to their original caster if possible.
    disable                       = { 101149, 116095, 1 }, -- Reduces the target's movement speed by $s1% for $d, duration refreshed by your melee attacks.$?s343731[ Targets already snared will be rooted for $116706d instead.][]
    elusive_mists                 = { 101144, 388681, 1 }, -- Reduces all damage taken by you and your target while channeling Soothing Mists by $s1%.
    energy_transfer               = { 101151, 450631, 1 }, -- Successfully interrupting an enemy reduces the cooldown of Paralysis and Roll by ${$s1/-1000} sec.
    escape_from_reality           = { 101176, 394110, 1 }, -- After you use Transcendence: Transfer, you can use Transcendence: Transfer again within $343249d, ignoring its cooldown.
    expeditious_fortification     = { 101174, 388813, 1 }, -- Fortifying Brew cooldown reduced by ${$s1/-1000} sec.
    fast_feet                     = { 101185, 388809, 1 }, -- Rising Sun Kick deals $s1% increased damage. Spinning Crane Kick deals $s2% additional damage.; 
    fatal_touch                   = { 101178, 394123, 1 }, -- Touch of Death increases your damage by $450832s1% for $450832d after being cast and its cooldown is reduced by ${$s1/-1000} sec.
    ferocity_of_xuen              = { 101166, 388674, 1 }, -- Increases all damage dealt by $s1%.
    flow_of_chi                   = { 101170, 450569, 1 }, -- You gain a bonus effect based on your current health.; Above $s1% health: Movement speed increased by $450574s1%. This bonus stacks with similar effects.; Between $s1% and $s2% health: Damage taken reduced by $450572s1%.; Below $s2% health: Healing received increased by $450571s1%. 
    fortifying_brew               = { 101173, 115203, 1 }, -- Turns your skin to stone for $120954d, increasing your current and maximum health by $<health>% and reducing all damage you take by $<damage>%.; Combines with other Fortifying Brew effects.
    grace_of_the_crane            = { 101146, 388811, 1 }, -- Increases all healing taken by $s1%.
    hasty_provocation             = { 101158, 328670, 1 }, -- Provoked targets move towards you at $s1% increased speed.
    healing_winds                 = { 101171, 450560, 1 }, -- Transcendence: Transfer immediately heals you for $450559s1% of your maximum health.
    improved_touch_of_death       = { 101140, 322113, 1 }, -- Touch of Death can now be used on targets with less than $s1% health remaining, dealing $s2% of your maximum health in damage.
    ironshell_brew                = { 101174, 388814, 1 }, -- Increases your maximum health by an additional $s1% and your damage taken is reduced by an additional $s2% while Fortifying Brew is active.
    jade_walk                     = { 101160, 450553, 1 }, -- While out of combat, your movement speed is increased by $450552s1%.
    lighter_than_air              = { 101168, 449582, 1 }, -- Roll causes you to become lighter than air, allowing you to double jump to dash forward a short distance once within $449609d, but the cooldown of Roll is increased by ${$s1/1000} sec.
    martial_instincts             = { 101179, 450427, 2 }, -- Increases your Physical damage done by $s1% and Avoidance increased by $s2%.
    paralysis                     = { 101142, 115078, 1 }, -- Incapacitates the target for $d. Limit 1. Damage will cancel the effect.
    peace_and_prosperity          = { 101163, 450448, 1 }, -- Reduces the cooldown of Ring of Peace by ${$s1/-1000} sec and Song of Chi-Ji's cast time is reduced by ${$s2/-1000}.1 sec.
    pressure_points               = { 101141, 450432, 1 }, -- Paralysis now removes all Enrage effects from its target.
    profound_rebuttal             = { 101135, 392910, 1 }, -- Expel Harm's critical healing is increased by $s1%.
    quick_footed                  = { 101158, 450503, 1 }, -- The duration of snare effects on you is reduced by $s1%.
    ring_of_peace                 = { 101136, 116844, 1 }, -- Form a Ring of Peace at the target location for $d. Enemies that enter will be ejected from the Ring.
    rising_sun_kick               = { 101186, 107428, 1 }, -- Kick upwards, dealing $?s137025[${$185099s1*$<CAP>/$AP}][$185099s1] Physical damage$?s128595[, and reducing the effectiveness of healing on the target for $115804d][].$?a388847[; Applies Renewing Mist for $388847s1 seconds to an ally within $388847r yds][]
    rushing_reflexes              = { 101154, 450154, 1 }, -- Your heightened reflexes allow you to react swiftly to the presence of enemies, causing you to quickly lunge to the nearest enemy in front of you within $450156r yards after you Roll.
    save_them_all                 = { 101157, 389579, 1 }, -- When your healing spells heal an ally whose health is below $s3% maximum health, you gain an additional $s1% healing for the next $390105d.
    song_of_chiji                 = { 101136, 198898, 1 }, -- Conjures a cloud of hypnotic mist that slowly travels forward. Enemies touched by the mist fall asleep, Disoriented for $198909d.
    soothing_mist                 = { 101143, 115175, 1 }, -- Heals the target for $o1 over $d. While channeling, Enveloping Mist$?s227344[, Surging Mist,][]$?s124081[, Zen Pulse,][] and Vivify may be cast instantly on the target.$?s117907[; Each heal has a chance to cause a Gust of Mists on the target.][]$?s388477[; Soothing Mist heals a second injured ally within $388478A2 yds for $388477s1% of the amount healed.][]
    spear_hand_strike             = { 101152, 116705, 1 }, -- Jabs the target in the throat, interrupting spellcasting and preventing any spell from that school of magic from being cast for $d.
    spirits_essence               = { 101138, 450595, 1 }, -- Transcendence: Transfer snares targets within $450596A2 yds by $450596s1% for $450596d when cast.
    strength_of_spirit            = { 101135, 387276, 1 }, -- Expel Harm's healing is increased by up to $s1%, based on your missing health.
    swift_art                     = { 101155, 450622, 1 }, -- Roll removes a snare effect once every $proccooldown sec.
    tiger_tail_sweep              = { 101182, 264348, 1 }, -- Increases the range of Leg Sweep by $s1 yds.
    tigers_lust                   = { 101147, 116841, 1 }, -- Increases a friendly target's movement speed by $s1% for $d and removes all roots and snares.
    transcendence                 = { 101167, 101643, 1 }, -- Split your body and spirit, leaving your spirit behind for $d. Use Transcendence: Transfer to swap locations with your spirit.
    transcendence_linked_spirits  = { 101176, 434774, 1 }, -- Transcendence now tethers your spirit onto an ally for $434763d. Use Transcendence: Transfer to teleport to your ally's location.
    vigorous_expulsion            = { 101156, 392900, 1 }, -- Expel Harm's healing increased by $s1% and critical strike chance increased by $s2%. 
    vivacious_vivification        = { 101145, 388812, 1 }, -- Every $t1 sec, your next Vivify becomes instant and its healing is increased by $392883s2%.$?c1[; This effect also reduces the energy cost of Vivify by $392883s3%.]?c3[; This effect also reduces the energy cost of Vivify by $392883s3%.][]; 
    winds_reach                   = { 101148, 450514, 1 }, -- The range of Disable is increased by $s1 yds.;  ; The duration of Crashing Momentum is increased by ${$s3/1000} sec and its snare now reduces movement speed by an additional $s2%.
    windwalking                   = { 101175, 157411, 1 }, -- You and your allies within $m2 yards have $s1% increased movement speed. Stacks with other similar effects.
    yulons_grace                  = { 101165, 414131, 1 }, -- Find resilience in the flow of chi in battle, gaining a magic absorb shield for ${$s1/10}.1% of your max health every $t sec in combat, stacking up to $s2%.

    -- Mistweaver Talents
    ancient_concordance           = { 101105, 388740, 1 }, -- Your Blackout Kicks strike ${$s2+1} targets and have an additional $s1% chance to reset the cooldown of your Rising Sun Kick while within your Jadefire Stomp.
    ancient_teachings             = { 101102, 388023, 1 }, -- After casting Jadefire Stomp, your Tiger Palm, Blackout Kick, and Rising Sun Kick heal up to $s2 injured allies within $388024A1 yds for $<healing>% of the damage done, split evenly among them. Lasts $388026d.; While Ancient Teachings is active, your Stamina is increased by $388026s1%.
    aspect_of_harmony             = { 101223, 450508, 1 }, -- Store vitality from $?a137023[$s1%][$s2%] of your damage dealt and $?a137023[$s3%][$s4%] of your $?a137023[effective ][]healing.$?a137024[ Vitality stored from overhealing is reduced.][]; For $450711d after casting $?a137023[Celestial Brew][Thunder Focus Tea] your spells and abilities draw upon the stored vitality to deal $s6% additional $?a137023[damage over $450763d][healing over $450769d].
    august_dynasty                = { 101235, 442818, 1 }, -- Casting Jadefire Stomp increases the $?c2[damage or healing of your next Rising Sun Kick by $442850s1% or Vivify by $442850s2%]?c3[damage of your next Rising Sun Kick by $442850s1%][].; This effect can only activate once every $proccooldown sec.
    awakened_jadefire             = { 101104, 388779, 1 }, -- Your abilities reset Jadefire Stomp $s2% more often. While within Jadefire Stomp, your Tiger Palms strike twice and your Spinning Crane Kick heals $s4 nearby allies for $s1% of the damage done.
    balanced_stratagem            = { 101230, 450889, 1 }, -- Casting a Physical spell or ability increases the damage and healing of your next Fire or Nature spell or ability by 5%, and vice versa. Stacks up to 5.
    burst_of_life                 = { 101098, 399226, 1 }, -- When Life Cocoon expires, it releases a burst of mist that restores $399230s2 health to $s3 nearby allies.
    calming_coalescence           = { 101095, 388218, 1 }, -- Each time Soothing Mist heals, the absorb amount of your next Life Cocoon is increased by $s1%, stacking up to $388220u times.
    celestial_conduit             = { 101243, 443028, 1 }, -- $?c2[The August Celestials empower you, causing you to radiate ${$443039s1*$s7} healing onto up to $s3 injured allies and ${$443038s1*$s7} Nature damage onto enemies within $s6 yds over $d, split evenly among them. Healing and damage increased by $s1% per target, up to ${$s1*$s3}%.]?c3[The August Celestials empower you, causing you to radiate ${$443038s1*$s7} Nature damage onto enemies and ${$443039s1*$s7} healing onto up to $s3 injured allies within $443038A2 yds over $d, split evenly among them. Healing and damage increased by $s1% per enemy struck, up to ${$s1*$s3}%.][]; You may move while channeling, but casting other healing or damaging spells cancels this effect.; 
    celestial_harmony             = { 101128, 343655, 1 }, -- While active, Yu'lon and Chi'Ji heal up to $s3 nearby targets with Enveloping Breath when you cast Enveloping Mist, healing for ${$325209s1*$325209d/$325209t1} over $325209d, and increasing the healing they receive from you by $325209s3%.; When activated, Yu'lon and Chi'Ji apply Chi Cocoons to $406139s3 targets within $406139r yds, absorbing $<newshield> damage for $406139d.
    chi_burst                     = { 102432, 123986, 1 }, -- Hurls a torrent of Chi energy up to $460485s1 yds forward, dealing $148135s1 Nature damage to all enemies, and $130654s1 healing to the Monk and all allies in its path. Healing and damage reduced beyond $s1 targets.; $?c1[; Casting Chi Burst does not prevent avoiding attacks.][]
    chi_harmony                   = { 101121, 448392, 1 }, -- Renewing Mist increases its target's healing received from you by $423439s1% for the first $457013d of its duration, but cannot jump to a new target during this time.
    chi_wave                      = { 102432, 450391, 1 }, -- Every $t1 sec, your next Rising Sun Kick or Vivify releases a wave of Chi energy that flows through friends and foes, dealing $132467s1 Nature damage or $132463s1 healing. Bounces up to $115098s1 times to targets within $132466a2 yards.
    chijis_swiftness              = { 101240, 443566, 1 }, -- Your movement speed is increased by $s1% during Celestial Conduit and by $443569s1% for $443569d after being assisted by any Celestial.; 
    chrysalis                     = { 101098, 202424, 1 }, -- Reduces the cooldown of Life Cocoon by ${$m1/-1000} sec.
    clarity_of_purpose            = { 101228, 451017, 1 }, -- Casting $?a137023[Purifying Brew][Vivify] stores $<value> vitality, increased based on $?a137023[Stagger level][your recent Gusts of Mist].
    coalescence                   = { 101227, 450529, 1 }, -- When Aspect of Harmony $?a450870[deals damage or heals]?a137023[deals damage][heals], it has a chance to spread to a nearby $?a450870[target]?a137023[enemy][ally]. When you directly $?a450870[attack or heal]?a137023[attack][heal] an affected target, it has a chance to intensify.; Targets damaged or healed by your Aspect of Harmony take $s2% increased damage or healing from you.
    courage_of_the_white_tiger    = { 101242, 443087, 1 }, -- $?c2[Tiger Palm and Vivify have a chance to cause Xuen to claw a nearby enemy for $457917s1 Physical damage, healing a nearby ally for $s2% of the damage done.]?c3[Tiger Palm has a chance to cause Xuen to claw your target for $457917s1 Physical damage, healing a nearby ally for $s2% of the damage done.][Xuen claws your target for $457917s1 Physical damage, healing a nearby ally for $s2% of the damage done.]; $?c2[Invoke Yu'lon, the Jade Serpent or Invoke Chi-Ji, the Red Crane]?c3[Invoke Xuen, the White Tiger][Invoking a celestial] guarantees your next cast activates this effect.
    crane_style                   = { 101097, 446260, 1 }, -- Rising Sun Kick now kicks up a Gust of Mist to heal $s1 $Lally:allies; within $446264A2 yds for $191894s1. ; Spinning Crane Kick and Blackout Kick have a chance to kick up a Gust of Mist to heal $s2 $Lally:allies; within $446264A2 yds for $191894s1. 
    dance_of_chiji                = { 101106, 438439, 1 }, -- Your spells and abilities have a chance to make your next Spinning Crane Kick deal an additional $s1% damage.
    dance_of_the_wind             = { 101139, 432181, 1 }, -- Your dodge chance is increased by $s2% and an additional $432180s1% every $t1 sec until you dodge an attack, stacking up to $432180u times. 
    dancing_mists                 = { 101112, 388701, 1 }, -- Renewing Mist has a $s1% chance to immediately spread to an additional target when initially cast or when traveling to a new target.
    deep_clarity                  = { 101122, 446345, 1 }, -- After you fully consume Thunder Focus Tea, your next Vivify triggers Zen Pulse.
    endless_draught               = { 101225, 450892, 1 }, -- $?a137023[Celestial Brew][Thunder Focus Tea] has $s1 additional charge.
    energizing_brew               = { 101130, 422031, 1 }, -- Mana Tea now channels $s1% faster and generates $s2% more Mana.
    enveloping_mist               = { 101134, 124682, 1 }, -- Wraps the target in healing mists, healing for $o1 over $d, and increasing healing received from your other spells by $m2%. $?a388847[; Applies Renewing Mist for $388847s1 seconds to an ally within $388847r yds.][]
    flight_of_the_red_crane       = { 101234, 443255, 1 }, -- $?c2[Refreshing Jade Wind and Spinning Crane Kick have a chance to cause Chi-Ji to grant you a stack of Mana Tea and quickly rush to $s1 allies, healing each target for $443272s1.]?c3[Rushing Jade Wind and Spinning Crane Kick have a chance to cause Chi-Ji to increase your energy regeneration by $457459s1% for $457459d and quickly rush to $s1 enemies, dealing $443263s1 Physical damage to each target struck.][]
    focused_thunder               = { 101115, 197895, 1 }, -- Thunder Focus Tea now empowers your next ${$m1+1} spells.
    gift_of_the_celestials        = { 101113, 388212, 1 }, -- Reduces the cooldown of $?s325197[Invoke Chi-Ji, the Red Crane][Invoke Yul'on, the Jade Serpent] by ${$s1/-60000} min, but decreases its duration to ${($s4+$s2)/1000} sec. 
    harmonic_gambit               = { 101224, 450870, 1 }, -- During Aspect of Harmony, $?a137023[Expel Harm and Vivify withdraw vitality to heal][Rising Sun Kick, Blackout Kick, and Tiger Palm also withdraw vitality to damage enemies].
    healing_elixir                = { 101109, 122280, 1 }, -- You consume a healing elixir when you drop below $s1% health or generate excess healing elixirs, instantly healing you for $428439s1% of your maximum health.; You generate $s2 healing elixir every $t2 sec, stacking up to $s3 times.
    heart_of_the_jade_serpent     = { 101237, 443294, 1 }, -- Consuming $?c2[$443506u stacks of Sheilun's Gift calls]?c3[$443424u Chi causes your next Strike of the Windlord to call][] upon Yu'lon to decrease the cooldown time of $?c2[Renewing Mist, Rising Sun Kick, Life Cocoon, and Thunder Focus Tea]?c3[Rising Sun Kick, Fists of Fury, Strike of the Windlord, and Whirling Dragon Punch][] by $443421s2% for $443421d.$?c3[ ; The channel time of Fists of Fury is reduced by $443421s5% while Yu'lon is active.][]
    improved_detox                = { 101089, 388874, 1 }, -- Detox additionally removes all Poison and Disease effects.
    inner_compass                 = { 101235, 443571, 1 }, -- You switch between alignments after an August Celestial assists you, increasing a corresponding secondary stat by $443572s1%.; Crane Stance:; Haste; Tiger Stance:; Critical Strike; Ox Stance:; Versatility; Serpent Stance: ; Mastery
    invigorating_mists            = { 101110, 274586, 1 }, -- Vivify heals all allies with your Renewing Mist active for $425804s1, reduced beyond $s1 allies.; 
    invoke_chiji_the_red_crane    = { 101129, 325197, 1 }, -- Summon an effigy of Chi-Ji for $d that kicks up a Gust of Mist when you Blackout Kick, Rising Sun Kick, or Spinning Crane Kick, healing up to $343818s3 allies for $343819s1, and reducing the cost and cast time of your next Enveloping Mist by $343820s1%, stacking.; Chi-Ji's presence makes you immune to movement impairing effects.
    invoke_yulon_the_jade_serpent = { 101129, 322118, 1 }, -- Summons an effigy of Yu'lon, the Jade Serpent for $d. Yu'lon will heal injured allies with Soothing Breath, healing the target and up to $s2 allies for $343737o1 over $343737d. ; Enveloping Mist costs $s4% less mana while Yu'lon is active.
    invokers_delight              = { 101123, 388661, 1 }, -- You gain $388663m1% haste for $?a388212[${$s2-$s3} sec][$388663d] after summoning your Celestial. 
    jade_bond                     = { 101113, 388031, 1 }, -- Abilities that activate Gust of Mist reduce the cooldown on $?s325197[Invoke Chi-Ji, the Red Crane][Invoke Yul'on, the Jade Serpent] by ${$s2/-1000}.1 sec, and Chi-Ji's Gusts of Mists healing is increased by $s1% and Yu'lon's Soothing Breath healing is increased by $s3%.
    jade_sanctuary                = { 101238, 443059, 1 }, -- You heal for $s2% of your maximum health instantly when you activate Celestial Conduit and receive $s1% less damage for its duration. ; This effect lingers for an additional $448508d after Celestial Conduit ends.
    jadefire_stomp                = { 101101, 388193, 1 }, -- Strike the ground fiercely to expose a path of jade for $d$?a137025[ that increases your movement speed by $451943s1% while inside][], dealing $388207s1 Nature damage to $?a451573[$s1 enemy][up to $s1 enemies], and restoring $388207s2 health to $?a451573[$s1 ally][up to $s4 allies] within $388207a1 yds caught in the path.$?a137024[]?a137025[ Up to 5 enemies caught in the path][Stagger is $s3% more effective for $347480d against enemies caught in the path.]$?a137023[]?a137024[][ suffer an additional $388201s1 damage.]$?a137024[; Your abilities have a $s2% chance of resetting the cooldown of Jadefire Stomp while fighting within the path.][]
    legacy_of_wisdom              = { 101118, 404408, 1 }, -- Sheilun's Gift heals $s1 additional allies and its cast time is reduced by ${$s2/-1000}.1 sec.
    life_cocoon                   = { 101096, 116849, 1 }, -- Encases the target in a cocoon of Chi energy for $d, absorbing $<newshield> damage and increasing all healing over time received by $m2%.$?a388548[; Applies Renewing Mist and Enveloping Mist to the target.][]
    lifecycles                    = { 101130, 197915, 1 }, -- Vivify has a $s2% chance to cause your next Rising Sun Kick or Enveloping Mist to generate $s1 stack of Mana Tea.; Enveloping Mist and Rising Sun Kick have a $s3% chance to cause your next Vivify to generate $s1 stack of Mana Tea.
    lotus_infusion                = { 101121, 458431, 1 }, -- Allies with Renewing Mist receive $s1% more healing from you and Renewing Mist's duration is increased by ${$s2/1000} sec.
    mana_tea                      = { 101132, 115869, 1 }, -- [115294] Consumes 1 stack of Mana Tea per $t1 sec to restore $s1 Mana and reduces the Mana cost of your spells by $197908s1% for ${$115869s3/1000}.2 sec per stack of Mana Tea consumed after drinking.; Can be cast while moving, but movement speed is reduced by $s2% while channeling.
    manifestation                 = { 101222, 450875, 1 }, -- Chi Burst and Chi Wave deal $s1% increased damage and healing.
    mantra_of_purity              = { 101229, 451036, 1 }, -- $?a137023[Purifying Brew removes $s1% additional Stagger and causes you to absorb up to $<value> incoming Stagger][When cast on yourself, your single-target healing spells heal for $s2% more and restore an additional $451452o1 health over $451452d].
    mantra_of_tenacity            = { 101229, 451029, 1 }, -- $?a137023[Fortifying Brew applies a Chi Cocoon][Fortifying Brew grants $s1% Stagger].
    mending_proliferation         = { 101125, 388509, 1 }, -- Each time Enveloping Mist heals, its healing bonus has a $s2% chance to spread to an injured ally within $388508a1 yds.
    mist_wrap                     = { 101093, 197900, 1 }, -- Increases Enveloping Mist's duration by ${$m2/1000} sec and its healing bonus by $s1%.
    mists_of_life                 = { 101099, 388548, 1 }, -- Life Cocoon applies Renewing Mist and Enveloping Mist to the target. 
    misty_peaks                   = { 101114, 388682, 2 }, -- Renewing Mist's heal over time effect has a ${$s3}.1% chance to apply Enveloping Mist for $s2 sec.
    niuzaos_protection            = { 101238, 442747, 1 }, -- Fortifying Brew grants you an absorb shield for $442749s2% of your maximum health.
    nourishing_chi                = { 101095, 387765, 1 }, -- Life Cocoon increases healing over time received by an additional $s1%, and increases all periodic healing you deal by $s1% for an additional $387766d after the cocoon is removed.
    overflowing_mists             = { 101094, 388511, 2 }, -- Your Enveloping Mists heal the target for ${$s1}.1% of their maximum health each time they take damage.
    overwhelming_force            = { 101220, 451024, 1 }, -- Rising Sun Kick, Blackout Kick, and Tiger Palm deal $s1% additional damage to enemies in a line in front of you. Damage reduced above $s2 targets.
    path_of_resurgence            = { 101226, 450912, 1 }, -- $?a450391[Chi Wave][Chi Burst] increases vitality stored by $451084s1% for $451084d.
    peaceful_mending              = { 101116, 388593, 1 }, -- Allies targeted by Soothing Mist receive $s1% more healing from your Enveloping Mist and Renewing Mist effects.
    peer_into_peace               = { 101127, 440008, 1 }, -- $s1% of your overhealing done onto targets with Soothing Mist is spread to $s2 nearby injured allies.; Soothing Mist now follows the target of your Enveloping Mist or Vivify and its channel time is increased by ${$s3/1000} sec.
    pool_of_mists                 = { 101127, 173841, 1 }, -- Renewing Mist now has ${$s5+$m1} charges and reduces the remaining cooldown of Rising Sun Kick by ${$s3/1000}.1 sec.; Rising Sun Kick now reduces the remaining cooldown of Renewing Mist by ${$s4/1000}.1 sec.
    purified_spirit               = { 101224, 450867, 1 }, -- When Aspect of Harmony ends, any remaining vitality is expelled as $?a137023[damage over $450820d][healing over $450805d], split among nearby targets.
    rapid_diffusion               = { 101111, 388847, 2 }, -- Rising Sun Kick and Enveloping Mist apply Renewing Mist for $s1 seconds to an ally within $r yds.
    refreshing_jade_wind          = { 101093, 457397, 1 }, -- Thunder Focus Tea summons a whirling tornado around you, causing $162530s1 healing every ${$196725t1}.2 sec for $196725d on to up to $196725s2 allies within $162530A1 yards.; 
    renewing_mist                 = { 101107, 115151, 1 }, -- Surrounds the target with healing mists, restoring $119611o1 health over $119611d.; If Renewing Mist heals a target past maximum health, it will travel to another injured ally within $119607A2 yds.$?a231606[; Each time Renewing Mist heals, it has a $s2% chance to increase the healing of your next Vivify by $197206s1%.][]
    resplendent_mist              = { 101126, 388020, 2 }, -- Gust of Mists has a $s2% chance to do $s1% more healing.
    restoral                      = { 101131, 388615, 1 }, -- Heals all party and raid members within $A1 yds for $s1 and clears them of all harmful Poison and Disease effects. ; Castable while stunned.; Healing reduced beyond $s5 targets.
    restore_balance               = { 101233, 442719, 1 }, -- $?c2[Gain Refreshing Jade Wind while Chi-Ji, the Red Crane or Yu'lon, the Jade Serpent is active.]?c3[Gain Rushing Jade Wind while Xuen, the White Tiger is active.][]
    revival                       = { 101131, 115310, 1 }, -- Heals all party and raid members within $A1 yds for $s1 and clears them of $s4 harmful Magic, all Poison, and all Disease effects.; Healing reduced beyond $s5 targets.
    rising_mist                   = { 101117, 274909, 1 }, -- Rising Sun Kick heals all allies with your Renewing Mist and Enveloping Mist for $274912s1, and extends those effects by $s1 sec, up to $s2% of their original duration.
    roar_from_the_heavens         = { 101221, 451043, 1 }, -- Tiger's Lust grants $452701s1% movement speed to up to $452701i allies near its target.
    secret_infusion               = { 101124, 388491, 2 }, -- After using Thunder Focus Tea, your next spell gives $s1% of a stat for $388497d:; $@spellname124682: Critical strike; $@spellname115151: Haste; $@spellname116670: Mastery; $@spellname107428: Versatility; $@spellname322101: Versatility
    shaohaos_lessons              = { 101119, 400089, 1 }, -- Each time you cast Sheilun's Gift, you learn one of Shaohao's Lessons for up to $s1 sec, with the duration based on how many clouds of mist are consumed.; Lesson of Doubt: Your spells and abilities deal up to $400097s1% more healing and damage to targets, based on their current health.; Lesson of Despair: Your Critical Strike is increased by $400100s1% while above $400100s2% health.; Lesson of Fear: Decreases your damage taken by $400103s1% and increases your Haste by $400103s2%.; Lesson of Anger: $400106s1% of the damage or healing you deal is duplicated every $400106s2 sec.
    sheiluns_gift                 = { 101120, 399491, 1 }, -- Draws in all nearby clouds of mist, healing the friendly target and up to ${$s2-1} nearby allies for $s1 per cloud absorbed.; A cloud of mist is generated every $?a400053[$400053s2][$s3] sec while in combat.
    strength_of_the_black_ox      = { 101241, 443110, 1 }, -- $?c2[After Xuen assists you, your next Enveloping Mist's cast time is reduced by $443112s1% and causes Niuzao to grant an absorb shield to $443113s3 nearby allies for $443113s2% of your maximum health.]?c3[After Xuen assists you, your next Blackout Kick refunds $s3 stacks of Teachings of the Monastery and causes Niuzao to stomp at your target's location, dealing $443127s1 damage to nearby enemies, reduced beyond $s2 targets.][]
    summon_jade_serpent_statue    = { 101164, 115313, 1 }, -- Summons a Jade Serpent Statue at the target location. When you channel Soothing Mist, the statue will also begin to channel Soothing Mist on your target, healing for $198533o1 over $198533d.
    tea_of_plenty                 = { 101103, 388517, 1 }, -- Thunder Focus Tea also empowers $s1 additional Enveloping Mist, Expel Harm, or Rising Sun Kick at random.
    tea_of_serenity               = { 101103, 393460, 1 }, -- Thunder Focus Tea also empowers $s1 additional Renewing Mist, Enveloping Mist, or Vivify at random.
    tear_of_morning               = { 101117, 387991, 1 }, -- Casting Vivify or Enveloping Mist on a target with Renewing Mist has a $s3% chance to spread the Renewing Mist to another target.; Your Vivify healing through Renewing Mist is increased by $s1% and your Enveloping Mist also heals allies with Renewing Mist for $s2% of its healing.
    temple_training               = { 101236, 442743, 1 }, -- $?c2[The healing of Enveloping Mist and Vivify is increased by $s1%.]?c3[Fists of Fury and Spinning Crane Kick deal $s2% more damage.][]
    thunder_focus_tea             = { 101133, 116680, 1 }, -- Receive a jolt of energy, empowering your next $?a197895[$u spells][spell] cast:; $@spellname124682: Immediately heals for $274062s1 and is instant cast.; $@spellname115151: Duration increased by ${$s3/1000} sec.; $@spellname116670: No mana cost.; $@spellname107428: Cooldown reduced by ${$s1/-1000} sec.; $@spellname322101: Transfers $s7% additional healing into damage and creates a Chi Cocoon absorbing $<newshield> damage. $?s353936[; $@spellname117952: Knockback applied immediately.; $@spellname109132: Refund a charge and heal yourself for $407058s1.][]
    tigers_vigor                  = { 101221, 451041, 1 }, -- Casting Tiger's Lust reduces the remaining cooldown on Roll by ${$s1/1000} sec.
    unison                        = { 101125, 388477, 1 }, -- Soothing Mist heals a second injured ally within $388478A2 yds for $s1% of the amount healed.
    unity_within                  = { 101239, 443589, 1 }, -- Celestial Conduit can be recast once during its duration to call upon all of the August Celestials to assist you at $s1% effectiveness.; Unity Within is automatically cast when Celestial Conduit ends if not used before expiration.
    uplifted_spirits              = { 101092, 388551, 1 }, -- Vivify critical strikes and Rising Sun Kicks reduce the remaining cooldown on $?s388615[Restoral][Revival] by ${$s2/1000} sec, and $?s388615[Restoral][Revival] heals targets for $s1% of $?s388615[Restoral's][Revival's] heal over $388555d.
    veil_of_pride                 = { 101119, 400053, 1 }, -- Increases Sheilun's Gift cloud of mist generation to every ${-$s1/1000} sec. 
    way_of_a_thousand_strikes     = { 101226, 450965, 1 }, -- Rising Sun Kick, Blackout Kick, and Tiger Palm contribute $s1% additional vitality.
    xuens_guidance                = { 101236, 442687, 1 }, -- Teachings of the Monastery has a $s1% chance to refund a charge when consumed. ; The damage of Tiger Palm is increased by $s2%.
    yulons_knowledge              = { 101233, 443625, 1 }, -- $?c2[Refreshing Jade Wind's duration is increased by ${$s1/1000} sec.]?c3[Rushing Jade Wind's duration is increased by ${$s1/1000} sec.][]
    yulons_whisper                = { 101100, 388038, 1 }, -- While channeling Mana Tea you exhale the breath of Yu'lon, healing up to $s1 allies within $388044a1 yards for $388044s1 every ${$388040t1}.1 sec.
    zen_pulse                     = { 101108, 446326, 1 }, -- Renewing Mist's heal over time has a chance to cause your next Vivify to also trigger a Zen Pulse on its target and all allies with Renewing Mist, healing them for $198487s1 increased by $s1% per Renewing Mist active, up to $s2%.
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    absolute_serenity    = 5642, -- (455945) Celestial Conduit now prevents incapacitate, disorient, snare, and root effects for its duration.
    alpha_tiger          = 5551, -- (287503) Attacking new challengers with Tiger Palm fills you with the spirit of Xuen, granting you $287504m1% haste for $287504d. ; This effect cannot occur more than once every $290512d per target.
    counteract_magic     = 679 , -- (353502) Removing hostile magic effects from a target increases the healing they receive from you by $353503s1% for $353503d, stacking up to $353503u times.
    dematerialize        = 5398, -- (353361) [357819] Demateralize into mist while stunned, reducing damage taken by $353362s1%. Each second you remain stunned reduces this bonus by 10%.
    dome_of_mist         = 680 , -- (202577) Enveloping Mist transforms $s1% of its remaining periodic healing into a Dome of Mist when dispelled.; $@spellicon205655 $@spellname205655; Absorbs damage. All healing received by the Monk increased by $205655m2%. Lasts $205655d.
    eminence             = 70  , -- (353584) Transcendence: Transfer can now be cast if you are stunned. Cooldown reduced by ${($m1/1000)*-1)} sec if you are not.
    grapple_weapon       = 3732, -- (233759) You fire off a rope spear, grappling the target's weapons and shield, returning them to you for $d.
    healing_sphere       = 683 , -- (205234) Coalesces a Healing Sphere out of the mists at the target location after 1.5 sec. If allies walk through it, they consume the sphere, healing themselves for $115464s1 and dispelling all harmful periodic magic effects.; Maximum of $m1 Healing Spheres can be active by the Monk at any given time.
    jadefire_accord      = 5565, -- (406888) Jadefire Stomp's cooldown is reduced by ${$s2/-1000} sec.; Enemies struck by Jadefire Stomp are snared by $406896s1% for $406896d.
    mighty_ox_kick       = 5539, -- (202370) You perform a Mighty Ox Kick, hurling your enemy a distance behind you.
    peaceweaver          = 5395, -- (353313) $?s388615[Restoral's][Revival's] cooldown is reduced by $s2%, and provides immunity to magical damage and harmful effects for $353319d.
    rodeo                = 5645, -- (355917) Every $s1 sec while Clash is off cooldown, your next Clash can be reactivated immediately to wildly Clash an additional enemy. This effect can stack up to $355918u times.
    thunderous_focus_tea = 5402, -- (353936) Thunder Focus Tea can now additionally cause Crackling Jade Lightning's knockback immediately or cause Roll and Chi Torpedo to refund a charge on use and heal you for $407058s1.
    zen_focus_tea        = 1928, -- (209584) Provides immunity to Silence and Interrupt effects for $d.
    zen_spheres          = 5603, -- (410777) Forms a sphere of Hope or Despair above the target. Only one of each sphere can be active at a time.; $@spellicon411036 $@spellname411036: Increases your healing done to the target by $411036s1%.; $@spellicon411038 $@spellname411038: Target deals $411038s1% less damage to you, and takes $411038s2% increased damage from all sources.; 
} )

-- Auras
spec:RegisterAuras( {
    -- Haste increased by $w1%.
    alpha_tiger = {
        id = 287504,
        duration = 8.0,
        max_stack = 1,
    },
    -- The $?c2[damage of your next Rising Sun Kick is increased by $s1% or the healing of your next Vivify is increased by by $s2%]?c3[damage of your next Rising Sun Kick is increased by $s1%][].
    august_dynasty = {
        id = 442850,
        duration = 12.0,
        max_stack = 1,
    },
    -- Your next Blackout Kick costs no Chi$?a451495[ and deals $w3% more damage][].
    blackout_kick = {
        id = 116768,
        duration = 15.0,
        max_stack = 1,
    },
    -- Reduces damage by $w1%.
    bounce_back = {
        id = 390239,
        duration = 4.0,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[428200] #8: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- Absorb amount of your next Life Cocoon is increased by $s1%.
    calming_coalescence = {
        id = 388220,
        duration = 3600,
        max_stack = 1,
    },
    -- Reduces all damage taken by $w1%.
    calming_presence = {
        id = 388664,
        duration = 0.0,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[428200] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'pvp_multiplier': 0.0, 'points': -3.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Channeling the power of the August Celestials, $?c2[healing $s3 nearby allies.]?c3[damaging nearby enemies.][]$?a443059[; Damage taken reduced by $w2%.][]$?a443566[; Movement speed increased by $w5%.][]
    celestial_conduit = {
        id = 443028,
        duration = 4.0,
        max_stack = 1,

        -- Affected by:
        -- chijis_swiftness[443566] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 75.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
        -- jade_sanctuary[443059] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -15.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- jade_sanctuary[443059] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
    },
    -- Chi Burst can be cast!
    chi_burst = {
        id = 460490,
        duration = 20.0,
        max_stack = 1,
    },
    -- Healing taken increased by $s1%.
    chi_harmony = {
        id = 423439,
        duration = 8.0,
        max_stack = 1,
    },
    -- Movement speed increased by $w1%.
    chi_torpedo = {
        id = 119085,
        duration = 10.0,
        max_stack = 1,
    },
    -- Movement speed increased by $w1%.
    chijis_swiftness = {
        id = 443569,
        duration = 3.0,
        max_stack = 1,
    },
    -- Stunned.
    clash = {
        id = 128846,
        duration = 4.0,
        max_stack = 1,
    },
    -- Healing from $@auracaster increased by $w1%.
    counteract_magic = {
        id = 353503,
        duration = 10.0,
        max_stack = 1,
    },
    -- Taking $w1 damage every $t1 sec.
    crackling_jade_lightning = {
        id = 117952,
        duration = 4.0,
        tick_time = 1.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[137024] #14: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 400.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },
    -- Haste increased by $w1%.
    crane_stance = {
        id = 443572,
        duration = 3600,
        max_stack = 1,
    },
    -- Movement slowed by $w1%.
    crashing_momentum = {
        id = 450342,
        duration = 5.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- winds_reach[450514] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- winds_reach[450514] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- winds_reach[450514] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 3000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- Your next Spinning Crane Kick deals an additional $438439s1% damage.
    dance_of_chiji = {
        id = 438443,
        duration = 15.0,
        max_stack = 1,
    },
    -- Your dodge chance is increased by $w1% until you dodge an attack.
    dance_of_the_wind = {
        id = 432180,
        duration = 10.0,
        max_stack = 1,
    },
    -- Damage taken reduced by $w1%, fading over $d.
    dematerialize = {
        id = 353362,
        duration = 3.0,
        max_stack = 1,
    },
    -- Spell damage taken reduced by $m1%.
    diffuse_magic = {
        id = 122783,
        duration = 6.0,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[428200] #16: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- mistweaver_monk[428200] #17: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'pvp_multiplier': 0.0, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Rooted for $d.
    disable = {
        id = 116706,
        duration = 8.0,
        max_stack = 1,
    },
    -- Absorbing $w1 damage.; Healing received from the Monk increased by $w2%.
    dome_of_mist = {
        id = 205655,
        duration = 8.0,
        max_stack = 1,
    },
    -- Heals $w1 every $t1 sec.; Healing received from the Monk increased by $m3%.
    enveloping_breath = {
        id = 325209,
        duration = 6.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- soothing_mist[209525] #1: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING, 'target': TARGET_UNIT_CASTER, }
        -- mist_wrap[197900] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- mist_wrap[197900] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- temple_training[442743] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- temple_training[442743] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- thunder_focus_tea[116680] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- strength_of_the_black_ox[443112] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
    },
    -- Heals $w1 every $t1 sec.; Healing received from the Monk increased by $m2%.
    enveloping_mist = {
        id = 124682,
        duration = 6.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[137024] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mistweaver_monk[137024] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- soothing_mist[209525] #1: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING, 'target': TARGET_UNIT_CASTER, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enveloping_mist[124682] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- mist_wrap[197900] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- mist_wrap[197900] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- temple_training[442743] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- temple_training[442743] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- thunder_focus_tea[116680] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- enveloping_breath[325209] #2: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'radius': 10.0, 'target': TARGET_DEST_TARGET_ALLY, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- lesson_of_doubt[400097] #0: { 'type': APPLY_AURA, 'subtype': UNKNOWN, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }
        -- strength_of_the_black_ox[443112] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- counteract_magic[353503] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ANY, }
        -- dome_of_mist[205655] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },
    -- Transcendence: Transfer has no cooldown.; Vivify's healing is increased by $w3% and you're refunded $m2% of the cost when cast on yourself.
    escape_from_reality = {
        id = 343249,
        duration = 10.0,
        max_stack = 1,
    },
    -- Movement slowed by $s1%.
    fae_accord = {
        id = 406896,
        duration = 8.0,
        max_stack = 1,
    },
    -- Your spells and abilities deal $s1% more damage.
    fatal_touch = {
        id = 450832,
        duration = 30.0,
        max_stack = 1,
    },
    -- Increases all damage dealt by $w1%.
    ferocity_of_xuen = {
        id = 388674,
        duration = 0.0,
        max_stack = 1,
    },
    -- Increases all healing taken by $w1%.
    flow_of_chi = {
        id = 450571,
        duration = 3600,
        max_stack = 1,
    },
    -- Movement speed reduced by $m2%.
    flying_serpent_kick = {
        id = 123586,
        duration = 4.0,
        max_stack = 1,

        -- Affected by:
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- windwalker_monk[137025] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },
    -- $?$w1>0[Health increased by $<health>%, damage taken reduced by $<damage>%.][]$?$w6>0[; Effectiveness of Stagger increased by $115203s1%.][]$?a451029&$c2[; Staggering $451029s1% of incoming damage.][]
    fortifying_brew = {
        id = 120954,
        duration = 15.0,
        max_stack = 1,
    },
    -- Increases all healing taken  by $w1%.
    grace_of_the_crane = {
        id = 388811,
        duration = 0.0,
        max_stack = 1,
    },
    -- Disarmed.
    grapple_weapon = {
        id = 233759,
        duration = 5.0,
        max_stack = 1,
    },
    -- Gathering Yu'lon's energy.
    heart_of_the_jade_serpent = {
        id = 443506,
        duration = 60.0,
        max_stack = 1,

        -- Affected by:
        -- veil_of_pride[400053] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': MAX_STACKS, }
    },
    -- [274586] Vivify heals all allies with your Renewing Mist active for $425804s1, reduced beyond $s1 allies.; 
    invigorating_mists = {
        id = 425804,
        duration = 0.0,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[137024] #28: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Blackout Kick, Rising Sun Kick, or Spinning Crane Kick cause Chi-ji to heal the $s3 nearest allies with a Gust of Mist for $343819s1.; Immune to movement-impairing effects.
    invoke_chiji_the_red_crane = {
        id = 343818,
        duration = 0.0,
        max_stack = 1,
    },
    -- Haste increased by $w1%.
    invokers_delight = {
        id = 388663,
        duration = 20.0,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[428200] #22: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -13.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- windwalker_monk[137025] #29: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -18.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Damage taken reduced by $w1%.
    jade_sanctuary = {
        id = 448508,
        duration = 8.0,
        max_stack = 1,
    },
    -- Movement speed increased by $w1%.
    jade_walk = {
        id = 450552,
        duration = 5.0,
        max_stack = 1,
    },
    -- $?c2[Fighting within jadefire has a $s2% chance of resetting the cooldown of Jadefire Stomp.]c3[A Jadefire Stomp is active.]
    jadefire_stomp = {
        id = 388193,
        duration = 30.0,
        max_stack = 1,
    },
    -- Stunned.
    leg_sweep = {
        id = 119381,
        duration = 3.0,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- ancient_arts[344359] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- tiger_tail_sweep[264348] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },
    -- Your spells and abilities deal up to $s1% more healing and damage to targets, based on their current health.
    lesson_of_doubt = {
        id = 400097,
        duration = 20.0,
        max_stack = 1,
    },
    -- Absorbing $w1 damage$?$w2!=0[ and healing from heal over time effects are increased by $w2%][].
    life_cocoon = {
        id = 116849,
        duration = 12.0,
        max_stack = 1,
    },
    -- You may jump twice to dash forward a short distance.
    lighter_than_air = {
        id = 449609,
        duration = 5.0,
        max_stack = 1,
    },
    -- Mana cost of spells reduced by $s1%.
    mana_tea = {
        id = 197908,
        duration = 10.0,
        max_stack = 1,
    },
    -- Physical damage taken increased by $w1%.
    mystic_touch = {
        id = 113746,
        duration = 3600,
        max_stack = 1,
    },
    -- Absorbing $w1 damage.
    niuzaos_protection = {
        id = 442749,
        duration = 15.0,
        max_stack = 1,
    },
    -- Healing from heal over time effect is increased by $w1%.
    nourishing_chi = {
        id = 387766,
        duration = 10.0,
        max_stack = 1,
    },
    -- Heal for $w1% of your maximum health when you take damage.
    overflowing_mists = {
        id = 388513,
        duration = 6.0,
        max_stack = 1,
    },
    -- Incapacitated.
    paralysis = {
        id = 115078,
        duration = 60.0,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- ancient_arts[344359] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },
    -- Vitality stored increased by $s1%.
    path_of_resurgence = {
        id = 451084,
        duration = 10.0,
        max_stack = 1,

        -- Affected by:
        -- chi_wave[450391] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- Immune to magical damage and harmful effects.
    peaceweaver = {
        id = 353319,
        duration = 2.0,
        max_stack = 1,
    },
    -- Taunted. Movement speed increased by $s3%.
    provoke = {
        id = 116189,
        duration = 3.0,
        max_stack = 1,

        -- Affected by:
        -- hasty_provocation[328670] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },
    -- Restores $w1 health every $t1 sec.$?a448392[; Healing received from $@auracaster increased by $457013s1% for the first $457013d.][]$?e1[; Healing received from $@auracaster increased by $w2%.][]
    renewing_mist = {
        id = 119611,
        duration = 20.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[137024] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mistweaver_monk[137024] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enveloping_mist[124682] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- lotus_infusion[458431] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'pvp_multiplier': 0.34, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- lotus_infusion[458431] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- thunder_focus_tea[116680] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- enveloping_breath[325209] #2: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'radius': 10.0, 'target': TARGET_DEST_TARGET_ALLY, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- lesson_of_doubt[400097] #0: { 'type': APPLY_AURA, 'subtype': UNKNOWN, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }
        -- counteract_magic[353503] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ANY, }
        -- dome_of_mist[205655] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },
    -- Nearby enemies will be knocked out of the Ring of Peace.
    ring_of_peace = {
        id = 116844,
        duration = 5.0,
        max_stack = 1,

        -- Affected by:
        -- peace_and_prosperity[450448] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },
    -- Movement speed increased by $s1%.
    roar_from_the_heavens = {
        id = 452701,
        duration = 6.0,
        max_stack = 1,
    },
    -- Clash can be reactivated.
    rodeo = {
        id = 355918,
        duration = 3.0,
        max_stack = 1,
    },
    -- Healing increased by $w1%.
    save_them_all = {
        id = 390105,
        duration = 4.0,
        max_stack = 1,
    },
    -- Haste increased by $w1%.
    secret_infusion = {
        id = 388497,
        duration = 10.0,
        max_stack = 1,
    },
    -- Disoriented.
    song_of_chiji = {
        id = 198909,
        duration = 20.0,
        max_stack = 1,
    },
    -- Healing for $w1 every $t1 sec.
    soothing_breath = {
        id = 343737,
        duration = 4.5,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- peer_into_peace[440008] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- Healing for $w1 every $t1 sec.
    soothing_mist = {
        id = 198533,
        duration = 8.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[137024] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mistweaver_monk[137024] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enveloping_mist[124682] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- peer_into_peace[440008] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- enveloping_breath[325209] #2: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'radius': 10.0, 'target': TARGET_DEST_TARGET_ALLY, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- lesson_of_doubt[400097] #0: { 'type': APPLY_AURA, 'subtype': UNKNOWN, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }
        -- counteract_magic[353503] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ANY, }
        -- dome_of_mist[205655] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },
    -- Receiving $s1% additional healing from the Monk.
    sphere_of_hope = {
        id = 411036,
        duration = 30.0,
        max_stack = 1,
    },
    -- Attacking all nearby enemies for Physical damage every $101546t1 sec.; Movement speed reduced by $s2%.
    spinning_crane_kick = {
        id = 107270,
        duration = 0.0,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[137024] #13: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 184.0, 'modifies': DAMAGE_HEALING, }
        -- fast_feet[388809] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- temple_training[442743] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #21: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 11.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- windwalker_monk[137025] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 165.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Movement slowed by $w1%.
    spirits_essence = {
        id = 450596,
        duration = 4.0,
        max_stack = 1,
    },
    -- Absorbing $w1 damage.
    strength_of_the_black_ox = {
        id = 443113,
        duration = 10.0,
        max_stack = 1,
    },
    -- Your next Blackout Kick strikes an additional $m1 $Ltime:times;$?s210802[ and restores ${$210803m~1*$m1/100}.2% mana][].
    teachings_of_the_monastery = {
        id = 202090,
        duration = 20.0,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[428200] #9: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'target': TARGET_UNIT_CASTER, 'modifies': MAX_STACKS, }
    },
    -- Your next ability is empowered:; - Enveloping Mist immediately heals for $274062s1 and is instant cast.; - Renewing Mist's duration is increased by ${$w3/1000} sec.; - Vivify costs no mana.; - Rising Sun Kick's cooldown reduced by ${$w1/1000} sec; - Expel Harm: Transfers $w7% additional healing into damage and creates a Chi Cocoon absorbing $<newshield> damage.$?s353936[; - $@spellname117952: Knockback applied immediately.; - $@spellname109132: Refund a charge and heal yourself for $407058s1.][]
    thunder_focus_tea = {
        id = 116680,
        duration = 30.0,
        max_stack = 1,

        -- Affected by:
        -- endless_draught[450892] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- focused_thunder[197895] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': MAX_STACKS, }
        -- focused_thunder[197895] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': ADDITIONAL_CHARGES, }
    },
    -- Moving $s1% faster.
    tigers_lust = {
        id = 116841,
        duration = 6.0,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },
    -- $w1 Nature damage every $t1 sec.
    touch_of_karma = {
        id = 124280,
        duration = 6.0,
        tick_time = 1.0,
        pandemic = true,
        max_stack = 1,
    },
    -- Your spirit is tethered to another player, allowing you to use Transcendence: Transfer to teleport to their location.
    transcendence = {
        id = 434767,
        duration = 3600.0,
        max_stack = 1,

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
    },
    -- Restores $w1 health every $t1 sec.
    uplifted_spirits = {
        id = 388555,
        duration = 10.0,
        max_stack = 1,
    },
    -- Your next Vivify is instant and its healing is increased by $s2%.$?c1[; The cost of Vivify is reduced by $s3%.]?c3[; The cost of Vivify is reduced by $s4%.][]
    vivacious_vivification = {
        id = 392883,
        duration = 3600,
        max_stack = 1,

        -- Affected by:
        -- windwalker_monk[137025] #15: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },
    -- Flying.
    zen_flight = {
        id = 125883,
        duration = 3600,
        max_stack = 1,
    },
    -- Immune to Silence and Interrupt effects.
    zen_focus_tea = {
        id = 209584,
        duration = 5.0,
        max_stack = 1,
    },
} )

-- Abilities
spec:RegisterAbilities( {
    -- [387624] Reduces Stagger by $<reduc>.
    blackout_kick = {
        id = 100784,
        cast = 0.0,
        cooldown = 3.0,
        gcd = "global",

        spend = 3,
        spendType = 'chi',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 0.847, 'pvp_multiplier': 1.3, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'chain_targets': 1, 'ap_bonus': 0.77, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- mistweaver_monk[137024] #6: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'target': TARGET_UNIT_CASTER, }
        -- mistweaver_monk[137024] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 4.0, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- brewmaster_monk[137023] #27: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- windwalker_monk[137025] #8: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- blackout_kick[116768] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- blackout_kick[116768] #1: { 'type': APPLY_AURA, 'subtype': ABILITY_IGNORE_AURASTATE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- blackout_kick[116768] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- $?c2[The August Celestials empower you, causing you to radiate ${$443039s1*$s7} healing onto up to $s3 injured allies and ${$443038s1*$s7} Nature damage onto enemies within $s6 yds over $d, split evenly among them. Healing and damage increased by $s1% per target, up to ${$s1*$s3}%.]?c3[The August Celestials empower you, causing you to radiate ${$443038s1*$s7} Nature damage onto enemies and ${$443039s1*$s7} healing onto up to $s3 injured allies within $443038A2 yds over $d, split evenly among them. Healing and damage increased by $s1% per enemy struck, up to ${$s1*$s3}%.][]; You may move while channeling, but casting other healing or damaging spells cancels this effect.; 
    celestial_conduit = {
        id = 443028,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "global",

        spend = 0.050,
        spendType = 'mana',

        talent = "celestial_conduit",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_TRIGGER_SPELL, 'tick_time': 1.0, 'points': 6.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 5.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': HEAL_PCT, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': APPLY_AURA, 'subtype': MOD_INCREASE_SPEED, 'target': TARGET_UNIT_CASTER, }
        -- #5: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 20.0, 'target': TARGET_UNIT_CASTER, }
        -- #6: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 5.0, 'target': TARGET_UNIT_CASTER, }
        -- #7: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 26, }

        -- Affected by:
        -- chijis_swiftness[443566] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 75.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
        -- jade_sanctuary[443059] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -15.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- jade_sanctuary[443059] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
    },

    -- Hurls a torrent of Chi energy up to $460485s1 yds forward, dealing $148135s1 Nature damage to all enemies, and $130654s1 healing to the Monk and all allies in its path. Healing and damage reduced beyond $s1 targets.; $?c1[; Casting Chi Burst does not prevent avoiding attacks.][]
    chi_burst = {
        id = 123986,
        cast = 1.0,
        cooldown = 30.0,
        gcd = "global",

        talent = "chi_burst",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': CREATE_AREATRIGGER, 'subtype': NONE, 'attributes': ['Position is facing relative'], 'points': 5.0, 'value': 1316, 'schools': ['fire', 'shadow'], 'target': TARGET_DEST_CASTER, }
        -- #1: { 'type': CREATE_AREATRIGGER, 'subtype': NONE, 'attributes': ['Position is facing relative'], 'value': 1315, 'schools': ['physical', 'holy', 'shadow'], 'target': TARGET_DEST_CASTER, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- manifestation[450875] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #26: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },

    -- You and the target charge each other, meeting halfway then rooting all targets within $128846A1 yards for $128846d.
    clash = {
        id = 324312,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        talent = "clash",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- rodeo[355918] #0: { 'type': APPLY_AURA, 'subtype': OVERRIDE_ACTIONBAR_SPELLS_TRIGGERED, 'attributes': ['Suppress Points Stacking'], 'trigger_spell': 324312, 'triggers': clash, 'points': 355919.0, 'value': 324312, 'schools': ['nature', 'frost', 'arcane'], 'target': TARGET_UNIT_CASTER, }
    },

    -- You have a $m1% chance when you Tiger Palm to cause your next Blackout Kick to cost no Chi within $116768d.
    combo_breaker = {
        id = 137384,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 8.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- Channel Jade lightning, causing $o1 Nature damage over $117952d to the target$?a154436[, generating 1 Chi each time it deals damage,][] and sometimes knocking back melee attackers.
    crackling_jade_lightning = {
        id = 117952,
        cast = 4.0,
        channeled = true,
        cooldown = 0.0,
        gcd = "global",

        spend = 20,
        spendType = 'energy',

        spend = 20,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 1.0, 'ap_bonus': 0.056, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 200.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 200.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mistweaver_monk[137024] #14: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 400.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },

    -- Removes all Magic$?a388874[, Poison, and Disease][] effects from the target.
    detox = {
        id = 115450,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.013,
        spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DISPEL, 'subtype': NONE, 'value': 3, 'schools': ['physical', 'holy'], 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': DISPEL, 'subtype': NONE, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #2: { 'type': DISPEL, 'subtype': NONE, 'points': 100.0, 'value': 1, 'schools': ['physical'], 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },

    -- Reduces magic damage you take by $m1% for $d, and transfers all currently active harmful magical effects on you back to their original caster if possible.
    diffuse_magic = {
        id = 122783,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "none",

        talent = "diffuse_magic",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'sp_bonus': 0.25, 'points': -60.0, 'schools': ['holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mistweaver_monk[428200] #16: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- mistweaver_monk[428200] #17: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'pvp_multiplier': 0.0, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },

    -- Reduces the target's movement speed by $s1% for $d, duration refreshed by your melee attacks.$?s343731[ Targets already snared will be rooted for $116706d instead.][]
    disable = {
        id = 116095,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 15,
        spendType = 'energy',

        spend = 0.007,
        spendType = 'mana',

        spend = 15,
        spendType = 'energy',

        talent = "disable",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DECREASE_SPEED, 'mechanic': snared, 'points': -50.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': PERIODIC_DUMMY, 'tick_time': 1.0, 'mechanic': snared, 'points': 1.0, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- winds_reach[450514] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },

    -- Wraps the target in healing mists, healing for $o1 over $d, and increasing healing received from your other spells by $m2%. $?a388847[; Applies Renewing Mist for $388847s1 seconds to an ally within $388847r yds.][]
    enveloping_mist = {
        id = 124682,
        cast = 2.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.042,
        spendType = 'mana',

        talent = "enveloping_mist",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_HEAL, 'tick_time': 1.0, 'sp_bonus': 0.52, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #2: { 'type': HEAL, 'subtype': NONE, 'sp_bonus': 3.12, 'radius': 60.0, 'target': TARGET_DEST_TARGET_ALLY, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }

        -- Affected by:
        -- mistweaver_monk[137024] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mistweaver_monk[137024] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- soothing_mist[209525] #1: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING, 'target': TARGET_UNIT_CASTER, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enveloping_mist[124682] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- mist_wrap[197900] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- mist_wrap[197900] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- temple_training[442743] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- temple_training[442743] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- thunder_focus_tea[116680] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- enveloping_breath[325209] #2: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'radius': 10.0, 'target': TARGET_DEST_TARGET_ALLY, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- lesson_of_doubt[400097] #0: { 'type': APPLY_AURA, 'subtype': UNKNOWN, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }
        -- strength_of_the_black_ox[443112] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- counteract_magic[353503] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ANY, }
        -- dome_of_mist[205655] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },

    -- Expel negative chi from your body, healing for $s1 and dealing $s2% of the amount healed as Nature damage to an enemy within $115129A1 yards.$?s322102[; Draws in the positive chi of all your Healing Spheres to increase the healing of Expel Harm.][]$?s342928[; Generates ${$s3+$342928s2} Chi.][]
    expel_harm = {
        id = 322101,
        cast = 0.0,
        cooldown = 15.0,
        gcd = "global",

        spend = 15,
        spendType = 'energy',

        spend = 0.014,
        spendType = 'mana',

        spend = 15,
        spendType = 'energy',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': HEAL, 'subtype': NONE, 'sp_bonus': 1.2, 'variance': 0.05, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mistweaver_monk[137024] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.528, 'points': 589.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mistweaver_monk[428200] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- profound_rebuttal[392910] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- vigorous_expulsion[392900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- vigorous_expulsion[392900] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- thunder_focus_tea[116680] #6: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- windwalker_monk[137025] #21: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 75.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #28: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- [120954] Turns your skin to stone for $120954d$?a388917[, increasing your current and maximum health by $<health>%][]$?s322960[, increasing the effectiveness of Stagger by $322960s1%][]$?a388917[, reducing all damage you take by $<damage>%][]$?a451029&$c2[, and Staggering $451029s1% of incoming damage][].
    fortifying_brew = {
        id = 115203,
        cast = 0.0,
        cooldown = 360.0,
        gcd = "none",

        talent = "fortifying_brew",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'pvp_multiplier': 1.5, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mistweaver_monk[428200] #21: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -240000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- expeditious_fortification[388813] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -30000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- ironshell_brew[388814] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- ironshell_brew[388814] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- windwalker_monk[137025] #25: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -240000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- You fire off a rope spear, grappling the target's weapons and shield, returning them to you for $d.
    grapple_weapon = {
        id = 233759,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DISARM, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DISARM_OFFHAND, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_DISARM_RANGED, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Coalesces a Healing Sphere out of the mists at the target location after 1.5 sec. If allies walk through it, they consume the sphere, healing themselves for $115464s1 and dispelling all harmful periodic magic effects.; Maximum of $m1 Healing Spheres can be active by the Monk at any given time.
    healing_sphere = {
        id = 205234,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.019,
        spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_DEST_DEST_GROUND, }
        -- #1: { 'type': UNKNOWN, 'subtype': NONE, 'points': 15.0, }
    },

    -- Summon an effigy of Chi-Ji for $d that kicks up a Gust of Mist when you Blackout Kick, Rising Sun Kick, or Spinning Crane Kick, healing up to $343818s3 allies for $343819s1, and reducing the cost and cast time of your next Enveloping Mist by $343820s1%, stacking.; Chi-Ji's presence makes you immune to movement impairing effects.
    invoke_chiji_the_red_crane = {
        id = 325197,
        cast = 0.0,
        cooldown = 180.0,
        gcd = "global",

        spend = 0.050,
        spendType = 'mana',

        talent = "invoke_chiji_the_red_crane",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': SUMMON, 'subtype': NONE, 'value': 166949, 'schools': ['physical', 'fire', 'shadow'], 'value1': 3733, 'radius': 3.0, 'target': TARGET_DEST_CASTER_LEFT, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- gift_of_the_celestials[388212] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -120000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- gift_of_the_celestials[388212] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -13000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },

    -- Summons an effigy of Yu'lon, the Jade Serpent for $d. Yu'lon will heal injured allies with Soothing Breath, healing the target and up to $s2 allies for $343737o1 over $343737d. ; Enveloping Mist costs $s4% less mana while Yu'lon is active.
    invoke_yulon_the_jade_serpent = {
        id = 322118,
        cast = 0.0,
        cooldown = 180.0,
        gcd = "global",

        spend = 0.050,
        spendType = 'mana',

        talent = "invoke_yulon_the_jade_serpent",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': SUMMON, 'subtype': NONE, 'value': 165374, 'schools': ['holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'value1': 5055, 'radius': 3.0, 'target': TARGET_DEST_CASTER_LEFT, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 2.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': PERIODIC_DUMMY, 'tick_time': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 50.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- gift_of_the_celestials[388212] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -120000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- gift_of_the_celestials[388212] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -13000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },

    -- Strike the ground fiercely to expose a path of jade for $d$?a137025[ that increases your movement speed by $451943s1% while inside][], dealing $388207s1 Nature damage to $?a451573[$s1 enemy][up to $s1 enemies], and restoring $388207s2 health to $?a451573[$s1 ally][up to $s4 allies] within $388207a1 yds caught in the path.$?a137024[]?a137025[ Up to 5 enemies caught in the path][Stagger is $s3% more effective for $347480d against enemies caught in the path.]$?a137023[]?a137024[][ suffer an additional $388201s1 damage.]$?a137024[; Your abilities have a $s2% chance of resetting the cooldown of Jadefire Stomp while fighting within the path.][]
    jadefire_stomp = {
        id = 388193,
        cast = 0.0,
        cooldown = 0.5,
        gcd = "global",

        spend = 0.040,
        spendType = 'mana',

        talent = "jadefire_stomp",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'radius': 0.0, 'target': TARGET_DEST_CASTER, 'target2': TARGET_DEST_DEST_BACK, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 6.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 5.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
    },

    -- Knocks down all enemies within $A1 yards, stunning them for $d.
    leg_sweep = {
        id = 119381,
        cast = 0.0,
        cooldown = 60.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_STUN, 'attributes': ['Area Effects Use Target Radius'], 'mechanic': stunned, 'radius': 6.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- ancient_arts[344359] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- tiger_tail_sweep[264348] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },

    -- Encases the target in a cocoon of Chi energy for $d, absorbing $<newshield> damage and increasing all healing over time received by $m2%.$?a388548[; Applies Renewing Mist and Enveloping Mist to the target.][]
    life_cocoon = {
        id = 116849,
        cast = 0.0,
        cooldown = 0.75,
        gcd = "none",

        spend = 0.024,
        spendType = 'mana',

        talent = "life_cocoon",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': SCHOOL_ABSORB, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': UNKNOWN, 'points': 50.0, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, }
    },

    -- Reduces the mana cost of your spells by $s1% for $d.
    mana_tea = {
        id = 197908,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_POWER_COST_SCHOOL_PCT, 'points': -30.0, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'value1': 1, 'target': TARGET_UNIT_CASTER, }
    },

    -- You perform a Mighty Ox Kick, hurling your enemy a distance behind you.
    mighty_ox_kick = {
        id = 202370,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 30.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Incapacitates the target for $d. Limit 1. Damage will cancel the effect.
    paralysis = {
        id = 115078,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        spend = 20,
        spendType = 'energy',

        spend = 20,
        spendType = 'energy',

        talent = "paralysis",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_STUN, 'points': 1.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': UNKNOWN, 'subtype': NONE, 'points': 60.0, }
        -- #2: { 'type': DISPEL, 'subtype': NONE, 'sp_bonus': 0.25, 'points': 10.0, 'value': 9, 'schools': ['physical', 'nature'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- ancient_arts[344359] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },

    -- Taunts the target to attack you$?s328670[ and causes them to move toward you at $116189m3% increased speed.][.]$?s115315[; This ability can be targeted on your Statue of the Black Ox, causing the same effect on all enemies within  $118635A1 yards of the statue.][]
    provoke = {
        id = 115546,
        cast = 0.0,
        cooldown = 8.0,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ANY, }

        -- Affected by:
        -- hasty_provocation[328670] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
    },

    -- Returns all dead party members to life with $s1% of maximum health and mana. Cannot be cast when in combat.
    reawaken = {
        id = 212051,
        cast = 10.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.008,
        spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': RESURRECT_WITH_AURA, 'subtype': NONE, 'points': 35.0, 'radius': 100.0, 'target': TARGET_CORPSE_SRC_AREA_RAID, }
    },

    -- Surrounds the target with healing mists, restoring $119611o1 health over $119611d.; If Renewing Mist heals a target past maximum health, it will travel to another injured ally within $119607A2 yds.$?a231606[; Each time Renewing Mist heals, it has a $s2% chance to increase the healing of your next Vivify by $197206s1%.][]
    renewing_mist = {
        id = 115151,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.018,
        spendType = 'mana',

        talent = "renewing_mist",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- lotus_infusion[458431] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'pvp_multiplier': 0.34, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- lotus_infusion[458431] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- pool_of_mists[173841] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- thunder_focus_tea[116680] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },

    -- Heals all party and raid members within $A1 yds for $s1 and clears them of all harmful Poison and Disease effects. ; Castable while stunned.; Healing reduced beyond $s5 targets.
    restoral = {
        id = 388615,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "global",

        spend = 0.044,
        spendType = 'mana',

        talent = "restoral",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': HEAL, 'subtype': NONE, 'sp_bonus': 13.018, 'variance': 0.05, 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #1: { 'type': DISPEL, 'subtype': NONE, 'points': 100.0, 'value': 3, 'schools': ['physical', 'holy'], 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #2: { 'type': DISPEL, 'subtype': NONE, 'points': 100.0, 'value': 4, 'schools': ['fire'], 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, }
        -- #4: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
    },

    -- Returns the spirit to the body, restoring a dead target to life with $s1% of maximum health and mana. Cannot be cast when in combat.
    resuscitate = {
        id = 115178,
        cast = 10.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.008,
        spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': RESURRECT, 'subtype': NONE, 'points': 35.0, }
    },

    -- Heals all party and raid members within $A1 yds for $s1 and clears them of $s4 harmful Magic, all Poison, and all Disease effects.; Healing reduced beyond $s5 targets.
    revival = {
        id = 115310,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "global",

        spend = 0.044,
        spendType = 'mana',

        talent = "revival",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': HEAL, 'subtype': NONE, 'sp_bonus': 13.018, 'variance': 0.05, 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #1: { 'type': DISPEL, 'subtype': NONE, 'points': 100.0, 'value': 3, 'schools': ['physical', 'holy'], 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #2: { 'type': DISPEL, 'subtype': NONE, 'points': 100.0, 'value': 4, 'schools': ['fire'], 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #3: { 'type': DISPEL, 'subtype': NONE, 'points': 3.0, 'value': 1, 'schools': ['physical'], 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #4: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mistweaver_monk[137024] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mistweaver_monk[137024] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enveloping_mist[124682] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- enveloping_breath[325209] #2: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'radius': 10.0, 'target': TARGET_DEST_TARGET_ALLY, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- lesson_of_doubt[400097] #0: { 'type': APPLY_AURA, 'subtype': UNKNOWN, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }
        -- counteract_magic[353503] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ANY, }
        -- dome_of_mist[205655] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },

    -- Form a Ring of Peace at the target location for $d. Enemies that enter will be ejected from the Ring.
    ring_of_peace = {
        id = 116844,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        talent = "ring_of_peace",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'radius': 8.0, 'target': TARGET_DEST_DEST, }
        -- #1: { 'type': CREATE_AREATRIGGER, 'subtype': NONE, 'points': 1.0, 'value': 718, 'schools': ['holy', 'fire', 'nature', 'arcane'], 'target': TARGET_DEST_DEST, }

        -- Affected by:
        -- peace_and_prosperity[450448] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },

    -- Kick upwards, dealing $?s137025[${$185099s1*$<CAP>/$AP}][$185099s1] Physical damage$?s128595[, and reducing the effectiveness of healing on the target for $115804d][].$?a388847[; Applies Renewing Mist for $388847s1 seconds to an ally within $388847r yds][]
    rising_sun_kick = {
        id = 107428,
        cast = 0.0,
        cooldown = 10.0,
        gcd = "global",

        spend = 2,
        spendType = 'chi',

        spend = 0.025,
        spendType = 'mana',

        talent = "rising_sun_kick",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 185099, 'points': 1.0, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- mistweaver_monk[137024] #9: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'modifies': COOLDOWN, }
        -- mistweaver_monk[137024] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.62, 'points': 79.0, 'modifies': DAMAGE_HEALING, }
        -- monk[137022] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'target': TARGET_UNIT_CASTER, }
        -- fast_feet[388809] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 70.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- thunder_focus_tea[116680] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': -9000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- august_dynasty[442850] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #25: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 47.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 16.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #14: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Roll a short distance.
    roll = {
        id = 109132,
        cast = 0.0,
        cooldown = 0.8,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- celerity[115173] #1: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- Draws in all nearby clouds of mist generated by Sheilun, healing the target for $s1 per cloud absorbed.
    sheiluns_gift = {
        id = 205406,
        color = 'artifact',
        cast = 2.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': HEAL, 'subtype': NONE, 'sp_bonus': 0.5, 'target': TARGET_UNIT_TARGET_ALLY, }
    },

    -- Draws in all nearby clouds of mist, healing the friendly target and up to ${$s2-1} nearby allies for $s1 per cloud absorbed.; A cloud of mist is generated every $?a400053[$400053s2][$s3] sec while in combat.
    sheiluns_gift_399491 = {
        id = 399491,
        cast = 2.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.025,
        spendType = 'mana',

        talent = "sheiluns_gift_399491",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': HEAL, 'subtype': NONE, 'sp_bonus': 1.2084, 'radius': 40.0, 'target': TARGET_DEST_CASTER, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- legacy_of_wisdom[404408] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- legacy_of_wisdom[404408] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        from = "spec_talent",
    },

    -- Conjures a cloud of hypnotic mist that slowly travels forward. Enemies touched by the mist fall asleep, Disoriented for $198909d.
    song_of_chiji = {
        id = 198898,
        cast = 1.8,
        cooldown = 30.0,
        gcd = "global",

        talent = "song_of_chiji",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': CREATE_AREATRIGGER, 'subtype': NONE, 'attributes': ['Position is facing relative'], 'value': 5484, 'schools': ['fire', 'nature', 'shadow', 'arcane'], 'target': TARGET_DEST_CASTER, }

        -- Affected by:
        -- peace_and_prosperity[450448] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
    },

    -- Heals the target for $o1 over $d.; While channeling, Effuse and Enveloping Mist are instant cast, and will heal the soothed target without breaking the Soothing Mist channel.
    soothing_mist = {
        id = 209525,
        color = 'pvp_talent',
        cast = 20.0,
        channeled = true,
        cooldown = 1.0,
        gcd = "global",

        spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_HEAL, 'amplitude': 1.0, 'tick_time': 0.5, 'sp_bonus': 0.225, 'chain_amp': 100.0, 'chain_targets': 1, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- elusive_mists[388681] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- peer_into_peace[440008] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- brewmaster_monk[137023] #24: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Heals the target for $o1 over $d. While channeling, Enveloping Mist$?s227344[, Surging Mist,][]$?s124081[, Zen Pulse,][] and Vivify may be cast instantly on the target.$?s117907[; Each heal has a chance to cause a Gust of Mists on the target.][]$?s388477[; Soothing Mist heals a second injured ally within $388478A2 yds for $388477s1% of the amount healed.][]
    soothing_mist_115175 = {
        id = 115175,
        cast = 8.0,
        channeled = true,
        cooldown = 0.0,
        gcd = "global",

        spendType = 'mana',

        spendType = 'energy',

        spendType = 'energy',

        talent = "soothing_mist_115175",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_HEAL, 'amplitude': 1.0, 'tick_time': 1.0, 'sp_bonus': 1.4, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- mistweaver_monk[137024] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mistweaver_monk[137024] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- elusive_mists[388681] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- enveloping_mist[124682] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- peer_into_peace[440008] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #24: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- enveloping_breath[325209] #2: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'radius': 10.0, 'target': TARGET_DEST_TARGET_ALLY, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- lesson_of_doubt[400097] #0: { 'type': APPLY_AURA, 'subtype': UNKNOWN, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }
        -- counteract_magic[353503] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ANY, }
        -- dome_of_mist[205655] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        from = "class_talent",
    },

    -- Jabs the target in the throat, interrupting spellcasting and preventing any spell from that school of magic from being cast for $d.
    spear_hand_strike = {
        id = 116705,
        cast = 0.0,
        cooldown = 15.0,
        gcd = "none",

        talent = "spear_hand_strike",
        startsCombat = true,
        interrupt = true,

        -- Effects:
        -- #0: { 'type': INTERRUPT_CAST, 'subtype': NONE, 'mechanic': interrupted, 'points': 1.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Spin while kicking in the air, dealing $?s137025[${4*$107270s1*$<CAP>/$AP}][${4*$107270s1}] Physical damage over $d to all enemies within $107270A1 yds. Deals reduced damage beyond $s1 targets.$?a220357[; Spinning Crane Kick's damage is increased by $220358s1% for each unique target you've struck in the last $220358d with Tiger Palm, Blackout Kick, or Rising Sun Kick. Stacks up to $228287i times.][]
    spinning_crane_kick = {
        id = 101546,
        cast = 1.5,
        channeled = true,
        cooldown = 0.0,
        gcd = "global",

        spend = 2,
        spendType = 'chi',

        spend = 0.010,
        spendType = 'mana',

        spend = 40,
        spendType = 'energy',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_TRIGGER_SPELL, 'tick_time': 0.5, 'trigger_spell': 107270, 'points': 5.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 15.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- mistweaver_monk[137024] #6: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'target': TARGET_UNIT_CASTER, }
        -- fast_feet[388809] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #21: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 11.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },

    -- Summons a Jade Serpent Statue at the target location. When you channel Soothing Mist, the statue will also begin to channel Soothing Mist on your target, healing for $198533o1 over $198533d.
    summon_jade_serpent_statue = {
        id = 115313,
        cast = 0.0,
        cooldown = 10.0,
        gcd = "global",

        talent = "summon_jade_serpent_statue",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': SUMMON, 'subtype': NONE, 'points': 1.0, 'value': 60849, 'schools': ['physical', 'frost', 'shadow'], 'value1': 3216, 'target': TARGET_DEST_DEST, }
    },

    -- Strike with the palm of your hand, dealing $s1 Physical damage.$?a137384[; Tiger Palm has an $137384m1% chance to make your next Blackout Kick cost no Chi.][]$?a137023[; Reduces the remaining cooldown on your Brews by $s3 sec.][]$?a137025[; Generates $s2 Chi.][]
    tiger_palm = {
        id = 100780,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 50,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.27027, 'pvp_multiplier': 1.3, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': chi, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- mistweaver_monk[137024] #6: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'target': TARGET_UNIT_CASTER, }
        -- mistweaver_monk[137024] #12: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.343, 'points': 245.0, 'modifies': DAMAGE_HEALING, }
        -- mistweaver_monk[137024] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- xuens_guidance[442687] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 139.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #16: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- windwalker_monk[137025] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- windwalker_monk[137025] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- windwalker_monk[137025] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 16.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 125.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #13: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 26.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk[137025] #27: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Increases a friendly target's movement speed by $s1% for $d and removes all roots and snares.
    tigers_lust = {
        id = 116841,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "global",

        talent = "tigers_lust",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_INCREASE_SPEED, 'points': 70.0, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },

    -- You exploit the enemy target's weakest point, instantly killing $?s322113[creatures if they have less health than you.][them.; Only usable on creatures that have less health than you]$?s322113[ Deals damage equal to $s3% of your maximum health against players and stronger creatures under $s2% health.][.]$?s325095[; Reduces delayed Stagger damage by $325095s1% of damage dealt.]?s325215[; Spawns $325215s1 Chi Spheres, granting 1 Chi when you walk through them.]?s344360[; Increases the Monk's Physical damage by $344361s1% for $344361d.][]
    touch_of_death = {
        id = 322109,
        cast = 0.0,
        cooldown = 180.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'chain_targets': 1, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- fatal_touch[394123] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -90000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- Instantly kills any creature under level $m2, or player under $m3% health.
    touch_of_fatality = {
        id = 169340,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': INSTAKILL, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Split your body and spirit, leaving your spirit behind for $d. Use Transcendence: Transfer to swap locations with your spirit.
    transcendence = {
        id = 101643,
        cast = 0.0,
        cooldown = 10.0,
        gcd = "global",

        talent = "transcendence",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': SUMMON, 'subtype': NONE, 'value': 54569, 'schools': ['physical', 'nature', 'shadow'], 'value1': 3234, 'target': TARGET_DEST_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk[137025] #11: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
    },

    -- Split your body and spirit, tethering your spirit onto an ally for $d. Use Transcendence: Transfer to teleport to your ally's location.
    transcendence_434763 = {
        id = 434763,
        cast = 0.0,
        cooldown = 10.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_TARGET_RAID, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 434767, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 434782, 'target': TARGET_UNIT_TARGET_RAID, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        from = "from_description",
    },

    -- [434763] Split your body and spirit, tethering your spirit onto an ally for $d. Use Transcendence: Transfer to teleport to your ally's location.
    transcendence_434767 = {
        id = 434767,
        cast = 0.0,
        cooldown = 15.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
        from = "triggered_spell",
    },

    -- Transcendence now tethers your spirit onto an ally for $434763d. Use Transcendence: Transfer to teleport to your ally's location.
    transcendence_linked_spirits = {
        id = 434774,
        cast = 0.0,
        cooldown = 10.0,
        gcd = "global",

        talent = "transcendence_linked_spirits",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mistweaver_monk[137024] #5: { 'type': APPLY_AURA, 'subtype': MOD_GLOBAL_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'value': 917504, 'target': TARGET_UNIT_CASTER, }
    },

    -- Causes a surge of invigorating mists, healing the target for $<healing>$?s274586[ and all allies with your Renewing Mist active for $425804s1, reduced beyond $274586s1 allies][].
    vivify = {
        id = 116670,
        cast = 1.5,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.030,
        spendType = 'mana',

        spend = 30,
        spendType = 'energy',

        spend = 30,
        spendType = 'energy',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': HEAL, 'subtype': NONE, 'sp_bonus': 2.58, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- mistweaver_monk[137024] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mistweaver_monk[137024] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- mistweaver_monk[137024] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enveloping_mist[124682] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- temple_training[442743] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- temple_training[442743] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- thunder_focus_tea[116680] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- vivacious_vivification[392883] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -1500.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- vivacious_vivification[392883] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- vivacious_vivification[392883] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -75.0, 'target': TARGET_UNIT_CASTER, 'modifies': IGNORE_SHAPESHIFT, }
        -- vivacious_vivification[392883] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -75.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- august_dynasty[442850] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- escape_from_reality[343249] #2: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 70.0, 'target': TARGET_UNIT_CASTER, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 92.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enveloping_breath[325209] #2: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'radius': 10.0, 'target': TARGET_DEST_TARGET_ALLY, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- windwalker_monk[137025] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.34, 'points': 150.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- lesson_of_doubt[400097] #0: { 'type': APPLY_AURA, 'subtype': UNKNOWN, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }
        -- counteract_magic[353503] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ANY, }
        -- dome_of_mist[205655] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },

    -- You fly through the air at a quick speed on a meditative cloud.
    zen_flight = {
        id = 125883,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': FLY, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_INCREASE_VEHICLE_FLIGHT_SPEED, 'points': 60.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_NO_ACTIONS, 'target': TARGET_UNIT_CASTER, }
    },

    -- Provides immunity to Silence and Interrupt effects for $d.
    zen_focus_tea = {
        id = 209584,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 30.0,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 26, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 9, }
    },

    -- Your spirit travels to your home temple, leaving your body behind. ; Use Zen Pilgrimage again to return back to near your departure point.
    zen_pilgrimage = {
        id = 126892,
        cast = 10.0,
        cooldown = 60.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': TELEPORT_UNITS, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'target2': TARGET_DEST_DB, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'value': 1000, 'schools': ['nature', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_CRIT_CHANCE_SCHOOL, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': OVERRIDE_ACTIONBAR_SPELLS, 'spell': 293866, 'value': 126892, 'schools': ['fire', 'nature', 'shadow'], 'target': TARGET_UNIT_CASTER, }
    },

    -- $?a200617[Returns your spirit back to its body, returning you near to where you once were.; Leaving the Wandering Isle will cancel Zen Pilgrimage: Return.]; [Returns your spirit back to its body, returning you near to where you once were.; Leaving Peak of Serenity will cancel Zen Pilgrimage: Return.]
    zen_pilgrimage_return = {
        id = 126895,
        cast = 10.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': SCRIPT_EFFECT, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- [124081] $@spelldesc446326
    zen_pulse = {
        id = 198487,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': HEAL, 'subtype': NONE, 'sp_bonus': 1.6, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- mistweaver_monk[137024] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mistweaver_monk[137024] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- enveloping_mist[124682] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- enveloping_breath[325209] #2: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'radius': 10.0, 'target': TARGET_DEST_TARGET_ALLY, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- lesson_of_doubt[400097] #0: { 'type': APPLY_AURA, 'subtype': UNKNOWN, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }
        -- counteract_magic[353503] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ANY, }
        -- dome_of_mist[205655] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },

    -- Forms a sphere of Hope or Despair above the target. Only one of each sphere can be active at a time.; $@spellicon411036 $@spellname411036: Increases your healing done to the target by $411036s1%.; $@spellicon411038 $@spellname411038: Target deals $411038s1% less damage to you, and takes $411038s2% increased damage from all sources.; 
    zen_spheres = {
        id = 410777,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.005,
        spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ANY, }
    },

} )