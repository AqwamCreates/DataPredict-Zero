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

local SchrodingerBox = {}

SchrodingerBox.__index = SchrodingerBox

local function defaultEvaluationFunction(positionArray, environmentArray)
	
	local score = 0

	for i, position in ipairs(positionArray) do 

		local environmentValue = environmentArray[i]

		score = score + (position * environmentValue)

	end
	
	return score

end

function SchrodingerBox.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}
	
	local ParticleArray = parameterDictionary.ParticleArray or {}
	
	local particleCount = parameterDictionary.particleCount or 100
	
	local particleCountInArray = #ParticleArray
	
	if (particleCountInArray > 0) then particleCount = particleCountInArray end
	
	local dimensionSize = parameterDictionary.dimensionSize or 1
	
	local evaluateFunction = parameterDictionary.evaluateFunction or defaultEvaluationFunction
	
	local inertiaCoefficientArray = parameterDictionary.inertiaCoefficientArray or table.create(dimensionSize, 0)
	
	local cognitiveCofficientArray = parameterDictionary.cognitiveCofficientArray or table.create(dimensionSize, 0)
	
	local socialCoefficientArray = parameterDictionary.socialCoefficientArray or table.create(dimensionSize, 0)
	
	local minimumBoundArray = parameterDictionary.minimumBoundArray or table.create(dimensionSize, -mathHuge)
	
	local maximumBoundArray = parameterDictionary.maximumBoundArray or table.create(dimensionSize, mathHuge)
	
	local globalBestScore = parameterDictionary.globalBestScore or -mathHuge
	
	local globalBestPositionArray = parameterDictionary.globalBestPositionArray or table.create(dimensionSize, 0)

	local NewSchrodingerBox = {}

	setmetatable(NewSchrodingerBox, SchrodingerBox)
	
	for i = 1, particleCount, 1 do
		
		ParticleArray[i] = ParticleArray[i] or Particle.new({dimensionSize = dimensionSize})
		
	end
	
	NewSchrodingerBox.ParticleArray = ParticleArray
	
	NewSchrodingerBox.particleCount = particleCount
	
	NewSchrodingerBox.dimensionSize = dimensionSize
	
	NewSchrodingerBox.evaluateFunction = evaluateFunction
	
	NewSchrodingerBox.inertiaCoefficientArray = inertiaCoefficientArray
	
	NewSchrodingerBox.cognitiveCofficientArray = cognitiveCofficientArray
	
	NewSchrodingerBox.socialCoefficientArray = socialCoefficientArray
	
	NewSchrodingerBox.minimumBoundArray = minimumBoundArray
	
	NewSchrodingerBox.maximumBoundArray = maximumBoundArray
	
	NewSchrodingerBox.globalBestScore = globalBestScore
	
	NewSchrodingerBox.globalBestPositionArray = globalBestPositionArray

	return NewSchrodingerBox

end

function SchrodingerBox:observe(environmentArray)

	local ParticleArray = self.ParticleArray
	
	local dimensionSize = self.dimensionSize
	
	local evaluateFunction = self.evaluateFunction

	local minimumBoundArray = self.minimumBoundArray
	
	local maximumBoundArray = self.maximumBoundArray

	local inertiaCoefficientArray = self.inertiaCoefficientArray
	
	local cognitiveCofficientArray = self.cognitiveCofficientArray
	
	local socialCoefficientArray = self.socialCoefficientArray
	
	local globalBestScore = self.globalBestScore

	local globalBestPositionArray = self.globalBestPositionArray

	local hasNewGlobalValues = false

	for _, Particle in ipairs(ParticleArray) do
		
		local positionArray = Particle:getPositionArray()
		
		local score = evaluateFunction(positionArray, environmentArray)

		if (Particle:record(score)) then

			if (score > globalBestScore) then
				
				globalBestScore = score
				
				globalBestPositionArray = Particle:getBestPositionArray()

				hasNewGlobalValues = true
				
			end
			
		end
		
	end

	for _, Particle in ipairs(ParticleArray) do
		
		local positionArray = Particle:getPositionArray(true)
		
		local velocityArray = Particle:getVelocityArray(true)
		
		local bestPositionArray = Particle:getBestPositionArray(true)

		local inertiaArray = {}
		
		local cognitiveArray = {}
		
		local socialArray = {}

		for i = 1, dimensionSize, 1 do
			
			local randomValue1 = mathRandom()
			
			local randomValue2 = mathRandom()

			inertiaArray[i] = inertiaCoefficientArray[i] * velocityArray[i]

			cognitiveArray[i] = cognitiveCofficientArray[i] * randomValue1 * (bestPositionArray[i] - positionArray[i])

			socialArray[i] = socialCoefficientArray[i] * randomValue2 * (globalBestPositionArray[i] - positionArray[i])
			
		end

		Particle:updateVelocity(inertiaArray, cognitiveArray, socialArray)

		Particle:move(minimumBoundArray, maximumBoundArray)
		
	end
	
	self.globalBestPositionArray = globalBestPositionArray

	self.globalBestScore = globalBestScore

	return globalBestPositionArray, globalBestScore, hasNewGlobalValues
	
end

function SchrodingerBox:destroy()

	table.clear(self)

	setmetatable(self, nil)

	self = nil

end

return SchrodingerBox
