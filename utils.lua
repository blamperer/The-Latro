function Card:get_suit()
	if SMODS.has_any_suit(self) then
		return "Wild"
	elseif SMODS.has_no_suit(self) then
		return "None"
	else
		return self.base.suit
	end
end

---@param table table
---@param value any
function the_latro.table_contains(table, value)
	for i = 1, #table do
		if table[i] == value then
			return true
		end
	end
	return false
end

---@param list table
---@param start_idx integer?
---@param end_idx integer?
function the_latro.slice(list, start_idx, end_idx)
	local _new_list = {}
	for i = (start_idx or 1), (end_idx or #list) do
		table.insert(_new_list, list[i])
	end
	return _new_list
end

---@param proportional boolean?
function the_latro.rank_in_deck(proportional)
	local ranks = {}
	for _, card in ipairs(G.playing_cards) do
		if not SMODS.has_no_rank(card) then
			local rank = card.config.card.value
			if proportional or not the_latro.table_contains(ranks, rank) then
				ranks[#ranks + 1] = rank
			end
		end
	end
	if #ranks > 0 then
		local choice, _ = pseudorandom_element(ranks, "thel_random_rank", {})
		return choice
	else
		return "Ace"
	end
end

---@param proportional boolean?
function the_latro.suit_in_deck(proportional)
	local suits = {}
	for _, card in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(card) then
			local suit = card.config.card.suit
			if proportional or not the_latro.table_contains(suits, suit) then
				suits[#suits + 1] = suit
			end
		end
	end
	if #suits > 0 then
		local choice, _ = pseudorandom_element(suits, "thel_random_suit", {})
		return choice
	else
		return "Spades"
	end
end

---@param entries table A table of (item, weight) pairs. As long as the weight is the second one.
function the_latro.weighted_pick(entries)
	local total_weight = 0.0
	for _, v in ipairs(entries) do
		total_weight = total_weight + v[2]
	end
	local x = pseudorandom("the_latro")
	for _, v in ipairs(entries) do
		local pick_chance = v[2] / total_weight
		if pick_chance > x then
			return v[1]
		else
			x = x - pick_chance
		end
	end
end

-- Yoink these straight from the base game

function the_latro.flip_cards(cards)
	if not type(cards) == "table" then
		cards = { cards }
	end
	for i = 1, #cards do
		local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				cards[i]:flip()
				play_sound("card1", percent)
				cards[i]:juice_up(0.3, 0.3)
				return true
			end,
		}))
	end
end
function the_latro.unflip_cards(cards)
	if not type(cards) == "table" then
		cards = { cards }
	end
	for i = 1, #cards do
		local percent = 0.85 + (i - 0.999) / (#cards - 0.998) * 0.3
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				cards[i]:flip()
				play_sound("tarot2", percent, 0.6)
				cards[i]:juice_up(0.3, 0.3)
				return true
			end,
		}))
	end
end
