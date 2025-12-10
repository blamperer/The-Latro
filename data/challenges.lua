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
		{ id = "j_ice_cream" },
	},
	deck = { type = "Challenge Deck" },
	rules = {
		modifiers = {
			{ id = "hands",    value = 0 },
			{ id = "discards", value = 0 },
		},
	},
	restrictions = {
		banned_cards = {
			{ id = "j_banner" },
			{ id = "j_delayed_grat" },
			{ id = "j_burglar" },
			{ id = "j_faceless" },
			{ id = "j_luchador" },
			{ id = "j_mail" },
			{ id = "j_drunkard" },
			{ id = "j_trading" },
			{ id = "j_castle" },
			{ id = "j_troubadour" },
			{ id = "j_merry_andy" },
			{ id = "j_hit_the_road" },
			{ id = "j_burnt" },
			{ id = "j_yorick" },
			{ id = "v_grabber" },
			{ id = "v_nacho_tong" },
			{ id = "v_wasteful" },
			{ id = "v_recyclomancy" },
			{ id = "v_hieroglyph" },
			{ id = "v_petroglyph" }
		},
		banned_tags = {
			{ id = "tag_garbage" }
		}
	}
})
