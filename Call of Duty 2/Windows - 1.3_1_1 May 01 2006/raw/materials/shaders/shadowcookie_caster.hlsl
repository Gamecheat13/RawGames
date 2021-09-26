#include "lib/globals.hlsl"
#include "lib/transform.hlsl"

struct VertexInput
{
	float4 position : POSITION;
};


struct PixelInput
{
	float4 position : POSITION;	
	float shadowCoord : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.shadowCoord = mul( vertex.position, shadowLookupMatrix ).z;

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;
	fragment.color = float4( pixel.shadowCoord, pixel.shadowCoord, pixel.shadowCoord, 1 );
	return fragment;
}
