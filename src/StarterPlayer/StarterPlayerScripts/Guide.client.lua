-- Modules
local Triangulate = require(game.ReplicatedStorage.Source.Triangulation)

-- Points
local one = Vector3.new(30, 0.5, 120)
local two = Vector3.new(-249, 0.5, 75)
local three = Vector3.new(-151, 0.5, 44)
local four = Vector3.new(-90, 0.5, 74)
local five = Vector3.new(-75, 0.5, 32)
local six = Vector3.new(-20, 0.5, 10)
local seven = Vector3.new(23, 0.5, -69)
local eight = Vector3.new(96, 0.5, 44)

-- Ordered example
local ordered = {one, two, three, four, five, six, seven, eight}

-- Randomized order with adjacency example
local adjacencies = {
	[six] = {five, seven},
	[one] = {two, eight},
	[three] = {two, four},
	[eight] = {seven, one},
	[four] = {three, five},
	[two] = {one, three},
	[seven] = {six, eight},
	[five] = {four, six},
}

-- Triangulate
Triangulate.Perform(adjacencies, true) -- true for adjacency dict, false for ordered array