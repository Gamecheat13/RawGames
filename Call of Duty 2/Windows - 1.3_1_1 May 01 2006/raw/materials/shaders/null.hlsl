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



PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel.position = vertex.position;

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;

	fragment.color = 0;

	return fragment;
}
