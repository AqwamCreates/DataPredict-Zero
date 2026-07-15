--[[

	--------------------------------------------------------------------

	Aqwam's Evolution Library (DataPredict Evolution)

	Author: Aqwam Harish Aiman
	
	Email: aqwam.harish.aiman@gmail.com
	
	YouTube: https://www.youtube.com/channel/UCUrwoxv5dufEmbGsxyEUPZw
	
	LinkedIn: https://www.linkedin.com/in/aqwam-harish-aiman/
	
	--------------------------------------------------------------------
		
	By using this library, you agree to comply with our Terms and Conditions in the link below:
	
	https://github.com/AqwamCreates/DataPredict-Genetics/blob/main/docs/TermsAndConditions.md
	
	--------------------------------------------------------------------
	
	DO NOT REMOVE THIS TEXT!
	
	--------------------------------------------------------------------

--]]

local BaseSelector = require(script.Parent.BaseSelector)

local mathRandom = math.random

local mathAbs = math.abs

local RouletteWheelSelector = {}

RouletteWheelSelector.__index = RouletteWheelSelector

function RouletteWheelSelector.new(parameterDictionary)
	
	parameterDictionary = parameterDictionary or {}
	
	parameterDictionary.type = "RouletteWheel"
	
	local NewRouletteWheelSelector = BaseSelector.new(parameterDictionary)
	
	return NewRouletteWheelSelector
	
end

function RouletteWheelSelector:select(ChromosomeAndScoreDictionaryArray)
	
	local numberOfChromosomes = #ChromosomeAndScoreDictionaryArray
	
	local minimumScore = math.huge
	
	local totalFitness = 0
	
	for arrayIndex, ChromosomeAndScoreDictionary in ipairs(ChromosomeAndScoreDictionaryArray) do
		
		local score = ChromosomeAndScoreDictionary.score
		
		if (score < minimumScore) then minimumScore = score end
		
	end

	local offset = 0
	
	if (minimumScore < 0) then offset = mathAbs(minimumScore) end

	local totalFitness = 0
	
	local fitnessValueArray = {}
	
	for arrayIndex, ChromosomeAndScoreDictionary in ipairs(ChromosomeAndScoreDictionaryArray) do
		
		local score = ChromosomeAndScoreDictionary.score
		
		local adjustedScore = score + offset
		
		fitnessValueArray[arrayIndex] = adjustedScore
		
		totalFitness = totalFitness + adjustedScore
		
	end

	if (totalFitness == 0) then
		
		local randomIndex = mathRandom(1, numberOfChromosomes)
		
		local ChromosomeAndScoreDictionary = ChromosomeAndScoreDictionaryArray[randomIndex]
		
		local Chromosome = ChromosomeAndScoreDictionary.Chromosome
		
		return Chromosome
		
	end

	local spin = mathRandom() * totalFitness
	
	local currentSum = 0
	
	for arrayIndex, ChromosomeAndScoreDictionary in ipairs(ChromosomeAndScoreDictionaryArray) do
		
		currentSum = currentSum + fitnessValueArray[arrayIndex]
		
		if (spin <= currentSum) then

			local Chromosome = ChromosomeAndScoreDictionary.Chromosome

			return Chromosome
			
		end
		
	end
	
	local ChromosomeAndScoreDictionary = ChromosomeAndScoreDictionaryArray[numberOfChromosomes]
	
	local Chromosome = ChromosomeAndScoreDictionary.Chromosome

	return Chromosome
	
end

return RouletteWheelSelector
