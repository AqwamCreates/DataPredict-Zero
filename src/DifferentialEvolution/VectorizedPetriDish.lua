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

local Particle = require(script.Parent.Parent.Core.Particle)

local mathHuge = math.huge

local mathRandom = math.random

local tableClone = table.clone

local VectorizedPetriDish = {}

VectorizedPetriDish.__index = VectorizedPetriDish

local function defaultEvaluateFunction(positionArray, environmentArray)
	
	local score = 0

	for i, position in ipairs(positionArray) do 

		local environmentValue = environmentArray[i]

		score = score + (position * environmentValue)

	end
	
	return score

end

function VectorizedPetriDish.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}
	
	local ParticleArray = parameterDictionary.ParticleArray or {}
	
	local populationSize = parameterDictionary.populationSize or 100
	
	local numberOfParticlesInArray = #ParticleArray
	
	if (numberOfParticlesInArray > 0) then populationSize = numberOfParticlesInArray end
	
	local dimensionSize = parameterDictionary.dimensionSize or 1
	
	local evaluateFunction = parameterDictionary.evaluateFunction or defaultEvaluateFunction
	
	local crossoverProbability = parameterDictionary.crossoverProbability or 0.9
	
	local differentialWeightFactor = parameterDictionary.differentialWeightFactor or 0.8 -- Must be set between 0 and 2.
	
	local socialCoefficientArray = parameterDictionary.socialCoefficientArray or table.create(dimensionSize, 0)
	
	local minimumBoundArray = parameterDictionary.minimumBoundArray or table.create(dimensionSize, -mathHuge)
	
	local maximumBoundArray = parameterDictionary.maximumBoundArray or table.create(dimensionSize, mathHuge)
	
	local globalBestScore = parameterDictionary.globalBestScore or -mathHuge
	
	local globalBestPositionArray = parameterDictionary.globalBestPositionArray or table.create(dimensionSize, 0)

	local NewVectorizedPetriDish = {}

	setmetatable(NewVectorizedPetriDish, VectorizedPetriDish)
	
	for i = 1, populationSize, 1 do
		
		ParticleArray[i] = ParticleArray[i] or Particle.new({dimensionSize = dimensionSize})
		
	end
	
	NewVectorizedPetriDish.ParticleArray = ParticleArray
	
	NewVectorizedPetriDish.populationSize = populationSize
	
	NewVectorizedPetriDish.dimensionSize = dimensionSize
	
	NewVectorizedPetriDish.evaluateFunction = evaluateFunction
	
	NewVectorizedPetriDish.crossoverProbability = crossoverProbability
	
	NewVectorizedPetriDish.differentialWeightFactor = differentialWeightFactor
	
	NewVectorizedPetriDish.socialCoefficientArray = socialCoefficientArray
	
	NewVectorizedPetriDish.minimumBoundArray = minimumBoundArray
	
	NewVectorizedPetriDish.maximumBoundArray = maximumBoundArray
	
	NewVectorizedPetriDish.globalBestScore = globalBestScore
	
	NewVectorizedPetriDish.globalBestPositionArray = globalBestPositionArray

	return NewVectorizedPetriDish

end

function VectorizedPetriDish:observe(environmentArray)

	local ParticleArray = self.ParticleArray
	
	local populationSize = self.populationSize
	
	local dimensionSize = self.dimensionSize
	
	local evaluateFunction = self.evaluateFunction

	local minimumBoundArray = self.minimumBoundArray
	
	local maximumBoundArray = self.maximumBoundArray

	local crossoverProbability = self.crossoverProbability
	
	local differentialWeightFactor = self.differentialWeightFactor
	
	local globalBestScore = self.globalBestScore

	local globalBestPositionArray = self.globalBestPositionArray
	
	local hasNewGlobalValues = false

	for particleIndex, Particle in ipairs(ParticleArray) do
		
		local localParticleArray = {Particle}
		
		repeat
			
			local randomParticleIndex = mathRandom(1, populationSize)
			
			local RandomParticle = ParticleArray[randomParticleIndex]
			
			local localParticleArrayIndex = table.find(localParticleArray, RandomParticle)
			
			if (not localParticleArrayIndex) then table.insert(localParticleArray, RandomParticle) end
			
		until (#localParticleArray >= 4)
		
		local ParticleX = localParticleArray[1]
		
		local ParticleA = localParticleArray[2]

		local ParticleB = localParticleArray[3]

		local ParticleC = localParticleArray[4]

		local randomDimensionIndex = mathRandom(1, dimensionSize)

		local positionXArray = ParticleX:getPositionArray(true)

		local positionAArray = ParticleA:getPositionArray(true)

		local positionBArray = ParticleB:getPositionArray(true)

		local positionCArray = ParticleC:getPositionArray(true)

		local mutatedPositionXArray = table.create(dimensionSize, 0)

		for dimensionIndex, positionXValue in ipairs(positionXArray) do

			local randomProbability = mathRandom()

			if (randomProbability < crossoverProbability) or (dimensionIndex == randomDimensionIndex) then

				local positionAValue = positionAArray[dimensionIndex]

				local positionBValue = positionBArray[dimensionIndex]

				local positionCValue = positionCArray[dimensionIndex]

				local newPositionXValue = positionAValue + (differentialWeightFactor * (positionBValue - positionCValue))

				mutatedPositionXArray[dimensionIndex] = newPositionXValue

			else

				mutatedPositionXArray[dimensionIndex] = positionXValue

			end

		end

		local originalXScore = evaluateFunction(positionXArray, environmentArray)

		local mutatedXScore = evaluateFunction(mutatedPositionXArray, environmentArray)

		local selectedXScore

		local selectedPositionArray

		if (mutatedXScore > originalXScore) then

			selectedXScore = mutatedXScore

			selectedPositionArray = mutatedPositionXArray

		else

			selectedXScore = originalXScore

			selectedPositionArray = positionXArray

		end
		
		Particle:setPositionArray(selectedPositionArray)
		
		Particle:record(selectedXScore)
		
		if (selectedXScore > globalBestScore) then
			
			globalBestScore = selectedXScore
			
			globalBestPositionArray = selectedPositionArray
			
			hasNewGlobalValues = true
			
		end
		
	end
	
	self.globalBestPositionArray = globalBestPositionArray

	self.globalBestScore = globalBestScore

	return globalBestPositionArray, globalBestScore, hasNewGlobalValues
	
end

function VectorizedPetriDish:destroy()

	table.clear(self)

	setmetatable(self, nil)

	self = nil

end

return VectorizedPetriDish
