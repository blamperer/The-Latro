SMODS.Atlas({
	key = "the_jokers",
	path = "the_jokers.png",
	px = 71,
	py = 95,
})
SMODS.Atlas({
	key = "normalsize",
	path = "normalsize.png",
	px = 75,
	py = 91,
})

-- Possible Talisman compat
local function big(x)
	return (Talisman and to_big(x)) or x
end
local function num(x)
	return (Talisman and to_number(x)) or x
end

--#region JOKERS
-- Misfortune
SMODS.Joker({
	key = "misfortune",
	config = {
		extra = {
			x_mult = 1.25,
			should_score = true,
		},
	},
	rarity = 2,
	cost = 7,
	atlas = "the_jokers",
	pos = { x = 0, y = 0 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
		return { vars = { card.ability.extra.x_mult } }
	end,
	enhancement_gate = "m_lucky",
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.lucky_trigger then
				card.ability.extra.should_score = false
			end
			if card.ability.extra.should_score and context.other_card.ability.effect == "Lucky Card" then
				return { xmult = card.ability.extra.x_mult }
			end
		elseif context.after and context.cardarea == G.jokers then
			card.ability.extra.should_score = true
		end
	end,
})

-- Blank Joker
SMODS.Joker({
	key = "blank_joker",
	config = {
		extra = {
			rounds_held = 0,
			waiting_period = 5,
			extra_slots = 0,
		},
	},
	rarity = 1,
	cost = 5,
	atlas = "the_jokers",
	pos = { x = 2, y = 0 },
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.extra_slots,
				card.ability.extra.waiting_period,
				card.ability.extra.rounds_held,
			},
			key = self.key .. (card.ability.extra.extra_slots > 0 and "_alt" or ""),
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.extra.rounds_held = card.ability.extra.rounds_held + 1
			if card.ability.extra.rounds_held == card.ability.extra.waiting_period then
				G.E_MANAGER:add_event(Event({
					func = function()
						card.ability.extra.rounds_held = 0
						card.ability.extra.extra_slots = card.ability.extra.extra_slots + 1
						if not card.edition or (card.edition.key ~= "e_negative") then
							card:set_edition("e_negative")
						else
							G.jokers.config.card_limit = G.jokers.config.card_limit + 1
						end
						return true
					end,
				}))
				return {
					message = localize("k_upgrade_ex"),
				}
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff then
			G.jokers.config.card_limit = G.jokers.config.card_limit - math.max(0, card.ability.extra.extra_slots - 1)
		end
	end,
})

-- Terminal
SMODS.Joker({
	key = "terminal",
	config = {
		extra = {
			odds = 10,
		},
	},
	rarity = 1,
	cost = 5,
	atlas = "the_jokers",
	pos = { x = 3, y = 0 },
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.odds) } }
	end,
	calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
			if SMODS.pseudorandom_probability(card, "terminal", 1, card.ability.extra.odds, "terminal") then
				return {
					message = localize("k_again_ex"),
					repetitions = 1,
					card = self,
				}
			else
				return nil, true
			end
		end
	end,
})

-- Chipfinity
SMODS.Joker({
	key = "chipfinity",
	config = {
		extra = {
			chip_gain = 1,
			chips = 0,
		},
	},
	rarity = 4,
	cost = 20,
	atlas = "the_jokers",
	pos = { x = 4, y = 0 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chip_gain,
				card.ability.extra.chips,
			}
		}
	end,
	calculate = function(self, card, context)
		card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
		if context.joker_main then
			return { chips = card.ability.extra.chips }
		end
	end,
})

-- Uppy-Downy
SMODS.Joker({
	key = "uppydowny",
	rarity = 2,
	cost = 5,
	atlas = "the_jokers",
	pos = { x = 0, y = 1 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
		if context.after then
			if #context.full_hand <= 1 then
				return
			end

			local last_played = context.full_hand[#context.full_hand]
			local first_played = context.full_hand[1]
			local both_cards = { last_played, first_played }

			the_latro.flip_cards(both_cards)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.3,
				func = function()
					assert(SMODS.modify_rank(first_played, -1))
					assert(SMODS.modify_rank(last_played, 1))
					return true
				end,
			}))
			the_latro.unflip_cards(both_cards)
			delay(2)
		end
	end,
})

