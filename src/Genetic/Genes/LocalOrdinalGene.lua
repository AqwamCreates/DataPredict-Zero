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

local LocalOrdinalGene = {}

LocalOrdinalGene.__index = LocalOrdinalGene

setmetatable(LocalOrdinalGene, BaseGene)

function LocalOrdinalGene.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}

	local value = parameterDictionary.value or 0

	local mutationChance = parameterDictionary.mutationChance or 0

	local mutationChoiceArray =  parameterDictionary.mutationChoiceArray or {value}

	local numberOfMutationChoices = #mutationChoiceArray

	local mutationWeightArray = parameterDictionary.mutationWeightArray or table.create(numberOfMutationChoices, 1)
	
	parameterDictionary.type = "LocalOrdinal"
	
	local NewLocalOrdinalGene = BaseGene.new(parameterDictionary)
	
	setmetatable(NewLocalOrdinalGene, LocalOrdinalGene)

	NewLocalOrdinalGene.mutationChoiceArray = mutationChoiceArray

	NewLocalOrdinalGene.mutationWeightArray = mutationWeightArray

	return NewLocalOrdinalGene

end

function LocalOrdinalGene:mutate(forceMutate)

	if (not forceMutate) and (self.mutationChance <= mathRandom()) then return end

	local mutationChoiceArray = self.mutationChoiceArray
	
	local mutationWeightArray = self.mutationWeightArray
	
	local arrayIndex = table.find(mutationChoiceArray, self.value)
	
	if (not arrayIndex) then
		
		self.value = mutationChoiceArray[mathRandom(#mutationChoiceArray)]
		
		return
		
	end
	
	local arrayIndexMinusOne = arrayIndex - 1
	
	local arrayIndexPlusOne = arrayIndex + 1

	local neighbourIndexArray = {}
	
	local neighbourWeightArray = {}

	if (arrayIndex > 1) then
		
		table.insert(neighbourIndexArray, arrayIndexMinusOne)
		
		table.insert(neighbourWeightArray, mutationWeightArray[arrayIndexMinusOne])
		
	end

	table.insert(neighbourIndexArray, arrayIndex)
	
	table.insert(neighbourWeightArray, mutationWeightArray[arrayIndex])

	if (arrayIndex < #mutationChoiceArray) then
		
		table.insert(neighbourIndexArray, arrayIndexPlusOne)
		
		table.insert(neighbourWeightArray, mutationWeightArray[arrayIndexPlusOne])
		
	end

	local totalWeight = 0
	
	for _, weight in ipairs(neighbourWeightArray) do totalWeight = totalWeight + weight end

	local randomPoint = mathRandom() * totalWeight
	
	local accumulatedWeight = 0

	for i, weight in ipairs(neighbourWeightArray) do
		
		accumulatedWeight = accumulatedWeight + weight
		
		if (randomPoint <= accumulatedWeight) then
			
			self.value = mutationChoiceArray[neighbourIndexArray[i]]
			
			break
			
		end
		
	end
	
end

return LocalOrdinalGene
