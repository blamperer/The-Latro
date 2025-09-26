SMODS.Atlas({
	key = "zodiac_jokers",
	path = "zodiac_jokers.png",
	px = 71,
	py = 95,
})

-- Possible Talisman compat
local function big(x)
	return (Talisman and to_big(x)) or x
end
local function num(x)
	return (Talisman and to_number(x)) or x
end

--#region JOKERS
-- Aries
SMODS.Joker({
	key = "aries",
	config = {
		extra = {
			x_mult = 2.5,
		},
	},
	rarity = 2,
	cost = 5,
	atlas = "zodiac_jokers",
	pos = { x = 0, y = 0 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.blind and G.GAME.blind.boss then
			return { xmult = card.ability.extra.x_mult }
		end
	end,
})

-- Taurus
SMODS.Joker({
	key = "taurus",
	config = {
		extra = {
			x_mult_gain = 0.01,
			spend_threshold = 1,
			current_x_mult = 1.0,
		},
	},
	rarity = 2,
	cost = 5,
	atlas = "zodiac_jokers",
	pos = { x = 1, y = 0 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult_gain,
				card.ability.extra.spend_threshold,
				card.ability.extra.current_x_mult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.current_x_mult > 1.0 then
			return { xmult = card.ability.extra.current_x_mult }
		end

		if context.money_altered and context.from_shop and num(context.amount) < 0 then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "current_x_mult",
				scalar_table = context,
				scalar_value = "amount",
				operation = function(ref_table, ref_value, initial, scaling)
					ref_table[ref_value] = initial - card.ability.extra.x_mult_gain * scaling
				end,
				scaling_message = {
					message = localize({
						type = "variable",
						key = "a_xmult",
						vars = {
							card.ability.extra.current_x_mult + (card.ability.extra.x_mult_gain * -context.amount),
						},
					}),
					colour = G.C.RED,
				},
			})
		end
	end,
})

-- Gemini
SMODS.Joker({
	key = "gemini",
	config = {
		extra = {
			chips = 150,
			x_mult = 2,
			plays = 0,
		},
	},
	rarity = 2,
	cost = 4,
	atlas = "zodiac_jokers",
	pos = { x = 2, y = 0 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.extra.chips,
			card.ability.extra.x_mult,
		} }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not card.debuff and next(context.poker_hands["Two Pair"]) then
			local return_table
			if card.ability.extra.plays % 2 == 0 then
				return_table = { chips = card.ability.extra.chips }
			else
				return_table = { xmult = card.ability.extra.x_mult }
			end
			card.ability.extra.plays = card.ability.extra.plays + 1
			return return_table
		end
	end,
})

-- Cancer
SMODS.Joker({
	key = "cancer",
	config = {
		extra = {
			mult = 0,
			mult_gain = 10,
		},
	},
	rarity = 2,
	cost = 4,
	atlas = "zodiac_jokers",
	pos = { x = 3, y = 0 },
	discovered = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	enhancement_gate = "m_glass",
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.config.center_key == "m_glass" and not context.other_card.debuff then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				return {
					message = localize("k_upgrade_ex"),
					colour = G.C.RED,
					card = card,
				}
			end
		end

		if context.joker_main then
			return { mult = card.ability.extra.mult }
		end

		if context.cards_destroyed then
			local any_shatters = false
			for _, v in ipairs(context.glass_shattered) do
				any_shatters = any_shatters or v.shattered
			end
			if any_shatters then
				card.ability.extra.mult = 0
				return { message = localize("k_reset") }
			end
		end

		if context.remove_playing_cards then
			local any_shatters = false
			for _, v in ipairs(context.removed) do
				any_shatters = any_shatters or v.shattered
			end
			if any_shatters then
				card.ability.extra.mult = 0
				return { message = localize("k_reset") }
			end
		end
	end,
})

