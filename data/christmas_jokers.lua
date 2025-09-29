SMODS.Atlas({
	key = "12_days",
	path = "12_days.png",
	px = 71,
	py = 95,
})

--#region On the 12th day of Christmas, my true love gave to me,

-- Twelve Drummers Drumming

-- Eleven Pipers Piping

-- Ten Lords a-Leaping

-- Nine Ladies Dancing

-- Eight Maids a-Milking

-- Seven Swans a-Swimming

-- Six Geese a-Laying

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
				if held_card:get_id() == 5 then
					card.ability.extra.fives_held = card.ability.extra.fives_held + 1
				end
			end
			print(card.ability.extra.fives_held)
			G.GAME.interest_cap = G.GAME.interest_cap + (5 * card.ability.extra.fives_held)
		end
		if context.starting_shop then
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
		if context.individual then
			if context.other_card:get_id() == 4 then
				draw_card(G.deck, G.hand)
			end
		end
	end,
})

-- Three French Hens

-- Two Turtle Doves

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
		return { vars = {
			localize("Pair", "poker_hands"),
		} }
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
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.4,
						func = function()
							if G.consumeables.config.card_limit > #G.consumeables.cards then
								play_sound("timpani")
								SMODS.add_card({ set = "Tarot", area = G.consumeables })
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
