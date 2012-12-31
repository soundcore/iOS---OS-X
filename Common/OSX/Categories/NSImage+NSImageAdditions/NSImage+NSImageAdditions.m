/****************************************************************************

File:			NSImage+NSImageAdditions.h

Date:			12/21/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Implementation for NSImage+NSImageAdditions.h

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore.

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE FULL EXTENT OF
				INTERNATIONAL LAW.

Dependencies:	See header.

Changes:		See header.

12/21/10		MCA Initial version.

******************************************************************************/

#import <cb.h>

#import <NSImage+NSImageAdditions.h>

@implementation NSImage ( NSImageAdditions )

////////////////////////////////////////
// Return a CGImageRef rep of NSImage.
// Caller must release returned image.
////////////////////////////////////////

- (CGImageRef)cgImage
{
	NSData				*cocoaData = nil;
	CFDataRef			carbonData = NULL;
	CGImageSourceRef	imageSourceRef = NULL;
	CGImageRef			imageDestRef = NULL;
	
	if( [ self representations ] && [ [ self representations ] count ] )
	{
		cocoaData = [ NSBitmapImageRep TIFFRepresentationOfImageRepsInArray:[ self representations ] ];
		if( cocoaData )
		{
			carbonData = (CFDataRef)cocoaData;
			if( carbonData )
			{
				// Instead of NULL, you can fill a CFDictionary full of options but the default values work for me...
			
				imageSourceRef = CGImageSourceCreateWithData( carbonData, NULL );
				if( imageSourceRef )
				{
					// Create new image. Caller must release...
					
					imageDestRef = CGImageSourceCreateImageAtIndex( imageSourceRef, 0, NULL );
			
					// Clean up...
					
					CFRelease( imageSourceRef );
				}
			}
		}
	}
	
	return imageDestRef;
}

////////////////////////////////////////
// Return a CGImageRef rep of NSImage.
// Caller must release returned image.
////////////////////////////////////////

- (CGImageRef)cgImage2
{
	NSBitmapImageRep*	bm = [ [ self bitmap ] retain ];	// Data provider will release this
	NSInteger			rowBytes, width, height;
	
	rowBytes = [ bm bytesPerRow ];
	
	width = [ bm pixelsWide ];
	
	height = [ bm pixelsHigh ];
	
	CGDataProviderRef provider = CGDataProviderCreateWithData( bm, [bm bitmapData], (size_t)( rowBytes * height ), (CGDataProviderReleaseDataCallback)BitmapReleaseCallback );
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName( kCGColorSpaceGenericRGB );
	CGBitmapInfo	bitsInfo = kCGImageAlphaLast;
	
	CGImageRef img = CGImageCreate( (size_t)width, (size_t)height, 8, 32, (size_t)rowBytes, colorspace, bitsInfo, provider, NULL, NO, kCGRenderingIntentDefault );
	
	CGDataProviderRelease( provider );
	CGColorSpaceRelease( colorspace );
	
	return img;
}

- (NSBitmapImageRep*)bitmap
{
	// returns a 32-bit bitmap rep of the receiver, whatever its original format. The image rep is not added to the image.
	
	NSSize size = [self size];
	
	int rowBytes = ((int)(ceil(size.width)) * 4 + 0x0000000F) & ~0x0000000F; // 16-byte aligned
	
	NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil 
																		 pixelsWide:(NSInteger)size.width 
																		 pixelsHigh:(NSInteger)size.height 
																	  bitsPerSample:8 
																	samplesPerPixel:4 
																		   hasAlpha:YES 
																		   isPlanar:NO 
																	 colorSpaceName:NSCalibratedRGBColorSpace 
																	   bitmapFormat:NSAlphaNonpremultipliedBitmapFormat 
																		bytesPerRow:rowBytes 
																	   bitsPerPixel:32];
	
	if ( imageRep == NULL )
		return NULL;
	
	NSGraphicsContext* imageContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:imageRep];
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:imageContext];
	
	[ self drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0 ];
	
	[ NSGraphicsContext restoreGraphicsState ];
	
	return [imageRep autorelease];
}

/////////////////////////////
// Release for bitmap above.
/////////////////////////////

void BitmapReleaseCallback( void* info, const void* data, size_t size )
{
	#pragma unused( data )
	#pragma unused( size )
	
	NSBitmapImageRep *bm = (NSBitmapImageRep*)info;
	
	[ bm release ];
}

//////////////////////////////////////////////////////////////////////////
// Composite overlayImage onto destImage and return a new combined image
// containing the composited image. Caller must release returned image.
//////////////////////////////////////////////////////////////////////////

- (NSImage*)compositeImage:(NSImage*)overlayImage ontoImage:(NSImage*)destImage
{
	NSImage	*newImage = nil;
	NSRect	compositingRect = kJustInitCGRectWithZeros;
	
	if( overlayImage && destImage )
	{
		compositingRect.origin = NSMakePoint( 0, 0 );
											
		compositingRect.size = [ destImage size ];
		
		newImage = [ [ NSImage alloc ] initWithSize:[ destImage size ] ];
		if( newImage )
		{
			[ newImage lockFocus ];
		
			[ destImage drawAtPoint:NSMakePoint( 0, 0 ) fromRect:compositingRect operation:NSCompositeSourceOver fraction:kTotallyOpaque ];
			
			[ overlayImage drawAtPoint:NSMakePoint( 0, 0 ) fromRect:compositingRect operation:NSCompositeSourceOver fraction:kTotallyOpaque ];
			
			[ newImage unlockFocus ];
		}
	}
	
	return newImage;
}

@end

/*
 
 CGImageRef CGImageCreateWithNSImage( NSImage *image )
{
    NSSize			imageSize = kJustInitCGPointWithZeros;
	CGContextRef	bitmapContext = nil;
	CGImageRef		cgImage = NULL;

    if( image )
	{
		imageSize = [ image size ];
		
		bitmapContext = CGBitmapContextCreate( NULL, (size_t)imageSize.width, (size_t)imageSize.height, 8, 0, [ [ NSColorSpace genericRGBColorSpace ] CGColorSpace ], ( kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst ) );
		if( bitmapContext )
		{
			[ NSGraphicsContext saveGraphicsState ];
			
			[ NSGraphicsContext setCurrentContext:[ NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO ] ];
			
			[ image drawInRect:NSMakeRect( 0, 0, imageSize.width, imageSize.height ) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0 ];
			
			[ NSGraphicsContext restoreGraphicsState ];

			cgImage = CGBitmapContextCreateImage( bitmapContext );
			
			CGContextRelease( bitmapContext );
		}
	}
	
    return cgImage;
}
 
 */
