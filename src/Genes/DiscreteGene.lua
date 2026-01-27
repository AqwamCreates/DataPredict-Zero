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

local DiscreteGene = {}

function DiscreteGene.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}

	local self = setmetatable({}, DiscreteGene)

	local value = parameterDictionary.value or parameterDictionary[1] or 0

	local mutationChoiceArray =  parameterDictionary.mutationChoiceArray or parameterDictionary[3] or {value}

	local numberOfMutationChoices = #mutationChoiceArray

	self.value = value

	self.mutationChance = parameterDictionary.mutationChance or parameterDictionary[2] or 0

	self.mutationChoiceArray = mutationChoiceArray

	self.mutationWeightArray = parameterDictionary.mutationWeightArray or parameterDictionary[4] or table.create(numberOfMutationChoices, 1)

	return self

end

function DiscreteGene:mutate(ignoreChance)

	if (self.mutationChance <= mathRandom()) then return end

	local mutationChoiceArray = self.mutationChoiceArray
	
	local mutationWeightArray = self.mutationWeightArray

	local totalWeight = 0

	for _, weight in ipairs(mutationWeightArray) do totalWeight = totalWeight + weight end

	local randomPoint = mathRandom() * totalWeight

	local accumulatedWeight = 0

	for i, weight in ipairs(mutationWeightArray) do

		accumulatedWeight = accumulatedWeight + weight

		if (randomPoint <= accumulatedWeight) then

			self.value = mutationChoiceArray[i]

			break

		end

	end

end

return DiscreteGene
