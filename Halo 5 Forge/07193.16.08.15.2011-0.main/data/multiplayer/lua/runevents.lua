--
-- Activate events
--

local engine = GetEngine();

local variant = nil;

engine:VisitVariant(
	function (currentVariant)
		variant = currentVariant
	end
	);

DefinitionRuntime:Deserialize(variant);	

DefinitionRuntime:Start(engine);