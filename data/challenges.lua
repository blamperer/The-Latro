-- Create test challenge
-- SMODS.Challenge {
--     key = "test_challenge",
--     loc_txt = { name = "Test Challenge" },
--     jokers = {
--         { id = "j_thel_cancer" },
--     },
--     deck = {
--         type = "Challenge Deck",
--         enhancement = "m_glass"
--     }
-- }

-- Autopilot
SMODS.Challenge({
	key = "autopilot",
	jokers = {
		{ id = "j_thel_helper_robot", edition = "negative", eternal = true },
		{ id = "j_thel_helper_robot", edition = "negative", eternal = true },
		{ id = "j_thel_helper_robot", edition = "negative", eternal = true },
		{ id = "j_thel_helper_robot", edition = "negative", eternal = true },
	},
	deck = { type = "Challenge Deck" },
	rules = {
		modifiers = {
			{ id = "hands", value = 0 },
			{ id = "discards", value = 0 },
		},
	},
})
