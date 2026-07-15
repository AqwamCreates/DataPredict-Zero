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

local BaseGene = require(script.Parent.BaseGene)

local mathRandom = math.random

local mathSqrt = math.sqrt

local mathLog = math.log

local mathCos = math.cos

local mathPi = math.pi

local ContinuousGene = {}

ContinuousGene.__index = ContinuousGene

setmetatable(ContinuousGene, BaseGene)

function ContinuousGene.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}

	local value = parameterDictionary.value or 0
	
	local mutationChance = parameterDictionary.mutationChance or 0
	
	local mutationStandardDeviation = parameterDictionary.mutationStandardDeviation or 1
	
	parameterDictionary.type = "Continuous"
	
	local NewContinuousGene = BaseGene.new(parameterDictionary)

	setmetatable(NewContinuousGene, ContinuousGene)

	NewContinuousGene.mutationStandardDeviation = mutationStandardDeviation

	return NewContinuousGene

end

function ContinuousGene:mutate(forceMutate)
	
	if (not forceMutate) and (self.mutationChance <= mathRandom()) then return end
		
	local mutationValue = self.mutationStandardDeviation * mathSqrt(-2 * mathLog(mathRandom())) * mathCos(2 * mathPi * mathRandom())

	self.value = self.value + mutationValue

end

return ContinuousGene
