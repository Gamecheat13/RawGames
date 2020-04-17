(script startup cex_damnation
	;destroy the original gruntbarrel in the scene
	(object_destroy gruntbarrel)

	(sleep_until
		(begin
			;wait a random period of time between 0 and 10 mins
			(sleep (random_range 750 18000))
			
			;create the gruntbarrel
			(object_create gruntbarrel)

			;wait for the anim to play through
			(sleep 200)
			
			;destroy the gruntbarrel
			(object_destroy gruntbarrel)

		FALSE)
	)
	
)		
