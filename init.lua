ts_furniture = {}

-- If true, you can sit on chairs and benches, when right-click them.
ts_furniture.enable_sitting = minetest.settings:get_bool("ts_furniture.enable_sitting", true)
ts_furniture.globalstep = minetest.settings:get_bool("ts_furniture.globalstep", true)
ts_furniture.kneeling_bench = minetest.settings:get_bool("ts_furniture.kneeling_bench", false)

-- Used for localization
local S = minetest.get_translator("ts_furniture")
local has_player_monoids = minetest.get_modpath("player_monoids")

-- Get texture by node name
local T = function (node_name)
	local def = minetest.registered_nodes[node_name]
	if not (def and def.tiles) then
		return ""
	end
	local tile = def.tiles[5] or def.tiles[4] or def.tiles[3] or def.tiles[2] or def.tiles[1]
	if type(tile) == "string" then
		return tile
	elseif type(tile) == "table" and tile.name then
		return tile.name
	end
	return ""
end

-- The following code is from "Get Comfortable [cozy]" (by everamzah; published under WTFPL)
-- Thomas S. modified it, so that it can be used in this mod
if ts_furniture.enable_sitting then
	ts_furniture.sit = function(pos, _, player)
		local name = player:get_player_name()
		if not player_api.player_attached[name] then
			if vector.length(player:get_velocity()) > 0.5 then
				minetest.chat_send_player(player:get_player_name(), 'You can only sit down when you are not moving.')
				return
			end
			player:move_to(pos)
			player:set_eye_offset({x = 0, y = -7, z = 2}, {x = 0, y = 0, z = 0})
			if has_player_monoids then
				player_monoids.speed:add_change(player, 0, "ts_furniture:sit")
				player_monoids.jump:add_change(player, 0, "ts_furniture:sit")
				player_monoids.gravity:add_change(player, 0, "ts_furniture:sit")
			else
				player:set_physics_override({speed = 0, jump = 0, gravity = 0})
			end
			player_api.player_attached[name] = true
			minetest.after(0.1, function()
				if player then
					player_api.set_animation(player, "sit" , 30)
				end
			end)
		else
			ts_furniture.stand(player, name)
		end
	end

	ts_furniture.up = function(_, _, player)
		local name = player:get_player_name()
		if player_api.player_attached[name] then
			ts_furniture.stand(player, name)
		end
	end

	ts_furniture.stand = function(player, name)
		player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
		if has_player_monoids then
			player_monoids.speed:del_change(player, "ts_furniture:sit")
			player_monoids.jump:del_change(player, "ts_furniture:sit")
			player_monoids.gravity:del_change(player, "ts_furniture:sit")
		else
			player:set_physics_override({speed = 1, jump = 1, gravity = 1})
		end
		player_api.player_attached[name] = false
		player_api.set_animation(player, "stand", 30)
	end

	-- The player will stand at the beginning of the movement
	if ts_furniture.globalstep and not minetest.get_modpath("cozy") then
		minetest.register_globalstep(function(dtime)
			local players = minetest.get_connected_players()
			for i = 1, #players do
				local player = players[i]
				local name = player:get_player_name()
				local ctrl = player:get_player_control()
				if default.player_attached[name] and not player:get_attach() and
				(ctrl.up or ctrl.down or ctrl.left or ctrl.right or ctrl.jump) then
					ts_furniture.up(nil, nil, player)
				end
			end
		end)
	end
end
-- End of [cozy] code

local furnitures = {
	["chair"] = {
		description = "Chair",
		sitting = true,
		nodebox = {
			{ -0.3, -0.5, 0.2, -0.2, 0.5, 0.3 }, -- foot 1
			{ 0.2, -0.5, 0.2, 0.3, 0.5, 0.3 }, -- foot 2
			{ 0.2, -0.5, -0.3, 0.3, -0.1, -0.2 }, -- foot 3
			{ -0.3, -0.5, -0.3, -0.2, -0.1, -0.2 }, -- foot 4
			{ -0.3, -0.1, -0.3, 0.3, 0, 0.2 }, -- seating
			{ -0.2, 0.1, 0.25, 0.2, 0.4, 0.26 } -- conector 1-2
		},
		craft = function(recipe)
			return {
				{ "", "group:stick" },
				{ recipe, recipe },
				{ "group:stick", "group:stick" }
			}
		end
	},
	["table"] = {
		description = "Table",
		nodebox = {
			{ -0.4, -0.5, -0.4, -0.3, 0.4, -0.3 }, -- foot 1
			{ 0.3, -0.5, -0.4, 0.4, 0.4, -0.3 }, -- foot 2
			{ -0.4, -0.5, 0.3, -0.3, 0.4, 0.4 }, -- foot 3
			{ 0.3, -0.5, 0.3, 0.4, 0.4, 0.4 }, -- foot 4
			{ -0.5, 0.4, -0.5, 0.5, 0.5, 0.5 } -- table top
		},
		craft = function(recipe)
			return {
				{ recipe, recipe, recipe },
				{ "group:stick", "", "group:stick" },
				{ "group:stick", "", "group:stick" }
			}
		end
	},
	["small_table"] = {
		description = "Small Table",
		nodebox = {
			{ -0.4, -0.5, -0.4, -0.3, 0.1, -0.3 }, -- foot 1
			{ 0.3, -0.5, -0.4, 0.4, 0.1, -0.3 }, -- foot 2
			{ -0.4, -0.5, 0.3, -0.3, 0.1, 0.4 }, -- foot 3
			{ 0.3, -0.5, 0.3, 0.4, 0.1, 0.4 }, -- foot 4
			{ -0.5, 0.1, -0.5, 0.5, 0.2, 0.5 } -- table top
		},
		craft = function(recipe)
			return {
				{ recipe, recipe, recipe },
				{ "group:stick", "", "group:stick" }
			}
		end
	},
	["tiny_table"] = {
		description = "Tiny Table",
		nodebox = {
			{ -0.5, -0.1, -0.5, 0.5, 0, 0.5 }, -- table top
			{ -0.4, -0.5, -0.5, -0.3, -0.1, 0.5 }, -- foot 1
			{ 0.3, -0.5, -0.5, 0.4, -0.1, 0.5 }, -- foot 2
		},
		craft = function(recipe)
			local bench_name = "ts_furniture:" .. recipe:gsub(":", "_") .. "_bench"
			return {
				{ bench_name, bench_name }
			}
		end
	},
	["bench"] = {
		description = "Bench",
		sitting = true,
		nodebox = {
			{ -0.5, -0.1, 0, 0.5, 0, 0.5 }, -- seating
			{ -0.4, -0.5, 0, -0.3, -0.1, 0.5 }, -- foot 1
			{ 0.3, -0.5, 0, 0.4, -0.1, 0.5 } -- foot 2
		},
		craft = function(recipe)
			return {
				{ recipe, recipe },
				{ "group:stick", "group:stick" }
			}
		end
	}
}

