#include "lib/globals.hlsl"

#define MAX_WORLD_EXTENTS	(262144 * 2 * 1.732)


struct PixelInput
{
	float4 position : POSITION;
};


struct PixelOutput
{
	float4 distance : COLOR;
};


// use with "transform_only.hlsl" vertex shader

PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;

	fragment.distance.rgba = MAX_WORLD_EXTENTS;

	return fragment;
}
