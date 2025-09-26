SMODS.Atlas({
	key = "deck_backs",
	path = "deck_backs.png",
	px = 71,
	py = 95,
})

SMODS.Back({
	key = "completionist",
	atlas = "deck_backs",
	pos = { x = 0, y = 0 },

	apply = function(self)
		local preferable_jokers = {}
		local unpreferable_jokers = {}
		local very_unpreferable_jokers = {}
		local all_jokers = {}

		-- Loop over every Joker. Surely this is a good idea.
		sendInfoMessage("Checking for " .. SMODS.stake_from_index(G.GAME.stake) .. " stickers...", "The Latro")
		for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
			if v and v.unlocked and v.discovered then
				if get_joker_win_sticker(v, true) < G.GAME.stake then
					if v.eternal_compat then
						table.insert(preferable_jokers, v.key)
					elseif not v.perishable_compat then
						table.insert(unpreferable_jokers, v.key)
					else
						table.insert(very_unpreferable_jokers, v.key)
					end
				end
				table.insert(all_jokers, v.key)
			end
		end

		sendInfoMessage("Found " .. tostring(#preferable_jokers + #unpreferable_jokers + #very_unpreferable_jokers) .. " Jokers!", "The Latro")

		local your_free_joker, idx
		if #preferable_jokers > 0 then
			your_free_joker, idx = pseudorandom_element(preferable_jokers, pseudoseed("completionist"))
		elseif #unpreferable_jokers > 0 then
			your_free_joker, idx = pseudorandom_element(unpreferable_jokers, pseudoseed("completionist"))
		elseif #very_unpreferable_jokers > 0 then
			your_free_joker, idx = pseudorandom_element(very_unpreferable_jokers, pseudoseed("completionist"))
		else
			sendInfoMessage("Wow! You've used every discovered Joker for this stake! Choosing randomly!", "The Latro")
			-- For some reason, it really didn't like me just plugging G.P_CENTER_POOLS["Joker"] in here, so we use a new list
			your_free_joker, idx = pseudorandom_element(all_jokers, pseudoseed("fully_completed"))
		end

		your_free_joker = tostring(your_free_joker) -- satisfy the parser
		local joker_name = (not string.find(your_free_joker, "^j_")) and G.P_CENTERS[your_free_joker].name
			or localize({ type = "name_text", set = "Joker", key = your_free_joker })
		sendInfoMessage("Chose Joker #" .. idx .. ": " .. joker_name .. "!", "The Latro")

		G.E_MANAGER:add_event(Event({
			func = function()
				SMODS.add_card({
					set = "Joker",
					area = G.jokers,
					key = your_free_joker,
					edition = "e_negative",
					stickers = {
						"eternal",
					},
					force_stickers = true
				})
				return true
			end,
		}))
	end,
})
