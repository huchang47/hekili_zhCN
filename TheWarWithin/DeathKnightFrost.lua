-- DeathKnightFrost.lua
-- January 2025

if UnitClassBase( "player" ) ~= "DEATHKNIGHT" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local PTR = ns.PTR

local strformat = string.format

local spec = Hekili:NewSpecialization( 251 )

spec:RegisterResource( Enum.PowerType.Runes, {
    rune_regen = {
        last = function () return state.query_time end,
        stop = function( x ) return x == 6 end,

        interval = function( time, val )
            val = floor( val )
            if val == 6 then return -1 end
            return state.runes.expiry[ val + 1 ] - time
        end,
        value = 1,
    },

    empower_rune = {
        aura = "empower_rune_weapon",

        last = function()
            local applied = state.buff.empower_rune_weapon.applied
            return applied + floor( ( state.query_time - applied ) / 5 ) * 5
        end,

        stop = function( x )
            return x == 6
        end,

        interval = 5,
        value = 1,
    },
}, setmetatable( {
    expiry = { 0, 0, 0, 0, 0, 0 },
    cooldown = 10,
    regen = 0,
    max = 6,
    forecast = {},
    fcount = 0,
    times = {},
    values = {},
    resource = "runes",

    reset = function()
        local t = state.runes
        for i = 1, 6 do
            local start, duration, ready = GetRuneCooldown( i )
            start = start or 0
            duration = duration or ( 10 * state.haste )
            t.expiry[ i ] = ready and 0 or ( start + duration )
            t.cooldown = duration
        end
        table.sort( t.expiry )
        t.actual = nil -- Reset actual to force recalculation
    end,

    gain = function( amount )
        local t = state.runes
        for i = 1, amount do
            table.insert( t.expiry, 0 )
            t.expiry[ 7 ] = nil
        end
        table.sort( t.expiry )
        t.actual = nil
    end,

    spend = function( amount )
        local t = state.runes
        for i = 1, amount do
            local nextReady = ( t.expiry[ 4 ] > 0 and t.expiry[ 4 ] or state.query_time ) + t.cooldown
            table.remove( t.expiry, 1 )
            table.insert( t.expiry, nextReady )
        end

        if state.this_action == "obliterate" and state.buff.exterminate.up then
            state.gain( 20, "runic_power" )
        else
            state.gain( amount * 10, "runic_power" )
        end

        if state.talent.gathering_storm.enabled and state.buff.remorseless_winter.up then
            state.buff.remorseless_winter.expires = state.buff.remorseless_winter.expires + ( 0.5 * amount )
        end

        t.actual = nil
    end,

    timeTo = function( x )
        return state:TimeToResource( state.runes, x )
    end,
}, {
    __index = function( t, k )
        if k == "actual" then
            -- Calculate the number of runes available based on `expiry`.
            local amount = 0
            for i = 1, 6 do
                if t.expiry[ i ] <= state.query_time then
                    amount = amount + 1
                end
            end
            return amount

        elseif k == "current" then
            -- If this is a modeled resource, use our lookup system.
            if t.forecast and t.fcount > 0 then
                local q = state.query_time
                local index, slice

                if t.values[ q ] then return t.values[ q ] end

                for i = 1, t.fcount do
                    local v = t.forecast[ i ]
                    if v.t <= q and v.v ~= nil then
                        index = i
                        slice = v
                    else
                        break
                    end
                end

                -- We have a slice.
                if index and slice and slice.v then
                    t.values[ q ] = max( 0, min( t.max, slice.v ) )
                    return t.values[ q ]
                end
            end

            return t.actual

        elseif k == "deficit" then
            return t.max - t.current

        elseif k == "time_to_next" then
            return t[ "time_to_" .. t.current + 1 ]

        elseif k == "time_to_max" then
            return t.current == t.max and 0 or max( 0, t.expiry[ 6 ] - state.query_time )

        else
            local amount = k:match( "time_to_(%d+)" )
            amount = amount and tonumber( amount )
            if amount then return t.timeTo( amount ) end
        end
    end
}))

spec:RegisterStateExpr( "breath_ticks_left", function()
    if not buff.breath_of_sindragosa.up then
        return 0
    end
    return floor( runic_power.current / 17 ) + ( runic_power.current % 17 + ( floor( runes.current / 2 )  * 20 ) / gcd.max ) / 17
end )

spec:RegisterResource( Enum.PowerType.RunicPower, {
    breath_of_sindragosa = {
        aura = "breath_of_sindragosa",
        stop = function( x )
            return state.buff.breath_of_sindragosa.down or x < 17 or breath_ticks_left == 0
        end,
        interval = 1,
        value = -17,

        last = function()
            local app = state.buff.breath_of_sindragosa.applied
            return app + floor( state.query_time - app )
        end,
    },

    empower_rp = {
        aura = "empower_rune_weapon",
        last = function () return state.buff.empower_rune_weapon.applied + floor( ( state.query_time - state.buff.empower_rune_weapon.applied ) / 5 ) * 5 end,
        interval = 5,
        value = 5
    },

    swarming_mist = {
        aura = "swarming_mist",

        last = function ()
            return state.buff.swarming_mist.applied + floor( state.query_time - state.buff.swarming_mist.applied )
        end,

        interval = 1,
        value = function () return min( 15, state.true_active_enemies * 3 ) end,
    },

} )

