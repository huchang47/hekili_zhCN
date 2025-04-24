-- PriestDiscipline.lua
-- January 2025

if UnitClassBase( "player" ) ~= "PRIEST" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 256 )

spec:RegisterResource( Enum.PowerType.Mana )

-- Talents
spec:RegisterTalents( {
    -- Priest
    angelic_bulwark            = {  82675, 108945, 1 }, -- When an attack brings you below 30% health, you gain an absorption shield equal to 15% of your maximum health for 20 sec. Cannot occur more than once every 90 sec.
    angelic_feather            = {  82703, 121536, 1 }, -- Places a feather at the target location, granting the first ally to walk through it 40% increased movement speed for 5 sec. Only 3 feathers can be placed at one time.
    angels_mercy               = {  82678, 238100, 1 }, -- Reduces the cooldown of Desperate Prayer by 20 sec.
    apathy                     = {  82689, 390668, 1 }, -- Your Mind Blast critical strikes reduce your target's movement speed by 75% for 4 sec.
    benevolence                = {  82676, 415416, 1 }, -- Increases the healing of your spells by 3%.
    binding_heals              = {  82678, 368275, 1 }, -- 20% of Flash Heal healing on other targets also heals you.
    blessed_recovery           = {  82720, 390767, 1 }, -- After being struck by a melee or ranged critical hit, heal 20% of the damage taken over 6 sec.
    body_and_soul              = {  82706,  64129, 1 }, -- Power Word: Shield and Leap of Faith increase your target's movement speed by 40% for 3 sec.
    cauterizing_shadows        = {  82687, 459990, 1 }, -- When your Shadow Word: Pain expires or is refreshed with less than 5 sec remaining, a nearby ally within 40 yards is healed for 183,145.
    crystalline_reflection     = {  82681, 373457, 2 }, -- Power Word: Shield instantly heals the target for 31,116 and reflects 10% of damage absorbed.
    death_and_madness          = {  82711, 321291, 1 }, -- If your Shadow Word: Death fails to kill a target at or below 20% health, its cooldown is reset. Cannot occur more than once every 10 sec.
    dispel_magic               = {  82715,    528, 1 }, -- Dispels Magic on the enemy target, removing 1 beneficial Magic effect.
    divine_star                = {  82682, 110744, 1 }, -- Throw a Divine Star forward 27 yds, healing allies in its path for 53,417 and dealing 49,786 Holy damage to enemies. After reaching its destination, the Divine Star returns to you, healing allies and damaging enemies in its path again. Healing reduced beyond 6 targets.
    dominate_mind              = {  82710, 205364, 1 }, -- Controls a mind up to 1 level above yours for 30 sec while still controlling your own mind. Does not work versus Demonic, Mechanical, or Undead beings or players. This spell shares diminishing returns with other disorienting effects.
    essence_devourer           = {  82674, 415479, 1 }, -- Attacks from your Shadowfiend siphon life from enemies, healing a nearby injured ally for 137,359. Attacks from your Mindbender siphon life from enemies, healing a nearby injured ally for 45,786.
    focused_mending            = {  82719, 372354, 1 }, -- Prayer of Mending does 45% increased healing to the initial target.
    from_darkness_comes_light  = {  82707, 390615, 1 }, -- Each time Shadow Word: Pain or Purge the Wicked deals damage, the healing of your next Flash Heal is increased by 3%, up to a maximum of 60%.
    halo                       = {  82682, 120517, 1 }, -- Creates a ring of Holy energy around you that quickly expands to a 30 yd radius, healing allies for 122,860 and dealing 128,201 Holy damage to enemies. Healing reduced beyond 6 targets.
    holy_nova                  = {  82701, 132157, 1 }, -- An explosion of holy light around you deals up to 126,695 Holy damage to enemies and up to 120,189 healing to allies within 12 yds, reduced if there are more than 5 targets.
    improved_fade              = {  82686, 390670, 2 }, -- Reduces the cooldown of Fade by 5 sec.
    improved_flash_heal        = {  82714, 393870, 1 }, -- Increases healing done by Flash Heal by 15%.
    improved_purify            = {  82705, 390632, 1 }, -- Purify additionally removes all Disease effects.
    inspiration                = {  82696, 390676, 1 }, -- Reduces your target's physical damage taken by 5% for 15 sec after a critical heal with Flash Heal or Penance.
    leap_of_faith              = {  82716,  73325, 1 }, -- Pulls the spirit of a party or raid member, instantly moving them directly in front of you.
    lights_inspiration         = {  82679, 373450, 2 }, -- Increases the maximum health gained from Desperate Prayer by 8%.
    manipulation               = {  82672, 459985, 1 }, -- You take 2% less damage from enemies affected by your Shadow Word: Pain.
    mass_dispel                = {  82699,  32375, 1 }, -- Dispels magic in a 15 yard radius, removing all harmful Magic from 5 friendly targets and 1 beneficial Magic effect from 5 enemy targets. Potent enough to remove Magic that is normally undispellable.
    mental_agility             = {  82698, 341167, 1 }, -- Reduces the mana cost of Purify and Mass Dispel by 50% and Dispel Magic by 10%.
    mind_control               = {  82710,    605, 1 }, -- Controls a mind up to 1 level above yours for 30 sec. Does not work versus Demonic, Undead, or Mechanical beings. Shares diminishing returns with other disorienting effects.
    move_with_grace            = {  82702, 390620, 1 }, -- Reduces the cooldown of Leap of Faith by 30 sec.
    petrifying_scream          = {  82695,  55676, 1 }, -- Psychic Scream causes enemies to tremble in place instead of fleeing in fear.
    phantasm                   = {  82556, 108942, 1 }, -- Activating Fade removes all snare effects.
    phantom_reach              = {  82673, 459559, 1 }, -- Increases the range of most spells by 15%.
    power_infusion             = {  82694,  10060, 1 }, -- Infuses the target with power for 15 sec, increasing haste by 20%. Can only be cast on players.
    power_word_life            = {  82676, 373481, 1 }, -- A word of holy power that heals the target for 789,815. Only usable if the target is below 35% health.
    prayer_of_mending          = {  82718,  33076, 1 }, -- Places a ward on an ally that heals them for 46,549 the next time they take damage, and then jumps to another ally within 30 yds. Jumps up to 4 times and lasts 30 sec after each jump.
    protective_light           = {  82707, 193063, 1 }, -- Casting Flash Heal on yourself reduces all damage you take by 10% for 10 sec.
    psychic_voice              = {  82695, 196704, 1 }, -- Reduces the cooldown of Psychic Scream by 15 sec.
    renew                      = {  82717,    139, 1 }, -- Fill the target with faith in the light, healing for 208,473 over 15 sec.
    rhapsody                   = {  82700, 390622, 1 }, -- Every 1 sec, the damage of your next Holy Nova is increased by 12% and its healing is increased by 20%. Stacks up to 20 times.
    sanguine_teachings         = {  82691, 373218, 1 }, -- Increases your Leech by 4%.
    sanlayn                    = {  82690, 199855, 1 }, --  Sanguine Teachings Sanguine Teachings grants an additional 2% Leech.  Vampiric Embrace Reduces the cooldown of Vampiric Embrace by 30 sec, increases its healing done by 25%.
    shackle_undead             = {  82693,   9484, 1 }, -- Shackles the target undead enemy for 50 sec, preventing all actions and movement. Damage will cancel the effect. Limit 1.
    shadow_word_death          = {  82712,  32379, 1 }, -- A word of dark binding that inflicts 75,569 Shadow damage to your target. If your target is not killed by Shadow Word: Death, you take backlash damage equal to 5% of your maximum health. Damage increased by 150% to targets below 20% health.
    shadowfiend                = {  82713,  34433, 1 }, -- Summons a shadowy fiend to attack the target for 15 sec. Generates 0.5% Mana each time the Shadowfiend attacks.
    sheer_terror               = {  82708, 390919, 1 }, -- Increases the amount of damage required to break your Psychic Scream by 75%.
    spell_warding              = {  82720, 390667, 1 }, -- Reduces all magic damage taken by 3%.
    surge_of_light             = {  82677, 109186, 1 }, -- Your healing spells and Smite have a 8% chance to make your next Flash Heal instant and cost no mana. Stacks to 2.
    throes_of_pain             = {  82709, 377422, 2 }, -- Shadow Word: Pain and Purge the Wicked deal an additional 3% damage. When an enemy dies while afflicted by your Shadow Word: Pain or Purge the Wicked, you gain 0.5% Mana.
    tithe_evasion              = {  82688, 373223, 1 }, -- Shadow Word: Death deals 50% less damage to you.
    translucent_image          = {  82685, 373446, 1 }, -- Fade reduces damage you take by 10%.
    twins_of_the_sun_priestess = {  82683, 373466, 1 }, -- Power Infusion also grants you its effect at 100% value when used on an ally. If no ally is targeted, it will grant its effect at 100% value to a nearby ally, preferring damage dealers.
    twist_of_fate              = {  82684, 390972, 2 }, -- After damaging or healing a target below 35% health, gain 5% increased damage and healing for 8 sec.
    unwavering_will            = {  82697, 373456, 2 }, -- While above 75% health, the cast time of your Flash Heal and Smite are reduced by 5%.
    vampiric_embrace           = {  82691,  15286, 1 }, -- Fills you with the embrace of Shadow energy for 12 sec, causing you to heal a nearby ally for 50% of any single-target Shadow spell damage you deal.
    void_shield                = {  82692, 280749, 1 }, -- When cast on yourself, 30% of damage you deal refills your Power Word: Shield.
    void_shift                 = {  82674, 108968, 1 }, -- Swap health percentages with your ally. Increases the lower health percentage of the two to 25% if below that amount.
    void_tendrils              = {  82708, 108920, 1 }, -- Summons shadowy tendrils, rooting all enemies within 8 yards for 15 sec or until the tendril is killed.
    words_of_the_pious         = {  82721, 377438, 1 }, -- For 12 sec after casting Power Word: Shield, you deal 10% additional damage and healing with Smite and Holy Nova.

    -- Discipline
    abyssal_reverie            = {  82583, 373054, 2 }, -- Atonement heals for 10% more when activated by Shadow spells.
    atonement                  = {  82594,  81749, 1 }, -- Power Word: Shield, Flash Heal, Renew, Power Word: Radiance, and Power Word: Life apply Atonement to your target for 15 sec. Your spell damage heals all targets affected by Atonement for 35% of the damage done. Healing increased by 100% when not in a raid.
    blaze_of_light             = {  82568, 215768, 2 }, -- The damage of Smite and Penance is increased by 8%, and Penance increases or decreases your target's movement speed by 25% for 2 sec.
    borrowed_time              = {  82600, 390691, 2 }, -- Casting Power Word: Shield increases your Haste by 4% for 4 sec.
    bright_pupil               = {  82591, 390684, 1 }, -- Reduces the cooldown of Power Word: Radiance by 3 sec.
    castigation                = {  82575, 193134, 1 }, -- Penance fires one additional bolt of holy light over its duration.
    dark_indulgence            = {  82596, 372972, 1 }, -- Mind Blast has a 100% chance to grant Power of the Dark Side and its mana cost is reduced by 40%.
    divine_aegis               = {  82602,  47515, 1 }, -- Direct critical heals create a protective shield on the target, absorbing 30% of the amount healed. Lasts 15 sec.
    divine_procession          = {  82599, 472361, 1 }, -- Smite extends the duration of an active Atonement by 3.0 sec.
    encroaching_shadows        = {  82590, 472568, 1 }, -- Shadow Word: Pain Spreads to 2 nearby enemies when you cast Penance on the target.
    enduring_luminescence      = {  82591, 390685, 1 }, -- Reduces the cast time of Power Word: Radiance by 30% and causes it to apply Atonement at an additional 10% of its normal duration.
    eternal_barrier            = {  86730, 238135, 1 }, -- Power Word: Shield absorbs 20% additional damage and lasts 5 sec longer.
    evangelism                 = {  82598, 472433, 1 }, -- Extends Atonement on all allies by 6 sec and heals for 3.2 million, split evenly among them.
    expiation                  = {  82585, 390832, 2 }, -- Increases the damage of Mind Blast and Shadow Word: Death by 10%. Mind Blast and Shadow Word: Death consume 3 sec of Shadow Word: Pain, instantly dealing that damage.
    harsh_discipline           = {  82572, 373180, 2 }, -- Power Word: Radiance causes your next Penance to fire 3 additional bolts, stacking up to 2 times.
    indemnity                  = {  82576, 373049, 1 }, -- Atonements granted by Power Word: Shield last an additional 4 sec.
    inescapable_torment        = {  82586, 373427, 1 }, -- Penance, Mind Blast and Shadow Word: Death cause your Mindbender or Shadowfiend to teleport behind your target, slashing up to 5 nearby enemies for 104,966 Shadow damage and extending its duration by 0.7 sec.
    inner_focus                = {  82601, 390693, 1 }, -- Flash Heal, Power Word: Shield, Penance, Power Word: Radiance, and Power Word: Life have a 20% increased chance to critically heal.
    lenience                   = {  82567, 238063, 1 }, -- Atonement reduces damage taken by 3%.
    lights_promise             = {  82592, 322115, 1 }, -- Power Word: Radiance gains an additional charge.
    luminous_barrier           = {  82564, 271466, 1 }, -- Create a shield on all allies within 40 yards, absorbing 877,572 damage on each of them for 10 sec. Absorption decreased beyond 5 targets.
    malicious_intent           = {  82580, 372969, 1 }, -- Increases the duration of Schism by 6 sec.
    mindbender                 = {  82584, 123040, 1 }, -- Summons a Mindbender to attack the target for 12 sec. Generates 0.2% Mana each time the Mindbender attacks.
    overloaded_with_light      = {  82573, 421557, 1 }, -- Ultimate Penitence emits an explosion of light, healing up to 10 allies around you for 137,359 and applying Atonement at 50% of normal duration.
    pain_and_suffering         = {  82578, 390689, 2 }, -- Increases the damage of Shadow Word: Pain by 8%.
    pain_suppression           = {  82587,  33206, 1 }, -- Reduces all damage taken by a friendly target by 40% for 8 sec. Castable while stunned.
    pain_transformation        = {  82588, 372991, 1 }, -- Pain Suppression also heals your target for 15% of their maximum health and applies Atonement.
    painful_punishment         = {  82597, 390686, 1 }, -- Each Penance bolt extends the duration of Shadow Word: Pain on enemies hit by 1.5 sec.
    power_of_the_dark_side     = {  82595, 198068, 1 }, -- Shadow Word: Pain and Purge the Wicked have a chance to empower your next Penance with Shadow, increasing its effectiveness by 50%.
    power_word_barrier         = {  82564,  62618, 1 }, -- Summons a holy barrier to protect all allies at the target location for 10 sec, reducing all damage taken by 20% and preventing damage from delaying spellcasting.
    power_word_radiance        = {  82593, 194509, 1 }, -- A burst of light heals the target and 4 injured allies within 40 yards for 412,443, and applies Atonement for 60% of its normal duration.
    protector_of_the_frail     = {  82588, 373035, 1 }, -- Pain Suppression gains an additional charge. Power Word: Shield reduces the cooldown of Pain Suppression by 3 sec.
    revel_in_darkness          = {  82566, 373003, 1 }, -- Shadow Word: Pain deals 5% additional damage and spreads to 1 additional target when casting Penance.
    sanctuary                  = {  92225, 231682, 1 }, -- Smite prevents the next 74,087 damage dealt by the enemy.
    schism                     = {  82579, 424509, 1 }, -- Mind Blast fractures the enemy's mind, increasing your spell damage to the target by 10% for 9 sec.
    shadow_covenant            = {  82581, 314867, 1 }, -- Casting Mindbender enters you into a shadowy pact, transforming Halo, Divine Star, and Penance into Shadow spells and increasing the damage and healing of your Shadow spells by 20% while active.
    shield_discipline          = {  82589, 197045, 1 }, -- When your Power Word: Shield is completely absorbed, you restore 0.5% of your maximum mana.
    twilight_corruption        = {  82582, 373065, 1 }, -- Shadow Covenant increases Shadow spell damage and healing by an additional 10%.
    twilight_equilibrium       = {  82571, 390705, 1 }, -- Your damaging Shadow spells increase the damage of your next Holy spell cast within 6 sec by 15%. Your damaging Holy spells increase the damage of your next Shadow spell cast within 6 sec by 15%.
    ultimate_penitence         = {  82577, 421453, 1 }, -- Ascend into the air and unleash a massive barrage of Penance bolts, causing 2.4 million Holy damage to enemies or 6 million healing to allies over 5.1 sec. While ascended, gain a shield for 100% of your health. In addition, you are unaffected by knockbacks or crowd control effects.
    void_summoner              = {  82570, 390770, 1 }, -- Mind Blast and Penance casts reduce the cooldown of Mindbender by 4.0 sec.
    weal_and_woe               = {  82569, 390786, 1 }, -- Your Penance bolts increase the damage of your next Smite by 20%, or the absorb of your next Power Word: Shield by 10%. Stacks up to 8 times.

    -- Oracle
    assured_safety             = {  94691, 440766, 1 }, -- Power Word: Shield casts apply 4 stacks of Prayer of Mending to your target.
    clairvoyance               = {  94687, 428940, 1 }, -- Casting Premonition of Solace invokes Clairvoyance, expanding your mind and opening up all possibilities of the future.  Premonition of Clairvoyance Grants Premonition of Insight, Piety, and Solace at 100% effectiveness.
    desperate_measures         = {  94690, 458718, 1 }, -- Desperate Prayer lasts an additional 10 sec. Angelic Bulwark's absorption effect is increased by 15% of your maximum health.
    divine_feathers            = {  94675, 440670, 1 }, -- Your Angelic Feathers increase movement speed by an additional 10%. When an ally walks through your Angelic Feather, you are also granted 100% of its effect.
    fatebender                 = {  94700, 440743, 1 }, -- Increases the effects of Premonition by 40%.
    foreseen_circumstances     = {  94689, 440738, 1 }, -- Pain Suppression reduces damage taken by an additional 10%.
    miraculous_recovery        = {  94679, 440674, 1 }, -- Reduces the cooldown of Power Word: Life by 3 sec and allows it to be usable on targets below 50% health.
    perfect_vision             = {  94700, 440661, 1 }, -- Reduces the cooldown of Premonition by 15 sec.
    preemptive_care            = {  94674, 440671, 1 }, -- Increases the duration of Atonement and Renew by 4 sec.
    premonition                = {  94683, 428924, 1, "oracle" }, -- Gain access to a spell that gives you an advantage against your fate. Premonition rotates to the next spell when cast.  Premonition of Insight Reduces the cooldown of your next 3 spell casts by 7 sec.  Premonition of Piety Increases your healing done by 15% and causes 70% of overhealing on players to be redistributed to up to 4 nearby allies for 15 sec.  Premonition of Solace Your next single target healing spell grants your target a shield that absorbs 301,473 damage and reduces their damage taken by 15% for 15 sec.
    preventive_measures        = {  94698, 440662, 1 }, -- Power Word: Shield absorbs 40% additional damage. All damage dealt by Penance, Smite and Holy Nova increased by 40%.
    prophets_will              = {  94690, 433905, 1 }, -- Your Flash Heal and Power Word: Shield are 30% more effective when cast on yourself.
    save_the_day               = {  94675, 440669, 1 }, -- For 6 sec after casting Leap of Faith you may cast it a second time for free, ignoring its cooldown.
    twinsight                  = {  94673, 440742, 1 }, -- 3 additional Penance bolts are fired at an enemy within 40 yards when healing an ally with Penance, or fired at an ally within 40 yards when damaging an enemy with Penance.
    waste_no_time              = {  94679, 440681, 1 }, -- Premonition causes your next Power Word: Radiance cast to be instant and cost 15% less mana.

    -- Voidweaver
    collapsing_void            = {  94694, 448403, 1 }, -- Each time Penance damages or heals, Entropic Rift is empowered, increasing its damage and size by 10%. After Entropic Rift ends it collapses, dealing 242,533 Shadow damage split amongst enemy targets within 15 yds.
    dark_energy                = {  94693, 451018, 1 }, -- While Entropic Rift is active, you move 20% faster.
    darkening_horizon          = {  94668, 449912, 1 }, -- Void Blast increases the duration of Entropic Rift by 1.0 sec, up to a maximum of 3 sec.
    depth_of_shadows           = { 100212, 451308, 1 }, -- Shadow Word: Death has a high chance to summon a Shadowfiend for 5 sec when damaging targets below 20% health.
    devour_matter              = {  94668, 451840, 1 }, -- Shadow Word: Death consumes absorb shields from your target, dealing 226,708 extra damage to them and granting you 1% mana if a shield was present.
    embrace_the_shadow         = {  94696, 451569, 1 }, -- You absorb 3% of all magic damage taken. Absorbing Shadow damage heals you for 100% of the amount absorbed.
    entropic_rift              = {  94684, 447444, 1, "voidweaver" }, -- Mind Blast tears open an Entropic Rift that follows the enemy for 8 sec. Enemies caught in its path suffer 6,110 Shadow damage every 0.8 sec while within its reach.
    inner_quietus              = {  94670, 448278, 1 }, -- Power Word: Shield absorbs 20% additional damage.
    no_escape                  = {  94693, 451204, 1 }, -- Entropic Rift slows enemies by up to 70%, increased the closer they are to its center.
    void_blast                 = {  94703, 450405, 1 }, -- Entropic Rift upgrades Smite into Void Blast while it is active. Void Blast: Sends a blast of cosmic void energy at the enemy, causing 112,465 Shadow damage.
    void_empowerment           = {  94695, 450138, 1 }, -- Summoning an Entropic Rift extends the duration of your 5 shortest Atonements by 1 sec.
    void_infusion              = {  94669, 450612, 1 }, -- Atonement healing with Void Blast is 100% more effective.
    void_leech                 = {  94696, 451311, 1 }, -- Every 3 sec siphon an amount equal to 4% of your health from an ally within 40 yds if they are higher health than you.
    voidheart                  = {  94692, 449880, 1 }, -- While Entropic Rift is active, your Atonement healing is increased by 20%.
    voidwraith                 = { 100212, 451234, 1 }, -- Transform your Shadowfiend or Mindbender into a Voidwraith. Voidwraith Summon a Voidwraith for 15 sec that casts Void Flay from afar. Void Flay deals bonus damage to high health enemies, up to a maximum of 50% if they are full health. Generates 0.5% Mana each time the Voidwraith attacks.
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    absolute_faith         = 5480, -- (408853) Leap of Faith also pulls the spirit of the 3 furthest allies within 40 yards and shields you and the affected allies for 555,659.
    archangel              =  123, -- (197862) Evangelism healing increased by 30%, and Evangelism increases your healing and absorption effects by 20% for 15 sec.
    catharsis              = 5487, -- (391297) 15% of all damage you take is stored. The stored amount cannot exceed 12% of your maximum health. The initial damage of your next Shadow Word: Pain deals this stored damage to your target.
    dark_archangel         =  126, -- (1218211) Casting Mindbender increases your damage, and the damage of all allies with your Atonement by 10% for 8 sec.
    improved_mass_dispel   = 5635, -- (426438) Reduces the cooldown of Mass Dispel by 60 sec.
    inner_light_and_shadow = 5416, -- (356085) Inner Light: Healing spells cost 10% less mana. Inner Shadow: Spell damage and Atonement healing increased by 10%. Activate to swap from one effect to the other, incurring a 6 sec cooldown.
    mindgames              = 5640, -- (375901) Assault an enemy's mind, dealing 266,715 Shadow damage and briefly reversing their perception of reality. For 7 sec, the next 777,921 damage they deal will heal their target, and the next 777,921 healing they deal will damage their target.
    phase_shift            = 5570, -- (408557) Step into the shadows when you cast Fade, avoiding all attacks and spells for 1 sec. Interrupt effects are not affected by Phase Shift.
    purification           =  100, -- (196439) Purify now has a maximum of 2 charges. Removing harmful effects with Purify grants your target an absorption shield equal to 5% of their maximum health. Lasts 8 sec.
    strength_of_soul       =  111, -- (197535)
    thoughtsteal           =  855, -- (316262) Peer into the mind of the enemy, attempting to steal a known spell. If stolen, the victim cannot cast that spell for 20 sec. Can only be used on Humanoids with mana. If you're unable to find a spell to steal, the cooldown of Thoughtsteal is reset.
    trinity                =  109, -- (214205)
    ultimate_radiance      =  114, -- (236499)
} )

