//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
//
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced f_init()
	//sleep_until(ai_strength (sq) <= 0);
	//print ("term narrative drop");
	
	repeat
		sleep_until( LevelEventStatus( "change drop state" ), 1);
			
		print ("changed");
		//inspect (toggle_drops);
		
//		if (toggle_drops == FALSE) then
//			object_hide (this, 1);
//		//	print ("Hiding Terminal Drops");
//		else
//			object_hide (this, 0);
//		//	print ("Showing Terminal Drops");
//		end
	until (1 == 0,1);

end