-- ShamanEnhancement.lua
-- July 2024

if UnitClassBase( "player" ) ~= "SHAMAN" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local PTR = ns.PTR
local FindPlayerAuraByID = ns.FindPlayerAuraByID

-- Globals
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local GetSpellCastCount = C_Spell.GetSpellCastCount
local strformat = string.format
local insert, wipe = table.insert, table.wipe

local spec = Hekili:NewSpecialization( 263 )

spec:RegisterResource( Enum.PowerType.Maelstrom )
spec:RegisterResource( Enum.PowerType.Mana )

-- Talents
spec:RegisterTalents( {
    -- Shaman
    ancestral_swiftness       = {  94894, 443454, 1 }, -- Your next healing or damaging spell is instant, costs no mana, and deals 10% increased damage and healing. If you know Nature's Swiftness, it is replaced by Ancestral Swiftness and causes Ancestral Swiftness to call an Ancestor to your side for 6 sec.
    ancestral_wolf_affinity   = { 103610, 382197, 1 }, -- Cleanse Spirit, Wind Shear, Purge, and totem casts no longer cancel Ghost Wolf.
    ancient_fellowship        = {  94862, 443423, 1 }, -- Ancestors have a 20% chance to call another Ancestor for 6 sec when they depart.
    arctic_snowstorm          = { 103619, 462764, 1 }, -- Enemies within 10 yds of your Frost Shock are snared by 30%.
    ascending_air             = { 103607, 462791, 1 }, -- Wind Rush Totem's cooldown is reduced by 30 sec and its movement speed effect lasts an additional 2 sec.
    astral_bulwark            = { 103611, 377933, 1 }, -- Astral Shift reduces damage taken by an additional 20%.
    astral_shift              = { 103616, 108271, 1 }, -- Shift partially into the elemental planes, taking 40% less damage for 12 sec.
    brimming_with_life        = { 103582, 381689, 1 }, -- Maximum health increased by 10%, and while you are at full health, Reincarnation cools down 75% faster.
    call_of_the_ancestors     = {  94888, 443450, 1 }, -- Benefiting from Undulation calls an Ancestor to your side for 6 sec. Casting Unleash Life calls an Ancestor to your side for 12 sec. Whenever you cast a healing or damaging spell, the Ancestor will cast a similar spell.
    call_of_the_elements      = { 103592, 383011, 1 }, -- Reduces the cooldown of Totemic Recall by 60 sec.
    capacitor_totem           = { 103579, 192058, 1 }, -- Summons a totem at the target location that gathers electrical energy from the surrounding air and explodes after 2 sec, stunning all enemies within 9 yards for 3 sec.
    chain_heal                = { 103588,   1064, 1 }, -- Heals the friendly target for 171,930, then jumps up to 15 yards to heal the 3 most injured nearby allies. Healing is reduced by 30% with each jump.
    chain_lightning           = { 103583, 188443, 1 }, -- Hurls a lightning bolt at the enemy, dealing 54,244 Nature damage and then jumping to additional nearby enemies. Affects 5 total targets. If Chain Lightning hits more than 1 target, each target hit by your Chain Lightning increases the damage of your next Crash Lightning by 20%. Each target hit by Chain Lightning reduces the cooldown of Crash Lightning by 0.5 sec. Consumes Maelstrom Weapon for increased cast speed and damage.
    cleanse_spirit            = { 103608,  51886, 1 }, -- Removes all Curse effects from a friendly target.
    creation_core             = { 103592, 383012, 1 }, -- Totemic Recall affects an additional totem.
    earth_elemental           = { 103585, 198103, 1 }, -- Calls forth a Greater Earth Elemental to protect you and your allies for 1 min. While this elemental is active, your maximum health is increased by 15%.
    earth_shield              = { 103596,    974, 1 }, -- Protects the target with an earthen shield, increasing your healing on them by 20% and healing them for 105,153 when they take damage. This heal can only occur once every 3 sec. Maximum 9 charges. Earth Shield can only be placed on the Shaman and one other target at a time. The Shaman can have up to two Elemental Shields active on them.
    earthen_communion         = {  94858, 443441, 1 }, -- Earth Shield has an additional 3 charges and heals you for 25% more.
    earthgrab_totem           = { 103617,  51485, 1 }, -- Summons a totem at the target location for 30 sec. The totem pulses every 2 sec, rooting all enemies within 9 yards for 8 sec. Enemies previously rooted by the totem instead suffer 50% movement speed reduction.
    elemental_orbit           = { 103602, 383010, 1 }, -- Increases the number of Elemental Shields you can have active on yourself by 1. You can have Earth Shield on yourself and one ally at the same time.
    elemental_resistance      = { 103601, 462368, 1 }, -- Healing from Healing Stream Totem reduces Fire, Frost, and Nature damage taken by 6% for 3 sec.
    elemental_reverb          = {  94869, 443418, 1 }, -- Lava Burst gains an additional charge and deals 5% increased damage.
    elemental_warding         = { 103597, 381650, 1 }, -- Reduces all magic damage taken by 6%.
    encasing_cold             = { 103619, 462762, 1 }, -- Frost Shock snares its targets by an additional 10% and its duration is increased by 2 sec.
    enhanced_imbues           = { 103606, 462796, 1 }, -- The effects of your weapon imbues are increased by 15%.
    final_calling             = {  94875, 443446, 1 }, -- When an Ancestor departs, they cast Hydrobubble on a nearby injured ally.  Hydrobubble
    fire_and_ice              = { 103605, 382886, 1 }, -- Increases all Fire and Frost damage you deal by 3%.
    frost_shock               = { 103604, 196840, 1 }, -- Chills the target with frost, causing 60,449 Frost damage and reducing the target's movement speed by 50% for 6 sec.
    graceful_spirit           = { 103626, 192088, 1 }, -- Reduces the cooldown of Spiritwalker's Grace by 30 sec and increases your movement speed by 20% while it is active.
    greater_purge             = { 103624, 378773, 1 }, -- Purges the enemy target, removing 2 beneficial Magic effects.
    guardians_cudgel          = { 103618, 381819, 1 }, -- When Capacitor Totem fades or is destroyed, another Capacitor Totem is automatically dropped in the same place.
    gust_of_wind              = { 103591, 192063, 1 }, -- A gust of wind hurls you forward.
    healing_stream_totem      = { 103590,   5394, 1 }, -- Summons a totem at your feet for 18 sec that heals an injured party or raid member within 46 yards for 80,597 every 1.9 sec. If you already know Healing Stream Totem, instead gain 1 additional charge of Healing Stream Totem.
    heed_my_call              = {  94884, 443444, 1 }, -- Ancestors last an additional 4 sec.
    hex                       = { 103623,  51514, 1 }, -- Transforms the enemy into a frog for 1 min. While hexed, the victim is incapacitated, and cannot attack or cast spells. Damage may cancel the effect. Limit 1. Only works on Humanoids and Beasts.
    jet_stream                = { 103607, 462817, 1 }, -- Wind Rush Totem's movement speed bonus is increased by 10% and now removes snares.
    latent_wisdom             = {  94862, 443449, 1 }, -- Your Ancestors' spells are 25% more powerful.
    lava_burst                = { 103598,  51505, 1 }, -- Hurls molten lava at the target, dealing 101,287 Fire damage. Lava Burst will always critically strike if the target is affected by Flame Shock.
    lightning_lasso           = { 103589, 305483, 1 }, -- Grips the target in lightning, stunning and dealing 614,591 Nature damage over 5 sec while the target is lassoed. Can move while channeling.
    maelstrom_supremacy       = {  94883, 443447, 1 }, -- Increases the healing done by Healing Wave, Healing Surge, Wellspring, Downpour, and Chain Heal by 15%.
    mana_spring               = { 103587, 381930, 1 }, -- Your Stormstrike casts restore 2,625 mana to you and 4 allies nearest to you within 40 yards. Allies can only benefit from one Shaman's Mana Spring effect at a time, prioritizing healers.
    natural_harmony           = {  94858, 443442, 1 }, -- Reduces the cooldown of Nature's Guardian by 15 sec and causes it to heal for an additional 10% of your maximum health.
    natures_fury              = { 103622, 381655, 1 }, -- Increases the critical strike chance of your Nature spells and abilities by 4%.
    natures_guardian          = { 103613,  30884, 1 }, -- When your health is brought below 35%, you instantly heal for 20% of your maximum health. Cannot occur more than once every 45 sec.
    natures_swiftness         = { 103620, 378081, 1 }, -- Your next healing or damaging Nature spell is instant cast and costs no mana.
    offering_from_beyond      = {  94887, 443451, 1 }, -- When an Ancestor is called, they reduce the cooldown of Riptide by 2 sec.
    planes_traveler           = { 103611, 381647, 1 }, -- Reduces the cooldown of Astral Shift by 30 sec.
    poison_cleansing_totem    = { 103609, 383013, 1 }, -- Summons a totem at your feet that removes all Poison effects from a nearby party or raid member within 34 yards every 1.5 sec for 9 sec.
    primordial_bond           = { 103612, 381764, 1 }, -- While you have an elemental active, your damage taken is reduced by 5%.
    primordial_capacity       = {  94860, 443448, 1 }, -- Increases your maximum mana by 5%. Tidal Waves can now stack up to 4 times.
    purge                     = { 103624,    370, 1 }, -- Purges the enemy target, removing 1 beneficial Magic effect.
    refreshing_waters         = { 103594, 378211, 1 }, -- Your Healing Surge is 25% more effective on yourself.
    routine_communication     = {  94884, 443445, 1 }, -- Riptide has a 15% chance to call an Ancestor to your side for 6 sec.
    seasoned_winds            = { 103628, 355630, 1 }, -- Interrupting a spell with Wind Shear decreases your damage taken from that spell school by 15% for 18 sec. Stacks up to 2 times.
    spirit_walk               = { 103591,  58875, 1 }, -- Removes all movement impairing effects and increases your movement speed by 60% for 8 sec.
    spirit_wolf               = { 103581, 260878, 1 }, -- While transformed into a Ghost Wolf, you gain 5% increased movement speed and 5% damage reduction every 1 sec, stacking up to 4 times.
    spiritwalkers_aegis       = { 103626, 378077, 1 }, -- When you cast Spiritwalker's Grace, you become immune to Silence and Interrupt effects for 5 sec.
    spiritwalkers_grace       = { 103584,  79206, 1 }, -- Calls upon the guidance of the spirits for 15 sec, permitting movement while casting Shaman spells. Castable while casting.
    spiritwalkers_momentum    = {  94861, 443425, 1 }, -- Using spells with a cast time increases the duration of Spiritwalker's Grace and Spiritwalker's Aegis by 1 sec, up to a maximum of 4 sec.
    static_charge             = { 103618, 265046, 1 }, -- Reduces the cooldown of Capacitor Totem by 5 sec for each enemy it stuns, up to a maximum reduction of 20 sec.
    stone_bulwark_totem       = { 103629, 108270, 1 }, -- Summons a totem at your feet that grants you an absorb shield preventing 2.1 million damage for 15 sec, and an additional 214,354 every 5 sec for 30 sec.
    thunderous_paws           = { 103581, 378075, 1 }, -- Ghost Wolf removes snares and increases your movement speed by an additional 25% for the first 3 sec. May only occur once every 20 sec.
    thundershock              = { 103621, 378779, 1 }, -- Thunderstorm knocks enemies up instead of away and its cooldown is reduced by 5 sec.
    thunderstorm              = { 103603,  51490, 1 }, -- Calls down a bolt of lightning, dealing 9,201 Nature damage to all enemies within 10 yards, reducing their movement speed by 40% for 5 sec, and knocking them upward. Usable while stunned.
    totemic_focus             = { 103625, 382201, 1 }, -- Increases the radius of your totem effects by 15%. Increases the duration of your Earthbind and Earthgrab Totems by 10 sec. Increases the duration of your Healing Stream, Tremor, Poison Cleansing, and Wind Rush Totems by 3.0 sec.
    totemic_projection        = { 103586, 108287, 1 }, -- Relocates your active totems to the specified location.
    totemic_recall            = { 103595, 108285, 1 }, -- Resets the cooldown of your most recently used totem with a base cooldown shorter than 3 minutes.
    totemic_surge             = { 103599, 381867, 1 }, -- Reduces the cooldown of your totems by 6 sec.
    traveling_storms          = { 103621, 204403, 1 }, -- Thunderstorm now can be cast on allies within 40 yards, reduces enemies movement speed by 60%, and knocks enemies 25% further.
    tremor_totem              = { 103593,   8143, 1 }, -- Summons a totem at your feet that shakes the ground around it for 13 sec, removing Fear, Charm and Sleep effects from party and raid members within 34 yards.
    voodoo_mastery            = { 103600, 204268, 1 }, -- Your Hex target is slowed by 70% during Hex and for 6 sec after it ends. Reduces the cooldown of Hex by 15 sec.
    wind_rush_totem           = { 103627, 192077, 1 }, -- Summons a totem at the target location for 18 sec, continually granting all allies who pass within 11 yards 40% increased movement speed for 7 sec.
    wind_shear                = { 103615,  57994, 1 }, -- Disrupts the target's concentration with a burst of wind, interrupting spellcasting and preventing any spell in that school from being cast for 2 sec.
    winds_of_alakir           = { 103614, 382215, 1 }, -- Increases the movement speed bonus of Ghost Wolf by 10%. When you have 3 or more totems active, your movement speed is increased by 15%.

    -- Enhancement
    alpha_wolf                = {  80970, 198434, 1 }, -- While Feral Spirits are active, Chain Lightning and Crash Lightning causes your wolves to attack all nearby enemies for 13,429 Physical damage every 2 sec for the next 8 sec.
    ascendance                = {  92219, 114051, 1 }, -- Transform into an Air Ascendant for 15 sec, immediately dealing 191,191 Nature damage to any enemy within 8 yds, reducing the cooldown and cost of Stormstrike by 60%, and transforming your auto attack and Stormstrike into Wind attacks which bypass armor and have a 30 yd range.
    ashen_catalyst            = {  80947, 390370, 1 }, -- Each time Flame Shock deals periodic damage, it increases the damage of your next Lava Lash by 12% up to 96%, and reduces the cooldown of your Lava Lash by 0.5 sec.
    converging_storms         = {  80973, 384363, 1 }, -- Each target hit by Crash Lightning increases the damage of your next Stormstrike by 25%, up to a maximum of 6 stacks.
    crash_lightning           = {  80974, 187874, 1 }, -- Electrocutes all enemies in front of you, dealing 143,917 Nature damage. Hitting 2 or more targets enhances your weapons for 12 sec, causing Stormstrike, Ice Strike, and Lava Lash to also deal 43,611 Nature damage to all targets in front of you. Damage reduced beyond 6 targets.
    crashing_storms           = {  80953, 334308, 1 }, -- Crash Lightning damage increased by 40%. Chain Lightning now jumps to 2 extra targets.
    deeply_rooted_elements    = {  92219, 378270, 1 }, -- Each stack of Maelstrom Weapon consumed has a 0.6% chance to activate Ascendance for 6.0 sec.  Ascendance Transform into an Air Ascendant for 15 sec, immediately dealing 191,191 Nature damage to any enemy within 8 yds, reducing the cooldown and cost of Stormstrike by 60%, and transforming your auto attack and Stormstrike into Wind attacks which bypass armor and have a 30 yd range.
    doom_winds                = {  80959, 384352, 1 }, -- Unleash a devastating storm around yourself, dealing 66,279 Stormstrike damage every 1 sec to nearby enemies for 8 sec. Increases your chance to activate Windfury Weapon by 200%, and the damage of Windfury Weapon by 10%.
    elemental_assault         = {  80962, 210853, 2 }, -- Stormstrike damage is increased by 10%, and Stormstrike, Lava Lash, and Ice Strike have a 50% chance to generate 1 stack of Maelstrom Weapon.
    elemental_blast           = {  80966, 117014, 1 }, -- Harnesses the raw power of the elements, dealing 180,793 Elemental damage and increasing your Critical Strike or Haste by 3% or Mastery by 6% for 10 sec. If Lava Burst is known, Elemental Blast replaces Lava Burst and gains 1 additional charge.
    elemental_spirits         = {  80970, 262624, 1 }, -- Your Feral Spirits are now imbued with Fire, Frost, or Lightning, increasing your damage dealt with that element by 10%, but now only increase your Physical damage dealt by 10%.
    elemental_weapons         = {  80961, 384355, 1 }, -- Each active weapon imbue Increases all Fire, Frost, and Nature damage dealt by 2.5%.
    feral_spirit              = {  80972,  51533, 1 }, -- Summons two Spirit Wolves that aid you in battle for 15 sec. They are immune to movement-impairing effects, and each Feral Spirit summoned grants you 15% increased Physical damage dealt by your abilities. Feral Spirit generates one stack of Maelstrom Weapon immediately, and one stack every 3 sec for 15 sec.
    fire_nova                 = {  80944, 333974, 1 }, -- Erupt a burst of fiery damage from all targets affected by your Flame Shock, dealing 45,519 Flamestrike damage to up to 6 targets within 8 yds of your Flame Shock targets. Each eruption from Fire Nova generates 1 stack of Maelstrom Weapon.
    flowing_spirits           = {  80971, 469314, 1 }, -- Your damaging abilities have a 10% chance to summon a Feral Spirit for 8 sec.
    flurry                    = { 103642, 382888, 1 }, -- Increases your attack speed by 15% for your next 3 melee swings after dealing a critical strike with a spell or ability.
    forceful_winds            = {  80969, 262647, 1 }, -- Windfury causes each successive Windfury attack within 15 sec to increase the damage of Windfury by 15%, stacking up to 5 times.
    hailstorm                 = {  80944, 334195, 1 }, -- Each stack of Maelstrom Weapon consumed increases the damage of your next Frost Shock by 15%, and causes your next Frost Shock to hit 1 additional target per Maelstrom Weapon stack consumed, up to 5. Consuming at least 2 stacks of Hailstorm generates 1 stack of Maelstrom Weapon.
    hot_hand                  = {  80945, 201900, 2 }, -- Melee auto-attacks with Flametongue Weapon active have a 5% chance to reduce the cooldown of Lava Lash by 33% and increase the damage of Lava Lash by 15% for 8 sec.
    ice_strike                = {  80956, 470194, 1 }, -- Strike your target with an icy blade, dealing 286,978 Frost damage and snaring them by 50% for 6 sec. Ice Strike increases the damage of your next Frost Shock by 100% and generates 1 stack of Maelstrom Weapon.
    ice_strike_passive        = {  80956, 466467, 1 }, -- Whenever you spend Maelstrom Weapon, your Frost Shock has a chance to become Ice Strike. Ice Strike Strike your target with an icy blade, dealing 286,978 Frost damage and snaring them by 50% for 6 sec. Ice Strike increases the damage of your next Frost Shock by and generates 1 stack of Maelstrom Weapon. This ability has a 40 yard range.
    improved_maelstrom_weapon = {  80957, 383303, 1 }, -- Maelstrom Weapon now increases the damage of spells it affects by 20% per stack and the healing of spells it affects by 20% per stack.
    lashing_flames            = {  80948, 334046, 1 }, -- Lava Lash and Sundering increases the damage of Flame Shock on its target by 100% for 20 sec.
    lava_lash                 = {  80942,  60103, 1 }, -- Charges your off-hand weapon with lava and burns your target, dealing 123,154 Fire damage. Damage is increased by 100% if your offhand weapon is imbued with Flametongue Weapon. Lava Lash will spread Flame Shock from your target to 5 nearby targets.
    legacy_of_the_frost_witch = {  80951, 384450, 2 }, -- Consuming 10 stacks of Maelstrom Weapon will reset the cooldown of Stormstrike and increases the damage of your Physical and Frost abilities by 5% for 8 sec.
    maelstrom_weapon          = {  80941, 187880, 1 }, -- When you deal damage with a melee weapon, you have a chance to gain Maelstrom Weapon, stacking up to 10 times. Each stack of Maelstrom Weapon reduces the cast time of your next damage or healing spell by 20% and increase its damage by 25% or its healing by 25%. A maximum of 10 stacks of Maelstrom Weapon can be consumed at a time.
    molten_assault            = {  80943, 334033, 1 }, -- Lava Lash cooldown reduced by 6.0 sec, and if Lava Lash is used against a target affected by your Flame Shock, Flame Shock will be spread to up to 5 nearby enemies.
    molten_thunder            = { 103848, 469344, 1 }, -- The cooldown of Sundering is reduced by 10 sec, but it can no longer Incapacitate. Sundering has a 40% chance to reset its own cooldown, increased by 12% for up to 5 targets. Each consecutive reset reduces these chances by half.
    overflowing_maelstrom     = {  80938, 384149, 1 }, -- Your damage or healing spells will now consume up to 10 Maelstrom Weapon stacks.
    primordial_storm          = {  80963, 1218047, 1 }, -- Primordial Wave transforms into a single use Primordial Storm for 15 sec after it is cast. Primordial Storm Devastate nearby enemies with a Primordial Storm dealing 79,801 Flamestrike, 79,801 Froststrike, 79,801 Stormstrike damage, and unleashing a Lightning Bolt or a Chain Lightning at 150% effectiveness. Deals reduced damage beyond 5 targets. Consumes Maelstrom Weapon for increased damage.
    primordial_wave           = {  80965, 375982, 1 }, -- Blast all targets affected by your Flame Shock within 45 yards with a Primordial Wave, dealing 460,943 Elemental damage. Primordial Wave generates 5 stacks of Maelstrom Weapon.
    raging_maelstrom          = {  80939, 384143, 1 }, -- Maelstrom Weapon can now stack 5 additional times, and Maelstrom Weapon now increases the damage of spells it affects by an additional 5% per stack and the healing of spells it affects by an additional 5% per stack.
    splintered_elements       = {  80964, 382042, 2 }, -- Primordial Wave grants you 10% Haste plus 4% for each additional targets blasted by Primordial Wave for 12 sec.
    static_accumulation       = {  80950, 384411, 2 }, -- 10% chance to refund Maelstrom Weapon stacks spent on Lightning Bolt, Tempest, or Chain Lightning. While Ascendance is active, generate 1 Maelstrom Weapon stack every 1 sec.
    stormblast                = {  80960, 319930, 1 }, -- Stormstrike has an additional charge. Stormsurge now also causes your next Stormstrike to deal 25% additional damage as Nature damage, stacking up to 2 times.
    stormflurry               = {  80954, 344357, 1 }, -- Stormstrike has a 25% chance to strike the target an additional time for 40% of normal damage. This effect can chain off of itself.
    storms_wrath              = {  80967, 392352, 1 }, -- Increase the chance for Mastery: Enhanced Elements to trigger Windfury and Stormsurge by 150%.
    sundering                 = {  80975, 197214, 1 }, -- Shatters a line of earth in front of you with your main hand weapon, causing 193,251 Flamestrike damage and Incapacitating any enemy hit for 2 sec.
    swirling_maelstrom        = {  80955, 384359, 1 }, -- Consuming at least 2 stacks of Hailstorm, and each explosion from Fire Nova now also grants you 1 stack of Maelstrom Weapon.
    tempest_strikes           = {  80966, 428071, 1 }, -- Stormstrike, Ice Strike, and Lava Lash have a 100% chance to discharge electricity at your target, dealing 35,689 Nature damage.
    thorims_invocation        = {  80949, 384444, 1 }, -- Increases the damage of Lightning Bolt and Chain Lightning by 20%, and reduces the cooldown of Ascendance by 60 sec. While Ascendance is active, Windstrike automatically consumes up to 5 Maelstrom Weapon stacks to discharge a Lightning Bolt or Chain Lightning at 100% effectiveness at your enemy, whichever you most recently used.
    unrelenting_storms        = {  80973, 470490, 1 }, -- When Crash Lightning hits only 1 target, it activates Windfury Weapon and its cooldown is reduced by 40%.
    unruly_winds              = {  80968, 390288, 1 }, -- Windfury Weapon has a 100% chance to trigger a third attack.
    voltaic_blaze             = { 103871, 470053, 1 }, -- Tempest, Lightning Bolt and Chain Lightning have a high chance to make your next Flame Shock become Voltaic Blaze. Voltaic Blaze Instantly shocks the target and 5 nearby enemies with blazing thunder, causing 358,219 Nature damage and applying Flame Shock. Generates 1 stack of Maelstrom Weapon.
    windfury_weapon           = {  80958,  33757, 1 }, -- Imbue your main-hand weapon with the element of Wind for 1 |4hour:hrs;. Each main-hand attack has a 28% chance to trigger three extra attacks, dealing 21,471 Physical damage each. Windfury causes each successive Windfury attack within 15 sec to increase the damage of Windfury by 15%, stacking up to 5 times.
    witch_doctors_ancestry    = {  80971, 384447, 1 }, -- Increases the chance to gain a stack of Maelstrom Weapon by 4%, and whenever you gain a stack of Maelstrom Weapon, the cooldown of Feral Spirits is reduced by 1.0 sec.

    -- Totemic
    amplification_core        = {  94874, 445029, 1 }, -- While Surging Totem is active, your damage and healing done is increased by 3%.
    earthsurge                = {  94881, 455590, 1 }, -- Casting Sundering within 40 yards of your Surging Totem causes it to create a Tremor at 100% effectiveness at the target area.
    imbuement_mastery         = {  94871, 445028, 1 }, -- Increases the chance for Windfury Weapon to trigger by 5% and increases its damage by 8%. When Flametongue Weapon triggers from Windfury Weapon attacks, it has a chance to gather a whirl of flame around the target, dealing 300% of its damage to all nearby enemies.
    lively_totems             = {  94882, 445034, 1 }, -- Lava Lash has a chance to summon a Searing Totem to hurl Searing Bolts that deal 44,552 Fire damage to a nearby enemy. Lasts 8 sec. Frost Shocks empowered by Hailstorm, Lava Lash, and Fire Nova cause your Searing totems to shoot a Searing Volley at up to 5 nearby enemies for 85,541 Fire damage.
    oversized_totems          = {  94859, 445026, 1 }, -- Increases the size and radius of your totems by 15%, and the health of your totems by 30%.
    oversurge                 = {  94874, 445030, 1 }, -- Surging Totem deals 50% more damage during Ascendance.
    pulse_capacitor           = {  94866, 445032, 1 }, -- Increases the damage of Surging Totem by 25%.
    reactivity                = {  94872, 445035, 1 }, -- While Hot Hand is active Lash Lava shatters the earth, causing a Sundering at 50% effectiveness. Sunderings from this effect do not Incapacitate.
    supportive_imbuements     = {  94866, 445033, 1 }, -- Increases the critical strike chance of Flametongue Weapon by 25%, and its critical strike damage by 100%.
    surging_totem             = {  94877, 444995, 1, "totemic" }, -- Summons a totem at the target location that creates a Tremor immediately and every 5.1 sec for 122,862 Flamestrike damage. Damage reduced beyond 5 targets. Lasts 24 sec.
    swift_recall              = {  94859, 445027, 1 }, -- Successfully removing a harmful effect with Tremor Totem or Poison Cleansing Totem, or controlling an enemy with Capacitor Totem or Earthgrab Totem reduces the cooldown of the totem used by 5 sec. Cannot occur more than once every 20 sec per totem.
    totemic_coordination      = {  94881, 445036, 1 }, -- Increases the critical strike chance of your Searing Totem's attacks by 15%, and its critical strike damage by 30%.
    totemic_rebound           = {  94890, 445025, 1 }, -- Lightning Bolt, Chain Lightning and Elemental Blast has a chance to unleash a Surging Bolt at your Surging Totem, increasing the totem's damage by 10%, and then redirecting the bolt to your target for 81,575 Nature damage. The damage bonus effect can stack.
    whirling_elements         = {  94879, 445024, 1 }, -- Elemental motes orbit around your Surging Totem. Your abilities consume the motes for enhanced effects. Air: Your next Lightning Bolt, Chain Lightning or Elemental Blast unleashes 3 Surging Bolts at your Surging Totem. Earth: Direct damage of your next Flame Shock is increased by 300% and it is applied to 5 nearby enemies. Fire: Your next Lava Lash or Fire Nova grants you Hot Hands for 8 sec.
    wind_barrier              = {  94891, 445031, 1 }, -- If you have a totem active, your totem grants you a shield absorbing 300,925 damage for 30 sec every 30 sec.

    -- Stormbringer
    arc_discharge             = {  94885, 455096, 1 }, -- Tempest causes your next Chain Lightning or Lightning Bolt to be instant cast, deal 40% increased damage, and cast an additional time. Can accumulate up to 2 charges.
    awakening_storms          = {  94867, 455129, 1 }, -- Stormstrike, Lightning Bolt, and Chain Lightning have a chance to strike your target for 139,705 Nature damage. Every 3 times this occurs, your next Lightning Bolt is replaced by Tempest.
    conductive_energy         = {  94868, 455123, 1 }, -- Gain the effects of the Lightning Rod talent:  Lightning Rod Tempest, Lightning Bolt, Elemental Blast, Primordial Wave and Chain Lightning make your target a Lightning Rod for 8 sec. Lightning Rods take 10% of all damage you deal with Tempest, Lightning Bolt, and Chain Lightning.
    electroshock              = {  94863, 454022, 1 }, -- Tempest increases your movement speed by 20% for 5 sec.
    lightning_conduit         = {  94863, 467778, 1 }, -- You have a chance to get struck by lightning, increasing your movement speed by 50% for 5 sec. The effectiveness is increased to 100% in outdoor areas. You call down a Thunderstorm when you Reincarnate.
    natures_protection        = {  94880, 454027, 1 }, -- Lightning Shield reduces the damage you take by 3%.
    rolling_thunder           = {  94889, 454026, 1 }, -- Tempest summons a Nature Feral Spirit for 15 sec.
    storm_swell               = {  94873, 455088, 1 }, -- Tempest grants 10% Mastery for 6 sec.
    stormcaller               = {  94893, 454021, 1 }, -- Increases the critical strike chance of your Nature damage spells by 5% and the critical strike damage of your Nature spells by 5%.
    supercharge               = {  94873, 455110, 1 }, -- Lightning Bolt, Tempest, and Chain Lightning have a 35% chance to refund 2 Maelstrom Weapon stacks.
    surging_currents          = {  94880, 454372, 1 }, -- When you cast Tempest you gain Surging Currents, increasing the effectiveness of your next Chain Heal or Healing Surge by 20%, up to 100%.
    tempest                   = {  94892, 454009, 1, "stormbringer" }, -- Every 40 Maelstrom Weapon stacks spent replaces your next Lightning Bolt with Tempest.
    unlimited_power           = {  94886, 454391, 1 }, -- Spending Maelstrom Weapon stacks grants you 1% haste for 15 sec. Multiple applications may overlap.
    voltaic_surge             = {  94870, 454919, 1 }, -- Crash Lightning and Chain Lightning damage increased by 15%.
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    burrow              = 5575, -- (409293) Burrow beneath the ground, becoming unattackable, removing movement impairing effects, and increasing your movement speed by 50% for 5 sec. When the effect ends, enemies within 6 yards are knocked in the air and take 392,977 Physical damage.
    counterstrike_totem = 3489, -- (204331) Summons a totem at your feet for 15 sec. Whenever enemies within 23 yards of the totem deal direct damage, the totem will deal 100% of the damage dealt back to attacker.
    electrocute         = 5658, -- (206642)
    grounding_totem     = 3622, -- (204336) Summons a totem at your feet that will redirect all harmful spells cast within 34 yards on a nearby party or raid member to itself. Will not redirect area of effect spells. Lasts 3 sec.
    shamanism           =  722, -- (193876)
    static_field_totem  = 5438, -- (355580) Summons a totem with 4% of your health at the target location for 6 sec that forms a circuit of electricity that enemies cannot pass through.
    stormweaver         = 5596, -- (410673)
    totem_of_wrath      = 3487, -- (460697)
    unleash_shield      = 3492, -- (356736) Unleash your Elemental Shield's energy on an enemy target: Lightning Shield: Knocks them away. Earth Shield: Roots them in place for 2 sec. Water Shield: Summons a whirlpool for 6 sec, reducing damage and healing by 50% while they stand within it.
} )



