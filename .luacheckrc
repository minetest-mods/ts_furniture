std = "lua51+luajit+minetest+spawnit"
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

stds.spawnit = {
	globals = {
		"ts_furniture",
		player_api = {fields = {"player_attached"}},
	},
	read_globals = {
	    "player_api",
	},
}