-- Auras
spec:RegisterAuras( {
    apathy = {
        id = 390669,
        duration = 4,
        max_stack = 1
    },
    archangel = {
        id = 197862,
        duration = 15,
        max_stack = 1
    },
    atonement = {
        id = 194384,
        duration = 15,
        max_stack = 1,
        dot = "buff",
        friendly = true
    },
    body_and_soul = {
        id = 65081,
        duration = 3,
        max_stack = 1
    },
    borrowed_time = {
        id = 390692,
        duration = 4,
        max_stack = 1
    },
    dark_archangel = {
        id = 197871,
        duration = 8,
        max_stack = 1
    },
    death_and_madness_debuff = {
        id = 322098,
        duration = 7,
        max_stack = 1
    },
    depth_of_the_shadows = {
        id = 390617,
        duration = 15,
        max_stack = 50
    },
    desperate_prayer = {
        id = 19236,
        duration = 10,
        tick_time = 1,
        max_stack = 1
    },
    dominate_mind = {
        id = 205364,
        duration = 30,
        max_stack = 1
    },
    fade = {
        id = 586,
        duration = 10,
        max_stack = 1
    },
    focused_will = {
        id = 45242,
        duration = 8,
        max_stack = 1
    },
    from_darkness_comes_light = {
        id = 390617,
        duration = 30,
        max_stack = 20
    },
    harsh_discipline = {
        id = 373183,
        duration = 30,
        max_stack = 2,
        copy = "harsh_discipline_ready"
    },
    inspiration = {
        id = 390677,
        duration = 15,
        max_stack = 1
    },
    leap_of_faith = {
        id = 73325,
        duration = 1.5,
        max_stack = 1
    },
    levitate = {
        id = 1706,
        duration = 600,
        max_stack = 1
    },
    -- Absorbs $w1 damage.
    luminous_barrier = {
        id = 271466,
        duration = 10.0,
        max_stack = 1,
        dot = "buff"
    },
    mind_control = {
        id = 605,
        duration = 30,
        max_stack = 1
    },
    mind_soothe = {
        id = 453,
        duration = 20,
        max_stack = 1
    },
    mind_vision = {
        id = 2096,
        duration = 60,
        max_stack = 1
    },
    mindbender = { -- TODO: Check Aura (https://wowhead.com/beta/spell=123040)
        id = 123040,
        duration = 12,
        max_stack = 1
    },
    mindgames = {
        id = 375901,
        duration = function() return talent.shattered_perceptions.enabled and 7 or 5 end,
        max_stack = 1
    },
    pain_suppression = {
        id = 33206,
        duration = 8,
        max_stack = 1,
        dot = "buff",
        shared = "player"
    },
    power_of_the_dark_side = {
        id = 198069,
        duration = 20,
        max_stack = 1
    },
    power_word_barrier = { -- TODO: Check for totem to help correct for remaining time.
        id = 81782,
        duration = 12,
        max_stack = 1
    },
    power_word_fortitude = {
        id = 21562,
        duration = 3600,
        max_stack = 1,
        shared = "player", -- use anyone's buff on the player
        dot = "buff",
        friendly = true
    },
    power_word_shield = {
        id = 17,
        duration = function() return 15 + ( 5 * talent.eternal_barrier.rank ) end,
        tick_time = 1,
        max_stack = 1,
        dot = "buff",
        friendly = true
    },
    prayer_of_mending = {
        id = 41635,
        duration = 30,
        max_stack = 5,
        dot = "buff",
        friendly = true
    },
    premonition_of_insight = {
        id = 428933,
        duration = 20,
        max_stack = 3
    },
    premonition_of_piety = {
        id = 428930,
        duration = 15,
        max_stack = 1
    },
    premonition_of_solace = {
        id = 428934,
        duration = 20,
        max_stack = 1
    },
    premonition_of_solace_absorb = {
        id = 443526,
        duration = 15,
        max_stack = 1,
        dot = "buff",
        friendly = true
    },
    psychic_scream = {
        id = 8122,
        duration = 8,
        max_stack = 1
    },
    --[[purge_the_wicked = {
        id = 204213,
        duration = 20,
        tick_time = function () return 2 * haste end,
        max_stack = 1
    },--]]
    --[[rapture = {
        id = 47536,
        duration = 8,
        max_stack = 3
    },--]]
    renew = {
        id = 139,
        duration = 15,
        tick_time = 3,
        max_stack = 1,
        dot = "buff",
        friendly = true
    },
    schism = {
        id = 214621,
        duration = function() return talent.malicious_intent.enabled and 15 or 9 end,
        max_stack = 1
    },
    shackle_undead = {
        id = 9484,
        duration = 50,
        max_stack = 1
    },
    shadow_covenant = {
        id = 322105,
        duration = 7,
        max_stack = 1
    },
    shadow_word_pain = {
        id = 589,
        duration = 16,
        tick_time = 2,
        max_stack = 1
    },
    shadowfiend = {
        id = 34433,
        duration = 15,
        max_stack = 1
    },
    shield_of_absolution = {
        id = 394624,
        duration = 15,
        max_stack = 1,
        dot = "buff",
        friendly = true
    },
    surge_of_light = {
        id = 114255,
        duration = 20,
        max_stack = 2
    },
    tools_of_the_cloth = {
        id = 390933,
        duration = 12,
        max_stack = 1
    },
    twilight_equilibrium_holy_amp = {
        id = 390706,
        duration = 6,
        max_stack = 1
    },
    twilight_equilibrium_shadow_amp = {
        id = 390707,
        duration = 6,
        max_stack = 1
    },
    twist_of_fate = {
        id = 390978,
        duration = 8,
        max_stack = 1
    },
    ultimate_penitence = {
        id = 421453,
        duration = 6,
        max_stack = 1,
        copy = 421454,
        dot = "buff",
        friendly = true
    },
    vampiric_embrace = {
        id = 15286,
        duration = 15,
        tick_time = 0.5,
        max_stack = 1
    },
    void_tendrils = {
        id = 108920,
        duration = 0.5,
        max_stack = 1
    },
    waste_no_time = {
        id = 440683,
        duration = 20,
        max_stack = 1
    },
    weal_and_woe = {
        id = 390787,
        duration = 20,
        max_stack = 7
    },
    words_of_the_pious = {
        id = 390933,
        duration = 12,
        max_stack = 1
    },
    wrath_unleashed = {
        id = 390782,
        duration = 15,
        max_stack = 1
    },
    light_weaving = {
        id = 394609,
        duration = 15,
        max_stack = 1
    },
} )

-- The War Within
spec:RegisterGear( "tww1", 212084, 212083, 212081, 212086, 212082 )
spec:RegisterAuras( {
    darkness_from_light = {
        id = 455033,
        duration = 30,
        max_stack = 3
    }
} )
spec:RegisterGear( "tww2", 229334, 229332, 229337, 229335, 229333 )

-- Dragonflight
spec:RegisterGear( "tier29", 200327, 200329, 200324, 200326, 200328 )
spec:RegisterGear( "tier30", 202543, 202542, 202541, 202545, 202540 )
spec:RegisterAuras( {
    radiant_providence = {
        id = 410638,
        duration = 3600,
        max_stack = 2
    }
} )
spec:RegisterGear( "tier31", 207279, 207280, 207281, 207282, 207284, 217202, 217204, 217205, 217201, 217203 )


spec:RegisterStateTable( "priest", {
    self_power_infusion = true
} )

local holy_schools = {
    holy = true,
    holyfire = true
}


local entropic_rift_expires = 0
local er_extensions = 0

spec:RegisterHook( "COMBAT_LOG_EVENT_UNFILTERED", function( _, subtype, _, sourceGUID, _, _, _, _, _, _, _, spellID )
    if sourceGUID ~= GUID then return end

    if ( subtype == "SPELL_AURA_APPLIED" or subtype == "SPELL_AURA_REFRESH" ) and spellID == 450193 then
        entropic_rift_expires = GetTime() + 8 -- Assuming it will re-refresh from VT ticks and be caught by SPELL_AURA_REFRESH.
        er_extensions = 0
        return

    elseif state.talent.darkening_horizon.enabled and subtype == "SPELL_CAST_SUCCESS" and er_extensions < 3 and spellID == 450405 and entropic_rift_expires > GetTime() then
        entropic_rift_expires = entropic_rift_expires + 1
        er_extensions = er_extensions + 1
    end

end, false )

spec:RegisterStateExpr( "rift_extensions", function()
    return er_extensions
end )


spec:RegisterHook( "reset_precast", function ()
    if buff.voidheart.up then
        applyBuff( "entropic_rift", buff.voidheart.remains )
    elseif entropic_rift_expires > query_time then
        applyBuff( "entropic_rift", entropic_rift_expires - query_time )
    end

    rift_extensions = nil
end )

spec:RegisterHook( "runHandler", function( action )
    if talent.twilight_equilibrium.enabled then
        local ability = class.abilities[ action ]
        if not ability then return end
        local school = ability.school

        if school and ability.damage then
            if holy_schools[ school ] and ( buff.twilight_equilibrium_holy_amp.up or buff.twilight_equilibrium_shadow_amp.down ) then
                removeBuff( "twilight_equilibrium_holy_amp" )
                applyBuff( "twilight_equilibrium_shadow_amp" )
            elseif school == "shadow" and ( buff.twilight_equilibrium_shadow_amp.up or buff.twilight_equilibrium_holy_amp.down )  then
                removeBuff( "twilight_equilibrium_shadow_amp" )
                applyBuff( "twilight_equilibrium_holy_amp" )
            end
        end
    end
end )

local InescapableTorment = setfenv( function ()
    if buff.mindbender.up then buff.mindbender.expires = buff.mindbender.expires + 0.7
    elseif buff.shadowfiend.up then buff.shadowfiend.expires = buff.shadowfiend.expires + 0.7
    elseif buff.voidwraith.up then buff.voidwraith.expires = buff.voidwraith.expires + 0.7
    end
end, state )

local insight_value = 7

spec:RegisterHook( "runHandler", function( a )
    -- Note: setCooldown will have already run in regular ability flow.
    if buff.premonition_of_insight.up then
        reduceCooldown( a, insight_value )
        removeStack( "premonition_of_insight" )
    end
end )

local Solace = setfenv( function ()
    if buff.premonition_of_solace.down then return end
    applyBuff( "premonition_of_solace_absorb" )
    removeBuff( "premonition_of_solace" )
end, state )


-- Abilities
spec:RegisterAbilities( {
    archangel = {
        id = 197862,
        cast = 0,
        cooldown = 60,
        gcd = "spell",
        school = "holy",

        pvptalent = "archangel",
        startsCombat = false,
        texture = 458225,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "archangel" )
        end,
    },


    dark_archangel = {
        id = 197871,
        cast = 0,
        cooldown = 60,
        gcd = "spell",
        school = "shadow",

        pvptalent = "dark_archangel",
        startsCombat = false,
        texture = 1445237,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "dark_arkangel" )
        end,
    },


    divine_star = {
        id = function() return buff.shadow_covenant.up and 122121 or 110744 end,
        known = 110744,
        flash = { 122121, 110744 },
        cast = 0,
        cooldown = 15,
        gcd = "spell",
        school = function() return buff.shadow_covenant.up and "shadow" or "holy" end,
        damage = 1,

        spend = 0.02,
        spendType = "mana",

        talent = "divine_star",
        startsCombat = true,
        texture = function() return buff.shadow_covenant.up and 631519 or 537026 end,

        handler = function ()
        end,

        copy = { 122121, 110744 }
    },


    evangelism = {
        id = 472433,
        cast = 0,
        cooldown = 90,
        gcd = "spell",
        school = "holy",

        talent = "evangelism",
        startsCombat = false,
        texture = 135895,

        toggle = "cooldowns",

        handler = function ()
            if buff.atonement.up then buff.atonement.expires = buff.atonement.expires + 6 end
        end,
    },


    flash_heal = {
        id = 2061,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",
        school = "holy",

        spend = function() return buff.surge_of_light.up and 0 or 0.04 end,
        spendType = "mana",

        startsCombat = false,
        texture = 135907,

        handler = function ()
            removeBuff( "from_darkness_comes_light" )
            removeStack( "surge_of_light" )
            if talent.protective_light.enabled then applyBuff( "protective_light" ) end
            Solace()
            applyBuff( "atonement" )
        end,
    },


    halo = {
        id = function() return buff.shadow_covenant.up and 120644 or 120517 end,
        known = 120517,
        flash = { 120644, 120517 },
        cast = 1.5,
        cooldown = 40,
        gcd = "spell",
        school = function() return buff.shadow_covenant.up and "shadow" or "holy" end,
        damage = 1,

        spend = 0.03,
        spendType = "mana",

        talent = "halo",
        startsCombat = false,
        texture = function() return buff.shadow_covenant.up and 632353 or 632352 end,

        handler = function ()
        end,

        copy = { 120644, 120517 }
    },

    -- Embrace the light, reducing the mana cost of healing spells by $s1%.
    inner_light_and_shadow = {
        id = 356085,
        cast = 0,
        cooldown = 6,
        gcd = "spell",

        spend = 0.010,
        spendType = "mana",

        pvptalent = "inner_light_and_shadow",
        startsCombat = false,

        handler = function()
            if buff.inner_shadow.up then
                removeBuff( "inner_shadow" )
                applyBuff( "inner_light" )
            else
                removeBuff( "inner_light" )
                applyBuff( "inner_shadow" )
            end
        end,

        copy = { "inner_light", "inner_shadow", 355897, 355898 }

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': IGNORE_SHAPESHIFT, }
        -- #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- #3: { 'type': APPLY_AURA, 'subtype': OVERRIDE_ACTIONBAR_SPELLS_TRIGGERED, 'points': 355898.0, 'value': 355897, 'schools': ['physical', 'nature', 'frost', 'shadow'], 'value1': 2, 'target': TARGET_UNIT_CASTER, }
    },

    --[[ lights_wrath = {
        id = 373178,
        cast = function() return talent.wrath_unleashed.enabled and 1.5 or 2.5 end,
        cooldown = 90,
        gcd = "spell",
        school = "holyfire",
        damage = 1,

        talent = "lights_wrath",
        startsCombat = false,
        texture = 1271590,

        toggle = "cooldowns",

        handler = function ()
        end,
    }, ]]

    -- Talent: Create a shield on all allies within $A1 yards, absorbing $s1 damage on each of them for $d.; Absorption increased by $s2% when not in a raid.
    luminous_barrier = {
        id = 271466,
        cast = 0.0,
        cooldown = 180.0,
        gcd = "spell",

        spend = 0.040,
        spendType = 'mana',

        talent = "luminous_barrier",
        startsCombat = false,

        handler = function()
            applyBuff( "luminous_barrier" )
            active_dot.luminous_barrier = group_members
        end,
    },

    -- Talent: Summons a Mindbender to attack the target for $d.     |cFFFFFFFFGenerates ${$123051m1/100}.1% mana each time the Mindbender attacks.|r
    shadowfiend = {
        id = function() return talent.mindbender.enabled and 123040 or talent.voidwraith.enabled and 451235 or 34433 end,
        known = 34433,
        flash = { 34433, 123040, 200174 },
        cast = 0,
        cooldown = function () return ( talent.mindbender.enabled and 60 or 180 ) * ( talent.void_summoner.enabled and 0.5 or 1 ) end,
        gcd = "spell",
        school = "shadow",

        toggle = function()
            if not talent.mindbender.enabled then return "cooldowns" end
        end,
        startsCombat = true,
        -- texture = function() return talent.mindbender.enabled and 136214 or 136199 end,

        handler = function ()
            local fiend = talent.voidwraith.enabled and "voidwraith" or talent.mindbender.enabled and "mindbender" or "shadowfiend"
            summonPet( fiend, 15 )
            applyBuff( fiend )

            if talent.shadow_covenant.enabled then applyBuff( "shadow_covenant" ) end
        end,

        copy = { "mindbender", 34433, 123040, 200174, "voidwraith", 451235 }
    },

    mind_blast = {
        id = 8092,
        cast = 1.5,
        cooldown = 9,
        gcd = "spell",
        school = "shadow",
        damage = 1,

        spend = function() return talent.dark_indulgence.enabled and 0.0015 or 0.0025 end,
        spendType = "mana",

        startsCombat = true,
        texture = 136224,

        handler = function ()
            if talent.entropic_rift.enabled then
                applyBuff( "entropic_rift" )
                if talent.voidheart.enabled then applyBuff( "voidheart" ) end
            end
            if talent.void_summoner.enabled then
                reduceCooldown( "mindbender", 4 )
            end
            if talent.manipulation.enabled then
                reduceCooldown( "mindgames", 0.5 * talent.manipulation.rank )
            end
            if talent.inescapable_torment.enabled then InescapableTorment() end

            local swp_reduction = 3 * talent.expiation.rank
            if swp_reduction > 0 then debuff.shadow_word_pain.expires = max( 0, debuff.shadow_word_pain.expires - swp_reduction ) end
        end,
    },

    -- Reduces all damage taken by a friendly target by $s1% for $d. Castable while stunned.
    pain_suppression = {
        id = 33206,
        cast = 0.0,
        charges = function() if talent.protector_of_the_frail.enabled then return 2 end end,
        cooldown = 180,
        recharge = function() if talent.protector_of_the_frail.enabled then return 180 end end,
        gcd = "off",

        spend = 0.016,
        spendType = 'mana',

        talent = "pain_suppression",
        startsCombat = false,

        handler = function()
            applyBuff( "pain_suppression" )

            if talent.pain_transformation.enabled then
                gain( 0.15 * health.max, "health" )
                applyBuff( "atonement" )
            end
        end,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'points': -40.0, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- protector_of_the_frail[373035] #2: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },

    penance = {
        id = function() return buff.shadow_covenant.up and 400169 or 47540 end,
        known = 47540,
        flash = { 400169, 47540 },
        cast = 2,
        channeled = true,
        breakable = true,
        cooldown = 9,
        gcd = "spell",
        school = function() return buff.shadow_covenant.up and "shadow" or "holy" end,
        damage = 1,
        bolts = function() return 3 + talent.castigation.rank + ( buff.harsh_discipline.up and ( buff.harsh_discipline.stack * talent.harsh_discipline.rank ) or 0 ) end,

        spend = function()
            if buff.harsh_discipline.up then return 0 end
            return 0.016 * ( buff.inner_light.up and 0.9 or 1 )
        end,
        spendType = "mana",

        startsCombat = true,
        texture = function() return buff.shadow_covenant.up and 1394892 or 237545 end,

        start = function ()
            removeBuff( "power_of_the_dark_side" )
            removeStack( "harsh_discipline" )

            if set_bonus.tier29_4pc > 0 then applyBuff( "shield_of_absolution" ) end
            if talent.inescapable_torment.enabled then InescapableTorment() end
            if talent.manipulation.enabled then reduceCooldown( "mindgames", 0.5 * talent.manipulation.rank ) end

            if debuff.shadow_word_pain.up then
                if talent.painful_punishment.enabled then
                    debuff.shadow_word_pain.expires = debuff.shadow_word_pain.expires + ( 1.5 * spec.abilities.penance.bolts )
                end
                if talent.encroaching_shadows.enabled then
                    active_dot.shadow_word_pain = max( active_enemies, ( active_dot.shadow_word_pain + 2 + talent.revel_in_darkness.rank ) )
                end
            end

            Solace()

            if talent.weal_and_woe.enabled then
                addStack( "weal_and_woe", spec.abilities.penance.bolts )
            end
            if talent.void_summoner.enabled then
                reduceCooldown( "mindbender", 4 )
            end

            setCooldown( buff.shadow_covenant.up and "penance" or "dark_reprimand", action.penance.cooldown )
        end,

        copy = { 47540, 186720, 400169, "dark_reprimand" }

    },

    power_infusion = {
        id = 10060,
        cast = 0,
        cooldown = 120,
        gcd = "off",
        school = "holy",

        toggle = "cooldowns",
        talent = "power_infusion",
        startsCombat = false,
        indicator = function () return group and ( talent.twins_of_the_sun_priestess.enabled or legendary.twins_of_the_sun_priestess.enabled ) and "cycle" or nil end,

        handler = function ()
            applyBuff( "power_infusion" )
            stat.haste = stat.haste + 0.25
        end,
    },

    -- Summons a holy barrier to protect all allies at the target location for $d, reducing all damage taken by $81782s2% and preventing damage from delaying spellcasting.
    power_word_barrier = {
        id = 62618,
        cast = 0,
        cooldown = 180,
        gcd = "spell",
        school = "holy",

        spend = 0.04,
        spendType = "mana",

        talent = "power_word_barrier",
        startsCombat = false,

        handler = function()
            applyBuff( "power_word_barrier" )
        end,

        -- Effects:
        -- #0: { 'type': CREATE_AREATRIGGER, 'subtype': NONE, 'value': 1489, 'schools': ['physical', 'frost', 'arcane'], 'radius': 8.0, 'target': TARGET_UNIT_DEST_AREA_ALLY, }
    },


    power_word_radiance = {
        id = 194509,
        cast = function() return ( buff.radiant_providence.up or buff.waste_no_time.up ) and 0 or ( 2 * ( talent.enduring_luminescence.enabled and 0.7 or 1 ) ) end,
        charges = function() if talent.lights_promise.enabled then return 2 end end,
        cooldown = function() return 18 - ( 3 * talent.bright_pupil.rank ) end,
        recharge = function() if talent.lights_promise.enabled then return 18 - ( 3 * talent.bright_pupil.rank ) end end,
        gcd = "spell",
        school = "radiant",

        spend = function() return ( buff.radiant_providence.up and 0.03 or 0.06 ) * ( buff.waste_no_time.up and 0.85 or 1 ) end,
        spendType = "mana",

        talent = "power_word_radiance",
        startsCombat = false,
        texture = 1386546,

        handler = function ()
            if buff.atonement.down then
                applyBuff( "atonement", ( ( talent.enduring_luminescence.enabled and 0.7 or 0.6 ) * class.auras.atonement.duration ) + ( buff.radiant_providence.up and 3 or 0 ) )
                active_dot.atonement = min( active_dot.atonement + 3, group_members )
            else
                active_dot.atonement = min( active_dot.atonement + 4, group_members )
            end

            if talent.harsh_discipline.enabled then addStack( "harsh_discipline" ) end

            if buff.radiant_providence.up then
                removeStack( "radiant_providence" )
            elseif buff.waste_no_time.up then
                removeStack( "waste_no_time" )
            end
        end,
    },

    power_word_shield = {
        id = 17,
        cast = 0,
        cooldown = 7.5,
        gcd = "spell",

        spend = 0.03,
        spendType = "mana",

        startsCombat = false,
        texture = 135940,

        handler = function ()
            applyBuff( "power_word_shield" )
            applyBuff( "atonement" )
            removeBuff( "weal_and_woe" )

            if talent.borrowed_time.enabled then
                applyBuff( "borrowed_time" )
            end

            if talent.words_of_the_pious.enabled then
                applyBuff( "words_of_the_pious" )
            end

            if talent.body_and_soul.enabled then
                applyBuff( "body_and_soul" )
            end
        end,
    },

    premonition_of_insight = {
        id = 428933,
        cast = 0,
        charges = 2,
        cooldown = function() return talent.perfect_vision.enabled and 45 or 60 end,
        recharge = function() return action.premonition_of_insight.cooldown end,
        gcd = "off",

        talent = "premonition",

        handler = function()
            applyBuff( "premonition_of_insight", nil, 3 )
        end,
    },

    premonition_of_clairvoyance = {
        id = 440725,
        cast = 0,
        cooldown = function() return talent.perfect_vision.enabled and 45 or 60 end,
        recharge = function() return action.premonition_of_insight.cooldown end,
        gcd = "off",

        talent = "premonition",

        handler = function()
            applyBuff( "premonition_of_insight" )
            applyBuff( "premonition_of_piety" )
            applyBuff( "premonition_of_solace" )
        end,
    },

    premonition_of_piety = {
        id = 428930,
        cast = 0,
        cooldown = function() return talent.perfect_vision.enabled and 45 or 60 end,
        recharge = function() return action.premonition_of_insight.cooldown end,
        gcd = "off",

        talent = "premonition",

        handler = function()
            applyBuff( "premonition_of_piety" )
        end,
    },

    premonition_of_solace = {
        id = 428934,
        cast = 0,
        cooldown = function() return talent.perfect_vision.enabled and 45 or 60 end,
        recharge = function() return action.premonition_of_insight.cooldown end,
        gcd = "off",

        talent = "premonition",

        handler = function()
            applyBuff( "premonition_of_solace" )
        end,
    },

    renew = {
        id = 139,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "holy",

        spend = 0.02,
        spendType = "mana",

        talent = "renew",
        startsCombat = false,
        texture = 135953,

        handler = function ()
            applyBuff( "renew" )
            Solace()

            applyBuff( "atonement" )
        end,
    },

    shadow_word_pain = {
        id = 589,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "shadow",
        damage = 1,

        spend = 0,
        spendType = "mana",

        -- notalent = "purge_the_wicked",
        startsCombat = true,
        texture = 136207,
        cycle = "shadow_word_pain",

        handler = function ()
            applyDebuff( "target", "shadow_word_pain" )
        end,
    },

    smite = {
        id = function() return state.spec.discipline and talent.void_blast.enabled and buff.entropic_rift.up and 450215 or 585 end,
        known = 585,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",
        school = "holy",
        damage = 1,

        spend = 0,
        spendType = "mana",

        startsCombat = true,
        texture = function()
            return buff.entropic_rift.up and 4914668 or 135924
        end,

        handler = function ()
            if talent.weal_and_woe.enabled then
                removeBuff( "weal_and_woe" )
            end
            if talent.manipulation.enabled then
                reduceCooldown( "mindgames", 0.5 * talent.manipulation.rank )
            end

            if talent.darkening_horizon.enabled and rift_extensions < 3 then
                buff.entropic_rift.expires = buff.entropic_rift.expires + 1
                if buff.voidheart.up then buff.voidheart.expires = buff.voidheart.expires + 1 end
                rift_extensions = rift_extensions + 1
            end
        end,

        copy = { 585, "void_blast", 450215, 450405, 450983 }
    },

    -- Ascend into the air and unleash a massive barrage of Penance bolts, causing $<penancedamage> Holy damage to enemies or $<penancehealing> healing to allies over $421434d.; While ascended, gain a shield for $s1% of your health. In addition, you are unaffected by knockbacks or crowd control effects.
    ultimate_penitence = {
        id = 421453,
        cast = 1.5,
        cooldown = 240,
        gcd = "spell",

        talent = "ultimate_penitence",
        startsCombat = true,

        handler = function()
            applyBuff( "ultimate_penitence" )
        end,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ANY, }
        -- #1: { 'type': UNKNOWN, 'subtype': NONE, 'points': 2.0, 'value': 852, 'schools': ['fire', 'frost', 'arcane'], 'target': TARGET_UNIT_CASTER, 'target2': TARGET_DEST_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': SCHOOL_ABSORB, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
    },
} )


