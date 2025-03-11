-- Warrior/ReflectableSpells.lua (for The War Within)

if UnitClassBase( "player" ) ~= "WARRIOR" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class = Hekili.Class

-- reflectableFilters[ instanceID ][ npcID ][ spellID ] = ...
local reflectableFilters = {
    -- Khaz Algar Surface
    [ 2552 ] = {
        [ 225977 ] = {
            desc = "Dornogal - Dungeoneer's Training Dummy",
            [ 167385 ] = "Uber Strike", -- testing code
        },
    },

    -- Grim Batol
    [ 670 ] = {
        [ 40166 ] = {
            desc = "Grim Batol - Molten Giant",
            [ 451971 ] = "Lava Fist",
        },
        [ 40167 ] = {
            desc = "Grim Batol - Twilight Beguiler",
            [ 76369 ] = "Shadowflame Bolt",
        },
        [ 40319 ] = {
            desc = "Grim Batol - Drahga Shadowburner",
            [ 447966 ] = "Shadowflame Bolt",
        },
        [ 224240 ] = {
            desc = "Grim Batol - Twilight Flamerender",
            [ 451241 ] = "Shadowflame Slash",
        },
        [ 224271 ] = {
            desc = "Grim Batol - Twilight Warlock",
            [ 76369 ] = "Shadowflame Bolt",
        },
    },

    -- The MOTHERLODE!!
    [ 1594 ] = {
        [ 130661 ] = {
            desc = "The MOTHERLODE!! - Venture Co. Earthshaper",
            [ 263202 ] = "Rock Lance",
            [ 271579 ] = "Rock Lance",
        },
        [ 136139 ] = {
            desc = "The MOTHERLODE!! - Mechanized Peacekeeper",
            [ 263628 ] = "Charged Shield",
        },
        [ 136934 ] = {
            desc = "The MOTHERLODE!! - Weapons Tester",
            [ 268846 ] = "Echo Blade",
        },
        [ 136470 ] = {
            desc = "The MOTHERLODE!! - Refreshment Vendor",
            [ 280604 ] = "Iced Spritzer",
        },
    },

    -- Siege of Boralus
    [ 1822 ] = {
        [ 129367 ] = {
            desc = "Siege of Boralus - Bilge Rat Tempest",
            [ 272581 ] = "Water Bolt",
        },
        [ 129370 ] = {
            desc = "Siege of Boralus - Irontide Waveshaper",
            [ 257063 ] = "Brackish Bolt",
        },
        [ 135258 ] = {
            desc = "Siege of Boralus - Irontide Curseblade",
            [ 257168 ] = "Cursed Slash",
        },
        [ 138247 ] = {
            desc = "Siege of Boralus - Irontide Curseblade",
            [ 257168 ] = "Cursed Slash",
        },
        [ 144071 ] = {
            desc = "Siege of Boralus - Irontide Waveshaper",
            [ 257063 ] = "Brackish Bolt",
        },
    },

    -- Operation: Mechagon
    [ 2097 ] = {
        [ 144294 ] = {
            desc = "Operation: Mechagon - Mechagon Tinkerer",
            [ 293827 ] = "Giga-Wallop",
        },
        [ 144298 ] = {
            desc = "Operation: Mechagon - Defense Bot Mk III",
            [ 294195 ] = "Arcing Zap",
        },
        [ 150396 ] = {
            desc = "Operation: Mechagon - Aerial Unit R-21/X",
            [ 291878 ] = "Pulse Blast",
        },
        [ 151649 ] = {
            desc = "Operation: Mechagon - Defense Bot Mk I",
            [ 294195 ] = "Arcing Zap",
        },
        [ 152033 ] = {
            desc = "Operation: Mechagon - Inconspicuous Plant",
            [ 294855 ] = "Blossom Blast",
        },
    },

    -- The Necrotic Wake
    [ 2286 ] = {
        [ 162693 ] = {
            desc = "The Necrotic Wake - Nalthor the Rimebinder",
            [ 323730 ] = "Frozen Binds",
            [ 320788 ] = "Frozen Binds",
        },
        [ 163126 ] = {
            desc = "The Necrotic Wake - Brittlebone Mage",
            [ 320336 ] = "Frostbolt",
        },
        [ 163128 ] = {
            desc = "The Necrotic Wake - Zolramus Sorcerer",
            [ 320462 ] = "Necrotic Bolt",
            [ 333479 ] = "Spew Disease",
            [ 333482 ] = "Disease Cloud",
            [ 333485 ] = "Disease Cloud",
        },
        [ 163618 ] = {
            desc = "The Necrotic Wake - Zolramus Necromancer",
            [ 320462 ] = "Necrotic Bolt",
        },
        [ 164815 ] = {
            desc = "The Necrotic Wake - Zolramus Siphoner",
            [ 322274 ] = "Enfeeble",
        },
        [ 165137 ] = {
            desc = "The Necrotic Wake - Zolramus Gatekeeper",
            [ 320462 ] = "Necrotic Bolt",
            [ 323347 ] = "Clinging Darkness",
        },
        [ 165824 ] = {
            desc = "The Necrotic Wake - Nar'zudah",
            [ 320462 ] = "Necrotic Bolt",
        },
        [ 166302 ] = {
            desc = "The Necrotic Wake - Corpse Harvester",
            [ 334748 ] = "Drain Fluids",
        },
    },

    -- Mists of Tirna Scithe
    [ 2290 ] = {
        [ 164567 ] = {
            desc = "Mists of Tirna Scithe - Ingra Maloch",
            [ 323057 ] = "Spirit Bolt",
        },
        [ 164920 ] = {
            desc = "Mists of Tirna Scithe - Drust Soulcleaver",
            [ 322557 ] = "Soul Split",
        },
        [ 164921 ] = {
            desc = "Mists of Tirna Scithe - Drust Harvester",
            [ 322767 ] = "Spirit Bolt",
            [ 326319 ] = "Spirit Bolt",
        },
        [ 164926 ] = {
            desc = "Mists of Tirna Scithe - Drust Boughbreaker",
            [ 324923 ] = "Bramble Burst",
        },
        [ 164929 ] = {
            desc = "Mists of Tirna Scithe - Tirnenn Villager",
            [ 322486 ] = "Overgrowth",
        },
        [ 166276 ] = {
            desc = "Mists of Tirna Scithe - Mistveil Guardian",
            [ 463217 ] = "Anima Slash",
        },
        [ 166304 ] = {
            desc = "Mists of Tirna Scithe - Mistveil Stinger",
            [ 325223 ] = "Anima Injection",
        },
        [ 172991 ] = {
            desc = "Mists of Tirna Scithe - Drust Soulcleaver",
            [ 322557 ] = "Soul Split",
        },
    },

    -- Theater of Pain
    [ 2293 ] = {
        [ 160495] = {
            desc = "Theater of Pain - Maniacal Soulbinder",
            [ 330784 ] = "Necrotic Bolt",
        },
        [ 162309 ] = {
            desc = "Theater of Pain - Kul'tharok",
            [  319669 ] = "Spectral Reach",
            [ 1216475 ] = "Necrotic Bolt",
        },
        [ 164461 ] = {
            desc = "Theater of Pain - Sathel the Accursed",
            [ 1217138 ] = "Necrotic Bolt",
        },
        [ 165946 ] = {
            desc = "Theater of Pain - Mordretha, the Endless Empress",
            [ 323608 ] = "Dark Devastation",
        },
        [ 166524 ] = {
            desc = "Theater of Pain - Deathwalker",
            [ 324589 ] = "Death Bolt",
        },
        [ 169875 ] = {
            desc = "Theater of Pain - Shackled Soul",
            [ 330810 ] = "Bind Soul",
        },
        [ 169893 ] = {
            desc = "Theater of Pain - Nefarious Darkspeaker",
            [ 330875 ] = "Spirit Frost",
        },
        [ 170690 ] = {
            desc = "Theater of Pain - Diseased Horror",
            [ 330697 ] = "Decaying Strike",
        },
        [ 174197 ] = {
            desc = "Theater of Pain - Battlefield Ritualist",
            [ 330784 ] = "Necrotic Bolt",
        },
        [ 174210 ] = {
            desc = "Theater of Pain - Blighted Sludge-Spewer",
            [ 341969 ] = "Withering Discharge",
        },
    },

    -- The Rookery
    [ 2648 ] = {
        [ 207202 ] = {
            desc = "The Rookery - Void Fragment",
            [ 430238 ] = "Void Bolt",
        },
        [ 207198 ] = {
            desc = "The Rookery - Cursed Thunderer",
            [ 430109 ] = "Lightning Bolt",
        },
        [ 214421 ] = {
            desc = "The Rookery - Coalescing Void Diffuser",
            [ 430805 ] = "Arcing Void",
        },
        [ 214439 ] = {
            desc = "The Rookery - Corrupted Oracle",
            [ 430179 ] = "Seeping Corruption",
        },
    },

    -- Priory of the Sacred Flame
    [ 2649 ] = {
        [ 206697 ] = {
            desc = "Priory of the Sacred Flame - Devout Priest",
            [ 427357 ] = "Holy Smite",
        },
        [ 206698 ] = {
            desc = "Priory of the Sacred Flame - Fanatical Conjuror",
            [ 427469 ] = "Fireball",
        },
        [ 207939 ] = {
            desc = "Priory of the Sacred Flame - Baron Braunpyke",
            [ 423015 ] = "Castigator's Shield",
        },
        [ 207940 ] = {
            desc = "Priory of the Sacred Flame - Prioress Murrpray",
            [ 423536 ] = "Holy Smite",
        },
        [ 211289 ] = {
            desc = "Priory of the Sacred Flame - Taener Duelmal",
            [ 424420 ] = "Cinderblast",
            [ 424421 ] = "Fireball",
        },
        [ 221760 ] = {
            desc = "Priory of the Sacred Flame - Risen Mage",
            [ 427469 ] = "Fireball",
        },
        [ 212827 ] = {
            desc = "Priory of the Sacred Flame - High Priest Aemya",
            [ 427357 ] = "Holy Smite",
        },
    },

    -- Darkflame Cleft
    [ 2651 ] = {
        [ 208743 ] = {
            desc = "Darkflame Cleft - Blazikon",
            [ 421638 ] = "Wicklighter Barrage",
            [ 421817 ] = "Wicklighter Barrage",
        },
        [ 210812 ] = {
            desc = "Darkflame Cleft - Royal Wicklighter",
            [ 423479 ] = "Wicklighter Bolt",
        },
        [ 212412 ] = {
            desc = "Darkflame Cleft - Sootsnout",
            [ 426677 ] = "Candleflame Bolt",
        },
        [ 213913 ] = {
            desc = "Darkflame Cleft - Kobold Flametender",
            [ 428563 ] = "Flame Bolt",
        },
    },

    -- The Stonevault
    [ 2652 ] = {
        [ 212389 ] = {
            desc = "The Stonevault - Cursedheart Invader",
            [ 426283 ] = "Arcing Void",
        },
        [ 212403 ] = {
            desc = "The Stonevault - Cursedheart Invader",
            [ 426283 ] = "Arcing Void",
        },
        [ 212765 ] = {
            desc = "The Stonevault - Void Bound Despoiler",
            [ 459210 ] = "Shadow Claw",
        },
        [ 213217 ] = {
            desc = "The Stonevault - Speaker Brokk",
            [ 428161 ] = "Molten Metal",
        },
        [ 213338 ] = {
            desc = "The Stonevault - Forgebound Mender",
            [ 429110 ] = "Alloy Bolt",
        },
        [ 214066 ] = {
            desc = "The Stonevault - Cursedforge Stoneshaper",
            [ 429422 ] = "Stone Bolt",
        },
        [ 214350 ] = {
            desc = "The Stonevault - Turned Speaker",
            [ 429545 ] = "Censoring Gear",
        },
    },

    -- Nerub-ar Palace
    [ 2657 ] = {
        [ 455123 ] = {
            desc = "Nerub-ar Palace - General Crixis",
            [ 451568 ] = "Void Slash",
        },
        [ 455124 ] = {
            desc = "Nerub-ar Palace - Arbitra's Fury",
            [ 451199 ] = "Celestial Blast",
        },
        [ 455125 ] = {
            desc = "Nerub-ar Palace - Netherblade Executioner",
            [ 450551 ] = "Shadow Rend",
        },
        [ 455126 ] = {
            desc = "Nerub-ar Palace - Frostbinder's Wrath",
            [ 444264 ] = "Ice Shard",
        },
        [ 455127 ] = {
            desc = "Nerub-ar Palace - Abyssal Devourer",
            [ 445619 ] = "Devour Essence",
        },
        [ 455128 ] = {
            desc = "Nerub-ar Palace - Sun King's Fury",
            [ 451895 ] = "Blazing Inferno",
        },
        [ 455129 ] = {
            desc = "Nerub-ar Palace - Starcaller Supreme",
            [ 451845 ] = "Cosmic Burst",
        },
        [ 455130 ] = {
            desc = "Nerub-ar Palace - Enraged Earthshaker",
            [ 444264 ] = "Earthquake",
        },
        [ 455131 ] = {
            desc = "Nerub-ar Palace - Mindshatter Lurker",
            [ 451678 ] = "Mind Flay",
        },
        [ 455132 ] = {
            desc = "Nerub-ar Palace - Spectral Overseer",
            [ 450551 ] = "Wail of Suffering",
        },
        [ 455133 ] = {
            desc = "Nerub-ar Palace - Necrotic Abomination",
            [ 450551 ] = "Necrotic Burst",
        },
        [ 455134 ] = {
            desc = "Nerub-ar Palace - Crimson Seeker",
            [ 444264 ] = "Blood Lance",
        },
    },

    -- Ara-Kara, City of Echoes
    [ 2660 ] = {
        [ 216293 ] = {
            desc = "Ara-Kara, City of Echoes - Trilling Attendant",
            [ 434786 ] = "Web Bolt",
        },
        [ 217531 ] = {
            desc = "Ara-Kara, City of Echoes - Ixin",
            [ 434786 ] = "Web Bolt",
        },
        [ 217533 ] = {
            desc = "Ara-Kara, City of Echoes - Atik",
            [ 436322 ] = "Poison Bolt",
        },
        [ 218324 ] = {
            desc = "Ara-Kara, City of Echoes - Nakt",
            [ 434786 ] = "Web Bolt",
        },
        [ 223253 ] = {
            desc = "Ara-Kara, City of Echoes - Bloodstained Webmage",
            [ 434786 ] = "Web Bolt",
        },
    },

    -- Cinderbrew Meadery
    [ 2661 ] = {
        [ 214661 ] = {
            desc = "Cinderbrew Meadery - Goldie Baronbottom",
            [ 436640 ] = "Burning Ricochet",
        },
        [ 218671 ] = {
            desc = "Cinderbrew Meadery - Venture Co. Pyromaniac",
            [ 437733 ] = "Boiling Flames",
        },
    },

    -- The Dawnbreaker
    [ 2662 ] = {
        [ 210966 ] = {
            desc = "The Dawnbreaker - Sureki Webmage",
            [ 451113 ] = "Web Bolt",
        },
        [ 213892 ] = {
            desc = "The Dawnbreaker - Nightfall Shadowmage",
            [ 431303 ] = "Night Bolt",
        },
        [ 213905 ] = {
            desc = "The Dawnbreaker - Animated Darkness",
            [ 451114 ] = "Congealed Shadow",
        },
        [ 213934 ] = {
            desc = "The Dawnbreaker - Nightfall Tactician",
            [ 431494 ] = "Blace Edge",
        },
        [ 214761 ] = {
            desc = "The Dawnbreaker - Nightfall Ritualist",
            [ 432448 ] = "Stygian Seed",
        },
        [ 223994 ] = {
            desc = "The Dawnbreaker - Nightfall Shadowmage",
            [ 431303 ] = "Night Bolt",
        },
        [ 228540 ] = {
            desc = "The Dawnbreaker - Nightfall Shadowmage",
            [ 431303 ] = "Night Bolt",
        },
    },

    -- City of Threads
    [ 2669 ] = {
        [ 216658 ] = {
            desc = "City of Threads - Izo, the Grand Splicer",
            [ 438860 ] = "Umbral Weave",
            [ 439341 ] = "Splice",
            [ 439814 ] = "Silken Tomb",
        },
        [ 220003 ] = {
            desc = "City of Threads - Eye of the Queen",
            [ 451222 ] = "Void Rush",
            [ 441772 ] = "Void Bolt",
            [ 451600 ] = "Expulsion Beam",
            [ 448660 ] = "Acid Bolt",
        },
        [ 220195 ] = {
            desc = "City of Threads - Sureki Silkbinder",
            [ 443427 ] = "Web Bolt",
        },
        [ 221102 ] = {
            desc = "City of Threads - Elder Shadeweaver",
            [ 446717 ] = "Umbral Weave",
            [ 443427 ] = "Web Bolt",
        },
        [ 223844 ] = {
            desc = "City of Threads - Covert Webmancer",
            [ 442536 ] = "Grimweave Blast",
        },
        [ 224732 ] = {
            desc = "City of Threads - Covert Webmancer",
            [ 442536 ] = "Grimweave Blast",
        },
    },

    -- Liberation of Undermine
    [ 2769 ] = {
        [ 231839 ] = {
            desc = "Liberation of Undermine - Scrapmaster",
            [ 1219384 ] = "Scrap Rockets",
        },
        [ 234211 ] = {
            desc = "Liberation of Undermine - Reel Assistant",
            [ 460847 ] = "Electric Blast",
        },
    },

    -- Operation: Floodgate
    [ 2773 ] = {
        [ 226396 ] = {
            desc = "Operation: Floodgate - Swampface",
            [ 473114 ] = "Mudslide",
        },
        [ 229069 ] = {
            desc = "Operation: Floodgate - Mechadrone Sniper",
            [ 1214468 ] = "Trickshot",
        },
        [ 229686 ] = {
            desc = "Operation: Floodgate - Venture Co. Surveyor",
            [ 462771 ] = "Surveying Beam",
        },
        [ 230740 ] = {
            desc = "Operation: Floodgate - Shreddinator 3000",
            [ 465754 ] = "Flamethrower",
        },
        [ 230748 ] = {
            desc = "Operation: Floodgate - Darkfuse Bloodwarper",
            [ 465871 ] = "Blood Bolt",
        },
        [ 231197 ] = {
            desc = "Operation: Floodgate - Bubbles",
            [ 469721 ] = "Backwash",
        },
        [ 231312 ] = {
            desc = "Operation: Floodgate - Venture Co. Electrician",
            [ 465595 ] = "Lightning Bolt",
        },
    },
}

do
    -- Make reflectableFilters[ instanceID ][ npcID ][ spellID ] always be valid.

    local emptyNPC = {}
    local mt_instance = { __index = function( t, k ) return emptyNPC end }

    local emptyInstance = setmetatable( {}, mt_instance )
    local mt_filter = { __index = function( t, k ) return emptyInstance end }

    for instanceID, instanceData in pairs( reflectableFilters ) do
        setmetatable( instanceData, mt_instance )
    end

    setmetatable( reflectableFilters, mt_filter )
end

class.reflectableFilters = reflectableFilters
