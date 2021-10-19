;Terminal Train of Death
;-------------------------------------------------------------------------------

(script continuous train_of_death

	(object_destroy eastbound_train)
	(object_destroy eastbound_death)
	
	(object_destroy westbound_train)
	(object_destroy westbound_death)

	(sleep (random_range 60 360))
	
	(if (= 0 (random_range 0 2))
		
		(begin
		
			(object_create eastbound_train)
			(object_create eastbound_death)
			
		)
		
		(begin
		
			(object_create westbound_train)
			(object_create westbound_death)
		
		)

	)

	(sleep 240)
	
)
	