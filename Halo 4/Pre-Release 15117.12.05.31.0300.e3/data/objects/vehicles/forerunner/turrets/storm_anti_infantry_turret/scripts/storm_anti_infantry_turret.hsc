
global vehicle selfCopy = none;

script startup instanced storm_anti_infantry_turret()
	print("Anti-Infantry turret startup.");
	selfCopy = this;
	InitializeAutomatedTurret(selfCopy, false);
end
