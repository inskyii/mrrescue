local lg = love.graphics

img = {}  	-- global Image objects
quad = {}	-- global Quads

local IMAGE_FILES = {
	"tiles", "door",
	"hud", "hud2", "hud_people", "item_slots",
	"water_bar", "reserve_bar", "overloaded_bar", "temperature_bar",
	"stream", "water", "shards",
	"fire_wall", "fire_wall_small", "fire_floor",
	"black_smoke", "black_smoke_small", "ashes", "sparkles",
	"light_player", "light_fire", "light_fireball",
	"red_screen", "circles", "warning_icons",
	"item_coolant", "item_reserve", "item_suit", "item_tank", "item_regen",

	"player_gun", "player_throw", "player_climb_down",
	"player_climb_up", "player_running",

	"enemy_normal_run", "enemy_normal_hit", "enemy_normal_recover", "enemy_jumper_hit",
	"enemy_jumper_jump", "enemy_jumper_recover", 
	"enemy_volcano_run", "enemy_volcano_shoot", "enemy_volcano_hit", "enemy_fireball",

	"human_1_run", "human_2_run", "human_3_run", "human_4_run",
	"human_1_carry_left", "human_2_carry_left", "human_3_carry_left", "human_4_carry_left",
	"human_1_carry_right", "human_2_carry_right", "human_3_carry_right", "human_4_carry_right",
	"human_1_fly", "human_2_fly", "human_3_fly", "human_4_fly",
	"human_1_burn", "human_2_burn", "human_3_burn", "human_4_burn",
	"human_1_panic", "human_2_panic", "human_3_panic", "human_4_panic"
}

local BACKGROUND_FILES = { "mountains", "night" }

NUM_ROOMS = { [10] = 6, [11] = 6, [17] = 6, [24] = 6 }

--- Returns size of an Image as two return values
-- Saves some typing when creating quads
function getSize(img)
	return img:getWidth(), img:getHeight()
end

--- Load all resources including images, quads sound effects etc.
function loadResources()
	-- Create canvas for lighting effects
	canvas = lg.newCanvas(256,256)
	canvas:setFilter("nearest","nearest")

	-- Load all images
	for i,v in ipairs(IMAGE_FILES) do
		img[v] = lg.newImage("data/"..v..".png")
	end
	for i,v in ipairs(BACKGROUND_FILES) do
		img[v] = lg.newImage("data/backgrounds/"..v..".png")
	end

	img.human_run = { img.human_1_run, img.human_2_run, img.human_3_run, img.human_4_run }
	img.human_carry_left = { img.human_1_carry_left, img.human_2_carry_left, img.human_3_carry_left, img.human_4_carry_left }
	img.human_carry_right = { img.human_1_carry_right, img.human_2_carry_right, img.human_3_carry_right, img.human_4_carry_right }
	img.human_fly = { img.human_1_fly, img.human_2_fly, img.human_3_fly, img.human_4_fly }
	img.human_burn = { img.human_1_burn, img.human_2_burn, img.human_3_burn, img.human_4_burn }
	img.human_panic = { img.human_1_panic, img.human_2_panic, img.human_3_panic, img.human_4_panic }

	-- Set special image attributes
	img.stream:setWrap("repeat", "clamp")

	quad.player_gun = {}
	for i=0,4 do
		quad.player_gun[i] = lg.newQuad(i*12,0,12,18, getSize(img.player_gun))
	end

	quad.door_normal  = lg.newQuad( 0,0, 8,48, getSize(img.door))
	quad.door_damaged = lg.newQuad(16,0, 8,48, getSize(img.door))

	quad.water_out = {}
	quad.water_out[0] = lg.newQuad(0,0, 8,15, getSize(img.water))
	quad.water_out[1] = lg.newQuad(16,0, 8,15, getSize(img.water))

	quad.water_end = {}
	quad.water_end[0] = lg.newQuad(32,0, 16,15, getSize(img.water))
	quad.water_end[1] = lg.newQuad(48,0, 16,15, getSize(img.water))

	quad.water_hit = {}
	for i=0,2 do
		quad.water_hit[i] = lg.newQuad(i*16, 16, 16, 19, getSize(img.water))
	end

	quad.shard = {}
	for i=0,7 do
		quad.shard[i] = lg.newQuad(i*8,0,8,8, getSize(img.shards))
	end

	quad.tile = {}
	local id = 1
	for iy = 0,15 do
		for ix = 0,15 do
			quad.tile[id] = lg.newQuad(ix*16, iy*16, 16, 16, getSize(img.tiles))
			id = id + 1
		end
	end

	quad.fire_wall = {}
	for i=0,4 do
		quad.fire_wall[i] = lg.newQuad(i*24, 0, 24, 32, getSize(img.fire_wall))
	end
	quad.fire_floor = {}
	for i=0,3 do
		quad.fire_floor[i] = lg.newQuad(i*16, 0, 16, 16, getSize(img.fire_floor))
	end

	quad.light_fire = {}
	for i=0,4 do
		quad.light_fire[i] = lg.newQuad(i*85, 0, 85, 85, getSize(img.light_fire))
	end

	quad.fireball = {}
	quad.light_fireball = {}
	for i=0,3 do
		quad.fireball[i] = lg.newQuad(i*8, 0, 8, 8, getSize(img.enemy_fireball))
		quad.light_fireball[i] = lg.newQuad(i*32, 0, 32, 32, getSize(img.light_fireball))
	end

	quad.water_bar = lg.newQuad(0,0, 1,1, getSize(img.water_bar))
	quad.temperature_bar = lg.newQuad(0,0,1,1, getSize(img.temperature_bar))
	quad.temperature_bar_end = lg.newQuad(81,0,2,6, getSize(img.temperature_bar))

	quad.red_screen = lg.newQuad(0,0, 256,169, 256,256)

	quad.hud_people_red = lg.newQuad(0,0, 4,8, 8,8)
	quad.hud_people_green = lg.newQuad(4,0,4,8, 8,8)

	quad.item_slot_regen = lg.newQuad(0,0,3,6, getSize(img.item_slots))
	quad.item_slot_tank  = lg.newQuad(3,0,3,6, getSize(img.item_slots))
	quad.item_slot_suit  = lg.newQuad(6,0,3,6, getSize(img.item_slots))

	quad.sparkles = {}
	for i=0,2 do
		quad.sparkles[i] = lg.newQuad(i*8, 0, 7, 7, getSize(img.sparkles))
	end

	quad.circles = {}
	for i=0,6 do
		quad.circles[i] = lg.newQuad(i*32, 0, 32, 32, getSize(img.circles))
	end

	quad.warning_icons = {}
	for i=0,4 do
		quad.warning_icons[i] = lg.newQuad(i*22, 0, 22, 20, getSize(img.warning_icons))
	end
end
