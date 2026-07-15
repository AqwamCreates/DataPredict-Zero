--[[

	--------------------------------------------------------------------

	Aqwam's Evolution Library (DataPredict Evolution)

	Author: Aqwam Harish Aiman
	
	Email: aqwam.harish.aiman@gmail.com
	
	YouTube: https://www.youtube.com/channel/UCUrwoxv5dufEmbGsxyEUPZw
	
	LinkedIn: https://www.linkedin.com/in/aqwam-harish-aiman/
	
	--------------------------------------------------------------------
		
	By using this library, you agree to comply with our Terms and Conditions in the link below:
	
	https://github.com/AqwamCreates/DataPredict-Evolution/blob/main/docs/TermsAndConditions.md
	
	--------------------------------------------------------------------
	
	DO NOT REMOVE THIS TEXT!
	
	--------------------------------------------------------------------

--]]

local BaseSelector = require(script.Parent.BaseSelector)

local mathRandom = math.random

local RandomSelector = {}

RandomSelector.__index = RandomSelector

setmetatable(RandomSelector, BaseSelector)

function RandomSelector.new(parameterDictionary)
	
	parameterDictionary = parameterDictionary or {}
	
	parameterDictionary.type = "Random"
	
	local NewRandomSelector = BaseSelector.new(parameterDictionary)
	
	setmetatable(NewRandomSelector, RandomSelector)
	
	return NewRandomSelector
	
end

function RandomSelector:select(ChromosomeAndScoreDictionaryArray)
	
	local numberOfChromosomes = #ChromosomeAndScoreDictionaryArray
	
	local randomArrayIndex = mathRandom(1, numberOfChromosomes)
	
	local ChromosomeAndScoreDictionary = ChromosomeAndScoreDictionaryArray[randomArrayIndex]
	
	local Chromosome = ChromosomeAndScoreDictionary.Chromosome

	return Chromosome
	
end

return RandomSelector
