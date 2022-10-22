-- Extra
local seen = {}

local function directConnection(p, q, dict)
	if table.find(dict[p], q) then
		return true
	end
end

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

-- store all the positions from p -> q
local function recursiveConnection(p, q, dict, hull)
	table.insert(seen, p)
	for _, part in pairs(dict[p]) do 
		if not table.find(hull, part) and not table.find(seen, part) then
			if table.find(dict[part], q) then
				table.insert(seen, part)
				table.remove(seen, 1)
				return seen
			else
				local prior = shallowCopy(seen)
				return recursiveConnection(part, q, dict, hull)
			end 
		end
	end
end

-- Checks CCW order
local function isCCW(p, q, r) 
	local c1 = (q.Z - p.Z) * (r.X - q.X)
	local c2 = (q.X - p.X) * (r.Z - q.Z)
	local cross = c1 - c2

	return cross < 0 
end

-- Get Convex hull
local function jarvis_march(points)
	-- We need at least 3 points
	local preventError = 0
	local numPoints = #points
	if numPoints < 3 then return end

	-- Find the left-most point
	local leftMostPointIndex = 1

	for i = 1, numPoints do
		if points[i].X < points[leftMostPointIndex].X then
			leftMostPointIndex = i
		end
	end

	local p = leftMostPointIndex
	local hull = {} -- The convex hull to be returned

	-- Process CCW from the left-most point to the start point
	repeat
		-- Find the next point q such that (p, i, q) is CCW for all i
		local q = points[p + 1] and p + 1 or 1
		for i = 1, numPoints, 1 do

			if isCCW(points[p], points[i], points[q]) then 	
				q = i 
			end

		end
		table.insert(hull, points[q]) -- Save q to the hull
		p = q  -- P is now q for the next iteration, means we found a point that is CCW to p
		preventError += 1 
	until (p == leftMostPointIndex) or preventError >= 500 

	if preventError >= 500 then 
		print("This is an error") 
		return nil
	end

	return hull
end

local function convexToConcave(hull, dict)
	local concaveHull = {}
	
	for i = 1, #hull do
		seen = {}
		local prev, cur = hull[i], hull[i % #hull + 1]
		if not directConnection(prev, cur, dict) then
			local nodesToAdd = recursiveConnection(prev, cur, dict, hull)	
			for i, node in pairs(nodesToAdd) do
				table.insert(concaveHull, node)
			end
		end
		table.insert(concaveHull, cur)
	end
	
	return concaveHull
end

local function getArray(dict)
	local result = {}
	for pt, _ in pairs(dict) do
		table.insert(result, pt)
	end
	return result
end



-- Public
local Concave = {}

function Concave.Perform(dict)
	local array = getArray(dict)
	local hull = jarvis_march(array)
	return convexToConcave(hull, dict)
end

return Concave



