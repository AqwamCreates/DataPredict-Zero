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
	
	local dimensionSize = parameterDictionary.dimensionSize or 1
	
	local positionArray = parameterDictionary.positionArray or {}
	
	positionArray = tableClone(positionArray)
	
	local velocityArray = parameterDictionary.velocityArray or {}
	
	velocityArray = tableClone(velocityArray)
	
	local bestPositionArray = parameterDictionary.bestPositionArray or {}
	
	bestPositionArray = tableClone(bestPositionArray)
	
	local bestScore = parameterDictionary.bestScore or -mathHuge
	
	local NewParticle = {}

	setmetatable(NewParticle, Particle)
	
	for i = 1, dimensionSize, 1 do
		
		local position = positionArray[i] or mathRandom()
		
		local velocity = velocityArray[i] or 0
		
		positionArray[i] = position
		
		velocityArray[i] = velocity
		
		bestPositionArray[i] = position
		
	end
	
	NewParticle.dimensionSize = dimensionSize

	NewParticle.positionArray = positionArray
	
	NewParticle.velocityArray = velocityArray
	
	NewParticle.bestPositionArray = bestPositionArray
	
	NewParticle.bestScore = bestScore

	return NewParticle

end

function Particle:guide(inertiaArray, cognitiveArray, socialArray)
	
	local dimensionSize = self.dimensionSize
	
	local velocityArray = self.velocityArray
	
	local isInertiaArrayTable = (type(inertiaArray) == "table")
	
	local isCognitiveArrayTable = (type(cognitiveArray) == "table")
	
	local isSocialArrayTable = (type(socialArray) == "table")
	
	for dimensionIndex = 1, dimensionSize, 1 do
		
		local inertia = (isInertiaArrayTable and (inertiaArray[dimensionIndex] or 0)) or inertiaArray
		
		local cognitive = (isCognitiveArrayTable and (cognitiveArray[dimensionIndex] or 0)) or cognitiveArray
		
		local social = (isSocialArrayTable and (socialArray[dimensionIndex] or 0)) or socialArray
		
		local newVelocity = inertia + cognitive + social
		
		velocityArray[dimensionIndex] = newVelocity
		
	end
	
end

function Particle:move(minimumBoundArray, maximumBoundArray) -- The change in position of the particle is based on the space they have, hence the bound arrays should not be kept as internal particle properties.
	
	local dimensionSize = self.dimensionSize
	
	local positionArray = self.positionArray
	
	local velocityArray = self.velocityArray
	
	if (not minimumBoundArray) then minimumBoundArray = -mathHuge end
	
	if (not maximumBoundArray) then maximumBoundArray = mathHuge end
	
	local isMinimumBoundArrayTable = (type(minimumBoundArray) == "table")
	
	local isMaximumBoundArrayTable = (type(maximumBoundArray) == "table")
	
	for dimensionIndex = 1, dimensionSize, 1 do
		
		local position = positionArray[dimensionIndex]
		
		local velocity = velocityArray[dimensionIndex]
		
		local minimumBound = (isMinimumBoundArrayTable and (minimumBoundArray[dimensionIndex] or -mathHuge)) or minimumBoundArray
		
		local maximumBound = (isMaximumBoundArrayTable and (maximumBoundArray[dimensionIndex] or mathHuge)) or maximumBoundArray
		
		local newPosition = position + velocity
		
		newPosition = math.clamp(newPosition, minimumBound, maximumBound)
		
		positionArray[dimensionIndex] = newPosition
		
	end
	
end

function Particle:record(score)
	
	if (score < self.bestScore) then return false end
	
	self.bestPositionArray = tableClone(self.positionArray)
	
	self.bestScore = score
	
	return true
	
end

function Particle:setPositionArray(positionArray, doNotDeepCopy)
	
	positionArray = (doNotDeepCopy and positionArray) or deepCopyValue(positionArray)
	
	self.positionArray = positionArray
	
end

function Particle:getPositionArray(doNotDeepCopy)
	
	if (doNotDeepCopy) then return self.positionArray end
	
	return deepCopyValue(self.positionArray)
	
end

function Particle:setVelocityArray(velocityArray, doNotDeepCopy)
	
	velocityArray = (doNotDeepCopy and velocityArray) or deepCopyValue(velocityArray)
	
	self.velocityArray = velocityArray
	
end

function Particle:getVelocityArray(doNotDeepCopy)
	
	if (doNotDeepCopy) then return self.velocityArray end
	
	return deepCopyValue(self.velocityArray)
	
end

function Particle:setBestPositionArray(bestPositionArray, doNotDeepCopy)
	
	bestPositionArray = (doNotDeepCopy and bestPositionArray) or deepCopyValue(bestPositionArray)
	
	self.bestPositionArray = bestPositionArray
	
end

function Particle:getBestPositionArray(doNotDeepCopy)

	if (doNotDeepCopy) then return self.bestPositionArray end

	return deepCopyValue(self.bestPositionArray)

end

function Particle:setBestScore(bestScore)
	
	self.bestScore = bestScore
	
end

function Particle:getBestScore()
	
	return self.bestScore
	
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
