#include "lib/globals.hlsl"

#define USE_DETAIL		0

struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/shade.hlsl"


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;

	fragment.color.rgb = ColoredTexturedDiffuse( pixel.color, pixel.texCoords );
	fragment.color.a = pixel.color.a;

	return fragment;
}