-- Leo
SMODS.Joker({
	key = "leo",
	config = {
		extra = {
			chips = 50,
		},
	},
	rarity = 2,
	cost = 4,
	atlas = "zodiac_jokers",
	pos = { x = 4, y = 0 },
	discovered = true,
	enhancement_gate = "m_lucky",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
		return { vars = { card.ability.extra.chips } }
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
		if context.individual and context.playarea == G.play then
			if context.other_card.lucky_trigger then
				return { chips = card.ability.extra.chips }
			end
		end
	end,
})

-- Virgo
SMODS.Joker({
	key = "virgo",
	config = {
		extra = {
			x_mult = 1.25,
		},
	},
	rarity = 2,
	cost = 4,
	atlas = "zodiac_jokers",
	pos = { x = 5, y = 0 },
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 12 and not context.other_card.debuff then
				return { x_mult = card.ability.extra.x_mult }
			end
		end
	end,
})

-- Libra
SMODS.Joker({
	key = "libra",
	config = {
		extra = {
			chips = 25,
			mult = 25,
		},
	},
	rarity = 2,
	cost = 4,
	atlas = "zodiac_jokers",
	pos = { x = 6, y = 0 },
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
		if context.joker_main then
			local suits = {}
			for _, v in ipairs(context.scoring_hand) do
				local suit = v:get_suit()
				if not (suit == "Wild" or suit == "None") and not the_latro.table_contains(suits, suit) then
					table.insert(suits, suit)
				end
			end
			if #suits == 2 then
				return {
					chips = card.ability.extra.chips,
					mult = card.ability.extra.mult,
				}
			end
		end
	end,
})

-- Scorpio
-- BUG: Cards that add seals to cards can have that seal be overwritten
SMODS.Joker({
	key = "scorpio",
	config = {
		extra = {
			should_add = false,
			odds = 4,
			seal = "Gold",
		},
	},
	rarity = 2,
	cost = 5,
	atlas = "zodiac_jokers",
	pos = { x = 0, y = 1 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS["Gold"]
		return {
			vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.odds)}
		}
	end,
	calculate = function(self, card, context)
		if context.using_consumeable then
			card.ability.extra.should_add = card.ability.extra.should_add
				or SMODS.pseudorandom_probability(card, "thel_scorpio", 1, card.ability.extra.odds, "thel_scorpio")
			if #G.hand.highlighted > 0 then
				local eligible_cards = {}
				for _, v in ipairs(G.hand.highlighted) do
					if not v.seal then
						table.insert(eligible_cards, v)
					end
				end
				if #eligible_cards > 0 and card.ability.extra.should_add then
					local choice = pseudorandom_element(eligible_cards, pseudoseed("scorpio"))

					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound("tarot1")
							card:juice_up(0.3, 0.5)
							return true
						end,
					}))
					G.E_MANAGER:add_event(Event({
						func = function()
							choice:set_seal(card.ability.extra.seal)
							card.ability.extra.should_add = false
							return true
						end,
					}))
					return {
						message = localize("k_gilded_ex"),
						colour = G.C.GOLD,
						card = card,
					}
				end
			end
		end
	end,
})

-- Sagittarius
SMODS.Joker({
	key = "sagittarius",
	config = {
		extra = {
			odds = 6,
			cards_valid = true,
		},
	},
	rarity = 2,
	cost = 5,
	atlas = "zodiac_jokers",
	pos = { x = 1, y = 1 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			card.ability.extra.cards_valid = card.ability.extra.cards_valid
				and context.other_card:is_suit("Spades", false, true)
		end
		if context.final_scoring_step and (context.cardarea == G.jokers) and card.ability.extra.cards_valid then
			local eligible_cards = {}
			for _, v in ipairs(context.scoring_hand) do
				if not v.edition then
					table.insert(eligible_cards, v)
				end
			end
			for _, v in ipairs(eligible_cards) do
				if SMODS.pseudorandom_probability(card, "thel_sagittarius", 1, card.ability.extra.odds, "thel_sagittarius") then
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound("tarot1")
							card:juice_up(0.3, 0.5)
							return true
						end,
					}))
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up(0.3, 0.5)
							v:set_edition("e_foil")
							return true
						end,
					}))
					G.E_MANAGER:add_event(Event({
						func = function()
							card_eval_status_text(card, "extra", nil, nil, nil, {
								message = localize("k_knapped_ex"),
								instant = instant,
								colour = G.C.BLUE,
							})
							return true
						end,
					}))
					delay(0.3)
				end
			end
		end
		if context.after and context.cardarea == G.jokers then
			card.ability.extra.cards_valid = true
		end
	end,
})

