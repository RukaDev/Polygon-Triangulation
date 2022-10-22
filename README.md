# Polygon Triangulation

Polygon Triangulation using the ear clipping method. Implmented in lua and visualized in Roblox Studio. Can triangulate concave and convex polygons, regardless of order. Unordered input uses a gift wrapping algorithm to create a convex hull of the input, which is then traversed to slot in the concave points left out from the gift wrapping.

## Basic Usage

The triangulation module takes two input types, the first of which is an array of ordered positions, and the second is a dictionary that takes a position as a key, and an array of the key's adjacent positions as the value.

### Example Data

```lua
-- Eight ordered positions for clarity
local one = Vector3.new(30, 0.5, 120)
local two = Vector3.new(-249, 0.5, 75)
local three = Vector3.new(-151, 0.5, 44)
local four = Vector3.new(-90, 0.5, 74)
local five = Vector3.new(-75, 0.5, 32)
local six = Vector3.new(-20, 0.5, 10)
local seven = Vector3.new(23, 0.5, -69)
local eight = Vector3.new(96, 0.5, 44)
```

### Ordered Input

```lua
local Triangulate = require(TriangulationModule)

-- Ordered Array
local ordered = {one, two, three, four, five, six, seven, eight}

Triangulate.Perform(ordered, false) -- false for ordered
```

### Unordered Adjacency Input

```lua
local Triangulate = require(TriangulationModule)

-- Randomized order with adjacency arrays
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

Triangulate.Perform(ordered, true) -- true for unordered
```

Both examples can be found within the "Guide" script in StarterPlayerScripts