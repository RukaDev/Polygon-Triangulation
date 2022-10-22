-- Credit feryblanca


-- Modules
local Draw = require(script.Draw)
local Order = require(script.Order)


-- Private
local function checkPointIntoTriangle(point: Instance, a: Instance, b:Instance, c:Instance)
	local pointToa = Vector2.new(point.X - a.X, point.Z - a.Z)
	local pointTob = Vector2.new(point.X - b.X, point.Z - b.Z)
	local pointToc = Vector2.new(point.X - c.X, point.Z - c.Z)
	local moduleA = math.sqrt((pointToa.X)^2+(pointToa.Y)^2)
	local moduleB = math.sqrt((pointTob.X)^2+(pointTob.Y)^2)
	local moduleC = math.sqrt((pointToc.X)^2+(pointToc.Y)^2)

	local CrossProductY_1 = (pointToa.X * pointTob.Y) - (pointToa.Y * pointTob.X)
	local CrossProductY_2 = (pointTob.X * pointToc.Y) - (pointTob.Y * pointToc.X)
	local CrossProductY_3 = (pointToc.X * pointToa.Y) - (pointToc.Y * pointToa.X)	

	if CrossProductY_1 <0 or CrossProductY_2 <0 or CrossProductY_3 <0 then
		return true
	end
end

local function checkVertex(a: Instance,b: Instance, c:Instance, vertexlist)

	local canMakeTriangle = true

	local vectorA = Vector2.new(a.X - b.X, a.Z - b.Z)	
	local vectorB = Vector2.new(a.X - c.X, a.Z - c.Z)
	local moduleA = math.sqrt((vectorA.X)^2+(vectorA.Y)^2)
	local moduleB = math.sqrt((vectorB.X)^2+(vectorB.Y)^2)
	local CrossProductY = (vectorA.X * vectorB.Y) - (vectorA.Y * vectorB.X)
	local sin = CrossProductY/(moduleA*moduleB)
	local angle = math.deg(math.asin(sin))	

	if angle > 0 then -- if the angle is higher than 180 degrees the variable angle will be a number under of 0 because the cross product will be negative
		for i, v in pairs(vertexlist) do
			if v ~= a and v ~= b and v ~= c then
				if not checkPointIntoTriangle(v, a, b, c) then
					canMakeTriangle = false
				end
			end			
		end
		if canMakeTriangle then
			return true
		end
	end
end


-- Public
local Triangulation = {}

function Triangulation.Perform(vertexlist, unordered)
	if unordered then
		vertexlist = Order.Perform(vertexlist)
		print(vertexlist)
	end
	
	local vertexfound = false

	while task.wait() do
		for i, v in pairs(vertexlist) do	
			if i == 1 then
				if checkVertex(v , vertexlist[i+1] , vertexlist[#vertexlist], vertexlist) then				
					vertexfound = true
					Draw(v, vertexlist[i+1], vertexlist[#vertexlist], workspace)						
					table.remove(vertexlist, i)
				end		
			elseif i == #vertexlist then
				if checkVertex(v, vertexlist[1], vertexlist[i-1], vertexlist) then				
					vertexfound = true
					Draw(v, vertexlist[1], vertexlist[i-1], workspace)								
					table.remove(vertexlist, i)
				end	
			elseif i ~= 1 and i ~= #vertexlist then	
				if checkVertex(v , vertexlist[i+1] , vertexlist[i-1], vertexlist) then				
					vertexfound = true
					Draw(v, vertexlist[i+1], vertexlist[i-1], workspace)		
					table.remove(vertexlist, i)
				end		
			end	
			if vertexfound then
				vertexfound = false
				break
			end
		end
		if #vertexlist <= 1 then
			break
		end
	end
end

return Triangulation