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

local BaseSelector = require(script.Parent.BaseSelector)

local mathRandom = math.random

local TournamentSelector = {}

TournamentSelector.__index = TournamentSelector

TournamentSelector.__index = TournamentSelector

function TournamentSelector.new(parameterDictionary)
	
	parameterDictionary = parameterDictionary or {}
	
	local tournamentSize = parameterDictionary.tournamentSize or 2
	
	parameterDictionary.type = "Tournament"
	
	local NewTournamentSelector = BaseSelector.new(parameterDictionary)
	
	NewTournamentSelector.tournamentSize = tournamentSize
	
	return NewTournamentSelector
	
end

function TournamentSelector:select(ChromosomeAndScoreDictionaryArray)
	
	local tournamentSize = self.tournamentSize
	
	local numberOfChromosomes = #ChromosomeAndScoreDictionaryArray
	
	local BestChromosome = nil
	
	local bestChromosomeScore = -math.huge

	for i = 1, tournamentSize, 1 do
		
		local chromosomeIndex = mathRandom(1, numberOfChromosomes)

		local ChromosomeAndScoreDictionary = ChromosomeAndScoreDictionaryArray[chromosomeIndex]
		
		local Chromosome = ChromosomeAndScoreDictionary.Chromosome
		
		local chromosomeScore = ChromosomeAndScoreDictionary.score
		
		if (chromosomeScore > bestChromosomeScore) then
			
			BestChromosome = Chromosome
			
			bestChromosomeScore = chromosomeScore
			
		end
		
	end
	
	return BestChromosome
	
end

return TournamentSelector