spec:RegisterSetting( "experimental_msg", nil, {
    type = "description",
    name = "|cFFFF0000警告|r：插件中的治疗仅专注于DPS输出。这在单人游戏或在团队/副本中你的治疗不太关键的空闲时段更有用。使用时需自行承担风险。",
    width = "full",
} )


spec:RegisterRanges( "penance", "smite", "dispel_magic" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    cycle = false,

    nameplates = false,
    nameplateRange = 40,
    rangeFilter = false,

    damage = true,
    damageExpiration = 8,

    potion = "tempered_potion",

    package = "Discipline",

    strict = false
} )

spec:RegisterSetting( "sw_death_protection", 50, {
    name = "|T136149:0|t暗言术：灭生命阈值",
    desc = "如果设置大于0，将不会在你生命值低于此百分比时推荐使用|T136149:0|t暗言术：灭。此选项能有效避免你自杀。",
    type = "range",
    min = 0,
    max = 100,
    step = 0.1,
    width = "full",
} )

spec:RegisterPack( "戒律Simc", 20250423, [[Hekili:TZt7YTnos(SKAQZrkJTITSDYSPCCv3nE3BYuZhPgLRY)KenjLfVirQLKko(kx6z)6UbiiaiajifLtYT3wENytc2O7g93aONE20pmDsGxE40)y8PJV80lgF(OZo9Y)2fNnDs(dBcNozJN)N8Ud(LyV1W)9MOm)OnRIIPx9WQeVaeezjBt9HhTmpFt2BE5lVlkF52Bh5NS(LzrR3UYlpkj2p1Bro(3(VC6KB3gTk)DXtV148F6ftN4TnFzs60jtIw)ZaKJccczdpmZF6KFj0Bvy6U5BsJssJYJcZ2n3lnC38BE)KtwK4Vnlmy38K4vpS7x39RiWp50loz85Vz38)kCDYNHr((p8r(7U4KtF9jNFk8UpSeEXh9aa)rGeIINozvuwEgXMcx4TDvo8R)bX2cJ9UDvyW0)dav9r6B6eFVvRMX(Jz43X(6zmwNFsYQGK7JZMMduRges2amXW8sq9zV0i8T4VTAl8ppB38B3UyXO87JwfD3Y8zH)tGfgDBA021ZwMS6HzER3mA7MDZpA38AhC2spap4dNMjogMholobwzb878wJFooF7M)4J7Mx81JkMsvSG9fSL60OnSz8dCyVB(FVe47MhLXO1O472nN9H7Mh4TgfAbc5IEKqu4Yoqg447arGFMmjCzRjHCq3ioFeNX7ds7XEWFxadjSCvs8DZYGrOHN)wcIjt4SZciWq0cWaO2RAnQvOfWrUfrHXbc(jX61XAvzuFV4zaTfMAcR)RqVaG1LNasc5EP5LceLuWMLEzeB91Tg3pvgr4Oz2MWvRYMfSnLSXnBT3xqG)tgaUxqqnaFS7a)V1AGZEXO1rXbZUDLxgil8Lq)TGmAE06q3N5ZoTntTdW0veuzzEdUuIUBGhbscrEcj(aV0pndGX2v3fcJyKKO6z6gTDMRXr)7tsdMfe6LVSlmVQ4QbWkHTMCq8nj2s(Bky)4lM5bRHR9cIdZY0gu6DH5JwcEUHpFJpOmE1U5JpLOxtoCCIErrM7a6jRFOtjWjTAyYlItyxq0NHyLMHwJ6h8tbGsyOjNeoHHl9wL0pOgdss4KjVdlwLGb1zfRgyXlqXCVB(js(DTJF7MpC38xUB(D(bJ4gAkik4pNz278a0Nc46vEUk8GWMJYxYa))5pFdiydCTDZFl4zmd(viAwiWZff(Xl(U7dryLSDfOmehIQeOBkimvcKKJ)Cm4Z4WVG(Tie5EqyeN7DZz(Jzpn8lqmiRcHOvhC2LeoE2yg2C2Olj8ymHyzCpHG5skuyDmc9VNKMBaSV2iup58rN7eGhGXcnKeb2tNSPHR9IIbMJLfSFozBCoX7kGZXfSXTRVfZpaxia05KfPSz0B1U5cOwG4(Gdhm)Hp7fTIqge1BVlCHyPIewDudopM8MdSOOf6Ho(N38NVPu(Bw4x2e6NJcsSOhV7UhylgC3JVeDgIelKI0AWM8XO0gr0Eu4r5r(4Bd26ZK19YkEtCWjrWdwKKI8U7f0Nsikft)m(0ntakRCOzHRYyRWvSDKNcCMzjlMb58TfIpw2oYytbD0cHiZgj0LK8w5J5PgIYeGk36T(lzcgf63GRV8LmbkDBcOU9spmNs)TPPa9GcvcPPrqYKHCvDZ4ctFkie4jG)hyyrlKbkB(XHCFi9aC1Xl(bD9oCeBstGL1CrAgs5VmIyMTkmOMyHLcgkmZj(lJYG0AEF1a1eX)ZfBeX(pG(PYRz6mzQM9Tl7rM9VYIpebSiBtJBviwoYjAiOefU0VxmiJ8NsqiXHm8worjzoWrYVvrC1oYVPyqvydOUH3Q79EaWmi(qU97frPOQ3Kp(MBmYEQofMytvhLGj4ixQvr(Da5stc9tqVTidHxxR53VmmUi2BCH3dhalkBW0afMnZwbhUG5EV47uuhRNz17Su6NJiaAlBa2mYFlYiMLNmdE9m8vx5gIm0PKsO13wf3C7wFLsM1FjspaM9cyvQnP6(VheWn1FpyRhDWuaj0pecdGNJarErTM5)AioUZic3uW59pH7ePjhBwf6JGdAuWlhdiEff)gBumHBgOvePhyIlZH8m5zJyhKWIBJ)kk2AHmm7NZiNtopNNqFbtvWO4qb5nJ533jhA0pLUrDdtUQatQsnUbGEMci5stzm0tYL2tgxrW8gAyGPwyCg99idhtMiLFFlmosKFRY6ODKVHm9vO7FbEVr6L(qtek9I2sHUMVZn2chomgtrOiTvMiMukD6XjBjAyMC7NjofeH(74trqs8ZZlMPp83lDVECzukl8G8yGV5)ILov2AGJ98Sc3SrjXYHSJ5FfMfILE2JsIil)eiTcmxaFGlKgLmsSqzR4hgdc2wQeGM01cLsc3QP8oy9iGSr7ukBg2IezxRN3(02mU5acI)hlPkPxBJ2W6OiYpWG0()GfGjp1)IkZuSeFlS(8l3GPtfU5KRlwio56mkZMtUgFNw(1en3PSRmGQCgIO6vkO(7QrDOqoafxjhSY14OXueLxMfcAvkBbjGrLT9CJ7J52BRzn(mzkVP678xyEDanMSnfn7OxShcfA)wvAkptZ1xS5enfd14IO8UwvSRfio3(DL0(8qkgJRipLDFGX8i4LU4JqyZVz38BWGJPsbs5vqvskmphRCgeXfqLjq2yPLLyOWsmTv7kPwq7RgvIHZ7um1Ai93lkag3b0NwfGofXKz2TuOCnw(c(yqHhuIbxnaXQ3G)nAvm(54)sFo(kq2jgFG3NX)cLWWvUu)WnmTjmN2NZE9x2eHRGvJP32w0iNTxgh4OkBb0LgyzuY1cSNjEFihBIvGXqBBOfMqbBhToVtrY14YsZ5v97LjfAsHMROxQhtX7iPkR6QVokSv7dDpsHf1crk9q1sH4ejOuJa77B8fDAlVRLk7qEi8I7GbCZn(2YvvoaucVviB72(mwVmFt6neVSvHh58UuQXSRqlYBmzpqeT)SBvtnRmSDovIQqwosoIc45ec1(iGAD0eLkM2m5Wve3nx6pAt4evfyfNuNl6urynJ3FNexXfgp0xpPXvCrNQqyTCDL03CSW3uzcLnV9CZHE2GnFXjn5IUhUuVtw42TQuxF1cDeWcoNmCZRDTjl1D(q3Cr3drPbwHtbqsSaXi1j(O8D6BTHZoVADqDe3W1ctX3i(pSenVH)FyzCvuEowE(Br0olA9g8G)g5FmgjmyfGD(oUnbxoTwH7ewzhe7Bm8RuHVHFzDYAQcsYBnwrnWXdtsw5NJh85rG8e3gucG0RJ(F452wuMdCGBsYYIqZqIfpB1ogpodcS(WxQBvNtgK0K9bw(ARMgnvdl3WFXULCz7RLvNCXscT28WYvtyEyl0zyIFfozt4zt1ENT1PGHmGwf5wT013jEGV8RFPTUStBrFDm9U4PYwLHKTCxXBmSgHNEOKT5zrbHmBDQJOuEurQtK)oEoMejWJ1fphhzdw)RBlLhuxo9kUhAQgc0AZ(ftApT20lrryJP54wOFz3l3x9Cc3kgqdL7WA8f1f)GX4dUC)IhEFPZww0JAe0BUMhx2(JTPHtMKlP2wLZO7CNDcPqKYu0Q9SpyPQE0ufziuQ7vaR6m9DIFXxzmuONu)IVQ7bJyLT3fRVv9mUnEfyDSb)Em1wHUjdcaD6wXlvoKu2Tw9QoD6g7FE03cEOEv3JJQjEHB2UR4JQCBMr5gxSCt0r3J5OFOJU4dQg3mVQ7ro4c90ybi0ZJQPfLkLvGiI94oqkxK9YnGUItsteRSBsP3tyKU37cejDBS6TtUcfQFWtKdBqXd)THXbHP0DZu6koJ(JMHhzccn09x7aAiOBX9sLMAXJ1V9NsZD5nzfNBDhZ(YBLO2HlnikKCVbV5u8gU8cmrd1B82gWL1iLJyJ4uZHPne5)jYjfpnJ0WfPHWNFlwdNYrXyXiOwSD1SnBJJYwUouMlRMMsDJKbvJOP85XY0jDOlNOELFkxj1NBK1)A94duy9kjzzwut5IvZ3MJA2Xvw1mnIsKtbcN0dyWvRu0KshjRnj3dsD0fujCgnA0b)iKZQQDuHnFL0LqRalLQAfIE6(Q3BwghjuwSKo)jVw3Hy5e2LzZun40OqDpx7nfkLx3qN3)Fv0tKzXR19dT3yNIiBnPIv1yuXjDVWE0LK9ih2aX60nlve0DwT3uAL1bhlJITLcDFxTqYSeK4g(sqt3f0EtUsUAv42AUGFDT(F6Yeljr9ul08tKfDXqWtuQmTHk4taN((jRV1RS9Oim7qgojiUijnpkFBq1pVS3OyO7Qyseqkgez9PNz5a0IXPOsJ0Hhvp9EwHiPlQ3Mq8yHwCZCZ4NAoFrBKGD1CZGCUVhSXrdcVzSi)YU189h5l)uCM2BZ4dAEyhz66)4uB7qx4IjjGX0KX0zK59ltW9L69VBx51I((imRWQSE99je5e29Vi59UyQv4OBsYRInzpe7J7qgthHHiV)DujFA5eX4qLrhO(Erqc4onXJjUySLOiWnMbZY6mJyzoiI(jsAvcpZLdgVwDQ6pZ1xXQIepTdd60PEbrS74PcQ9EyEPJPeUAsrSxDLKHMLXTBanvGPApP5NlGIfDJMIPsyDvCi4fQeME1rQD7NcArKjaTjBZy2LZgXoNw4I65v9kzxR9jaZuCGPHGAoXSRt5sfzSgWtVsHn46QPa7oeiIuC2nfTv)n91kdo2qKrFnXSkYGJTkdApaUALb7BIObXm7r79vszqn7RkDTPk4xTHQ)eGRI4)R0LM(kXkBoq7MUQB1lXuP)oD4uaTXPF6CdzvUSPQcCiqHclGv6yspftUM1TkDiPdhoCWfOpSEuy7bPMPykt0CdTQhLWg)V3MXpStSRDjM6q62yAt6S0oxO4OPZAN3TjuBDjjoiImkA0ppRh(uvntjnxEFSXGQG2WusFUkZwB0JLhTS8L24oxECKsG2aUyAtz5dy6NdtPK3W216fN(tG56j37LIBNlqTuZtnA9gQPsrDpONZBAQpV4CqIMRZsW9F3BBEc2RScOtYy8DHzJ29R)gT96N9Q3GX3hdtg9(eWPezYNFuJE(GABryNijprJWq7bB4)gVMSpNLIsFaYxwaYryBL9DeFar)llsTdpMOz5iDIfmjzr0krovzJevq5hF7lnvZeeM8XcJqVtZEmUjiVvugf5HwG6SHKZ6uPhNS5TzH5ht7i1BFMt980JQzyC2cV5O(R)WU5U0Ptlu8y960ArA2qvrBhrNhFu2scs9oJGYTI1ArpCGUICsSulOMdDFv7yJiHAv8XCDEOPZ52MQ9jvDJ5uNzl1o6XhTv3iRZIDLp1z8uGS(HcTU2cgVGaoyyF)i2D(wzJKpoAHGHY61vDeNlNSX7pi44RL9YNwQl2yOd8CjXF02zTEBMR4y06cK(a)gafoQG5OFSvoQsATxbHN1xiS5tfHeIwUBo91uA7UoklHivoG(AARCFbLMpQWiOYW)F7(ShB3N2x6K6gM4Af1by5Rw9quxfbYrROhO(bQDARYPzSIJOw9LLYXcsxI7XcB5RvBa1oPy)WJW5grlowKbvHwOEh)SWni7FP7Sd5hhwu)xGwZzBn8vnEhq9Mhjs7d9PnH9ugnh79yGCd0FiVSbxvxnfgsi977wajAXoPGyLDwuaZgy7G5uACXU47qhiGFVRUmBPhAJnguzwF5Z54NW0GdurJnHZEH6AoGPABgLkcAvEV7YC9yV08jITuhD3l8LHhnWuKNp(OX6fEvZt3qRH4slbo3xl7fgSuwk855fnN)I1V963EMgnS)nWY(MmRianWk5iDJxbk7ixg3vJb5Lbdo7eNG6jNnCOb(TYD)TblTdrl5UmxxDghZCzW7nwrIbkTPL(yzSUuMS0dkLTayO7t6GnXFHskQhWEJzEP3kjLXx5MiPdi6)60wiRB5GVpj1fFTHspwBwxvIlY8I(WRl8AvP1sQf6oTC17Tzr7CLkxYphkdjNO)rfpXvBSKePC4UdETKMk1545(IQyILTkjwE9P8Q8w7fRRLzQMT9wooCw9vfMJ8QRfvJkVAo)1fwUyqvVyNuaE8Kapqn5WgwUkAxtQKSDu(hh)1v8sgF)Mt06hWvakVMdwJgStShPihmNV2Gb61u9O6oSnyeov(GNPFMxgoSAbIV(TJpvKj6(04)2x(G19bWgc341j8PeJoY2(vOhI3bTt8TpuC7k1UzbPQIC7dg1uv43FCGF1iQ1tVPl(qzTruTlxqocfkUCzF3w7AGRwk8(DLNedO93IouCTLYTpuRsaL1VfHM2Wpr5f212Bo)tes3QTVSGAk3EXU2S36bQZ9nb1KHOYDG5)Z0)3Q36Ajl1uYMvD2ASQsfH9BOgosnxU(SCsQgj1LlutuvPk(p99xnhKPlBroFp5kqfR)w0tW3292S9Gf3cl5MQ6)aDdFctHMtE5a7W6GqL1Vbf7DBfB)jRAZGXGFP9nDQ(fLSMpvtoBiuWsa9L(UBkqEvIPffQ3yhx57fRUMW7VpS72hDoR9I5Sx2sW9j1Gg5HXI4bKoAPnr1oMuFG2TWatVyZRNqktfnQ2UlvFHwULit9gDLMmlMDn1NQ0S3QJXYtPwdFInZIRNUecRTLuhzULtTt7eozg84zDKDy0Ln3v(4Jept9SR3iIxE(6LbS4PUaxzLtSVjr1lw7KweefE9GthD(lQTxuHhCJNX7)uqyBsDEk85mUA1(ivzaEvF3rdQRRsD1(DEQO)N(6hBZ(qEWZmlhyJ1rwPiENLpu66vWluOH6NRDaRLY31Q(9rn1sOoYgx6kXPvTCgl2Hm3je(xW5KWp)dmHKBE)eiOIFdJzaSZCFQhR9zuDhxXseO5PLFaKjtNpKSfTF(PqbqqNZEzllofZa(J1uiCx1JwlTPWzSc6GmPmCp0zB3EAiDwB9IcqhI5y8ehZNS1E4bbIUNji8zrcHGquaKBdVlkMTr(404vGX(p4JfkHoJQGbsQOe40GlVWOhPlRrruLnJOlP1x6VNvsMwLhCB9P8B0Hel4w3xPfFZWA39OEwdrlsEDttSdbgAD6Yx4qT2hoSh5c1MhQ88G7VGJ2uKDa6osj9vvmPjDb(Ysw5PM2ZEVa1RRhKgl)WA4sxBr8TJeEWvj4Iocdsv1DMlUs0yz4ZU5(7s58jCXYLIybeOW6vgJ2nZs5DfshdEMCObSdvd4DS6dlDRNxCzebFVuP)u64gx)2ZnpJveY6Xjwc2wNFJsD1LdGK()EHRMrhfNE9p4pGRVJ)kV(Az(DF9D)qn76JvIA6WkbP4iPoVchKz3c7UxPBBg6B4qs2iZA)WkxeaoeZq)Os)eO82cbM9BI6O8Hn)L6Xg3nKdl5NvEagRX(dAa)73M6rTUOAqHQj1bhLgAuU0Usrn8AkYQFadMs0yiWcHV)95YY5u0ZjeuffLNCO3svVjK19c4TscDzuP7(VcClbGKv2wb1FGQYEqh7WKMXk1E5yn5AuGFLLDXYaos)E80yVsGRoyUFvAdTZ5ORLowzjaR2AjndsrdQ0ouF8XYsIyShyETizHPtaDw)P)X4lFf10zM()c]] )
