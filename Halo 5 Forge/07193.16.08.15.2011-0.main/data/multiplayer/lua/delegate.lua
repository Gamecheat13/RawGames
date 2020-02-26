--
-- Delegate implementation
--

Delegate = { };

function Delegate:new(...)
	local obj = { };
	setmetatable(obj, { __index = self, __call = Delegate.Call });
	return obj;
end

function Delegate:Call(...)

	if self.Targets ~= nil then
		
		for func, value in pairs(self.Targets) do
			func(...);
		end

	end

end

function Delegate:Subscribe(func)

	if self.Targets == nil then
		self.Targets = { };
	end

	self.Targets[func] = func;

end

function Delegate:Unsubscribe(func)

	if self.Targets ~= nil then
		self.Targets[func] = nil;
	end

end