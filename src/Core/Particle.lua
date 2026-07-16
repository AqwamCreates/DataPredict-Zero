--[[

	--------------------------------------------------------------------

	Aqwam's Derivative-Free Optimization Library (DataPredict Zero)

	Author: Aqwam Harish Aiman
	
	Email: aqwam.harish.aiman@gmail.com
	
	YouTube: https://www.youtube.com/channel/UCUrwoxv5dufEmbGsxyEUPZw
	
	LinkedIn: https://www.linkedin.com/in/aqwam-harish-aiman/
	
	--------------------------------------------------------------------
		
	By using this library, you agree to comply with our Terms and Conditions in the link below:
	
	https://github.com/AqwamCreates/DataPredict-Zero/blob/main/docs/TermsAndConditions.md
	
	--------------------------------------------------------------------
	
	DO NOT REMOVE THIS TEXT!
	
	--------------------------------------------------------------------

--]]

local mathRandom = math.random

local mathHuge = math.huge

local tableClone = table.clone

local Particle = {}

Particle.__index = Particle

local function deepCopyValue(original, copies)

	copies = copies or {}

	local originalType = type(original)

	local copy

	if (originalType == 'table') then

		if copies[original] then

			copy = copies[original]

		else

			copy = {}

			copies[original] = copy

			for originalKey, originalValue in next, original, nil do

				copy[deepCopyValue(originalKey, copies)] = deepCopyValue(originalValue, copies)

			end

			setmetatable(copy, deepCopyValue(getmetatable(original), copies))

		end

	else

		copy = original

	end

	return copy

end

function Particle.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}
	
	local dimension = parameterDictionary.dimension or 1
	
	local positionArray = tableClone(parameterDictionary.positionArray) or {}
	
	local velocityArray = tableClone(parameterDictionary.velocityArray) or {}
	
	local bestPositionArray = tableClone(parameterDictionary.bestPositionArray) or {}
	
	local bestScore = parameterDictionary.bestScore or -mathHuge
	
	local NewParticle = {}

	setmetatable(NewParticle, Particle)
	
	for i = 1, dimension, 1 do
		
		local position = positionArray[i] or mathRandom()
		
		local velocity = velocityArray[i] or 0
		
		positionArray[i] = position
		
		velocityArray[i] = velocity
		
		bestPositionArray[i] = position
		
	end

	NewParticle.positionArray = positionArray
	
	NewParticle.velocityArray = velocityArray
	
	NewParticle.bestPositionArray = bestPositionArray
	
	NewParticle.bestScore = bestScore

	return NewParticle

end

function Particle:clone()

	return deepCopyValue(self)

end

function Particle:__tostring()
	
	local numberOfPositions = #self.positionArray
	
	local text = "{"
	
	for positionIndex, positionValue in ipairs(self.positionArray) do
		
		text = text .. positionValue
		
		if (positionIndex < numberOfPositions) then text = text .. ", " end
		
	end
	
	return text .. "}"
	
end

function Particle:destroy()
	
	table.clear(self)
	
	setmetatable(self, nil)
	
	self = nil
	
end

return Particle
