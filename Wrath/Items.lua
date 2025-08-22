-- Wrath/Items.lua

local addon, ns = ...
local Hekili = _G[ addon ]

local class, state = Hekili.Class, Hekili.State
local all = Hekili.Class.specs[ 0 ]

all:RegisterAbilities( {
    wrathstone = {
        cast = 0,
        cooldown = 120,
        gcd = "off",

        item = function ()
            -- Short-circuit the most likely match first.
            if equipped[156000] then return 156000 end
            return 45263
        end,
        items = { 45263, 156000 },
        toggle = "cooldowns",

        handler = function ()
            applyBuff( "wrathstone" )
        end,

        auras = {
            wrathstone = {
                id = 64800,
                duration = 20,
                max_stack = 1
            }
        }
    },

    scale_of_fates = {
        cast = 0,
        cooldown = 120,
        gcd = "off",

        item = 156187,
        toggle = "cooldowns",

        proc = "haste",
        self_buff = "scale_of_fates",

        handler = function()
            applyBuff( "scale_of_fates" )
        end,

        auras = {
            scale_of_fates = {
                id = 64707,
                duration = 20,
                max_stack = 1
            },
        },
    },
} )
