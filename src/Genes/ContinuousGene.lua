--[[

	--------------------------------------------------------------------

	Aqwam's Genetic Evolution Library (DataPredict Genetics)

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

local mathRandom = math.random

local mathSqrt = math.sqrt

local mathLog = math.log

local mathCos = math.cos

local mathPi = math.pi

local ContinuousGene = {}

function ContinuousGene.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}

	local self = setmetatable({}, ContinuousGene)

	self.value = parameterDictionary.value or parameterDictionary[1] or 0

	self.mutationChance = parameterDictionary.mutationChance or parameterDictionary[2] or 0

	self.mutationStandardDeviation = parameterDictionary.mutationStandardDeviation or parameterDictionary[3] or 1

	return self

end

function ContinuousGene:mutate(ignoreChance)

	if (self.mutationChance <= math.random()) then return end

	local noise = self.mutationStandardDeviation * mathSqrt(-2 * mathLog(mathRandom())) * mathCos(2 * mathPi * mathRandom())

	self.value = self.value + noise

end

return ContinuousGene
