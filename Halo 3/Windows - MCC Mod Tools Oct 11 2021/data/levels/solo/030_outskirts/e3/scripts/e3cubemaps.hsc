
(script startup setup
	(fade_in 0 0 0 0)
	(cinematic_lighting_initialize)
	(cinematic_light_object ark ark 0 0)
	(cinematic_light_object storm storm 0 .5)
	(object_create fleet)
	(object_create_anew rocks)
	
	(object_create_anew hero_cruiser)
	(object_create_anew fleet)
	
	(scenery_animation_start_relative hero_cruiser objects\vehicles\capital_ship\capital_ship "flyover" anchor)
)