-- Talents
spec:RegisterTalents( {
    -- DeathKnight
    abomination_limb            = {  76049, 383269, 1 }, -- Sprout an additional limb, dealing 54,565 Shadow damage over 12 sec to all nearby enemies. Deals reduced damage beyond 5 targets. Every 1 sec, an enemy is pulled to your location if they are further than 8 yds from you. The same enemy can only be pulled once every 4 sec.
    antimagic_barrier           = {  76046, 205727, 1 }, -- Reduces the cooldown of Anti-Magic Shell by 20 sec and increases its duration and amount absorbed by 40%.
    antimagic_zone              = {  76065,  51052, 1 }, -- Places an Anti-Magic Zone that reduces spell damage taken by party or raid members by 20%. The Anti-Magic Zone lasts for 8 sec or until it absorbs 1.3 million damage.
    asphyxiate                  = {  76064, 221562, 1 }, -- Lifts the enemy target off the ground, crushing their throat with dark energy and stunning them for 5 sec.
    assimilation                = {  76048, 374383, 1 }, -- The amount absorbed by Anti-Magic Zone is increased by 10% and its cooldown is reduced by 30 sec.
    blinding_sleet              = {  76044, 207167, 1 }, -- Targets in a cone in front of you are blinded, causing them to wander disoriented for 5 sec. Damage may cancel the effect. When Blinding Sleet ends, enemies are slowed by 50% for 6 sec.
    blood_draw                  = {  76056, 374598, 1 }, -- When you fall below 30% health you drain 17,735 health from nearby enemies, the damage you take is reduced by 10% and your Death Strike cost is reduced by 10 for 8 sec. Can only occur every 2 min.
    blood_scent                 = {  76078, 374030, 1 }, -- Increases Leech by 3%.
    brittle                     = {  76061, 374504, 1 }, -- Your diseases have a chance to weaken your enemy causing your attacks against them to deal 6% increased damage for 5 sec.
    cleaving_strikes            = {  76073, 316916, 1 }, -- Obliterate hits up to 2 additional enemies while you remain in Death and Decay. When leaving your Death and Decay you retain its bonus effects for 4 sec.
    coldthirst                  = {  76083, 378848, 1 }, -- Successfully interrupting an enemy with Mind Freeze grants 10 Runic Power and reduces its cooldown by 3 sec.
    control_undead              = {  76059, 111673, 1 }, -- Dominates the target undead creature up to level 71, forcing it to do your bidding for 5 min.
    death_pact                  = {  76075,  48743, 1 }, -- Create a death pact that heals you for 50% of your maximum health, but absorbs incoming healing equal to 30% of your max health for 15 sec.
    death_strike                = {  76071,  49998, 1 }, -- Focuses dark power into a strike with both weapons, that deals a total of 8,500 Physical damage and heals you for 40.00% of all damage taken in the last 5 sec, minimum 11.2% of maximum health.
    deaths_echo                 = { 102007, 356367, 1 }, -- Death's Advance, Death and Decay, and Death Grip have 1 additional charge.
    deaths_reach                = { 102006, 276079, 1 }, -- Increases the range of Death Grip by 10 yds. Killing an enemy that yields experience or honor resets the cooldown of Death Grip.
    enfeeble                    = {  76060, 392566, 1 }, -- Your ghoul's attacks have a chance to apply Enfeeble, reducing the enemies movement speed by 30% and the damage they deal to you by 12% for 6 sec.
    gloom_ward                  = {  76052, 391571, 1 }, -- Absorbs are 15% more effective on you.
    grip_of_the_dead            = {  76057, 273952, 1 }, -- Death and Decay reduces the movement speed of enemies within its area by 90%, decaying by 10% every sec.
    ice_prison                  = {  76086, 454786, 1 }, -- Chains of Ice now also roots enemies for 4 sec but its cooldown is increased to 12 sec.
    icebound_fortitude          = {  76081,  48792, 1 }, -- Your blood freezes, granting immunity to Stun effects and reducing all damage you take by 30% for 8 sec.
    icy_talons                  = {  76085, 194878, 1 }, -- Your Runic Power spending abilities increase your melee attack speed by 6% for 10 sec, stacking up to 5 times.
    improved_death_strike       = {  76067, 374277, 1 }, -- Death Strike's cost is reduced by 10, and its healing is increased by 60%.
    insidious_chill             = {  76051, 391566, 1 }, -- Your auto-attacks reduce the target's auto-attack speed by 5% for 30 sec, stacking up to 4 times.
    march_of_darkness           = {  76074, 391546, 1 }, -- Death's Advance grants an additional 25% movement speed over the first 3 sec.
    mind_freeze                 = {  76084,  47528, 1 }, -- Smash the target's mind with cold, interrupting spellcasting and preventing any spell in that school from being cast for 3 sec.
    null_magic                  = { 102008, 454842, 1 }, -- Magic damage taken is reduced by 8% and the duration of harmful Magic effects against you are reduced by 35%.
    osmosis                     = {  76088, 454835, 1 }, -- Anti-Magic Shell increases healing received by 15%.
    permafrost                  = {  76066, 207200, 1 }, -- Your auto attack damage grants you an absorb shield equal to 40% of the damage dealt.
    proliferating_chill         = { 101708, 373930, 1 }, -- Chains of Ice affects 1 additional nearby enemy.
    raise_dead                  = {  76072,  46585, 1 }, -- Raises a ghoul to fight by your side. You can have a maximum of one ghoul at a time. Lasts 1 min.
    rune_mastery                = {  76079, 374574, 2 }, -- Consuming a Rune has a chance to increase your Strength by 3% for 8 sec.
    runic_attenuation           = {  76045, 207104, 1 }, -- Auto attacks have a chance to generate 3 Runic Power.
    runic_protection            = {  76055, 454788, 1 }, -- Your chance to be critically struck is reduced by 3% and your Armor is increased by 6%.
    sacrificial_pact            = {  76060, 327574, 1 }, -- Sacrifice your ghoul to deal 11,084 Shadow damage to all nearby enemies and heal for 25% of your maximum health. Deals reduced damage beyond 8 targets.
    soul_reaper                 = {  76063, 343294, 1 }, -- Strike an enemy for 9,914 Shadowfrost damage and afflict the enemy with Soul Reaper. After 5 sec, if the target is below 35% health this effect will explode dealing an additional 45,489 Shadowfrost damage to the target. If the enemy that yields experience or honor dies while afflicted by Soul Reaper, gain Runic Corruption.
    subduing_grasp              = {  76080, 454822, 1 }, -- When you pull an enemy, the damage they deal to you is reduced by 6% for 6 sec.
    suppression                 = {  76087, 374049, 1 }, -- Damage taken from area of effect attacks reduced by 3%. When suffering a loss of control effect, this bonus is increased by an additional 6% for 6 sec.
    unholy_bond                 = {  76076, 374261, 1 }, -- Increases the effectiveness of your Runeforge effects by 20%.
    unholy_endurance            = {  76058, 389682, 1 }, -- Increases Lichborne duration by 2 sec and while active damage taken is reduced by 15%.
    unholy_ground               = {  76069, 374265, 1 }, -- Gain 5% Haste while you remain within your Death and Decay.
    unyielding_will             = {  76050, 457574, 1 }, -- Anti-Magic shell now removes all harmful magical effects when activated, but it's cooldown is increased by 20 sec.
    vestigial_shell             = {  76053, 454851, 1 }, -- Casting Anti-Magic Shell grants 2 nearby allies a Lesser Anti-Magic Shell that Absorbs up to 55,050 magic damage and reduces the duration of harmful Magic effects against them by 50%.
    veteran_of_the_third_war    = {  76068,  48263, 1 }, -- Stamina increased by 20%.
    will_of_the_necropolis      = {  76054, 206967, 2 }, -- Damage taken below 30% Health is reduced by 20%.
    wraith_walk                 = {  76077, 212552, 1 }, -- Embrace the power of the Shadowlands, removing all root effects and increasing your movement speed by 70% for 4 sec. Taking any action cancels the effect. While active, your movement speed cannot be reduced below 170%.

    -- Deathbringer
    absolute_zero               = { 102009, 377047, 1 }, -- Frostwyrm's Fury has 50% reduced cooldown and Freezes all enemies hit for 3 sec.
    arctic_assault              = {  76091, 456230, 1 }, -- Consuming Killing Machine fires a Glacial Advance through your target at 80% effectiveness.
    avalanche                   = {  76105, 207142, 1 }, -- Casting Howling Blast with Rime active causes jagged icicles to fall on enemies nearby your target, applying Razorice and dealing 4,963 Frost damage.
    biting_cold                 = {  76111, 377056, 1 }, -- Remorseless Winter damage is increased by 35%. The first time Remorseless Winter deals damage to 3 different enemies, you gain Rime.
    bonegrinder                 = {  76122, 377098, 2 }, -- Consuming Killing Machine grants 1% critical strike chance for 10 sec, stacking up to 5 times. At 5 stacks your next Killing Machine consumes the stacks and grants you 10% increased Frost damage for 10 sec.
    breath_of_sindragosa        = {  76093, 152279, 1 }, -- Continuously deal 25,472 Frost damage every 1 sec to enemies in a cone in front of you, until your Runic Power is exhausted. Deals reduced damage to secondary targets. Generates 2 Runes at the start and end.
    chill_streak                = {  76098, 305392, 1 }, -- Deals 25,420 Frost damage to the target and reduces their movement speed by 70% for 4 sec. Chill Streak bounces up to 12 times between closest targets within 10 yards.
    cold_heart                  = {  76035, 281208, 1 }, -- Every 2 sec, gain a stack of Cold Heart, causing your next Chains of Ice to deal 2,481 Frost damage. Stacks up to 20 times.
    cryogenic_chamber           = {  76109, 456237, 1 }, -- Each time Frost Fever deals damage, 15% of the damage dealt is gathered into the next cast of Remorseless Winter, up to 20 times.
    empower_rune_weapon         = {  76110,  47568, 1 }, -- Empower your rune weapon, gaining 15% Haste and generating 1 Rune and 5 Runic Power instantly and every 5 sec for 20 sec.
    enduring_chill              = {  76097, 377376, 1 }, -- Chill Streak's bounce range is increased by 2 yds and each time Chill Streak bounces it has a 25% chance to increase the maximum number of bounces by 1.
    enduring_strength           = {  76100, 377190, 1 }, -- When Pillar of Frost expires, your Strength is increased by 15% for 6 sec. This effect lasts 2 sec longer for each Obliterate and Frostscythe critical strike during Pillar of Frost.
    everfrost                   = {  76113, 376938, 1 }, -- Remorseless Winter deals 6% increased damage to enemies it hits, stacking up to 10 times.
    frigid_executioner          = {  76120, 377073, 1 }, -- Obliterate deals 15% increased damage and has a 15% chance to refund 2 runes.
    frost_strike                = {  76115,  49143, 1 }, -- Chill your weapon with icy power and quickly strike the enemy, dealing 26,260 Frost damage.
    frostscythe                 = {  76096, 207230, 1 }, -- A sweeping attack that strikes all enemies in front of you for 18,880 Frost damage. This attack always critically strikes and critical strikes with Frostscythe deal 4 times normal damage. Deals reduced damage beyond 5 targets. Consuming Killing Machine reduces the cooldown of Frostscythe by 1.0 sec.
    frostwhelps_aid             = {  76106, 377226, 1 }, -- Pillar of Frost summons a Frostwhelp who breathes on all enemies within 40 yards in front of you for 9,278 Frost damage. Each unique enemy hit by Frostwhelp's Aid grants you 8% Mastery for 15 sec, up to 40%.
    frostwyrms_fury             = { 101931, 279302, 1 }, -- Summons a frostwyrm who breathes on all enemies within 40 yd in front of you, dealing 81,901 Frost damage and slowing movement speed by 50% for 10 sec.
    gathering_storm             = {  76099, 194912, 1 }, -- Each Rune spent during Remorseless Winter increases its damage by 10%, and extends its duration by 0.5 sec.
    glacial_advance             = {  76092, 194913, 1 }, -- Summon glacial spikes from the ground that advance forward, each dealing 10,985 Frost damage and applying Razorice to enemies near their eruption point.
    horn_of_winter              = {  76089,  57330, 1 }, -- Blow the Horn of Winter, gaining 2 Runes and generating 25 Runic Power.
    howling_blast               = {  76114,  49184, 1 }, -- Blast the target with a frigid wind, dealing 4,770 Frost damage to that foe, and reduced damage to all other enemies within 10 yards, infecting all targets with Frost Fever.  Frost Fever A disease that deals 57,047 Frost damage over 24 sec and has a chance to grant the Death Knight 5 Runic Power each time it deals damage.
    hyperpyrexia                = {  76108, 456238, 1 }, -- Your Runic Power spending abilities have a chance to additionally deal 45% of the damage dealt over 4 sec.
    icebreaker                  = {  76033, 392950, 2 }, -- When empowered by Rime, Howling Blast deals 30% increased damage to your primary target.
    icecap                      = { 101930, 207126, 1 }, -- Reduces Pillar of Frost cooldown by 15 sec.
    icy_death_torrent           = { 101933, 435010, 1 }, -- Your auto attack critical strikes have a chance to send out a torrent of ice dealing 24,555 Frost damage to enemies in front of you.
    improved_frost_strike       = {  76103, 316803, 2 }, -- Increases Frost Strike damage by 10%.
    improved_obliterate         = {  76119, 317198, 1 }, -- Increases Obliterate damage by 10%.
    improved_rime               = {  76112, 316838, 1 }, -- Increases Howling Blast damage done by an additional 75%.
    inexorable_assault          = {  76037, 253593, 1 }, -- Gain Inexorable Assault every 8 sec, stacking up to 5 times. Obliterate consumes a stack to deal an additional 5,815 Frost damage.
    killing_machine             = {  76117,  51128, 1 }, -- Your auto attack critical strikes have a chance to make your next Obliterate deal Frost damage and critically strike.
    murderous_efficiency        = {  76121, 207061, 1 }, -- Consuming the Killing Machine effect has a 25% chance to grant you 1 Rune.
    obliterate                  = {  76116,  49020, 1 }, -- A brutal attack that deals 28,347 Physical damage.
    obliteration                = {  76123, 281238, 1 }, -- While Pillar of Frost is active, Frost Strike Soul Reaper, and Howling Blast always grant Killing Machine and have a 30% chance to generate a Rune. to deal additional damage.
    piercing_chill              = {  76097, 377351, 1 }, -- Enemies suffer 12% increased damage from Chill Streak each time they are struck by it.
    pillar_of_frost             = { 101929,  51271, 1 }, -- The power of frost increases your Strength by 30% for 12 sec.
    rage_of_the_frozen_champion = {  76120, 377076, 1 }, -- Obliterate has a 15% increased chance to trigger Rime and Howling Blast generates 6 Runic Power while Rime is active.
    runic_command               = {  76102, 376251, 2 }, -- Increases your maximum Runic Power by 5.
    shattered_frost             = {  76094, 455993, 1 }, -- When Frost Strike consumes 5 Razorice stacks, it deals 60% of the damage dealt to nearby enemies. Deals reduced damage beyond 8 targets.
    shattering_blade            = {  76095, 207057, 1 }, -- When Frost Strike damages an enemy with 5 stacks of Razorice it will consume them to deal an additional 115% damage.
    smothering_offense          = {  76101, 435005, 1 }, -- Your auto attack damage is increased by 10%. This amount is increased for each stack of Icy Talons you have and it can stack up to 2 additional times.
    the_long_winter             = { 101932, 456240, 1 }, -- While Pillar of Frost is active your auto-attack critical strikes increase its duration by 2 sec, up to a maximum of 6 sec.
    unleashed_frenzy            = {  76118, 376905, 1 }, -- Damaging an enemy with a Runic Power ability increases your Strength by 2% for 10 sec, stacks up to 3 times.

    -- Rider of the Apocalypse
    a_feast_of_souls            = {  95042, 444072, 1 }, -- While you have 2 or more Horsemen aiding you, your Runic Power spending abilities deal 20% increased damage.
    apocalypse_now              = {  95041, 444040, 1 }, -- Army of the Dead and Frostwyrm's Fury call upon all 4 Horsemen to aid you for 20 sec.
    death_charge                = {  95060, 444010, 1 }, -- Call upon your Death Charger to break free of movement impairment effects. For 10 sec, while upon your Death Charger your movement speed is increased by 100%, you cannot be slowed below 100% of normal speed, and you are immune to forced movement effects and knockbacks.
    fury_of_the_horsemen        = {  95042, 444069, 1 }, -- Every 50 Runic Power you spend extends the duration of the Horsemen's aid in combat by 1 sec, up to 5 sec.
    horsemens_aid               = {  95037, 444074, 1 }, -- While at your aid, the Horsemen will occasionally cast Anti-Magic Shell on you and themselves at 80% effectiveness. You may only benefit from this effect every 45 sec.
    hungering_thirst            = {  95044, 444037, 1 }, -- The damage of your diseases and Frost Strike are increased by 10%.
    mawsworn_menace             = {  95054, 444099, 1 }, -- Obliterate deals 10% increased damage and the cooldown of your Death and Decay is reduced by 10 sec.
    mograines_might             = {  95067, 444047, 1 }, -- Your damage is increased by 5% and you gain the benefits of your Death and Decay while inside Mograine's Death and Decay.
    nazgrims_conquest           = {  95059, 444052, 1 }, -- If an enemy dies while Nazgrim is active, the strength of Apocalyptic Conquest is increased by 3%. Additionally, each Rune you spend increase its value by 1%.
    on_a_paler_horse            = {  95060, 444008, 1 }, -- While outdoors you are able to mount your Acherus Deathcharger in combat.
    pact_of_the_apocalypse      = {  95037, 444083, 1 }, -- When you take damage, 5% of the damage is redirected to each active horsemen.
    riders_champion             = {  95066, 444005, 1, "rider_of_the_apocalypse" }, -- Spending Runes has a chance to call forth the aid of a Horsemen for 10 sec. Mograine Casts Death and Decay at his location that follows his position. Whitemane Casts Undeath on your target dealing 2,608 Shadowfrost damage per stack every 3 sec, for 24 sec. Each time Undeath deals damage it gains a stack. Cannot be Refreshed. Trollbane Casts Chains of Ice on your target slowing their movement speed by 40% and increasing the damage they take from you by 5% for 8 sec. Nazgrim While Nazgrim is active you gain Apocalyptic Conquest, increasing your Strength by 5%.
    trollbanes_icy_fury         = {  95063, 444097, 1 }, -- Obliterate shatters Trollbane's Chains of Ice when hit, dealing 31,015 Shadowfrost damage to nearby enemies, and slowing them by 40% for 4 sec. Deals reduced damage beyond 8 targets.
    whitemanes_famine           = {  95047, 444033, 1 }, -- When Obliterate damages an enemy affected by Undeath it gains 1 stack and infects another nearby enemy.

    -- Deathbringer
    bind_in_darkness            = {  95043, 440031, 1 }, -- Rime empowered Howling Blast deals 30% increased damage to its main target, and is now Shadowfrost. Shadowfrost damage applies 2 stacks to Reaper's Mark and 4 stacks when it is a critical strike.
    dark_talons                 = {  95057, 436687, 1 }, -- Consuming Killing Machine or Rime has a 25% chance to grant 3 stacks of Icy Talons and increase its maximum stacks by the same amount for 6 sec. Runic Power spending abilities count as Shadowfrost while Icy Talons is active.
    deaths_messenger            = {  95049, 437122, 1 }, -- Reduces the cooldowns of Lichborne and Raise Dead by 30 sec.
    expelling_shield            = {  95049, 439948, 1 }, -- When an enemy deals direct damage to your Anti-Magic Shell, their cast speed is reduced by 10% for 6 sec.
    exterminate                 = {  95068, 441378, 1 }, -- After Reaper's Mark explodes, your next 2 Obliterates cost 1 Rune and summon 2 scythes to strike your enemies. The first scythe strikes your target for 74,146 Shadowfrost damage and has a 30% chance to apply Reaper's Mark, the second scythe strikes all enemies around your target for 25,308 Shadowfrost damage. Deals reduced damage beyond 8 targets.
    grim_reaper                 = {  95034, 434905, 1 }, -- Reaper's Mark initial strike grants Killing Machine. Reaper's Mark explosion deals up to 30% increased damage based on your target's missing health.
    pact_of_the_deathbringer    = {  95035, 440476, 1 }, -- When you suffer a damaging effect equal to 25% of your maximum health, you instantly cast Death Pact at 50% effectiveness. May only occur every 2 min. When a Reaper's Mark explodes, the cooldowns of this effect and Death Pact are reduced by 5 sec.
    reaper_of_souls             = {  95034, 440002, 1 }, -- When you apply Reaper's Mark, the cooldown of Soul Reaper is reset, your next Soul Reaper costs no runes, and it explodes on the target regardless of their health. Soul Reaper damage is increased by 20%.
    reapers_mark                = {  95062, 439843, 1, "deathbringer" }, -- Viciously slice into the soul of your enemy, dealing 55,138 Shadowfrost damage and applying Reaper's Mark. Each time you deal Shadow or Frost damage, add a stack of Reaper's Mark. After 12 sec or reaching 40 stacks, the mark explodes, dealing 4,233 damage per stack. Reaper's Mark travels to an unmarked enemy nearby if the target dies, or explodes below 35% health when there are no enemies to travel to. This explosion cannot occur again on a target for 3 min.
    reapers_onslaught           = {  95057, 469870, 1 }, -- Reduces the cooldown of Reaper's Mark by 15 sec, but the amount of Obliterates empowered by Exterminate is reduced by 1.
    rune_carved_plates          = {  95035, 440282, 1 }, -- Each Rune spent reduces the magic damage you take by 1.5% and each Rune generated reduces the physical damage you take by 1.5% for 5 sec, up to 5 times.
    soul_rupture                = {  95061, 437161, 1 }, -- When Reaper's Mark explodes, it deals 30% of the damage dealt to nearby enemies and causes them to deal 5% reduced Physical damage to you for 10 sec.
    swift_and_painful           = {  95032, 443560, 1 }, -- If no enemies are struck by Soul Rupture, you gain 10% Strength for 8 sec. Wave of Souls is 100% more effective on the main target of your Reaper's Mark.
    wave_of_souls               = {  95036, 439851, 1 }, -- Reaper's Mark sends forth bursts of Shadowfrost energy and back, dealing 17,091 Shadowfrost damage both ways to all enemies caught in its path. Wave of Souls critical strikes cause enemies to take 5% increased Shadowfrost damage for 15 sec, stacking up to 2 times, and it is always a critical strike on its way back.
    wither_away                 = {  95058, 441894, 1 }, -- Frost Fever deals its damage 100% faster, and the second scythe of Exterminate applies Frost Fever.
} )


