-- PriestDiscipline.lua
-- August 2025
-- Patch 11.2

if UnitClassBase( "player" ) ~= "PRIEST" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State
local spec = Hekili:NewSpecialization( 256 )

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

spec:RegisterResource( Enum.PowerType.Mana )

-- Talents
spec:RegisterTalents( {

    -- Priest
    angelic_bulwark                = {  82675,  108945, 1 }, -- When an attack brings you below $s1% health, you gain an absorption shield equal to $s2% of your maximum health for $s3 sec. Cannot occur more than once every $s4 sec
    angelic_feather                = {  82703,  121536, 1 }, -- Places a feather at the target location, granting the first ally to walk through it $s1% increased movement speed for $s2 sec. Only $s3 feathers can be placed at one time
    angels_mercy                   = {  82678,  238100, 1 }, -- Reduces the cooldown of Desperate Prayer by $s1 sec
    apathy                         = {  82689,  390668, 1 }, -- Your Mind Blast critical strikes reduce your target's movement speed by $s1% for $s2 sec
    benevolence                    = {  82676,  415416, 1 }, -- Increases the healing of your spells by $s1%
    binding_heals                  = {  82678,  368275, 1 }, -- $s1% of Flash Heal healing on other targets also heals you
    blessed_recovery               = {  82720,  390767, 1 }, -- After being struck by a melee or ranged critical hit, heal $s1% of the damage taken over $s2 sec
    body_and_soul                  = {  82706,   64129, 1 }, -- Power Word: Shield and Leap of Faith increase your target's movement speed by $s1% for $s2 sec
    cauterizing_shadows            = {  82687,  459990, 1 }, -- When your Shadow Word: Pain expires or is refreshed with less than $s1 sec remaining, a nearby ally within $s2 yards is healed for $s3
    crystalline_reflection         = {  82681,  373457, 2 }, -- Power Word: Shield instantly heals the target for $s1 and reflects $s2% of damage absorbed
    death_and_madness              = {  82711,  321291, 1 }, -- If your Shadow Word: Death fails to kill a target at or below $s1% health, its cooldown is reset. Cannot occur more than once every $s2 sec
    dispel_magic                   = {  82715,     528, 1 }, -- Dispels Magic on the enemy target, removing $s1 beneficial Magic effect
    divine_star                    = {  82682,  110744, 1 }, -- Throw a Divine Star forward $s2 yds, healing allies in its path for $s3 and dealing $s$s4 Holy damage to enemies. After reaching its destination, the Divine Star returns to you, healing allies and damaging enemies in its path again. Healing reduced beyond $s5 targets
    dominate_mind                  = {  82710,  205364, 1 }, -- Controls a mind up to $s1 level above yours for $s2 sec while still controlling your own mind. Does not work versus Demonic, Mechanical, or Undead beings or players. This spell shares diminishing returns with other disorienting effects
    essence_devourer               = {  82674,  415479, 1 }, -- Attacks from your Shadowfiend siphon life from enemies, healing a nearby injured ally for $s1. Attacks from your Mindbender siphon life from enemies, healing a nearby injured ally for $s2
    focused_mending                = {  82719,  372354, 1 }, -- Prayer of Mending does $s1% increased healing to the initial target
    from_darkness_comes_light      = {  82707,  390615, 1 }, -- Each time Shadow Word: Pain deals damage, the healing of your next Flash Heal is increased by $s1%, up to a maximum of $s2%
    halo                           = {  82682,  120517, 1 }, -- Creates a ring of Holy energy around you that quickly expands to a $s2 yd radius, healing allies for $s3 and dealing $s$s4 Holy damage to enemies. Healing reduced beyond $s5 targets
    holy_nova                      = {  82701,  132157, 1 }, -- An explosion of holy light around you deals up to $s$s2 Holy damage to enemies and up to $s3 healing to allies within $s4 yds, reduced if there are more than $s5 targets
    improved_fade                  = {  82686,  390670, 2 }, -- Reduces the cooldown of Fade by $s1 sec
    improved_flash_heal            = {  82714,  393870, 1 }, -- Increases healing done by Flash Heal by $s1%
    improved_purify                = {  82705,  390632, 1 }, -- Purify additionally removes all Disease effects
    inspiration                    = {  82696,  390676, 1 }, -- Reduces your target's physical damage taken by $s1% for $s2 sec after a critical heal with Flash Heal or Penance
    leap_of_faith                  = {  82716,   73325, 1 }, -- Pulls the spirit of a party or raid member, instantly moving them directly in front of you
    lights_inspiration             = {  82679,  373450, 2 }, -- Increases the maximum health gained from Desperate Prayer by $s1%
    manipulation                   = {  82672,  459985, 1 }, -- You take $s1% less damage from enemies affected by your Shadow Word: Pain
    mass_dispel                    = {  82699,   32375, 1 }, -- Dispels magic in a $s1 yard radius, removing all harmful Magic from $s2 friendly targets and $s3 beneficial Magic effect from $s4 enemy targets. Potent enough to remove Magic that is normally undispellable
    mental_agility                 = {  82698,  341167, 1 }, -- Reduces the mana cost of Purify and Mass Dispel by $s1% and Dispel Magic by $s2%
    mind_control                   = {  82710,     605, 1 }, -- Controls a mind up to $s1 level above yours for $s2 sec. Does not work versus Demonic, Undead, or Mechanical beings. Shares diminishing returns with other disorienting effects
    move_with_grace                = {  82702,  390620, 1 }, -- Reduces the cooldown of Leap of Faith by $s1 sec
    petrifying_scream              = {  82695,   55676, 1 }, -- Psychic Scream causes enemies to tremble in place instead of fleeing in fear
    phantasm                       = {  82556,  108942, 1 }, -- Activating Fade removes all snare effects
    phantom_reach                  = {  82673,  459559, 1 }, -- Increases the range of most spells by $s1%
    power_infusion                 = {  82694,   10060, 1 }, -- Infuses the target with power for $s1 sec, increasing haste by $s2%. Can only be cast on players
    power_word_life                = {  82676,  373481, 1 }, -- A word of holy power that heals the target for $s1 million. Only usable if the target is below $s2% health
    prayer_of_mending              = {  82718,   33076, 1 }, -- Places a ward on an ally that heals them for $s1 the next time they take damage, and then jumps to another ally within $s2 yds. Jumps up to $s3 times and lasts $s4 sec after each jump
    protective_light               = {  82707,  193063, 1 }, -- Casting Flash Heal on yourself reduces all damage you take by $s1% for $s2 sec
    psychic_voice                  = {  82695,  196704, 1 }, -- Reduces the cooldown of Psychic Scream by $s1 sec
    renew                          = {  82717,     139, 1 }, -- Fill the target with faith in the light, healing for $s1 over $s2 sec
    rhapsody                       = {  82700,  390622, 1 }, -- Every $s1 sec, the damage of your next Holy Nova is increased by $s2% and its healing is increased by $s3%. Stacks up to $s4 times
    sanguine_teachings             = {  82691,  373218, 1 }, -- Increases your Leech by $s1%
    sanlayn                        = {  82690,  199855, 1 }, --  Sanguine Teachings Sanguine Teachings grants an additional $s3% Leech.  Vampiric Embrace Reduces the cooldown of Vampiric Embrace by $s6 sec, increases its healing done by $s7%
    shackle_undead                 = {  82693,    9484, 1 }, -- Shackles the target undead enemy for $s1 sec, preventing all actions and movement. Damage will cancel the effect. Limit $s2
    shadow_word_death              = {  82712,   32379, 1 }, -- A word of dark binding that inflicts $s$s2 Shadow damage to your target. If your target is not killed by Shadow Word: Death, you take backlash damage equal to $s3% of your maximum health. Damage increased by $s4% to targets below $s5% health
    shadowfiend                    = {  82713,   34433, 1 }, -- Summons a shadowy fiend to attack the target for $s1 sec. Generates $s2% Mana each time the Shadowfiend attacks
    sheer_terror                   = {  82708,  390919, 1 }, -- Increases the amount of damage required to break your Psychic Scream by $s1%
    spell_warding                  = {  82720,  390667, 1 }, -- Reduces all magic damage taken by $s1%
    surge_of_light                 = {  82677,  109186, 1 }, -- Your healing spells and Smite have a $s1% chance to make your next Flash Heal instant and cost $s2% less mana. Stacks to $s3
    throes_of_pain                 = {  82709,  377422, 2 }, -- Shadow Word: Pain deals an additional $s1% damage. When an enemy dies while afflicted by your Shadow Word: Pain, you gain $s2% Mana
    tithe_evasion                  = {  82688,  373223, 1 }, -- Shadow Word: Death deals $s1% less damage to you
    translucent_image              = {  82685,  373446, 1 }, -- Fade reduces damage you take by $s1%
    twins_of_the_sun_priestess     = {  82683,  373466, 1 }, -- Power Infusion also grants you its effect at $s1% value when used on an ally. If no ally is targeted, it will grant its effect at $s2% value to a nearby ally, preferring damage dealers
    twist_of_fate                  = {  82684,  390972, 2 }, -- After damaging or healing a target below $s1% health, gain $s2% increased damage and healing for $s3 sec
    unwavering_will                = {  82697,  373456, 2 }, -- While above $s1% health, the cast time of your Flash Heal and Smite are reduced by $s2%
    vampiric_embrace               = {  82691,   15286, 1 }, -- Fills you with the embrace of Shadow energy for $s1 sec, causing you to heal a nearby ally for $s2% of any single-target Shadow spell damage you deal
    void_shield                    = {  82692,  280749, 1 }, -- When cast on yourself, $s1% of damage you deal refills your Power Word: Shield
    void_shift                     = {  82674,  108968, 1 }, -- Swap health percentages with your ally. Increases the lower health percentage of the two to $s1% if below that amount
    void_tendrils                  = {  82708,  108920, 1 }, -- Summons shadowy tendrils, rooting all enemies within $s1 yards for $s2 sec or until the tendril is killed
    words_of_the_pious             = {  82721,  377438, 1 }, -- For $s1 sec after casting Power Word: Shield, you deal $s2% additional damage and healing with Smite and Holy Nova

    -- Discipline
    abyssal_reverie                = {  82583,  373054, 2 }, -- Atonement heals for $s1% more when activated by Shadow spells
    atonement                      = {  82594,   81749, 1 }, -- Power Word: Shield, Flash Heal, Renew, Power Word: Radiance, and Power Word: Life apply Atonement to your target for $s1 sec. Your spell damage heals all targets affected by Atonement for $s2% of the damage done. Healing increased by $s3% when not in a raid
    blaze_of_light                 = {  82568,  215768, 2 }, -- The damage of Smite and Penance is increased by $s1%, and Penance increases or decreases your target's movement speed by $s2% for $s3 sec
    borrowed_time                  = {  82600,  390691, 2 }, -- Casting Power Word: Shield increases your Haste by $s1% for $s2 sec
    bright_pupil                   = {  82591,  390684, 1 }, -- Reduces the cooldown of Power Word: Radiance by $s1 sec
    castigation                    = {  82575,  193134, 1 }, -- Penance fires one additional bolt of holy light over its duration
    dark_indulgence                = {  82596,  372972, 1 }, -- Mind Blast has a $s1% chance to grant Power of the Dark Side and its mana cost is reduced by $s2%
    divine_aegis                   = {  82602,   47515, 1 }, -- Direct critical heals create a protective shield on the target, absorbing $s1% of the amount healed. Lasts $s2 sec
    divine_procession              = {  82599,  472361, 1 }, -- Smite extends the duration of an active Atonement by $s1 sec
    encroaching_shadows            = {  82590,  472568, 1 }, -- Shadow Word: Pain Spreads to $s1 nearby enemies when you cast Penance on the target
    enduring_luminescence          = {  82591,  390685, 1 }, -- Reduces the cast time of Power Word: Radiance by $s1% and causes it to apply Atonement at an additional $s2% of its normal duration
    eternal_barrier                = {  86730,  238135, 1 }, -- Power Word: Shield absorbs $s1% additional damage and lasts $s2 sec longer
    evangelism                     = {  82598,  472433, 1 }, -- Extends Atonement on all allies by $s1 sec and heals for $s2 million, split evenly among them
    expiation                      = {  82585,  390832, 2 }, -- Mind Blast and Shadow Word: Death consume $s1 sec of Shadow Word: Pain, dealing damage equal to $s2% of the amount consumed
    harsh_discipline               = {  82572,  373180, 2 }, -- Power Word: Radiance causes your next Penance to fire $s1 additional bolts, stacking up to $s2 charges
    indemnity                      = {  82576,  373049, 1 }, -- Atonements granted by Power Word: Shield last an additional $s1 sec
    inescapable_torment            = {  82586,  373427, 1 }, -- Penance, Mind Blast and Shadow Word: Death cause your Mindbender or Shadowfiend to teleport behind your target, slashing up to $s2 nearby enemies for $s$s3 Shadow damage and extending its duration by $s4 sec
    inner_focus                    = {  82601,  390693, 1 }, -- Flash Heal, Power Word: Shield, Penance, Power Word: Radiance, and Power Word: Life have a $s1% increased chance to critically heal
    lenience                       = {  82567,  238063, 1 }, -- Atonement reduces damage taken by $s1%
    lights_promise                 = {  82592,  322115, 1 }, -- Power Word: Radiance gains an additional charge
    luminous_barrier               = {  82564,  271466, 1 }, -- Create a shield on all allies within $s2 yards, absorbing $s$s3 million damage on each of them for $s4 sec. Absorption decreased beyond $s5 targets
    malicious_intent               = {  82580,  372969, 1 }, -- Increases the duration of Schism by $s1 sec
    mindbender                     = {  82584,  123040, 1 }, -- Summons a Mindbender to attack the target for $s1 sec. Generates $s2% Mana each time the Mindbender attacks
    overloaded_with_light          = {  82573,  421557, 1 }, -- Ultimate Penitence emits an explosion of light, healing up to $s1 allies around you for $s2 and applying Atonement at $s3% of normal duration
    pain_and_suffering             = {  82578,  390689, 2 }, -- Increases the damage of Shadow Word: Pain by $s1% and increases its duration by $s2 sec
    pain_suppression               = {  82587,   33206, 1 }, -- Reduces all damage taken by a friendly target by $s1% for $s2 sec. Castable while stunned
    pain_transformation            = {  82588,  372991, 1 }, -- Pain Suppression also heals your target for $s1% of their maximum health and applies Atonement
    painful_punishment             = {  82597,  390686, 1 }, -- Each Penance bolt extends the duration of Shadow Word: Pain on enemies hit by $s1 sec
    power_of_the_dark_side         = {  82595,  198068, 1 }, -- Shadow Word: Pain has a chance to empower your next Penance with Shadow, increasing its effectiveness by $s1%
    power_word_barrier             = {  82564,   62618, 1 }, -- Summons a holy barrier to protect all allies at the target location for $s1 sec, reducing all damage taken by $s2% and preventing damage from delaying spellcasting
    power_word_radiance            = {  82593,  194509, 1 }, -- A burst of light heals the target and $s1 injured allies within $s2 yards for $s3, and applies Atonement for $s4% of its normal duration
    protector_of_the_frail         = {  82588,  373035, 1 }, -- Pain Suppression gains an additional charge. Power Word: Shield reduces the cooldown of Pain Suppression by $s1 sec
    revel_in_darkness              = {  82566,  373003, 1 }, -- Shadow Word: Pain deals $s1% additional damage and spreads to $s2 additional target when you cast Penance to its target
    sanctuary                      = {  92225,  231682, 1 }, -- Smite prevents the next $s1 damage dealt by the enemy
    schism                         = {  82579,  424509, 1 }, -- Mind Blast fractures the enemy's mind, increasing your spell damage to the target by $s1% for $s2 sec
    shadow_covenant                = {  82581,  314867, 1 }, -- Casting Mindbender enters you into a shadowy pact, transforming Halo, Divine Star, and Penance into Shadow spells and increasing the damage and healing of your Shadow spells by $s1% while active
    shield_discipline              = {  82589,  197045, 1 }, -- When your Power Word: Shield is completely absorbed, you restore $s1% of your maximum mana
    twilight_corruption            = {  82582,  373065, 1 }, -- Shadow Covenant increases Shadow spell damage and healing by an additional $s1%
    twilight_equilibrium           = {  82571,  390705, 1 }, -- Your damaging Shadow spells increase the damage of your next Holy spell cast within $s1 sec by $s2%. Your damaging Holy spells increase the damage of your next Shadow spell cast within $s3 sec by $s4%
    ultimate_penitence             = {  82577,  421453, 1 }, -- Ascend into the air and unleash a massive barrage of Penance bolts, causing $s1 million Holy damage to enemies or $s2 million healing to allies over $s3 sec. While ascended, gain a shield for $s4% of your health. In addition, you are unaffected by knockbacks or crowd control effects
    void_summoner                  = {  82570,  390770, 1 }, -- Reduces the cooldown of Shadowfiend or Mindbender by $s1%
    weal_and_woe                   = {  82569,  390786, 1 }, -- Your Penance bolts increase the damage of your next Smite by $s1%, or the absorb of your next Power Word: Shield by $s2%. Stacks up to $s3 times

    -- Oracle
    assured_safety                 = {  94691,  440766, 1 }, -- Power Word: Shield casts apply $s1 stacks of Prayer of Mending to your target
    clairvoyance                   = {  94687,  428940, 1 }, -- Casting Premonition of Solace invokes Clairvoyance, expanding your mind and opening up all possibilities of the future.  Premonition of Clairvoyance Grants Premonition of Insight, Piety, and Solace at $s3% effectiveness
    desperate_measures             = {  94690,  458718, 1 }, -- Desperate Prayer lasts an additional $s1 sec. Angelic Bulwark's absorption effect is increased by $s2% of your maximum health
    divine_feathers                = {  94675,  440670, 1 }, -- Your Angelic Feathers increase movement speed by an additional $s1%. When an ally walks through your Angelic Feather, you are also granted $s2% of its effect
    fatebender                     = {  94700,  440743, 1 }, -- Increases the effects of Premonition by $s1%
    foreseen_circumstances         = {  94689,  440738, 1 }, -- Pain Suppression reduces damage taken by an additional $s1%
    miraculous_recovery            = {  94679,  440674, 1 }, -- Reduces the cooldown of Power Word: Life by $s1 sec and allows it to be usable on targets below $s2% health
    perfect_vision                 = {  94700,  440661, 1 }, -- Reduces the cooldown of Premonition by $s1 sec
    preemptive_care                = {  94674,  440671, 1 }, -- Increases the duration of Atonement and Renew by $s1 sec
    premonition                    = {  94683,  428924, 1 }, -- Gain access to a spell that gives you an advantage against your fate. Premonition rotates to the next spell when cast.  Premonition of Insight Reduces the cooldown of your next $s4 spell casts by $s5 sec.  Premonition of Piety Increases your healing done by $s8% and causes $s9% of overhealing on players to be redistributed to up to $s10 nearby allies for $s11 sec.  Premonition of Solace Your next single target healing spell grants your target a shield that absorbs $s$s14 million damage and reduces their damage taken by $s15% for $s16 sec
    preventive_measures            = {  94698,  440662, 1 }, -- Power Word: Shield absorbs $s2% additional damage$s$s3 All damage dealt by Penance, Smite and Holy Nova increased by $s4%
    prophets_will                  = {  94690,  433905, 1 }, -- Your Flash Heal and Power Word: Shield are $s1% more effective when cast on yourself
    save_the_day                   = {  94675,  440669, 1 }, -- For $s1 sec after casting Leap of Faith you may cast it a second time for free, ignoring its cooldown
    twinsight                      = {  94673,  440742, 1 }, -- $s1 additional Penance bolts are fired at an enemy within $s2 yards when healing an ally with Penance, or fired at an ally within $s3 yards when damaging an enemy with Penance
    waste_no_time                  = {  94679,  440681, 1 }, -- Premonition causes your next Power Word: Radiance cast to be instant and cost $s1% less mana

    -- Voidweaver
    collapsing_void                = {  94694,  448403, 1 }, -- Each time Penance damages or heals, Entropic Rift is empowered, increasing its damage and size by $s2%. After Entropic Rift ends it collapses, dealing $s$s3 Shadow damage split amongst enemy targets within $s4 yds
    dark_energy                    = {  94693,  451018, 1 }, -- While Entropic Rift is active, you move $s1% faster
    darkening_horizon              = {  94695,  449912, 1 }, -- Void Blast increases the duration of Entropic Rift by $s1 sec, up to a maximum of $s2 sec
    depth_of_shadows               = { 100212,  451308, 1 }, -- Shadow Word: Death has a high chance to summon a Shadowfiend for $s1 sec when damaging targets below $s2% health
    devour_matter                  = {  94668,  451840, 1 }, -- Shadow Word: Death consumes absorb shields from your target, dealing $s$s2 extra damage to them and granting you $s3% mana if a shield was present
    embrace_the_shadow             = {  94696,  451569, 1 }, -- You absorb $s1% of all magic damage taken. Absorbing Shadow damage heals you for $s2% of the amount absorbed
    entropic_rift                  = {  94684,  447444, 1 }, -- Mind Blast tears open an Entropic Rift that follows the enemy for $s2 sec. Enemies caught in its path suffer $s$s3 Shadow damage every $s4 sec while within its reach
    inner_quietus                  = {  94670,  448278, 1 }, -- Power Word: Shield absorbs $s1% additional damage
    no_escape                      = {  94693,  451204, 1 }, -- Entropic Rift slows enemies by up to $s1%, increased the closer they are to its center
    void_blast                     = {  94703,  450405, 1 }, -- Entropic Rift upgrades Smite into Void Blast while it is active. Void Blast: Sends a blast of cosmic void energy at the enemy, causing $s$s2 Shadow damage
    void_empowerment               = {  94695,  450138, 1 }, -- Summoning an Entropic Rift extends the duration of your $s1 shortest Atonements by $s2 sec
    void_infusion                  = {  94669,  450612, 1 }, -- Atonement healing with Void Blast is $s1% more effective
    void_leech                     = {  94696,  451311, 1 }, -- Every $s1 sec siphon an amount equal to $s2% of your health from an ally within $s3 yds if they are higher health than you
    voidheart                      = {  94692,  449880, 1 }, -- While Entropic Rift is active, your Atonement healing is increased by $s1%
    voidwraith                     = { 100212,  451234, 1 }, -- Transform your Shadowfiend or Mindbender into a Voidwraith. Voidwraith Summon a Voidwraith for $s3 sec that casts Void Flay from afar. Void Flay deals bonus damage to high health enemies, up to a maximum of $s4% if they are full health. Generates $s5% Mana each time the Voidwraith attacks
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
        type = "Magic",
        max_stack = 1,
        generate = function( t, auraType )
            if auraType == "debuff" then return end

            local remains = pet.shadowfiend.remains
            if remains == 0 then return end

            t.expires = query_time + remains
            t.applied = t.expires - 15
            t.count = 1
        end
    },
    mindbender = {
        duration = 15,
        max_stack = 1,
        generate = function( t, auraType )
            if auraType == "debuff" then return end

            local remains = pet.mindbender.remains
            if remains == 0 then return end

            t.expires = query_time + remains
            t.applied = t.expires - 15
            t.count = 1
        end
    },
    voidwraith = {
        duration = 15,
        max_stack = 1,
        generate = function( t, auraType )
            if auraType == "debuff" then return end

            local remains = pet.voidwraith.remains
            if remains == 0 then return end

            t.expires = query_time + remains
            t.applied = t.expires - 15
            t.count = 1
        end
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

spec:RegisterGear({
    -- The War Within
    tww3 = {
        items = { 237710, 237708, 237709, 237712, 237707 },
        auras = {
            -- Oracle
            visionary_velocity = {
                id = 1239609,
                duration = 10,
                max_stack = 10
            },
            -- Voidweaver
            overflowing_void = {
                id = 1237615,
                duration = 3600,
                max_stack = 1
            },
        }
    },
    tww2 = {
        items = { 229334, 229332, 229337, 229335, 229333 }
    },
    tww1 = {
        items = { 212084, 212083, 212081, 212086, 212082 },
        auras = {
            darkness_from_light = {
                id = 455033,
                duration = 30,
                max_stack = 3
            }
        }
    },
    -- Dragonflight
    tier29 = {
        items = { 200327, 200329, 200324, 200326, 200328 }
    },
    tier30 = {
        items = { 202543, 202542, 202541, 202545, 202540 },
        auras = {
            radiant_providence = {
                id = 410638,
                duration = 3600,
                max_stack = 2
            }
        }
    },
    tier31 = {
        items = { 207279, 207280, 207281, 207282, 207284, 217202, 217204, 217205, 217201, 217203 }
    }
} )

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

local premonitions = {
    insight = "premonition_of_insight",
    piety = "premonition_of_piety",
    solace = "premonition_of_solace",
    clairvoyance = "premonition_of_clairvoyance"
}

spec:RegisterHook( "reset_precast", function ()
    if talent.premonition.enabled then
        local charge = min( cooldown.premonition_of_insight.charge, cooldown.premonition_of_solace.charge, cooldown.premonition_of_piety.charge, cooldown.premonition_of_clairvoyance.charge )
        local start = max( cooldown.premonition_of_insight.recharge_began, cooldown.premonition_of_solace.recharge_began, cooldown.premonition_of_piety.recharge_began, cooldown.premonition_of_clairvoyance.recharge_began )
        local duration = talent.perfect_vision.enabled and 45 or 60

        for _, v in pairs( premonitions ) do
            local cd = cooldown[ v ]
            cd.charge = charge
            cd.recharge_began = start
            cd.duration = duration
            cd.recharge = duration
        end
    end

    if buff.voidheart.up then
        applyBuff( "entropic_rift", buff.voidheart.remains )
    elseif entropic_rift_expires > query_time then
        applyBuff( "entropic_rift", entropic_rift_expires - query_time )
    end

    rift_extensions = nil
end )

spec:RegisterHook( "TALENTS_UPDATED", function()
    -- For ability/cooldown, Mindbender takes precedent.
    local sf = talent.mindbender.enabled and "mindbender_actual" or talent.voidwraith.enabled and "voidwraith" or "shadowfiend"

    class.abilities.shadowfiend = class.abilities[ sf ]
    class.abilities.mindbender = class.abilities.mindbender_actual

    rawset( cooldown, "shadowfiend", cooldown[ sf ] )
    rawset( cooldown, "mindbender", cooldown.mindbender_actual )
    rawset( cooldown, "fiend", cooldown.shadowfiend )

    -- For totem/pet/buff, Voidwraith takes precedent.
    sf = talent.voidwraith.enabled and "voidwraith" or talent.mindbender.enabled and "mindbender" or "shadowfiend"

    class.totems.fiend = spec.totems[ sf ]
    totem.fiend = totem[ sf ]
    pet.fiend = pet[ sf ]
    buff.fiend = buff[ sf ]
end )

spec:RegisterTotems( {
    mindbender = {
        id = 136214,
        copy = "mindbender_actual"
    },
    shadowfiend = {
        id = 136199,
        copy = "shadowfiend_actual"
    },
    voidwraith = {
        id = 615099
    },
} )

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
        if set_bonus.tww3_oracle >= 4 then addStack( "visionary_velocity" ) end
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

        spend = function() return 0.04 * ( buff.surge_of_light.up and 0.5 or 1 )end,
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
    mindbender = {
        id = function() return state.spec.shadow and 200174 or 123040 end,
        known = 34433,
        flash = { 34433, 123040, 200174, 451235 },
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "shadow",

        talent = "mindbender",
        startsCombat = true,
        texture = 136214,

        handler = function ()
            local sf = talent.voidwraith.enabled and "voidwraith" or "mindbender"
            summonPet( sf, 12 )
            applyBuff( sf )
            if talent.shadow_covenant.enabled then applyBuff( "shadow_covenant" ) end
        end,

        bind = { "shadowfiend", "voidwraith" },

        copy = { "mindbender_actual", 123040, 200174 }
    },

    shadowfiend = {
        id = 34433,
        flash = { 34433, 123040, 200174, 451235 },
        cast = 0,
        cooldown = function() return talent.void_summoner.enabled and 90 or 180 end,
        gcd = "spell",
        school = "shadow",

        toggle = "cooldowns",

        notalent = function() return talent.mindbender.enabled and "mindbender" or "voidwraith" end,

        startsCombat = true,
        texture = 136199,

        handler = function ()
            summonPet( "shadowfiend" )
            applyBuff( "shadowfiend" )

            if talent.shadow_covenant.enabled then applyBuff( "shadow_covenant" ) end
        end,

        bind = { "mindbender", "voidwraith" },

        copy = "shadowfiend_actual"
    },

    voidwraith = {
        id = 451235,
        known = 34433,
        flash = { 34433, 123040, 200174, 451235 },
        cast = 0,
        cooldown = function() return talent.void_summoner.enabled and 90 or 180 end,
        gcd = "spell",
        school = "shadow",

        toggle = "cooldowns",

        talent = "voidwraith",
        notalent = "mindbender",

        startsCombat = true,
        texture = 615099,

        handler = function ()
            summonPet( "voidwraith" )
            applyBuff( "voidwraith" )

            if talent.shadow_covenant.enabled then applyBuff( "shadow_covenant" ) end
        end,

        bind = { "shadowfiend", "mindbender" }
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

        spend = function() return 0.05 * ( buff.waste_no_time.up and 0.85 or 1 ) end,
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

            spendCharges( "premonition_of_clairvoyance", 1 )
            spendCharges( "premonition_of_piety", 1 )
            spendCharges( "premonition_of_solace", 1 )
        end,
    },

    premonition_of_clairvoyance = {
        id = 440725,
        cast = 0,
        charges = 2,
        cooldown = function() return talent.perfect_vision.enabled and 45 or 60 end,
        recharge = function() return action.premonition_of_insight.cooldown end,
        gcd = "off",

        talent = "premonition",

        handler = function()
            applyBuff( "premonition_of_insight" )
            applyBuff( "premonition_of_piety" )
            applyBuff( "premonition_of_solace" )

            spendCharges( "premonition_of_insight", 1 )
            spendCharges( "premonition_of_piety", 1 )
            spendCharges( "premonition_of_solace", 1 )
        end,
    },

    premonition_of_piety = {
        id = 428930,
        cast = 0,
        charges = 2,
        cooldown = function() return talent.perfect_vision.enabled and 45 or 60 end,
        recharge = function() return action.premonition_of_insight.cooldown end,
        gcd = "off",

        talent = "premonition",

        handler = function()
            applyBuff( "premonition_of_piety" )

            spendCharges( "premonition_of_clairvoyance", 1 )
            spendCharges( "premonition_of_insight", 1 )
            spendCharges( "premonition_of_solace", 1 )
        end,
    },

    premonition_of_solace = {
        id = 428934,
        cast = 0,
        charges = 2,
        cooldown = function() return talent.perfect_vision.enabled and 45 or 60 end,
        recharge = function() return action.premonition_of_insight.cooldown end,
        gcd = "off",

        talent = "premonition",

        handler = function()
            applyBuff( "premonition_of_solace" )

            spendCharges( "premonition_of_clairvoyance", 1 )
            spendCharges( "premonition_of_insight", 1 )
            spendCharges( "premonition_of_piety", 1 )
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
        cast = function() return 1.5 * haste * ( set_bonus.tww3 >= 2 and state.spec.discipline and talent.void_blast.enabled and buff.entropic_rift.up and 0.8 or 1 ) end,
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

            if set_bonus.tww3_voidweaver >= 4 then removeBuff( "overflowing_void" ) end
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

spec:RegisterPack( "戒律Simc", 20250424, [[Hekili:TZ1EZTnsY9plUCfzsVI0sup8fxYkvYQ9Y6T29oxR8v()ejeaOiIjbyaaLSsPIF2t3ZlmpbgackBNlxPBTeWGz6UNE6(x3Zm9nhFZNU56OGY4B(BtoAYzhD6KthF8Bp60to9MRlFCD8nxVoi8lb3b)sAWk4)EvsryY6LjPKx94YSGiSlkY2KhcpArz56I39M3Cxs5In3oomB1BkswTzzqzswAyEW8s8VdFZnxF7MKLLFi9MBTp(NCZ1bBkxKLFZ1xNS6NHEojkkM284IWBU(xJdwgNVD268KS8KYK4ITZcYJ3o7QpE9O5zHBkIJ2ollD5JB)TT)g25Jo60rto5DBN9NXRYUhA5h)0NzV70rh92rNCe8UpTaEXNdGo(ZalKKEZ1ltkkliIP45bBwwc)6FJi2ItdUDzC0n)haPgI83nxhgSC5u6Fmf)o6xpLk6cZYwgL9qAXnLa3Q1dzRbHyCzvxDFqEc(w83wUb(NxSD2TBMpFC5djltUBr504)BqeMCBEYMvtxKT8XPbRwpEZ6TZoy7SABCXIaGoynNmsmkSmEAAgmZc03jTM(8C82o7PN2oJ)1J5djzwnpznTZ)eRB2o7xQ6NTZskOSvs6DBNr71TZIcwr0pvyd6lrg50EKruKY9eBG9PdMaFfYcN1AwOewBKwoMj4dbT90a4V59Hkv(7ziDCntCYBmLmfFrfHTeA(0cOziPDERjn(QagXnpjonsipjIEDQg1rvi4)moicKzLzGsqzqEzLUqfXVErqHI8mmiDkitIZf0(BBnTFKChYiZI1XlxwmnAtoXg30vbFf78)ILopikQMoFI)D()AR7C6lgVkjnA6TldkaDHVghUbuYktwf7)iF8rTzO9OpVgMwHjLKaHsBuq(xMc05ML3fNgg7qPDnoph6ndIKUUrBVLAmY)HS8OPrXbLl0eEgSGLpWCDudcABoiEMPwINe(Sc(IPbG0DvquACrHwJYVlUC8cWNm85RdHfGxSD2KwSE5yBoC8IFXP87GrOOj(uQHTE2WMxeVOUOK7bSstr7unrFknT1uOnNeErHlcwM1ePrBtRPjBEhMVmdb15KQg4WlaVZ3oBKKFx3eW2zd3o7nBNDxy0yIHgfZhdqNaGBx5oL7eH2zvVK2p)N)8vGEoiE2o79GFXc4xbyRacZ5CF48V7HySVY2SewBKgJRqqpvaEusxsC6xIOmtJ)k66Iqipa6M4yVDg1Bm9PXFfaBSmgGLo44Zi04XtOuZXJpJqhtiewbZziyuKG5vNIqV7z5Lw623ATxhDY4t8QJhGGEgkRraI6PsqxoUtozvMQ(5SnPLePgVPhYfGBwDlgcaofaeYO550ony52z5XRcssLqyfc(eWqeUpizPU)jrJvi927cxOwklfACCS5nherjZTSqSmh6GPzZNcHgTbqw6W74N(7x93FxLg804VUooSevfPypV7UhPtNm3OVbD6IcniAQvGr(dr9vIWlGGXQmjeFB0Mq6QLGc(BsJgLapyEwooh8Gm3Yh0PSbzQOdCkcNgVSiMHZIbkcJvYgOJwQefSmeJcngvhG1zR2eUGQtWxudU)kxq1L0neGlOxeGrmgUjphMgq9jHI0yiuXy26B7MJOlIIIHPsWhe0SK5YDkD8XM8qm5bOani9r9fBylwNNbZeLI4kKIozCZgMjcZwbdQH(tsbvGRNnBlW0pG8JXRPRfkunN7wLHyo)ch(ge91qTP9RdxKuarC9rn0Iu1QwbXQdsIkahsYclVLr(sRsBnJ(h8oZt0ri73kexDG9nXvAtmy2kbt2APaUomy5dbpcVdWJYCtmpjhxMF9NF3v6sNgWkJsPwH8ZFPu9IGExqr(5ash6cRoDezVfz)PLztHxpfF1f(rid9kKb9fPXHzi8cCcILXUzpSioL3r4cIaSbuAdmlsiDQDs28f4Dki9U4om)2kCZ(p)AgpA4cK8bH0LacRJ1Kb)7rrmB(pag9rpn8wJoKWEbMIXUX26B9b41qx1y4WtSboVhyCQ5ENu3uzqAejbrLXV2FbbWRqtM(ZXexiEpMJiFbDbHvbvEm9ZMs9l7LBhYpvo78JsUGtjMCJFDqpZbovjLhtd9sYqIwAdkXWywsWEtBfDfkpbtEMMMj2IyOh0lfMVKdZ2MDw533clSAsVRi9cyud6gDU3zobq2VvrD0b2NekVn(M8IUZW)k856mQzQfqoSvX7yjn8oCJCLl81XPyOs8GFPRjKcpuh4Td410fA3teSaK)pWgIOS0xvYhPp9lv(SoSckY8aiQg4B(h0qQkwbm5Rk4(UsYsLJbaJblUigZHDajQKIYrqCkyWfHaJNNKPb0ht0aepP)Xu5kdlwrK7kIgWGXLcBpeoYyI(K2h2M1nhqqx)u1ak9A1uxPOs8xPi)yH(ZZjdFA5wqM(RxHXufVE0LCXWOllibnm6s8DAXfll5X03iItrWZDk6kZUsALGyQWi7bKPa9iD)qn6(8Ppu3KyDxo5ingGPywINsnKFTUpMBUTM5yDOp)jgIhqQzBYrRr6j7rwozn)jN0(TQ0w8O2ZVyZbKkAQLjX7v29j(wwG0C73vs3JdzHXeDq1SCy8za6772o7ke8ljrGeq2KSafxwIzpd8CdmtgeQuEvUg4wqj7OUcoBYgRn2q7T4HOQfbDctTA38dZcaR7a6Z7cGoHyYP4Ealkr77zICaEGvyufIS6ipmMWosnScsCTD2leVhwSLq9Vk3hdDTdty0dt0N9zdbQQJ63OAaSi4D4FJ2XtFf(VeDz8vGMEk(GG7X)IWmW3X5f8nz4xGVMrB6qCCNFLt6esoNtl(ka(JQyfTToNT(VA5nb(I0kCBmOdO6N0Q9HU7COssf8A3H5Puqkaf1mk0cU80oTL31WLU2SV61ZBATsnXFWsFcIgNzrVL6eSoqbRRGa0fL1fDZPTcE0USlL7QWSg3BN2(ZUvn5oZYE0yGQOspsfrb8Ccb1EeqTenXFuToA7mP)On4imvQmoJoeIPAPyLeVtjH1AV9JcUItTEOVEwXvCANYqytsD3hveZSpjBy6v2rIQBNO5m(EA3HlvlBTthtglzEd0TusmUAsnIOa6j2LzdvhefDhIsZIIwJ2ZMuq0j68Fs5w9ThWp3tUbSDQxjMYeWGZmBBFt5)0c0Qj()HP4LjLLy6(Vf5NIKvRXZlCs4HiwvWab90ICBgov7mZRz0uzi2qA4xjjKf(LvzRizssEFW45MfpAkfvFoEEPhd6AmZtzarVk5)Hfsmp1jydxNvuKGMn19gvjsCAKYwUOSMVC8auiy49F69vDhAXd0zTpxwDWflttN6ILR2tvu4EzZyrM0EVTnSgXy1nz8ReaTc5wDD2pkEGp7BFQToRtBrFdc963)3b1fnUI97MI(xpKmhjEs2cVH3Dy2epyrzBklsIIPM(uBrLsVIQTG4WJ4KG6WeFxITSrVen778SDdtABNBA)2Q)SHI4SUNUV6KeEbsOHSD4e(qTWdCKiGZ2n8WTJp)2MZJZA)X20Y5AYNqB1LmMqkOhRjKOSHwTx9bRVPTkZHs51Oso19mGz0D)O4x8CRqHEw9lEE3bJuNyVPtgLxwKm9ZTjDjyxTbVy0LQIoN2dGGXXA3MTkFENoDJ7Gm67ypuN3DCu1ll8sJWWhv1gqJkiTWS85DhZHh8XZVBMZ7oYbp4hJeq4oIl)MvSN2GZ3H7aPCUYR2aAdNKMmRQBsP3tOiDV3gIg9J(HmOdfh53gNgfNtUcMCUjFtQZR4m6ZzkEEkiKHU)Alo4exMuYqlES2L10RXw9EPQ7youE)n1oKRrjXe)QWBocV4lVgdrq9EXTgCcnw50Vio3EyerjHFH4bJfbvE888y4ZVftgtvROYESRMVz501BstkwSkww8RgbwDTK2Rwjt5ZWLTt6qxo59k)unFOp2OO)T64due9kXpAxhu5IvZ2MJA2gywguTrseVbeAshWGVg)idk50sTo7bqDKCZBINsAn6mFmkzvx2yiMVq6sOXPsPCLHKNUV6DwKXicLjlPZFYB1DiwnGDz0SL5pnou3Z1oZHsH2n07dLGk5jIS4T6(H2zQtrLTMi8mngXpX9C7rNrSh5Xgiw3AZQfc6oR2zo1yEWZme5AQWTVRgPUQUe3jysV52fuhzxjxTksBnxWVTw)pDzGL0OEUvA(lel6IMGh2tzEdxGFn40pmB1TbvLhfHzhIHtspoplVmPCtK5NxvBuQP6QiDQp1dCNM7pYDWBDmEyp5302c25GluuziOx12ciG4haJtKgrVPRJgrbcws2GM47rqT8n7aJa5Xvz5X)BAAKUQyfLML4fV(oLvfu0xyFvR96g7R7ZsIEipiHoDQBkwDIcHCuqvPLLWqO3G(3h)W2QlZ8djyKzMcy9nQRvRH1Xavhs1bgQ4Evnry68LMfwLkjrPPeO4X0quHGUSHY8F8dYmNeobUuKPkOB1LpqGCCk81RkSowLGk8xiAZ(pAuoVcmI67fysW9NKbKM3w6cXku0wwiQqJQLnMFMjFDPa3echHToXbAxOjy7vhOw7D4kHcC5KDeBk1kzXy6jFc55tm9r4EP1ZaLP4orJa1CP4gbLp5KXj8JELdBWrstWS2heIeQ3MW(0FdFT6GtSGt5BjLzOdoXPoOB4u1Qd23mrdQzUXE9nAXGASqg1qjBPNPUTwDVtRc04g1mPVrIYMH924LvRwngJQT0(BbOlj9ZNBiN6LnfJ((Ge4wanQFrphdUM1nJ6v0(Jg27k07xpk0TquZumjUWslfohfyJ)xBkyNmj6TAeJuiFtkz7XCu(viGFjhHTGBZiLHLS0OeIrrR(5PvuhZLzkbDYQQmwwkO1mLGznf2ATEICRL1V0A3jYTJSiqRbNEtJXCxLT9AcAwk878GOeAzqrzg5JqpqUvayKDKSUBgvNScu9xsZlOBTmF7rie69X5Kqk514vaK7db54U6ctkKkUAYQ1KcufPoc9kwLw9v8tbj6vPid30(GnLzyD3kICogtVlUy82F73jBA)XN)ommKuyWiVpd8Ds8mXozrVAqT1vSrsQ9KwyPMIn8FHLi3xrfw9rx(gExogRfTFGihqY)mEaA4HeTOe5tygFDCiwZkoht4s28KLInOQySidm)07FJTCUGDpRTql0RuThIBIY7fPHrUPCUG2KsALo9WS1VViU8qYoA9(x4vnt9GAAgtcXkUQ)2l3oZNINkxnLw(uRLOPnvLS9KCE6jzBFi37nbkxDxRL8Wg6lXjjsDqAEusxDtnIuaOsp2tidz48UGS6Eqv3Xp1r2rsEE6jxj4X5O4EDO6iEeWwVKVaSTDtqueRBOF)y6fkxzJJpmzUqGsRrvDKMRgSj7ExWOxh7ypzQMVXs75Xss(OTZC92iB4k35eKEd)oGeoW1rT5aJaXVaau2xeS9tbHeHwTBq91q666ekRHiLaJ(AynUVHsJhjvo4IH))QiApwfrDp1jvnnX5ksfKLnB1daW4y6iZO7PInQBEZ48nA4iQvFzLESG1LKEuylFRQnOUzf3h(eM0iz(HIy(4Rc1lfQC3G0)LCtJi(XHj1)jO4F2wdFM4DGL3mKiTh6tBG9uHMJ(Eei3a9hYcN8I6YcYqcr)XUbird7KcHvvbtbkBGRd2tLXf3QVd9Gb(JU6YSLEOTwwsLf9vpNrFctdEWfnw6n7fURzat1wunvu0mEV)6C9yfR8zsSuhF3lYLHhmWgYZNEYAgoVO5HBOtiUKPaVlyM9Iawkkf2486MJFX53E57pwJh29kSyFZMgkqdCYos3)wGZoWN2DXeqFzWGJh5vVo64HdTiVvUjVnyPDiAj3NX6IJzuMpnENPkIAGsPAPpMgRlKjhLbtzlawkaMEyt8xjbf1duV1iV0lFLY0RCHR0dc9FEQtK1nDW2zN6WxBj1J1g1LbUi7t6dVK71YOQrQbDNmD171Wr3sfJljOhPHKX0)KINyZctjHv2F3tVwYtvR5yX(IlXetBgbwE5rSS8w7T2RLrQwS5wgnCC9zfMr8QZfMOYnJ5Voy5IgzEXqja8ybbUNQEInmDXl3tQSSBs(NM8Tv9sME)Ut16L4majUM9wnbStIhjKd2JxBWa9CQEqDhpieHJXh8c9tPZWHMji(Y3p5irKO7sPdCxLdo3haxeCJ3fXNtk6ax7xHoeV9A14Bx442LQD7ksMQC7cf1uw43DAGD1kQ1tVTlorvUruTlZzhXckMEzFx28AqQwP8(dLNelK93Jou8T40TlCRcGY63IqBB4Ni9cBB71R)zIOB12xY5MQTxSRLdUEG78FtqTziQAhy()mfcU6TUwjsTfSPPZwRzvId73soCKkvC9z6KunsQRxOgOQsw8F(lFBEOtxvID(rYvGkv)9ONGVVRQz7GiUfwYTL1)b6g(eMcTh8YE2H1EHlRFdk25kt2UZw1gbJf)s7A4u9lj5mEQMC2qibha6R8D3eqEvMPfjQ3AfB5hfRU2O7FmS72hvzRDs4St2sW9j1YkY9JfX9iF0sBIQ1CP(GSBHbMEXMxpru2sAuT1NQ(IS8lqM6n6knyom7ARoxPzVvNILhsTY(eDKf3(fjcwBlPoWETSAR2jCYE3JN1r6Hrx2Cx1Jpq8m1ZUEJeE15RxUJfp1N(vEXjw3Li5lw7KweLeF5GJgFYRRTwwHhCJxWQFvaSnPkxf(CQu1SouvbWZ8DhmOUQs1f725PI8)0N)OB2hkdEHD9axIoIvkISZXhkD9kyjk0s(Z1oG1sX76C99bnvsPoWLu6cXPvTAe57qM)mc7lyss4N)kgqYvF8AauXVJyga7mpKhqRVhM74kMIanpTSdGmX05JzBq7NFjw0jOZ5GIf8tXmq)yofI3AE0AjBkCbnHoOqQa3dD62TNhtoRTbjrOdXsepXHSbBvaEqGi3ZeS)PiHWUqKaKBJVljLUr(4WeWP4WhdXeLqoJQGbsssjWHbNEHwpwxxJGOQykHVKMFj)90k20P(GFZpvFJEprb36)mT4Bgw7Uh1ZRq0qYRBAIEiWqRtN9ApY1(WH9OuO24qLhhC)f80MISdq)jkPVYWKM0f4RiBzGAyp78euVoFqwXYoSg(CvsfF7yHhCvgMFnvrUQUZCXfI7zkB0TxrAQgpHlwMwefqGIOxPnA3mlL3X1og8czOb0dvd4D08HvU1l5xgrW3lj1Fk1iKlF)j2hrdLSECGL6BNJVvTU6IbqA9)orR2jhfNE9F3VhNFN8nE(1X47)87UrAUxpAGAA)QbP4iPoVc7Lr3H4Ux5Bxg6B4qs2OWA3OkFua2hJq)SK(zyXBluy2TbQJ6hU8xQJnUBehMYpNYaeRXU31a93VLHKADr1WcQMwo4P2qJ6LUxuuJSMGS6LiykrHHate(Zx52SI2e1Mcb3tqdsGO3uHaq5JRG(1(VTQsAw)3(sss5J6yfZ0(yRwlhRj0eEP4QklnoAWb6x7NglTcSvp2RfMUi7sg56OIvw1HMf8s7DPOSz6UxF6PQmOyTgyEPi2csnQ5M)3)]] )
