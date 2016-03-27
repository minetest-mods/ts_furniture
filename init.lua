function register_ts_furniture(mod, name, description, texture)
	local groups = minetest.registered_nodes[mod .. ":" ..name].groups
	local furniture_groups = {}
	for k,v in pairs(groups) do
		if k ~= "wood" then
			furniture_groups[k] = v
		end
	end
	minetest.register_node("ts_furniture:" .. mod .. "_" ..name .. "_table", {
		description = description .. " Table",
		tiles = {texture},
		drawtype = "nodebox",
		sunlight_propagates = true,
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4, -0.3, 0.4,-0.3}, -- foot 1
				{ 0.3,-0.5,-0.4,  0.4, 0.4,-0.3}, -- foot 2
				{-0.4,-0.5, 0.3, -0.3, 0.4, 0.4}, -- foot 3
				{ 0.3,-0.5, 0.3,  0.4, 0.4, 0.4}, -- foot 4
				{-0.5, 0.4,-0.5,  0.5, 0.5, 0.5}, -- table top
			},
		},
		groups = furniture_groups
	})
	minetest.register_craft({
		output = "ts_furniture:" .. mod .. "_" ..name .. "_table",
		recipe = {
			{mod .. ":" .. name, mod .. ":" .. name, mod .. ":" .. name},
			{"group:stick"     , ""                , "group:stick"     },
			{"group:stick"     , ""                , "group:stick"     },
		}
	})

	minetest.register_node("ts_furniture:" .. mod .. "_" .. name .."_chair", {
		description = description .. " Chair",
		tiles = {texture},
		drawtype = "nodebox",
		sunlight_propagates = true,
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.3,-0.5, 0.2, -0.2, 0.5, 0.3}, -- foot 1
				{ 0.2,-0.5, 0.2,  0.3, 0.5, 0.3}, -- foot 2
				{ 0.2,-0.5,-0.3,  0.3,-0.1,-0.2}, -- foot 3
				{-0.3,-0.5,-0.3, -0.2,-0.1,-0.2}, -- foot 4
				{-0.3,-0.1,-0.3,  0.3, 0  , 0.2}, -- seating
				{-0.2, 0.1, 0.25, 0.2, 0.4, 0.26} -- conector 1-2
			},
		},
		groups = furniture_groups
	})
	minetest.register_craft({
		output = "ts_furniture:" .. mod .. "_" ..name .. "_chair",
		recipe = {
			{"group:stick"     , ""                , ""},
			{mod .. ":" .. name, mod .. ":" .. name, ""},
			{"group:stick"     , "group:stick"     , ""},
		}
	})

	minetest.register_node("ts_furniture:" .. mod .. "_" .. name .."_bench", {
		description = description .. " Bench",
		tiles = {texture},
		drawtype = "nodebox",
		sunlight_propagates = true,
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.1, 0,  0.5, 0  , 0.5}, -- seating
				{-0.4, -0.5, 0, -0.3,-0.1, 0.5}, -- foot 1
				{ 0.3, -0.5, 0,  0.4,-0.1, 0.5}, -- foot 2
			},
		},
		groups = furniture_groups
	})
	minetest.register_craft({
		output = "ts_furniture:" .. mod .. "_" ..name .. "_bench",
		recipe = {
			{mod .. ":" .. name, mod .. ":" .. name, ""},
			{"group:stick"     , "group:stick"     , ""},
		}
	})

	minetest.register_node("ts_furniture:" .. mod .. "_" .. name .."_tiny_table", {
		description = description .. " Tiny Table",
		tiles = {texture},
		drawtype = "nodebox",
		sunlight_propagates = true,
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.1, -0.5,  0.5, 0  , 0.5}, -- table top
				{-0.4, -0.5, -0.5, -0.3,-0.1, 0.5}, -- foot 1
				{ 0.3, -0.5, -0.5,  0.4,-0.1, 0.5}, -- foot 2
			},
		},
		groups = furniture_groups
	})
	minetest.register_craft({
		output = "ts_furniture:" .. mod .. "_" ..name .. "_tiny_table",
		recipe = {
			{"ts_furniture:" .. mod .. "_" ..name .. "_bench", "ts_furniture:" .. mod .. "_" ..name .. "_bench"},
		}
	})

	minetest.register_node("ts_furniture:" .. mod .. "_" .. name .."_small_table", {
		description = description .. " Small Table",
		tiles = {texture},
		drawtype = "nodebox",
		sunlight_propagates = true,
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4,-0.5,-0.4, -0.3, 0.1,-0.3}, -- foot 1
				{ 0.3,-0.5,-0.4,  0.4, 0.1,-0.3}, -- foot 2
				{-0.4,-0.5, 0.3, -0.3, 0.1, 0.4}, -- foot 3
				{ 0.3,-0.5, 0.3,  0.4, 0.1, 0.4}, -- foot 4
				{-0.5, 0.1,-0.5,  0.5, 0.2, 0.5}, -- table top
			},
		},
		groups = furniture_groups
	})
	minetest.register_craft({
		output = "ts_furniture:" .. mod .. "_" ..name .. "_small_table",
		recipe = {
			{mod .. ":" .. name, mod .. ":" .. name, mod .. ":" .. name},
			{"group:stick"     , ""                , "group:stick"     },
		}
	})
end

register_ts_furniture("default", "aspen_wood" , "Aspen"      , "default_aspen_wood.png" )
register_ts_furniture("default", "pine_wood"  , "Pine"       , "default_pine_wood.png"  )
register_ts_furniture("default", "acacia_wood", "Acacia"     , "default_acacia_wood.png")
register_ts_furniture("default", "wood"       , "Wooden"     , "default_wood.png"       )
register_ts_furniture("default", "junglewood" , "Jungle Wood", "default_junglewood.png" )
