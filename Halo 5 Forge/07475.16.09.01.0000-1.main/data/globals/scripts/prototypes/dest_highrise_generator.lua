-- object dest_highrise_generator

--## SERVER

function dest_highrise_generator:init()
--	print("Generator is Active!");

	while(true) do

		object_create_anew( "cannistera" );


		objects_physically_attach(self, "explosive1", OBJECTS.cannistera, "")


		SleepUntil( [|object_get_health(OBJECTS.cannistera) < 0.5], 1 );

--		print("Generator cannisters destroyed!  Generator hiding!");

		device_set_position( self,1 );
		device_set_position( OBJECTS.cover1,1 );
		device_set_position( OBJECTS.cover2,1 );


		Sleep(900);

--		print("Resetting generator");



		device_set_position( self,0 );
		device_set_position( OBJECTS.cover1,0 );
		device_set_position( OBJECTS.cover2,0 );

	end


end