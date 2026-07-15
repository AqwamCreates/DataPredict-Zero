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

local BaseSelector = require(script.Parent.BaseSelector)

local mathRandom = math.random

local mathPower = math.pow

local RankSelector = {}

RankSelector.__index = RankSelector

setmetatable(RankSelector, BaseSelector)

function RankSelector.new(parameterDictionary)
	
	parameterDictionary = parameterDictionary or {}
	
	local pressure = parameterDictionary.pressure or 1
	
	parameterDictionary.type = "Rank"
	
	local NewRankSelector = BaseSelector.new(parameterDictionary)
	
	setmetatable(NewRankSelector, RankSelector)
	
	NewRankSelector.pressure = pressure
	
	return NewRankSelector
	
end

function RankSelector:select(ChromosomeAndScoreDictionaryArray)
	
	local p = self.pressure
	
	local numberOfChromosomes = #ChromosomeAndScoreDictionaryArray
	
	local totalWeight = 0
	
	local weightArray = {}

	for arrayIndex, ChromosomeAndScoreDictionary in ipairs(ChromosomeAndScoreDictionaryArray) do

		local rankValue = numberOfChromosomes - arrayIndex + 1

		local weight = mathPower(rankValue, p)

		weightArray[arrayIndex] = weight
		
		totalWeight = totalWeight + weight

	end

	if (totalWeight == 0) then
		
		local randomArrayIndex = mathRandom(1, numberOfChromosomes)
		
		local ChromosomeAndScoreDictionary = ChromosomeAndScoreDictionaryArray[randomArrayIndex]
		
		local Chromosome = ChromosomeAndScoreDictionary.Chromosome
		
		return Chromosome
		
	end

	local spinValue = mathRandom() * totalWeight
	
	local currentSumValue = 0

	for arrayIndex, ChromosomeAndScoreDictionary in ipairs(ChromosomeAndScoreDictionaryArray) do

		currentSumValue = currentSumValue + weightArray[arrayIndex]

		if (spinValue <= currentSumValue) then

			return ChromosomeAndScoreDictionary.Chromosome

		end

	end
	
	local ChromosomeAndScoreDictionary = ChromosomeAndScoreDictionaryArray[numberOfChromosomes]
	
	local Chromosome = ChromosomeAndScoreDictionary.Chromosome
	
	return Chromosome
	
end

return RankSelector
