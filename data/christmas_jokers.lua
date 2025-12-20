SMODS.Atlas({
	key = "12_days",
	path = "12_days.png",
	px = 71,
	py = 95,
})

--#region On the 12th day of Christmas, my true love gave to me,

-- Twelve Drummers Drumming
SMODS.Joker {
	key = "twelfth_day",
	config = {
		extra = {
			faces_scored = 0,
			faces_needed = 12
		}
	},
	rarity = 1,
	cost = 3,
	atlas = "12_days",
	pos = { x = 5, y = 1 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.faces_needed,
				card.ability.extra.faces_scored
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:is_face() then
			if not context.blueprint then
				card.ability.extra.faces_scored = card.ability.extra.faces_scored + 1
			end

			if card.ability.extra.faces_scored >= card.ability.extra.faces_needed then
				card.ability.extra.faces_scored = card.ability.extra.faces_scored - card.ability.extra.faces_needed
				if #G.consumeables.cards < G.consumeables.config.card_limit then
					G.E_MANAGER:add_event(Event({
						func = function()
							SMODS.add_card { set = "Tarot", area = G.consumeables }
							return true
						end
					}))
					return {
						message = localize("k_plus_tarot"),
						message_card = card,
						colour = G.C.SECONDARY_SET.Tarot
					}
				end
			end
		end
	end
}

-- Eleven Pipers Piping
SMODS.Joker {
	key = "eleventh_day",
	config = {
		extra = {
			x_mult_gain = 0.5,
			suits_scored = {}
		}
	},
	rarity = 2,
	cost = 6,
	atlas = "12_days",
	pos = { x = 4, y = 1 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult_gain,
				1 + (#card.ability.extra.suits_scored * card.ability.extra.x_mult_gain)
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			if context.other_card:get_id() == 11 then
				local suit = context.other_card:get_suit()
				if suit ~= "None" then
					if suit == "Wild" then
						-- Substitute in a pre-existing suit
						for k, _ in pairs(SMODS.Suits) do
							if not the_latro.table_contains(card.ability.extra.suits_scored, k) then
								table.insert(card.ability.extra.suits_scored, k)
								return {
									message = localize {
										type = "variable",
										key = "a_xmult",
										vars = { 1 + (#card.ability.extra.suits_scored * card.ability.extra.x_mult_gain) }
									},
									colour = G.C.MULT,
									message_card = card
								}
							end
						end
						-- A Wild card is infinite extra suits...
						table.insert(card.ability.extra.suits_scored, suit)
						return {
							message = localize {
								type = "variable",
								key = "a_xmult",
								vars = { 1 + (#card.ability.extra.suits_scored * card.ability.extra.x_mult_gain) }
							},
							colour = G.C.MULT,
							message_card = card
						}
					elseif not the_latro.table_contains(card.ability.extra.suits_scored, suit) then
						-- SMODS.scale_card(card, {
						-- 	ref_table = card.ability.extra,
						-- 	ref_value = "x_mult",
						-- 	scalar_value = "x_mult_gain",
						-- 	message_key = "a_xmult",
						-- 	message_colour = G.C.MULT
						-- })
						table.insert(card.ability.extra.suits_scored, suit)
						return {
							message = localize {
								type = "variable",
								key = "a_xmult",
								vars = { 1 + (#card.ability.extra.suits_scored * card.ability.extra.x_mult_gain) }
							},
							colour = G.C.MULT,
							message_card = card
						}
					end
				end
			end
		end

		if context.joker_main and #card.ability.extra.suits_scored > 0 then
			return {
				xmult = 1 + (#card.ability.extra.suits_scored * card.ability.extra.x_mult_gain)
			}
		end

		if
			context.end_of_round
			and context.beat_boss
			and context.cardarea == G.jokers
			and not context.blueprint
		then
			card.ability.extra.suits_scored = {}
			return {
				message = localize("k_reset"),
				message_card = card
			}
		end
	end
}

-- Ten Lords a-Leaping
SMODS.Joker {
	key = "tenth_day",
	config = {
		extra = {
			active = false,
			king_one = 0,
			king_two = 0
		}
	},
	rarity = 2,
	cost = 5,
	atlas = "12_days",
	pos = { x = 3, y = 1 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
		if context.before then
			local kings = {}
			for i, v in ipairs(context.scoring_hand) do
				if v:get_rank() == "King" then table.insert(kings, { i, v }) end
			end
			if #kings == 2 then
				card.ability.extra.active = true
				card.ability.extra.king_one = kings[1][1]
				card.ability.extra.king_two = kings[2][1]
			else
				card.ability.extra.active = false
			end
		end

		if
			context.cardarea == G.play
			and context.repetition
			and not context.repetition_only
			and card.ability.extra.active
		then
			local card_idx = -1
			for i, v in pairs(context.scoring_hand) do
				if context.other_card.ID == v.ID then
					card_idx = i
					break
				end
			end
			-- print("card at " .. card_idx)
			if (card_idx > card.ability.extra.king_one) and (card_idx < card.ability.extra.king_two) then
				return {
					message = localize("k_again_ex"),
					repetitions = 1,
					card = context.other_card
				}
			end
		end
	end
}

-- Nine Ladies Dancing

-- Eight Maids a-Milking
SMODS.Joker({
	key = "eighth_day",
	config = {
		extra = {
			cash_per_chips = 8,
			cash_spent = 0,
			chip_gain = 8,
			chips = 0,
		},
	},
	rarity = 1,
	cost = 4,
	atlas = "12_days",
	pos = { x = 1, y = 1 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chip_gain,
				card.ability.extra.cash_per_chips,
				card.ability.extra.chips,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.reroll_shop and not context.blueprint then
			card.ability.extra.cash_spent = card.ability.extra.cash_spent + context.cost
			local ticks = 0
			while card.ability.extra.cash_spent > card.ability.extra.cash_per_chips do
				ticks = ticks + 1
				card.ability.extra.cash_spent = card.ability.extra.cash_spent - card.ability.extra.cash_per_chips
			end
			if ticks > 0 then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "chips",
					scalar_value = "chip_gain",
					operation = function(ref_table, ref_value, initial, scaling)
						ref_table[ref_value] = initial + scaling * ticks
					end,
					scaling_message = {
						message = localize({
							type = "variable",
							key = "a_chips",
							vars = { card.ability.extra.chips + card.ability.extra.chip_gain * ticks },
						}),
						colour = G.C.CHIPS
					},
				})
			end
		end

		if context.joker_main then
			return { chips = card.ability.extra.chips }
		end
	end,
})

-- Seven Swans a-Swimming
SMODS.Joker({
	key = "seventh_day",
	config = {
		extra = {
			needed_sevens = 2,
		},
	},
	rarity = 2,
	cost = 6,
	atlas = "12_days",
	pos = { x = 0, y = 1 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.needed_sevens } }
	end,
	calculate = function(self, card, context)
		if context.after then
			local num_sevens = 0
			for _, v in ipairs(context.scoring_hand) do
				if v:get_id() == 7 and not v.debuff then
					num_sevens = num_sevens + 1
				end
			end
			if num_sevens >= card.ability.extra.needed_sevens then
				local destroyable_cards = {}
				for _, v in ipairs(G.hand.cards) do
					if v:get_id() ~= 7 then
						destroyable_cards[#destroyable_cards + 1] = v
					end
				end
				if #destroyable_cards > 0 then
					local dead_card = pseudorandom_element(destroyable_cards, "swan_attack", {})
					SMODS.destroy_cards(dead_card)
					return {
						message = localize("k_attacked_ex"),
						colour = G.C.RED,
					}
				end
			end
		end
	end,
})

-- Six Geese a-Laying
SMODS.Joker({
	key = "sixth_day",
	config = {
		extra = {
			sixes_scored = 0,
		},
	},
	rarity = 2,
	cost = 6,
	atlas = "12_days",
	pos = { x = 5, y = 0 },
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.sixes_scored,
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			if
				SMODS.in_scoring(context.other_card, context.scoring_hand)
				and context.other_card:get_id() == 6
				and not context.other_card.debuff
			then
				card.ability.extra.sixes_scored = card.ability.extra.sixes_scored + 1
			end
		end
		if context.end_of_round and not context.blueprint and card.ability.extra.sixes_scored > 0 then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "extra_value",
				scalar_table = card.ability.extra,
				scalar_value = "sixes_scored",
				scaling_message = {
					message = localize("k_val_up"),
					colour = G.C.MONEY,
				},
			})
			card:set_cost()
			card.ability.extra.sixes_scored = 0
		end
	end,
})

-- ~ FIVE GOLDEN RIIIINGS ~
SMODS.Joker({
	key = "fifth_day",
	config = {
		extra = {
			fives_held = 0,
		},
	},
	rarity = 2,
	cost = 5,
	atlas = "12_days",
	pos = { x = 4, y = 0 },
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint and card.ability.extra.fives_held == 0 then
			for _, held_card in ipairs(G.hand.cards) do
				if held_card:get_id() == 5 and not held_card.debuff then
					card.ability.extra.fives_held = card.ability.extra.fives_held + 1
				end
			end
			-- print(card.ability.extra.fives_held)
			G.GAME.interest_cap = G.GAME.interest_cap + (5 * card.ability.extra.fives_held)
		end
		if context.starting_shop and not context.blueprint then
			G.GAME.interest_cap = G.GAME.interest_cap - (5 * card.ability.extra.fives_held)
			card.ability.extra.fives_held = 0
		end
	end,
})

-- Four Calling Birds
SMODS.Joker({
	key = "fourth_day",
	rarity = 2,
	cost = 5,
	atlas = "12_days",
	pos = { x = 3, y = 0 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if
				context.other_card:get_id() == 4
				and SMODS.in_scoring(context.other_card, context.scoring_hand)
				and not context.other_card.debuff
			then
				draw_card(G.deck, G.hand)
			end
		end
	end,
})

-- Three French Hens
SMODS.Joker {
	key = "third_day",
	config = {
		extra = {
			mult = 3
		}
	},
	rarity = 1,
	cost = 3,
	atlas = "12_days",
	pos = { x = 2, y = 0 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if SMODS.in_scoring(context.other_card, context.scoring_hand)
				and context.other_card:get_id() == 3
				and not context.other_card.debuff then
				local threes = 0
				for _, v in ipairs(context.scoring_hand) do
					if v:get_id() == 3
						and not v.debuff then
						threes = threes + 1
					end
				end
				return {
					mult = card.ability.extra.mult * threes
				}
			end
		end
	end
}

-- Two Turtle Doves
SMODS.Joker {
	key = "second_day",
	rarity = 1,
	cost = 4,
	atlas = "12_days",
	pos = { x = 1, y = 0 },
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				localize("Two Pair", "poker_hands")
			}
		}
	end,
	calculate = function(self, card, context)
		if context.after and context.scoring_name == "Two Pair" and not context.blueprint then
			local pair_table = {}
			for _, v in ipairs(context.scoring_hand) do
				local card_rank = v:get_rank()
				if card_rank ~= "None" then
					if pair_table[card_rank] and type(pair_table[card_rank]) == "table" then
						table.insert(pair_table[card_rank], v)
					else
						pair_table[card_rank] = { v }
					end
				end
			end
			local gifted_cards = {}
			for _, v in pairs(pair_table) do
				if #v >= 2 then
					gifted_cards[#gifted_cards + 1] = pseudorandom_element(v, "thel_2nd", {})
				end
			end

			G.E_MANAGER:add_event(Event({
				func = function()
					card:juice_up()
					return true
				end
			}))
			the_latro.flip_cards(gifted_cards)
			for _, v in ipairs(gifted_cards) do
				local enhanced_with = SMODS.poll_enhancement { guaranteed = true }
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.15,
					func = function()
						v:set_ability(enhanced_with)
						v:juice_up()
						return true
					end
				}))
			end
			the_latro.unflip_cards(gifted_cards)
			delay(0.5)
		end
	end
}
-- and
-- A Partridge in a Pear Tree
SMODS.Joker({
	key = "first_day",
	rarity = 3,
	cost = 7,
	atlas = "12_days",
	pos = { x = 0, y = 0 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				localize("Pair", "poker_hands"),
			}
		}
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			local num_pairs = 0
			for k, _ in pairs(SMODS.Ranks) do
				local num_cards_of_rank = 0
				for _, this_card in ipairs(context.scoring_hand) do
					if not SMODS.has_no_rank(this_card) then
						if this_card.config.card.value == k then
							num_cards_of_rank = num_cards_of_rank + 1
						end
					end
				end
				if num_cards_of_rank >= 2 then
					num_pairs = num_pairs + 1
				end
			end
			if num_pairs > 0 then
				for i = 1, math.min(num_pairs, G.consumeables.config.card_limit - #G.consumeables.cards) do
					local type = the_latro.weighted_pick({ { "Tarot", 45 }, { "Planet", 45 }, { "Spectral", 10 } })
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.4,
						func = function()
							if G.consumeables.config.card_limit > #G.consumeables.cards then
								play_sound("timpani")
								SMODS.add_card({ set = type, area = G.consumeables })
								card:juice_up(0.3, 0.5)
							end
							return true
						end,
					}))
				end
			end
		end
	end,
})

--#endregion
