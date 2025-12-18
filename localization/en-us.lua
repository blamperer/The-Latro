return {
	descriptions = {
		Back = {
			b_thel_completionist = {
				name = "Completionist Deck",
				text = {
					"Get an {C:eternal}Eternal {C:dark_edition}Negative{} copy",
					"of a Joker without a",
					"sticker for {C:attention}this stake{}",
				},
			},
		},
		-- Blind={},
		-- Edition={},
		-- Enhanced={},
		Joker = {
			j_thel_misfortune = {
				name = "Misfortune",
				text = {
					"Played {C:attention}Lucky{} cards give",
					"{X:mult,C:white}X#1#{} Mult while none",
					"have activated",
				},
			},
			j_thel_blank_joker = {
				name = "Blank Joker",
				text = {
					"{C:inactive}Does nothing?",
				},
			},
			j_thel_blank_joker_alt = {
				name = "Antijoker",
				text = {
					"+#1# Joker slots and",
					"one more every #2# rounds",
					"{C:inactive}({C:attention}#3#{C:inactive}/#2#)",
				},
			},
			j_thel_terminal = {
				name = "Terminal",
				text = {
					"{C:green}#1# in #2#{} chance to",
					"retrigger other Jokers",
				},
			},
			j_thel_chipfinity = {
				name = "Chipfinity",
				text = {
					"This Joker gains {C:chips}+#1#{} Chip",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
				},
			},
			j_thel_uppydowny = {
				name = "Uppy-Downy",
				text = {
					"The {C:attention}last{} played card",
					"steals one rank from",
					"the {C:attention}first{} played card",
				},
			},
			j_thel_helper_robot = {
				name = "Helper Robot",
				text = {
					"{C:blue}+1{} free hand,",
					"{C:attention}played for you!",
					'{B:1,V:2} "#1#" ^v^ ',
				},
			},
			j_thel_normalsize = {
				name = "Normal-Sized Joker",
				text = { "{C:chips}+4{} Mult?" },
			},
			j_thel_quest_log_none = {
				name = "Quest Log",
				text = {
					"Earn {C:money}$#1#{} by playing a card",
					"of the {C:important}indicated type",
					"{C:inactive}(Requirement changes on payout)",
				},
			},
			j_thel_quest_log_rank = {
				name = "Quest Log",
				text = {
					"Earn {C:money}$#1#{} if you play",
					"a card of rank {V:1}#2#",
					"{C:inactive}(Requirement changes on payout)",
				},
			},
			j_thel_quest_log_rank_none = {
				name = "Quest Log",
				text = {
					"Earn {C:money}$#1#{} if you play",
					"a card with {V:1}#2#{} rank",
					"{C:inactive}(Requirement changes on payout)",
				},
			},
			j_thel_quest_log_suit = {
				name = "Quest Log",
				text = {
					"Earn {C:money}$#1#{} if you play",
					"a card with {V:1}#2#{} suit",
					"{C:inactive}(Requirement changes on payout)",
				},
			},
			j_thel_interloper = {
				name = "Interloper",
				text = {
					"When played hand is an",
					'{C:attention}"X of a Kind"{}, add a {C:attention}random',
					"{C:attention}card{} of the {C:attention}same rank{}",
					"and {C:blue}score it{} as well",
				},
			},
						--region ZODIAC JOKERS
			j_thel_aries = {
				name = "Aries",
				text = {
					"{X:mult,C:white}X#1#{} Mult while fighting",
					"a {C:attention}Boss Blind",
				},
			},
			j_thel_taurus = {
				name = "Taurus",
				text = {
					"This Joker gains {X:mult,C:white}X#1#{} Mult",
					"for every {C:money}$#2#{} spent in the Shop",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
				},
			},
			j_thel_gemini = {
				name = "Gemini",
				text = {
					"This Joker flips between giving",
					"{C:chips}+#1#{} Chips or {X:mult,C:white}X#2#{} Mult if",
					"played hand contains a {C:attention}Two Pair{}",
				},
			},
			j_thel_cancer = {
				name = "Cancer",
				text = {
					"This Joker gains {C:mult}+#1#{} Mult",
					"when a {C:attention}Glass Card{} scores",
					"and {C:attention}resets{} if one breaks",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
			},
			j_thel_leo = {
				name = "Leo",
				text = {
					"{C:attention}Lucky Cards{} which trigger",
					"also give {C:chips}+#1#{} Chips",
				},
			},
			j_thel_virgo = {
				name = "Virgo",
				text = {
					"Played {C:attention}Queens{}",
					"give {X:mult,C:white}X#1#{} Mult",
				},
			},
			j_thel_libra = {
				name = "Libra",
				text = {
					"Played hands with exactly",
					"{C:attention}two suits{} give",
					"{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
				},
			},
			j_thel_scorpio = {
				name = "Scorpio",
				text = {
					"{C:green}#1# in #2#{} chance to add",
					"a {C:money}Gold Seal{} to {C:attention}1{} selected card",
					"after using {C:attention}any consumable",
					"{C:inactive,S:0.8}(Won't overwrite)",
				},
			},
			j_thel_sagittarius = {
				name = "Sagittarius",
				text = {
					"If all scored cards are {C:spades}Spades{},",
					"{C:green}#1# in #2#{} chance for each",
					"one to become {C:dark_edition}Foil",
				},
			},
			j_thel_capricorn = {
				name = "Capricorn",
				text = {
					"Retrigger all",
					"played {C:attention}Stone Cards",
				},
			},
			j_thel_aquarius = {
				name = "Aquarius",
				text = {
					"This Joker gains {C:chips}+#1#{} Chips for",
					"each played {C:chips}Bonus Card{}",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
				},
			},
			j_thel_pisces = {
				name = "Pisces",
				text = {
					"This Joker gains {C:chips}+#1#{} Chips",
					"for every {C:attention}Tag{} used",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
				},
			},
			j_thel_ophiuchus = {
				name = "Ophiuchus",
				text = {
					"{C:dark_edition}Polychrome{} Jokers give",
					"{X:mult,C:white}X#1#{} Mult",
				},
			},
			--endregion
			--region 12 DAYS OF CHRISTMAS
			j_thel_first_day = {
				name = "Partridge in a Pair Tree",
				text = {
					"Creates {C:attention}1 Consumable",
					"card for every {C:attention}#1#",
					"in played hand",
					"{C:inactive}(Must have room)",
				},
			},
			j_thel_second_day = {
				name = "Two Turtle Doves",
				text = {
					"If played hand is {C:attention}#1#,",
					"one card from each pair",
					"gains a random {C:attention}enhancement"
				}
			},
			j_thel_fourth_day = {
				name = "Four Calling Birds",
				text = {
					"When a {C:attention}4{} is scored,",
					"draw a card to hand",
				},
			},
			j_thel_fifth_day = {
				name = "Five Golden Rings",
				text = {
					"Each {C:attention}5{} held in hand",
					"at end of round",
					"lets you earn an",
					"additional {C:money}$1{} of interest",
				},
			},
			j_thel_sixth_day = {
				name = "Six Geese a-Laying",
				text = {
					"This Joker gains {C:money}$1{} of",
					"{C:attention}sell value{} at end of round",
					"for every {C:attention}6{} scored this round",
					"{C:inactive}(Will gain {C:money}$#1#{C:inactive})",
				},
			},
			j_thel_seventh_day = {
				name = "Seven Swans a-Swimming",
				text = {
					"If played hand has",
					"{C:attention}#1# or more{} scoring {C:attention}7s{},",
					"destroy a random card",
					"{C:red}without{} rank 7 in hand",
				},
			},
			j_thel_eighth_day = {
				name = "Eight Maids a-Milking",
				text = {
					"This Joker gains {C:chips}+#1#{} Chips for every",
					"{C:money}$#2#{} spent rerolling in the shop",
					"{C:inactive}(Currently {C:chips}+#3# {C:inactive}Chips)"
				}
			},
			--endregion
		},
		-- Other={},
		-- Planet={},
		-- Spectral={},
		-- Stake={},
		-- Tag={},
		-- Tarot={},
		-- Voucher={},
	},
	misc = {
		-- achievement_descriptions={},
		-- achievement_names={},
		-- blind_states={},
		challenge_names = {
			c_thel_autopilot = "Autopilot",
		},
		-- collabs={},
		dictionary = {
			k_gilded_ex = "Gilded!",
			k_knapped_ex = "Knapped!",
			k_attacked_ex = "Attacked!"
		},
		-- high_scores={},
		-- labels={},
		-- poker_hand_descriptions={},
		-- poker_hands={},
		-- quips={},
		-- ranks={},
		-- suits_plural={},
		-- suits_singular={},
		-- tutorial={},
		v_dictionary = {
			indicate_rank = "Rank: #1#",
			indicate_suit = "Suit: #1#",
		},
		-- v_text={},
	},
}
