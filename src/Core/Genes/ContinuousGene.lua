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

local BaseGene = require(script.Parent.BaseGene)

local mathRandom = math.random

local mathSqrt = math.sqrt

local mathLog = math.log

local mathCos = math.cos

local mathPi = math.pi

local safeMaximumValue = 4.5e15

local safeMinimumValue = -4.5e15

local ContinuousGene = {}

ContinuousGene.__index = ContinuousGene

setmetatable(ContinuousGene, BaseGene)

function ContinuousGene.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}

	local value = parameterDictionary.value or 0
	
	local mutationChance = parameterDictionary.mutationChance or 0
	
	local maximumValue = parameterDictionary.maximumValue or safeMaximumValue
	
	local minimumValue = parameterDictionary.minimumValue or safeMinimumValue
	
	local mutationStandardDeviation = parameterDictionary.mutationStandardDeviation or 1
	
	local mutationMode = parameterDictionary.mutationMode or "Local"
	
	value = math.clamp(value, minimumValue, maximumValue)
	
	parameterDictionary.type = "Continuous"
	
	local NewContinuousGene = BaseGene.new(parameterDictionary)

	setmetatable(NewContinuousGene, ContinuousGene)
	
	NewContinuousGene.maximumValue = maximumValue
	
	NewContinuousGene.minimumValue = minimumValue
	
	NewContinuousGene.mutationStandardDeviation = mutationStandardDeviation
	
	NewContinuousGene.mutationMode = mutationMode

	return NewContinuousGene

end

function ContinuousGene:mutate(forceMutate)
	
	if (not forceMutate) and (self.mutationProbability <= mathRandom()) then return end
	
	local mutationValue = self.value
	
	local maximumValue = self.maximumValue
	
	local minimumValue = self.minimumValue
	
	local mutationMode = self.mutationMode
	
	if (mutationMode == "Local") then
		
		local noiseValue = self.mutationStandardDeviation * mathSqrt(-2 * mathLog(mathRandom())) * mathCos(2 * mathPi * mathRandom())
		
		mutationValue = mutationValue + noiseValue
		
	elseif (mutationMode == "Global") then
		
		local range = maximumValue - minimumValue
		
		mutationValue = minimumValue + (mathRandom() * range)
		
	else
		
		error("Invalid mutation mode.")
		
	end
	
	mutationValue = math.clamp(mutationValue, minimumValue, maximumValue)

	self.value = mutationValue

end

return ContinuousGene