-- Capricorn
SMODS.Joker({
	key = "capricorn",
	config = {
		extra = {
			repetitions = 1,
		},
	},
	rarity = 2,
	cost = 4,
	atlas = "zodiac_jokers",
	pos = { x = 2, y = 1 },
	discovered = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	enhancement_gate = "m_stone",
	calculate = function(self, card, context)
		if context.repetition and not context.repetition_only and context.cardarea == G.play then
			if context.other_card.config.center_key == "m_stone" then
				return {
					message = localize("k_again_ex"),
					repetitions = card.ability.extra.repetitions,
					card = card,
				}
			end
		end
	end,
})

-- Aquarius
SMODS.Joker({
	key = "aquarius",
	config = {
		extra = {
			chips = 0,
			chips_gain = 10,
		},
	},
	rarity = 2,
	cost = 4,
	atlas = "zodiac_jokers",
	pos = { x = 3, y = 1 },
	discovered = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
		return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips } }
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	enhancement_gate = "m_bonus",
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.chips > 0 then
			return {
				chips = card.ability.extra.chips,
			}
		elseif context.individual and context.cardarea == G.play and not context.blueprint then
			if context.other_card.config.center_key == "m_bonus" and not context.other_card.debuff then
				-- card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
				-- return {
				-- 	--message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips }}
				-- 	message = localize("k_upgrade_ex"),
				-- 	colour = G.C.CHIPS,
				-- }
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "chips",
					scalar_value = "chips_gain",
					message_colour = G.C.BLUE
				})
			end
		end
	end,
})

-- Pisces
SMODS.Joker({
	key = "pisces",
	config = {
		extra = {
			plus_chips = 0,
			chip_gain = 25,
			triggered_tags = {},
		},
	},
	rarity = 2,
	cost = 5,
	atlas = "zodiac_jokers",
	pos = { x = 4, y = 1 },
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chip_gain, card.ability.extra.plus_chips } }
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.plus_chips > 0 then
			return { chips = card.ability.extra.plus_chips }
		end

		if context.tag_triggered then
			SMODS.scale_card(
				card,
				{
					ref_table = card.ability.extra,
					ref_value = "plus_chips",
					scalar_value = "chip_gain",
					message_colour = G.C.BLUE
				}
			)
		end
	end,
})

-- Ophiuchus
-- Needs a better effect
-- SMODS.Joker({
-- 	key = "ophiuchus",
-- 	config = {
-- 		extra = {
-- 			x_mult = 1.5,
-- 		},
-- 	},
-- 	rarity = 3,
-- 	cost = 8,
-- 	atlas = "zodiac_jokers",
-- 	pos = { x = 5, y = 1 },
-- 	discovered = true,
-- 	loc_vars = function(self, info_queue, card)
-- 		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
-- 		return { vars = { card.ability.extra.x_mult } }
-- 	end,
-- 	blueprint_compat = true,
-- 	eternal_compat = true,
-- 	perishable_compat = true,
-- 	calculate = function(self, card, context)
-- 		if context.other_joker then
-- 			if context.other_joker.edition and context.other_joker.edition.polychrome then
-- 				G.E_MANAGER:add_event(Event({
-- 					func = function()
-- 						context.other_joker:juice_up()
-- 						return true
-- 					end,
-- 				}))
-- 				return {
-- 					xmult = card.ability.extra.x_mult,
-- 				}
-- 			end
-- 		end
-- 	end,
-- })
--#endregion