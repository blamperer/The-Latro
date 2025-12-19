the_latro = SMODS.current_mod
the_latro.optional_features = {
	retrigger_joker = true,
}

SMODS.Atlas {
	key = "modicon",
	path = "modicon.png",
	px = 34,
	py = 34
}

SMODS.load_file("utils.lua")()

-- Jokers
SMODS.load_file("data/jokers.lua")()

-- Decks
SMODS.load_file("data/decks.lua")()

-- Challenges
SMODS.load_file("data/challenges.lua")()

sendInfoMessage("who up multin they mult", "The Latro")
