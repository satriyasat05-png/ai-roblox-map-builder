-- AI Roblox Map Builder
-- Generates: City, Village, Nature, Obby and Dungeon
-- Place in Roblox Studio ServerScriptService to generate the map.

local Workspace = game:GetService("Workspace")

local MAP_NAME = "AI_Map"

-- Remove previous generated map
local oldMap = Workspace:FindFirstChild(MAP_NAME)
if oldMap then
	oldMap:Destroy()
end

local map = Instance.new("Folder")
map.Name = MAP_NAME
map.Parent = Workspace

local function part(name, size, position, material, color)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = position
	p.Anchored = true
	p.Material = material or Enum.Material.Concrete
	p.Color = color or Color3.fromRGB(150, 150, 150)
	p.Parent = map
	return p
end

local function block(name, x, y, z, sx, sy, sz, material, color)
	return part(
		name,
		Vector3.new(sx, sy, sz),
		Vector3.new(x, y, z),
		material,
		color
	)
end

local function tree(x, z)
	-- trunk
	block(
		"Tree_Trunk",
		x, 5, z,
		3, 10, 3,
		Enum.Material.Wood,
		Color3.fromRGB(101, 67, 33)
	)

	-- leaves
	local leaves = part(
		"Tree_Leaves",
		Vector3.new(10, 10, 10),
		Vector3.new(x, 12, z),
		Enum.Material.Grass,
		Color3.fromRGB(45, 140, 55)
	)

	leaves.Shape = Enum.PartType.Ball
end

local function house(x, z)
	-- floor
	block(
		"House_Floor",
		x, 1, z,
		18, 2, 16,
		Enum.Material.WoodPlanks,
		Color3.fromRGB(130, 90, 55)
	)

	-- walls
	block("House_Wall1", x, 6, z - 8, 18, 10, 1, Enum.Material.Brick)
	block("House_Wall2", x, 6, z + 8, 18, 10, 1, Enum.Material.Brick)
	block("House_Wall3", x - 9, 6, z, 1, 10, 16, Enum.Material.Brick)
	block("House_Wall4", x + 9, 6, z, 1, 10, 16, Enum.Material.Brick)

	-- roof
	block(
		"House_Roof",
		x, 12, z,
		21, 2, 19,
		Enum.Material.Wood,
		Color3.fromRGB(110, 45, 35)
	)

	-- door
	block(
		"House_Door",
		x, 5, z - 8.6,
		4, 8, 1,
		Enum.Material.Wood,
		Color3.fromRGB(70, 40, 20)
	)
end

local function building(x, z, height)
	block(
		"City_Building",
		x, height / 2, z,
		22, height, 22,
		Enum.Material.Concrete,
		Color3.fromRGB(120, 125, 135)
	)

	-- roof
	block(
		"Building_Roof",
		x, height + 1, z,
		24, 2, 24,
		Enum.Material.Metal
	)

	-- windows
	for y = 8, height - 4, 8 do
		for side = -1, 1, 2 do
			block(
				"Building_Window",
				x + side * 11.2,
				y,
				z,
				0.5, 3, 5,
				Enum.Material.Glass,
				Color3.fromRGB(80, 180, 230)
			)
		end
	end
end

local function platform(x, y, z, size)
	return block(
		"Obby_Platform",
		x, y, z,
		size, 2, size,
		Enum.Material.Neon,
		Color3.fromRGB(255, 170, 0)
	)
end

local function dungeonRoom(x, z)
	-- floor
	block(
		"Dungeon_Floor",
		x, 2, z,
		30, 4, 30,
		Enum.Material.Slate,
		Color3.fromRGB(55, 55, 60)
	)

	-- walls
	block("Dungeon_Wall_N", x, 12, z - 15, 30, 20, 2, Enum.Material.Cobblestone)
	block("Dungeon_Wall_S", x, 12, z + 15, 30, 20, 2, Enum.Material.Cobblestone)
	block("Dungeon_Wall_E", x + 15, 12, z, 2, 20, 30, Enum.Material.Cobblestone)
	block("Dungeon_Wall_W", x - 15, 12, z, 2, 20, 30, Enum.Material.Cobblestone)

	-- center platform
	block(
		"Dungeon_Altar",
		x, 6, z,
		8, 8, 8,
		Enum.Material.Brick,
		Color3.fromRGB(90, 40, 40)
	)
end

--------------------------------------------------
-- WORLD GROUND
--------------------------------------------------

block(
	"World_Ground",
	0, -2, 0,
	500, 4, 500,
	Enum.Material.Grass,
	Color3.fromRGB(80, 150, 70)
)

--------------------------------------------------
-- CITY
--------------------------------------------------

for x = -120, 120, 40 do
	for z = -120, -40, 40 do
		building(x, z, math.random(35, 75))
	end
end

-- city road
block(
	"Main_Road",
	0, 1, -20,
	300, 1, 20,
	Enum.Material.Asphalt,
	Color3.fromRGB(40, 40, 40)
)

block(
	"Cross_Road",
	0, 1, -80,
	20, 1, 180,
	Enum.Material.Asphalt,
	Color3.fromRGB(40, 40, 40)
)

--------------------------------------------------
-- VILLAGE
--------------------------------------------------

for x = -100, 100, 50 do
	house(x, 70)
end

for x = -75, 75, 50 do
	tree(x, 110)
	tree(x, 145)
end

--------------------------------------------------
-- NATURE AREA
--------------------------------------------------

for x = -200, 200, 35 do
	for z = 130, 220, 35 do
		if math.random() > 0.35 then
			tree(
				x + math.random(-8, 8),
				z + math.random(-8, 8)
			)
		end
	end
end

-- small lake
local lake = part(
	"Nature_Lake",
	Vector3.new(100, 1, 70),
	Vector3.new(120, 1, 170),
	Enum.Material.Water,
	Color3.fromRGB(40, 130, 220)
)

--------------------------------------------------
-- OBBY
--------------------------------------------------

local obbyStartX = -180
local obbyZ = -170

for i = 1, 15 do
	local x = obbyStartX + (i * 18)
	local y = 5 + (i * 2)

	platform(
		x,
		y,
		obbyZ,
		12
	)
end

-- finish platform
block(
	"Obby_Finish",
	110, 40, obbyZ,
	25, 3, 25,
	Enum.Material.Neon,
	Color3.fromRGB(50, 255, 100)
)

--------------------------------------------------
-- DUNGEON
--------------------------------------------------

dungeonRoom(100, -100)

-- dungeon entrance
block(
	"Dungeon_Entrance",
	100, 8, -135,
	14, 16, 5,
	Enum.Material.Brick,
	Color3.fromRGB(45, 35, 35)
)

--------------------------------------------------
-- SPAWN
--------------------------------------------------

local spawn = Instance.new("SpawnLocation")
spawn.Name = "AI_Map_Spawn"
spawn.Size = Vector3.new(8, 1, 8)
spawn.Position = Vector3.new(0, 5, 0)
spawn.Anchored = true
spawn.Neutral = true
spawn.Parent = map

print("AI Roblox Map Builder: map generated successfully!")