-- PvP Talents
spec:RegisterPvpTalents( {
    bitter_chill      = 5435, -- (356470)
    bloodforged_armor = 5586, -- (410301)
    dark_simulacrum   = 3512, -- (77606) Places a dark ward on an enemy player that persists for 12 sec, triggering when the enemy next spends mana on a spell, and allowing the Death Knight to unleash an exact duplicate of that spell.
    dead_of_winter    = 3743, -- (287250)
    deathchill        =  701, -- (204080)
    delirium          =  702, -- (233396)
    rot_and_wither    = 5510, -- (202727)
    shroud_of_winter  = 3439, -- (199719)
    spellwarden       = 5591, -- (410320)
    strangulate       = 5429, -- (47476) Shadowy tendrils constrict an enemy's throat, silencing them for 4 sec.
} )


-- Auras
spec:RegisterAuras( {
    -- Your Runic Power spending abilities deal $w1% increased damage.
    a_feast_of_souls = {
        id = 440861,
        duration = 3600,
        max_stack = 1,
    },
    -- Talent: Absorbing up to $w1 magic damage.  Immune to harmful magic effects.
    -- https://wowhead.com/beta/spell=48707
    antimagic_shell = {
        id = 48707,
        duration = function () return ( legendary.deaths_embrace.enabled and 2 or 1 ) * 5 + ( conduit.reinforced_shell.mod * 0.001 ) end,
        max_stack = 1
    },
    antimagic_zone = { -- TODO: Modify expiration based on last cast.
        id = 145629,
        duration = 8,
        max_stack = 1
    },
    asphyxiate = {
        id = 108194,
        duration = 4,
        mechanic = "stun",
        type = "Magic",
        max_stack = 1
    },
    -- Next Howling Blast deals Shadowfrost damage.
    bind_in_darkness = {
        id = 443532,
        duration = 3600,
        max_stack = 1,
    },
    -- Talent: Disoriented.
    -- https://wowhead.com/beta/spell=207167
    blinding_sleet = {
        id = 207167,
        duration = 5,
        mechanic = "disorient",
        type = "Magic",
        max_stack = 1
    },
    blood_draw = {
        id = 454871,
        duration = 8,
        max_stack = 1
    },
    -- You may not benefit from the effects of Blood Draw.
    -- https://wowhead.com/beta/spell=374609
    blood_draw_cd = {
        id = 374609,
        duration = 120,
        max_stack = 1
    },
    -- Draining $w1 health from the target every $t1 sec.
    -- https://wowhead.com/beta/spell=55078
    blood_plague = {
        id = 55078,
        duration = function() return 24 * ( talent.wither_away.enabled and 0.5 or 1 ) end,
        tick_time = function() return 3 * ( talent.wither_away.enabled and 0.5 or 1 ) end,
        max_stack = 1
    },
    -- Draining $s1 health from the target every $t1 sec.
    -- https://wowhead.com/beta/spell=206931
    blooddrinker = {
        id = 206931,
        duration = 3,
        type = "Magic",
        max_stack = 1
    },
    bonegrinder_crit = {
        id = 377101,
        duration = 10,
        max_stack = 5
    },
    -- Talent: Frost damage increased by $s1%.
    -- https://wowhead.com/beta/spell=377103
    bonegrinder_frost = {
        id = 377103,
        duration = 10,
        max_stack = 1
    },
    -- Talent: Continuously dealing Frost damage every $t1 sec to enemies in a cone in front of you.
    -- https://wowhead.com/beta/spell=152279
    breath_of_sindragosa = {
        id = 152279,
        duration = 3600,
        tick_time = 1,
        max_stack = 1,
    },
    -- Talent: Movement slowed $w1% $?$w5!=0[and Haste reduced $w5% ][]by frozen chains.
    -- https://wowhead.com/beta/spell=45524
    chains_of_ice = {
        id = 45524,
        duration = 8,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    chilled = {
        id = 204206,
        duration = 4,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    cold_heart_item = {
        id = 235599,
        duration = 3600,
        max_stack = 20
    },
    -- Talent: Your next Chains of Ice will deal $281210s1 Frost damage.
    -- https://wowhead.com/beta/spell=281209
    cold_heart_talent = {
        id = 281209,
        duration = 3600,
        max_stack = 20,
    },
    cold_heart = {
        alias = { "cold_heart_item", "cold_heart_talent" },
        aliasMode = "first",
        aliasType = "buff",
        duration = 3600,
        max_stack = 20,
    },
    -- Talent: Controlled.
    -- https://wowhead.com/beta/spell=111673
    control_undead = {
        id = 111673,
        duration = 300,
        mechanic = "charm",
        type = "Magic",
        max_stack = 1
    },
    cryogenic_chamber = {
        id = 456370,
        duration = 30,
        max_stack = 20
    },
    -- Taunted.
    -- https://wowhead.com/beta/spell=56222
    dark_command = {
        id = 56222,
        duration = 3,
        mechanic = "taunt",
        max_stack = 1
    },
    dark_succor = {
        id = 101568,
        duration = 20,
        max_stack = 1
    },
    -- Reduces healing done by $m1%.
    -- https://wowhead.com/beta/spell=327095
    death = {
        id = 327095,
        duration = 6,
        type = "Magic",
        max_stack = 3
    },
    death_and_decay = { -- Buff.
        id = 188290,
        duration = 10,
        tick_time = 1,
        max_stack = 1
    },
    -- [444347] $@spelldesc444010
    death_charge = {
        id = 444347,
        duration = 10,
        max_stack = 1,
    },
    -- Talent: The next $w2 healing received will be absorbed.
    -- https://wowhead.com/beta/spell=48743
    death_pact = {
        id = 48743,
        duration = 15,
        max_stack = 1
    },
    -- Your movement speed is increased by $s1%, you cannot be slowed below $s2% of normal speed, and you are immune to forced movement effects and knockbacks.
    -- https://wowhead.com/beta/spell=48265
    deaths_advance = {
        id = 48265,
        duration = 10,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Haste increased by $s3%.  Generating $s1 $LRune:Runes; and ${$m2/10} Runic Power every $t1 sec.
    -- https://wowhead.com/beta/spell=47568
    empower_rune_weapon = {
        id = 47568,
        duration = 20,
        tick_time = 5,
        max_stack = 1
    },
    -- Talent: When Pillar of Frost expires, you will gain $s1% Strength for $<duration> sec.
    -- https://wowhead.com/beta/spell=377192
    enduring_strength = {
        id = 377192,
        duration = 20,
        max_stack = 20
    },
    -- Talent: Strength increased by $w1%.
    -- https://wowhead.com/beta/spell=377195
    enduring_strength_buff = {
        id = 377195,
        duration = function() return 6 + 2 * buff.enduring_strength.stack end,
        max_stack = 1
    },
    everfrost = {
        id = 376974,
        duration = 8,
        max_stack = 10
    },
    -- Casting speed reduced by $w1%.
    expelling_shield = {
        id = 440739,
        duration = 6.0,
        max_stack = 1,
    },
    -- Reduces damage dealt to $@auracaster by $m1%.
    -- https://wowhead.com/beta/spell=327092
    famine = {
        id = 327092,
        duration = 6,
        max_stack = 3
    },
    -- Suffering $w1 Frost damage every $t1 sec.
    -- https://wowhead.com/beta/spell=55095
    frost_fever = {
        id = 55095,
        duration = function() return 24 * ( talent.wither_away.enabled and 0.5 or 1 ) end,
        tick_time = function() return 3 * ( talent.wither_away.enabled and 0.5 or 1 ) end,
        max_stack = 1
    },
    -- Talent: Grants ${$s1*$mas}% Mastery.
    -- https://wowhead.com/beta/spell=377253
    frostwhelps_aid = {
        id = 377253,
        duration = 15,
        type = "Magic",
        max_stack = 5
    },
    -- Talent: Movement speed slowed by $s2%.
    -- https://wowhead.com/beta/spell=279303
    frostwyrms_fury = {
        id = 279303,
        duration = 10,
        type = "Magic",
        max_stack = 1
    },
    frozen_pulse = {
        -- Pseudo aura for legacy talent.
        name = "Frozen Pulse",
        meta = {
            up = function () return runes.current < 3 end,
            down = function () return runes.current >= 3 end,
            stack = function () return runes.current < 3 and 1 or 0 end,
            duration = 15,
            remains = function () return runes.time_to_3 end,
            applied = function () return runes.current < 3 and query_time or 0 end,
            expires = function () return runes.current < 3 and ( runes.time_to_3 + query_time ) or 0 end,
        }
    },
    -- Dealing $w1 Frost damage every $t1 sec.
    -- https://wowhead.com/beta/spell=274074
    glacial_contagion = {
        id = 274074,
        duration = 14,
        tick_time = 2,
        type = "Magic",
        max_stack = 1
    },
    -- Dealing $w1 Shadow damage every $t1 sec.
    -- https://wowhead.com/beta/spell=275931
    harrowing_decay = {
        id = 275931,
        duration = 4,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    -- Deals $s1 Fire damage.
    -- https://wowhead.com/beta/spell=286979
    helchains = {
        id = 286979,
        duration = 15,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    -- Rooted.
    ice_prison = {
        id = 454787,
        duration = 4.0,
        max_stack = 1,
    },
    -- Talent: Damage taken reduced by $w3%.  Immune to Stun effects.
    -- https://wowhead.com/beta/spell=48792
    icebound_fortitude = {
        id = 48792,
        duration = 8,
        tick_time = 1.0,
        max_stack = 1
    },
    icy_talons = {
        id = 194879,
        duration = 10,
        max_stack = function() return ( talent.smothering_offense.enabled and 5 or 3 ) + ( talent.dark_talons.enabled and 3 or 0 ) end,
    },
    inexorable_assault = {
        id = 253595,
        duration = 3600,
        max_stack = 5,
    },
    insidious_chill = {
        id = 391568,
        duration = 30,
        max_stack = 4
    },
    -- Talent: Guaranteed critical strike on your next Obliterate$?s207230[ or Frostscythe][].
    -- https://wowhead.com/beta/spell=51124
    killing_machine = {
        id = 51124,
        duration = 10,
        max_stack = 2,
    },
    -- Absorbing up to $w1 magic damage.; Duration of harmful magic effects reduced by $s2%.
    lesser_antimagic_shell = {
        id = 454863,
        duration = function() return 5.0 * ( talent.antimagic_barrier.enabled and 1.4 or 1 ) end,
        max_stack = 1,

        -- Affected by:
        -- antimagic_barrier[205727] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -20000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- antimagic_barrier[205727] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.5, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- osmosis[454835] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- unyielding_will[457574] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- spellwarden[410320] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- Casting speed reduced by $w1%.
    -- https://wowhead.com/beta/spell=326868
    lethargy = {
        id = 326868,
        duration = 6,
        max_stack = 1
    },
    -- Leech increased by $s1%$?a389682[, damage taken reduced by $s8%][] and immune to Charm, Fear and Sleep. Undead.
    -- https://wowhead.com/beta/spell=49039
    lichborne = {
        id = 49039,
        duration = 10,
        tick_time = 1,
        max_stack = 1
    },
    march_of_darkness = {
        id = 391547,
        duration = 3,
        max_stack = 1
    },
    -- Talent: $@spellaura281238
    -- https://wowhead.com/beta/spell=207256
    obliteration = {
        id = 207256,
        duration = 3600,
        max_stack = 1
    },
    -- Grants the ability to walk across water.
    -- https://wowhead.com/beta/spell=3714
    path_of_frost = {
        id = 3714,
        duration = 600,
        tick_time = 0.5,
        max_stack = 1
    },
    -- Suffering $o1 shadow damage over $d and slowed by $m2%.
    -- https://wowhead.com/beta/spell=327093
    pestilence = {
        id = 327093,
        duration = 6,
        tick_time = 1,
        type = "Magic",
        max_stack = 3
    },
    -- Talent: Strength increased by $w1%.
    -- https://wowhead.com/beta/spell=51271
    pillar_of_frost = {
        id = 51271,
        duration = 12,
        type = "Magic",
        max_stack = 1
    },
    -- Frost damage taken from the Death Knight's abilities increased by $s1%.
    -- https://wowhead.com/beta/spell=51714
    razorice = {
        id = 51714,
        duration = 20,
        tick_time = 1,
        type = "Magic",
        max_stack = 5
    },
    -- You are a prey for the Deathbringer... This effect will explode for $436304s1 Shadowfrost damage for each stack.
    reapers_mark = {
        id = 434765,
        duration = 12.0,
        tick_time = 1.0,
        max_stack = 40,
    },
    -- Talent: Dealing $196771s1 Frost damage to enemies within $196771A1 yards each second.
    -- https://wowhead.com/beta/spell=196770
    remorseless_winter = {
        id = 196770,
        duration = 8,
        tick_time = 1,
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=211793
    remorseless_winter_snare = {
        id = 211793,
        duration = 3,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Your next Howling Blast will consume no Runes, generate no Runic Power, and deals $s2% additional damage.
    -- https://wowhead.com/beta/spell=59052
    rime = {
        id = 59052,
        duration = 15,
        type = "Magic",
        max_stack = 1
    },
    -- Magical damage taken reduced by $w1%.
    rune_carved_plates = {
        id = 440290,
        duration = 5.0,
        max_stack = 1,
    },
    -- Talent: Strength increased by $w1%
    -- https://wowhead.com/beta/spell=374585
    rune_mastery = {
        id = 374585,
        duration = 8,
        max_stack = 1
    },
    -- Runic Power generation increased by $s1%.
    -- https://wowhead.com/beta/spell=326918
    rune_of_hysteria = {
        id = 326918,
        duration = 8,
        max_stack = 1
    },
    -- Healing for $s1% of your maximum health every $t sec.
    -- https://wowhead.com/beta/spell=326808
    rune_of_sanguination = {
        id = 326808,
        duration = 8,
        max_stack = 1
    },
    -- Absorbs $w1 magic damage.    When an enemy damages the shield, their cast speed is reduced by $w2% for $326868d.
    -- https://wowhead.com/beta/spell=326867
    rune_of_spellwarding = {
        id = 326867,
        duration = 8,
        max_stack = 1
    },
    -- Haste and Movement Speed increased by $s1%.
    -- https://wowhead.com/beta/spell=326984
    rune_of_unending_thirst = {
        id = 326984,
        duration = 10,
        max_stack = 1
    },
    -- Talent: Afflicted by Soul Reaper, if the target is below $s3% health this effect will explode dealing an additional $343295s1 Shadowfrost damage.
    -- https://wowhead.com/beta/spell=448229
    soul_reaper = {
        id = 448229,
        duration = 5,
        tick_time = 5,
        max_stack = 1
    },
    -- Silenced.
    strangulate = {
        id = 47476,
        duration = 5.0,
        max_stack = 1,
    },
    -- Damage dealt to $@auracaster reduced by $w1%.
    subduing_grasp = {
        id = 454824,
        duration = 6.0,
        max_stack = 1,
    },
    -- Damage taken from area of effect attacks reduced by an additional $w1%.
    suppression = {
        id = 454886,
        duration = 6.0,
        max_stack = 1,
    },
    -- Deals $s1 Fire damage.
    -- https://wowhead.com/beta/spell=319245
    unholy_pact = {
        id = 319245,
        duration = 15,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Strength increased by 0%
    unleashed_frenzy = {
        id = 376907,
        duration = 10, -- 20230206 Hotfix
        max_stack = 3
    },
    -- The touch of the spirit realm lingers....
    -- https://wowhead.com/beta/spell=97821
    voidtouched = {
        id = 97821,
        duration = 300,
        max_stack = 1
    },
    -- Increases damage taken from $@auracaster by $m1%.
    -- https://wowhead.com/beta/spell=327096
    war = {
        id = 327096,
        duration = 6,
        type = "Magic",
        max_stack = 3
    },
    -- Talent: Movement speed increased by $w1%.  Cannot be slowed below $s2% of normal movement speed.  Cannot attack.
    -- https://wowhead.com/beta/spell=212552
    wraith_walk = {
        id = 212552,
        duration = 4,
        max_stack = 1
    },

    -- PvP Talents
    -- Your next spell with a mana cost will be copied by the Death Knight's runeblade.
    dark_simulacrum = {
        id = 77606,
        duration = 12,
        max_stack = 1,
    },
    -- Your runeblade contains trapped magical energies, ready to be unleashed.
    dark_simulacrum_buff = {
        id = 77616,
        duration = 12,
        max_stack = 1,
    },
    dead_of_winter = {
        id = 289959,
        duration = 4,
        max_stack = 5,
    },
    deathchill = {
        id = 204085,
        duration = 4,
        max_stack = 1
    },
    delirium = {
        id = 233396,
        duration = 15,
        max_stack = 1,
    },
    shroud_of_winter = {
        id = 199719,
        duration = 3600,
        max_stack = 1,
    },

    -- Legendary
    absolute_zero = {
        id = 334693,
        duration = 3,
        max_stack = 1,
    },

    -- Azerite Powers
    cold_hearted = {
        id = 288426,
        duration = 8,
        max_stack = 1
    },
    frostwhelps_indignation = {
        id = 287338,
        duration = 6,
        max_stack = 1,
    },
} )


spec:RegisterTotem( "ghoul", 1100170 )

-- The War Within
spec:RegisterGear( "tww2", 229253, 229251, 229256, 229254, 229252 )
spec:RegisterAuras( {
    -- https://www.wowhead.com/spell=1216813
    -- Winning Streak! On a Winning Streak! Death Coil and Epidemic damage increased by 30%.  
    winning_streak = {
        id = 1217897,
        duration = 3600,
        max_stack = 6
    },
    -- https://www.wowhead.com/spell=1222698
    -- Murderous Frenzy Your Haste is increased by 12%.  
    murderous_frenzy = {
        id = 1222698,
        duration = 6,
        max_stack = 1,
    },
} )
-- Dragonflight
spec:RegisterGear( "tier29", 200405, 200407, 200408, 200409, 200410 )
spec:RegisterGear( "tier30", 202464, 202462, 202461, 202460, 202459, 217223, 217225, 217221, 217222, 217224 )
spec:RegisterAura( "wrath_of_the_frostwyrm", {
    id = 408368,
    duration = 30,
    max_stack = 10
} )
spec:RegisterAura( "lingering_chill", {
    id = 410879,
    duration = 12,
    max_stack = 1
} )

spec:RegisterGear( "tier31", 207198, 207199, 207200, 207201, 207203 )
spec:RegisterAura( "chilling_rage", {
    id = 424165,
    duration = 12,
    max_stack = 5
} )

--[[ Uncomment if enduring strength buff ever becomes referenced in APL
local TriggerEnduringStrengthBuff = setfenv( function()
    applyBuff( "enduring_strength_buff" )
end, state )
--]]

local any_dnd_set = false

local spendHook = function( amt, resource )
    -- Runic Power
    if amt > 0 and resource == "runic_power" then
        if talent.icy_talons.enabled then addStack( "icy_talons", nil, 1 ) end
        if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy") end
    end
    -- Runes
    if resource == "rune" and amt > 0 then
        if active_dot.shackle_the_unworthy > 0 then
            reduceCooldown( "shackle_the_unworthy", 4 * amt )
        end

        if talent.rune_carved_plates.enabled then
            addStack( "rune_carved_plates", nil, amt )
        end
    end
end

spec:RegisterHook( "spend", spendHook )

spec:RegisterHook( "reset_precast", function ()

    if covenant.night_fae then
        if state:IsKnown( "deaths_due" ) then
            class.abilities.any_dnd = class.abilities.deaths_due
            cooldown.any_dnd = cooldown.deaths_due
            setCooldown( "death_and_decay", cooldown.deaths_due.remains )
        elseif state:IsKnown( "defile" ) then
            class.abilities.any_dnd = class.abilities.defile
            cooldown.any_dnd = cooldown.defile
            setCooldown( "death_and_decay", cooldown.defile.remains )
        end
    else
        class.abilities.any_dnd = class.abilities.death_and_decay
        cooldown.any_dnd = cooldown.death_and_decay
    end

    if not any_dnd_set then
        class.abilityList.any_dnd = "|T136144:0|t |cff00ccff[Any]|r " .. class.abilities.death_and_decay.name
        any_dnd_set = true
    end
    --[[ Uncomment if enduring strength buff ever becomes referenced in APL
    if buff.pillar_of_frost.up and talent.enduring_strength.enabled then
        state:QueueAuraEvent( "pillar_of_frost", TriggerEnduringStrengthBuff, buff.pillar_of_frost.expires, "AURA_EXPIRATION" )
    end
    --]]

    local control_expires = action.control_undead.lastCast + 300
    if talent.control_undead.enabled and control_expires > now and pet.up then
        summonPet( "controlled_undead", control_expires - now )
    end

    -- Reset CDs on any Rune abilities that do not have an actual cooldown.
    for action in pairs( class.abilityList ) do
        local data = class.abilities[ action ]
        if data and data.cooldown == 0 and data.spendType == "runes" then
            setCooldown( action, 0 )
        end
    end

end )

-- Abilities
spec:RegisterAbilities( {
    -- Talent: Surrounds you in an Anti-Magic Shell for $d, absorbing up to $<shield> magic damage and preventing application of harmful magical effects.$?s207188[][ Damage absorbed generates Runic Power.]
    antimagic_shell = {
        id = 48707,
        cast = 0,
        cooldown = function() return 60 - ( talent.antimagic_barrier.enabled and 15 or 0 ) - ( talent.unyielding_will.enabled and -20 or 0 ) - ( pvptalent.spellwarden.enabled and 10 or 0 ) end,
        gcd = "off",

        startsCombat = false,

        toggle = function()
            if settings.ams_usage == "defensives" or settings.ams_usage == "both" then return "defensives" end
        end,

        usable = function()
            if settings.ams_usage == "damage" or settings.ams_usage == "both" then return incoming_magic_3s > 0, "settings require magic damage taken in the past 3 seconds" end
        end,

        handler = function ()
            applyBuff( "antimagic_shell" )
            if talent.unyielding_will.enabled then removeBuff( "dispellable_magic" ) end
        end,
    },

    -- Talent: Places an Anti-Magic Zone that reduces spell damage taken by party or raid members by $145629m1%. The Anti-Magic Zone lasts for $d or until it absorbs $?a374383[${$<absorb>*1.1}][$<absorb>] damage.
    antimagic_zone = {
        id = 51052,
        cast = 0,
        cooldown = function() return 120 - ( talent.assimilation.enabled and 30 or 0 ) end,
        gcd = "spell",

        talent = "antimagic_zone",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "antimagic_zone" )
        end,
    },

    -- Talent: Lifts the enemy target off the ground, crushing their throat with dark energy and stunning them for $d.
    asphyxiate = {
        id = 221562,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        talent = "asphyxiate",
        startsCombat = false,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            applyDebuff( "target", "asphyxiate" )
            interrupt()
        end,
    },

    -- Talent: Targets in a cone in front of you are blinded, causing them to wander disoriented for $d. Damage may cancel the effect.    When Blinding Sleet ends, enemies are slowed by $317898s1% for $317898d.
    blinding_sleet = {
        id = 207167,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        talent = "blinding_sleet",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyDebuff( "target", "blinding_sleet" )
            active_dot.blinding_sleet = max( active_dot.blinding_sleet, active_enemies )
        end,
    },

    -- Talent: Continuously deal ${$155166s2*$<CAP>/$AP} Frost damage every $t1 sec to enemies in a cone in front of you, until your Runic Power is exhausted. Deals reduced damage to secondary targets.    |cFFFFFFFFGenerates $303753s1 $lRune:Runes; at the start and end.|r
    breath_of_sindragosa = {
        id = 152279,
        cast = 0,
        cooldown = 120,
        gcd = "off",

        spend = 17,
        spendType = "runic_power",
        readySpend = function () return settings.bos_rp end,

        talent = "breath_of_sindragosa",
        startsCombat = true,

        toggle = "cooldowns",

        handler = function ()
            gain( 2, "runes" )
            applyBuff( "breath_of_sindragosa" )
            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end
        end,
    },

    -- Talent: Shackles the target $?a373930[and $373930s1 nearby enemy ][]with frozen chains, reducing movement speed by $s1% for $d.
    chains_of_ice = {
        id = 45524,
        cast = 0,
        cooldown = function() return 0 + ( talent.ice_prison.enabled and 12 or 0 ) end,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "chains_of_ice" )
            if talent.ice_prison.enabled then applyDebuff( "target", "ice_prison" ) end
            removeBuff( "cold_heart_item" )
            removeBuff( "cold_heart_talent" )
        end,
    },

    -- Talent: Deals $204167s4 Frost damage to the target and reduces their movement speed by $204206m2% for $204206d.    Chill Streak bounces up to $m1 times between closest targets within $204165A1 yards.
    chill_streak = {
        id = 305392,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        talent = "chill_streak",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "chilled" )
            if set_bonus.tier31_2pc > 0 then
                applyBuff( "chilling_rage", 5 ) -- TODO: Check if reliable.
            end
        end,
    },

    -- Talent: Dominates the target undead creature up to level $s1, forcing it to do your bidding for $d.
    control_undead = {
        id = 111673,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        talent = "control_undead",
        startsCombat = false,

        usable = function () return target.is_undead and target.level <= level + 1, "requires undead target up to 1 level above player" end,
        handler = function ()
            summonPet( "controlled_undead", 300 )
        end,
    },

    -- Command the target to attack you.
    dark_command = {
        id = 56222,
        cast = 0,
        cooldown = 8,
        gcd = "off",

        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "dark_command" )
        end,
    },


    dark_simulacrum = {
        id = 77606,
        cast = 0,
        cooldown = 20,
        gcd = "spell",

        startsCombat = true,
        texture = 135888,

        pvptalent = "dark_simulacrum",

        usable = function ()
            if not target.is_player then return false, "target is not a player" end
            return true
        end,
        handler = function ()
            applyDebuff( "target", "dark_simulacrum" )
        end,
    },

    -- Corrupts the targeted ground, causing ${$341340m1*11} Shadow damage over $d to targets within the area.$?!c2[; While you remain within the area, your ][]$?s223829&!c2[Necrotic Strike and ][]$?c1[Heart Strike will hit up to $188290m3 additional targets.]?s207311&!c2[Clawing Shadows will hit up to ${$55090s4-1} enemies near the target.]?!c2[Scourge Strike will hit up to ${$55090s4-1} enemies near the target.][; While you remain within the area, your Obliterate will hit up to $316916M2 additional $Ltarget:targets;.]
    death_and_decay = {
        id = 43265,
        noOverride = 324128,
        cast = 0,
        charges = function() if talent.deaths_echo.enabled then return 2 end end,
        cooldown = 30,
        recharge = function() if talent.deaths_echo.enabled then return 30 end end,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        startsCombat = true,

        handler = function ()
            applyBuff( "death_and_decay" )
            applyDebuff( "target", "death_and_decay" )
        end,
    },

    -- Fires a blast of unholy energy at the target$?a377580[ and $377580s2 additional nearby target][], causing $47632s1 Shadow damage to an enemy or healing an Undead ally for $47633s1 health.$?s390268[    Increases the duration of Dark Transformation by $390268s1 sec.][]
    death_coil = {
        id = 47541,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 30,
        spendType = "runic_power",

        startsCombat = true,

        handler = function ()
            if buff.dark_transformation.up then buff.dark_transformation.up.expires = buff.dark_transformation.expires + 1 end
            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end
        end,
    },

    -- Opens a gate which you can use to return to Ebon Hold.    Using a Death Gate while in Ebon Hold will return you back to near your departure point.
    death_gate = {
        id = 50977,
        cast = 4,
        cooldown = 60,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        startsCombat = false,

        handler = function ()
        end,
    },

    -- Harnesses the energy that surrounds and binds all matter, drawing the target toward you$?a389679[ and slowing their movement speed by $389681s1% for $389681d][]$?s137008[ and forcing the enemy to attack you][].
    death_grip = {
        id = 49576,
        cast = 0,
        charges = function() if talent.deaths_echo.enabled then return 2 end end,
        cooldown = 25,
        recharge = function() if talent.deaths_echo.enabled then return 25 end end,

        gcd = "off",

        startsCombat = false,

        handler = function ()
            applyDebuff( "target", "death_grip" )
            setDistance( 5 )
            if conduit.unending_grip.enabled then applyDebuff( "target", "unending_grip" ) end
        end,
    },

    -- Talent: Create a death pact that heals you for $s1% of your maximum health, but absorbs incoming healing equal to $s3% of your max health for $d.
    death_pact = {
        id = 48743,
        cast = 0,
        cooldown = 120,
        gcd = "off",

        talent = "death_pact",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            gain( health.max * 0.5, "health" )
            applyDebuff( "player", "death_pact" )
        end,
    },

    -- Talent: Focuses dark power into a strike$?s137006[ with both weapons, that deals a total of ${$s1+$66188s1}][ that deals $s1] Physical damage and heals you for ${$s2}.2% of all damage taken in the last $s4 sec, minimum ${$s3}.1% of maximum health.
    death_strike = {
        id = 49998,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function ()
            if buff.dark_succor.up then return 0 end
            return ( talent.improved_death_strike.enabled and 40 or 50 ) - ( buff.blood_draw.up and 10 or 0 )
        end,
        spendType = "runic_power",

        talent = "death_strike",
        startsCombat = true,

        handler = function ()
            removeBuff( "dark_succor" )
            gain( health.max * 0.10, "health" )
            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end
        end,
    },

    -- For $d, your movement speed is increased by $s1%, you cannot be slowed below $s2% of normal speed, and you are immune to forced movement effects and knockbacks.    |cFFFFFFFFPassive:|r You cannot be slowed below $124285s1% of normal speed.
    deaths_advance = {
        id = 48265,
        cast = 0,
        charges = function() if talent.deaths_echo.enabled then return 2 end end,
        cooldown = 45,
        recharge = function() if talent.deaths_echo.enabled then return 45 end end,

        gcd = "off",

        startsCombat = false,

        handler = function ()
            applyBuff( "deaths_advance" )
            if conduit.fleeting_wind.enabled then applyBuff( "fleeting_wind" ) end
        end,
    },

    -- Talent: Empower your rune weapon, gaining $s3% Haste and generating $s1 $LRune:Runes; and ${$m2/10} Runic Power instantly and every $t1 sec for $d.  $?s137006[  If you already know $@spellname47568, instead gain $392714s1 additional $Lcharge:charges; of $@spellname47568.][]
    empower_rune_weapon = {
        id = 47568,
        cast = 0,
        cooldown = function () return ( conduit.accelerated_cold.enabled and 0.9 or 1 ) * ( essence.vision_of_perfection.enabled and 0.87 or 1 ) * ( level > 55 and 105 or 120 ) end,
        gcd = "off",

        talent = "empower_rune_weapon",
        startsCombat = false,

        handler = function ()
            stat.haste = state.haste + 0.15 + ( conduit.accelerated_cold.mod * 0.01 )
            gain( 1, "runes" )
            gain( 5, "runic_power" )
            applyBuff( "empower_rune_weapon" )
        end,

        copy = "empowered_rune_weapon"
    },

    -- Talent: Chill your $?$owb==0[weapon with icy power and quickly strike the enemy, dealing $<2hDamage> Frost damage.][weapons with icy power and quickly strike the enemy with both, dealing a total of $<dualWieldDamage> Frost damage.]
    frost_strike = {
        id = 49143,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 30,
        spendType = "runic_power",
        school = function() if talent.dark_talons.enabled and buff.icy_talons.up then return "shadowfrost" end return "frost" end,

        talent = "frost_strike",
        startsCombat = true,

        cycle = function ()
            if debuff.mark_of_fyralath.up then return "mark_of_fyralath" end
            if death_knight.runeforge.razorice and debuff.razorice.stack == 5 then return "razorice" end
        end,

        handler = function ()

            if talent.obliteration.enabled and buff.pillar_of_frost.up then addStack( "killing_machine" ) end
            if talent.shattering_blade.enabled and debuff.razorice.stack == 5 then removeDebuff( "target", "razorice" ) end
            -- if debuff.razorice.stack > 5 then applyDebuff( "target", "razorice", nil, debuff.razorice.stack - 5 ) end 

            
            if death_knight.runeforge.razorice then applyDebuff( "target", "razorice", nil, min( 5, buff.razorice.stack + 1 ) ) end

            -- Legacy / PvP
            if pvptalent.bitter_chill.enabled and debuff.chains_of_ice.up then
                applyDebuff( "target", "chains_of_ice" )
            end

            if conduit.eradicating_blow.enabled then removeBuff( "eradicating_blow" ) end

        end,

        auras = {
            unleashed_frenzy = {
                id = 338501,
                duration = 6,
                max_stack = 5,
            }
        }
    },

    -- A sweeping attack that strikes all enemies in front of you for $s2 Frost damage. This attack always critically strikes and critical strikes with Frostscythe deal $s3 times normal damage. Deals reduced damage beyond $s5 targets. ; Consuming Killing Machine reduces the cooldown of Frostscythe by ${$s1/1000}.1 sec.
    frostscythe = {
        id = 207230,
        cast = 0,
        cooldown = 30,
        gcd = "spell",

        spend = 2,
        spendType = "runes",

        talent = "frostscythe",
        startsCombat = true,

        range = 7,

        handler = function ()
            removeStack( "inexorable_assault" )

            if buff.killing_machine.up and talent.bonegrinder.enabled then
                if buff.bonegrinder_crit.stack_pct == 100 then
                    removeBuff( "bonegrinder_crit" )
                    applyBuff( "bonegrinder_frost" )
                else
                    addStack( "bonegrinder_crit" )
                end
                removeBuff( "killing_machine" )
            end
        end,
    },

    -- Talent: Summons a frostwyrm who breathes on all enemies within $s1 yd in front of you, dealing $279303s1 Frost damage and slowing movement speed by $279303s2% for $279303d.
    frostwyrms_fury = {
        id = 279302,
        cast = 0,
        cooldown = function () return legendary.absolute_zero.enabled and 90 or 180 end,
        gcd = "spell",

        talent = "frostwyrms_fury",
        startsCombat = true,

        toggle = "cooldowns",

        handler = function ()
            -- if talent.apocalypse_now.enabled then do stuff end
            applyDebuff( "target", "frostwyrms_fury" )
            if set_bonus.tier30_4pc > 0 then applyDebuff( "target", "lingering_chill" ) end
            if legendary.absolute_zero.enabled then applyDebuff( "target", "absolute_zero" ) end
        end,
    },

    -- Talent: Summon glacial spikes from the ground that advance forward, each dealing ${$195975s1*$<CAP>/$AP} Frost damage and applying Razorice to enemies near their eruption point.
    glacial_advance = {
        id = 194913,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 30,
        spendType = "runic_power",

        talent = "glacial_advance",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "razorice", nil, min( 5, buff.razorice.stack + 1 ) )
            if active_enemies > 1 then active_dot.razorice = active_enemies end
            if talent.obliteration.enabled and buff.pillar_of_frost.up then addStack( "killing_machine" ) end
            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end
        end,
    },

    -- Talent: Blow the Horn of Winter, gaining $s1 $LRune:Runes; and generating ${$s2/10} Runic Power.
    horn_of_winter = {
        id = 57330,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        talent = "horn_of_winter",
        startsCombat = false,

        handler = function ()
            gain( 2, "runes" )
            gain( 25, "runic_power" )
        end,
    },

    -- Talent: Blast the target with a frigid wind, dealing ${$s1*$<CAP>/$AP} $?s204088[Frost damage and applying Frost Fever to the target.][Frost damage to that foe, and reduced damage to all other enemies within $237680A1 yards, infecting all targets with Frost Fever.]    |Tinterface\icons\spell_deathknight_frostfever.blp:24|t |cFFFFFFFFFrost Fever|r  $@spelldesc55095
    howling_blast = {
        id = 49184,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = function() return talent.bind_in_darkness.enabled and buff.rime.up and "shadowfrost" or "frost" end,

        spend = function () return buff.rime.up and 0 or 1 end,
        spendType = "runes",

        talent = "howling_blast",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "frost_fever" )
            active_dot.frost_fever = max( active_dot.frost_fever, active_enemies )

            if talent.bind_in_darkness.enabled and debuff.reapers_mark.up then applyDebuff( "target", "reapers_mark", nil, debuff.reapers_mark.stack + 2 ) end
            if talent.obliteration.enabled and buff.pillar_of_frost.up then addStack( "killing_machine" ) end

            if buff.rime.up then
                removeBuff( "rime" )
                if talent.rage_of_the_frozen_champion.enabled then gain( 6, "runic_power") end
                if talent.avalanche.enabled then applyDebuff( "target", "razorice", nil, min( 5, buff.razorice.stack + 1 ) ) end
                if legendary.rage_of_the_frozen_champion.enabled then gain( 8, "runic_power" ) end
                if set_bonus.tier30_2pc > 0 then addStack( "wrath_of_the_frostwyrm" ) end
            end

            if pvptalent.delirium.enabled then applyDebuff( "target", "delirium" ) end
        end,
    },

    -- Talent: Your blood freezes, granting immunity to Stun effects and reducing all damage you take by $s3% for $d.
    icebound_fortitude = {
        id = 48792,
        cast = 0,
        cooldown = function () return 120 - ( azerite.cold_hearted.enabled and 15 or 0 ) + ( conduit.chilled_resilience.mod * 0.001 ) end,
        gcd = "off",

        talent = "icebound_fortitude",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "icebound_fortitude" )
        end,
    },

    -- Draw upon unholy energy to become Undead for $d, increasing Leech by $s1%$?a389682[, reducing damage taken by $s8%][], and making you immune to Charm, Fear, and Sleep.
    lichborne = {
        id = 49039,
        cast = 0,
        cooldown = function() return 120 - ( talent.deaths_messenger.enabled and 30 or 0 ) end,
        gcd = "off",

        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "lichborne" )
            if conduit.hardened_bones.enabled then applyBuff( "hardened_bones" ) end
        end,
    },

    -- Talent: Smash the target's mind with cold, interrupting spellcasting and preventing any spell in that school from being cast for $d.
    mind_freeze = {
        id = 47528,
        cast = 0,
        cooldown = 15,
        gcd = "off",

        talent = "mind_freeze",
        startsCombat = true,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            if conduit.spirit_drain.enabled then gain( conduit.spirit_drain.mod * 0.1, "runic_power" ) end
            interrupt()
        end,
    },

    -- Talent: A brutal attack $?$owb==0[that deals $<2hDamage> Physical damage.][with both weapons that deals a total of $<dualWieldDamage> Physical damage.]
    obliterate = {
        id = 49020,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function()
            if talent.exterminate.enabled and buff.exterminate.up then return 1 end
            return 2
        end,
        spendType = "runes",

        talent = "obliterate",
        startsCombat = true,
        school = function() if buff.killing_machine.up then return "frost" end return "physical" end,

        cycle = function ()
            if debuff.mark_of_fyralath.up then return "mark_of_fyralath" end
            if death_knight.runeforge.razorice and debuff.razorice.stack == 5 then return "razorice" end
        end,

        handler = function ()
            if talent.inexorable_assault.enabled then removeStack( "inexorable_assault" ) end

            if buff.exterminate.up then
                removeStack( "exterminate" )
                if talent.wither_away.enabled then
                    applyDebuff( "target", "frost_fever" )
                    active_dot.frost_fever = max ( active_dot.frost_fever, active_enemies ) -- it applies in AoE around your target
                end
            end

            if buff.killing_machine.up then
                if talent.bonegrinder.enabled and buff.bonegrinder_crit.stack_pct == 100 then
                    removeBuff( "bonegrinder_crit" )
                    applyBuff( "bonegrinder_frost" )
                else
                    addStack( "bonegrinder_crit" )
                end
                removeStack( "killing_machine" )
                if talent.arctic_assault.enabled then applyDebuff( "target", "razorice", nil, min( 5, buff.razorice.stack + 1 ) ) end
            end

            -- Koltira's Favor is not predictable.
            if conduit.eradicating_blow.enabled then addStack( "eradicating_blow", nil, 1 ) end
        end,

        auras = {
            -- Conduit
            eradicating_blow = {
                id = 337936,
                duration = 10,
                max_stack = 2
            }
        }
    },

    -- Activates a freezing aura for $d that creates ice beneath your feet, allowing party or raid members within $a1 yards to walk on water.    Usable while mounted, but being attacked or damaged will cancel the effect.
    path_of_frost = {
        id = 3714,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        startsCombat = false,

        handler = function ()
            applyBuff( "path_of_frost" )
        end,
    },

    -- The power of frost increases your Strength by $s1% for $d.
    pillar_of_frost = {
        id = 51271,
        cast = 0,
        cooldown = function() return 60 - ( talent.icecap.enabled and 15 or 0 ) end,
        gcd = "off",

        talent = "pillar_of_frost",
        startsCombat = false,

        handler = function ()
            applyBuff( "pillar_of_frost" )

            -- Legacy
            if set_bonus.tier30_2pc > 0 then
                applyDebuff( "target", "frostwyrms_fury" )
                applyDebuff( "target", "lingering_chill" )
            end
            if azerite.frostwhelps_indignation.enabled then applyBuff( "frostwhelps_indignation" ) end
            virtual_rp_spent_since_pof = 0
        end,
    },

    --[[ Pours dark energy into a dead target, reuniting spirit and body to allow the target to reenter battle with $s2% health and at least $s1% mana.
    raise_ally = {
        id = 61999,
        cast = 0,
        cooldown = 600,
        gcd = "spell",

        spend = 30,
        spendType = "runic_power",

        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            -- trigger voidtouched [97821]
        end,
    }, ]]

    -- Talent: Raises a $?s58640[geist][ghoul] to fight by your side.  You can have a maximum of one $?s58640[geist][ghoul] at a time.  Lasts $46585d.
    raise_dead = {
        id = 46585,
        cast = 0,
        cooldown = function() return 120 - ( talent.deaths_messenger.enabled and 30 or 0 ) end,
        gcd = "off",

        talent = "raise_dead",
        startsCombat = true,

        usable = function () return not pet.alive, "cannot have an active pet" end,

        handler = function ()
            summonPet( "ghoul" )
        end,
    },

    -- Viciously slice into the soul of your enemy, dealing $?a137008[$s1][$s4] Shadowfrost damage and applying Reaper's Mark.; Each time you deal Shadow or Frost damage,
    reapers_mark = {
        id = 439843,
        cast = 0.0,
        cooldown = function() return 60.0 - ( 15 * talent.reapers_onslaught.rank ) end,
        gcd = "spell",

        spend = 2,
        spendType = 'runes',

        talent = "reapers_mark",
        startsCombat = true,

        handler = function()
            applyDebuff( "target", "reapers_mark" )

            if talent.grim_reaper.enabled then
                addStack( "killing_machine" )
            end

            if talent.reaper_of_souls.enabled then
                setCooldown( "soul_reaper", 0 )
                applyBuff( "reaper_of_souls" )
            end
        end,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'attributes': ['Chain from Initial Target', 'Enforce Line Of Sight To Chain Targets'], 'ap_bonus': 0.8, 'target':
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 434765, 'value': 10, 'schools': ['holy', 'nature'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'points': 200.0, 'target': TARGET_UNIT_CASTER, 'resource': runic_power, }
        -- #3: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'attributes': ['Chain from Initial Target', 'Enforce Line Of Sight To Chain Targets'], 'ap_bonus': 1.5, 'target':

        -- Affected by:
        -- swift_end[443560] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -30000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- swift_end[443560] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -1.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Talent: Drain the warmth of life from all nearby enemies within $196771A1 yards, dealing ${9*$196771s1*$<CAP>/$AP} Frost damage over $d and reducing their movement speed by $211793s1%.
    remorseless_winter = {
        id = 196770,
        cast = 0,
        cooldown = function () return pvptalent.dead_of_winter.enabled and 45 or 20 end,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        startsCombat = true,

        handler = function ()
            applyBuff( "remorseless_winter" )
            removeBuff( "cryogenic_chamber" )

            if active_enemies > 2 and legendary.biting_cold.enabled then
                applyBuff( "rime" )
            end

            if conduit.biting_cold.enabled then applyDebuff( "target", "biting_cold" ) end
            -- if pvptalent.deathchill.enabled then applyDebuff( "target", "deathchill" ) end
        end,

        auras = {
            -- Conduit
            biting_cold = {
                id = 337989,
                duration = 8,
                max_stack = 10
            }
        }
    },

    -- Talent: Sacrifice your ghoul to deal $327611s1 Shadow damage to all nearby enemies and heal for $s1% of your maximum health. Deals reduced damage beyond $327611s2 targets.
    sacrificial_pact = {
        id = 327574,
        cast = 0,
        cooldown = 120,
        gcd = "spell",

        spend = 20,
        spendType = "runic_power",

        talent = "sacrificial_pact",
        startsCombat = false,

        toggle = "defensives",

        usable = function () return pet.alive, "requires an undead pet" end,

        handler = function ()
            dismissPet( "ghoul" )
            gain( 0.25 * health.max, "health" )

            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end
        end,
    },

    -- Talent: Strike an enemy for $s1 Shadowfrost damage and afflict the enemy with Soul Reaper.     After $d, if the target is below $s3% health this effect will explode dealing an additional $343295s1 Shadowfrost damage to the target. If the enemy that yields experience or honor dies while afflicted by Soul Reaper, gain Runic Corruption.
    soul_reaper = {
        id = 343294,
        cast = 0,
        cooldown = 6,
        gcd = "spell",

        spend = function() if talent.reaper_of_souls.enabled and buff.reaper_of_souls.up then return 0 end return 1 end,
        spendType = "runes",

        talent = "soul_reaper",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "soul_reaper" )
            if talent.obliteration.enabled and buff.pillar_of_frost.up then addStack( "killing_machine" ) end
        end,
    },


    strangulate = {
        id = 47476,
        cast = 0,
        cooldown = 45,
        gcd = "off",

        spend = 0,
        spendType = "runes",

        pvptalent = "strangulate",
        startsCombat = false,
        texture = 136214,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
            applyDebuff( "target", "strangulate" )
        end,
    },

    -- Talent: Embrace the power of the Shadowlands, removing all root effects and increasing your movement speed by $s1% for $d. Taking any action cancels the effect.    While active, your movement speed cannot be reduced below $m2%.
    wraith_walk = {
        id = 212552,
        cast = 4,
        fixedCast = true,
        channeled = true,
        cooldown = 60,
        gcd = "spell",

        talent = "wraith_walk",
        startsCombat = false,

        start = function ()
            applyBuff( "wraith_walk" )
        end,
    },
} )


spec:RegisterRanges( "frost_strike", "mind_freeze", "death_coil" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    cycle = false,

    nameplates = true,
    nameplateRange = 10,
    rangeFilter = false,

    damage = true,
    damageDots = false,
    damageExpiration = 8,

    potion = "tempered_potion",

    package = "冰霜Simc",
} )

