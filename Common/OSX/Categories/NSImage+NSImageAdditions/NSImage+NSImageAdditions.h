/****************************************************************************

File:			NSImage+NSImageAdditions.h

Date:			12/21/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Header for NSArray+NSArrayAdditions.m

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

Changes:		

12/21/10		MCA Initial version.

******************************************************************************/

// Classes

@interface NSImage ( NSImageAdditions )

// Utils

- (CGImageRef)cgImage;

- (CGImageRef)cgImage2;

- (NSBitmapImageRep*)bitmap;

- (NSImage*)compositeImage:(NSImage*)overlayImage ontoImage:(NSImage*)destImage;

@end

// C Protos

// CGImageRef CGImageCreateWithNSImage( NSImage *image );

void BitmapReleaseCallback( void* info, const void* data, size_t size );