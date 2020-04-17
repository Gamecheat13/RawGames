




#include maps\_utility;




e2_main()
{
	
	
	
	

	
	level waittill( "in_car_2" );
	thread maps\MontenegroTrain_car3::e3_main();
}

load_car2_civilians()
{
	civies = maps\MontenegroTrain_util::spawn_group_ordinal( "car2_passenger" );
	for( i=0; i<civies.size; i++ )
	{
		civies[i] thread maps\MontenegroTrain_util::make_civilian( "car2_passenger"+(i+1) );

		
		
		
		
		civies[i].script_noteworthy = "early_cars";
		
	}
}	




