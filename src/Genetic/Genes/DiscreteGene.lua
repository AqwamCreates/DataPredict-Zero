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

local DiscreteGene = {}

DiscreteGene.__index = DiscreteGene

setmetatable(DiscreteGene, BaseGene)

local mutationModeFunctionList = {
	
	["Global"] = function(arrayIndex, mutationWeightArray, stepSize)

		local totalWeight = 0

		for _, weight in ipairs(mutationWeightArray) do totalWeight = totalWeight + weight end
		
		if (totalWeight == 0) then return mathRandom(#mutationWeightArray) end

		local randomPoint = mathRandom() * totalWeight

		local accumulatedWeight = 0

		local newArrayIndex

		for currentArrayIndex, weight in ipairs(mutationWeightArray) do

			accumulatedWeight = accumulatedWeight + weight

			if (randomPoint <= accumulatedWeight) then return currentArrayIndex end

		end

	end,
	
	["Stepwise"] = function(arrayIndex, mutationWeightArray, stepSize)

		local numberOfMutationWeights = #mutationWeightArray

		local totalWeight = 0

		for _, weight in ipairs(mutationWeightArray) do totalWeight = totalWeight + weight end
		
		if (totalWeight == 0) then return mathRandom(numberOfMutationWeights) end

		local randomPoint = mathRandom() * totalWeight

		local accumulatedWeight = 0

		local currentArrayIndex = arrayIndex

		local newArrayIndex

		repeat

			accumulatedWeight = accumulatedWeight + mutationWeightArray[currentArrayIndex]

			if (randomPoint <= accumulatedWeight) then newArrayIndex = currentArrayIndex end

			currentArrayIndex = currentArrayIndex + stepSize

			if (currentArrayIndex > numberOfMutationWeights) then

				currentArrayIndex = currentArrayIndex - numberOfMutationWeights

			elseif (currentArrayIndex <= 0) then

				currentArrayIndex = numberOfMutationWeights + currentArrayIndex

			end

		until newArrayIndex
		
		return newArrayIndex
		
	end,
	
	["Local"] = function(arrayIndex, mutationWeightArray, stepSize)
		
		local numberOfMutationWeights = #mutationWeightArray

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

		if (arrayIndex < numberOfMutationWeights) then

			table.insert(neighbourIndexArray, arrayIndexPlusOne)

			table.insert(neighbourWeightArray, mutationWeightArray[arrayIndexPlusOne])

		end

		local totalWeight = 0

		for _, weight in ipairs(neighbourWeightArray) do totalWeight = totalWeight + weight end
		
		if (totalWeight == 0) then return mathRandom(#neighbourWeightArray) end

		local randomPoint = mathRandom() * totalWeight

		local accumulatedWeight = 0

		for i, weight in ipairs(neighbourWeightArray) do

			accumulatedWeight = accumulatedWeight + weight

			if (randomPoint <= accumulatedWeight) then return neighbourIndexArray[i] end

		end
		
	end,
	
}

function DiscreteGene.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}

	local value = parameterDictionary.value or 0

	local mutationChance = parameterDictionary.mutationChance or 0

	local mutationChoiceArray =  parameterDictionary.mutationChoiceArray or {value}

	local mutationWeightArray = parameterDictionary.mutationWeightArray or table.create(#mutationChoiceArray, 1)
	
	local stepSize = parameterDictionary.stepSize or 1
	
	local mutationMode = parameterDictionary.mutationMode or "Local"
	
	parameterDictionary.type = "Discrete"
	
	local NewDiscreteGene = BaseGene.new(parameterDictionary)
	
	setmetatable(NewDiscreteGene, DiscreteGene)

	NewDiscreteGene.mutationChoiceArray = mutationChoiceArray

	NewDiscreteGene.mutationWeightArray = mutationWeightArray
	
	NewDiscreteGene.stepSize = stepSize
	
	NewDiscreteGene.mutationMode = mutationMode

	return NewDiscreteGene

end

function DiscreteGene:mutate(forceMutate)

	if (not forceMutate) and (self.mutationChance <= mathRandom()) then return end
	
	local mutationChoiceArray = self.mutationChoiceArray
	
	local arrayIndex = table.find(mutationChoiceArray, self.value)
	
	local newArrayIndex
	
	if (arrayIndex) then
		
		local mutationFunction = mutationModeFunctionList[self.mutationMode]

		if (not mutationFunction) then error("Invalid mutation mode.") end

		newArrayIndex = mutationFunction(arrayIndex, self.mutationWeightArray, self.stepSize)
		
	else
		
		newArrayIndex = mathRandom(#mutationChoiceArray)

	end
	
	self.value = mutationChoiceArray[newArrayIndex]
	
end

return DiscreteGene
