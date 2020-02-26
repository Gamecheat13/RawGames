-- object dest_shoulderBashWall

--## SERVER

hstructure dest_shoulderBashWall
	meta : table
	instance : luserdata
end


function dest_shoulderBashWall:init()
	print("Shoulder Bash Wall is awaiting a bashing -- should nav-passable after break");
	RegisterDeathEvent(shoulder_bash_wall_deathEvent, self)
end


function shoulder_bash_wall_deathEvent(objectThatDied:object, killerObject:object)
	print("Shoulder Bash has DIED!!");
	--ObjectOverrideNavMeshCutting(objectThatDied, false); 
end
