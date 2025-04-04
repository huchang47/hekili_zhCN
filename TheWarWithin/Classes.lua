-- TheWarWithin/Classes.lua

local addon, ns = ...
local Hekili = _G[ addon ]
local class = Hekili.Class

if Hekili.CurrentBuild < 110000 then return end

-- interruptibleFilters[ instanceID ][ npcID ][ spellID ] = ...
local interruptibleFilters = {
    -- Grim Batol
    [ 670 ] = {
        [ 40167 ] = {
            desc = "Grim Batol - Twilight Beguiler",
            [ 76369 ] = "Sear Mind",
        },
        [ 224219 ] = {
            desc = "Grim Batol - Twilight Earthcaller",
            [ 451871 ] = "Mass Tremor",
        },
    },

    -- Siege of Boralus
    [ 1822 ] = {
        [ 129367 ] = {
            desc = "Siege of Boralus - Bilge Rat Tempest",
            [ 272571 ] = "Choking Waters",
        },
        [ 128969 ] = {
            desc = "Siege of Boralus - Ashvane Commander",
            [ 275826 ] = "Bolstering Shout",
        },
        [ 129370 ] = {
            desc = "Siege of Boralus - Irontide Waveshaper",
            [ 256957 ] = "Watertight Shell",
        },
        [ 135241 ] = {
            desc = "Siege of Boralus - Bilge Rat Pillager",
            [ 454440 ] = "Stinky Vomit",
        },
        [ 141284 ] = {
            desc = "Siege of Boralus - Kul Tiran Wavetender",
            [ 256957 ] = "Watertight Shell",
        },
        [ 144071 ] = {
            desc = "Siege of Boralus - Irontide Waveshaper",
            [ 256957 ] = "Watertight Shell",
        },
    },

    -- The Necrotic Wake
    [ 2286 ] = {
        [ 165222 ] = {
            desc = "The Necrotic Wake - Zolramus Bonemender",
            [ 335143 ] = "Bonemend",
        },
        [ 165872 ] = {
            desc = "The Necrotic Wake - Flesh Crafter",
            [ 327130 ] = "Repair Flesh",
        },
        [ 165919 ] = {
            desc = "The Necrotic Wake - Skeletal Marauder",
            [ 324293 ] = "Rasping Scream",
        },
        [ 166302 ] = {
            desc = "The Necrotic Wake - Corpse Harvester",
            [ 334748 ] = "Drain Fluids",
        },
        [ 171095 ] = {
            desc = "The Necrotic Wake - Grisly Colossus",
            [ 324293 ] = "Rasping Scream",
        },
        [ 173016 ] = {
            desc = "The Necrotic Wake - Corpse Collector",
            [ 334748 ] = "Drain Fluids",
            [ 338353 ] = "Goresplatter",
        },
        [ 173044 ] = {
            desc = "The Necrotic Wake - Stitching Assistant",
            [ 334748 ] = "Drain Fluids",
        },
    },

    -- Mists of Tirna Scithe
    [ 2290 ] = {
        [ 164517 ] = {
            desc = "Mists of Tirna Scithe - Tred'ova",
            [ 322450 ] = "Consumption",
            [ 337235 ] = "Parasitic Pacification",
        },
        [ 164921 ] = {
            desc = "Mists of Tirna Scithe - Drust Harvester",
            [ 322938 ] = "Harvest Essence",
        },
        [ 164926 ] = {
            desc = "Mists of Tirna Scithe - Drust Boughbreaker",
            [ 324923 ] = "Bramble Burst",
        },
        [ 166275 ] = {
            desc = "Mists of Tirna Scithe - Mistveil Shaper",
            [ 324776 ] = "Bramblethorn Coat",
        },
        [ 166299 ] = {
            desc = "Mists of Tirna Scithe - Mistveil Tender",
            [ 324914 ] = "Nourish the Forest",
        },
        [ 167111 ] = {
            desc = "Mists of Tirna Scithe - Spinemaw Staghorn",
            [ 326046 ] = "Stimulate Resistance",
            [ 340544 ] = "Stimulate Regeneration",
        },
    },

    -- Khaz Algar Surface
    [ 2552 ] = {
        [ 225977 ] = {
            desc = "Dornogal - Dungeoneer's Training Dummy",
            [ 167385 ] = "testing", -- Uber Strike
        },
    },

    -- Khaz Algar Underground
    [ 2601 ] = {
        [ 223469 ] = {
            desc = "The Ringing Deeps - Voidtouched Speaker",
            [ 429545 ] = "Censoring Gear",
        },
    },

    -- The Rookery
    [ 2648 ] = {
        [ 214421 ] = {
            desc = "The Rookery - Coalescing Void Diffuser",
            [ 430805 ] = "Arcing Void",
        },
        [ 212793 ] = {
            desc = "The Rookery - Void Ascendant",
            [ 432959 ] = "Void Volley",
        },
    },

    -- Priory of the Sacred Flame
    [ 2649 ] = {
        [ 206697 ] = {
            desc = "Priory of the Sacred Flame - Devout Priest",
            [ 427356 ] = "Greater Heal",
        },
        [ 207939 ] = {
            desc = "Priory of the Sacred Flame - Baron Braunpyke",
            [ 423051 ] = "Burning Light",
        },
        [ 207946 ] = {
            desc = "Priory of the Sacred Flame - Captain Dailcry",
            [ 424419 ] = "Battle Cry",
        },
        [ 211289 ] = {
            desc = "Priory of the Sacred Flame - Taener Duelmal",
            [ 424420 ] = "Cinderblast",
        },
        [ 221760 ] = {
            desc = "Priory of the Sacred Flame - Risen Mage",
            [ 444743 ] = "Fireball Volley",
        },
    },

    -- Darkflame Cleft
    [ 2651 ] = {
        [ 208745 ] = {
            desc = "Darkflame Cleft - The Candle King",
            [ 426145 ] = "Paranoid Mind",
        },
        [ 212412 ] = {
            desc = "Darkflame Cleft - Sootsnout",
            [ 426295 ] = "Flaming Tether",
        },
        [ 208747 ] = {
            desc = "Darkflame Cleft - The Darkness",
            [ 427157 ] = "Call Darkspawn",
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
        [ 212453 ] = {
            desc = "The Stonevault - Ghastly Voidsoul",
            [ 449455 ] = "Howling Fear",
        },
        [ 213338 ] = {
            desc = "The Stonevault - Forgebound Mender",
            [ 429109 ] = "Restoring Metals",
        },
        [ 214350 ] = {
            desc = "The Stonevault - Turned Speaker",
            [ 429545 ] = "Censoring Gear",
        },
        [ 221979 ] = {
            desc = "The Stonevault - Void Bound Howler",
            [ 445207 ] = "Piercing Wail",
        },
        [ 224962 ] = {
            desc = "The Stonevault - Cursedforge Mender",
            [ 429109 ] = "Restoring Metals",
        },
    },

    -- Nerub-ar Palace
    [ 2657 ] = {
        [ 201792 ] = {
            desc = "Nerub'ar Palace - Nexus-Princess Ky'veza",
            [ 437839 ] = "Nether Rift",
            [ 436787 ] = "Regicide",
            [ 436996 ] = "Stalking Shadows",
        },
        [ 201793 ] = {
            desc = "Nerub'ar Palace - The Silken Court",
            [ 438200 ] = "Poison Bolt",
            [ 441772 ] = "Void Bolt"
        },
        [ 201794 ] = {
            desc = "Nerub'ar Palace - Queen Ansurek",
            [ 451600 ] = "Expulsion Beam",
            [ 439865 ] = "Silken Tomb",
        },
        [ 203669 ] = {
            desc = "Nerub'ar Palace - Rasha'nan",
            [ 436996 ] = "Stalking Shadows"
        },
    },

    -- Ara-Kara, City of Echoes
    [ 2660 ] = {
        [ 216293 ] = {
            desc = "Ara-Kara, City of Echoes - Trilling Attendant",
            [ 434793 ] = "Resonant Barrage",
        },
        [ 216364 ] = {
            desc = "Ara-Kara, City of Echoes - Blood Overseer",
            [ 433841 ] = "Venom Volley",
        },
        [ 217531 ] = {
            desc = "Ara-Kara, City of Echoes - Ixin",
            [ 434802 ] = "Horrifying Shrill",
        },
        [ 217533 ] = {
            desc = "Ara-Kara, City of Echoes - Atik",
            [ 436322 ] = "Poison Bolt",
        },
        [ 220599 ] = {
            desc = "Ara-Kara, City of Echoes - Bloodstained Webmage",
            [ 442210 ] = "Silken Restraints",
        },
        [ 223253 ] = {
            desc = "Ara-Kara, City of Echoes - Bloodstained Webmage",
            [ 448248 ] = "Revolting Volley",
        },
    },

    -- Cinderbrew Meadery
    [ 2661 ] = {
        [ 218671 ] = {
            desc = "Cinderbrew Meadery - Venture Co. Pyromaniac",
            [ 437721 ] = "Boiling Flames",
        },
        [ 220141 ] = {
            desc = "Cinderbrew Meadery - Royal Jelly Purveyor",
            [ 440687 ] = "Honey Volley",
        },
        [ 214673 ] = {
            desc = "Cinderbrew Meadery - Flavor Scientist",
            [ 441627 ] = "Rejuvenating Honey",
        },
        [ 222964 ] = {
            desc = "Cinderbrew Meadery - Flavor Scientist",
            [ 441627 ] = "Rejuvenating Honey",
        },
    },

    -- The Dawnbreaker
    [ 2662 ] = {
        [ 213892 ] = {
            desc = "The Dawnbreaker - Nightfall Shadowmage",
            [ 431309 ] = "Ensnaring Shadows",
        },
        [ 213893 ] = {
            desc = "The Dawnbreaker - Nightfall Darkcaster",
            [ 431333 ] = "Tormenting Beam",
        },
        [ 225605 ] = {
            desc = "The Dawnbreaker - Nightfall Darkcaster",
            [ 431333 ] = "Tormenting Beam",
        },
        [ 213932 ] = {
            desc = "The Dawnbreaker - Sureki Militant",
            [ 451097 ] = "Silken Shell",
        },
        [ 214762 ] = {
            desc = "The Dawnbreaker - Nightfall Commander",
            [ 450756 ] = "Abyssal Howl",
        },
        [ 228539 ] = {
            desc = "The Dawnbreaker - Nightfall Darkcaster",
            [ 431333 ] = "Tormenting Beam",
        },
        [ 228540 ] = {
            desc = "The Dawnbreaker - Nightfall Shadowmage",
            [ 431309 ] = "Ensnaring Shadows",
        },
    },

    -- City of Threads
    [ 2669 ] = {
        [ 220195 ] = {
            desc = "City of Threads - Sureki Silkbinder",
            [ 443430 ] = "Silk Binding",
        },
        [ 220196 ] = {
            desc = "City of Threads - Herald of Ansurek",
            [ 443433 ] = "Twist Thoughts",
        },
        [ 220401 ] = {
            desc = "City of Threads - Pale Priest",
            [ 448047 ] = "Web Wrap",
        },
        [ 223844 ] = {
            desc = "City of Threads - Covert Webmancer",
            [ 442536 ] = "Grimweave Blast",
            [ 452162 ] = "Mending Web",
        },
        [ 224732 ] = {
            desc = "City of Threads - Covert Webmancer",
            [ 442536 ] = "Grimweave Blast",
            [ 452162 ] = "Mending Web",
        },
    },
    [ 2648 ] = {
        [ 207199 ] = {
            desc = "被诅咒的雷鸫看护者",
            [ 427260 ] = "闪电涌动",
        },
        [ 207198 ] = {
            desc = "被诅咒的雷霆使",
            [ 430109 ] = "闪电箭",
        },
        [ 212793 ] = {
            desc = "虚空晋升者",
            [ 430238 ] = "虚空箭",
        },
        [ 214439 ] = {
            desc = "被腐化的先知",
            [ 430238 ] = "虚空箭",
        },
    },
		--车间
    [ 2097 ] = {
        [ 151657 ] = {
            desc = "炸弹坦克",
            [ 301088 ] = "引爆",
        },
        [ 144294 ] = {
            desc = "麦卡贡工匠",
            [ 293827 ] = "超荷冲击波",
        },
        [ 144295 ] = {
            desc = "麦卡贡机械师",
            [ 293729 ] = "调校",
        },
    },
		--剧场
    [ 2293 ] = {
        [ 174197 ] = {
            desc = "战场祭师",
            [ 330784 ] = "通灵箭",
            [ 341902 ] = "不洁热情",
        },
        [ 164506 ] = {
		    desc = "上古队长",
            [ 330562 ] = "挫志怒吼",
        },
        [ 170690 ] = {
            desc = "染病恐魔",
            [ 341977 ] = "血肉之盾",
            [ 319290 ] = "血肉之盾",
        },
        [ 174210 ] = {
            desc = "凋零淤泥喷射者",
            [ 341969 ] = "凋零释放",
        },
        [ 160495 ] = {
            desc = "狂热的缚魂者",
            [ 330784 ] = "通灵箭",
            [ 330868 ] = "通灵箭雨",
        },
        [ 170882 ] = {
            desc = "白骨魔导师",
            [ 342675 ] = "骨矛",
        },
    },
		--暴富
    [ 1594 ] = {
        [ 136470 ] = {
            desc = "零食商贩",
            [ 280604 ] = "冰镇汽水",
        },
        [ 134232 ] = {
            desc = "雇来的刺客",
            [ 269302 ] = "淬毒之刃",
        },
        [ 130661 ] = {
            desc = "风险投资公司塑地者",
            [ 263202 ] = "石枪",
            [ 271579 ] = "石枪",
        },
        [ 130635 ] = {
            desc = "巨石之怒",
            [ 263215 ] = "地壳屏障",
            [ 268702 ] = "狂怒地震",
        },
        [ 133432 ] = {
            desc = "风险投资公司炼金师",
            [ 262268 ] = "腐蚀性化合物",
            [ 268797 ] = "转化：敌人变黏液",
        },
    },
		--酒庄
    [ 2661 ] = {
        [ 218671 ] = {
            desc = "风险投资公司纵火狂",
            [ 437721 ] = "沸燃烈焰",
            [ 453909 ] = "沸燃烈焰",
            [ 453989 ] = "沸燃烈焰",
            [ 454318 ] = "沸燃烈焰",
            [ 454319 ] = "沸燃烈焰",
        },
        [ 214673 ] = {
            desc = "风味科学家",
            [ 441627 ] = "疗愈蜂蜜",
        },
        [ 210264 ] = {
            desc = "驯蜂者",
            [ 441351 ] = "狂蜂怒火",
        },
        [ 220141 ] = {
            desc = "蜂王浆供应商",
            [ 440687 ] = "蜂蜜齐射",
        },
    },
		--暴富
    [ 2651 ] = {
        [ 210812 ] = {
            desc = "皇家点芯者",
            [ 2423479 ] = "点芯箭",
        },
        [ 210818 ] = {
            desc = "低贱的鼹鼠倌",
            [ 425536 ] = "鼹鼠狂暴",
        },
        [ 220815 ] = {
            desc = "炽焰魔",
            [ 424322 ] = "爆炸烈焰",
        },
        [ 212412 ] = {
            desc = "灰鼻",
            [ 426295 ] = "烈焰系链",
            [ 426677 ] = "烛焰箭",
        },
        [ 208745 ] = {
            desc = "蜡烛之王",
            [ 426145 ] = "偏执失心",
        },
        [ 208456 ] = {
            desc = "残步恐魔",
            [ 422541 ] = "吸取光明",
            [ 422692 ] = "吸取光明",
        },
        [ 208747 ] = {
            desc = "黑暗之主",
            [ 427157 ] = "召唤暗嗣",
        },
        [ 213008 ] = {
            desc = "蠕动暗嗣",
            [ 427176 ] = "吸取光明",
        },
    },
		--修道院(11.1,S2)
    [ 2649 ] = {
        [ 206697 ] = {
            desc = "虔诚的牧师",
            [ 427356 ] = "强效治疗术",
        },
        [ 206698 ] = {
            desc = "狂热的咒术师",
            [ 427469 ] = "火球术",
        },
        [ 212827 ] = {
            desc = "高阶牧师艾姆雅",
            [ 427357 ] = "神圣惩击",
        },
        [ 239834 ] = {
            desc = "泰纳·杜尔玛",
            [ 424420 ] = "余烬冲击",
            [ 424421 ] = "火球术",
        },
        [ 221760 ] = {
            desc = "亡灵法师",
            [ 444743 ] = "连珠火球",
            [ 427469 ] = "火球术",
        },
        [ 207940 ] = {
            desc = "隐修院长穆普雷",
            [ 423588 ] = "圣光屏障",
        },
    },
		--水闸行动(11.1,S2)
    [ 2773 ] = {
        [ 229686 ] = {
            desc = "风险投资公司勘探员",
            [ 462771 ] = "勘测光束",
        },
        [ 229252 ] = {
            desc = "暗索土狼",
            [ 463058 ] = "嗜血狞笑",
        },
        [ 229069 ] = {
            desc = "无人机狙击手",
            [ 1214468 ] = "特技射击",
        },
        [ 230748 ] = {
            desc = "暗索扭血者",
            [ 465871 ] = "鲜血冲击",
        },
        [ 231496 ] = {
            desc = "风险管理公司潜水员",
            [ 468631 ] = "鱼叉",
        },
        [ 231223 ] = {
            desc = "被惊扰的海藻",
            [ 471733 ] = "回春水藻",
        },
        [ 231312 ] = {
            desc = "风险投资公司电工",
            [ 465595 ] = "闪电箭",
        },
    },
}

do
    -- Make interruptibleFilters[ instanceID ][ npcID ][ spellID ] always be valid.

    local emptyNPC = {}
    local mt_instance = { __index = function( t, k ) return emptyNPC end }

    local emptyInstance = setmetatable( {}, mt_instance )
    local mt_filter = { __index = function( t, k ) return emptyInstance end }

    for instanceID, instanceData in pairs( interruptibleFilters ) do
        setmetatable( instanceData, mt_instance )
    end

    setmetatable( interruptibleFilters, mt_filter )
end

class.interruptibleFilters = interruptibleFilters
