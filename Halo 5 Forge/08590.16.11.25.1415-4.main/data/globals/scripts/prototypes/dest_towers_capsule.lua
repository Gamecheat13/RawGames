-- object dest_towers_capsule

--## SERVER


function dest_towers_capsule:init()
	
 	local obj:object = self;
	objects_physically_attach(OBJECTS.capsule1, "capsule", OBJECTS.reactor1, "")
	objects_physically_attach(OBJECTS.capsule2, "capsule", OBJECTS.reactor2, "")
			
end