-- Helper Robot
SMODS.Joker({
	key = "helper_robot",
	config = {
		extra = {
			hands = 1,
			activated = false,
			helping = false,
		},
	},
	rarity = 2,
	cost = 7,
	atlas = "the_jokers",
	pos = { x = 5, y = 0 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.activated and "You're welcome!" or "Ready to help!",
				colours = { HEX("374244"), HEX("ffef3e") },
			},
		}
	end,
	calculate = function(self, card, context)
		-- local should_trigger = function()
		-- 	for i, v in ipairs(G.jokers.cards) do
		-- 		if v.config.center_key == "j_thel_helper_robot" then
		-- 			if not (v.ability.extra.activated or v.ability.extra.helping) then
		-- 				return v == card
		-- 			end
		-- 		end
		-- 	end
		-- 	return false
		-- end

		if context.setting_blind and context.cardarea == G.jokers then
			G.GAME.current_round.helper_queue[#G.GAME.current_round.helper_queue + 1] = card.ID
		end

		if context.hand_drawn and context.cardarea == G.jokers then
			if G.GAME.current_round.helper_queue[1] == card.ID then
				-- print(card.ID .. " helping!")
				-- Select as many cards as possible
				-- Weirdly janky. Why are they invisible. Done messing with it b/c it works now.
				card.ability.extra.helping = true
				G.E_MANAGER:add_event(Event({
					func = function()
						local cards_to_select = math.min(#G.hand.cards, G.GAME.starting_params.play_limit) -
						#G.hand.highlighted
						local eligible_cards = G.hand.cards
						local forced_cards = {}
						for i = cards_to_select, 1, -1 do
							local valid = false
							local force_card, idx
							while not valid and #eligible_cards > 0 do
								force_card, idx = pseudorandom_element(eligible_cards, pseudoseed("helper_robot"))
								table.remove(eligible_cards, tonumber(idx))
								if not force_card.ability.forced_selection then
									valid = true
								end
							end
							if #eligible_cards <= 0 then
								break
							end
							forced_cards[#forced_cards + 1] = force_card
							-- force_card.ability.forced_selection = true
							-- G.hand:add_to_highlighted(force_card)
						end
						-- print(card.ID .. " playing!")
						G.hand.highlighted = forced_cards
						G.FUNCS.play_cards_from_highlighted(G.HUD:get_UIE_by_ID("play_button"))
						return true
					end
				}))
			end
		end
		if
			context.after
			and context.cardarea == G.jokers
			and card.ability.extra.helping
			and not card.ability.extra.activated
		then
			-- print(card.ID .. " done!")
			card.ability.extra.activated = true
			G.hand:unhighlight_all()
			if G.GAME.current_round.helper_queue[1] == card.ID then
				table.remove(G.GAME.current_round.helper_queue, 1)
			end
		end
		if context.end_of_round and context.cardarea == G.jokers then
			card.ability.extra.helping = false
			card.ability.extra.activated = false
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
		ease_hands_played(1)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
		if not card.ability.extra.activated then
			ease_hands_played(-1)
		end
	end,
})

-- Normal-Sized Joker
SMODS.Joker({
	key = "normalsize",
	rarity = 1,
	cost = 2,
	atlas = "normalsize",
	pos = { x = 0, y = 0 },
	-- pixel_size = {w = 75, h = 91},
	display_size = { w = 75, h = 91 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
		if context.joker_main then
			-- Apparently these are just global? Thanks Paperback
			local current_chips = hand_chips
			local current_mult = math.abs(mult) > big(1e-9) and mult or big(1e-9) -- Divide by 0 prevention
			local new_chips = (current_chips * (current_mult + 4)) / current_mult
			local added_chips = math.floor(new_chips - current_chips)
			if added_chips >= big(1) then
				return { chips = added_chips }
			end
		end
	end,
})

-- Quest Log
SMODS.Joker({
	key = "quest_log",
	config = {
		extra = {
			prize = 1,
			quest_type = "none",
			rank_in_question = "Ace",
			suit_in_question = "Spades",
		},
	},
	rarity = 1,
	cost = 5,
	atlas = "the_jokers",
	pos = { x = 1, y = 1 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		local indicated_thing = ""
		local proper_color = G.C.FILTER
		local text_flavor = "none"

		if card.ability.extra.quest_type == "rank" then
			if card.ability.extra.rank_in_question == "None" then
				indicated_thing = "no"
				text_flavor = "rank_none"
			else
				indicated_thing = tostring(card.ability.extra.rank_in_question)
				text_flavor = "rank"
			end
		elseif card.ability.extra.quest_type == "suit" then
			text_flavor = "suit"
			if card.ability.extra.suit_in_question == "None" then
				indicated_thing = "no"
			else
				indicated_thing = localize(card.ability.extra.suit_in_question, "suits_singular")
				proper_color = G.C.SUITS[card.ability.extra.suit_in_question]
			end
		end

		return {
			vars = {
				card.ability.extra.prize,
				-- card.ability.extra.quest_type == "rank" and card.ability.extra.rank_in_question
				-- or localize(card.ability.extra.suit_in_question, "suits_singular"),
				-- colours = {
				-- 	card.ability.extra.quest_type == "suit" and G.C.SUITS[card.ability.extra.suit_in_question]
				-- 	or G.C.FILTER,
				-- },
				indicated_thing,
				colours = { proper_color }
			},
			key = self.key .. "_" .. text_flavor,
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			card.ability.extra.rank_in_question = the_latro.rank_in_deck(false)
			card.ability.extra.quest_type = "rank"
		end
	end,
	calculate = function(self, card, context)
		local flip_quest = function()
			if card.ability.extra.quest_type == "rank" then
				card.ability.extra.quest_type = "suit"
				card.ability.extra.suit_in_question = the_latro.suit_in_deck(false)
			elseif card.ability.extra.quest_type == "suit" then
				card.ability.extra.quest_type = "rank"
				card.ability.extra.rank_in_question = the_latro.rank_in_deck(false)
			end
		end

		-- Earn reward for indicated card
		if context.individual and context.cardarea == G.play then
			local this_card = context.other_card or {}
			if
				card.ability.extra.quest_type == "rank" and
				(
					(this_card.config.card.value == card.ability.extra.rank_in_question)
					or
					(card.ability.extra.rank_in_question == "None" and SMODS.has_no_rank(this_card))
				)
			then
				flip_quest()
				SMODS.calculate_effect({ dollars = card.ability.extra.prize }, card)
				return {
					message = localize({
						type = "variable",
						key = "indicate_suit",
						vars = {
							card.ability.extra.suit_in_question == "None" and "None" or
							localize(card.ability.extra.suit_in_question, "suits_plural")
						},
					}),
					message_card = card,
				}
			elseif
				card.ability.extra.quest_type == "suit"
				and this_card:get_suit() == card.ability.extra.suit_in_question
			then
				flip_quest()
				SMODS.calculate_effect({ dollars = card.ability.extra.prize }, card)
				return {
					message = localize({
						type = "variable",
						key = "indicate_rank",
						vars = {
							card.ability.extra.rank_in_question == "None" and "None" or
							localize(card.ability.extra.rank_in_question, "ranks")
						},
					}),
					message_card = card,
				}
			end
		end

		-- Don't get stuck on something you don't have
		if context.end_of_round and context.cardarea == G.jokers then
			local count = 0
			for _, v in ipairs(G.playing_cards) do
				if (card.ability.extra.quest_type == "rank" and (v.config.card.value == card.ability.extra.rank_in_question and (not SMODS.has_no_rank(v))))
				then
					count = count + 1
				elseif (card.ability.extra.quest_type == "suit" and v:is_suit(card.ability.extra.suit_in_question, false, true))
				then
					count = count + 1
				end
			end

			if count == 0 then
				if card.ability.extra.quest_type == "rank" then
					card.ability.extra.rank_in_question = the_latro.rank_in_deck(false)
					return {
						message = localize({
							type = "variable",
							key = "indicate_rank",
							vars = { localize(card.ability.extra.rank_in_question, "ranks") },
						}),
						message_card = card,
					}
				elseif card.ability.extra.quest_type == "suit" then
					card.ability.extra.suit_in_question = the_latro.suit_in_deck(false)
					return {
						message = localize({
							type = "variable",
							key = "indicate_suit",
							vars = { localize(card.ability.extra.suit_in_question, "suits_plural") },
						}),
						message_card = card,
					}
				end
			end
		end
	end,
})

-- Interloper
SMODS.Joker({
	key = "interloper",
	rarity = 2,
	cost = 5,
	atlas = "the_jokers",
	pos = { x = 2, y = 1 },
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
		if context.before then -- and context.cardarea == G.play then
			if
				(not next(context.poker_hands["Full House"]))
				and (
					next(context.poker_hands["Five of a Kind"])
					or next(context.poker_hands["Four of a Kind"])
					or next(context.poker_hands["Three of a Kind"])
				)
			then
				-- Get rank
				local ranks = {}
				for _, _c in ipairs(context.scoring_hand) do
					local _r = _c.config.card.value
					ranks[_r] = (ranks[_r] or 0) + 1
				end
				local rank, max = "2", 0
				for _r, x in pairs(ranks) do
					if x > max then
						rank, max = _r, x
					end
				end
				-- Interlope
				local interloping_card = SMODS.add_card({
					rank = rank,
					enhancement = SMODS.poll_enhancement({ mod = 1.25 }),
					edition = SMODS.poll_edition({}),
					seal = SMODS.poll_seal({ mod = 1.1 }),
					area = G.play,
				})
				interloping_card:start_materialize({ G.C.DARK_EDITION })
				highlight_card(interloping_card, 0, "up")
				context.scoring_hand[#context.scoring_hand + 1] = interloping_card
			end
		end
	end,
})

--#endregion

--region HOOKS
-- local igo_ref = Game.init_game_object
-- function Game:init_game_object()
-- 	local igo = igo_ref(self)
-- 	igo.current_round.helper_queue = {}
-- 	return igo
-- end

--endregion

-- Additional Joker files
SMODS.load_file("data/zodiac_jokers.lua")()
SMODS.load_file("data/christmas_jokers.lua")()
