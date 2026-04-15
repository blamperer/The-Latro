-- Possible Talisman compat
the_latro.big = function(x)
	return (Talisman and to_big(x)) or x
end
the_latro.num = function(x)
	return (Talisman and to_number(x)) or x
end

local JOKER_FILES = {
	"misc_jokers",
	"zodiac_jokers",
	"christmas_jokers"
}

for _, file_name in ipairs(JOKER_FILES) do
	local func, err = SMODS.load_file("data/jokers/" .. file_name .. ".lua")
	if err then
		sendErrorMessage(err, "The Latro")
	else
		func()
	end
end
