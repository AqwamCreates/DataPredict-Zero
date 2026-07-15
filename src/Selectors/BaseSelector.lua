--[[

	--------------------------------------------------------------------

	Aqwam's Genetics Evolution Library (DataPredict Genetics)

	Author: Aqwam Harish Aiman
	
	Email: aqwam.harish.aiman@gmail.com
	
	YouTube: https://www.youtube.com/channel/UCUrwoxv5dufEmbGsxyEUPZw
	
	LinkedIn: https://www.linkedin.com/in/aqwam-harish-aiman/
	
	--------------------------------------------------------------------
		
	By using this library, you agree to comply with our Terms and Conditions in the link below:
	
	https://github.com/AqwamCreates/DataPredict-Geneticss/blob/main/docs/TermsAndConditions.md
	
	--------------------------------------------------------------------
	
	DO NOT REMOVE THIS TEXT!
	
	--------------------------------------------------------------------

--]]

local BaseSelector = {}

BaseSelector.__index = BaseSelector

function BaseSelector.new(parameterDictionary)

	parameterDictionary = parameterDictionary or {}

	local NewBaseSelector = {}

	setmetatable(NewBaseSelector, BaseSelector)

	NewBaseSelector.type = parameterDictionary.type or "Base"

	return NewBaseSelector

end

function BaseSelector:__tostring()

	return tostring("Type: " .. self.type)

end

function BaseSelector:destroy()

	table.clear(self)

	setmetatable(self, nil)

	self = nil

end

return BaseSelector
