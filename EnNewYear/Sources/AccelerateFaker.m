
#import <Accelerate/Accelerate.h>

EXPHOOK(void, vDSP_dotpr,
		 const float *__vDSP_A,
		 vDSP_Stride  __vDSP_IA,
		 const float *__vDSP_B,
		 vDSP_Stride  __vDSP_IB,
		 float       *__vDSP_C,
		 vDSP_Length  __vDSP_N)
{
	_LogLine();
	return _vDSP_dotpr(__vDSP_A,
					   __vDSP_IA,
					   __vDSP_B,
					   __vDSP_IB,
					   __vDSP_C,
					   __vDSP_N);
} ENDHOOK

EXPHOOK(vImage_Error, vImageBoxConvolve_ARGB8888, const vImage_Buffer *src, const vImage_Buffer *dest, void *tempBuffer, vImagePixelCount srcOffsetToROI_X, vImagePixelCount srcOffsetToROI_Y, uint32_t kernel_height, uint32_t kernel_width, Pixel_8888 backgroundColor, vImage_Flags flags )
{
	_LogLine();
	return _vImageBoxConvolve_ARGB8888(src, dest, tempBuffer, srcOffsetToROI_X, srcOffsetToROI_Y, kernel_height, kernel_width, backgroundColor, flags );
} ENDHOOK


EXPHOOK(vImage_Error, vImageConvolve_Planar8, const vImage_Buffer *src, const vImage_Buffer *dest, void *tempBuffer, vImagePixelCount srcOffsetToROI_X, vImagePixelCount srcOffsetToROI_Y,  const int16_t *kernel, uint32_t kernel_height, uint32_t kernel_width, int32_t divisor, Pixel_8 backgroundColor, vImage_Flags flags )
{
	_LogLine();
	return _vImageConvolve_Planar8(src, dest, tempBuffer, srcOffsetToROI_X, srcOffsetToROI_Y,  kernel, kernel_height, kernel_width, divisor, backgroundColor, flags );
} ENDHOOK

EXPHOOK(vImage_Error, vImageMatrixMultiply_ARGB8888, const vImage_Buffer *src,
		 const vImage_Buffer *dest,
		 const int16_t	matrix[4*4],
		 int32_t             divisor,
		 const int16_t	*pre_bias,	//Must be an array of 4 int16_t's. NULL is okay.
		 const int32_t 	*post_bias,	//Must be an array of 4 int32_t's. NULL is okay.
		 vImage_Flags 	flags )
{
	_LogLine();
	return _vImageMatrixMultiply_ARGB8888(src,
										  dest,
										  matrix,
										  divisor,
										  pre_bias,	//Must be an array of 4 int16_t's. NULL is okay.
										  post_bias,	//Must be an array of 4 int32_t's. NULL is okay.
										  flags );

} ENDHOOK

EXPHOOK(vImage_Error, vImageRotate90_Planar8, const vImage_Buffer *src, const vImage_Buffer *dest, uint8_t rotationConstant, Pixel_8 backColor, vImage_Flags flags )
{
	_LogLine();
	return _vImageRotate90_Planar8(src, dest, rotationConstant, backColor, flags );
} ENDHOOK

EXPHOOK(vImage_Error, vImageScale_Planar8, const vImage_Buffer *src, const vImage_Buffer *dest, void *tempBuffer, vImage_Flags flags )
{
	_LogLine();
	return _vImageScale_Planar8(src, dest, tempBuffer, flags );
} ENDHOOK

//
void AccelerateFaker()
{
	_LogLine();
	_PTRFUN(/System/Library/Frameworks/Accelerate.framework/Accelerate, vDSP_dotpr);
	_PTRFUN(/System/Library/Frameworks/Accelerate.framework/Accelerate, vImageBoxConvolve_ARGB8888);
	_PTRFUN(/System/Library/Frameworks/Accelerate.framework/Accelerate, vImageConvolve_Planar8);
	_PTRFUN(/System/Library/Frameworks/Accelerate.framework/Accelerate, vImageMatrixMultiply_ARGB8888);
	_PTRFUN(/System/Library/Frameworks/Accelerate.framework/Accelerate, vImageRotate90_Planar8);
	_PTRFUN(/System/Library/Frameworks/Accelerate.framework/Accelerate, vImageScale_Planar8);
	_LogLine();
}

