-- MonkBrewmaster.lua
-- July 2024

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 268 )

-- Resources
spec:RegisterResource( Enum.PowerType.Energy )
spec:RegisterResource( Enum.PowerType.Mana )
spec:RegisterResource( Enum.PowerType.Chi )

spec:RegisterTalents( {
    -- Monk Talents
    ancient_arts                        = { 101184, 344359, 2 }, -- Reduces the cooldown of Paralysis by ${$abs($s0/1000)} sec and the cooldown of Leg Sweep by ${$s2/-1000} sec.
    bounce_back                         = { 101177, 389577, 1 }, -- When a hit deals more than $m2% of your maximum health, reduce all damage you take by $s1% for $390239d.; This effect cannot occur more than once every $m3 seconds.
    bounding_agility                    = { 101161, 450520, 1 }, -- Roll and Chi Torpedo travel a small distance further.
    calming_presence                    = { 101153, 388664, 1 }, -- Reduces all damage taken by $s1%.
    celerity                            = { 101183, 115173, 1 }, -- Reduces the cooldown of Roll by ${$m1/-1000} sec and increases its maximum number of charges by $m2.
    celestial_determination             = { 101180, 450638, 1 }, -- While your Celestial is active, you cannot be slowed below $s2% normal movement speed.
    chi_proficiency                     = { 101169, 450426, 2 }, -- Magical damage done increased by $s1% and healing done increased by $s2%.
    chi_torpedo                         = { 101183, 115008, 1 }, -- Torpedoes you forward a long distance and increases your movement speed by $119085m1% for $119085d, stacking up to 2 times.
    clash                               = { 101154, 324312, 1 }, -- You and the target charge each other, meeting halfway then rooting all targets within $128846A1 yards for $128846d.
    crashing_momentum                   = { 101149, 450335, 1 }, -- Targets you Roll through are snared by $450342s1% for $450342d.
    diffuse_magic                       = { 101165, 122783, 1 }, -- Reduces magic damage you take by $m1% for $d, and transfers all currently active harmful magical effects on you back to their original caster if possible.
    disable                             = { 101149, 116095, 1 }, -- Reduces the target's movement speed by $s1% for $d, duration refreshed by your melee attacks.$?s343731[ Targets already snared will be rooted for $116706d instead.][]
    elusive_mists                       = { 101144, 388681, 1 }, -- Reduces all damage taken by you and your target while channeling Soothing Mists by $s1%.
    energy_transfer                     = { 101151, 450631, 1 }, -- Successfully interrupting an enemy reduces the cooldown of Paralysis and Roll by ${$s1/-1000} sec.
    escape_from_reality                 = { 101176, 394110, 1 }, -- After you use Transcendence: Transfer, you can use Transcendence: Transfer again within $343249d, ignoring its cooldown.
    expeditious_fortification           = { 101174, 388813, 1 }, -- Fortifying Brew cooldown reduced by ${$s1/-1000} sec.
    fast_feet                           = { 101185, 388809, 1 }, -- Rising Sun Kick deals $s1% increased damage. Spinning Crane Kick deals $s2% additional damage.; 
    fatal_touch                         = { 101178, 394123, 1 }, -- Touch of Death increases your damage by $450832s1% for $450832d after being cast and its cooldown is reduced by ${$s1/-1000} sec.
    ferocity_of_xuen                    = { 101166, 388674, 1 }, -- Increases all damage dealt by $s1%.
    flow_of_chi                         = { 101170, 450569, 1 }, -- You gain a bonus effect based on your current health.; Above $s1% health: Movement speed increased by $450574s1%. This bonus stacks with similar effects.; Between $s1% and $s2% health: Damage taken reduced by $450572s1%.; Below $s2% health: Healing received increased by $450571s1%. 
    fortifying_brew                     = { 101173, 115203, 1 }, -- Turns your skin to stone for $120954d, increasing your current and maximum health by $<health>% and reducing all damage you take by $<damage>%.; Combines with other Fortifying Brew effects.
    grace_of_the_crane                  = { 101146, 388811, 1 }, -- Increases all healing taken by $s1%.
    hasty_provocation                   = { 101158, 328670, 1 }, -- Provoked targets move towards you at $s1% increased speed.
    healing_winds                       = { 101171, 450560, 1 }, -- Transcendence: Transfer immediately heals you for $450559s1% of your maximum health.
    improved_touch_of_death             = { 101140, 322113, 1 }, -- Touch of Death can now be used on targets with less than $s1% health remaining, dealing $s2% of your maximum health in damage.
    ironshell_brew                      = { 101174, 388814, 1 }, -- Increases your maximum health by an additional $s1% and your damage taken is reduced by an additional $s2% while Fortifying Brew is active.
    jade_walk                           = { 101160, 450553, 1 }, -- While out of combat, your movement speed is increased by $450552s1%.
    lighter_than_air                    = { 101168, 449582, 1 }, -- Roll causes you to become lighter than air, allowing you to double jump to dash forward a short distance once within $449609d, but the cooldown of Roll is increased by ${$s1/1000} sec.
    martial_instincts                   = { 101179, 450427, 2 }, -- Increases your Physical damage done by $s1% and Avoidance increased by $s2%.
    paralysis                           = { 101142, 115078, 1 }, -- Incapacitates the target for $d. Limit 1. Damage will cancel the effect.
    peace_and_prosperity                = { 101163, 450448, 1 }, -- Reduces the cooldown of Ring of Peace by ${$s1/-1000} sec and Song of Chi-Ji's cast time is reduced by ${$s2/-1000}.1 sec.
    pressure_points                     = { 101141, 450432, 1 }, -- Paralysis now removes all Enrage effects from its target.
    profound_rebuttal                   = { 101135, 392910, 1 }, -- Expel Harm's critical healing is increased by $s1%.
    quick_footed                        = { 101158, 450503, 1 }, -- The duration of snare effects on you is reduced by $s1%.
    ring_of_peace                       = { 101136, 116844, 1 }, -- Form a Ring of Peace at the target location for $d. Enemies that enter will be ejected from the Ring.
    rising_sun_kick                     = { 101186, 107428, 1 }, -- Kick upwards, dealing $?s137025[${$185099s1*$<CAP>/$AP}][$185099s1] Physical damage$?s128595[, and reducing the effectiveness of healing on the target for $115804d][].$?a388847[; Applies Renewing Mist for $388847s1 seconds to an ally within $388847r yds][]
    rushing_reflexes                    = { 101154, 450154, 1 }, -- Your heightened reflexes allow you to react swiftly to the presence of enemies, causing you to quickly lunge to the nearest enemy in front of you within $450156r yards after you Roll.
    save_them_all                       = { 101157, 389579, 1 }, -- When your healing spells heal an ally whose health is below $s3% maximum health, you gain an additional $s1% healing for the next $390105d.
    song_of_chiji                       = { 101136, 198898, 1 }, -- Conjures a cloud of hypnotic mist that slowly travels forward. Enemies touched by the mist fall asleep, Disoriented for $198909d.
    soothing_mist                       = { 101143, 115175, 1 }, -- Heals the target for $o1 over $d. While channeling, Enveloping Mist$?s227344[, Surging Mist,][]$?s124081[, Zen Pulse,][] and Vivify may be cast instantly on the target.$?s117907[; Each heal has a chance to cause a Gust of Mists on the target.][]$?s388477[; Soothing Mist heals a second injured ally within $388478A2 yds for $388477s1% of the amount healed.][]
    spear_hand_strike                   = { 101152, 116705, 1 }, -- Jabs the target in the throat, interrupting spellcasting and preventing any spell from that school of magic from being cast for $d.
    spirits_essence                     = { 101138, 450595, 1 }, -- Transcendence: Transfer snares targets within $450596A2 yds by $450596s1% for $450596d when cast.
    strength_of_spirit                  = { 101135, 387276, 1 }, -- Expel Harm's healing is increased by up to $s1%, based on your missing health.
    swift_art                           = { 101155, 450622, 1 }, -- Roll removes a snare effect once every $proccooldown sec.
    tiger_tail_sweep                    = { 101182, 264348, 1 }, -- Increases the range of Leg Sweep by $s1 yds.
    tigers_lust                         = { 101147, 116841, 1 }, -- Increases a friendly target's movement speed by $s1% for $d and removes all roots and snares.
    transcendence                       = { 101167, 101643, 1 }, -- Split your body and spirit, leaving your spirit behind for $d. Use Transcendence: Transfer to swap locations with your spirit.
    transcendence_linked_spirits        = { 101176, 434774, 1 }, -- Transcendence now tethers your spirit onto an ally for $434763d. Use Transcendence: Transfer to teleport to your ally's location.
    vigorous_expulsion                  = { 101156, 392900, 1 }, -- Expel Harm's healing increased by $s1% and critical strike chance increased by $s2%. 
    vivacious_vivification              = { 101145, 388812, 1 }, -- Every $t1 sec, your next Vivify becomes instant and its healing is increased by $392883s2%.$?c1[; This effect also reduces the energy cost of Vivify by $392883s3%.]?c3[; This effect also reduces the energy cost of Vivify by $392883s3%.][]; 
    winds_reach                         = { 101148, 450514, 1 }, -- The range of Disable is increased by $s1 yds.;  ; The duration of Crashing Momentum is increased by ${$s3/1000} sec and its snare now reduces movement speed by an additional $s2%.
    windwalking                         = { 101175, 157411, 1 }, -- You and your allies within $m2 yards have $s1% increased movement speed. Stacks with other similar effects.
    yulons_grace                        = { 101165, 414131, 1 }, -- Find resilience in the flow of chi in battle, gaining a magic absorb shield for ${$s1/10}.1% of your max health every $t sec in combat, stacking up to $s2%.

    -- Brewmaster Talents
    against_all_odds                    = { 101253, 450986, 1 }, -- Flurry Strikes increase your Agility by $451061s1% for $451061d, stacking up to $451061u times.
    anvil_stave                         = { 101081, 386937, 2 }, -- Each time you dodge or an enemy misses you, the remaining cooldown on your Brews is reduced by ${$s1/10}.1 sec. Effect reduced for each recent melee attacker.
    aspect_of_harmony                   = { 101223, 450508, 1 }, -- Store vitality from $?a137023[$s1%][$s2%] of your damage dealt and $?a137023[$s3%][$s4%] of your $?a137023[effective ][]healing.$?a137024[ Vitality stored from overhealing is reduced.][]; For $450711d after casting $?a137023[Celestial Brew][Thunder Focus Tea] your spells and abilities draw upon the stored vitality to deal $s6% additional $?a137023[damage over $450763d][healing over $450769d].
    august_blessing                     = { 101084, 454483, 1 }, -- When you would be healed above maximum health, you instead convert an amount equal to $s1% of your critical strike chance to a heal over time effect.
    balanced_stratagem                  = { 101230, 450889, 1 }, -- Casting a Physical spell or ability increases the damage and healing of your next Fire or Nature spell or ability by 5%, and vice versa. Stacks up to 5.
    black_ox_adept                      = { 101198, 455079, 1 }, -- Rising Sun Kick grants a charge of Ox Stance.
    black_ox_brew                       = { 101190, 115399, 1 }, -- Chug some Black Ox Brew, which instantly refills your Energy, Purifying Brew charges, and resets the cooldown of Celestial Brew.
    blackout_combo                      = { 101195, 196736, 1 }, -- Blackout Kick also empowers your next ability:; Tiger Palm: Damage increased by $s1%.; Breath of Fire: Damage increased by $228563s5%, and damage reduction increased by $228563s2%.; Keg Smash: Reduces the remaining cooldown on your Brews by $s3 additional sec.; Celestial Brew: Gain up to $s6 additional stacks of Purified Chi.; Purifying Brew: Pauses Stagger damage for $s4 sec.
    bob_and_weave                       = { 101190, 280515, 1 }, -- Increases the duration of Stagger by ${$s1/10}.1 sec.
    breath_of_fire                      = { 101069, 115181, 1 }, -- Breathe fire on targets in front of you, causing $s1 Fire damage. Deals reduced damage to secondary targets.; Targets affected by Keg Smash will also burn, taking $123725o1 Fire damage and dealing $123725s2% reduced damage to you for $123725d.
    call_to_arms                        = { 101192, 397251, 1 }, -- Weapons of Order calls forth $?c1[Niuzao, the Black Ox]?c2&s325197[Chi-Ji, the Red Crane]?c3[Xuen, the White Tiger][Yu'lon, the Jade Serpent] to assist you for ${$s1/1000} sec.; Triggering a bonus attack with Press the Advantage has a chance to call forth Niuzao, the Black Ox.
    celestial_brew                      = { 101067, 322507, 1 }, -- A swig of strong brew that coalesces purified chi escaping your body into a celestial guard, absorbing $<absorb> damage.; Purifying Stagger damage increases absorption by up to $322510s1%.
    celestial_flames                    = { 101070, 325177, 1 }, -- Drinking from Brews has a $h% chance to coat the Monk with Celestial Flames for $325190d.; While Celestial Flames is active, Spinning Crane Kick applies Breath of Fire and Breath of Fire reduces the damage affected enemies deal to you by an additional $s2%.; 
    charred_passions                    = { 101187, 386965, 1 }, -- Your Breath of Fire ignites your right leg in flame for $386963d, causing your Blackout Kick and Spinning Crane Kick to deal $s1% additional damage as Fire damage and refresh the duration of your Breath of Fire on the target.
    chi_burst                           = { 102433, 123986, 1 }, -- Hurls a torrent of Chi energy up to $460485s1 yds forward, dealing $148135s1 Nature damage to all enemies, and $130654s1 healing to the Monk and all allies in its path. Healing and damage reduced beyond $s1 targets.; $?c1[; Casting Chi Burst does not prevent avoiding attacks.][]
    chi_surge                           = { 101712, 393400, 1 }, -- Triggering a bonus attack from Press the Advantage or casting Weapons of Order releases a surge of chi at your target's location, dealing Nature damage split evenly between all targets over $393786d.; $@spellicon418359 $@spellname418359:; Deals $<ptadmg> Nature damage.; $@spellicon387184 $@spellname387184:; Deals $<dmg> Nature damage and reduces the cooldown of Weapons of Order by $s1 for each affected enemy, to a maximum of ${$s1*5} sec.
    chi_wave                            = { 102433, 450391, 1 }, -- Every $t1 sec, your next Rising Sun Kick or Vivify releases a wave of Chi energy that flows through friends and foes, dealing $132467s1 Nature damage or $132463s1 healing. Bounces up to $115098s1 times to targets within $132466a2 yards.
    clarity_of_purpose                  = { 101228, 451017, 1 }, -- Casting $?a137023[Purifying Brew][Vivify] stores $<value> vitality, increased based on $?a137023[Stagger level][your recent Gusts of Mist].
    coalescence                         = { 101227, 450529, 1 }, -- When Aspect of Harmony $?a450870[deals damage or heals]?a137023[deals damage][heals], it has a chance to spread to a nearby $?a450870[target]?a137023[enemy][ally]. When you directly $?a450870[attack or heal]?a137023[attack][heal] an affected target, it has a chance to intensify.; Targets damaged or healed by your Aspect of Harmony take $s2% increased damage or healing from you.
    counterstrike                       = { 101080, 383785, 1 }, -- Each time you dodge or an enemy misses you, your next Tiger Palm or Spinning Crane Kick deals $383800s1% increased damage.
    dampen_harm                         = { 101181, 122278, 1 }, -- Reduces all damage you take by $m2% to $m3% for $d, with larger attacks being reduced by more.
    dance_of_the_wind                   = { 101181, 414132, 1 }, -- Your dodge chance is increased by $s1%.
    detox                               = { 101090, 218164, 1 }, -- Removes all Poison and Disease effects from the target.
    dragonfire_brew                     = { 101187, 383994, 1 }, -- After using Breath of Fire, you breathe fire $s1 additional times, each dealing $387621s1 Fire damage.; Breath of Fire damage increased by up to $s2% based on your level of Stagger.
    efficient_training                  = { 101251, 450989, 1 }, -- Energy spenders deal an additional $s1% damage.; Every $s3 Energy spent reduces the cooldown of $?c1[Weapons of Order][Storm, Earth, and Fire] by ${$s4/1000} sec.
    elixir_of_determination             = { 101085, 455139, 1 }, -- When you fall below $s1% health, you gain an absorb for $s2% of your recently Purified damage, or a minimum of $s3% of your maximum health. Cannot occur more than once every $455180d.
    elusive_footwork                    = { 101194, 387046, 1 }, -- Blackout Kick deals an additional $s3% damage. Blackout Kick critical hits grant an additional $m2 $Lstack:stacks; of Elusive Brawler.
    endless_draught                     = { 101225, 450892, 1 }, -- $?a137023[Celestial Brew][Thunder Focus Tea] has $s1 additional charge.
    exploding_keg                       = { 101197, 325153, 1 }, -- Hurls a flaming keg at the target location, dealing $s1 Fire damage to nearby enemies, causing your attacks against them to deal $388867s1 additional Fire damage, and causing their melee attacks to deal $s2% reduced damage for the next $d.
    face_palm                           = { 101079, 389942, 1 }, -- Tiger Palm has a $s1% chance to deal $s2% of normal damage and reduce the remaining cooldown of your Brews by ${$s3/1000} additional sec.
    fluidity_of_motion                  = { 101078, 387230, 1 }, -- Blackout Kick's cooldown is reduced by ${-$s1/1000} sec and its damage is reduced by $s2%.
    flurry_strikes                      = { 101248, 450615, 1 }, -- Every $<value> damage you deal generates a Flurry Charge. For each $s2 energy you spend, unleash all Flurry Charges, dealing $450617s1 Physical damage per charge. 
    fortifying_brew_determination       = { 101068, 322960, 1 }, -- Fortifying Brew increases Stagger effectiveness by $s1% while active.; Combines with other Fortifying Brew effects.
    gai_plins_imperial_brew             = { 102004, 383700, 1 }, -- Purifying Brew instantly heals you for $s1% of the purified Stagger damage.
    gift_of_the_ox                      = { 101072, 124502, 1 }, -- [224863] Summon a Healing Sphere visible only to you. Moving through this Healing Sphere heals you for $124507s1.
    harmonic_gambit                     = { 101224, 450870, 1 }, -- During Aspect of Harmony, $?a137023[Expel Harm and Vivify withdraw vitality to heal][Rising Sun Kick, Blackout Kick, and Tiger Palm also withdraw vitality to damage enemies].
    heightened_guard                    = { 101711, 455081, 1 }, -- Ox Stance will now trigger when an attack is larger than ${$455068s2+$s1}% of your current health.
    high_impact                         = { 101247, 450982, 1 }, -- Enemies who die within $451037d of being damaged by a Flurry Strike explode, dealing $451039s1 physical damage to uncontrolled enemies within $451039a1 yds.
    high_tolerance                      = { 101189, 196737, 2 }, -- Stagger is $s1% more effective at delaying damage.; You gain up to $s4% Haste based on your current level of Stagger.
    hit_scheme                          = { 101071, 383695, 1 }, -- Dealing damage with Blackout Kick increases the damage of your next Keg Smash by $383696s1%, stacking up to $383696u times.
    improved_invoke_niuzao_the_black_ox = { 101073, 322740, 1 }, -- While Niuzao is active, Purifying Brew increases the damage of Niuzao's next Stomp, based on Stagger level.
    invoke_niuzao_the_black_ox          = { 101075, 132578, 1 }, -- Summons an effigy of Niuzao, the Black Ox for $d. Niuzao attacks your primary target, and frequently Stomps, damaging all nearby enemies$?s322740[ for $227291s1 plus $322740s1% of Stagger damage you have recently purified.][.]; While active, $s2% of damage delayed by Stagger is instead Staggered by Niuzao.
    keg_smash                           = { 101088, 121253, 1 }, -- Smash a keg of brew on the target, dealing $s2 Physical damage to all enemies within $A2 yds and reducing their movement speed by $m3% for $d. Deals reduced damage beyond $s7 targets.$?a322120[; Grants Shuffle for $s6 sec and reduces the remaining cooldown on your Brews by $s4 sec.][]
    lead_from_the_front                 = { 101254, 450985, 1 }, -- Chi Burst, Chi Wave, and Expel Harm now heal you for $s1% of damage dealt.
    light_brewing                       = { 101082, 325093, 1 }, -- Reduces the cooldown of Purifying Brew and Celestial Brew by $s1%.
    manifestation                       = { 101222, 450875, 1 }, -- Chi Burst and Chi Wave deal $s1% increased damage and healing.
    mantra_of_purity                    = { 101229, 451036, 1 }, -- $?a137023[Purifying Brew removes $s1% additional Stagger and causes you to absorb up to $<value> incoming Stagger][When cast on yourself, your single-target healing spells heal for $s2% more and restore an additional $451452o1 health over $451452d].
    mantra_of_tenacity                  = { 101229, 451029, 1 }, -- $?a137023[Fortifying Brew applies a Chi Cocoon][Fortifying Brew grants $s1% Stagger].
    martial_precision                   = { 101246, 450990, 1 }, -- Your attacks penetrate $s1% armor.
    one_versus_many                     = { 101250, 450988, 1 }, -- Damage dealt by Fists of Fury and Keg Smash counts as double towards Flurry Charge generation.; Fists of Fury damage increased by $s2%.; Keg Smash damage increased by $s3%.
    one_with_the_wind                   = { 101710, 454484, 1 }, -- You have a $s1% chance to not reset your Elusive Brawler stacks after a successful dodge.
    overwhelming_force                  = { 101220, 451024, 1 }, -- Rising Sun Kick, Blackout Kick, and Tiger Palm deal $s1% additional damage to enemies in a line in front of you. Damage reduced above $s2 targets.
    ox_stance                           = { 101199, 455068, 1 }, -- Casting Purifying Brew grants a charge of Ox Stance, increased based on Stagger level. When you take damage that is greater than $s1% of your current health, a charge is consumed to increase the amount you Stagger.
    path_of_resurgence                  = { 101226, 450912, 1 }, -- $?a450391[Chi Wave][Chi Burst] increases vitality stored by $451084s1% for $451084d.
    predictive_training                 = { 101245, 450992, 1 }, -- When you dodge or parry an attack, reduce all damage taken by $451230s1% for the next $451230d.
    press_the_advantage                 = { 101193, 418359, 1 }, -- Your main hand auto attacks reduce the cooldown on your brews by ${$s2/1000}.1 sec and block your target's chi, dealing $418360s1 additional Nature damage and increasing your damage dealt by $418361s1% for $418361d. ; Upon reaching $418361u stacks, your next cast of Rising Sun Kick or Keg Smash consumes all stacks to strike again at $418361s2% effectiveness. This bonus attack can trigger effects on behalf of Tiger Palm at reduced effectiveness.
    pretense_of_instability             = { 101077, 393516, 1 }, -- Activating Purifying Brew or Celestial Brew grants you $393515s1% dodge for $393515d.
    pride_of_pandaria                   = { 101247, 450979, 1 }, -- Flurry Strikes have $s1% additional chance to critically strike.
    protect_and_serve                   = { 101254, 450984, 1 }, -- Your Vivify always heals you for an additional $s1% of its total value.
    purified_spirit                     = { 101224, 450867, 1 }, -- When Aspect of Harmony ends, any remaining vitality is expelled as $?a137023[damage over $450820d][healing over $450805d], split among nearby targets.
    purifying_brew                      = { 101064, 119582, 1 }, -- Clears $s1% of your damage delayed with Stagger.$?s322510[; Increases the absorption of your next Celestial Brew by up to $322510s1%, based on your current level of Stagger][]$?s383700[; Instantly heals you for $383700s1% of the damage cleared.][]
    quick_sip                           = { 101063, 388505, 1 }, -- Purify $s1% of your Staggered damage each time you gain $s2 sec of Shuffle duration.
    roar_from_the_heavens               = { 101221, 451043, 1 }, -- Tiger's Lust grants $452701s1% movement speed to up to $452701i allies near its target.
    rushing_jade_wind                   = { 101202, 116847, 1 }, -- Summons a whirling tornado around you, causing ${(1+$d/$t1)*$148187s1} Physical damage over $d to all enemies within $107270A1 yards. Deals reduced damage beyond $s1 targets.
    salsalabims_strength                = { 101188, 383697, 1 }, -- When you use Keg Smash, the remaining cooldown on Breath of Fire is reset.
    scalding_brew                       = { 101188, 383698, 1 }, -- Keg Smash deals an additional $s1% damage to targets affected by Breath of Fire.
    shadowboxing_treads                 = { 101078, 387638, 1 }, -- Blackout Kick's damage increased by $s2% and it strikes an additional $s1 $ltarget;targets.
    shuffle                             = { 101087, 322120, 1 }, -- Niuzao's teachings allow you to shuffle during combat, increasing the effectiveness of your Stagger by $215479s3%.; Shuffle is granted by attacking enemies with your Keg Smash, Blackout Kick, and Spinning Crane Kick.
    special_delivery                    = { 101202, 196730, 1 }, -- Drinking from your Brews has a $h% chance to toss a keg high into the air that lands nearby after $s1 sec, dealing $196733s1 damage to all enemies within $196733A1 yards and reducing their movement speed by $196733m2% for $196733d.
    spirit_of_the_ox                    = { 101086, 400629, 1 }, -- [224863] Summon a Healing Sphere visible only to you. Moving through this Healing Sphere heals you for $124507s1.
    staggering_strikes                  = { 101065, 387625, 1 }, -- When you Blackout Kick, your Stagger is reduced by $<reduc>.
    stormstouts_last_keg                = { 101196, 383707, 1 }, -- Keg Smash deals $m1% additional damage, and has $m2 additional $?m2>1[charge][charges].
    strike_at_dawn                      = { 101076, 455043, 1 }, -- Rising Sun Kick grants a stack of Elusive Brawler.
    summon_black_ox_statue              = { 101172, 115315, 1 }, -- Summons a Black Ox Statue at the target location for $d, pulsing threat to all enemies within $163178A1 yards.; You may cast Provoke on the statue to taunt all enemies near the statue.
    tigers_vigor                        = { 101221, 451041, 1 }, -- Casting Tiger's Lust reduces the remaining cooldown on Roll by ${$s1/1000} sec.
    training_of_niuzao                  = { 101082, 383714, 1 }, -- Gain up to ${$s1*$s3}% Mastery based on your current level of Stagger.
    tranquil_spirit                     = { 101083, 393357, 1 }, -- When you consume a Healing Sphere or cast Expel Harm, your current Stagger amount is lowered by $s1%.
    veterans_eye                        = { 101249, 450987, 1 }, -- Striking the same target $451071u times within $451071d grants $451085s1% Haste.; Multiple instances of this effect may overlap, stacking up to $451085u times.
    vigilant_watch                      = { 101244, 450993, 1 }, -- Blackout Kick deals an additional $s1% critical damage and increases the damage of your next set of Flurry Strikes by $451233s1%.
    walk_with_the_ox                    = { 101074, 387219, 2 }, -- Abilities that grant Shuffle reduce the cooldown on Invoke Niuzao, the Black Ox by ${$s2/-1000}.2 sec, and Niuzao's Stomp deals an additional $s1% damage. 
    way_of_a_thousand_strikes           = { 101226, 450965, 1 }, -- Rising Sun Kick, Blackout Kick, and Tiger Palm contribute $s1% additional vitality.
    weapons_of_order                    = { 101193, 387184, 1 }, -- For the next $d, your Mastery is increased by $?c1[${$117906bc1*$s1}]?c2[${$117907bc1*$s1}][${$115636bc1*$s1}.1]%. Additionally, $?a137025[Rising Sun Kick reduces Chi costs by $311054s1 for $311054d, and Blackout Kick reduces the cooldown of affected abilities by an additional ${$s8/1000} sec.][]$?a137023 [Keg Smash cooldown is reset instantly and enemies hit by Keg Smash or Rising Sun Kick take $312106s1% increased damage from you for $312106d, stacking up to $312106u times.][]$?a137024[Essence Font cooldown is reset instantly and heals up to $311123s2 nearby allies for $311123s1 health on channel start and end.][]
    whirling_steel                      = { 101245, 450991, 1 }, -- When your health drops below $s1%, summon Whirling Steel, increasing your parry chance and avoidance by $451214s1% for $451214d.; This effect can not occur more than once every $proccooldown sec.
    wisdom_of_the_wall                  = { 101252, 450994, 1 }, -- [452684] Critical strike damage increased by $s1%.
    zen_meditation                      = { 101201, 115176, 1 }, -- Reduces all damage taken by $s2% for $d. Being hit by a melee attack, or taking another action$?s328682[ other than movement][] will cancel this effect.
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    admonishment       = 843 , -- (207025) [206891] You focus the assault on this target, increasing their damage taken by $s1% for $d. Each unique player that attacks the target increases the damage taken by an additional $s1%, stacking up to $u times.; Your melee attacks refresh the duration of Focused Assault.
    alpha_tiger        = 5552, -- (287503) Attacking new challengers with Tiger Palm fills you with the spirit of Xuen, granting you $287504m1% haste for $287504d. ; This effect cannot occur more than once every $290512d per target.
    avert_harm         = 669 , -- (202162) Guard the $i closest players within $A1 yards for $d, allowing you to Stagger $s2% of damage they take.
    dematerialize      = 5541, -- (353361) [357819] Demateralize into mist while stunned, reducing damage taken by $353362s1%. Each second you remain stunned reduces this bonus by 10%.
    double_barrel      = 672 , -- (202335) Your next Keg Smash deals $s1% additional damage, and stuns all targets it hits for $202346d.
    eerie_fermentation = 765 , -- (205147) You gain up to $s5% movement speed  and $s6% magical damage reduction based on your current level of Stagger.
    grapple_weapon     = 5538, -- (233759) You fire off a rope spear, grappling the target's weapons and shield, returning them to you for $d.
    guided_meditation  = 668 , -- (202200) The cooldown of Zen Meditation is reduced by $m2%. While Zen Meditation is active, all harmful spells cast against your allies within 40 yards are redirected to you.; Zen Meditation is no longer cancelled when being struck by a melee attack.
    hot_trub           = 667 , -- (410346) Purifying Brew deals $s1% of cleared damage split among nearby enemies. After clearing $s2% of your maximum health in Stagger damage, your next Breath of Fire incapacitates targets for $202274d.
    microbrew          = 666 , -- (202107) Reduces the cooldown of Fortifying Brew by $m1%.
    mighty_ox_kick     = 673 , -- (202370) You perform a Mighty Ox Kick, hurling your enemy a distance behind you.
    nimble_brew        = 670 , -- (354540) Douse allies in the targeted area with Nimble Brew, preventing the next full loss of control effect within $d.
    niuzaos_essence    = 1958, -- (232876) Drinking a Purifying Brew will dispel all snares affecting you.
    rodeo              = 5417, -- (355917) Every $s1 sec while Clash is off cooldown, your next Clash can be reactivated immediately to wildly Clash an additional enemy. This effect can stack up to $355918u times.
} )

-- Auras
spec:RegisterAuras( {
    -- Agility increased by $w1%.
    against_all_odds = {
        id = 451061,
        duration = 6.0,
        max_stack = 1,
    },
    -- Haste increased by $w1%.
    alpha_tiger = {
        id = 287504,
        duration = 8.0,
        max_stack = 1,
    },
    -- A nearby Brewmaster is staggering $s2% of all damage.
    avert_harm = {
        id = 202162,
        duration = 15.0,
        max_stack = 1,
    },
    -- Your next ability is empowered.
    blackout_combo = {
        id = 228563,
        duration = 15.0,
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
    },
    -- Burning for $w1 Fire damage every $t1 sec.  Dealing $w2% reduced damage to the Monk.
    breath_of_fire = {
        id = 123725,
        duration = 12.0,
        tick_time = 2.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- blackout_combo[228563] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- blackout_combo[228563] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- celestial_flames[325190] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },
    -- Reduces all damage taken by $w1%.
    calming_presence = {
        id = 388664,
        duration = 0.0,
        max_stack = 1,
    },
    -- Absorbs $w1 damage.$?$w2>0[; Your self-healing increased by $w2%.][]
    celestial_brew = {
        id = 322507,
        duration = 8.0,
        max_stack = 1,

        -- Affected by:
        -- endless_draught[450892] #1: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },
    -- Breath of Fire reduces damage taken by an additional $325177s2%.; Spinning Crane Kick ignites targets with Breath of Fire.
    celestial_flames = {
        id = 325190,
        duration = 6.0,
        max_stack = 1,
    },
    -- Your Blackout Kick and Spinning Crane Kick deal $w1% increased damage as Fire damage, and their damage refreshes the duration of Breath of Fire on the target.
    charred_passions = {
        id = 386963,
        duration = 8.0,
        max_stack = 1,
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
    -- Taking $w1 Nature damage every $t1 sec.
    chi_surge = {
        id = 393786,
        duration = 8.0,
        tick_time = 2.0,
        max_stack = 1,

        -- Affected by:
        -- press_the_advantage[418359] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },
    -- Movement speed increased by $w1%.
    chi_torpedo = {
        id = 119085,
        duration = 10.0,
        max_stack = 1,
    },
    -- Stunned.
    clash = {
        id = 128846,
        duration = 4.0,
        max_stack = 1,
    },
    -- Your next Tiger Palm or Spinning Crane Kick deals $w1% increased damage.
    counterstrike = {
        id = 383800,
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
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk_twohand_adjustment[346104] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- efficient_training[450989] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- efficient_training[450989] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- press_the_advantage[418361] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Movement slowed by $w1%.
    crashing_momentum = {
        id = 450342,
        duration = 5.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- winds_reach[450514] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- winds_reach[450514] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- winds_reach[450514] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 3000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- Damage taken reduced by $m2% to $m3% for $d, with larger attacks being reduced by more.
    dampen_harm = {
        id = 122278,
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
    },
    -- Rooted for $d.
    disable = {
        id = 116706,
        duration = 8.0,
        max_stack = 1,
    },
    -- Stunned.
    double_barrel = {
        id = 202346,
        duration = 3.0,
        max_stack = 1,
    },
    -- Absorbing $w1 damage.
    elixir_of_determination = {
        id = 455179,
        duration = 15.0,
        max_stack = 1,
    },
    -- Dodge chance increased by $w1%.
    elusive_brawler = {
        id = 195630,
        duration = 10.0,
        max_stack = 1,

        -- Affected by:
        -- mastery_elusive_brawler[117906] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'sp_bonus': 0.88, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Transcendence: Transfer has no cooldown.; Vivify's healing is increased by $w3% and you're refunded $m2% of the cost when cast on yourself.
    escape_from_reality = {
        id = 343249,
        duration = 10.0,
        max_stack = 1,
    },
    -- Misses melee attacks.
    exploding_keg = {
        id = 325153,
        duration = 3.0,
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
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- press_the_advantage[418361] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Damage taken increased by $m1%.
    focused_assault = {
        id = 206891,
        duration = 6.0,
        max_stack = 1,
    },
    -- $?$w1>0[Health increased by $<health>%, damage taken reduced by $<damage>%.][]$?$w6>0[; Effectiveness of Stagger increased by $115203s1%.][]$?a451029&$c2[; Staggering $451029s1% of incoming damage.][]
    fortifying_brew = {
        id = 120954,
        duration = 15.0,
        max_stack = 1,

        -- Affected by:
        -- fortifying_brew_determination[322960] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
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
    -- The damage of your next Keg Smash is increased by $w1%.
    hit_scheme = {
        id = 383696,
        duration = 8.0,
        max_stack = 1,
    },
    -- Disoriented.
    hot_trub = {
        id = 202274,
        duration = 4.0,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- blackout_combo[228563] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- [274586] Vivify heals all allies with your Renewing Mist active for $425804s1, reduced beyond $s1 allies.; 
    invigorating_mists = {
        id = 425804,
        duration = 0.0,
        max_stack = 1,

        -- Affected by:
        -- improved_vivify[231602] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Niuzao is staggering $s2% of the Monk's Stagger damage.
    invoke_niuzao_the_black_ox = {
        id = 132578,
        duration = 25.0,
        max_stack = 1,

        -- Affected by:
        -- invoke_niuzao_the_black_ox[132578] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
    },
    -- Movement speed increased by $w1%.
    jade_walk = {
        id = 450552,
        duration = 5.0,
        max_stack = 1,
    },
    -- $?$w3!=0[Movement speed reduced by $w3%.; ][]Drenched in brew, vulnerable to Breath of Fire.
    keg_smash = {
        id = 121253,
        duration = 15.0,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- efficient_training[450989] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- efficient_training[450989] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- one_versus_many[450988] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- stormstouts_last_keg[383707] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- stormstouts_last_keg[383707] #1: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- double_barrel[202335] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- hit_scheme[383696] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- press_the_advantage[418361] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Stunned.
    leg_sweep = {
        id = 119381,
        duration = 3.0,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- ancient_arts[344359] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- tiger_tail_sweep[264348] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
    },
    -- You may jump twice to dash forward a short distance.
    lighter_than_air = {
        id = 449609,
        duration = 5.0,
        max_stack = 1,
    },
    -- Physical damage taken increased by $w1%.
    mystic_touch = {
        id = 113746,
        duration = 3600,
        max_stack = 1,
    },
    -- Prevents the next full loss of control effect.
    nimble_brew = {
        id = 354540,
        duration = 8.0,
        max_stack = 1,
    },
    -- Incapacitated.
    paralysis = {
        id = 115078,
        duration = 60.0,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- ancient_arts[344359] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- Vitality stored increased by $s1%.
    path_of_resurgence = {
        id = 451084,
        duration = 10.0,
        max_stack = 1,

        -- Affected by:
        -- chi_wave[450391] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- Damage taken reduced by $w1%.
    predictive_training = {
        id = 451230,
        duration = 6.0,
        max_stack = 1,
    },
    -- Damage increased by $w1%.
    press_the_advantage = {
        id = 418361,
        duration = 20.0,
        max_stack = 1,
    },
    -- Increases Dodge by $s1%.
    pretense_of_instability = {
        id = 393515,
        duration = 5.0,
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
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },
    -- Nearby enemies will be knocked out of the Ring of Peace.
    ring_of_peace = {
        id = 116844,
        duration = 5.0,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- peace_and_prosperity[450448] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
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
    -- Dealing physical damage to nearby enemies every $116847t1 sec.
    rushing_jade_wind = {
        id = 116847,
        duration = 6.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -38.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #8: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- monk[137022] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'target': TARGET_UNIT_CASTER, }
    },
    -- Healing increased by $w1%.
    save_them_all = {
        id = 390105,
        duration = 4.0,
        max_stack = 1,
    },
    -- Blackout Kick damage increased by $s2% and strikes an additional $s1 $ltarget;targets.
    shadowboxing_treads = {
        id = 387638,
        duration = 0.0,
        max_stack = 1,
    },
    -- Your Stagger is $w3% more effective.
    shuffle = {
        id = 215479,
        duration = 5.0,
        max_stack = 1,
    },
    -- Disoriented.
    song_of_chiji = {
        id = 198909,
        duration = 20.0,
        max_stack = 1,
    },
    -- Healing for $w1 every $t1 sec.$?a388681[; Damage taken reduced by $w2%.][]
    soothing_mist = {
        id = 115175,
        duration = 8.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #24: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- elusive_mists[388681] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },
    -- $?$w2!=0[Movement speed reduced by $w2%.; ][]Drenched in brew, vulnerable to Breath of Fire.
    special_delivery = {
        id = 196733,
        duration = 15.0,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- press_the_advantage[418361] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Attacking all nearby enemies for Physical damage every $101546t1 sec.; Movement speed reduced by $s2%.
    spinning_crane_kick = {
        id = 107270,
        duration = 0.0,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #21: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 11.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fast_feet[388809] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- efficient_training[450989] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- press_the_advantage[418361] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Movement slowed by $w1%.
    spirits_essence = {
        id = 450596,
        duration = 4.0,
        max_stack = 1,
    },
    -- Moving $s1% faster.
    tigers_lust = {
        id = 116841,
        duration = 6.0,
        max_stack = 1,

        -- Affected by:
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
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
    },
    -- Damage of your next set of Flurry Strikes increased by $w1%.
    vigilant_watch = {
        id = 451233,
        duration = 30.0,
        max_stack = 1,
    },
    -- Your next Vivify is instant and its healing is increased by $s2%.$?c1[; The cost of Vivify is reduced by $s3%.]?c3[; The cost of Vivify is reduced by $s4%.][]
    vivacious_vivification = {
        id = 392883,
        duration = 3600,
        max_stack = 1,
    },
    -- Increases your Mastery by $?c1[${$117906bc1*$w1}]?c2[${$117907bc1*$w1}][${$115636bc1*$w1}]%$?a137025[, Rising Sun Kick reduces Chi costs by $311054s1 for $311054d, and Blackout Kick reduces the cooldown of affected abilities by an additional ${$s8/1000} sec.]?a137023 [ and your Keg Smash increases the damage you deal to those enemies by $312106s1%, up to ${$312106s1*$312106u}% for $312106d.]?a137024[ and your Essence Font heals nearby allies for $311123s1 health on channel start and end.][ and your abilities are enhanced.]
    weapons_of_order = {
        id = 387184,
        duration = 30.0,
        max_stack = 1,
    },
    -- Parry and Avoidance increased by $w1%.
    whirling_steel = {
        id = 451214,
        duration = 6.0,
        max_stack = 1,
    },
    -- Flying.
    zen_flight = {
        id = 125883,
        duration = 3600,
        max_stack = 1,
    },
    -- Damage taken reduced by $s2%.
    zen_meditation = {
        id = 115176,
        duration = 8.0,
        max_stack = 1,

        -- Affected by:
        -- guided_meditation[202200] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
} )

-- Abilities
spec:RegisterAbilities( {
    -- [206891] You focus the assault on this target, increasing their damage taken by $s1% for $d. Each unique player that attacks the target increases the damage taken by an additional $s1%, stacking up to $u times.; Your melee attacks refresh the duration of Focused Assault.
    admonishment = {
        id = 207025,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 20.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 206891, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }
    },

    -- Guard the $i closest players within $A1 yards for $d, allowing you to Stagger $s2% of damage they take.
    avert_harm = {
        id = 202162,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': SCHOOL_ABSORB, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'value1': -20, 'radius': 15.0, 'target': TARGET_DEST_CASTER, 'target2': TARGET_UNIT_DEST_AREA_ALLY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, }
    },

    -- Chug some Black Ox Brew, which instantly refills your Energy, Purifying Brew charges, and resets the cooldown of Celestial Brew.
    black_ox_brew = {
        id = 115399,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "none",

        talent = "black_ox_brew",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': ENERGIZE, 'subtype': NONE, 'points': 200.0, 'target': TARGET_UNIT_CASTER, 'resource': energy, }
    },

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
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- brewmaster_monk[137023] #27: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- elusive_footwork[387046] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fluidity_of_motion[387230] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -1000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- fluidity_of_motion[387230] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowboxing_treads[387638] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- shadowboxing_treads[387638] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- vigilant_watch[450993] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- weapons_of_order[387184] #7: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1000.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- press_the_advantage[418361] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- blackout_kick[116768] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- blackout_kick[116768] #1: { 'type': APPLY_AURA, 'subtype': ABILITY_IGNORE_AURASTATE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- blackout_kick[116768] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Breathe fire on targets in front of you, causing $s1 Fire damage. Deals reduced damage to secondary targets.; Targets affected by Keg Smash will also burn, taking $123725o1 Fire damage and dealing $123725s2% reduced damage to you for $123725d.
    breath_of_fire = {
        id = 115181,
        cast = 0.0,
        cooldown = 15.0,
        gcd = "global",

        talent = "breath_of_fire",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'attributes': ['Add Target (Dest) Combat Reach to AOE', 'Area Effects Use Target Radius'], 'ap_bonus': 0.5328, 'pvp_multiplier': 1.35, 'variance': 0.05, 'radius': 12.0, 'target': TARGET_UNIT_CONE_CASTER_TO_DEST_ENEMY, }

        -- Affected by:
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- windwalker_monk_twohand_adjustment[346104] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- blackout_combo[228563] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- press_the_advantage[418361] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- [115181] Breathe fire on targets in front of you, causing $s1 Fire damage. Deals reduced damage to secondary targets.; Targets affected by Keg Smash will also burn, taking $123725o1 Fire damage and dealing $123725s2% reduced damage to you for $123725d.
    breath_of_fire_123725 = {
        id = 123725,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 2.0, 'ap_bonus': 0.0555, 'pvp_multiplier': 1.35, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_IGNORE_TARGET_RESIST, 'points': -5.0, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- blackout_combo[228563] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- blackout_combo[228563] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- celestial_flames[325190] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        from = "from_description",
    },

    -- A swig of strong brew that coalesces purified chi escaping your body into a celestial guard, absorbing $<absorb> damage.; Purifying Stagger damage increases absorption by up to $322510s1%.
    celestial_brew = {
        id = 322507,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        talent = "celestial_brew",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': SCHOOL_ABSORB, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- endless_draught[450892] #1: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
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
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #26: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- manifestation[450875] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
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
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- windwalker_monk_twohand_adjustment[346104] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- efficient_training[450989] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- efficient_training[450989] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- press_the_advantage[418361] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Reduces all damage you take by $m2% to $m3% for $d, with larger attacks being reduced by more.
    dampen_harm = {
        id = 122278,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "none",

        talent = "dampen_harm",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': SCHOOL_ABSORB, 'value': 1, 'schools': ['physical'], 'value1': -29, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'sp_bonus': 0.25, 'pvp_multiplier': 1.25, 'points': 20.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': DUMMY, 'sp_bonus': 0.25, 'points': 50.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': SCHOOL_ABSORB, 'value': 126, 'schools': ['holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'value1': -29, 'target': TARGET_UNIT_CASTER, }
    },

    -- Removes all Poison and Disease effects from the target.
    detox = {
        id = 218164,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 10,
        spendType = 'energy',

        talent = "detox",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DISPEL, 'subtype': NONE, 'points': 100.0, 'value': 3, 'schools': ['physical', 'holy'], 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': DISPEL, 'subtype': NONE, 'points': 100.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_TARGET_ALLY, }
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
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- winds_reach[450514] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- Your next Keg Smash deals $s1% additional damage, and stuns all targets it hits for $202346d.
    double_barrel = {
        id = 202335,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 45.0,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
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
        -- expel_harm[322102] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- profound_rebuttal[392910] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- vigorous_expulsion[392900] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- vigorous_expulsion[392900] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- celestial_brew[322507] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_CASTER, }
    },

    -- Hurls a flaming keg at the target location, dealing $s1 Fire damage to nearby enemies, causing your attacks against them to deal $388867s1 additional Fire damage, and causing their melee attacks to deal $s2% reduced damage for the next $d.
    exploding_keg = {
        id = 325153,
        cast = 0.0,
        cooldown = 60.0,
        gcd = "global",

        talent = "exploding_keg",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 2.8638, 'radius': 8.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_AUTOATTACK_DAMAGE, 'points': -100.0, 'radius': 8.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_HIT_CHANCE, 'attributes': ['Players Only'], 'points': -100.0, 'radius': 8.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #3: { 'type': APPLY_AURA, 'subtype': PROC_TRIGGER_SPELL, 'trigger_spell': 388867, 'ap_bonus': 0.2, 'target': TARGET_UNIT_CASTER, }
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
        -- expeditious_fortification[388813] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -30000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- ironshell_brew[388814] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- ironshell_brew[388814] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- microbrew[202107] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
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

    -- Summons an effigy of Niuzao, the Black Ox for $d. Niuzao attacks your primary target, and frequently Stomps, damaging all nearby enemies$?s322740[ for $227291s1 plus $322740s1% of Stagger damage you have recently purified.][.]; While active, $s2% of damage delayed by Stagger is instead Staggered by Niuzao.
    invoke_niuzao_the_black_ox = {
        id = 132578,
        cast = 0.0,
        cooldown = 180.0,
        gcd = "global",

        talent = "invoke_niuzao_the_black_ox",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SUMMON, 'subtype': NONE, 'value': 73967, 'schools': ['physical', 'holy', 'fire', 'nature', 'shadow', 'arcane'], 'value1': 3353, 'target': TARGET_DEST_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 25.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': SCHOOL_ABSORB, 'value': 1, 'schools': ['physical'], 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }

        -- Affected by:
        -- invoke_niuzao_the_black_ox[132578] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
    },

    -- Smash a keg of brew on the target, dealing $s2 Physical damage to all enemies within $A2 yds and reducing their movement speed by $m3% for $d. Deals reduced damage beyond $s7 targets.$?a322120[; Grants Shuffle for $s6 sec and reduces the remaining cooldown on your Brews by $s4 sec.][]
    keg_smash = {
        id = 121253,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "global",

        spend = 40,
        spendType = 'energy',

        talent = "keg_smash",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.999, 'variance': 0.05, 'radius': 8.0, 'target': TARGET_DEST_TARGET_ENEMY, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_DECREASE_SPEED, 'mechanic': snared, 'points': -20.0, 'radius': 8.0, 'target': TARGET_DEST_TARGET_ENEMY, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': APPLY_AURA, 'subtype': DUMMY, 'radius': 8.0, 'target': TARGET_DEST_TARGET_ENEMY, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #5: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #6: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- efficient_training[450989] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- efficient_training[450989] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- one_versus_many[450988] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- stormstouts_last_keg[383707] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- stormstouts_last_keg[383707] #1: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- double_barrel[202335] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- hit_scheme[383696] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- press_the_advantage[418361] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
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
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- ancient_arts[344359] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- tiger_tail_sweep[264348] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
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

    -- Douse allies in the targeted area with Nimble Brew, preventing the next full loss of control effect within $d.
    nimble_brew = {
        id = 354540,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 90.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 18, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 1, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 2, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 5, }
        -- #4: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 13, }
        -- #5: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 24, }
        -- #6: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 14, }
        -- #7: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 17, }
        -- #8: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 30, }
        -- #9: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 10, }
        -- #10: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'radius': 8.0, 'target': TARGET_UNK_149, 'target2': TARGET_UNIT_DEST_AREA_ALLY, 'mechanic': 12, }
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
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- ancient_arts[344359] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
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

    -- Clears $s1% of your damage delayed with Stagger.$?s322510[; Increases the absorption of your next Celestial Brew by up to $322510s1%, based on your current level of Stagger][]$?s383700[; Instantly heals you for $383700s1% of the damage cleared.][]
    purifying_brew = {
        id = 119582,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "none",

        talent = "purifying_brew",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mantra_of_purity[451036] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
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
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- peace_and_prosperity[450448] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
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
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #25: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 47.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- monk[137022] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'target': TARGET_UNIT_CASTER, }
        -- fast_feet[388809] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 70.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
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

    -- Summons a whirling tornado around you, causing ${(1+$d/$t1)*$148187s1} Physical damage over $d to all enemies within $107270A1 yards. Deals reduced damage beyond $s1 targets.
    rushing_jade_wind = {
        id = 116847,
        cast = 0.0,
        cooldown = 6.0,
        gcd = "global",

        spend = 1,
        spendType = 'chi',

        talent = "rushing_jade_wind",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_TRIGGER_SPELL, 'tick_time': 0.75, 'trigger_spell': 148187, 'points': 5.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- brewmaster_monk[137023] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -38.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #8: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- monk[137022] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'target': TARGET_UNIT_CASTER, }
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
        -- brewmaster_monk[137023] #24: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- elusive_mists[388681] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
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
        -- brewmaster_monk[137023] #24: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- elusive_mists[388681] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
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

    -- Spin while kicking in the air, dealing $?s137025[${4*$107270s1*$<CAP>/$AP}][${4*$107270s1}] Physical damage over $d to enemies within $107270A1 yds. $?s322700[; Dealing damage with Spinning Crane Kick grants Shuffle for $322700s1 sec, and your Healing Spheres travel towards you.][] $?c3[; Spinning Crane Kick's damage is increased by $220358s1% for each unique target you've struck in the last $220358d with Tiger Palm, Blackout Kick, or Rising Sun Kick.][]
    spinning_crane_kick = {
        id = 322729,
        cast = 1.5,
        channeled = true,
        cooldown = 0.0,
        gcd = "global",

        spend = 25,
        spendType = 'energy',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_TRIGGER_SPELL, 'tick_time': 0.5, 'trigger_spell': 107270, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 15.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- brewmaster_monk[137023] #21: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 11.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fast_feet[388809] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- efficient_training[450989] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Spin while kicking in the air, dealing $?s137025[${4*$107270s1*$<CAP>/$AP}][${4*$107270s1}] Physical damage over $d to all enemies within $107270A1 yds. Deals reduced damage beyond $s1 targets.$?a220357[; Spinning Crane Kick's damage is increased by $220358s1% for each unique target you've struck in the last $220358d with Tiger Palm, Blackout Kick, or Rising Sun Kick. Stacks up to $228287i times.][]
    spinning_crane_kick_101546 = {
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
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #21: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 11.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fast_feet[388809] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- efficient_training[450989] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        from = "class",
    },

    -- Stomps the ground, dealing $s1 Physical damage to all nearby enemies.
    stomp = {
        id = 227291,
        cast = 0.0,
        cooldown = 5.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'attributes': ['Add Target (Dest) Combat Reach to AOE', 'Area Effects Use Target Radius'], 'ap_bonus': 0.1638, 'variance': 0.05, 'radius': 8.0, 'target': TARGET_DEST_CASTER, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }

        -- Affected by:
        -- invoke_niuzao_the_black_ox[132578] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
        -- walk_with_the_ox[387219] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 10.0, 'radius': 100.0, 'target': TARGET_UNIT_CASTER_AND_SUMMONS, 'modifies': DAMAGE_HEALING, }
    },

    -- Summons a Black Ox Statue at the target location for $d, pulsing threat to all enemies within $163178A1 yards.; You may cast Provoke on the statue to taunt all enemies near the statue.
    summon_black_ox_statue = {
        id = 115315,
        cast = 0.0,
        cooldown = 10.0,
        gcd = "global",

        talent = "summon_black_ox_statue",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': SUMMON, 'subtype': NONE, 'points': 1.0, 'value': 61146, 'schools': ['holy', 'nature', 'frost', 'arcane'], 'value1': 3223, 'target': TARGET_DEST_DEST, }
        -- #1: { 'type': UNKNOWN, 'subtype': NONE, 'points': 30.0, }
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
        -- brewmaster_monk[137023] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 139.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- brewmaster_monk[137023] #16: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- windwalker_monk_twohand_adjustment[346104] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- windwalker_monk_twohand_adjustment[346104] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- efficient_training[450989] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- efficient_training[450989] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- fatal_touch[450832] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_touch[450832] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- blackout_combo[228563] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- counterstrike[383800] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'trigger_spell': 100780, 'triggers': tiger_palm, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- press_the_advantage[418361] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
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
        -- brewmaster_monk[137023] #13: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
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
        -- brewmaster_monk[137023] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 92.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- improved_vivify[231602] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- renewing_mist[119611] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- chi_proficiency[450426] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- celestial_brew[322507] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_CASTER, }
        -- vivacious_vivification[392883] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -1500.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- vivacious_vivification[392883] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- vivacious_vivification[392883] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -75.0, 'target': TARGET_UNIT_CASTER, 'modifies': IGNORE_SHAPESHIFT, }
        -- vivacious_vivification[392883] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -75.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- escape_from_reality[343249] #2: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'points': 70.0, 'target': TARGET_UNIT_CASTER, }
        -- save_them_all[390105] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- save_them_all[390105] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- chi_harmony[423439] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'pvp_multiplier': 0.3, 'points': 50.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },

    -- For the next $d, your Mastery is increased by $?c1[${$117906bc1*$s1}]?c2[${$117907bc1*$s1}][${$115636bc1*$s1}.1]%. Additionally, $?a137025[Rising Sun Kick reduces Chi costs by $311054s1 for $311054d, and Blackout Kick reduces the cooldown of affected abilities by an additional ${$s8/1000} sec.][]$?a137023 [Keg Smash cooldown is reset instantly and enemies hit by Keg Smash or Rising Sun Kick take $312106s1% increased damage from you for $312106d, stacking up to $312106u times.][]$?a137024[Essence Font cooldown is reset instantly and heals up to $311123s2 nearby allies for $311123s1 health on channel start and end.][]
    weapons_of_order = {
        id = 387184,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "global",

        spend = 0.050,
        spendType = 'mana',

        talent = "weapons_of_order",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MASTERY, 'points': 10.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_CRIT_PCT, 'points': 10.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_VERSATILITY, 'points': 10.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MELEE_SLOW, 'points': 10.0, 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': APPLY_AURA, 'subtype': MOD_LEECH, 'points': 10.0, 'target': TARGET_UNIT_CASTER, }
        -- #5: { 'type': APPLY_AURA, 'subtype': MOD_RESISTANCE_PCT, 'value': 1, 'schools': ['physical'], 'target': TARGET_UNIT_CASTER, }
        -- #6: { 'type': FORCE_CAST, 'subtype': NONE, 'trigger_spell': 314486, 'target': TARGET_UNIT_CASTER, }
        -- #7: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1000.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
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

    -- Reduces all damage taken by $s2% for $d. Being hit by a melee attack, or taking another action$?s328682[ other than movement][] will cancel this effect.
    zen_meditation = {
        id = 115176,
        cast = 8.0,
        channeled = true,
        cooldown = 300.0,
        gcd = "none",

        talent = "zen_meditation",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'points': -60.0, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': HOVER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- guided_meditation[202200] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
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

} )