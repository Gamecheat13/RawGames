-- object storm_anti_infantry_turret

--## SERVER

function storm_anti_infantry_turret:init()
	print("Anti-Infantry turret startup.");
	initializeautomatedturret(self, false);
end
