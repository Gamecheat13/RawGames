#include "lib/globals.hlsl"


struct VertexInput
{
	float4 position : POSITION;
};


struct PixelInput
{
	float4 position : POSITION;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel.position = Transform_ObjectToClip( vertex.position );

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;

	fragment.color = 0;

	return fragment;
}
