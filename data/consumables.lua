-- CONSUMABLES
-- All of them, ordered by type, then by date of creation.
-- Includes relevant enhancements.

SMODS.Atlas {
    key = "the_tarots",
    path = "the_tarots.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "the_hancements",
    path = "the_hancements.png",
    px = 71,
    py = 95
}

-- The Look-alike and Two Cards
SMODS.Consumable {
    key = "lookalike",
    set = "Tarot",
    atlas = "the_tarots",
    pos = { x = 0, y = 0 },
    discovered = true,
    cost = 3,
    config = {
        extra = {
            max_highlighted = 1,
            mod_conv = "m_thel_twocards"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.mod_conv]
        return {
            vars = {
                card.ability.extra.max_highlighted,
                localize { type = "name_text", set = "Enhanced", key = card.ability.extra.mod_conv }
            }
        }
    end,
    can_use = function(self, card)
        return #G.hand.highlighted == card.ability.extra.max_highlighted
    end,
    keep_on_use = function(self, card)
        return false
    end,
    use = function(self, card, area, copier)
        the_latro.flip_cards(G.hand.highlighted)
        delay(0.2)
        for k, v in pairs(G.hand.highlighted) do
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.1,
                func = function()
                    v:set_ability(card.ability.extra.mod_conv)
                    return true
                end
            }))
        end
        delay(0.2)
        the_latro.unflip_cards(G.hand.highlighted)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.2,
            func = function()
                G.hand.unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
}
SMODS.Enhancement {
    key = "twocards",
    atlas = "the_hancements",
    pos = { x = 0, y = 0 },
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition then
            return { repetitions = 1, card = card, remove_default_message = true }
        end
    end
}