--[[ Estimation of whether or not random RP gains can happen, in an attempt to smooth out changing recommendations
spec:RegisterStateExpr( "breath_possible_gains", function ()
    -- Initialize possible gains
    local possible_gains = 0

    -- Check for weapon swing before next GCD
    if state.nextMH and state.nextMH > 0 and state.nextMH <= ( state.now + state.gcd.remains ) then
        possible_gains = possible_gains + 5
    end

    -- Calculate next Frost Fever tick dynamically
    if state.debuff.frost_fever.up then
        local tick_time = state.debuff.frost_fever.tick_time or 3 -- Default tick time if unavailable
        local last_tick = state.debuff.frost_fever.last_tick or state.debuff.frost_fever.applied
        local next_tick = last_tick + tick_time

        -- Check if Frost Fever will tick before the next GCD ends
        if next_tick <= ( state.now + state.gcd.remains ) then
            possible_gains = possible_gains + ( active_dot.frost_fever * 3 )
        end
    end

    return possible_gains
end )--]]

spec:RegisterSetting( "bos_rp", 50, {
    name = strformat( "%s 的 %s", _G.RUNIC_POWER, Hekili:GetSpellLinkWithTexture( spec.abilities.breath_of_sindragosa.id ) ),
    desc = strformat( "只有当你拥有多于此项数值的 %s 后，插件才会推荐使用|W%s|w 。", Hekili:GetSpellLinkWithTexture( spec.abilities.breath_of_sindragosa.id ), _G.RUNIC_POWER ),
    type = "range",
    min = 18,
    max = 100,
    step = 1,
    width = "full"
} )

