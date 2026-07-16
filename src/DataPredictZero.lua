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

local AqwamDerivativeFreeOptimizationLibrary = {}

local Core = script.Core

local Genes = Core.Genes

local Genetic = script.Genetic

local Selectors = Genetic.Selectors

local SimulatedAnnealing = script.SimulatedAnnealing

AqwamDerivativeFreeOptimizationLibrary.Core = {
	
	Genes = {

		ContinuousGene = require(Genes.ContinuousGene),

		IntegerGene = require(Genes.IntegerGene),

		DiscreteGene = require(Genes.DiscreteGene),

	},
	
	Chromosome = require(Core.Chromosome),
	
}

AqwamDerivativeFreeOptimizationLibrary.Genetic = {
	
	Selectors = {
		
		RandomSelector = require(Selectors.RandomSelector),
		
		TournamentSelector = require(Selectors.TournamentSelector),
		
		RankSelector = require(Selectors.RankSelector),
		
		RouletteWheelSelector = require(Selectors.RouletteWheelSelector),
		
	},
	
	PetriDish = require(Genetic.PetriDish),

}

AqwamDerivativeFreeOptimizationLibrary.SimulatedAnnealing = {
	
	Annealer = require(SimulatedAnnealing.Annealer),
	
}

return AqwamDerivativeFreeOptimizationLibrary