if ts_furniture.kneeling_bench then
	furnitures.kneeling_bench = {
		description = "Kneeling Bench",
		nodebox = {
			{ -0.5, -0.5, 0.4, 0.5, 0.5, 0.5 },
			{ -0.4, -0.5, -0.2, -0.3, -0.3, 0.5 },
			{ 0.3, -0.5, -0.2, 0.4, -0.3, 0.5 },
			{ -0.5, -0.3, -0.2, 0.5, -0.2, 0.2},
			{ -0.5, 0.4, 0.15, 0.5, 0.5, 0.55},
		},
		craft = function(recipe)
			local bench_name = "ts_furniture:" .. recipe:gsub(":", "_") .. "_bench"
			return {
				{ recipe, "" },
				{ recipe, bench_name }
			}
		end
	}
end

local ignore_groups = {
	["wood"] = true,
	["stone"] = true,
	["tree"] = true
}

function ts_furniture.register_furniture(recipe, description, tiles)
	if not tiles then
		tiles = T(recipe)
	end

	local recipe_def = minetest.registered_items[recipe]
	if not recipe_def then
		return
	end

	local groups = {}
	for k, v in pairs(recipe_def.groups) do
		if not ignore_groups[k] then
			groups[k] = v
		end
	end

	for furniture, def in pairs(furnitures) do
		local node_name = "ts_furniture:" .. recipe:gsub(":", "_") .. "_" .. furniture

		if def.sitting and ts_furniture.enable_sitting then
			def.on_rightclick = ts_furniture.sit
			def.on_punch = ts_furniture.up
		end

		minetest.register_node(":" .. node_name, {
			description = S(description .. " " .. def.description),
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			sunlight_propagates = true,
			tiles = { tiles },
			groups = groups,
			node_box = {
				type = "fixed",
				fixed = def.nodebox
			},
			on_rightclick = def.on_rightclick,
			on_punch = def.on_punch
		})

		minetest.register_craft({
			output = node_name,
			recipe = def.craft(recipe)
		})
	end
end

ts_furniture.register_furniture("default:aspen_wood", "Aspen")
ts_furniture.register_furniture("default:pine_wood", "Pine")
ts_furniture.register_furniture("default:acacia_wood", "Acacia")
ts_furniture.register_furniture("default:wood", "Wooden")
ts_furniture.register_furniture("default:junglewood", "Jungle Wood")

if (minetest.get_modpath("moretrees")) then
	ts_furniture.register_furniture("moretrees:apple_tree_planks", "Apple Tree")
	ts_furniture.register_furniture("moretrees:beech_planks", "Beech")
	ts_furniture.register_furniture("moretrees:birch_planks", "Birch")
	ts_furniture.register_furniture("moretrees:fir_planks", "Fir")
	ts_furniture.register_furniture("moretrees:oak_planks", "Oak")
	ts_furniture.register_furniture("moretrees:palm_planks", "Palm")
	ts_furniture.register_furniture("moretrees:rubber_tree_planks", "Rubber Tree")
	ts_furniture.register_furniture("moretrees:sequoia_planks", "Sequoia")
	ts_furniture.register_furniture("moretrees:spruce_planks", "Spruce")
	ts_furniture.register_furniture("moretrees:willow_planks", "Willow")
end

if minetest.get_modpath("ethereal") then
	ts_furniture.register_furniture("ethereal:banana_wood", "Banana")
	ts_furniture.register_furniture("ethereal:birch_wood", "Birch")
	ts_furniture.register_furniture("ethereal:frost_wood", "Frost")
	ts_furniture.register_furniture("ethereal:mushroom_trunk", "Mushroom")
	ts_furniture.register_furniture("ethereal:palm_wood", "Palm")
	ts_furniture.register_furniture("ethereal:redwood_wood", "Redwood")
	ts_furniture.register_furniture("ethereal:sakura_wood", "Sakura")
	ts_furniture.register_furniture("ethereal:scorched_tree", "Scorched")
	ts_furniture.register_furniture("ethereal:willow_wood", "Willow")
	ts_furniture.register_furniture("ethereal:yellow_wood", "Healing Tree")
end