spec:RegisterSetting( "ams_usage", "damage", {
    name = strformat( "%s 必要条件", Hekili:GetSpellLinkWithTexture( spec.abilities.antimagic_shell.id ) ),
    desc = strformat( "在默认优先级中使用|W%s|w 产生 |W%s|w 无论是否受到魔法伤害。"
        .. "你可以在这里为使用 |W%s|w 设定附加条件。\n\n"
        .. "|cFFFFD100伤害|r:\n在过去3秒内受到魔法伤害。\n\n"
        .. "|cFFFFD100防御|r:\n已激活【防御】开关。\n\n"
        .. "|cFFFFD100防御 + 伤害|r:\n需要上述两个条件。\n\n"
        .. "|cFFFFD100无|r:\n如果满足优先级内的条件，就冷却好了就用。",
        spec.abilities.antimagic_shell.name, _G.RUNIC_POWER, _G.RUNIC_POWER,
        spec.abilities.antimagic_shell.name ),
    type = "select",
    width = "full",
    values = {
        ["damage"] = "伤害",
        ["defensives"] = "防御",
        ["both"] = "防御 + 伤害",
        ["none"] = "无"
    },
    sorting = { "damage", "defensives", "both", "none" }
} )


spec:RegisterPack( "冰霜Simc", 20250225, [[Hekili:S3vBZnUns6FlU2AuK8mrJiLLNKuJDvzZLu7KlxsQXz37BwIwKsI7qrQJKYE8uU0V9RbaFbaenaOiLNj1M72kXre8bD3OrJUB0a8wNB)JBVX3lp42F1DI7SjUUxoEY36C5SlV9M8h3fC7n78w(bV1WFe7Tf(N)uAsw(Hf)x)3KN8yuINpbHSK9PlHNUjpFx2396xVomFZ(7gVmz7RZc3UpYlpmjEzQ3QCY)9YxF7n3Tpmk)DX3ENYU)I3C7nE7Z3KKE7n3eU9haKd99dynpiB5T3qA(xpX9RDV87oS4MhJxEyXdqNc)nT5rHz5zuklmEDuW8CV01b5Wp8Ruooi27UOa)B)7q3SKqB3EZkcJnplpn8dbSojnCh7r3qX4WI)GcYHfVpj3J9eOn5bPHEGWYlkioFS38vbEaojRMdYKOSXf90HfdoSWp4U9Rwno17tjPHldgNLdY2dlU6WIz0NxGr2gVCcQXRNFxKNFGagueA0l73DBoicLyTAQJ(wFimkIa6wVLBcJ57E3dlE6PcSd(i8oBdJHbfcSvYNK7IiOrgRGUAkAxnSh4Zrm6bGkDFmi4FlLeH38SQxgW9U0aVpeKY9AiJMa9Ebk9EVh8VGFECA42G5ecpRgMnjpevqFz5eCM1or8(DLKDv3SljH2ecNLHjEVeTBwfUEt(80GTEHXzhwCDTmLOBooNWe5jZ3TmF(0zujh6ZNW96m5m8F6wtsevlON82fKsOP3GstiSx4Y57sEiiL2bd5At6oMCUAu(ml0jyezjMJ9dwfUmmNPBmHQYOz4)B0pSrg6fu2BmU)TDI5pJYLKHS5B8I9h7UHX6gzAnSKZK2ssbzuIHNmW0)CKTsAe8s(vdbJBEQ1ZpCWT)ay5NKpM17RcUh0vYdx(basndVo42hKSaPuhKmVzwPAETYmXav(gQv6Wy)uV1jzE1JTefGkUopDpy8H1(LGeWp5HykUL)hJH1cJjq9qyCoPV3Nsxd6WIV(WcNzcQkInLYF42TSLC1X7tQ7BV0LEXetmPPaM3s()VzjWcZ3e4LQDb4LBiM0iDF4s5vG)baHdl(huiWngcdsRx6pER3hlhl4h8iY7ZkwKdXonB0tCEA5AU1mr56zxdlODbdxRFLdl(MQL36rkHcBljeNsRMA9COw9OAgimI00LKDaF4Lsg9OZ8k5dnIos)Z4uLaOCu9CA7DoS4L0)OGYOVWdpMUnB(Q9PpkqCvZFKBeOS7)itcWnCSpEts0JeRwbXRZ3iWgYptjfoctHwRttwiL9Pto)qmrLFmrVEvcSI(4vErW7nFz6(myLJQLB0nMujsqf5xZmPWn6ODievYvjwrE9P6Lx4gLTqEDwRezMzY(qOYBOSb3IBI2cwvhPzym8IUng(TSMyM)HzjtnkRVqRgroNFaKgOz1eo)fUz5JlRcbmJ8kw62(qLHeX4xnl9CoD5MrslH9BCe(HfFpqM3hWfk5rh(wLNj2BfDaVV42e1dUHR(NYkvMztEHvYM7hS07XYXKkcFT38DPHqaM5pwt5RJ8wg6fn3Z)EVy1gruhV)NhosHQPcdbMO4ohUDDB0M(cAVOk1dk5c5qyvoX000q1qJhj6NVOJLJWu9CjXLWmy7bpsgQ1fvsg5WuXMxiMVgvZPyw5quTyYTr8eQ6LAlFXYwQfpvDiMb2P8jjcp3c8()ZixpQH35bXbBddkC1Pm7bQKOncZ20SrfrDGqCDEE7OsZlgtaHqyPskdIrKklFUIkFAMSIa)cRE1udIaepvcm23yUxAK4atdbFPlrKxo1IzP2WsQxAujf02ffnM0hL9cUhTvZqMQnRf4PbTcaNsd01IccS6YiXV6OnvMOlfHPGcM13LgSmz7DEktWrc8Uzb5HRQHOuys)R5SDwbe6XFiiFUZ8ShJxk4)p7jJZDgVXlB((mMhBL6XfQHYUJifHGTj5HayD)v5wFD(MEHgN9RBfmlzsLn6w03vqRSXcuHEYSIagreYr7HzWrzGyEY4zf)WT34OYT7woC5IpC5(mpC5(NJHlLKP1dxYgplgUupyrFnPPp1PxTH2U4Wfvu8L0dh145HzJHy1bBubPj7ZMNN6fNTnKSAKAllSa9uevulKIU6LIYk9cu8xcpuwk62sPOBTuuEbUwA6WzEP(pI1E9ew9KeUxHqBCWwoZzMQqYAj56QNCnjhvqUUAjx5vPBj5Y5cKs)yKMvi6cL0GnIwE9KaIg1znM6w)8rsrcGGVrR5Vwjg1pFuvoYhpJMLCDtdoxm0PA8YO1tXOg5BxK8cJUpIU9t8AS0FBeLqDMmPm)6JObAn0cVluXGowXGkSwIWGowXGokyqxuguud3Psv2vvYbSut23BR3AWZ1oOqR6586Cn4mswyLebAzn5mo0IfsO238IGig2aS8U9F6tqie3L8XoVk3wV49ErkJEVfKNRDKNjZEnTIYrEiHkOJ8kIyfC2ILtGmiWMTIrSw6)wyoPbKmTx(CEck9H6fYAeITzcbcIIdSc3)s3bDxru7hHJAm6oLO0doscCiXp1pr2RMnEB3fYVThC8PQsbsqme7ppmEUVx6hIdYYujlYizHF5CUKHRkkzchKgGYdnLf5BGMVbK)KK0UYBFuoveqgwYgFxsg0gPDj47)9F5WI)vbOhw8B0F(7oS4FK8WHfB3VCZHfVNeR7Hf)oly38KdlirKdXTsY5g8olHOsP5i8VtPJdlswrQkUsNYvgzULCwarNPM7sdxVMOKxXBVzILSZ)mJmiXkypEq3hhuclJ18dYPB9c8YpSjaS)dujTwdbZxEeUnIiycIt2VEd7nGfaoS4h3wKlG3tZtW)BG3UKyLPu4i4CoIKJ3N2rwF3jMXv5nLfmonD9mEUiXpC88fwYZmTxV4hz0fWcWC7dlOn)biMuI50h51LbnzqdNgTkt)TOStzIn(TsB8HfVdEqiGzCc8hEhwSEVhycopi4vhw8V3Nv8JjErJPccvlgBHGOCCIyIazQ9L2Q()9Bt2hNZ4mXPZe2NOFao8OzomtuDhajd4QH)3duhlJuEjbQYfvjhYVlmIKCYpY2DsIZw)sO4EwGKAm(SvVmkW7E26sKKiQyhKuSnykYcthZijT76Cc2fsydAAEvLK43slniKeaJL)xD7veAnTPQdWlCclt5EllZ16IkAIsvmfXE2t58Ud7ELD7Tyh1dv3jutqQMkw3XkCTwr2V)tDnjIxaR4mKM06NxAJ2w7ETUSq4kyEjRMLMPBxzDC62T665iKFLBsP0UwRTm(RueQDlUkrh6wjG(mKArY2sz6UK4G1Gjz)GuoagPK)4jvSvPPQK12YTkeJZpS4YdCfiOoRWOws7CHfpDc3KyQSjG5JhZPShOE4vvwsYBewdbdlaTYIu6C1vUyZjRy1KsRQMJgKyJQi2McjPUBKzo)hfglGjwjPzbrqmFCCI29(t23KQ6TqAPgqbyxKxCC5ZkuRkQFU1PG7D(wu60cvxO2PgcgM5zxHXnWd75(X(Qs5K1sTwC0hKv2Uu)UUIBV3oVsYRD1wHfEb7XVJmANUFhNp9BjPbyvAqWNcuzv2C2jKDXJm4j1TLU6NjMBHkDfvMCBFhFnTJR7apF)SIvruzXXChOwTwLBTxZw7RUVPPBLTQRcReM7A0jvck8CCyrQwReUbX(0KC5NPYwHzcGx1tX0CP0cjKyjpacWN1nbi7DlmfG82EzzeDwPI5wVNP1mOykPq2sen8xLLjiUSSn0GxcI)0JYX4qjNgnst1xrKdQFPAEzQ8okhU8rW4EusCMY(N7X20ZCnVUphsBdlB(Sf4kdFBBszkttwTkiotSqQu8gKeg2GC5s3F1q0U6biKm9RFgqB8oN5DKQMv7GuTFo6kYaDUPn0SNAkFDHtqWK6TfthwJKBMrIwNdq2btDRuHLGaxPjq9cqbTJYGLahmdw(bvlOYTBq1ljQVWk4LZMQ8EP1O(PKuYbYMKZjVD7st8wUPrghPzNJeErDwLHFkJMVPqymKkiwMqEEczR2QJomFJxEX7xFWVH)Ede3biqH5Pc5SUkPMJpS4haYHi0ja4md6GW4cKGXM5S5pZjNRBskUJIgZlKvfQk6CUInYYSCRygQvdfk9WXY95JLJ1YShqK768YAkFnjxf(GjUzEWh3fSmNiGjvn3erzXuEZrdBfAVSSaAFnFSe0)tgwmcTQzNZ97181llRO4rLnYzYeQm9iRMUIXkleQcbHu4oUHCGOqcorscAaHJtQjlYCNOqG1EpBRuLQi6Mz93QO3B5AzgKrxxwsyTw9wIpevcQ1repQX5DzplTPw5mRuDVuOz8eotK18yhnTkasRStj7swFnwAzNxKqdfjYP2YMPX6JCiUkLS5iBTBl8tdDVagi3e17QGkNkUOAOX6UQrRSV3CLCtHVMXZr2HyJwro2upvSCwvgnDPkkca(Auavy1NLsJCKT7144SExB5JiPy0QiqOUE0HRWRCwxDsqHqfJRURwgOnjP4pfRxRIAqvMg0UvkxvDWDoZ6ZauTsR2JDXz6IZwQbibAlAPt7TSrTk0QhwXvci4zleZdIlMueHpNWyvyAw(CVTzZjfNbv(ZmP3E7Sw1qZEWWh3GxmqmERbUbcJhCSMRy74tTOqJOch5GDl9fhPwOi5kccxyoO6r3TLsOrFbfrdPBw5LImoxQHuScCBQ9trTnZJrwUw4Bl3FbAC9jzmYq1k8sHW9hmcKPHIDK)k4cqoNfLKZ)FlKXB(QXKCUoz6LmxVujumvCHLvFxPiFO5AquFknARWhVRgv3B6YBHcwsO8uD5myYlavvsWCpSsPOQVusT17Gn7CMjFmYlh7pS4pObPZ(plRmgA4YBanOaIzg4FaZzPoftxC7vLvBdPYr2tRdjQLjWWFm8378ctj)gdQgvFdT6zCXooKfeIlM6LRDQxUgRDvRuVC(tK6LRDQxYvuUG6LZrPEX8buW8aTMEDX29CCBkY22RvcoPgyoZyAmBZy7zMuwg0CZNv4uk3MoxPKAuT4sPLoA22YRRg014g98AycPD8wljbAiTE2a2sDY3VtB8IJdOdeejvf9L10IvvzUwq20vbDXkFSAZssQ52OXEkSz9xASwOXEIS1HAb3knwIAgwL7HByuDLIDug74DGf5OHWF607Qva(bNHgDuSVvClAKSYAznpyCUu566AOAEvp9o)Bo8JRRsgROdfOBcLz3(DMjxudGDXK4Ohj)tYoVexu0VfKm4axAY9H(0keNjzEvzliUfs3(t2RvXphw8BWpfcahheYEUz0UlHwrY84qNCGDPcuBZv)KHwzh12jdUkNm0AdmytguVeXx6tguq1ANm48fXKbfoQIvwAKxKEni2OkJWephF2bg0W8ydTN3AJuZObzRqHnoAUDIJrwj5RfQerpwbDlve7cwW(FaeY9i7RBX554Nivrjyx5DlFKC9Atk1IIGr)NLLvcPTK6krUs9WUzKgOBl777jMJAIkE97v0GhOgAN79G3JkFUHDKXK)w0HtnEywYtQkptIvo6GlEApBPe0sXNjdedm61SjHNr3z)p4YvXOnasD3JL92DjS)T091lFWz41IQPrnDlQnalQIQPkKCkdEfeeWoZr3bgxPNVoHvXsPfdFgmpi9dc2ANzJKXH)ejCxc9sImKwNkBVJY7AV4WnX(Q4p993u8ISTcSYd(RnIqd7WcVrsevlguwVGKDEyOUQalJAv(WrxVzv8xyTPnkpCdBqwZJRHdxbp3eo64b(TF2jwYxtzG99Oi6Ep6rR)SP4NiftkK2A6xN5gt2A4KPkS2rzad3hP6YgYWMLDWffQDOBGnYX0DaxryPSTcNM5rMzlBUVJnk3TWSYzgwyINXMz)myO1VXG)hwUKNfYQoDBjBRSu9u0wOalXHukh)8S0nYsAys)Epk6WtfG1LZFPrp6qzJA8wiBL6wMLPhDD5wzPtUO9G5CIhu1tz4(VymaHbhx(xtLUbrLX4BMy3AR0icgGmatawD9KnQA9uwkcEB1kNPC37ICJNQ4)gUmseLy7wnVxysHBWMQXcqs4Cp6hwOAnTuyuwLkCGnV43y55zqTtcyMNmBN7ADNF4lWDaREEsAiPOCsyN)qWK2sVOh3LXQhKY19R(15XjpyubUPJdgNhOFbAtXT1cJGuKR)YlqLsA)(YyweihLdlR3d6JyjnzSX2LWehQQQQiJsUP6fC28L6OfcoHuJyINmP0K6f6pp4Ekj47Nno4JKVcBm7gspQo4GMIi9caB(iAOrayAHKokgykqvzkBC(dj0)WSd7du8XBXSTOoQnQxuB4AKOjxWzp3lee(G)a(Qwg4cTFoIqtp1aDsqjwjB5JGXvANH7WfMNlCDKPpdbYNeyZ5vq67eXGdkVE55okVxy(6kgHkBmBV0mj2npGUfhhGmYam6YCP5oWct7lcaVOIxfSFQSpKxFLZdhf8XSsxcO9N2BDgeBEQp30xy2zVEuyBWGaVZDY96Yne)oY4QjyZwl(Cjt1MeSVqLPowktVwpKc3jk21WZTIib6GjQjBi6lkljh()3Z(48mTFscF(hNRxyK4NDucWJfj6JNfnpe30O9iSONCM9zs0BrEglz0ItIkAg9VlkjXN5fGyw9FpTC9pS47lpeO0Eg3Ju0EUQNGfidsz3Gkn9sygUREgrU46Ny3EYHZJGLfFayXWkImkNn)FV3F92a2DzXmChymch5OoaJ3ErZjhJvLmUfx5jyOVkmnGoaQeyCpjm5xSHzBfPjs(eWWnu7TMgWBA4YpW0B0UqRjYXWmFeYbNunSZc6DyP57mshJJVAyPzHKQVnAsHMOZ7yo7k6J9VY(0W(7C9upKHEOEeA1XE3zykZdxH8PyeMPXFeYzFGWRoH(vFEsHHNlnCn1OTiDkEiPyeYMhfSIDKGMqUeyarvUGz2uXt1UajXWHso4g27YCedjU0oQKVNP0k(sbkxmtPyr7qf5wTK0r4Rmi3rSBPN22pGWG7RgFXLp09WQvKxT4tv)KV52BEWlLe5hehn90yeUDxsAEX1x6xjaYxrUSd()2ZoHfz0RobV95jfhpdWNoiYZSXh(5FHEbm48Dhw8djXqpsF8xvoRq6JVgak5Uua7XLAdqZg68XrMqx(aYjHo25Ntg9PFoqV(oGwc3Mxo0Yi(Mtk9(TNu0DUqn8QMwl1f6wJOr3m7e3nh(zfZFQTl3UjpUQjwERvsePktOYYaeuLYBMeWspTLk1DKIr0n6iQiQchnQkh6lUN3A34(LignlD1q2APSliYCkgEcUMidQs)wS0KJ82SkHn2D4LLOxFDz1WeP8TYLLi28k1s2mg6DULL9a3vWLe0kUCUKX8BoXgT02ls(Dj1bijQ3sSp65AFgq9ukhoLyROUtKWxtPyk3hote7KKDfcZm2TC1xnCOPSqvDb38sNrVOieNrVy4qsVd)050)QSgbE5SrJgDUZKjLKC7W)1L4)AJ4xZIogzrUsOV5vsagBX3RUtK5ktqQKtucznJCACFad2E2AKdIReptDtxfsptupINrsx1oYlMP(I4PLGFQ84)pf0(md2i4Mz(wfLjf52(5C3ZlMtpiv4kd6AUx(fiVCjD3x9ZRX6NAwgXjsPSKjjqrYHwd5zF7XlkGD3LxmO7lvlehi7BlhptDZZJRRonsorXXpJ7WYwbFAZdsRz8EEjBXJ4CdkVXJTfvUA6G6RKcKv0Ktj6O42WK6zQg4UEYaSd74GZu8e25UDWWHnFyXXGCGUSj)0tNzXW8tpHb(Ob62)LRvqWLBM(lChny4ziAap9KgrScQP8CfFLZOYXO)Zw6(6tL0Ts92Dc(0guluU4wOAI3jXcfkz7O3cvJhBlQgTHOSjNs0rXvJfkx9ZHCrNd5QBoKZxGZHCXSq5GnhQPiw3CixfwO(prP7Rpvs3A17gBMw90MJXhQM4DASqHr2DYhknOA0gIzFO6z0RXTrQzQX9OwK55jvpOKD3wKbhvJczlwKPFrVg3gjoQxuNXr1i1AH6C)IUzCpwlsppjL75IS7LnnWTrIY6L5E4OAuJWI5E9l6MX9ynF(8utdpxKD)OV1yx370y3PfDZ4ECw4SLQpo0RXfjtL9T(hs30XTqbdwUBDijuvCFezlODLwFEYMkw30pZmra)ejAorWEsffNuW719P390uAeUi5fVJWofjzw9WU1mfRau7bOpn7VogS9STKPppoNG1nDviDk9rzAFxzG6HTVL4ppR6p90yxhd2EM6VaZIJW5Tx2SGYdJVTq33CaMHTEGdqGUxMCHbEh1BoT0mIj5(qwJaD)q3izoOpO7ttDtHb7jvC0pGJ5wN8fiGe8OxWa22bYh9wj8XozUnGhXJX(cEephprW3CV5OB8sZdT9aXJz11odeoiExpBWWZqo(zdQlfvKt2(vodQAc2E(Gds5w)81MBY5gjL51hY(x8cNrK)VbdL49zp9KbXUS0IF75(lbCLaUxLVv64ZqCSq6kbqAgeYfgG8eimW7P5NZonElo70eM7mmJvjCNJlbXqI85C2wi7zVcX6MEPknXa)ORstua7EW5x23UzQ80DTlnyzY278A557cFN2jBQc9MneSiwrEI75c3Jf44tPdWppBLVMcqOY47EPHofzVNRnNu4)lPZXiDA4zgI69GH6vrhytL4aGOHgFXlqDEOSjxnzu1I267OkOu2S6Uuhbb92idZ6Foelp)sfJcLkTj8kCrRPZgpwq3)ugd(Zt2C1u4pgN9QUnNu4)lPZXiDWnD6EsTrOGg)8A6ubbP005ZVy55xQyuOuPnHxwsDOsF0d6r6kREqPzlOr20erwUn9m8DGW36Lbbz8Oo6UUj9l4DGQHNLbQuqasAPCXM1)Dsh4GnerJoAVSb9jWDGEjxeu6i3IN3JW2EInmBmYN8EfDH2gl0H41ZMwdv6lbw9GEKooQhu9wsu3MEg(oq4y2su2K(f8oq16SHG2S(Vt6ahO2EIIg0Na3b6vPfLMpVhHT9eBlmuzOXcDiE1MUlnz5y6TA7UmD5nbRD9C3qKwZBp8TqS1g77nkqLQXj74h821ZDJwXgo8TqS1gTTgBHIWKMJCzrmq7uqb4u6Xfq8jgEla221B1UCE3HhZYhoYHr3hPsRJ9ZwbIJAqCAjiMhBSil19n8waS5Xglc5S7W32H(EzuRl6pnlbd0JCl6r4DiIvmY5WvTPOr4h(2bd1N7gnN(2rNp0z8SxImBeEQI3n7X4LK37LcDlrW91sJgJEHZKjJgn66H6ZlVMlWazc0Xib6OKaDKiqxbcSur4l8rYx)5BK81wns2KaF2gjliWAdFnQGIIxOvt9XaPvgHWVdFaFK8IwhKVXlD(U9F6trGWi5JQGfRH23r265wBC4v(wtKxiBhRPPHTONSL3AJxPYxxIv1uINWNU4Q(q5tr3ZBSTwpmN8UKYUrcyUNGckszGM6TM8zMG(PmCvAYNciFsk82UJ3xcJTSTDAhUUVrVJbdJ9NhgpNCXYghKjxYwYpUj80cDzvsuuYdHKpgyEGPjyr8hcsHFhSe5ZwqpN0mwnVDyb5kNNCt8Nx2U4eAvYSpwO1((Kg77L7DNxwW3D4NPFnHiX6JuHnEjKuw0LARHX19uDSHSFL90D)ME072nI4PU(Zuo6XE12naEAkS8phZ5rQ5XIVylRtjtoK6fHN1sCpAjKYHoj0AXaiYXCQNMJGGEF9bLaPmy7jIhd(EP8mnq7DZ8b2T(B)q5NgdFh(53rvPjq(gXLQiAR3Et2UGL3(RUZCU9MDPjRcJcU9M)2F7WIF8EVO9GYnSONh0Nm3IYQ)aR9kyjSW7d9jaF3JhwW2SFiK3vWShcTanO4W6w(nXKDCDHFNm5IzwK1EoZUC9W4dlEh8WWCYpsOgaInKfHJtiZfjv2Upf8G89Pap5q6XiYhE5YFzY4zapY45SXvfQ6lVQk4Jxr(cXCLyueVkz3vzb5HREfTtVYH9VNtW(kaYxTmj2pKG5v1EnZhGcwrwOT4kQJo80uLEwxmfVqdDqkMI2iqDpwbQBFkqpn1Ut7fOivNsBeOf5yOqqkQ(vcoVMeVuS(gstrg3u(WIDOu5ZUVE))u(8nK3v5tiE6oI)j4bA1grJRsrJlIOXfr0Oip0kFydrJ6Tgv5ZLenUOIgDXG2grtDMvAmvCg)CX6HeL7oKsdF9df62skez)RuAjPFOWY7lqz6ZLN8C4iGUKGq08dEmPhSB55vXecRZqOuccrZ0B3s0RcRzwNIqPmekMQxBup892sck6eOLGF)blsTxFLiZydvx3xSld0gRNOotBNcJ2kjaSu91FMgtFqC5IcF1ftjx96)1zuZgWl8hO47hqPHS3yZRML7rozxPKpqbkiqnrGxrS1znJJ(fZ31HFg8W)7)9F5WI)vrVFyXVr)UadbH8psE4WIT7xcoN)EYxhHdl(DMx8Kap2btubN3jF1qH3HC)Prtp2FNZB(BQ8bYggUwwLVjnidc93)vfFWWiZGiWNn(UKmOfKjvqtcY1s()tAY5i3dwq4aKH5IoGCHbbApRxxYk(bGUYwAWxpSjiMe2aexC6sAipeUlIiicIt2VEd7n2tcU4hldQ590GA(FPb1ydNYtm7kjLkE9nt6g7T7lhMJtsxXEtTJ7y6EWY6mkiRiNP0M)a4Oojs0h51ePjQ535I98NioXxkG(n(C(aHtcpimRiVSquTR37bwnYdcGih)37Zk(XeViRIAKMDig3sOfqrTIBVWoU973MSpoNr3It1iasgN9P3lcOZVOcI7iPIIcC1W47bZh2WcLJyeRnkNbEjVwjLxEh5euNUFxEf(aQBj2xwLge8PGIMvYTz8nt2u38DrEXKp5Qfg5ep53x5G)UE((zfhFELV71AExQt)ugV4vRwOLJIE6PghdDnCsaSCoz9b)sZ1dvJz1VYr)JWXTXQauNCi)k9MbGRpKw0OYWF1XpUkuzXJo8aLFYOF7mDe1ovlmj)5mCWqkUn(khwCJe82IphpNp9PNu3qgHmDe3YALFydlWM7lDigQCnHH3WPVCO75LjpRXh0WrCpL7BsiVVGnKhLUUY(2Txo(RlZefeNYSgSF3i0SDqFlvxrefTNpD16VK1DMuFlUZ)wJQ)zLDUQBFp(BeES8ZO49umbdJbhrTO8tGdz7J8igj92br)5TCtJL6OlwqUpxRDrb(PmQbss840pI0lPjVhgXRt1iPzE5fVFwiPFiId4V3KSpIKW)CpbhGQwnfwv5haYHyRMaGZSmUT6t6ZTnXFPiU1wu4vCZV7DYrsOpPtfdW8rBGMORY2whmIvyFTjaX5p2kMflwsV3DL5U29Pn0(pDI8cKPCCm)3oSPZOFCWERRX7tLkA4TotW52cHOE2LliVU9zuuiNQQ5WXWQ6HldZHP)d02VAzRs(HqnLlcqLBvq20XObQSqzWgPwk86jJAXOKeLXpIyfFwkafxYtDsH1lyREQcLJNEs4wb6TtNm4mRMrwVgzBKVwb91tbbT0KetY9JtCV2Ro5jsRHkTjxde)5QnCSXfh0fGGbfKZSffxnR9xi68FS2h2(6Rri2x9qCI5)V9UA7TXXnc)BjOa(IwK1Xwjo7Uf2gyXIEylqlUI2TOF7CuSLtuTIvGKZLlab53ENHuKIKAgsjBFydwuCalYzBroCEJpZluC9tRTqMDQpiakOsahQg)LOO76xaBaScYp35XroSslRyB6TLIAYbWj3UrTFUXN3azH5BCh92V)Og)YlKqwNnbqHiFTuTzlAgnezTaeGBt1)YglcNAY2aGrJx24JSam3yR5Q4ejI8baQ81mmK6)rTYmeLNuEjcD)1RNcrTbHzTE2pD3UDpu9Np)8NE6PHpvarPNSAiGn58QhsZZNbU0VA05cvH3NTD9JvWy8tZRdp8Vw)btppzogGFwEpg5jJJ)W4ZL6fVVy97L1vEERGOLdogV8JpabilB)jmeC8V66KnEsC8h(05sDyC2mQ17C6OALZlgxpIaRbIw26UpT9BnMGnOvxh69EfLOBjmPgeGzuOVOct)oqVr4deSSZ2(BfBaT(Fh0W2ckQOgVABjeiTsJ4SS1m25EGLhrgXG)ID6lIf)3iudid0W0nwYwWdyYTGrgeayEoUMOqTC5Obwg4RZkHGRtUVAbMgYPOx0q755Jm9J3qVPNdXQlyHmiLVjtpTfgymFdWc)(ZW)ac7yb4DB2yfIFYmyJSGGBZEvdjBKaIbuv(qw3GwFrSkBbhbKctVcCnEtrv1axumOwoWA(pI0qIHqb2spKdbTvhL03kvSaXFRZIpyMuT51RVfC)VDOLPcWuxvSGH3TaFmhEnWoznsSj3XtSLJxlAlSAgMkTIcYgnxtXG6G)jRUnWeB8EMkvLyI5KTkQqvT2pZdjYEitouT8inKu1PkVyNQ6iILJrfbFBEvvE8Ua44UaqDlsAZNRvyRht)xqLbz4Xwm843O38Ehpgo39z4yggE7Bng)33EclSVCxY2TPIKCJuNzlM5A9OR2u9Sq7D12ePL9)XZEH)v1QFXZj(KTMbznNa6Vo18G2JxP5vg(RB)Bsw9Ce52gr)ryzr8TngZZNz55DaU3rqbBmVG9WTl)XxWESSGj914xW(NKDZzX28NX)nvIUxuTQ6Ha2ASSa7OuzlNkG8Q(f4gUIK1BhuWWxV(xkLrgSnnt(9HhTBkeq0TgNqkEYnD3h3fn4Xy6vKzJfPPO32EOK9uA3AhIcl81UQPI8BeXAFy1FsgKbQ5XJ5me(25XJ4lhbnwte8wqhiKYXo4DiSCm2uo2Dtnl5y8Bd5yCq544VtYr8xSaWoSYlO((heez)xRiOqRrFMPbF4WzYwYczyuGJ1)o8)Slbl7uD3p8ZP)geej4XDj4S9BIAywh9X)wvNv83IfA1KtFxXt515ZQANWqzvbeNnoMlwJd5WDzl3G5ZVDT7oev1OMNMmJegxQDCP62)wJ1vCLyRDjDTb(cCHFpeqz2wS66rr1nYWxOaD(qb(xTXI8)l7R4HosL9LuLp2Y3qYnf3NTvSiwKND)ncaHeSfwODuqMa1jmTcycgsLx1b3aw33I9tNHXDYdPLvGgt5gTL(KU4oJIKPekKKM5abdFrzfecvvv9fBaou6Ns1HJClrY0BRmujKgdcwAwWnv4Tdm7rdjGx3ZbTmF(Jhj1lAVkjQsG91PHD1lbl68Crbms2yXGom2H5uqONZQigmjRuBNrzhmQduG3atmlJ80lbrhzPRi7XWb2f8LP5)6cpQ3zoU2uM2LKKUMewvD6hy3sGhRI1oa2F3EjUP0e7GSMFQ78Se6SlzTHHEaAACUivXbDAAlrSYC(orzZ8XH4I0Y8(UanNeQhQ9w3hRG4LTqILX08poYV3taHYacUC7gcquUvat(uW7OyISzNMBkD2YNxMdMI4fZZUQA4jOUfIGc)mDzNxLbILlI0TcOXGSO(Zq6EaFDMczTn3UFcfF3tpxEF1I1pw(mszn6mLzy5GlKT4EZ9WMQO)23mBb2BRNoz9HoRd2LelRtOPABiqZg3BOF0OL58B1WL0TiaDPAogRgrSa9B5agljzRwabyGd(Qvvdt)D88jpW9JruiTxl7hvtggr)O7bNOdgD4UNke)bpIHbn)447cgYxVKMw(asYGvi45DvNRbwlgy1YNbRVgVITdpIfqTDDDFEXkzG607jmG9ctRXUUP9Ph4h8TcxzSWZ48ygk5aUJ24eSK8iGgxUtRr16goKb(rJdZ(C1PfONLooR(d4gQlChv(d1Y9T5fYx)Vr((oZNvoaDU9(cYCB8ee1U6(h86xKuO)PO9XE96pR7QCt8M5ffRKB)0YdS2VMArip1awpo4zlTeZY2E94qaSjyJ3(yEvAhFKCKhvT4)(4QBVh4dD8PWgNdyuj5lWUAFVO11zLPcU1E903KCRaNyz2Ynv9oXp1bW421JENaYyty1FzMHG9vP(0R4r)(DxiufTYZbifmpTbQtNI6wz0Gd18Hk7V27W7TzPWkwS)THPIn60fMnhrPahAjAW4Za2ID0q2N(cZo29m0cF5odurSfrP(lWeFxTipD9U5JcojM6hCkMSyk9roHL3jfPwlUwUWcpeWmERoYrpdgE(80jjhpKmFf1O0JVHwgov3HcjCbbAa4yzl8azxtOZSGop9elm0IFMX1oQqdC(SlF5Lo8Z(yuTv2(opFSttZyRxWl(zj9Y9cZIF8igCQMopWxbc1ZLtatnBU68fYSuefPpUE92T2HXgy8PSg0GXZaF5JvjR0buqWUcbAy(yfaFsEkZIUMBq8ixCylxoFOURxEkE)5egz1iaP3RnCz5Ux2FU7NcNZPPxWYCUms74s1V2Fw4zda2vStSmA4aspXWQxVktPsTgPRe5wIXedg(c4BHmm2wodbuXozO7HL7wCXKPKF(O5tSYo5KretxRc72uFCZdnmRJxozkVca1P(W6Ken)0w5r19uO)ELtQs(36fV7k0NexDQjzfLBXXQPIzYTDgq1Y5xmsbqIReOK1mPjXW2h3NOJJALZ8QP2ykrF76NzbVUMufDgcXtBgJNB4DQEbG8SURunSEzEsYJfoRiZNjjrsXdBPE35LNmyPDfLL1b(ykpVQtMscru9zYx7xX8fpHpVlMl49vzO2ZQ4SIiQSSudPfaR3ze(U7etVQi9NnLPG9Mq5i8UWo1orbC4tE4KkACwdzjlP3ezMa6SW4GPX9MCyIgJ9SsQcSY5DcRKYB9MI1dHTxQSSJ2rFFrZeb7xPNG69eicZgo8wyUQ5uLNJsbL58oofZKvWiTPdsF6K2dQDUfE5fJtMU6f(HScUtJJALvVi(LDi9wDqFetxp1PJm6EtIdVTNt)PBCTUNXt1HgUV(p17kSNmNVFRNoOT6N4oQ(A9ovEKjKi9UG9birdKoDS9bGFu3vc48FOHj85I)I68b)61)TmJt39WKIuBVREaaWL)6GBYiNKdI9t)geYZopNsRl6Q1o9Yix6mS)6GHbqnqSwRDweidSCK7tEWgr9CdHJQCLNn0MB2JiQINeQtH1eL)ZHR9S2u2SXT5dEr5BqzAZY)vgMbuSZPrUffUDRCK6YQZ0zgPf8Q(ASegoMlL0v1v80kqe3q3xICfaGD7zaurTIHsbO5nvze)8YhChvWf7b7at6oLLqQNH9pwCQHy9D1Rrduk3xdknAyeMctJTsADqbcT3ZdBrCYPMjx33lDJUj5zKWwnLZrI2pqsQhm(W731EiEZ6R2LuB712BB9rNqSFDh8F)6)7p]] )