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

local BaseGene = require(script.Parent.BaseGene)

local mathRandom = math.random

local GlobalOrdinalGene = {}

GlobalOrdinalGene.__index = GlobalOrdinalGene

setmetatable(GlobalOrdinalGene, BaseGene)

function GlobalOrdinalGene.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}

	local value = parameterDictionary.value or 0

	local mutationChance = parameterDictionary.mutationChance or 0

	local mutationChoiceArray =  parameterDictionary.mutationChoiceArray or {value}

	local numberOfMutationChoices = #mutationChoiceArray

	local mutationWeightArray = parameterDictionary.mutationWeightArray or table.create(numberOfMutationChoices, 1)
	
	local indexChange = parameterDictionary.indexChange or 1
	
	parameterDictionary.type = "GlobalOrdinal"
	
	local NewGlobalOrdinalGene = BaseGene.new(parameterDictionary)
	
	setmetatable(NewGlobalOrdinalGene, GlobalOrdinalGene)

	NewGlobalOrdinalGene.mutationChoiceArray = mutationChoiceArray

	NewGlobalOrdinalGene.mutationWeightArray = mutationWeightArray
	
	NewGlobalOrdinalGene.indexChange = indexChange

	return NewGlobalOrdinalGene

end

function GlobalOrdinalGene:mutate(forceMutate)

	if (not forceMutate) and (self.mutationChance <= mathRandom()) then return end

	local mutationChoiceArray = self.mutationChoiceArray
	
	local mutationWeightArray = self.mutationWeightArray
	
	local indexChange = self.indexChange
	
	local numberOfMutationChoices = #mutationChoiceArray
	
	local arrayIndex = table.find(mutationChoiceArray, self.value)
	
	if (not arrayIndex) then
		
		self.value = mutationChoiceArray[mathRandom(numberOfMutationChoices)]
		
		return
		
	end

	local totalWeight = 0
	
	for _, weight in ipairs(mutationWeightArray) do totalWeight = totalWeight + weight end
	
	local randomPoint = mathRandom() * totalWeight
	
	local accumulatedWeight = 0
	
	local currentIndex = arrayIndex
	
	local newValue
	
	repeat
		
		accumulatedWeight = accumulatedWeight + mutationWeightArray[currentIndex]
		
		if (randomPoint <= accumulatedWeight) then newValue = mutationChoiceArray[currentIndex] end
		
		currentIndex = currentIndex + indexChange
		
		if (currentIndex > numberOfMutationChoices) then
			
			currentIndex = currentIndex - numberOfMutationChoices
			
		elseif (currentIndex <= 0) then
			
			currentIndex = numberOfMutationChoices + currentIndex
			
		end
		
	until newValue
	
	self.value = newValue
	
end

return GlobalOrdinalGene
