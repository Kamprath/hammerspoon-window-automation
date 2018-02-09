--- Provides ternary conditional functionality.
-- @module Ternary

--- Determine a value based on a condition.
-- @param condition An expression that evaluates to true or false.
-- @param expr1     Expression to execute if the condition evaluates to true.
-- @param expr2     Expression to execute if the condition evaluates to false.
return function(condition, expr1, expr2)
	if condition then
		return expr1
	else
		return expr2
	end
end