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

local BaseGene = {}

BaseGene.__index = BaseGene

function BaseGene.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}
	
	local NewBaseGene = {}

	setmetatable(NewBaseGene, BaseGene)

	NewBaseGene.value = parameterDictionary.value or 0
	
	NewBaseGene.type = parameterDictionary.type or "Base"

	NewBaseGene.mutationChance = parameterDictionary.mutationChance or 0

	return NewBaseGene

end

function BaseGene:__tostring()
	
	return tostring("Type: " .. self.type .. " Value: " .. self.value)
	
end

function BaseGene:destroy()
	
	table.clear(self)
	
	setmetatable(self, nil)
	
	self = nil
	
end

return BaseGene
