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

local Chromosome = {}

Chromosome.__index = Chromosome

local function defaultActivationFunction(valueArray, environmentArray)

	local activationValue = 0

	for i, value in ipairs(valueArray) do 

		local environmentValue = environmentArray[i]

		activationValue = activationValue + (value * environmentValue)

	end

	return activationValue

end

local function deepCopyValue(original, copies)

	copies = copies or {}

	local originalType = type(original)

	local copy

	if (originalType == 'table') then

		if copies[original] then

			copy = copies[original]

		else

			copy = {}

			copies[original] = copy

			for originalKey, originalValue in next, original, nil do

				copy[deepCopyValue(originalKey, copies)] = deepCopyValue(originalValue, copies)

			end

			setmetatable(copy, deepCopyValue(getmetatable(original), copies))

		end

	else

		copy = original

	end

	return copy

end

function Chromosome.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}
	
	local NewChromosome = {}

	setmetatable(NewChromosome, Chromosome)

	NewChromosome.geneArray = parameterDictionary.geneArray or {}
	
	NewChromosome.activationFunction = parameterDictionary.activationFunction or defaultActivationFunction
	
	NewChromosome.mutationChance = parameterDictionary.mutationChance or 0

	return NewChromosome

end

function Chromosome:mutate(forceMutateChromosome, forceMutateGene)
	
	if (not forceMutateChromosome) and (self.mutationChance <= mathRandom()) then return end
	
	for i, Gene in ipairs(self.geneArray) do Gene:mutate(forceMutateGene) end
	
end

function Chromosome:activate(environmentArray)
	
	local valueArray = {}
	
	for i, Gene in ipairs(self.geneArray) do valueArray[i] = Gene.value end
	
	return self.activationFunction(valueArray, environmentArray)
	
end

function Chromosome:clone()

	return deepCopyValue(self)

end

function Chromosome:crossover(OtherChromosome, crossoverRate)
	
	local ClonedChromosome = self:clone()
	
	local ClonedOtherChromosome = OtherChromosome:clone()
	
	for geneIndex, ClonedGene in ipairs(ClonedChromosome.geneArray) do
		
		if (mathRandom() < crossoverRate) then
			
			local ClonedOtherGene = ClonedOtherChromosome.geneArray[geneIndex]
			
			local clonedGeneValue = ClonedGene.value
			
			local clonedOtherGeneValue = ClonedOtherGene.value
			
			ClonedGene.value = clonedOtherGeneValue
			
			ClonedOtherGene.value = clonedGeneValue
			
		end
		
	end
	
	return ClonedChromosome, ClonedOtherChromosome
	
end

function Chromosome:__tostring()
	
	local stringText = "{"
	
	local geneArray = self.geneArray
	
	local numberOfGenes = #geneArray
	
	for i, Gene in ipairs(geneArray) do stringText = stringText .. Gene .. (i < numberOfGenes and " " or "") end
	
	stringText = stringText .. "}"
	
	return stringText
	
end

function Chromosome:destroy()

	table.clear(self)

	setmetatable(self, nil)

	self = nil

end
	
return Chromosome
