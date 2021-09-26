#include "globals.hlsl"


struct VertexInput
{
	float4 position : POSITION;
};


struct PixelInput
{
	float4 position : POSITION;
	float distance : TEXCOORD0;
};


struct PixelOutput
{
	float4 distance : COLOR;
};


#include "transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.distance = pixel.position.z;

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;

	fragment.distance.rgba = pixel.distance;

	return fragment;
}
