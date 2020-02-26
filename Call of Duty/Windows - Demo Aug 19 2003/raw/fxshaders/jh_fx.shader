gfx/effects/animated/jh_animfire
{
	sort	additive
    {
	AnimMap 14
        map gfx/effects/animated/jh_animfire1
	map gfx/effects/animated/jh_animfire2
	map gfx/effects/animated/jh_animfire3
	map gfx/effects/animated/jh_animfire4
	map gfx/effects/animated/jh_animfire5
	map gfx/effects/animated/jh_animfire6
	map gfx/effects/animated/jh_animfire7
        blendFunc add
        rgbGen vertex
	tcmod scale -1 1
	//tcmod transform 1 0 0 -1 0 1 
    }
}

gfx/effects/animated/jh_animfire2
{
	sort	additive 
    {
	AnimMap 14
        map clamp gfx/effects/animated/jh_animfire1
	map clamp gfx/effects/animated/jh_animfire2
	map clamp gfx/effects/animated/jh_animfire3
	map clamp gfx/effects/animated/jh_animfire4
	map clamp gfx/effects/animated/jh_animfire5
	map clamp gfx/effects/animated/jh_animfire6
	map clamp gfx/effects/animated/jh_animfire7
        blendFunc add
        rgbGen vertex
    }
}

gfx/effects/animated/firespark
{
 
	entityMergable
    {
	map gfx/effects/animated/jh_firespark
	//rgbgen const ( 1 .47 .39 )
	rgbgen vertex

    }
}