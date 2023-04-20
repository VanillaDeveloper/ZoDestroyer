local ProbabilityCalculator = {}
ProbabilityCalculator.__index = ProbabilityCalculator

function ProbabilityCalculator.calculate(chances)
		local total = 0
		for _, chance in pairs(chances) do
			total += chance
		end

		local randomValue = math.random(1, total)
		local currentTotal = 0
		for name, chance in pairs(chances) do
			currentTotal += chance
			if randomValue <= currentTotal then
				return name
			end
		end

		return nil
end

return ProbabilityCalculator
