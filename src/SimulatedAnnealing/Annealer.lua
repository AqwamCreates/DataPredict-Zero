
local mathRandom = math.random

local mathHuge = math.huge

local mathExp = math.exp

local mathMax = math.max

local Annealer = {}

Annealer.__index = Annealer

local function defaultEvaluationFunction(Chromosome, environmentArray)

	return Chromosome:activate(environmentArray)

end

function Annealer.new(parameterDictionary)
	
	parameterDictionary = parameterDictionary or {}
	
	local Chromosome = parameterDictionary.Chromosome
	
	local evaluateFunction = parameterDictionary.evaluateFunction or defaultEvaluationFunction
	
	local initialTemperature = parameterDictionary.initialTemperature or 1000
	
	local coolingRate = parameterDictionary.coolingRate or 0.95
	
	local minimumTemperature = parameterDictionary.minimumTemperature or 0
	
	local NewAnnealer = {}

	setmetatable(NewAnnealer, Annealer)
	
	NewAnnealer.Chromosome = Chromosome
	
	NewAnnealer.evaluateFunction = evaluateFunction

	NewAnnealer.initialTemperature = initialTemperature
	
	NewAnnealer.coolingRate = coolingRate
	
	NewAnnealer.minimumTemperature = minimumTemperature
	
	NewAnnealer.currentTemperature = initialTemperature
	
	NewAnnealer.currentScore = nil
	
	NewAnnealer.BestChromosome = nil
	
	NewAnnealer.bestScore = -mathHuge

	return NewAnnealer
	
end

function Annealer:heat(environmentArray)
	
	local CurrentChromosome = self.Chromosome
	
	if (not CurrentChromosome) then error("No chromosome.") end
	
	local evaluateFunction = self.evaluateFunction
	
	local coolingRate = self.coolingRate
	
	local minimumTemperature = self.minimumTemperature
	
	local currentTemperature = self.currentTemperature
	
	local currentScore = self.currentScore
	
	local BestChromosome = self.BestChromosome
	
	local bestScore = self.bestScore
	
	if (not currentScore) then currentScore = evaluateFunction(CurrentChromosome, environmentArray) end
	
	local NeighborChromosome = CurrentChromosome:clone()
	
	NeighborChromosome:mutate(true)
	
	local neighborScore = evaluateFunction(NeighborChromosome, environmentArray)

	local energyDifference = neighborScore - currentScore

	local acceptNeighbourChromosome = false

	if (energyDifference > 0) then

		acceptNeighbourChromosome = true
		
	else

		if (currentTemperature > 0) then
			
			local probability = mathExp(energyDifference / currentTemperature)
			
			if (mathRandom() < probability) then acceptNeighbourChromosome = true end
			
		end
		
	end

	if (acceptNeighbourChromosome) then
		
		CurrentChromosome = NeighborChromosome
		
		currentScore = neighborScore

		if (currentScore > bestScore) then
			
			BestChromosome = NeighborChromosome:clone()
			
			bestScore = currentScore
			
		end
		
	end

	currentTemperature = currentTemperature * coolingRate
	
	local hasCooledDown = false

	if (currentTemperature <= minimumTemperature) then 
		
		currentTemperature = minimumTemperature
		
		hasCooledDown = true
		
	end
	
	self.currentTemperature = currentTemperature
	
	self.Chromosome = CurrentChromosome
	
	self.currentScore = currentScore
	
	self.BestChromosome = BestChromosome
	
	self.bestScore = bestScore

	return CurrentChromosome, BestChromosome, hasCooledDown
	
end

function Annealer:reset()
	
	self.currentTemperature = self.initialTemperature
	
	self.currentScore = nil
	
	self.BestChromosome = nil
	
	self.bestScore = -mathHuge
	
end

function Annealer:destroy()

	table.clear(self)

	setmetatable(self, nil)

	self = nil

end

return Annealer
