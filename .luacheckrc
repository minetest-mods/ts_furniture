std = "lua51+luajit+minetest+ts_furniture"
unused_args = false
max_line_length = 120

stds.minetest = {
	read_globals = {
		"DIR_DELIM",
		"dump",
		"dump2",
		"INIT",

		"math",
		"table",
		"string",
		"vector",

		"ItemStack",
		"PerlinNoise",
		"PerlinNoiseMap",
		"PseudoRandom",
		"PcgRandom",
		"SecureRandom",
		"Settings",
		"VoxelArea",
		"VoxelManip",

		"minetest",
	}
}

stds.ts_furniture = {
	globals = {
		"ts_furniture",
		player_api = {fields = {"player_attached"}},
	},
	read_globals = {
	    "more_player_monoids",
	    "player_api",
	    "player_monoids",
	},
}