-- Auras
spec:RegisterAuras( {
    -- Damage and healing increased by $w1%.
    amplification_core = {
        id = 456369,
        duration = 20.0,
        max_stack = 1,
    },
    -- Talent: A percentage of damage or healing dealt is copied as healing to up to 3 nearby injured party or raid members.
    -- https://wowhead.com/ptr-2/spell=108281
    --[[ancestral_guidance = {
        id = 108281,
        duration = 10,
        tick_time = 0.5,
        max_stack = 1
    },--]]
    -- Health increased by $s1%.    If you die, the protection of the ancestors will allow you to return to life.
    -- https://wowhead.com/ptr-2/spell=207498
    ancestral_protection = {
        id = 207498,
        duration = 30,
        max_stack = 1
    },
    -- Your next 1 Chain Lightning or Lightning Bolt spells are instant cast and will deal 40% increased damage.
    arc_discharge = {
        id = 470532,
        duration = 15.0,
        max_stack = 2
    },
    -- Movement speed reduced by $w1%.
    arctic_snowstorm = {
        id = 462765,
        duration = 8.0,
        max_stack = 1
    },
    -- Talent: Transformed into a powerful Air ascendant. Auto attacks have a $114089r yard range. Stormstrike is empowered and has a $114089r yard range.$?s384411[    Generating $384411s1 $lstack:stacks; of Maelstrom Weapon every $384437t1 sec.][]
    -- https://wowhead.com/ptr-2/spell=114051
    ascendance = {
        id = 114051,
        duration = 15,
        max_stack = 1
    },
    -- Talent: Damage of your next Lava Lash increased by $s1%.
    -- https://wowhead.com/ptr-2/spell=390371
    ashen_catalyst = {
        id = 390371,
        duration = 15,
        max_stack = 8
    },
    awakening_storms = {
        id = 462131,
        duration = 3600,
        max_stack = 4
    },
    -- Haste increased by $w1%.
    -- https://wowhead.com/ptr-2/spell=2825
    bloodlust = {
        id = 2825,
        duration = 40,
        max_stack = 1
    },
    -- When you deal damage, $w1% is dealt to your lowest health ally within $204331m2 yards.
    counterstrike_totem = {
        id = 208997,
        duration = 15.0,
        max_stack = 1,
    },
    -- Increases nature damage dealt from your abilities by $s1%.
    -- https://wowhead.com/ptr-2/spell=224127
    crackling_surge = {
        id = 224127,
        duration = 15,
        max_stack = 20,
        meta = {
            active = function( t ) return active_crackling_surges end,
        },
    },
    crash_lightning = {
        id = 187878,
        duration = 12,
        max_stack = 1
    },
    -- Talent: Damage of your next Crash Lightning increased by $s1%.
    -- https://wowhead.com/ptr-2/spell=333964
    cl_crash_lightning = {
        id = 333964,
        duration = 15,
        max_stack = 6,
        copy = "converging_storms"
    },
    -- Talent: Chance to activate Windfury Weapon increased to ${$319773h}.1%.  Damage dealt by Windfury Weapon increased by $s2%.
    -- https://wowhead.com/ptr-2/spell=384352
    doom_winds_talent = {
        id = 466772,
        duration = 8,
        max_stack = 1,
        copy = 384352
    },
    doom_winds_buff = { -- legendary.
        id = 335903,
        duration = 8,
        tick_time = 1,
        max_stack = 1,
    },
    doom_winds_debuff = {
        id = 335904,
        duration = 60,
        tick_time = 1,
        max_stack = 1,
        copy = "doom_winds_cd",
    },
    doom_winds = {
        alias = { "doom_winds_talent", "doom_winds_buff" },
        aliasMode = "first",
        aliasType = "buff",
        duration = 8,
        max_stack = 1,
    },
    -- Maximum health increased by $w3%.
    downpour = {
        id = 207778,
        duration = 6.0,
        max_stack = 1
    },
    -- Talent:
    -- https://wowhead.com/ptr-2/spell=198103
    earth_elemental = {
        id = 198103,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Heals for ${$w2*(1+$w1/100)} upon taking damage.
    -- https://wowhead.com/ptr-2/spell=974
    earth_shield = {
        id = 974,
        duration = 600,
        type = "Magic",
        max_stack = 9
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/ptr-2/spell=3600
    earthbind = {
        id = 3600,
        duration = 5,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    -- Increases physical damage dealt from your abilities by $s1%.
    -- https://wowhead.com/ptr-2/spell=392375
    earthen_weapon = {
        id = 392375,
        duration = 15,
        type = "Magic",
        max_stack = 20,
        meta = {
            active = function( t ) return active_earthen_weapons end,
        },
    },
    -- Rooted.
    -- https://wowhead.com/ptr-2/spell=64695
    earthgrab = {
        id = 64695,
        duration = 8,
        mechanic = "root",
        type = "Magic",
        max_stack = 1
    },
    -- Heals $w1 every $t1 sec.
    -- https://wowhead.com/ptr-2/spell=382024
    earthliving_weapon = {
        id = 382024,
        duration = 12,
        max_stack = 1
    },
    -- Your next damage or healing spell will be cast a second time ${$s2/1000}.1 sec later for free.
    -- https://wowhead.com/ptr-2/spell=320125
    echoing_shock = {
        id = 320125,
        duration = 8,
        type = "Magic",
        max_stack = 1
    },
    -- $w1 Nature damage every $t1 sec.
    electrocute = {
        id = 206647,
        duration = 3.0,
        tick_time = 1.0,
        pandemic = true,
        max_stack = 1,
    },
    -- Movement speed increased by $w1%.
    electroshock = {
        id = 454025,
        duration = 5.0,
        max_stack = 1
    },
    -- Fire, Frost, and Nature damage taken reduced by $w1%.
    elemental_resistance = {
        id = 462568,
        duration = 3.0,
        pandemic = true,
        max_stack = 1,
    },
    -- Cannot move while using Far Sight.
    -- https://wowhead.com/ptr-2/spell=6196
    far_sight = {
        id = 6196,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Generating $s1 stack of Maelstrom Weapon every $t1 sec.
    -- https://wowhead.com/ptr-2/spell=333957
    feral_spirit = {
        id = 333957,
        duration = 15,
        tick_time = 3,
        max_stack = 20,
        meta = {
            active = function( t ) return active_feral_spirits end,
        },
        copy = 469328,
    },
    -- Suffering $w2 Fire damage every $t2 sec.
    -- https://wowhead.com/ptr-2/spell=188389
    flame_shock = {
        id = 188389,
        duration = 18,
        tick_time = 2.0,
        pandemic = true,
        type = "Magic",
        max_stack = 1
    },
    -- Each of your weapon attacks causes up to ${$max(($<coeff>*$AP),1)} additional Fire damage.
    -- https://wowhead.com/ptr-2/spell=319778
    flametongue_weapon = {
        duration = 3600,
        max_stack = 1
    },
    -- Talent: Attack speed increased by $w1%.
    -- https://wowhead.com/ptr-2/spell=382889
    flurry = {
        id = 382889,
        duration = 15,
        max_stack = 3
    },
    -- Talent: Movement speed reduced by $s2%.
    -- https://wowhead.com/ptr-2/spell=196840
    frost_shock = {
        id = 196840,
        duration = function() return 6 + 2 * talent.encasing_cold.rank end,
        type = "Magic",
        max_stack = 1
    },
    converging_storms = {
        id = 198300,
        duration = 12,
        max_stack = 6,
    },
    -- Increases movement speed by $?s382215[${$382216s1+$w2}][$w2]%.$?$w3!=0[  Less hindered by effects that reduce movement speed.][]
    -- https://wowhead.com/ptr-2/spell=2645
    ghost_wolf = {
        id = 2645,
        duration = 3600,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Your next Frost Shock will deal $s1% additional damage, and hit up to ${$334195s1/$s2} additional $Ltarget:targets;.
    -- https://wowhead.com/ptr-2/spell=334196
    hailstorm = {
        id = 334196,
        duration = 20,
        max_stack = 5
    },
    -- Your Healing Rain is currently active.  $?$w1!=0[Magic damage taken reduced by $w1%.][]
    -- https://wowhead.com/ptr-2/spell=73920
    healing_rain = {
        id = 73920,
        duration = 10,
        max_stack = 1
    },
    -- Healing $?s147074[two injured party or raid members][an injured party or raid member] every $t1 sec.
    -- https://wowhead.com/ptr-2/spell=5672
    healing_stream = {
        id = 5672,
        duration = 15,
        tick_time = 2,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Incapacitated.
    -- https://wowhead.com/ptr-2/spell=51514
    hex = {
        id = 51514,
        duration = 60,
        mechanic = "polymorph",
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Lava Lash damage increased by $s1% and cooldown reduced by ${$s2/4}%.
    -- https://wowhead.com/ptr-2/spell=215785
    hot_hand = {
        id = 215785,
        duration = 6,
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $s2%.
    -- https://wowhead.com/ptr-2/spell=342240
    ice_strike_snare = {
        id = 342240,
        duration = 6,
        max_stack = 1,
    },
    -- Talent: Damage of your next Frost Shock increased by $s1%.
    -- https://wowhead.com/ptr-2/spell=384357
    ice_strike = {
        id = 384357,
        duration = 12,
        max_stack = 1
    },
    -- Frost Shock damage increased by $w2%.
    -- https://wowhead.com/ptr-2/spell=210714
    icefury = {
        id = 210714,
        duration = 25,
        type = "Magic",
        max_stack = 4
    },
    -- Increases frost damage dealt from your abilities by $s1%.
    -- https://wowhead.com/ptr-2/spell=224126
    icy_edge = {
        id = 224126,
        duration = 15,
        max_stack = 20,
        meta = {
            active = function( t ) return active_icy_edges end,
        },
    },
    -- Fire damage inflicted every $t2 sec.
    -- https://wowhead.com/ptr-2/spell=118297
    immolate = {
        id = 118297,
        duration = 21,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Damage taken from the Shaman's Flame Shock increased by $s1%.
    -- https://wowhead.com/ptr-2/spell=334168
    lashing_flames = {
        id = 334168,
        duration = 20,
        max_stack = 1
    },
    -- Talent: Damage dealt by your physical abilities increased by $w1%.
    -- https://wowhead.com/ptr-2/spell=384451
    legacy_of_the_frost_witch = {
        id = 384451,
        duration = 8,
        max_stack = 1
    },
    -- Talent: Stunned. Suffering $w1 Nature damage every $t1 sec.
    -- https://wowhead.com/ptr-2/spell=305485
    lightning_lasso = {
        id = 305485,
        duration = 5,
        tick_time = 1,
        mechanic = "stun",
        type = "Magic",
        max_stack = 1
    },
    -- Casting Shaman's Lightning Bolt and Chain Lightning also deal $210689s2% of their damage to the Lightning Rod.
    lightning_rod = {
        id = 197209,
        duration = 8.0,
        max_stack = 1,
    },
    -- Chance to deal $192109s1 Nature damage when you take melee damage$?a137041[ and have a $s3% chance to generate a stack of Maelstrom Weapon]?a137040[ and have a $s4% chance to generate $s5 Maelstrom][].
    -- https://wowhead.com/ptr-2/spell=192106
    lightning_shield = {
        id = 192106,
        duration = 1800,
        max_stack = 1
    },
    -- Searing Totem is hurling Searing Bolts at nearby enemies.
    lively_totems = {
        id = 461242,
        duration = 8.0,
        max_stack = 1,
    },
    -- Talent: Your next damage or healing spell has its cast time reduced by ${$max($187881s1, -100)*-1}%$?s383303[ and damage or healing increased by][]$?s383303&!s384149[ ${$min($187881w2, 5*$s~2)}%]?s383303&s384149[ $187881w2%][].
    -- https://wowhead.com/ptr-2/spell=344179
    maelstrom_weapon = {
        id = 344179,
        duration = 30,
        type = "Magic",
        max_stack = function() return talent.raging_maelstrom.enabled and 10 or 5 end
    },
    -- Increases fire damage dealt from your abilities by $s1%.
    -- https://wowhead.com/ptr-2/spell=224125
    molten_weapon = {
        id = 224125,
        duration = 15,
        type = "Magic",
        max_stack = 20,
        meta = {
            active = function( t ) return active_molten_weapons end,
        },
    },
    -- Talent: Your next healing or damaging Nature spell is instant cast and costs no mana.
    -- https://wowhead.com/ptr-2/spell=378081
    natures_swiftness = {
        id = 378081,
        duration = 3600,
        type = "Magic",
        max_stack = 1,
        onRemove = function( t )
            -- 20221117:  This function is triggered when the buff is removed.
            setCooldown( "natures_swiftness", action.natures_swiftness.cooldown )
        end
    },
    -- Heals $w1 damage every $t1 seconds.
    -- https://wowhead.com/ptr-2/spell=280205
    pack_spirit = {
        id = 280205,
        duration = 3600,
        max_stack = 1
    },
    -- Cleansing $383015s1 poison effect from a nearby party or raid member every $t1 sec.
    -- https://wowhead.com/ptr-2/spell=383014
    poison_cleansing = {
        id = 383014,
        duration = function() return 6 + 3 * talent.tidecallers_guard.rank end,
        tick_time = 1.5,
        type = "Magic",
        max_stack = 1
    },
    primal_lava_actuators = {
        id = 335896,
        duration = 15,
        max_stack = 20,
    },
    -- https://www.wowhead.com/spell=1218125
    -- Primordial Storm Primordial Wave has been replaced by Primordial Storm.
    primordial_storm = {
        id = 1218125,
        duration = 15,
        max_stack = 1,
    },
    primordial_wave = {
        id = 375986,
        duration = 10,
        max_stack = 1,
        copy = 327164
    },
    -- Heals $w2 every $t2 seconds.
    -- https://wowhead.com/ptr-2/spell=61295
    riptide = {
        id = 61295,
        duration = 18,
        type = "Magic",
        max_stack = 1
    },
    -- Mastery increased by $w1% and auto attacks have a $h% chance to instantly strike again.
    skyfury = {
        id = 462854,
        duration = 3600.0,
        max_stack = 1,
        shared = "player",
        dot = "buff"
    },
    -- Talent: Increases movement speed by $s1%.
    -- https://wowhead.com/ptr-2/spell=58875
    spirit_walk = {
        id = 58875,
        duration = 8,
        max_stack = 1
    },
    -- Talent: Able to move while casting all Shaman spells.
    -- https://wowhead.com/ptr-2/spell=79206
    spiritwalkers_grace = {
        id = 79206,
        duration = 15,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Stunned.
    -- https://wowhead.com/ptr-2/spell=118905
    static_charge = {
        id = 118905,
        duration = 3,
        mechanic = "stun",
        type = "Magic",
        max_stack = 1
    },
    -- Absorbing up to $w1 damage.
    stone_bulwark = {
        id = 114893,
        duration = 15,
        max_stack = 1,
    },
    -- Mastery increased by $w1%.
    storm_swell = {
        id = 455089,
        duration = 6.0,
        max_stack = 1,
    },
    -- Your next Stormstrike deals $s1% additional damage as Nature damage.
    stormblast = {
        id = 470466,
        duration = 12,
        max_stack = 1,
    },
    -- Your next Lightning Bolt or Chain Lightning will deal $s2% increased damage and be instant cast.
    -- https://wowhead.com/ptr-2/spell=383009
    stormkeeper = {
        id = 383009,
        duration = 15,
        type = "Magic",
        max_stack = 2,
        copy = 320137
    },
    -- Stormstrike cooldown has been reset$?$?a319930[ and will deal $319930w1% additional damage as Nature][].
    stormsurge = {
        id = 201846,
        duration = 12.0,
        max_stack = 1,
    },
    -- Talent: Incapacitated.
    -- https://wowhead.com/ptr-2/spell=197214
    sundering = {
        id = 197214,
        duration = 2,
        max_stack = 1
    },
    -- Your next Chain Heal or Healing Surge will be instant and consume no mana.
    surging_currents = {
        id = 454376,
        duration = 30.0,
        max_stack = 1,
    },
    -- Talent: Tempest
    -- https://www.wowhead.com/spell=454015/tempest
    tempest = {
        id = 454015,
        duration = 30.0,
        max_stack = 2,
        copy = { 454009, 452201 }
    },
    -- Talent: Movement speed increased by $378075s1%.
    -- https://wowhead.com/ptr-2/spell=378076
    thunderous_paws = {
        id = 378076,
        duration = 3,
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $s3%.
    -- https://wowhead.com/ptr-2/spell=51490
    thunderstorm = {
        id = 51490,
        duration = 5,
        type = "Magic",
        max_stack = 1
    },
    -- Your healing done is increased by $w2%.; $?a157153[Cloudburst][Healing Stream] Totem lasts an additional ${$w1/1000} sec.
    tidecallers_guard = {
        id = 457496,
        duration = 3600.0,
        max_stack = 1,

    },
    -- Healing and spell critical effect increased by $w1%.
    totem_of_wrath = {
        id = 208963,
        duration = 15.0,
        max_stack = 1,
    },
    totemic_rebound = {
        id = 458269,
        duration = 25,
        max_stack = 20
    },
    -- Your next healing spell has increased effectiveness.
    -- https://wowhead.com/ptr-2/spell=73685
    unleash_life = {
        id = 73685,
        duration = 10,
        type = "Magic",
        max_stack = 1
    },
    -- Haste increased by $s1%.
    unlimited_power = {
        id = 454394,
        duration = 15.0,
        max_stack = 1,
    },
    voltaic_blaze = {
        id = 470058,
        duration = 20,
        max_stack = 1
    },
    -- Allows walking over water.
    water_walking = {
        id = 546,
        duration = 600.0,
        max_stack = 1,
    },
    whirling_air = {
        id = 453409,
        duration = 24,
        max_stack = 1
    },
    whirling_earth = {
        id = 453406,
        duration = 24,
        max_stack = 1
    },
    whirling_fire = {
        id = 453405,
        duration = 24,
        max_stack = 1
    },
    -- Absorbs $w1 damage.
    wind_barrier = {
        id = 457387,
        duration = 30.0,
        max_stack = 1,
    },
    -- Movement speed increased by $w1%.
    wind_rush = {
        id = 192082,
        duration = function() return 5.0 + 2 * talent.ascending_air.rank end,
        max_stack = 1
    },
    windfury_weapon = {
        duration = 3600,
        max_stack = 1,
    },


    chains_of_devastation_cl = {
        id = 336736,
        duration = 20,
        max_stack = 1,
    },
    chains_of_devastation_ch = {
        id = 336737,
        duration = 20,
        max_stack = 1
    },
} )

spec:RegisterStateTable( "feral_spirit", setmetatable( {}, {
    __index = function( t, k )
        return buff.feral_spirit[ k ]
    end
} ) )

spec:RegisterStateTable( "twisting_nether", setmetatable( { onReset = function( self ) end }, {
    __index = function( t, k )
        if k == "count" then
            return ( buff.fire_of_the_twisting_nether.up and 1 or 0 ) + ( buff.chill_of_the_twisting_nether.up and 1 or 0 ) + ( buff.shock_of_the_twisting_nether.up and 1 or 0 )
        end

        return 0
    end
} ) )

local death_events = {
    UNIT_DIED               = true,
    UNIT_DESTROYED          = true,
    UNIT_DISSIPATES         = true,
    PARTY_KILL              = true,
    SPELL_INSTAKILL         = true,
}

local vesper_heal = 0
local vesper_damage = 0
local vesper_used = 0

local vesper_expires = 0
local vesper_guid
local vesper_last_proc = 0

local last_totem_actual = 0

local recall_totems = {
    capacitor_totem = 1,
    earthbind_totem = 1,
    earthgrab_totem = 1,
    grounding_totem = 1,
    healing_stream_totem = 1,
    liquid_magma_totem = 1,
    poison_cleansing_totem = 1,
    skyfury_totem = 1,
    stoneskin_totem = 1,
    tranquil_air_totem = 1,
    tremor_totem = 1,
    wind_rush_totem = 1,
}

local recallTotem1
local recallTotem2
local tiWindow, tiSpell, tiTarget = 0, "lightning_bolt", nil
local recent_spell_hits = {}
local actual_spirits, virtual_spirits = {}, {}
local molten_weapons, virtual_molten_weapons = {}, {}
local icy_edges, virtual_icy_edges = {}, {}
local crackling_surges, virtual_crackling_surges = {}, {}
local earthen_weapons, virtual_earthen_weapons = {}, {}

spec:RegisterCombatLogEvent( function( _, subtype, _,  sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName )
    -- Deaths/despawns.
    if death_events[ subtype ] and destGUID == vesper_guid then
        vesper_guid = nil
        return
    end

    if sourceGUID == state.GUID then
        -- Summons.
        if subtype == "SPELL_SUMMON" then
            if spellID == 262627 or spellID == 426516 then
                actual_spirits[ destGUID ] = {
                    expires = GetTime() + ( state.talent.flowing_spirits.enabled and 8 or 15 ),
                    alpha_expires = 0
                }

                C_Timer.After( ( state.talent.flowing_spirits.enabled and 8 or 15 ), function()
                    actual_spirits[ destGUID ] = nil
                end )

            elseif spellID == 469328 then
                actual_spirits[ destGUID ] = {
                    expires = GetTime() + 8,
                    alpha_expires = 0
                }

                C_Timer.After( 8, function()
                    actual_spirits[ destGUID ] = nil
                end )

            elseif spellID == 324386 then
                vesper_guid = destGUID
                vesper_expires = GetTime() + 30

                vesper_heal = 3
                vesper_damage = 3
                vesper_used = 0
            end

        -- For any Maelstrom Weapon changes, force an immediate update for responsiveness.
        elseif spellID == 344179 then
            Hekili:ForceUpdate( subtype, true )

        elseif state.talent.alpha_wolf.enabled and ( spellID == 187874 or spellID == 188443 ) then
            local expires = GetTime() + 8

            for k, v in pairs( actual_spirits ) do
                v.alpha_expires = expires
            end

            -- Vesper Totem heal
        elseif spellID == 324522 then
            local now = GetTime()

            if vesper_last_proc + 0.75 < now then
                vesper_last_proc = now
                vesper_used = vesper_used + 1
                vesper_heal = vesper_heal - 1
            end

        -- Vesper Totem damage; only fires on SPELL_DAMAGE...
        elseif spellID == 324520 then
            local now = GetTime()

            if vesper_last_proc + 0.75 < now then
                vesper_last_proc = now
                vesper_used = vesper_used + 1
                vesper_damage = vesper_damage - 1
            end

        end

        if state.talent.thorims_invocation.enabled and subtype == "SPELL_DAMAGE" and ( spellID == 188196 or spellID == 452201 or spellID == 188443 ) then

            -- Chain Lightning ALWAYS sets tiSpell to "chain_lightning"
            if spellID == 188443 then
                tiSpell = "chain_lightning"
                return
            end

            -- timestamp not needed if it's a chain lightning, declare after
            local now = GetTime()

            if now > tiWindow then -- "if this is a new window"
                tiWindow = GetTime() + 0.5 -- Window closure time
                tiSpell = "lightning_bolt" -- We can set to Lightning Bolt since we're at target count = 1 for now.
                tiTarget = destGUID -- To count the next target, we just need to know it wasn't this guy.
                return
            end

            -- If we're here, we're inside an active Thorim's log collection window of 0.5s.
            -- If this is hit # 3 - 99999 of the same window it doesn't matter
            if tiSpell == "chain_lightning" then return end

            -- Otherwise, check if this is a new enemy
            if destGUID ~= tiTarget then
                tiSpell = "chain_lightning" -- If so, it must be an aoe CL or tempset, and so thorims is primed to CL
                return
             end
        end

        if subtype == "SPELL_CAST_SUCCESS" then
            -- Reset in case we need to deal with an instant after a hardcast.
            vesper_last_proc = 0

            local ability = class.abilities[ spellID ]
            local key = ability and ability.key

            if key and recall_totems[ key ] then
                recallTotem2 = recallTotem1
                recallTotem1 = key
            end
        end
    end

    if destGUID == state.GUID and ( subtype == "SPELL_AURA_APPLIED" or subtype == "SPELL_AURA_REFRESH" ) then
        if spellID == 224125 then
            insert( molten_weapons, {
                expires = GetTime() + ( state.talent.flowing_spirits.enabled and 8 or 15 )
            } )

        elseif spellID == 224126 then
            insert( icy_edges, {
                expires = GetTime() + ( state.talent.flowing_spirits.enabled and 8 or 15 )
            } )

        elseif spellID == 224127 then
            insert( crackling_surges, {
                expires = GetTime() + ( state.talent.flowing_spirits.enabled and 8 or 15 )
            } )

        elseif spellID == 392375 then
            insert( earthen_weapons, {
                expires = GetTime() + ( state.talent.flowing_spirits.enabled and 8 or 15 )
            } )

        end
    end

end )

spec:RegisterStateExpr( "vesper_totem_heal_charges", function()
    return vesper_heal
end )

spec:RegisterStateExpr( "vesper_totem_dmg_charges", function ()
    return vesper_damage
end )

spec:RegisterStateExpr( "vesper_totem_used_charges", function ()
    return vesper_used
end )

spec:RegisterStateFunction( "trigger_vesper_heal", function ()
    if vesper_totem_heal_charges > 0 then
        vesper_totem_heal_charges = vesper_totem_heal_charges - 1
        vesper_totem_used_charges = vesper_totem_used_charges + 1
    end
end )

spec:RegisterStateFunction( "trigger_vesper_damage", function ()
    if vesper_totem_dmg_charges > 0 then
        vesper_totem_dmg_charges = vesper_totem_dmg_charges - 1
        vesper_totem_used_charges = vesper_totem_used_charges + 1
    end
end )

spec:RegisterStateExpr( "active_feral_spirits", function()
    local count = 0

    for _, v in pairs( virtual_spirits ) do
        if v.expires > query_time then count = count + 1 end
    end

    return count
end )

spec:RegisterStateExpr( "alpha_wolf_min_remains", function()
    local minimum

    for _, v in pairs( virtual_spirits ) do
        if v.expires > query_time then
            local remains = max( 0, v.alpha_expires - query_time )
            if remains == 0 then return 0 end
            if not minimum then minimum = remains
            else minimum = min( minimum, remains ) end
        end
    end

    return minimum or 0
end )

spec:RegisterStateExpr( "active_molten_weapons", function()
    local count = 0

    for _, v in pairs( virtual_molten_weapons ) do
        if v > query_time then count = count + 1 end
    end

    return count
end )

spec:RegisterStateExpr( "active_icy_edges", function()
    local count = 0

    for _, v in pairs( virtual_icy_edges ) do
        if v > query_time then count = count + 1 end
    end

    return count
end )

spec:RegisterStateExpr( "active_crackling_surges", function()
    local count = 0

    for _, v in pairs( virtual_crackling_surges ) do
        if v > query_time then count = count + 1 end
    end

    return count
end )

spec:RegisterStateExpr( "active_earthen_weapons", function()
    local count = 0

    for _, v in pairs( virtual_earthen_weapons ) do
        if v > query_time then count = count + 1 end
    end

    return count
end )

local TriggerFeralMaelstrom = setfenv( function()
    gain_maelstrom( 1 )
end, state )

local TriggerStaticAccumulation = setfenv( function()
    gain_maelstrom( 1 )
end, state )

spec:RegisterStateExpr( "ti_mode", function ()
    return tiSpell
end)

spec:RegisterStateExpr( "ti_lightning_bolt", function ()
    return ti_mode == "lightning_bolt"
end)

spec:RegisterStateExpr( "ti_chain_lightning", function ()
    return ti_mode == "chain_lightning"
end)

spec:RegisterStateExpr( "tempest_mael_count", function ()
    return GetSpellCastCount( class.abilities.tempest.id )
end )

spec:RegisterStateExpr( "time_since_tr", function ()
    return max( action.stormstrike.time_since, action.windstrike.time_since )
end )

spec:RegisterStateExpr( "time_since_as", function ()
    return max( action.stormstrike.time_since, action.windstrike.time_since, action.lightning_bolt.time_since, action.tempest.time_since, action.chain_lightning.time_since )
end )


spec:RegisterHook( "reset_precast", function ()
    tempest_mael_count = nil

    local mh, _, _, mh_enchant, oh, _, _, oh_enchant = GetWeaponEnchantInfo()

    if mh and mh_enchant == 5401 then applyBuff( "windfury_weapon" ) end
    if oh and oh_enchant == 5400 then applyBuff( "flametongue_weapon" ) end

    if buff.windfury_weapon.down and ( now - action.windfury_weapon.lastCast < 1 ) then applyBuff( "windfury_weapon" ) end
    if buff.flametongue_weapon.down and ( now - action.flametongue_weapon.lastCast < 1 ) then applyBuff( "flametongue_weapon" ) end

    if settings.pad_windstrike and cooldown.windstrike.remains > 0 and buff.ascendance.up then
        reduceCooldown( "windstrike", latency * 2 )
    end

    if settings.pad_lava_lash and cooldown.lava_lash.remains > 0 and buff.hot_hand.up then
        reduceCooldown( "lava_lash", latency * 2 )
    end

    local tick = dot.flame_shock.next_tick + 0.1
    if talent.ashen_catalyst.enabled and dot.flame_shock.ticking and cooldown.lava_lash.remains > 0.25 then
        local original = cooldown.lava_lash.remains

        while( tick < cooldown.lava_lash.expires ) do
            reduceCooldown( "lava_lash", min( cooldown.lava_lash.expires - tick, active_dot.flame_shock * 0.5 ) )
            -- addStack( "ashen_catalyst", nil, active_dot.flame_shock )
            tick = tick + dot.flame_shock.tick_time
        end

        if Hekili.ActiveDebug then Hekili:Debug( "[Ashen Catalyst] Lava Lash cooldown reduced from %.2f to %.2f.", original, cooldown.lava_lash.remains ) end
    end

    if talent.ascendance.enabled and buff.ascendance.up then
        setCooldown( "ascendance", buff.ascendance.applied + ( talent.thorims_invocation.enabled and 120 or 180 ) - now )
    end

    if vesper_expires > 0 and now > vesper_expires then
        vesper_expires = 0
        vesper_heal = 0
        vesper_damage = 0
        vesper_used = 0
    end

    vesper_totem_heal_charges = 0
    vesper_totem_dmg_charges = 0
    vesper_totem_used_charges = 0

    if totem.vesper_totem.up then
        applyBuff( "vesper_totem", totem.vesper_totem.remains )
    end

    if buff.feral_spirit.up then
        --[[ local next_mw = query_time + 3 - ( ( query_time - buff.feral_spirit.applied ) % 3 )

        while ( next_mw <= buff.feral_spirit.expires ) do
            state:QueueAuraEvent( "feral_maelstrom", TriggerFeralMaelstrom, next_mw, "AURA_PERIODIC" )
            next_mw = next_mw + 3
        end ]]

        if talent.alpha_wolf.enabled then
            local last_trigger = max( action.chain_lightning.lastCast, action.crash_lightning.lastCast )

            if last_trigger > buff.feral_spirit.applied then
                applyBuff( "alpha_wolf", last_trigger + 8 - now )
            end
        end
    end

    wipe( virtual_spirits )
    for k, v in pairs( actual_spirits ) do
        if v.expires > now then
            virtual_spirits[ k ] = {
                expires = v.expires,
                alpha_expires = v.alpha_expires
            }
        else
            virtual_spirits[ k ] = nil
        end
    end

    wipe( virtual_molten_weapons )
    for k, v in pairs( molten_weapons ) do
        if v.expires > now then
            virtual_molten_weapons[ k ] = v.expires
        else
            molten_weapons[ k ] = nil
        end
    end

    wipe( virtual_icy_edges )
    for k, v in pairs( icy_edges ) do
        if v.expires > now then
            virtual_icy_edges[ k ] = v.expires
        else
            icy_edges[ k ] = nil
        end
    end

    wipe( virtual_crackling_surges )
    for k, v in pairs( crackling_surges ) do
        if v.expires > now then
            virtual_crackling_surges[ k ] = v.expires
        else
            crackling_surges[ k ] = nil
        end
    end

    wipe( virtual_earthen_weapons )
    for k, v in pairs( earthen_weapons ) do
        if v.expires > now then
            virtual_earthen_weapons[ k ] = v.expires
        else
            earthen_weapons[ k ] = nil
        end
    end

    if Hekili.ActiveDebug then
        if active_feral_spirits > 0 then Hekili:Debug( "Feral Spirits: " .. active_feral_spirits ) end
        if active_molten_weapons > 0 then Hekili:Debug( "Molten Weapons: " .. active_molten_weapons ) end
        if active_icy_edges > 0 then Hekili:Debug( "Icy Edges: " .. active_icy_edges ) end
        if active_crackling_surges > 0 then Hekili:Debug( "Crackling Surges: " .. active_crackling_surges ) end
        if active_earthen_weapons > 0 then Hekili:Debug( "Earthen Weapons: " .. active_earthen_weapons ) end
    end

    --[[ if buff.ascendance.up and talent.static_accumulation.enabled then
        local next_mw = query_time + 1 - ( ( query_time - buff.ascendance.applied ) % 1 )

        while ( next_mw <= buff.ascendance.expires ) do
            state:QueueAuraEvent( "ascendance_maelstrom", TriggerStaticAccumulation, next_mw, "AURA_PERIODIC" )
            next_mw = next_mw + 1
        end
    end ]]

    ti_mode = tiSpell -- Sync with CLEU every recommendation set

    rawset( buff, "doom_winds_debuff", debuff.doom_winds_debuff )
    rawset( buff, "doom_winds_cd", debuff.doom_winds_debuff )

    if totem.surging_totem.remains > cooldown.surging_totem.remains then setCooldown( "surging_totem", totem.surging_totem.remains ) end
end )


local ancestral_wolf_affinity_spells = {
    cleanse_spirit = 1,
    wind_shear = 1,
    purge = 1,
    -- TODO: List totems?
}

spec:RegisterStateExpr( "recall_totem_1", function()
    return recallTotem1
end )

spec:RegisterStateExpr( "recall_totem_2", function()
    return recallTotem2
end )

spec:RegisterHook( "runHandler", function( action )
    if buff.ghost_wolf.up then
        if talent.ancestral_wolf_affinity.enabled then
            local ability = class.abilities[ action ]
            if not ancestral_wolf_affinity_spells[ action ] and not ability.gcd == "totem" then
                removeBuff( "ghost_wolf" )
                removeBuff( "spirit_wolf" )
            end
        else
            removeBuff( "ghost_wolf" )
            removeBuff( "spirit_wolf" )
        end
    end

    if talent.totemic_recall.enabled and recall_totems[ action ] then
        recall_totem_2 = recall_totem_1
        recall_totem_1 = action
    end
end )


spec:RegisterGear({
    tww2 = {
        items = { 229260, 229261, 229262, 229263, 229265 },
        auras = {
            -- https://www.wowhead.com/spell=1218616
            -- Winning Streak! Stormstrike, Lava Lash and Doom Winds damage increased by 5.0%.
            winning_streak = {
                id = 1218616,
                duration = 30,
                max_stack = 5
            },
            -- https://www.wowhead.com/spell=1223410
            -- Electrostatic Wager Crash Lightning damage increased by 120%.
            electrostatic_wager = {
                id = 1223410,
                duration = 30,
                max_stack = 10,
            },
        }
    },
    tier29 = {
        items = { 200396, 200398, 200400, 200401, 200399 },
        auras = {
            maelstrom_of_elements = {
                id = 394677,
                duration = 15,
                max_stack = 1
            },
            fury_of_the_storm = {
                id = 396006,
                duration = 3,
                max_stack = 10
            }
        }
    },
    tier30 = {
        items = { 202473, 202471, 202470, 202469, 202468 },
        auras = {
            earthen_might = {
                id = 409689,
                duration = 15,
                max_stack = 1,
                copy = "t30_2pc_enh"
            },
            volcanic_strength = {
                id = 409833,
                duration = 15,
                max_stack = 1,
                copy = "t30_4pc_enh_damage"
            },
            crackling_thunder = {
                id = 409834,
                duration = 15,
                max_stack = 2,
                copy = "t30_4pc_enh_cl"
            }
        }
    },
    tier31 = {
        items = { 207207, 207208, 207209, 207210, 207212, 217238, 217240, 217236, 217237, 217239 },
    },
    waycrest_legacy = {
        items = { 158362, 159631 },
    },
    electric_mail = {
        items = { 161031, 161034, 161032, 161033, 161035 },
    }
} )


spec:RegisterStateFunction( "consume_maelstrom", function( cap )
    local stacks = min( buff.maelstrom_weapon.stack, cap or ( talent.overflowing_maelstrom.enabled and 10 or 5 ) )

    if talent.hailstorm.enabled and stacks > buff.hailstorm.stack then
        applyBuff( "hailstorm", nil, stacks )
    end

    removeStack( "maelstrom_weapon", stacks )
    if set_bonus.tier29_4pc > 0 then addStack( "fury_of_the_storm", nil, stacks ) end

    -- TODO: Have to actually track consumed MW stacks.
    if legendary.legacy_oF_the_frost_witch.enabled and stacks > 4 or talent.legacy_of_the_frost_witch.enabled and stacks > 9 then
        setCooldown( "stormstrike", 0 )
        setCooldown( "windstrike", 0 )
        applyBuff( "legacy_of_the_frost_witch" )
    end
end )

spec:RegisterStateFunction( "gain_maelstrom", function( stacks )
    if talent.witch_doctors_ancestry.enabled and not action.feral_spirit.disabled then
        reduceCooldown( "feral_spirit", stacks * talent.witch_doctors_ancestry.rank )
    end

    addStack( "maelstrom_weapon", nil, stacks )
end )

spec:RegisterStateFunction( "maelstrom_mod", function( amount )
    local mod = max( 0, 1 - ( 0.2 * buff.maelstrom_weapon.stack ) )
    return mod * amount
end )

spec:RegisterTotems( {
    skyfury_totem = {
        id = 135829
    },
    counterstrike_totem = {
        id = 511726
    },
    poison_cleansing_totem = {
        id = 136070
    },
    stoneskin_totem = {
        id = 4667425
    },
} )

-- Abilities
spec:RegisterAbilities( {
    -- Talent: For the next $d, $s1% of your damage and healing is converted to healing on up to 3 nearby injured party or raid members.
    --[[ancestral_guidance = {
        id = 108281,
        cast = 0,
        cooldown = 120,
        gcd = "off",
        school = "nature",

        talent = "ancestral_guidance",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "ancestral_guidance" )
        end,
    },--]]

    -- Talent: Transform into an Air Ascendant for $114051d, immediately dealing $344548s1 Nature damage to any enemy within $344548A1 yds, reducing the cooldown and cost of Stormstrike by $s4%, and transforming your auto attack and Stormstrike into Wind attacks which bypass armor and have a $114089r yd range.$?s384411[    While Ascendance is active, generate $s1 Maelstrom Weapon $lstack:stacks; every $384437t1 sec.][]
    ascendance = {
        id = 114051,
        cast = 0,
        cooldown = function() return talent.thorims_invocation.enabled and 120 or 180 end,
        gcd = "spell",
        school = "nature",

        talent = "ascendance",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            -- trigger ascendance [344548], windstrike [115356]
            applyBuff( "ascendance" )
            --[[ if talent.static_accumulation.enabled then
                for i = 1, 15 do
                    state:QueueAuraEvent( "ascendance_maelstrom", TriggerStaticAccumulation, query_time + i, "AURA_PERIODIC" )
                end
            end ]]
        end,
    },

    -- Talent: Summons a totem at the target location that gathers electrical energy from the surrounding air and explodes after $s2 sec, stunning all enemies within $118905A1 yards for $118905d.
    capacitor_totem = {
        id = 192058,
        cast = 0,
        cooldown = function () return 60 - 6 * talent.totemic_surge.rank + conduit.totemic_surge.mod * 0.001 end,
        gcd = "totem",
        school = "nature",

        spend = 0.1,
        spendType = "mana",

        talent = "capacitor_totem",
        startsCombat = false,
        toggle = "interrupts",

        handler = function ()
            summonTotem( "capacitor_totem" )
            if not target.is_boss and debuff.casting.remains > totem.capacitor_totem.remains then
                debuff.casting.expires = query_time + totem.capacitor_totem.remains
            end
        end,
    },

    -- Talent: Heals the friendly target for $s1, then jumps to heal the $<jumps> most injured nearby allies. Healing is reduced by $s2% with each jump.
    chain_heal = {
        id = 1064,
        cast = function ()
            if buff.chains_of_devastation_ch.up then return 0 end
            if buff.natures_swiftness.up then return 0 end
            if buff.surging_currents.up then return 0 end
            return 2.5 * ( 1 - 0.2 * min( 5, buff.maelstrom_weapon.stack ) )
        end,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return buff.natures_swiftness.up or buff.surging_currents.up and 0 or 0.15 end,
        spendType = "mana",

        talent = "chain_heal",
        startsCombat = false,

        handler = function ()
            consume_maelstrom()

            removeBuff( "chains_of_devastation_ch" )
            if buff.natures_swiftness.up then removeBuff( "natures_swiftness" )
            elseif buff.surging_currents.up then removeBuff( "surging_currents" ) end

            if legendary.chains_of_devastation.enabled then
                applyBuff( "chains_of_devastation_cl" )
            end

            if buff.vesper_totem.up and vesper_totem_heal_charges > 0 then trigger_vesper_heal() end
        end,
    },

    -- Talent: Hurls a lightning bolt at the enemy, dealing $s1 Nature damage and then jumping to additional nearby enemies. Affects $x1 total targets.$?s187874[    If Chain Lightning hits more than 1 target, each target hit by your Chain Lightning increases the damage of your next Crash Lightning by $333964s1%.][]$?s187874[    Each target hit by Chain Lightning reduces the cooldown of Crash Lightning by ${$s3/1000}.1 sec.][]$?a343725[    |cFFFFFFFFGenerates $343725s5 Maelstrom per target hit.|r][]
    chain_lightning = {
        id = 188443,
        cast = function ()
            if buff.chains_of_devastation_cl.up then return 0 end
            if buff.natures_swiftness.up then return 0 end
            if buff.arc_discharge.up then return 0 end
            if buff.stormkeeper.up then return 0 end
            return ( talent.unrelenting_calamity.enabled and 1.75 or 2 ) * ( 1 - 0.2 * min( 5, buff.maelstrom_weapon.stack ) )
        end,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return buff.natures_swiftness.up and 0 or 0.01 end,
        spendType = "mana",

        talent = "chain_lightning",
        startsCombat = true,

        cycle = function() if talent.conductive_energy.enabled then return "lightning_rod" end end,

        handler = function ()
            local refund = ceil( buff.maelstrom_weapon.stack * 0.5 )
            consume_maelstrom()

            if set_bonus.tier30_2pc > 1 then applyBuff( "maelstrom_weapon", nil, refund ) end

            if talent.totemic_rebound.enabled and buff.whirling_air.up then
                removeBuff( "whirling_air" )
                addStack( "totemic_rebound", nil, 3 )
            end

            removeStack( "arc_discharge" )
            removeBuff( "chains_of_devastation_cl" )

            if buff.natures_swiftness.up then removeBuff( "natures_swiftness" ) end -- TODO: Determine order of instant cast effect consumption.
            removeBuff( "master_of_the_elements" )

            if legendary.chains_of_devastation.enabled then
                applyBuff( "chains_of_devastation_ch" )
            end

            if talent.crash_lightning.enabled then
                if true_active_enemies > 1 then applyBuff( "cl_crash_lightning", nil, min( talent.crashing_storms.enabled and 5 or 3, true_active_enemies ) ) end
                reduceCooldown( "crash_lightning", min( talent.crashing_storms.enabled and 5 or 3, true_active_enemies ) )
            end

            if talent.alpha_wolf.enabled then
                for _, v in pairs( virtual_spirits ) do
                    if v.expires > query_time then
                        v.alpha_expires = min( v.expires, query_time + 8 )
                    end
                end
            end

            removeStack( "stormkeeper" )

            if pet.storm_elemental.up then
                addStack( "wind_gust" )
            end

            if buff.feral_spirit.up and talent.alpha_wolf.enabled then
                applyBuff( "alpha_wolf" )
            end

            if talent.conductive_energy.enabled then
                if debuff.lightning_rod.down then
                    applyDebuff( "target", "lightning_rod" )
                else
                    active_dot.lightning_rod = min( active_enemies, active_dot.lightning_rod + 1 )
                end
            end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end

            ti_mode = "chain_lightning"
        end,
    },

    -- Summons a totem at your feet for $d.; Whenever enemies within $<radius> yards of the totem deal direct damage, the totem will deal $208997s1% of the damage dealt back to attacker.
    counterstrike_totem = {
        id = 204331,
        cast = 0,
        cooldown = function () return 45 - 6 * talent.totemic_surge.rank end,
        gcd = "totem",

        spend = 0.03,
        spendType = "mana",

        pvptalent = "counterstrike_totem",

        startsCombat = false,
        texture = 511726,

        handler = function ()
            summonPet( "counterstrike_totem" )
        end,
    },

    -- Talent: Electrocutes all enemies in front of you, dealing ${$s1*$<CAP>/$AP} Nature damage. Hitting 2 or more targets enhances your weapons for $187878d, causing Stormstrike, Ice Strike, and Lava Lash to also deal ${$195592s1*$<CAP>/$AP} Nature damage to all targets in front of you. Damage reduced beyond $s2 targets.$?s384363[    Each target hit by Crash Lightning increases the damage of your next Stormstrike by $198300s1%, up to a maximum of $198300u stacks.][]
    crash_lightning = {
        id = 187874,
        cast = 0,
        cooldown = 12,
        gcd = "spell",
        school = "nature",

        spend = 0.01,
        spendType = "mana",

        talent = "crash_lightning",
        startsCombat = true,

        handler = function ()
            if active_enemies > 1 then
                applyBuff( "crash_lightning" )
            end

            removeBuff( "crashing_lightning" )
            removeBuff( "cl_crash_lightning" )

            if buff.feral_spirit.up and talent.alpha_wolf.enabled then
                applyBuff( "alpha_wolf" )
            end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end

            if talent.converging_storms.enabled then
                applyBuff( "converging_storms", nil, min( 6, active_enemies ) )
            end

            if talent.alpha_wolf.enabled then
                for _, v in pairs( virtual_spirits ) do
                    if v.expires > query_time then
                        v.alpha_expires = min( v.expires, query_time + 8 )
                    end
                end
            end

            removeBuff( "electrostatic_wager" )
        end,
    },

    -- Unleash a devastating storm around yourself, dealing $469270s1 Stormstrike damage every $466772s5 sec to nearby enemies for $466772d.; Increases your chance to activate Windfury Weapon by $466772s1%, and the damage of Windfury Weapon by $466772s2%.;
    doom_winds = {
        id = 384352,
        cast = 0,
        cooldown = 60,
        gcd = "spell",
        school = "physical",

        talent = "doom_winds",
        startsCombat = true,

        toggle = "essences",

        handler = function ()
            applyBuff( "doom_winds" )
        end,
    },

    -- Talent: Calls forth a Greater Earth Elemental to protect you and your allies for $188616d.    While this elemental is active, your maximum health is increased by $381755s1%.
    earth_elemental = {
        id = 198103,
        cast = 0,
        cooldown = 300,
        gcd = "spell",
        school = "nature",

        talent = "earth_elemental",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            summonPet( "greater_earth_elemental", 60 )
            if conduit.vital_accretion.enabled then
                applyBuff( "vital_accretion" )
                health.max = health.max * ( 1 + ( conduit.vital_accretion.mod * 0.01 ) )
            end
        end,
    },

    -- Talent: Protects the target with an earthen shield, increasing your healing on them by $s1% and healing them for ${$379s1*(1+$s1/100)} when they take damage. This heal can only occur once every few seconds. Maximum $n charges.    $?s383010[Earth Shield can only be placed on the Shaman and one other target at a time. The Shaman can have up to two Elemental Shields active on them.][Earth Shield can only be placed on one target at a time. Only one Elemental Shield can be active on the Shaman.]
    earth_shield = {
        id = 974,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function() return state.spec.enhancement and 0.02 or 0.05 end,
        spendType = "mana",

        talent = "earth_shield",
        startsCombat = false,

        timeToReady = function () return buff.earth_shield.remains - 120 end,

        handler = function ()
            applyBuff( "earth_shield" )
            if talent.elemental_orbit.rank == 0 then removeBuff( "lightning_shield" ) end

            if buff.vesper_totem.up and vesper_totem_heal_charges > 0 then trigger_vesper_heal() end
        end,
    },

    -- Summons a totem at the target location for 20 sec that slows the movement speed of enemies within 10 yards by 50%.
    earthbind_totem = {
        id = 2484,
        cast = 0,
        cooldown = function() return 24 - 6 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.005,
        spendType = "mana",

        startsCombat = false,
        texture = 136102,

        handler = function()
            summonTotem( "earthbind_totem" )
        end,
    },

    -- Talent: Summons a totem at the target location for $d. The totem pulses every $116943t1 sec, rooting all enemies within $64695A1 yards for $64695d. Enemies previously rooted by the totem instead suffer $116947s1% movement speed reduction.
    earthgrab_totem = {
        id = 51485,
        cast = 0,
        cooldown = function () return 30 - 6 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.025,
        spendType = "mana",

        talent = "earthgrab_totem",
        startsCombat = true,

        toggle = "interrupts",

        handler = function ()
            summonTotem( "earthgrab_totem" )
        end,
    },

    -- Talent: Harnesses the raw power of the elements, dealing $s1 Elemental damage and increasing your Critical Strike or Haste by $118522s1% or Mastery by ${$173184s1*$168534bc1}% for $118522d.$?s137041[    If Lava Burst is known, Elemental Blast replaces Lava Burst and gains $394152s2 additional $Lcharge:charges;.][]
    elemental_blast = {
        id = 117014,
        cast = function ()
            if buff.natures_swiftness.up then return 0 end
            return maelstrom_mod( 2 ) * haste
        end,
        flash = { 51505, 117014, 394150 },
        charges = function() if talent.lava_burst.enabled then return 2 end end,
        cooldown = 12,
        recharge = function() if talent.lava_burst.enabled then return 12 end end,
        gcd = "spell",
        school = "elemental",

        spend = function()
            if state.spec.elemental then return 90 end
            return 0.006
        end,

        spendType = function()
            if state.spec.elemental then return "maelstrom" end
            return "mana"
        end,

        talent = "elemental_blast",
        startsCombat = false,

        cycle = function() if talent.conductive_energy.enabled then return "lightning_rod" end end,

        handler = function ()
            consume_maelstrom()

            if talent.totemic_rebound.enabled and buff.whirling_air.up then
                removeBuff( "whirling_air" )
                addStack( "totemic_rebound", nil, 3 )
            end

            if buff.natures_swiftness.up then removeBuff( "natures_swiftness" ) end
            applyBuff( "elemental_blast" )

            if talent.lightning_rod.enabled then applyDebuff( "target", "lightning_rod" ) end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,

        bind = "lava_burst"
    },

    -- Changes your viewpoint to the targeted location for $d.
    far_sight = {
        id = 6196,
        cast = 2,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        startsCombat = false,

        handler = function ()
            applyBuff( "far_sight" )
        end,
    },

    -- Talent: Lunge at your enemy as a ghostly wolf, biting them to deal $215802s1 Physical damage.
    feral_lunge = {
        id = 196884,
        cast = 0,
        cooldown = 30,
        gcd = "off",
        school = "physical",

        startsCombat = true,

        min_range = 8,
        max_range = 25,

        handler = function ()
            setDistance( 5 )
        end,
    },

    -- Talent: Summons two $?s262624[Elemental ][]Spirit $?s147783[Raptors][Wolves] that aid you in battle for $228562d. They are immune to movement-impairing effects, and each $?s262624[Elemental ][]Feral Spirit summoned grants you $?s262624[$224125s1%][$392375s1%] increased $?s262624[Fire, Frost, or Nature][Physical] damage dealt by your abilities.    Feral Spirit generates one stack of Maelstrom Weapon immediately, and one stack every $333957t1 sec for $333957d.
    feral_spirit = {
        id = 51533,
        cast = 0,
        cooldown = function () return ( essence.vision_of_perfection.enabled and 0.87 or 1 ) * ( 90 - ( talent.elemental_spirits.enabled and 30 or 0 ) ) end,
        gcd = "spell",
        school = "nature",

        talent = "feral_spirit",
        startsCombat = false,
        notalent = "flowing_spirits",

        toggle = "cooldowns",

        handler = function ()
            -- instant MW stack?
            applyBuff( "feral_spirit" )

            insert( virtual_spirits, {
                expires = query_time + 15,
                alpha_expires = 0
            } )

            insert( virtual_spirits, {
                expires = query_time + 15,
                alpha_expires = 0
            } )

            if not talent.elemental_spirits.enabled then
                insert( virtual_earthen_weapons, query_time + 15 )
                insert( virtual_earthen_weapons, query_time + 15 )
            end

            if set_bonus.tww1_4pc > 0 then
                insert( virtual_spirits, {
                    expires = query_time + 15,
                    alpha_expires = 0
                } )
                if not talent.elemental_spirits.enabled then
                    insert( virtual_earthen_weapons, query_time + 15 )
                end
            end

            if set_bonus.tier31_4pc > 0 then
                reduceCooldown( "primordial_wave", 14 )
            end

            gain_maelstrom( 1 )
            state:QueueAuraEvent( "feral_maelstrom", TriggerFeralMaelstrom, query_time + 3, "AURA_PERIODIC" )
            state:QueueAuraEvent( "feral_maelstrom", TriggerFeralMaelstrom, query_time + 6, "AURA_PERIODIC" )
            state:QueueAuraEvent( "feral_maelstrom", TriggerFeralMaelstrom, query_time + 9, "AURA_PERIODIC" )
            state:QueueAuraEvent( "feral_maelstrom", TriggerFeralMaelstrom, query_time + 12, "AURA_PERIODIC" )
            state:QueueAuraEvent( "feral_maelstrom", TriggerFeralMaelstrom, query_time + 15, "AURA_PERIODIC" )
        end
    },

    -- Talent: Erupt a burst of fiery damage from all targets affected by your Flame Shock, dealing $333977s1 Fire damage to up to $333977I targets within $333977A1 yds of your Flame Shock targets.$?s384359[    Each eruption from Fire Nova generates $384359s1 $Lstack:stacks; of Maelstrom Weapon.][]
    fire_nova = {
        id = 333974,
        cast = 0,
        cooldown = 15,
        gcd = "spell",
        school = "fire",

        spend = 0.01,
        spendType = "mana",

        talent = "fire_nova",
        startsCombat = true,

        usable = function() return active_dot.flame_shock > 0, "requires active flame_shock" end,

        handler = function ()
            if buff.whirling_fire.up then
                removeBuff( "whirling_fire" )
                applyBuff( "hot_hand", 8 )
            end

            if talent.swirling_maelstrom.enabled then
                gain_maelstrom( min( 6, active_dot.flame_shock ) + ( buff.maelstrom_of_elements.up and 1 or 0 ) )
            end

            if buff.maelstrom_of_elements.up then removeBuff( "maelstrom_of_elements" ) end
            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Sears the target with fire, causing $s1 Fire damage and then an additional $o2 Fire damage over $d.    Flame Shock can be applied to a maximum of $I targets.
    flame_shock = {
        id = 470411,
        cast = 0,
        cooldown = 6,
        hasteCD = true,
        gcd = "spell",
        school = "fire",

        spend = 0.003,
        spendType = "mana",

        startsCombat = true,
        nobuff = "voltaic_blaze",

        handler = function ()
            applyDebuff( "target", "flame_shock" )
            if buff.whirling_earth.up then
                removeBuff( "whirling_earth" )
                active_dot.flame_shock = min( 6, true_active_enemies, active_dot.flame_shock + 5 )
            end

            if talent.focused_insight.enabled then applyBuff( "focused_insight" ) end
            if talent.primal_lava_actuators.enabled then addStack( "primal_lava_actuators_df" ) end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,

        copy = { 188389, 470411 },
        bind = "voltaic_blaze"
    },

    -- Sears the target with fire, causing $s1 Fire damage and then an additional $o2 Fire damage over $d.    Flame Shock can be applied to a maximum of $I targets.
    voltaic_blaze = {
        id = 470057,
        known = 470411,
        cast = 0,
        cooldown = 6,
        hasteCD = true,
        gcd = "spell",
        school = "fire",

        spend = 0.003,
        spendType = "mana",

        startsCombat = true,
        buff = "voltaic_blaze",

        handler = function ()
            removeBuff( "voltaic_blaze" )

            spec.abilities.flame_shock.handler()
            active_dot.flame_shock = min( 6, true_active_enemies, active_dot.flame_shock + 5 )

            if buff.whirling_earth.up then
                removeBuff( "whirling_earth" )
                active_dot.flame_shock = min( true_active_enemies, active_dot.flame_shock + 5 )
            end

            if talent.focused_insight.enabled then applyBuff( "focused_insight" ) end
            if talent.primal_lava_actuators.enabled then addStack( "primal_lava_actuators_df" ) end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,

        bind = "voltaic_blaze"
    },

    -- Imbue your $?s33757[off-hand ][]weapon with the element of Fire for $319778d, causing each of your attacks to deal ${$max(($<coeff>*$AP),1)} additional Fire damage$?s382027[ and increasing the damage of your Fire spells by $382028s1%][].
    flametongue_weapon = {
        id = 318038,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "fire",

        startsCombat = false,
        nobuff = "flametongue_weapon",
        essential = true,

        usable = function () return off_hand.size > 0, "requires an offhand weapon" end,
        handler = function ()
            applyBuff( "flametongue_weapon" )
        end,
    },

    -- Talent: Chills the target with frost, causing $s1 Frost damage and reducing the target's movement speed by $s2% for $d.
    frost_shock = {
        id = 196840,
        known = 196840,
        cast = 0,
        cooldown = 6,
        hasteCD = true,
        gcd = "spell",
        school = "frost",

        spend = 0.01,
        spendType = "mana",

        talent = "frost_shock",
        startsCombat = false,

        handler = function ()
            applyDebuff( "target", "frost_shock" )

            if buff.hailstorm.up then
                if talent.swirling_maelstrom.enabled and buff.hailstorm.stack > 1 then gain_maelstrom( 1 + ( buff.maelstrom_of_elements.up and 1 or 0 ) ) end
                removeBuff( "hailstorm" )
            end

            removeBuff( "ice_strike_buff" )
            removeBuff( "maelstrom_of_elements" )

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,

        bind = function()
            if talent.ice_strike_passive.enabled then return "ice_strike" end
        end
    },

    -- Turn into a Ghost Wolf, increasing movement speed by $?s382215[${$s2+$382216s1}][$s2]% and preventing movement speed from being reduced below $s3%.
    ghost_wolf = {
        id = 2645,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        startsCombat = false,

        handler = function ()
            applyBuff( "ghost_wolf" )
            if conduit.thunderous_paws.enabled then applyBuff( "thunderous_paws_sl" ) end
            if talent.thunderous_paws.enabled and query_time - buff.thunderous_paws_df.lastApplied > 20 then
                applyBuff( "thunderous_paws_df" )
                if debuff.snared.up then removeDebuff( "player", "snared" ) end
            end
        end,
    },

    -- Talent: Purges the enemy target, removing $m1 beneficial Magic effects.
    greater_purge = {
        id = 378773,
        cast = 0,
        cooldown = 12,
        gcd = "spell",
        school = "nature",

        spend = function() return state.spec.enhancement and 0.024 or 0.021 end,
        spendType = "mana",

        talent = "greater_purge",
        startsCombat = true,
        toggle = "interrupts",
        debuff = "dispellable_magic",

        handler = function ()
            removeDebuff( "target", "dispellable_magic" )
        end,
    },

    -- Talent: A gust of wind hurls you forward.
    gust_of_wind = {
        id = 192063,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "nature",

        talent = "gust_of_wind",
        startsCombat = false,

        toggle = "interrupts",
        debuff = "dispellable_magic",

        handler = function ()
            removeDebuff( "target", "dispellable_magic" )
        end,
    },

    -- Talent: Summons a totem at your feet for $d that heals $?s147074[two injured party or raid members][an injured party or raid member] within $52042A1 yards for $52042s1 every $5672t1 sec.    If you already know $?s157153[$@spellname157153][$@spellname5394], instead gain $392915s1 additional $Lcharge:charges; of $?s157153[$@spellname157153][$@spellname5394].
    healing_stream_totem = {
        id = 5394,
        cast = 0,
        cooldown = function () return 30 - 6 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.05,
        spendType = "mana",

        talent = "healing_stream_totem",
        startsCombat = false,

        handler = function ()
            summonTotem( "healing_stream_totem" )
            if buff.vesper_totem.up and vesper_totem_heal_charges > 0 then trigger_vesper_heal() end
        end,
    },

    -- A quick surge of healing energy that restores $s1 of a friendly target's health.
    healing_surge = {
        id = 8004,
        cast = function ()
            if buff.natures_swiftness.up then return 0 end
            if buff.surging_currents.up then return 0 end
            return maelstrom_mod( 1.5 ) * haste
        end,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return ( buff.natures_swiftness.up or buff.surging_currents.up ) and 0 or maelstrom_mod( state.spec.enhancement and 0.08 or state.spec.elemental and 0.044 or state.spec.restoration and 0.044 ) end,
        spendType = "mana",

        startsCombat = false,

        handler = function ()
            consume_maelstrom()

            if buff.natures_swiftness.up then removeBuff( "natures_swiftness" )
            elseif buff.surging_currents.up then removeBuff( "surging_currents" ) end

            if buff.vesper_totem.up and vesper_totem_heal_charges > 0 then trigger_vesper_heal() end
        end
    },

    -- Strike your target with an icy blade, dealing $s1 Frost damage and snaring them by $s2% for $d.; Ice Strike increases the damage of your next Frost Shock by $384357s1%$?s384359[ and generates $384359s1 $Lstack:stacks; of Maelstrom Weapon][].
    ice_strike = {
        id = 470194,
        cast = 0,
        cooldown = 15,
        gcd = "spell",
        school = "frost",

        spend = 0.033,
        spendType = "mana",

        talent = "ice_strike",
        notalent = "ice_strike_passive",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "ice_strike" )
            applyBuff( "ice_strike_buff" )

            if talent.swirling_maelstrom.enabled then
                if state.spec.elemental then
                    gain_maelstrom( 1 + ( buff.maelstrom_of_elements.up and 1 or 0 ) )
                    removeBuff( "maelstrom_of_elements" )
                else
                    gain_maelstrom( 2 )
                end
            else
                gain_maelstrom( 1 )
            end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,

        copy = 342240
    },

    -- Talent: Hurls molten lava at the target, dealing $285452s1 Fire damage. Lava Burst will always critically strike if the target is affected by Flame Shock.$?a343725[    |cFFFFFFFFGenerates $343725s3 Maelstrom.|r][]
    lava_burst = {
        id = 51505,
        cast = function ()
            if buff.natures_swiftness.up or buff.lava_surge.up then return 0 end
            return maelstrom_mod( 2 ) * haste
        end,
        cooldown = 8,
        gcd = "spell",
        school = "fire",

        spend = 0.025,
        spendType = "mana",

        talent = "lava_burst",
        notalent = "elemental_blast",
        startsCombat = false,
        velocity = 30,

        indicator = function()
            return active_enemies > 1 and settings.cycle and dot.flame_shock.down and active_dot.flame_shock > 0 and "cycle" or nil
        end,

        handler = function ()
            if buff.windspeakers_lava_resurgence.up then removeBuff( "windspeakers_lava_resurgence" ) end
            if buff.lava_surge.up then removeBuff( "lava_surge" ) end
            if buff.echoing_shock.up then removeBuff( "echoing_shock" ) end

            consume_maelstrom()

            if talent.master_of_the_elements.enabled then applyBuff( "master_of_the_elements" ) end

            if talent.surge_of_power.enabled then
                gainChargeTime( "fire_elemental", 6 )
                removeBuff( "surge_of_power" )
            end

            if buff.primordial_wave.up and state.spec.elemental and ( talent.splintered_elements.enabled or legendary.splintered_elements.enabled ) then
                if buff.splintered_elements.down then stat.haste = stat.haste + 0.1 * active_dot.flame_shock end
                applyBuff( "splintered_elements", nil, active_dot.flame_shock )
            end
            removeBuff( "primordial_wave" )

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,

        impact = function () end,  -- This + velocity makes action.lava_burst.in_flight work in APL logic.

        -- bind = "elemental_blast",
    },

    -- Talent: Charges your off-hand weapon with lava and burns your target, dealing $s1 Fire damage.    Damage is increased by $s2% if your offhand weapon is imbued with Flametongue Weapon. $?s334033[Lava Lash will spread Flame Shock from your target to $s3 nearby targets.][]$?s334046[    Lava Lash increases the damage of Flame Shock on its target by $334168s1% for $334168d.][]
    lava_lash = {
        id = 60103,
        cast = 0,
        cooldown = function () return ( 18 - 6 * talent.molten_assault.rank ) * ( buff.hot_hand.up and ( 1 - 0.375 * talent.hot_hand.rank ) or 1 ) * haste - ( settings.pad_lava_lash and buff.hot_hand.up and ( latency * 2 ) or 0 ) end,
        gcd = "spell",
        school = "fire",

        spend = 0.008,
        spendType = "mana",

        talent = "lava_lash",
        startsCombat = true,

        cycle = function()
            return talent.lashing_flames.enabled and "lashing_flames" or nil
        end,

        indicator = function()
            if debuff.flame_shock.down and active_dot.flame_shock > 0 and active_enemies > 1 then return "cycle" end
        end,

        handler = function ()
            removeDebuff( "target", "primal_primer" )

            if buff.whirling_fire.up then
                removeBuff( "whirling_fire" )
                applyBuff( "hot_hand", 8 )
            end

            if talent.lashing_flames.enabled then applyDebuff( "target", "lashing_flames" ) end

            removeBuff( "primal_lava_actuators" )
            removeBuff( "ashen_catalyst" )

            if azerite.natural_harmony.enabled and buff.frostbrand.up then applyBuff( "natural_harmony_frost" ) end
            if azerite.natural_harmony.enabled then applyBuff( "natural_harmony_fire" ) end
            if azerite.natural_harmony.enabled and buff.crash_lightning.up then applyBuff( "natural_harmony_nature" ) end

            -- This is dumb, but technically you don't know if FS will go to a new target or refresh an old one.  Even your current target.
            if talent.molten_assault.enabled and debuff.flame_shock.up then
                active_dot.flame_shock = min( active_enemies, active_dot.flame_shock + 5 )
                removeBuff( "whirling_earth" )
            end
            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Hurls a bolt of lightning at the target, dealing $s1 Nature damage.$?a343725[    |cFFFFFFFFGenerates $343725s1 Maelstrom.|r][]
    lightning_bolt = {
        id = 188196,
        cast = function ()
            if buff.natures_swiftness.up or buff.arc_discharge.up then return 0 end
            return maelstrom_mod( 2 ) * haste
        end,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return buff.natures_swiftness.up and 0 or 0.01 end,
        spendType = "mana",

        startsCombat = true,
        nobuff = "tempest",

        cycle = function() if talent.conductive_energy.enabled then return "lightning_rod" end end,

        handler = function ()
            consume_maelstrom()

            if talent.totemic_rebound.enabled and buff.whirling_air.up then
                removeBuff( "whirling_air" )
                addStack( "totemic_rebound", nil, 3 )
            end

            if buff.natures_swiftness.up then removeBuff( "natures_swiftness" ) end
            if buff.arc_discharge.up then removeStack( "arc_discharge" ) end

            if buff.primordial_wave.up and state.spec.enhancement and ( talent.splintered_elements.enabled or legendary.splintered_elements.enabled ) then
                if buff.splintered_elements.down then stat.haste = stat.haste + 0.1 * active_dot.flame_shock end
                applyBuff( "splintered_elements", nil, active_dot.flame_shock )
            end
            removeBuff( "primordial_wave" )

            if talent.lightning_rod.enabled then applyDebuff( "target", "lightning_rod" ) end

            if azerite.natural_harmony.enabled then applyBuff( "natural_harmony_nature" ) end
            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end

            ti_mode = buff.primordial_wave.up and active_dot.flame_shock > 1 and "chain_lightning" or "lightning_bolt"

        end,

        bind = "tempest"
    },

    -- Hurls a bolt of lightning at the target, dealing $s1 Nature damage.$?a343725[    |cFFFFFFFFGenerates $343725s1 Maelstrom.|r][]
    tempest = {
        id = 452201,
        cast = function ()
            if buff.natures_swiftness.up then return 0 end
            return maelstrom_mod( 2 ) * haste
        end,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return buff.natures_swiftness.up and 0 or 0.01 end,
        spendType = "mana",

        startsCombat = true,
        buff = "tempest",

        cycle = function() if talent.conductive_energy.enabled then return "lightning_rod" end end,

        handler = function ()
            consume_maelstrom()

            if buff.natures_swiftness.up then removeBuff( "natures_swiftness" ) end
            removeStack( "tempest" )

            if talent.arc_discharge.enabled then addStack( "arc_discharge" ) end

            if buff.primordial_wave.up and state.spec.enhancement and ( talent.splintered_elements.enabled or legendary.splintered_elements.enabled ) then
                if buff.splintered_elements.down then stat.haste = stat.haste + 0.1 * active_dot.flame_shock end
                applyBuff( "splintered_elements", nil, active_dot.flame_shock )
            end
            removeBuff( "primordial_wave" )

            if talent.lightning_rod.enabled then applyDebuff( "target", "lightning_rod" ) end

            if azerite.natural_harmony.enabled then applyBuff( "natural_harmony_nature" ) end
            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end

            ti_mode = true_active_enemies > 1 and "chain_lightning" or "lightning_bolt"
        end,

        bind = "lightning_bolt",
        copy = { 454009, 454015 },
        flash = 188196
    },

    -- Talent: Grips the target in lightning, stunning and dealing $305485o1 Nature damage over $305485d while the target is lassoed. Can move while channeling.
    lightning_lasso = {
        id = 305483,
        cast = 0,
        cooldown = 45,
        gcd = "spell",
        school = "nature",

        talent = "lightning_lasso",
        startsCombat = false,
        toggle = "interrupts",

        start = function ()
            removeBuff( "echoing_shock" )
            applyDebuff( "target", "lightning_lasso" )
            if not target.is_boss then interrupt() end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,

        copy = 305485
    },

    -- Surround yourself with a shield of lightning for $d.    Melee attackers have a $h% chance to suffer $192109s1 Nature damage$?a137041[ and have a $s3% chance to generate a stack of Maelstrom Weapon]?a137040[ and have a $s4% chance to generate $s5 Maelstrom][].    $?s383010[The Shaman can have up to two Elemental Shields active on them.][Only one Elemental Shield can be active on the Shaman at a time.]
    lightning_shield = {
        id = 192106,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = 0.015,
        spendType = "mana",

        startsCombat = false,
        essential = true,
        nobuff = function() if not talent.elemental_orbit.enabled then return "earth_shield" end end,

        timeToReady = function () return buff.lightning_shield.remains - 120 end,

        handler = function ()
            applyBuff( "lightning_shield" )
            if talent.elemental_orbit.rank == 0 then removeBuff( "earth_shield" ) end
        end,
    },

    -- Talent: Your next healing or damaging Nature spell is instant cast and costs no mana.
    natures_swiftness = {
        id = 378081,
        cast = 0,
        cooldown = 60,
        gcd = "off",
        school = "nature",

        talent = "natures_swiftness",
        startsCombat = false,

        toggle = "cooldowns",
        nobuff = "natures_swiftness",

        handler = function ()
            applyBuff( "natures_swiftness" )
        end,
    },

    -- Talent: Summons a totem at your feet that removes $383015s1 poison effect from a nearby party or raid member within $383015a yards every $383014t1 sec for $d.
    poison_cleansing_totem = {
        id = 383013,
        cast = 0,
        cooldown = function() return 120 - 6 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.025,
        spendType = "mana",
        toggle = "interrupts",

        talent = "poison_cleansing_totem",
        startsCombat = false,

        handler = function ()
            summonTotem( "poison_cleaning_totem" )
            removeBuff( "dispellable_poison" )
        end,
    },

    -- An instant weapon strike that causes $sw2 Physical damage.
    primal_strike = {
        id = 73899,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "physical",

        spend = 0.094,
        spendType = "mana",

        notalent = "stormstrike",
        startsCombat = true,

        handler = function ()
        end,
    },
    -- Talent / Covenant (Necrolord): Blast your target with a Primordial Wave, dealing $375984s1 Shadow damage and apply Flame Shock to them.; Your next $?a137040[Lava Burst]?a137041[Lightning Bolt][Healing Wave] will also hit all targets affected by your $?a137040|a137041[Flame Shock][Riptide] for $?a137039[$s2%]?a137040[$s3%][$s4%] of normal $?a137039[healing][damage].$?s384405[; Primordial Wave generates $s5 stacks of Maelstrom Weapon.][]
    primordial_storm = {
        id = 1218090,
        known = 375982,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "flamestrike",
        flash = 375982,

        spend = 0.08,
        spendType = "mana",

        startsCombat = true,

        talent = "primordial_storm",
        buff = "primordial_storm",

        handler = function ()
            removeBuff( "primordial_storm" )
            consume_maelstrom()
        end,

        bind = "primordial_wave"
    },
    -- Talent / Covenant (Necrolord): Blast your target with a Primordial Wave, dealing $375984s1 Shadow damage and apply Flame Shock to them.; Your next $?a137040[Lava Burst]?a137041[Lightning Bolt][Healing Wave] will also hit all targets affected by your $?a137040|a137041[Flame Shock][Riptide] for $?a137039[$s2%]?a137040[$s3%][$s4%] of normal $?a137039[healing][damage].$?s384405[; Primordial Wave generates $s5 stacks of Maelstrom Weapon.][]
    primordial_wave = {
        id = function() return talent.primordial_wave.enabled and 375982 or 326059 end,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "shadow",

        spend = 0.06,
        spendType = "mana",

        startsCombat = true,
        -- velocity = 25,

        toggle = "essences",

        usable = function()
            if active_dot.flame_shock < 1 then return false, "requires active flame_shock" end
            if buff.maelstrom_weapon.stack < 5 then return true end
            return not ( talent.primal_maelstrom.enabled and settings.burn_before_wave ), "setting requires spending maelstrom_weapon before using with primal_maelstrom"
        end,

        cycle = "flame_shock",

        handler = function ()
            if talent.primal_maelstrom.enabled then gain_maelstrom( 5 ) end
            applyBuff( "primordial_wave" )
            if talent.conductive_energy.enabled then active_dot.lightning_rod = min( active_enemies, max( active_dot.lightning_rod, active_dot.flame_shock ) ) end
            if set_bonus.tier31_2pc > 0 then
                insert( virtual_spirits, {
                    expires = query_time + 15,
                    alpha_expires = 0
                } )
                if not talent.elemental_spirits.enabled then
                    insert( virtual_earthen_weapons, query_time + 15 )
                end
            end
        end,

        copy = { 326059, 375982 }
    },

    -- Talent: Purges the enemy target, removing $m1 beneficial Magic $leffect:effects;.$?(s147762&s51530)  [ Successfully purging a target grants a stack of Maelstrom Weapon.][]
    purge = {
        id = 370,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        icd = function() if settings.purge_icd > 0 then return settings.purge_icd end end,
        school = "nature",

        spend = function() return state.spec.enhancement and 0.016 or 0.14 end,
        spendType = "mana",

        talent = "purge",
        startsCombat = true,
        toggle = "interrupts",
        buff = "dispellable_magic",

        handler = function ()
            removeBuff( "dispellable_magic" )
            if time > 0 and talent.inundate.enabled then gain( 8, "maelstrom" ) end
        end,
    },

    -- Harness the fury of the Windlord to grant a target ally $s1% Mastery and empower their auto attacks to have a $h% chance to instantly strike again for $d.; If the target is in your party or raid, all party and raid members will be affected.
    skyfury = {
        id = 462854,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "spell",

        spend = 0.040,
        spendType = 'mana',

        startsCombat = false,
        nobuff = "skyfury",
        essential = true,

        handler = function()
            applyBuff( "skyfury" )
        end,
   },

    -- Removes all movement impairing effects and increases your movement speed by $58875s1% for $58875d.
    spirit_walk = {
        id = 58875,
        cast = 0.0,
        cooldown = 60.0,
        gcd = "off",

        talent = "spirit_walk",
        startsCombat = false,

        handler = function()
            applyBuff( "spirit_walk" )
        end,
    },

    -- Talent: Calls upon the guidance of the spirits for $d, permitting movement while casting Shaman spells. Castable while casting.$?a192088[ Increases movement speed by $192088s2%.][]
    spiritwalkers_grace = {
        id = 79206,
        cast = 0,
        cooldown = function () return 120 - 30 * talent.graceful_spirit.rank end,
        gcd = "off",
        school = "nature",

        spend = 0.141,
        spendType = "mana",

        talent = "spiritwalkers_grace",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            applyBuff( "spiritwalkers_grace" )
        end,
    },

     -- Summons a totem with $s2% of your health at the target location for $d that forms a circuit of electricity that enemies cannot pass through.
     static_field_totem = {
        id = 355580,
        cast = 0.0,
        cooldown = function() return 90.0 - 6 * talent.totemic_surge.rank end,
        gcd = "spell",

        spend = 0.01,
        spendType = "mana",

        startsCombat = false,
        pvptalent = "static_field_totem",

        handler = function()
        end,
    },

    -- Summons a totem with ${$m1*$MHP/100} health at the feet of the caster for $d, granting the caster a shield absorbing $114893s1 damage for $114893d, and up to an additional $462844s1 every $114889t1 sec.
    stone_bulwark_totem = {
        id = 108270,
        cast = 0,
        cooldown = function () return 180 - 6 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.02,
        spendType = "mana",

        talent = "stone_bulwark_totem",
        startsCombat = false,

        handler = function ()
            summonTotem( "stone_bulwark_totem" )
            applyBuff( "stone_bulwark" )
        end,
    },

    -- Talent: Energizes both your weapons with lightning and delivers a massive blow to your target, dealing a total of ${$32175sw1+$32176sw1} Physical damage.$?s210853[    Stormstrike has a $s4% chance to generate $210853m2 $Lstack:stacks; of Maelstrom Weapon.][]
    stormstrike = {
        id = 17364,
        cast = 0,
        charges = function() if talent.stormblast.enabled then return 2 end end,
        cooldown = function() return gcd.execute * 5 end,
        recharge = function() if talent.stormblast.enabled then return gcd.execute * 5 end end,
        gcd = "spell",
        school = "physical",

        rangeSpell = 73899,

        spend = 0.02,
        spendType = "mana",

        -- talent = "stormstrike",
        startsCombat = true,

        bind = "windstrike",
        cycle = function () return azerite.lightning_conduit.enabled and "lightning_conduit" or nil end,
        nobuff = "ascendance",

        handler = function ()
            setCooldown( "windstrike", action.stormstrike.cooldown )

            if buff.stormbringer.up then
                removeBuff( "stormbringer" )
            end

            if buff.stormsurge.up then
                removeStack( "stormsurge" )
            end

            removeBuff( "converging_storms" )
            removeBuff( "strength_of_earth" )
            removeBuff( "legacy_of_the_frost_witch" )

            if talent.elemental_assault.rank > 1 then
                gain_maelstrom( 1 )
            end

            if set_bonus.tier29_2pc > 0 then applyBuff( "maelstrom_of_elements" ) end

            if azerite.lightning_conduit.enabled then
                applyDebuff( "target", "lightning_conduit" )
            end
            if azerite.natural_harmony.enabled and buff.frostbrand.up then applyBuff( "natural_harmony_frost" ) end
            if azerite.natural_harmony.enabled and buff.flametongue.up then applyBuff( "natural_harmony_fire" ) end
            if azerite.natural_harmony.enabled and buff.crash_lightning.up then applyBuff( "natural_harmony_nature" ) end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Talent: Shatters a line of earth in front of you with your main hand weapon, causing $s1 Flamestrike damage and Incapacitating any enemy hit for $d.
    sundering = {
        id = 197214,
        cast = 0,
        cooldown = function() return talent.molten_thunder.enabled and 30 or 40 end,
        gcd = "spell",
        school = "flamestrike",

        spend = 0.06,
        spendType = "mana",

        talent = "sundering",
        startsCombat = true,

        handler = function ()
            if not talent.molten_thunder.enabled then applyDebuff( "target", "sundering" ) end
            -- Todo: Track 11.1 molten thunder reset and whether or not it can be 100%. Currently a serverside script so *shrug*
            if talent.lashing_flames.enabled then
                applyDebuff( "target", "lashing_flames" )
                active_dot.lashing_flames = active_enemies
            end
            if azerite.natural_harmony.enabled and buff.flametongue.up then applyBuff( "natural_harmony_fire" ) end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- [Summons a totem at the target location that creates a Tremor immediately and every $455593t1 sec for $455622s1 Physical damage. Damage reduced beyond $455622s2 targets. Lasts $d.]
    surging_totem = {
        id = 444995,
        cast = 0.0,
        cooldown = function() return 30.0 - 6 * talent.totemic_surge.rank end,
        gcd = "spell",

        spend = 0.086,
        spendType = 'mana',

        talent = "surging_totem",
        startsCombat = false,
        readyTime = function() return totem.surging_totem.remains end,

        texture = 5927655,

        handler = function()
            summonTotem( "surging_totem" )

            if talent.whirling_elements.enabled then
                applyBuff( "whirling_air" )
                applyBuff( "whirling_earth" )
                applyBuff( "whirling_fire" )
            end
        end,

        bind = "surging_totem_projection"
    },

    -- Summons your Surging Totem nearby
    surging_totem_projection = {
        id = 1221348,
        cast = 0,
        cooldown = 6,
        gcd = "off",
        school = "nature",

        talent = "surging_totem",
        startsCombat = false,
        usable = function() return totem.surging_totem.up end,

        texture = 310733,
        essential = false,

        handler = function ()
        end,

        bind = "surging_totem"
    },

    -- Talent: Calls down a bolt of lightning, dealing $s1 Nature damage to all enemies within $A1 yards, reducing their movement speed by $s3% for $d, and knocking them $?s378779[upward][away from the Shaman]. Usable while stunned.
    -- TODO: Track Thunderstorm for CDR.
    thunderstorm = {
        id = 51490,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "nature",

        talent = "thunderstorm",
        startsCombat = false,
        toggle = "interrupts",

        handler = function ()
            applyDebuff( "target", "thunderstorm" )
            if not target.is_boss then interrupt() end
            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Talent: Relocates your active totems to the specified location.
    totemic_projection = {
        id = 108287,
        cast = 0,
        cooldown = 10,
        gcd = "off",
        school = "nature",

        talent = "totemic_projection",
        startsCombat = false,
        essential = false,

        handler = function ()
        end,
    },


    -- Talent: Resets the cooldown of your most recently used totem with a base cooldown shorter than 3 minutes.
    totemic_recall = {
        id = 108285,
        cast = 0,
        cooldown = function() return talent.call_of_the_elements.enabled and 120 or 180 end,
        gcd = "spell",
        school = "nature",

        talent = "totemic_recall",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            if recall_totem_1 then setCooldown( recall_totem_1, 0 ) end
            if talent.creation_core.enabled and recall_totem_2 then setCooldown( recall_totem_2, 0 ) end
        end,

        copy = "call_of_the_elements"
    },

    -- Talent: Summons a totem at your feet that shakes the ground around it for $d, removing Fear, Charm and Sleep effects from party and raid members within $8146a1 yards.
    tremor_totem = {
        id = 8143,
        cast = 0,
        cooldown = function () return 60 + ( conduit.totemic_surge.mod * 0.001 ) - 6 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.023,
        spendType = "mana",

        talent = "tremor_totem",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            summonTotem( "tremor_totem" )
        end,
    },

    -- Unleash your Elemental Shield's energy on an enemy target:; $@spellicon192106$@spellname192106: Knocks them away.; $@spellicon974$@spellname974: Roots them in place for $356738d.; $@spellicon52127$@spellname52127: Summons a whirlpool for $356739d, reducing damage and healing by $356824s1% while they stand within it.
    unleash_shield = {
        id = 356736,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "spell",

        startsCombat = true,
        pvptalent = "unleash_shield",

        buff = function()
            return buff.lightning_shield.up or buff.earth_shield.up or buff.water_shield.up, "requires an elemental shield"
        end,

        handler = function()
        end,
    },

    water_walking = {
        id = 546,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        startsCombat = false,
        texture = 135863,

        handler = function ()
            applyBuff( "water_walking" )
        end,
    },

    -- Talent: Summons a totem at the target location for $d, continually granting all allies who pass within $192078s1 yards $192082s% increased movement speed for $192082d.
    wind_rush_totem = {
        id = 192077,
        cast = 0,
        cooldown = function () return 120 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",

        spend = 0.010,
        spendType = 'mana',

        talent = "wind_rush_totem",
        startsCombat = false,
        texture = 538576,

        toggle = "cooldowns",

        handler = function ()
            summonTotem( "wind_rush_totem" )
            applyBuff( "wind_rush" )
        end,
    },

    -- Talent: Disrupts the target's concentration with a burst of wind, interrupting spellcasting and preventing any spell in that school from being cast for $d.
    wind_shear = {
        id = 57994,
        cast = 0,
        cooldown = 12,
        gcd = "off",
        school = "nature",

        talent = "wind_shear",
        startsCombat = false,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
        end,
    },

    -- Talent: Imbue your main-hand weapon with the element of Wind for $319773d. Each main-hand attack has a $319773h% chance to trigger $?s390288[three][two] extra attacks, dealing $25504sw1 Physical damage each.$?s262647[    Windfury causes each successive Windfury attack within $262652d to increase the damage of Windfury by $262652s1%, stacking up to $262652u times.][]
    windfury_weapon = {
        id = 33757,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        talent = "windfury_weapon",
        startsCombat = false,
        essential = true,
        nobuff = "windfury_weapon",

        usable = function() return main_hand.size > 0, "requires a mainhand weapon" end,
        handler = function ()
            applyBuff( "windfury_weapon" )
        end,
    },


    windstrike = {
        id = 115356,
        cast = 0,
        charges = function() if talent.stormblast.enabled then return 2 end end,
        cooldown = function() return gcd.execute * 2 - ( settings.pad_windstrike and latency * 2 or 0 ) end,
        recharge = function() if talent.stormblast.enabled then return gcd.execute * 2 - ( settings.pad_windstrike and latency * 2 or 0 ) end end,
        gcd = "spell",

        texture = 1029585,
        known = 17364,

        buff = "ascendance",
        cycle = function() if talent.conductive_energy.enabled then return "lightning_rod" end end,

        bind = "stormstrike",

        handler = function ()
            setCooldown( "stormstrike", action.stormstrike.cooldown )
            setCooldown( "strike", action.stormstrike.cooldown )

            if buff.stormbringer.up then
                removeBuff( "stormbringer" )
            end

            removeBuff( "converging_storms" )
            removeBuff( "strength_of_earth" )
            removeBuff( "legacy_of_the_frost_witch" )

            if talent.elemental_assault.enabled then
                gain_maelstrom( 1 )
            end

            if talent.thorims_invocation.enabled and buff.maelstrom_weapon.up then
                consume_maelstrom( min( 5, buff.maelstrom_weapon.stack ) )
            end

            if azerite.natural_harmony.enabled then
                if buff.frostbrand.up then applyBuff( "natural_harmony_frost" ) end
                if buff.flametongue.up then applyBuff( "natural_harmony_fire" ) end
                if buff.crash_lightning.up then applyBuff( "natural_harmony_nature" ) end
            end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },
} )

spec:RegisterRanges( "primal_strike", "lightning_bolt", "flame_shock", "wind_shear" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 2,
    cycle = false,

    nameplates = true,
    nameplateRange = 10,
    rangeFilter = false,

    damage = true,
    damageExpiration = 8,

    potion = "tempered_potion",

    package = "增强Simc",
} )

spec:RegisterSetting( "funnel_priority", false, {
    name = "增强萨满能够使用漏斗伤害机制。前往 |cFFFFD100快捷切换|r 了解如何开启和关闭此机制。" ..
    "如果启用漏斗伤害，默认优先级会建议在 AOE 战斗时，使用单体终结级对重要目标造成更多伤害。\n\n",
    desc = "",
    type = "description",
    fontSize = "medium",
    width = "full"
})

spec:RegisterStateExpr( "funnel", function()
    return toggle.funnel
end )

spec:RegisterStateTable( "rotation", setmetatable( {}, {
    __index = setfenv( function( t, k )
        if ( k == "simple" or k == "standard" ) and not settings.funnel_priority then return true end
        if k == "funnel" and settings.funnel_priority then return true end
        return false
    end, state )
} ) )

spec:RegisterSetting( "pad_windstrike", true, {
    name = strformat( "缓冲 %s 冷却", Hekili:GetSpellLinkWithTexture( spec.abilities.windstrike.id ) ),
    desc = strformat( "如果勾选，%s 的冷却时间将被缩短，以确保在 %s 期间尽可能频繁地推荐它。",
        Hekili:GetSpellLinkWithTexture( spec.abilities.windstrike.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.ascendance.id ) ),
    type = "toggle",
    width = 1.5
} )

spec:RegisterSetting( "pad_lava_lash", true, {
    name = strformat( "缓冲 %s 冷却", Hekili:GetSpellLinkWithTexture( spec.abilities.lava_lash.id ) ),
    desc = strformat( "如果勾选，%s 的冷却时间将被缩短，以确保在 %s 期间尽可能频繁地推荐它。",
        Hekili:GetSpellLinkWithTexture( spec.abilities.lava_lash.id ), Hekili:GetSpellLinkWithTexture( spec.auras.hot_hand.id ) ),
    type = "toggle",
    width = 1.5
} )

local elemental = Hekili:GetSpec( 262 )

spec:RegisterSetting( "pwave_targets", 0, {
    name = strformat( "%s:目标数量", Hekili:GetSpellLinkWithTexture( spec.abilities.primordial_wave.id ) ),
    desc = strformat( "如果设置为 1 以上，除非检测到多个目标，否则不会推荐 %s。 可以通过小地图上的图标或附加组件快速切换该选项，"
        .. "以便在遇到不同的 BOSS 时快速更改。\n\n这个设置也可以在|cFFFFD100技能|cFFFFFFFF>|r "
        .. "增强|cFFFFFFFF>|r |W%s|w|r中找到。", Hekili:GetSpellLinkWithTexture( spec.abilities.primordial_wave.id ), spec.abilities.primordial_wave.name ),
    type = "range",
    min = 0,
    max = 15,
    step = 1,
    set = function( info, val )
        Hekili.DB.profile.specs[ 263 ].abilities.primordial_wave.targetMin = val
    end,
    get = function()
        return Hekili.DB.profile.specs[ 263 ].abilities.primordial_wave.targetMin or 0
    end,
    width = "full"
} )

spec:RegisterSetting( "pwave_gcds", 4, {
    name = strformat( "%s: GCD阈值", Hekili:GetSpellLinkWithTexture( spec.abilities.primordial_wave.id ) ),
    desc = strformat( "默认情况下，在多目标情况下，可能会推荐使用 %s 激活 %s，同时等待您将 %s 传播到其他目标。\n\n"
        .. "如果设置为 0 以上，当 %s 处于活动状态且剩余的 GCD 数少于此值时，将阻止填充技能 %s 的施法，并推荐 %s，尽管敌人没有 %s 处于活动状态。"
        .. "\n\n"
        .. "设置值 |cffffd100越大|r，可降低 %s 在 %s 执行过程中发呆的风险。",
        Hekili:GetSpellLinkWithTexture( spec.abilities.chain_lightning.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.primordial_wave.id ),
        Hekili:GetSpellLinkWithTexture( spec.abilities.flame_shock.id ), spec.abilities.primordial_wave.name, spec.abilities.chain_lightning.name, spec.abilities.lightning_bolt.name,
        spec.abilities.flame_shock.name, spec.abilities.primordial_wave.name, Hekili:GetSpellLinkWithTexture( spec.talents.hot_hand[2] ) ),
    type = "range",
    min = 0,
    max = 6,
    step = 0.1,
    width = "full",
} )

spec:RegisterSetting( "hostile_dispel", false, {
    name = strformat( "使用 %s 或 %s", Hekili:GetSpellLinkWithTexture( 370 ), Hekili:GetSpellLinkWithTexture( 378773 ) ),
    desc = strformat( "如果勾选，当目标拥有可被驱散的魔法时，推荐使用 %s 或 %s。\n\n"
        .. "默认情况下，需要|cFFFFD100【打断】|r 开关处于激活状态。", Hekili:GetSpellLinkWithTexture( 370 ), Hekili:GetSpellLinkWithTexture( 378773 ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "purge_icd", 12, {
    name = strformat( "%s 内置冷却", Hekili:GetSpellLinkWithTexture( 370 ) ),
    desc = strformat( "如果设置大于0，%s 在距离上次使用时间之前不会被推荐，即使目标有更多可被驱散的魔法。\n\n"
        .. "这样会避免你对快速获得魔法Buff的敌人无休止地使用驱散。"
        .. "", Hekili:GetSpellLinkWithTexture( 370 ) ),
    type = "range",
    min = 0,
    max = 20,
    step = 1,
    width = "full"
} )

spec:RegisterSetting( "filler_shock", true, {
    name = strformat( "%s 填充", Hekili:GetSpellLinkWithTexture( spec.abilities.flame_shock.id ) ),
    desc = strformat( "如果勾选，当目前没有其他技能可使用时，可能会推荐 %s 作为填充技能，即使有技能即将完成冷却。\n\n"
        .. "此选项与Simc模拟是匹配的，能小幅提升DPS，但对某些玩家会造成困扰。",
        Hekili:GetSpellLinkWithTexture( spec.abilities.flame_shock.id ) ),
    type = "toggle",
    width = 1.5
} )

spec:RegisterPack( "风暴使者(黑科研)", 20250417, [[Hekili:L3ZAZrXrs(Br3gmmJWN88qsG2qJ2am3YEkK8UE1gHdyJvJAntluVmV2P7bwPqXeY2lgjEBBW41WzBSbJngdS2yTyqG)XCZ0ZWN8FHRE0pQQ66r3ZdeMZHdByQSZkZSYkRSYmRQMp18)P5NRGML(8VE6KPhl5OP27iPgD09MCI5NZALQ6ZpxvT8ht7OG)qzTsG)7Z(IZB)XpO5t(PoRFY4p7XVx7B9ET)SlLac3kfROvaIpZk1RLhclQ5wN(QaiA)1BzV56Zp3I1nkA9FxE(fd2TzsowMrbFDv98GFE8mZp3YgfkOJHv3m)8Z15N(NnF4TTp96DENN0C7pQ1j3O9JU1Zo55A)K726tFuZhD(FN(XmkAy)V2S1z)W2BUrRn2Q5tU2)76VDJPBm9Zw)TbG26g3Q9)67BDJVUZpCMFE7pUX0Vw(3y)ZShJdoZV7pm9CZ8A7z8L(BZo9(SQV4VF1zp4S)1JC4sh5qRo7mRo7BwQ4b2V7)C4dmZHxCrydZO9MPpuP)4QZ(6h(a7F1vo2bk9Bxf8nZU6Hp0bbF1F6np8rmNT0r2)(p0bb0WJ)Oo39gaPx7l9vD(8VP1P)QwN7uDo5t)5TpR9LVFR132(Qp4zFZhbO4wx4EDo1T7C9Z25(VJ9LFG9gxS5dFmj8n3(gTU733(Y3S1tV7Z(NNR5top8hFY72EJ3T1fEpaEayW(83IM5V6NBFT7069pBRn)UoNBZWkfoXShC1zxDF7hjgMzMvxz)()tplgWSv7ZSDyKbyzggyrca7npJ9)4tHcGB(ehUVX0)5G6I)LoVZ1T36TNFUIgMwMq9w7TVG9hEfmEb)9xhn5qVS2If1lm)bMFoT8wgvkp)ClPxtRyoZQg1mSWQM1mQIBIefEAO2N9unF8nATXv6C9VA(5aaBPxZqdmbtROEzRr0lQxc8)9qP5iU9PfyEaKgC7yZ61oQr5JMZQILEjssdaygsa1mZRxUGwz4SqkOgLHL8jM4nwWHESwUsnJsM5mkF8k51Gi0LGASqSglSy9LwAKsA6fnTQvPuUtORvfaHPfWorJfMQXcjBSqIglS2AoqMVs5JRJjBtRk1kz6cAwHaus7VNdbKpdDcJYfa9NXX0HCXyc5cPexwreVxhIP74QysaIgdjlGcn9sv1nTYbbox(k1lBHKczssid0oH2X0lZveKgjTs4ZPo4dYMJlBWcc)X1ZvOI1ilveyAoN5YvCWPtt6L1lzOBIPdjGpoIeChzRcg7RuRGbqD8eAhxFK6vvpQhgblwAnKdKMvlAugWm6fY5O(BI6jiPUKXrx2kxn9sAgLbu)KaSNknUPAAgGp44qTuTcfmhHcOJMVaSdPKMfH4cj5xSsrKqDVDNUJ)yUQzTiGinrmcw2JXXO(0MpgwSOgEeFFcjoNE1SEv9A5xwR2r1d)KYWp8CCnqNbq6i6)DWQWwGrNIlMBP6LlRxePvhS98f9AxQyFIqy4zGXCK2J0QLpxbdtNUjmA3OHEFEd8LgLZ5XHqMlvYqWDLasc9Y50mn1Qx0IIbzMvoILr(JbqT7OIO5UtgCQoEISKpyCpPHpLPzUmGWaM61kUIPvqrpt7mcEMwjf7ekeAhxlhqlFzK4s0cRm2EiLJdj08eCUbyO0kNXsGfJzKKogiq9AAzdsdfMj20In5waaWH1XmrIkOyX7V7PmszMaQlMW9FvPuQwTxQHMuuUlq7qdLddPgLeWcvGDeCTywWuSKC)XlaClEUbKs6cKyXdEsxaNuW9znWFTiQlRdng4BTOFk9rQ(lwVMJGVlx)rDpo4THNs8Yt9iTl36Q41oqO1xP0ZfIH8hHnx2hBETty7Ry1L1YDIkfxs963qlREGNReGo98)ilPFV(ypOwDaJRcNzmP6zguJxm8kAZdIxxsKKZ12MwnRLXZkC)CIDHuUaajoDbRTC)UqUlNockraH8vs6IzCC0LqASKrn9CLRCCnerk20Vd)c06kIKUudqUQrg5b9kYSdA9g3(W)NrDsMURtq9GFtKDWs1Qa2zbIFr9WO0Bg0DyG2uCAXMIv7jcCzqSZheuHVuhHFwRU8GJRhqEJj0RO60k7k7EWKyG4huyDBiTyd2Y0DZisvuHnuEwS830rbD9QfxjxTkvSi35uWPO0luMwSfuxdvWUvQzkWMB5tASIEMD5WXSuMKK6XeBTNjIgPOu3jyjg4OIrcXKsgWOC5X3HugOOMJXs8mWkEMMmvJ0cunYi1DMFP5GkZUM44dAgXZSgWUVXqB0EOLPl9YHkQqdoNWYOWBOqYZC8ZAuXEleILfgvSJa(QUbwbu0ADO4QUeC5P5zde7I(FZIfRuPqX6MbIc79UG9DUENB9(D28768txT1jVP9gFK9hEf7RSL9M3QZ1pluWwwpxEq)pEYKitKKt7BDQ1BD2p0(A3JDcVqwCzDTIwlps18wOvxaoE5JSR9PTo570(bFgskfomaxaHafT)0VV1x8wTU6t7CYNcXIy7om0XOeiX(7EC7p8kn)XZy)9B6JkX2Cyq1yjd38Qm86XTolSVupF3pU1EoKY3mKxlCCHnEGqiUlO4mPRCL0p9HiccIxxZ6qKJ3lK0aFqiigsVxiMpxTc6)BfmuFmgknQxkxvWCbGdkALpUrr38VjS56M65QS0s5okqPgmHXkyi3C7bTIa3Eaw6ZvT(QRwuhyz5Vh4ZD6nUGYUSeVrocNNdm2r0gZOhNitXDqbU0vLkflu5eLjbXpAWO4Qpm23eK6PNVdJayq3LWeQSKAFKklqzzGi85kmbiTmyuifJ9op77UTNZWemzXOgMbC(1rSsbmjAMdk8HYdxMBapxGO39eJfQxdLQhmFtabeZ58B1xS5XIWncJhVGlJvWVRMkRQ(65)erZIvSig1SKenshGsRyOnTGH207OdTPvo0MUVn0YTV2HhAtJgAz33VNJd6A5RayTk5Swgm(OVsLYfezdKpSppmcYXW0yogMgZ1UeRljUCyjTYg5ZD0Ag6lbm(LFzrCxq42H4S0SCgRRs9Mf3HeA0LRnbwpS6nBcdj0SaxTw1H1EWzaXzftKN1GnKuBfV524HNGT39gqK1xp)nFqTPce5Ggm2jDA1vaPxZuVgC3xcgm8BV3hm41x7GdgEKdAWq8wZFUnyadzdsfH)yHFZ98qbVEANBKWJAqdestN)ZNbciQb(0dqwETIf5pAWatppKiSp35gxOjjuOmy3RcDSr(P1TFWJTV8zBDVFS9vVR9NDk7lF)NDQlKnfS85E4LS)URBFTnb7yhwSHOWeGltq7RSfr0JaDvo8FjhS854e6tV4bdKEPy4kQ6yZpuqqmLd7wsRZD5Mp5dqCdR75HIBMAqXnt5YnGH6AvSWLhNPLgyGUMtay9)zJsvlQ3WjIKrH9B)0ByFPhJyFwxyJe736I3R9L(kYIsS3zCp2dhUsk6MQckrrXRAn98vkTOwW44XYlbRqtyfH(r3R5dxhkoU2M4FV9390238tG1W6gVBZh9n4)A7p(F0(8FDR7Uv7h)pS34IG)k4B7CQhaWwZhD(op9dADQhzF1h0C7pQ9Twh0kUoHX)UxzAcrYJb)7PGvn6cT(Y32(tUwZN8zar7CgLQxeX0VwnTLSa0sZh9UDU1xa6eqRyK16P3U95VxNFyRwN8bD2c2K9D(8o)05BD6pdf)X3R5JVd4hFJ3aWm)82F8yPsLzVJn(47TXcDU3)2(cxS5tVQ9PVCRlEU2NElq7aUU5dVDN35jTUXNA)TFr7RF3o)0f7C9Z6r8EKnIAXvuR9wB0z9R06dEla5FTVchZZwBVERBDMwBEoCKpbq38XN0(83S1fUYZ(F(ehLI1Vfy(bUuP91oGL696VV93(LT(NFvGqK2(T(MoBCwNg5eLupKCLB3(s)qZF8mTV6tzGJktlTUXTADT7ZfUXOH7RbefdeSomxPkWVADl)VY1ip8pvSUUN)2W9cyyocNWCHNktdg7EL4bJG4ZXdu(BSeqQotMcSrgEXqncSA6WXQPdbRMo8SA6iWQPPyvwN9uZQXPdni16RElN)QiGgffFqhdYNWWk)Y5kujpGxnZ5SI6k0R42yH9aSaMegg5HvVioa8P(n0udXs5E0cFukyrFweYlYN8ripprsqk)f47dVOihQrHuikPGoYVU8lRvXm3I1aRrICSByUTG(yeFomInXOiUhSlxhwVWM5kPv7yUObNb)riZub0zT9L0fp8(w3oIs)dxkaL1SQxtpxjhNCz9JsnR74MiDw7gPGwjTJQtZyouMpK1Q4jD8JMalzrJdeg4vV2dlU0hgwWNrj(5sC8KBbZUj3iQgAbhtwjhasUaU1GNuLbH60Kgfewsej6EXKxsEXoh54Mx3Dut2)V))c4mxpFitCmx7yOiq1W5TWVi32W(x4LF1NDLh06(xa40vQXAFR33NrQvVSipnTmkPJYztQX44eCNF4FBV5zMxA2xDO(ERUMKE0yewH2qHNVHwruaEhawg5yt7U)248pXoCsWRluUhoe6OpI3VnvDTtKqwVTR4UZ8UVmnz2htnn02y8GNIFD2oS0EesEt4oHkSFqyo5n4TitwGx8MQsSkN0qUkDjCIZ6Ju4a637LoGkKtTD9SZTrHfAT4iG1LhIGSD15fYNszRzFoUmem4qYgFtL0D(sCXbgsUZsoQsQg3yxiexzkEqWOtkgqV0n7FcKejIqFjxNlcynle1omWOEElyDZa2BAEG4)O61iksQX9evyNTcu(Eebciyr6jmTOK1RxaIU3p7GcStgH5YsoOhHs0kETqPYlXlpHf)sobeJ7lCqTHkrUaIfmxRFuT8RKRYsODsHlAk02xCZ9Murmm0O7ZNnyppfIxcmkyLNWPlpXMmy(4GLx1aA6a5ZQ8pbiE0aR(ti7q)fygs00Eh5mP9f2PwuHoofRflEh5GOTALKKsj3UTJ9mra1xl6EjjRXnoO(66CM)HADPI1R5VtCXAUtqU4jTAc96NbcoU7hruqWbi0Io7eajk475C0pDFChXP7iYYqxC5v6qb9JJWGslN98ryGk4GcpcdInePwChcx9dCej4bhTBlUr75xKhHbXE3kZsGWJWGIJWMGZjGVqu(PyGiJG9YPgKYWe75HqPPPU78qiDnW0u2OeFQhOoCeso1duNocXN6bQO2l8upqnTuXPEq8KtzAtcp1dIMloqxcpsl3k5GzecJnsoMd((eeLcJNkUiYIDePXmoHocJHwBFbrHoIG5ScgfOG7Qt(2rMWFYd)6cRl3OIy)ULy7mJeNk7LfFIRETaI1l4SAsczUmmiwfjdpRdwYoJbHzt8J2JCYaiQeINeRKBMGysfVO20ZyLiCpwYIXZGlsKubCr(MmP7iXWY0NdXBYVViGoaO9wiKMGncs9BgIRIM4y74cmNW3ggEHq4XpkVnwizKwqlqSDIQT8rBO4KNlSYR7LOh1RXfsuTs37EAexr8cixEtUUycbRsgnovuTt3lC6e9BonASupCbJOk8APeUrbC8LcNFXPOcGVSyqGJmcVUKcolVYGtvPtbaZP6VeKqWglm4sthMg9ttNA)evf9FV9)jjK7ErQsjghtP9AXEq67bmJ3DIUYKctWaiGruGLsiC3esZsPQeE0FsuLY7xI(vsa8ngGo8Z8wdrTFDkdyECLvmepjhFiXzckHih7e7SOc3KzV37mkJOkCVeqtZVSKHKmVVDYq4VC)WluPZbgs5SPer39WDevq53)BXjz1kGvPwQyLtyWpX5kPnhdAHpD5E5xpM399aywaMp0k6y0DeIKSW72ctT)IoU2YgGo3FoWTuvpETzMHYtjv8FqpW55IAK9fsvkIK6XoHthmkz8Cv9fpfk5kmDzMez2wm5OvxMbrgmYruR(02TCfRCl7w9Ie7QuRBVxejL3cIBp2fN0U6zod2uEvsTbBhSPWVcmXZpztEhKLecIiuiokCmb2lwO2mzkpgieaRipZkU7w4ujjI3wqsXBlq56p1lxth(hmIyjgGAv2LmNu2x199gHISGXyjPz0eStTfRuUU5iwN4ePZnA18YPL0HD7qm5euygpuNvqFlr8InR6O3kmtT8LvuhmbHzGrs23uA5ke5XqSLnv5PlCjSv8mQqK7djx8yCDPnR)v2HBQH98MLqfH8ciKoFzksDfvoZi5ug4e7Aa8JdgbAcKsLBlknB0DQyopDu2(K64WqHBs4Sy2WDxL)hY4f03YceFjdohd0XWK8KHkYeHLSTLhg3uEbmdekCks2ovjgvd9UXJasP3MApSJAFusVHn1UoOkOq7Kb0NkEDcZCF)5IzJN30kwwpKyM0BAXlZhfmYXB60HBTCjBWjI(zqFbvlnSRkdC1Zx)hOdUSi)hqM8pHwni)Ao)CD(2VS17D6FE7pU192U1jV5UDUL82n2U9ZU26D(Y3cE2rF0v7CQBdpuN)0DTV0pIEhuAFN7S3ox)SGVTZtUJ95(8FDJfEnuuZTGKFLQ64dhpWqhCT4DhpOX61wd9BmhHFNFLY361wlo1b3Fx7ktYKtMntYeGwgYlSpShlTyUnX7u151yWs(orIDdgFQ03P6bnrpcAuzIOmQmuqgm2q8yqNFLIbHmIy(iUKJw4KPh21Zm)j1WltTejcowNAFyXM3GYVaiApAgpMKkj5GYUDpoR0xDq7U5dF0UT4FTcT7FE7nszFNR)ZBVP7SpH4mW1NflIdcWGf7amReT4H0YRieTbbiceDOWEUUbZDH4yWIDHcBfMcgs8vEvmbkLX6VMh3Lm(AYSIgTGt(uDTRmvwz4EGzq2XG1oVO9LojRJz1uCN3KwIz10knRkcNkMlYdGbl2jNPlcTkm8XdGiq0Hc7snR2hfhdwSluyhvZQP5m3p9GCU)UKXxet(t3tt(5G7b2KFrMvFUlAFPtY6ywnDeuW7DVXzD3FmGRZJ1h92NXZCh07WQz2rz10dwwnnfRo6aypiJnawaE8OmK0xNpVlN93X5oeDYSbBlAtOfJ7b205bsumEjtg5m5yhmwwUmDW7kvFbAW7K1OjqdI7bMaDGQ09sImYrPBF74kDbVvy9KNbV7zJK4miMhysZbPg3lfcih1Tifz4(QW0vAcXKzWB8wprkt7DLCvqFmWeUdsTVxgLxaLXMp(MnF4zSV8g2FY1A9V)o4Tl6PxhE7KIs7uZh(T4hZFNxG)R8z2F)LHWCH3V5J3Y(Y33(C3T1J(aay2B(0wBCFGkDJPBSW)zJf0kVc855NnRwE3ASHmVwJlWrz(x4LSUmlaQGo6kPByVWm50hbajsDGGBBto9JiiJu3X7g7KtFXfSGD0EfSPJWm(ieQi1nYhF4dsK6Gqn(ifYi1DQhFedwWoksU14NXnktjUgcJp6WogtKFTQMiXEGxvPdlZUuIP(n(9gHTjN(IgbCSDr(5btpi9Nh0KP)kfYz5x9LjwEeO9y7nUyRt)PyJXnF07U3Mp82K27rQnZpNwD4XSy(568ox3ER3gw6mvwYaEPE(RGxi1ViDBEp9V654f6nSZ6d3P3GHbZL1agLY(F8Ndkn)lyH()baOQ65ZQxEz4Wi0UsJPlQFC9Iz3xYgtxtlVEwlT610ld(lvkQNvZcvjptxTIPbK)ZUi(Vcg60nnHtZb4kpazWsxolqB5vbAnUvoy2r3xJPX6oMzFT8VX(NzpghCMF3Fy65M512Z4l93MD69zvFXF)QZEWz)Rh5WLoYHwD2zwD23SuXdSF3)5WhyMdV4IWgMr7ntFOs)XvN91p8b2)QRCSdu63Uk4BMD1dFOdc(Q)0BE4JyoBPJS)9FOdcLf)QGxY5tJFn9YIkSPAaFLW)9CzAm9sf1mpww0)fw4xAfZVSEjJ8qxMq35WqqaoYNn)YgvRUsolDTgtRv)OOQ)bHZ81wXeWPfnwfyeCAypuPMwTvY5iCYwWWenHXH066RBDq3ICQZCepFEYsEXRZP99KL8YxNlaVk51UoFiiVW1fbb8QwNFBU(Q(kWZaQBKV9ts6RGUfCZQYrS1wtQpumnlyDtgO4TIxe4H0I4brUH439CDIGPzL8GWvTddpiyJdoCY)pAH7WiScCfr7kMsThUxC5dl6slpXWGpjo)RP8HdCfLpfWWCIHfEXKhksp41UTdT7Sbr66Y05w0EyFgJ(u2dOsX3B2WVc9nbVNXr1wvWAHEyUG7iPeFLzhng37I0MMX5F)H3TCUd)5u)3avYm7jT7uebxqyjuWIOflu(8e7jkY69ch)kopyXzhpzsVMHgPDFQIP(r3NC4xXyPS(QEtMM6tjFvHzamBgkid(0bZa)OcaFRZYa4yjJHKo8lW4PYMHep4LZHyO)gQMbDzDsYdW0MzaCFWr)LV5)xH4TzmBkXFoNLFO)uKSQNZjPyrs)Qyl9Q2sU8k8jr0ZNcilfMYXAGwnw7YVxKu2aCQAXWfxpjy)5QokPGpnxbpNc2yGwVg7YVxKi45uxtrtW)CSInep7MNxFdIP38REdX0fRlTppOP0IPPizDyi(MhuIyLA)dXx9NeX(5eFaSeMJP2xsYPpLyZlRUdqX2lhzLMuS5LCYbNu7LHmRskYOZJ2GtUjiFD)soNG49X09pLOKddSVcL4vDWNYz4GcSj)THLnLhHX9D0ukLfINfu1ug((3niLnvQyXd8KGU2AmphOj6dKp3N1t1eo5hWL8zEApD2UQKhAk)9SJfkzjvKGDHdRk81NAT1CvodEvyGIRQSRTo2EhW4m3FDKdy4d6oIOmkPpzQX485eHXGG65FIpbJJoNK8G4XFQgYQIGZf6ARnK0Eirmo3tRb7mNZ17R4DBkcJd4Vw2fQiY5gSPUG3ortbMHfhBiK)U0ZYVnVl4gpfCrVpuqJssW)uzNiHsqglw8GxHutb2rzcEdRmALYcnjahRTMK2NCV86bF440itSWGuGanIyUXCIPDMPQRTMaWgNhTXEI29xOtKWnvYeo7JJzboXljagVKjurit015O3GTiaMm9WO4iWH5yor4eZAf(i)GJaLWRzOPghWNiq48qgeKaq8jkwhrCcOdzk(MQtAKYsgoBdDJ4rIf5a4NiupqCJfB8VkwZooMHyVRLMYjKGYUshKjkMm7(chJhzCqDzc0vyGzakIAikmaoe)5maPL)urbVmrGP4(tMdoqZ1gQ7fBdHNdbm)aMiZVPPYoASqzAJxxZOK56(KVEeJMlQf6xoivJUCA37UAqWOMgVNQhc6J)DWMNdpcCQq0Tvtq6Z)cJGOtd8os4OLq98)WB01)Uqsk2qiJ8IJI3WL71Z0a0bls8Wm8W)(0dTON7UDyF2f8gueCFLMq06YtYO8kqhFYX7UjuK5drHn3alvfZLBL)A74Srwr2Sf0ONVErCjz(jndRvX9f1r6cUYLnsNYiB(UAwQBhnt)cZseQNAkBYhTXIHezTGA)JCVNXyrogOSHKuWqZxJlUcN8Miwq)BteEh)866a(iiWcqGjYEyWFDgLgeJl3mLNzSag4siADLE1WMy2IZMEKVPJrJmr297kYJkz3zOukCcHOXxnQhqYGlOboBMtMh2(Ov51LwcEjXjm6bHC3NtKOptVcPTUlYjYj(yIdSsY(PbSrfZwdWTKQEtN(80GCHT4cxzZ1gUmLNeCm(VtWht0R8HqIUFSV8uHvDnCloggA1TaPicuTI4otcAKJ(mF0G2cdrO5fcLVbBHGqmvKydiDBmFs0JERlKmDnekxHvvGF72y26Wv8VU)ZMMmUFm0T)0oyHoIeX9QRcXyNq6uTJYgzujyCNMBwTObSGpj3hgCMovAdNmBQ0RTg71JSxJWaHkuEWC5HQ0a0yXunfjgvQbXsnGVAryeXnOm1RQxZz5WqOSRwK6LA0Gvd7ubBZRGrfl8yn0tmHTpt8UZJPDsqUogyWsSqNCleX7Qam1RBeyCQchK3Z5cM5048MjKLxl8cXadBZUfJqhiOal66mhpkZR8sRUKCBgxfiXI78KSKfYUo)z(vCqIej6fvoHSgz3ieiEP3IDjZi4XrxVofsrFX61CgcW8mwpNAUcUdQb(Jfr4VUNt4dgHyqRE9qV88X0wpqGI7gbjDHnlIUdpmbzHWcsGusWBDOy8FOmYMKWwKISakqdDsvAOIf1Er)we37Ata(AaGvmv5nAiITyFo1lmeq)ivdS8uVNWbrcEX9zVL8bjyl0R88crkiIU6fvIicJH)GPJWkmzJikwwS62CkeJwIjZBwE5Aqm7hI5pQDHlSIGEB4m9VGD1rPNWdoheK21rXha0MH3HxMxgZOmdmYnNRkLqQFWAJqX)HRu0SCl9pY3khKrd2s)ddWE6M4uNYnWfclBjWkVYL)j4qice9XKV7kvRF41o)YsGlHmOQAoVEGo6yw9wWXIf456KtpYjrnsR7i5hzAAUMhetMMhFhLccm47K1uy8j8zFnyWJmkp548OJOMXjH6wdjv38fJHEElS5TYM0xrtvtIvf3ZjaRNf8PxfyazK9XHojIflgTupTQzP(jI9m2frwnJI16MG3axexMBcjLPgM24KOSuVOn8jFys(x3hKH8qbvi)W7sY)1D07uyg5GTbLgc2)YKzt7vA3CFisj22n)vzIfx8tpkxHSW8IsTNAvf0Bk34TkgeEte5TXgM9YJ(Tajolz44ehrL4NkuXvIRWiFOstHvrjCuAWNKloFNGK9XtCQIkdSxc2nNlFR7kRHsVEL3gZ62zPHQAR8DUI2Hz84c3WCOYXqEIAYyqXXbc3dnwWhzt16dY5fETQE)O8m3t)yzkxCWzxfkk3mmwcB5MrcnRMUyUAYmX4CUOfI1xqlykgQKBbtj91yueMIOR4cXdTtSDpE6Mnao4QujgIJxGOyajY5(viMcRRnIXqunDkersw0qwXtPEblv1Ocld98F5jV(M4LHe(yqo))h]] )
spec:RegisterPack( "增强Simc", 20250416.1, [[Hekili:S3ZAVTnss(BXyr0i5KrrIs2JZEwEXTZThWeS7IdBM7UVjkAjklIqrQJKkE8ad9B)6hK97Q7MsI2jz3VKhIn7UQQRUE3fNpE(Vo)tRIQIN)3dgfC1OPJVE44Bgnoy88pv90U45FAx0Yph9a6FKfTf9N)LSnrzlJ3gNvHF2tP5rRWZrz((ILONVPQAx5F89V)HKQn7VF4Y8TVVmz7(0OQK8SLfrRRW))LV)(087F)QIOhYZwNM8WMQ3hN9qsw87xMgvwgUnF1(04Y3xUmSCt02OSHl3TB(NUFFsA1VKn)EJa94Pi4yx8s0pF9eeOKSAvmDSXLlN)j8y)Xrt)XXx)hpS4)Um(WI97qWxs2dhwSRijViP6P)TdlQEmo6Zhw8FvKSnVyvsu6HfFQkVy7HpE4JSP4k0u8lB3vK)f00eVEDYYK4SLpjnMj0XKsiwhw0VmFB8Gdl(3l3eNDyXphvfL(uj6b)8)X)a9ElEl6rRwHg3QKYO7tJxHg7(QKueuHwISQIK4se0LFyXQ41r7tRKwSrn4KoCV4(415fOhvTb9h3VF96dlwhLMIMT81RFhAY)cgGEeTJLVhbp)TO40YQc0o3Fn(HiesHgw9l)FwKJH4)3KQLB4l)e6Y)PKT)mMMI3z4pm4hdUH9qJpgVD8)KNwfLS8WI)CA0VJwOeeWTEFAkAXrKJQKSLOLDncMqWqkIrenHBYx(5A62)i(ljLXRmI8l3eJg3cef4WI)cDVa)u06GXK3FyXVMxfVfV0F6xLal8w8)iU8PSLuAdfhM)Pue8usy5rCoPXO)1FNCkkoJSRn)pt53ks2Hz5N)PprggIagv8qmAjJwI)Dol3Hf4zC(NO)(8pTeT1es)pH0NG2mswwfMSgDMmbJ73EyX4BqJe96Xfjrs)8Hf9q8qi8oppDv(JzdxLNVn8XKSvLdlI3gLKHiTZoSy0Hfp)SWWk3NTcnzzpyAuxq5BgUjVkeD(F1W97oSyaLwesfmqPgH57qh5QqNavijCyTF9CTTHnleDGBxoccQIW7u3Hw2X1RlzG7yBQHL49uoaElAOtjiSZz8kc82qJvNsmepbeIryFvYYpteuqjUiwieF0Wi8r5WL1NKhw)YuqVEicR0JrFj24yqSIBqtE4AmNDjFicam5rirHiEEmSo1g116o)DhwmrDR304q8s)KmeexGPw7sqlfgeUceeQXkK0eeUxgMK9L8LeX)CmZ5ogHZRhMUhs0oKHPp3JesWbicaJoz85ym4Cni4qwOuIKSW81Hi5yHRXIXqymskgHtw5eJiQANYzEKiAxGeTJtGXG6pbcQRYRgkStpuHRRikzviwynIZBfAZkjJav0vrJtRbiPGSP3fbNxdDSapfyG9gBCAGWBTmdFodCHZttcayu5Y4SvydqWW2h(6IfC8iB0Q(IOkYSHI1P5pINsga0cyRwGgLc6Ja1pqg9aYuVCdwtuj6uafpWQdjcDhEdh1IBuvgEpwtjb)uvZPlthPjDxmAVRELNP8ZBJ(TW6hvlhL(acniCz(ESDscNZiVC0JrFoMq8jIQlfM8jnOKx4ph5QxwcsbROYNjThx3OMAQAjluKOyziYqgkPxGfBmhOuyYWWgSkPVwyOSZWaRMY98BE3cwRtBMrdKAy9h9nz7tpovsrSLcRVYtfobmqKERkjvYeNGg(S6n7VqnwgtO)DbPP8zZHDfuGFvmvZO8GOAmK3AtJ(suiECekfS6RgkIG9eINbqCilRWAErsIxI0e8qCH4jbgc4XGfeuH8PSCdxcnbeHvAzc(yRj5ylH7vujaFPOYF4Y7DQ)zFwrm(Fii8sCtOrVx6UnrHpMNUw6P8Foe5JAOKv5wr)ay9qQmYa7XbWs6lJRqhAY2xoS6XhdcNUBPDyHiETzasmUIlaEKtehPiPwzCWcvQPNCjrrLLyhLnr03Iaf0bttJaWQgiA1vIWDYs0BzeSDyGQdjZ21ZytYwa85vk3qusQ(8qTqM5Vra8jkUZrGEReaFqXOjTZy20YDkTXAwbwKMNrCEBK4UGkJO8wXKXIJvetvghSPb4x(lXHkCkctAsrCyw(xIiZJeNDCur1MqgpQ6AcZDJo5HfKuoCDsAACH2skrZrgPUEFwwC6CdHNWYjgQRmmXuZbD)t6CD5(IhW8Cv4qPOIrIduW(D5rz1H2ZM18IkywMNHSz6bJ2vcmaMYBipaosRtMbb8cwl4RDzxDMmToq1iabRWSARK5Jg8t1ONfNfVLemtmGan(zuNt5BTQErkAAXPqz71ykn1gGDPjziSjEvZzubJeYlljJFnwYsOKnAJdm7NT0GEy5k8klBCLMeBhcSDV776unfhedDbDtGohtTAtpSIG6vTC)U4IA)C8(4P)7tFjcTyOjDy8VTdzHiABk9(qQOoc)T(ZxMYEUvYoSskUiOod5eLmj7ROpS5KTEb1FiD6zkMeBn2ehTnrn7kqhIVv)mp9eTLx4AdEYafAOENQpyqo5OQYSzuQrit2qia5uOr90Y04qAgakXkKRSg5bjx7TCmwMiz)8EFwGFiegmrG9)zSEscfiX4xiUrNitUvXkJLmtqYydzdfOXuOzGcbwvzyoufFE0(R6qO7GiuFetZ4e6AwG(VPKLCVqyIoZuFcJ(97lQj8hP2g3Ry3lX2LF(hpSBxwkSMcY0Ai8cxW3HfDmH98(UcgGrT1ocsGb5O6C1AIsbpzCR7tgs7xhrKjmq5AKTH9AIEQqZ1ejhbTe6c7wAwtOSz(6uRQUmzG7aaxcdGL9xJWC3Yf3HA4J4HzqYRDHOpu1erL2ViKvWVWcmv2lWM9bzzXbotvOfdp8j8cQIDnnoXyoeVUiUCdE4mNLOWbBpQDPYDqNygKzRgSeohBmMtGyeDic1KalUhgRIJ3L(uyrEELO)s6NqL1tAjEqnYPkQJknOukKpTMbnvcTIlngKkjh7ibp6vcKHuyJGdq5ePqJagqq5OcXT(uzusNWCexl4Zz2yncaynMy1AMV1SpvXfjdMGoXDIn6iR3uGnzd0MCKg5ifmOUZgSjomgYtC2GzwtHnwWdLctHTdGZ6QP)dstxfR(MQOvlgToNmeBvJ6ESwpy4zkUqTEWQRynsv3XQqTnXf5nap6VlIvDaTHQuzRaSqJBxmowgcbTv0MYkNzpeo1HMKOvPeeyBrlwsCNMZ2sd1HhE2Q4hHTjLWAFcLreFs9TCF8jEUJhjyFHtyqTKAGhl34fJ0BwvX5q6J7Cj2oNL65bscAxHLGC1Mjv0Dcl18IlxmhpYQ6MJTWtuMzOQgXTDkYrsbWaeCXoLZK6zsGNGTBSIq9AMg9xIIqLPdXVcN9APYwva7KRDvFKwzXbRKqvvASzuUi2CMoBB2c33S9UJrk()rI6)lzIc2NvShzRoDpW0PFdwgdlI11ElUGoMOS5ASmtNrRZuXk)a7QVUvwkwQ6TC7wlK1fEnrvGmeEnrMTvxsNRvcVn6bzzQm9Zs5stGPlz5HYUKFy9wDs9qFmorBl)HAf3QIbI3iEihmoYWAVoYmICKPbf2OiMEVMba6aR9638f3HoWeqg0c36Chk3gyHJFGcuf2hy7n1hKDuOJo0L72kjlL6j90)PuoCokdZ2e11o1suYKd5AcKbAhznx0i2VHbZobEQu0xHd(Ko9CUnxC9jHrEP2cS2Wmx(bx6kl)hBwHeOQNeizIw1(I681kRl2pn(brH1wRisR5S)Lv)J0PtKyb4tNYHx2zPN1(Aoaqc6XMsfQaAHSD4lEQKkeNjBbqTJvMflf76l7(p0(RZu74jrhMUET4Xf7ba3sUrScnTlRANC8yDiw8U2iO2sQu6AOXGmA5mPyjfjoIQY30wK06Yg(vjd0YPFYMAilLK857uLLCxDMeKypDwF9W94ug2PLSClPtYgBfu(JNizndyYoNkjyakzNth7VS(PwZVHdQaU1vueVmF79rvZBIPzZqXYDwVV4PAjMQ6yehkzwRYZEyFS5r7WRUYp)eELgYVMUc7b1pKejJhkY3VlCB827Jlkf4COdHqpKiWSGcJS4ioDLcu58SgxrtEX9jgQ3s6LyGo5k59r8r4ft9yx(oYvzqq2tDUhX)R09O)cXaL9z0PMQXdtkrMM)qC1MOIWD7)9Fpno8(8FRwJG0W2gLHKF9qrs8AKKGLBmnMA0kz)2WDigH4QWOSVKKAAO3hhTmpdDGLC8((4NYZwra16Wgxp6XHjLOD(KccQQE0TfOAGFOAGhOAG)OAqlq1ajuvvkIBuTVCWvnFZ5FpzqtfJBnrOk6aXseUwgIJAoscZtsszhqAciJhnAe5f5cPLweX34U)K7q9AEkfgPTjKhJFxtOWi5tOi9h7HjDS40YVQXBt8UGQXFETlmMaj1PWfzexEz49fnPt5sJpH8Ye88scAsNI(SXUzp(ktugUnQ4Zntdn92d3ehLwTz4oC)BbRi5MrnZJP3TzHK4)ite6)uThP4zBoH)tlvFUrD6dgkNWSHRI2g9qSmI1KEB2ilYzuhwLsObwYZHQz1SRSYLW2VDjWRjr(ncCMOB6L6bHWPA6T3eof797akNQTR1hQMqM6arHcGHWDWXtMyv8YCwApp(I84VHmnl5GJA8aWOLkBfVrFVIx5haIgjltrWHgd2amR2ZaXtBiRnw8G5wjlnL9kPYJCLAX24(UtbLGFMgQe0b2ckLRWUCmva6etwmB18nFcA80teto5aizibwNWDJwORoOMt4tig2cZQCX8CoAhoqmP0Tf9khO7JWHXuuZjb(21D8H97dhEvlNjn7gAgCZ1BTvCjCPSY3zpQhrgV0xU7HooZeLJ8lOQ7OzSI5fwtWPJ7wTPYzXi6PQGGbOAVT)KzwvScMsj1e(yNNAaGYrausvPZ5aL(W5gLaG9t4wWDnNkrEMAFrrOZfPwgETiK90enAwHVYiLkydWyllxWAGwWzYWRgrHDPYpLOXD8fPBhdNNq17AZ(SYhtkiLip7WHpz8RZnjrkKMs9Zfl3evyJwETqddwwDgl(yxvRM31fhlFsIY3oUQJRlQ7Tti)EkL(GZMoPZYJLdPgY9NJu)5x1olBER92eGhMN0voE6QoS9OcRCuJwUTdTVyWVnxGQCS3Oc9bIIrflIjRn6ppaVMv9Xn1YxXs0uxszYH1oUZjINqSa23IpPk5Y6jfl1zvRMAtLLKZ815zIlj)ARl7elvff0C91JM2X(L8qx3ACODVBBLazqZzdKYoiuUl)xLF0Rad0)Q8J8(Wa3rAlUCAvi6PxQrETYhFzfPDjnn543r0A(9(QyYqbVUisiXAICi8F2ldUNDMU8u6DW)U52qjN2nUqoj)BfnVFQKVenavr895i0uK3AIGpaG8GQfMRV3blLOd0)Wz5QUiiUroEaombYTvUwlYjx8uiQuGxxARM7SLcFQkcl(cbw)IoOhQxTHWPEYeqVd6VdnwhBZ1V2VgO(RVvVZDil3pZvK9G70IoVKd)ozxM50ZBr)ZnxG(wkRcrFUS6CFGOZ9QmiELfafcVqnziAqMJlmpqTP6CRKpkls5ekwxVUGK(ElM9l()EiCT3Hw8Ls4K8fxN70u12iepgBvAJkJiWGCXc4A7BIKbqs8xTpMa1G6Rt3f3sGd4uXtIDAM8nZIftJOKIHg6Xe8wz3PLyC9oTGMqhEDA6qOKwI6oIGsOhruNNna9H1JM2)RgPrrKH9GAqfaApdP2zFBx)OGHqTmhyUIzHEG6yRuKXEzkEB4gaJ(c0QFzZXrjWl3Ou6e)Gb8WANkVvFJaKY4I1Beh8rgNYeTdcwVS7KTLw4Do0cPGmsr)smUdkUvbZkrvaPg1eHjvQu9L4sC0g6TxD9uATXpdjqU2uHD9M8zlCU10X23KksHthADamB2xYAy3916z3Vb3k0hvF)ULAvM2TfON76lUNldBvmqnN83v6zdwkwf)cUmzl2VRI(5yCjssu5q5t9iInABDUQR43Bswl6eDzU2(kPKDtkdzeUMIboc)nyKDnNv(1Ve0ePb9NPErYy)Fld9wLH(wEM7uDwxa3Q2qmFIAKVjlCPpM47N2E13ci(vai(YODrltqODtuz(gCtfQfEUd7oLUs6KYDXPP4rhUn6HKLerYi9PXHlxnN)LYG82HjlnE7m8AoBGJhkIJqJoKcpQUUFV4P5KYCK6704OSYeEKYSSA0xbVCg8FxXas1l0rZNLxWhVVmgzR46qeTUPOGGkbodx)eT3VE5moujH4gD1rYjinj59aRgaUWz7sMD5tilwbuuEOGnqdri4H6YhVET01ym(grngZn5zntAu9fes50iVi4vVaruF24xcPnrLHyIpMEiz69lGMrbWGhbO9feh5OeaHrGxIq(t50pgUcCdwOg1AFTE5vlxMMxjS9zkAfk7Xbo2Jda2Jd(6ypoW5ECWzBp24A9kVhhm3u0wA2JnF74mlv08y7CXI23NhFvTmRRAezbvqRQ3Rqi0uFCV2OyGkkQgjOguCtofLqUxxG71xMrq1rzl6WZnfjhMlq7ZOZfIFeC1ugKZft1oMttJZfGkDmkkunYmNMOWlaLgA8mQ7CB8ci3S20H7tZZxfsU928CbD7mtp)4LBABTE5LAYejYaN52J01RWUcYbV4cCA9a2v4p)03vmTwVI7kmWzolKGD)Us)dGFv047k4WqryAmVPWF8jVNyALE92syqZ8kRfi2zDhXRZj1xJE0SIRvfZBlkJ5K3BaxZxVnizqAEL16Od)sILT2mYLEwAfLtpyZSux9pev(8y2OwIqAfIZC7bzheC6cyHvrvvwl6ovy6orsu(dOjAyZhvGUGUfLtjAWzjODa4zh6KiJo)qUOdLsGy7HaXR3E9(6XFd397ZyGAWi95kUxJ(gVs0s(kaKgDTRnU7QR)BTlmTJo6QF5iwT0PolFqfKRgPZYNtb5A17CNjB337dUCQt)(hlLFqWm1EkvAlF6nvZbhzP0RmZv8VfWUUyoEoJgkcapZwTL6KPL5Hw(dIG17IQZ6op(f9BqV8nUf6IuqVASwL2lDBhT1qtOVHnP9AecJnt8gZ90ksj7Qi4FnhUQ9QbzD2fRQgCVhjOpZO(sRYP73zTlcibNqXeZqNpGPGvQRgikgTreQlzUZGEUC)zNJTfreBTmC)G5Uj4uWcTjt0IxWNVA6uxhmDn7Tw01UQ46jQLXVLkUgw3T01OxqhSSCl46Q6RiBBChLV2PG)yR7yxBCKj3zPp335apZfWCnI5Xx6v7Lr31msfzWN6911KnpAa9jv2OcvHSF9QeN3yp70qyvxwjmoAjONsl5qOOzDwb1wPL4OaDJzJVQmKajpn5tzwpJxbyLzwZbqWe0Ck9WfN3PTgPqmbjQNHKIs2yvrtMkCBO(8IZyjaijUwcLnX7NVwoTLY6TjslCUAdN0ipDD6(cE7)eMh94)klOBHToGc9TruWK2JX4EJFWFDE3noh3QuNYcp5lsRstKb4tfTZoiZPzpUwSlnnozloAI383aFAODg3tJhFb)0q7OG5a(e4Wjz2)6qlKfdB68agG5p58QfHVtboG9r0gEBJFQFSQdtUSUbdXJN3PzLQ2g(RjTu0sa)AslDi0E5PBPT)BJBc8Rjn0jVovfS5dkw(ua4HmelDOFUYBnXLqcgjHLbXCxIFgszuWvJMI)ev(yubMCG8G7xX378KT7YlAUj6)aR51)dhwue))ThrOr8SL54GIeTVkFBuf(hqK2ShqQNo8X)Asg6rx)hpS4NjhLip(hAQ9cO(S(pGZ4GW4aBi7Ob2F8VnWVfsT8HmVkggL)lbq1WAELGhS)lOPk)Y8QbmsPL6NawkOMeV2kzzG(Vqo3NGgL)lHV7togS)lOx7t2gP0sDJ8sLVlMMICKoC81)(h633A7U)n9NEzT4c7n5(bdElUXXF5fn2Iyi33dU7p13selKNa9OEi966LoT8RRNC(bnerhO87)EcLr8bh(ObPZ13ZP2jBESlEjAazfZ45Zpt(nLQdP(xLI6f63Yll71xQEqEZBMmA0TZMmAWZp3hgp7zBlONfYlNN48d6DnKZ3wg5AF5cDSR3fMWU6Fvc7Wiam8BJ982GlPguOEjggGNtLn6X3qjxSDKVbaAgmZ3lgdQcwS0rnO3v5XscXTmRA1QUHP20y6253NzMU9M9KTz20y8fY9D(dpI5(4OkD98doZAseUaUIR7bWt2Rder(gBOZTZG2OWheDvwF3nZ2C3zcLR3M(kH((Dh5LZHhaAcTv5SApw(ej8S6(eP5X0TZVpZSB5GMhJVqUVZpSC2ZnvPRNFWz2TC2adYbc6C5aVXg6iiii4KeeyyU7mbbqYzFDOVF3rE5C4t6AFlmYVo(kKH1xD(8fW0I0SgCCD6RdUg8cGRbQ4kuiOon)uUPt0k)bx7lN)t0VP2hqdxRTBNP)S2DKgEU7Sd0Dxyo(oJqX46cCgvLZpTKrm1V2ECIP(1dSDet95UZiMDpx33jekoxNlp3prAzFcX0mxN(ftKrl1V(JTIuQpZDgL88WYzIm99evIZV5YdMtKqAtkhE6k1VSLmYPYZpkAkWA0ze2Zd7NfjEFps0gwNIQ15PP5pskP7ieCJybFmUa97iddxrzhj93Eku2037VFFvZ4YYj53AFM0OxTcp4vrvr3hvg)hp8Xdl(r0pN9eo1y)cjRy4PF8y5zgN2R5FkApUEFX3KWT)mUmNZxNKY6I(Ldzf5WBN9Emwj8n5)WhnnisDAi914384Q)Q5)UK1ZimiIFf(F(z8BuxCl1p4wPV((MNt(9xI(LV38Oe)24Jx(6noLp3(9iqL2NyFZtzdJ37W3TLghA5re9DKp5XZ4EGyUWaE(zPrOMuFLhdKjELrzkd6TahcGWbOIBGV8glmbLh7ehaRcaFWbaPa1yY)evxa(qS0(EG3qMg)wJFL6Ve6lu)GlrVsFZFt6Vu77r)DZUz0Glb)k07fOR)nwVg2RL2lFTgR)KPFjhX4pN(Hs)sEm3ujk43I8oQ1Ak6TeKzjuSAxAC41uk4Vp6TdXzF10LrCZFS4pwmVg)QRqwel5K3g0CebOeoh4afp8X)WFOrPujc9ighMUVS6D1TrYzxpAeJsGgaTnTILA3bgG01f0acBpSWyhKvefXVeThYk(Rk9m23vpPZgHPfxi3Er7P1Arv)LVemBK6V1yJKq)bfyi3kmK32CFPeGvXEaRmGwtCm1fy79vgsO0px)QMGt6hQSJm6nEvMrwMAVQItKudw173YC3wvMIPnrS(TQ4mHdqAc(DPI3mBDW7e6GBZgd)6gSor(vjIro1Gr)cueoSQWXiUIBrBmtojmNEKA(UpZ8VHVuwYyKHIyXph5Sm7DN4Bhu)aJuFdjSR7Zx3B4lLfQVHuB3oQ)lyg7GpNBY9Go4GUT04bdCQoa9Ibyboam52RPoyPduWZLuZZ8ONQwji7cZsYCoXopJEH5dPItmpBnDLHO1Qg(ojLts0owoh6AA33hjorK2XcF(zG099EAsePBYr79mq8(NSy(R6LoUXq854W4Fd5QqgAQWKiQIGD5pI8EijB9E8nP7mqPnQwlyKFuRXbDOR8IEkk3MJOKcAR97Dyd7xwr1dIhdpakZgZwbJ92qFxIM2zO9L60wPOCByYDymrSPiEQiMqtASvl7PTQ1rqZ6ck3Ek)ijIoE1uU4HZdHCyz5cCCgtcb9rmwUNFUHlwVHuOm1W0uC)2sc)WDWRBhFLgWXdFPaSz(s)J2dQ7srktc)4groaq7w45NVW60pONENKrDLQBxuVt6wgtrWABR17GwiPd96tfoz(UnpZ8Zyx5DgpouVYcl6XY8F3SpmW5qUQxF9EH1DtgjiacGFYw6gqtWZpB553(tAtpFqQprjY241gyRUxteKvE(DkhZKY(NW4MDTgyPEzZ5ACGOOJhnO2FBfnnWs7rBs2iMKjdQXsX2HHgWTbxsc6J2Hy52cGWXqW(HuDglH6Nu3DncjjdXqpJqz1jyijKuMouvdiW9jQE22cg5Xj6Jb79w(Oqa3yENc08lMDnfvuB0tiKG872AWt2ic3o7gpq52nbsTxN2)6k7iM23DiQ6cZm6ikb)8dqZxcDUKFcuFhuxAxttTqqjTM0c0rpibot75NOiTfwH3PXGJk1oMupXNi3TKSUVP(qwpeXY5qZTbjMbdaQTH61GkaaVxNiSIA9vJ69EPUCK2EgVJByDQiZKy3msBpOPTf1jMTiojgO5nH7xRteXO3aDHObqQ)UvHLdG182RpIdb3nBIxs)0ui0RbpT3(GQDAds6jWdz2q1gTEMtWmLBXy)bcwNMfscm7p4jth4WrTRf8ckD2XPiWZjYhNVa68SzNKm3N6LwdI3kEcpnJ1a)tFhwf9HE6wdoWtlLAwwnvVEDsh6G(eJRbxtGtrB9TljIjPstg2aiTcNQSlZOKbxhSB8(0wdGhRVfmMpf3QS7qNXPGZzDKtq35iDTNq2SILpToB7(dmLFkxB8E622hgCMHvJWLLajyh6OYqKdZGC1IEAcPMAgEpv30C4igdGpzLp9b1(0iP12(6adIO7ea9dNkGAeQoh(Bo2hoj36MCbFnvKNFH0K2PLi1G(VsJw7HfBIlYpu3)9q)DrSYAwhw336rOFfdxzystWkV(D8)zpBbMzMyqUy(mi(u6g6M8QWn0AADaeSkfrzObjlN21zlbcrRn6vTumNn(QF8QMsXCFwXEKf7YjSaATBvydhpXEydN9tdQDiGu28iDqYhVcGGI2RpGegpRH40qy(yW5KM9Ejrk9SI7xzf1M2G5GX5BYLQfUN6wHz7C7XlWm8YIKGhL(epqdNl3oHmm6wvdJ4amqmHnVV(chBybGaWVpHrO8j6HW91yjHLeY031qqCOetbkNH94T(F)8ZsjBKIoOZgdgmWwedDMocgedi0Gr5QPKOtbGKmjFnufs2cXyoSQ5gyXT1sRztIsW6BO84ZIyzZc1CPtL0TXkXE7IvtNiLkcseuSaXLfhJh5kQ9tRTQ2ymoCAyKDMCNIybSgIjiTwK2LtpJ0JtFnbyevt4dLSQrtfkPxTar3ZWz3E8HfIlfbMbgGhVSysMG6aX4eb503zqSznpo6OKV84Tise(eKzrC(ydrCRXHwBZLxBtD3U0zNI5jHbAyNP0cyx(Kvjfx1ZQCI7ClMOLIMo5fekmZFxO4ZJWA3bzKRTcvp)STNHdG))v3vwpnosq4Fl8s0GyeseI0csK848hyFNvzMXiSwuwKtyZl8JFDCF4(4RQQpSjzfVGWM(O6QRJV6WmSaN7dvFxs4L1JbMploKWWvbp5evlvPOnY4naHgHiqgvanIqCpwC1mPnbgOHROyzM9LHmKlwcLlJLMhD)X2U3ArPL1xweecxLowoY(INFNMlhM(6GLrRbTeWzQe(fZooxJqSURWMiqSGuYUEaXoI9Bkh3yvqyhQk2OCIvuAdfWuyusqOrr8ke17kmeKegXrH9lC1lRvwnlhFvle6KekXPG(8jZDc6qBI5653izAyTWWvSfw55uiuBc1iCUuIiyfexeNiseWKKGL2vJlPtXPX)EipXz6OVycyo0Pez(MeNNkv6tQPYuTILkDE8CZx5ZWpuLlIyPHOkRKBYV6qadbH9Z2NpgTsWdDsSG2XCES0e((6kttqWc8Gotn4peLcAsPLFHE)S942)Uzx02zPB28BxXwgVHMq0azTAbgrMaOBfrvgiPH3y)79MUCOPZnRpT1(Oxv59067w(5NDBB7FZ)Da38FhyvpIEK)1EPlbiW53SEvsNfg3g)49MoD(7KaRTmT0wKIX9OQnXpZ2gNqemG8RVnplBZ9v)8zINTQ)acrO9mBUOyfKy8RPtBAVE0cke66K3Y)zoeQGNGYEz7go05DYssl(sBA3rMZatpSWckl3kdlTGUnWJrzvWOsnGHTtOwLb21F(rNx4rvCRE86QHUR)xhCVtbeVINyIjwXsQQy8NBXrvS0qtWLsyChhjHsVJGt8jjore5T8ibHUYjd9(uhCg7CpfEnmUrQ3jOykmAEQlWhWXbOkOR5LUM9VEAywCruyr5WX4fSgEj0X5TIElj8XjpjHc8(1ZuGql8PpytfrzpgAZYY5ZzzK8MS0JNL)V0IcgdjNpnZetAokFh8w8SPFfVbidLPKGvPQ56pBp15retqC78O6ujRzBJjWS9(HVp(RZy2ERwc3uwiVKc9uV6t(to0cHk6V1LnW2NJRzy4cjNmepNglHDg8bB6qDynDQMw8V3cMXmdR2c(ofU)Ug9gpTuGxtmqVHOR0UBJA8IoPnlKyezA35Lm321rU1xgjV1vS8Mxgh9ifGwnG)tVf6VO(anasCaHlXsGj(yVEpTIXE(l1cB7B9cqU9bW60bGt1WQ)dUUtz(too4vaCL3lOz8r0bxMQgFKP5qOwBGo0ZDxAhF8ht8)3taneneXHL2rbNTXYMnYwNOgHYbSQZwAB9rE5CN9E(O5IyTmlmFCacE8qlSdrKjJmUFgIm8NOtMH7SfNukfKGDYro0e4k(WFB498ArmPTt0KQp211C6xAJ9G5ajmguqwiXPeYOK2kDFZHEo1DFS)2dhpU8Vw9(Va)FePHjICkTkJ85i0XBE3Yj0JbMvKJALElnPOgoACLVz3QZfiSfsggIi1UqibmGW0njhTw2y7Gm)a)Eb9uzpwrI7h(87y5aKjh2EF)lTV9wtNzGHoTqK6MbZXGFjRtKQBIbCQneI71Cl4MJCWGcSx8IODj4VkHDmH0sUe)bktJ0PggFRBlEykXXW5RNf4V2qyu5)gzhSvQbkv7DihGCfNsnom6ryYbizvyWBWKBMVE1vOmblhizYnX01ZQohx4rWXnrycrYzP67)I6xNDKCmlLBiZdMO3lQ6995ub1oHX9)v6R5MTFxZpp9f6ZWcFV2ark3w5w8ZdkqCZyw2j6UsdHjIfNOLcDsG)WnnYd3fwqvirEZvSA0dneboQW8cnZ1ySzywp1QleUZYrpg7P5A8PG(XxJ7S3S9Bv2bmULPcU0hg9u)pVgKv1IriEC91js0xWjeqx8GI9fJODYxmczS0qEms5(AhnuPewzwHTH9RDHom6H0hwSsDtYY6XD7zYZ8qjV2qCDvDh12glGTge222DlY3oNvqrTiaI7QkiOzVh71vRIz)KWDr(gjhXooBmpB708BCgRQHUrHxveCRSwfewBlgmMbynUzDeUAqbCPTPszvMhXobNcg))59lOo5jmdNFw0WMSmslfoJ4OHWX9TYhkhxHm8q6Wz8ldOZ5bXtDobLhIqU)tH3KORUwEa0PXpxA6tYBicaNKE96r(jyaNiREVOHWHJ9yyMtW9laMitTkZr(NCmkuA0YdwkVcfKG8Ld6sjmEjO3j6K75d9)88)9d]] )