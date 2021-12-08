-- Copyright (c) Microsoft. All rights reserved.
--   ____                          __                            ____            ___                            __             
--  /\  _`\                       /\ \__  __                    /\  _`\         /\_ \                          /\ \__          
--  \ \ \ _  __  __    ___     ___\ \ ,_\/\_\    ___     ___    \ \ \/\ \     __\//\ \      __     __      __  \ \ ,_\    __   
--   \ \  _\/\ \/\ \ /' _ `\  /'___\ \ \/\/\ \  / __`\ /' _ `\   \ \ \ \ \  /'__`\\ \ \   /'__`\ /'_ `\  /'__`\ \ \ \/  /'__`\ 
--    \ \ \/\ \ \_\ \/\ \/\ \/\ \__/\ \ \_\ \ \/\ \L\ \/\ \/\ \   \ \ \_\ \/\  __/ \_\ \_/\  __//\ \L\ \/\ \L\.\_\ \ \_/\  __/ 
--     \ \_\ \ \____/\ \_\ \_\ \____\\ \__\\ \_\ \____/\ \_\ \_\   \ \____/\ \____\/\____\ \____\ \____ \ \__/.\_\\ \__\ \____\
--      \/_/  \/___/  \/_/\/_/\/____/ \/__/ \/_/\/___/  \/_/\/_/    \/___/  \/____/\/____/\/____/\/___L\ \/__/\/_/ \/__/\/____/
--                                                                                                 /\____/                     
--                                                                                                 \_/__/                      
--## SERVER

global FunctionDelegate = table.makePermanent
{
	callback = nil,
	callee = nil,
	params = {},
};

function FunctionDelegate:New(callback:ifunction, callee, params:table):table
	local newFunctionDelegate = table.addMetatableRecursive(self);
	newFunctionDelegate.callback = callback;
	newFunctionDelegate.callee = callee;
	newFunctionDelegate.params = params;
	return newFunctionDelegate;
end

-- ------------------
-- Delegate Interface
-- ------------------
function FunctionDelegate:Invoke(...)
	if self.callee ~= nil then
		return self.callback(self.callee, self.params, unpack(arg));
	end

	return self.callback(self.params, unpack(arg));
end
