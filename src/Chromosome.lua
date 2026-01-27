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

function Chromosome.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}

	local self = setmetatable({}, Chromosome)

	local geneArray = parameterDictionary.geneArray or parameterDictionary[1] or {}
	
	local activationFunction = parameterDictionary.activationFunction or parameterDictionary[2] or function(...) return ... end
	
	local mutationChance = parameterDictionary.mutationChance or parameterDictionary[3] or 0

	return self

end

function Chromosome:mutate(forceMutateChromosome, forceMutateGene)
	
	if (not forceMutateChromosome) and (self.mutationChance <= mathRandom()) then return end
	
	for i, Gene in ipairs(self.geneArray) do Gene:mutate(forceMutateGene) end
	
end

function Chromosome:activate()
	
	local valueArray = {}
	
	for i, Gene in ipairs(self.geneArray) do valueArray[i] = Gene.value end
	
	return self.activationFunction(table.unpack(valueArray))
	
end

function Chromosome:__tostring()
	
	local stringText = "{"
	
	local geneArray = self.geneArray
	
	local numberOfGenes = #geneArray
	
	for i, Gene in ipairs(geneArray) do stringText = stringText .. Gene .. (i < #numberOfGenes and " " or "") end
	
	stringText = stringText .. "}"
	
	return stringText
	
end
	
return Chromosome
