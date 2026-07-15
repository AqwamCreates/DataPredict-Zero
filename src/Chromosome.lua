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

local Selectors = require(script.Parent.Selectors)

local tableInsert = table.insert

local tableSort = table.sort

local mathRandom = math.random

local mathMinimum = math.min

local PetriDish = {}

PetriDish.__index = PetriDish

function PetriDish.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}
	
	local NewPetriDish = {}

	setmetatable(NewPetriDish, PetriDish)
	
	NewPetriDish.populationCount = parameterDictionary.populationCount or 10

	NewPetriDish.eliteCount = parameterDictionary.eliteCount or 1
	
	NewPetriDish.crossoverRate = parameterDictionary.crossoverRate or 0.5
	
	NewPetriDish.Selector = parameterDictionary.Selector or Selectors.TournamentSelector.new()
	
	NewPetriDish.reuseElites = parameterDictionary.reuseElites or false

	return NewPetriDish

end

function PetriDish:cultivate(ChromosomeArray, scoreArray)
	
	local numberOfChromosomes = #ChromosomeArray
	
	local numberOfScores = #scoreArray
		
	if (numberOfChromosomes ~= numberOfScores) then error("You have " .. numberOfChromosomes .. " Chromosome(s), but you have " .. numberOfScores .. " score(s).") end
	
	local populationCount = self.populationCount
	
	local eliteCount = self.eliteCount
	
	local crossoverRate = self.crossoverRate
	
	local Selector = self.Selector
	
	local reuseElites = self.reuseElites

	local ChromosomeAndScoreDictionaryArray = {}
	
	for ChromosomeIndex, Chromosome in ipairs(ChromosomeArray) do
		
		local score = scoreArray[ChromosomeIndex]
		
		local ChromosomeAndScoreDictionary = {Chromosome = Chromosome, score = score}
		
		tableInsert(ChromosomeAndScoreDictionaryArray, ChromosomeAndScoreDictionary) 
		
	end

	tableSort(ChromosomeAndScoreDictionaryArray, function(a, b) return a.score > b.score end)

	local numberOfElites = mathMinimum(eliteCount, numberOfChromosomes)
	
	local NewChromosomeArray = {}
	
	for ChromosomeIndex = 1, numberOfElites, 1 do
		
		local ChromosomeAndScoreDictionary = ChromosomeAndScoreDictionaryArray[ChromosomeIndex]
		
		local Chromosome = ChromosomeAndScoreDictionary.Chromosome
		
		if (not reuseElites) then Chromosome = Chromosome:clone() end
		
		tableInsert(NewChromosomeArray, Chromosome)
		
	end
	
	local remainingPopulationCountToAdd = populationCount - numberOfElites
	
	repeat
		
		local ParentChromosomeA = Selector:select(ChromosomeAndScoreDictionaryArray)

		local ParentChromosomeB = Selector:select(ChromosomeAndScoreDictionaryArray)

		local ChildA, ChildB = ParentChromosomeA:crossover(ParentChromosomeB, crossoverRate)
		
		if (remainingPopulationCountToAdd >= 2) then
			
			ChildA:mutate(true)
			
			ChildB:mutate(true)
			
			tableInsert(NewChromosomeArray, ChildA)
			
			tableInsert(NewChromosomeArray, ChildB)
			
			remainingPopulationCountToAdd = remainingPopulationCountToAdd - 2
			
		else
			
			local randomNumber = mathRandom()
			
			local selectChildA = (randomNumber <= 0.5)
			
			local SelectedChild = (selectChildA and ChildA) or ChildB
			
			SelectedChild:mutate(true)
			
			tableInsert(NewChromosomeArray, SelectedChild)
			
			remainingPopulationCountToAdd = remainingPopulationCountToAdd - 1
			
		end
		
	until (remainingPopulationCountToAdd <= 0)

	return NewChromosomeArray
	
end

function PetriDish:destroy()

	table.clear(self)

	setmetatable(self, nil)

	self = nil

end

return PetriDish
