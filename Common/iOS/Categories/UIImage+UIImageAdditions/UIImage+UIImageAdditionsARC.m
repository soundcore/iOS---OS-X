/****************************************************************************

File:			UIImage+UIImageAdditions.h

Date:			2/26/11

Version:		1.0

Authors:		soundcore & Lane Roathe

				Copyright 2009 soundcore
				All rights reserved worldwide.

Notes:			Implementation of UIImageView+UIImageViewAdditions

				See comments in header.

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

Dependencies:	XCode 3.2.x+ iPhone SDK 3.0+

******************************************************************************/

#import "UIImage+UIImageAdditions.h"

#import <cb.h>

@implementation UIImage( UIImageAdditions )

///////////////////////////////////////////////////////////////////////
// Return a new UIImage with the new size. 'newImage' is autoreleased.
///////////////////////////////////////////////////////////////////////

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
	UIImage *newImage;
	
	UIGraphicsBeginImageContext( newSize );
	
	[ image drawInRect:CGRectMake( kFloatZero, kFloatZero, newSize.width, newSize.height ) ];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return newImage;
}

//////////////////////////////////////////////////
// Given a UIImage, return another UIImage with
// rounded corners with the radii specified.
//////////////////////////////////////////////////

+ (UIImage*)roundCornerImage:(UIImage*)img withCornerWidth:(int)cornerWidth andCornerHeight:(int)cornerHeight
{
	UIImage				*newImage = nil;
	//NSAutoreleasePool	*pool = [ [ NSAutoreleasePool alloc ] init ];
	CGColorSpaceRef		colorSpace = NULL;
	CGContextRef		context = NULL;
	CGRect				rect = CGRectZero;
	CGImageRef			imageMasked = NULL;
	int					w = 0;
	int					h = 0;
	
	if( img )
	{
		w = img.size.width;
		
		h = img.size.height;
		
		colorSpace = CGColorSpaceCreateDeviceRGB();
		if( colorSpace )
		{
			context = CGBitmapContextCreate( NULL, w, h, 8, ( 4 * w ), colorSpace, kCGImageAlphaPremultipliedFirst );
			
			CGContextBeginPath( context );
			
			rect = CGRectMake( kFloatZero, kFloatZero, img.size.width, img.size.height );
			
			// Round its corners...
			
			addRoundedRectToPath( context, rect, cornerWidth, cornerHeight );
			
			CGContextClosePath( context );
			
			CGContextClip( context );
			
			if( img.CGImage )
			{
				CGContextDrawImage( context, CGRectMake( kFloatZero, kFloatZero, w, h ), img.CGImage );
			}
			
			imageMasked = CGBitmapContextCreateImage( context );
			
			CGContextRelease( context );
			
			CGColorSpaceRelease( colorSpace );
			
			newImage = [ UIImage imageWithCGImage:imageMasked ];
			
			CGImageRelease( imageMasked );
			
			imageMasked = NULL;
		}
	}
	
//[ pool release ];
	
	return newImage;
}

/////////////////////////////////////////
// Return a UIImage with the new size.
/////////////////////////////////////////

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
	UIImage		*newImage = nil;
	UIImage		*sourceImage = self;
	CGSize		imageSize = sourceImage.size;
	CGFloat		width = imageSize.width;
	CGFloat		height = imageSize.height;
	CGFloat		targetWidth = targetSize.width;
	CGFloat		targetHeight = targetSize.height;
	CGFloat		scaleFactor = kFloatZero;
	CGFloat		scaledWidth = targetWidth;
	CGFloat		scaledHeight = targetHeight;
	CGPoint		thumbnailPoint = CGPointMake( kFloatZero, kFloatZero );
	CGRect		thumbnailRect = CGRectZero;
	
	if( !CGSizeEqualToSize( imageSize, targetSize ) ) 
	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if( widthFactor > heightFactor )
		{
			scaleFactor = widthFactor; // scale to fit height
        }
		else
		{
			scaleFactor = heightFactor; // scale to fit width
        }
		
		scaledWidth = ( width * scaleFactor );
        
		scaledHeight = ( height * scaleFactor );
		
        // Center the image
		
        if( widthFactor > heightFactor )
		{
			thumbnailPoint.y = ( ( targetHeight - scaledHeight ) * (CGFloat)0.5 ); 
		}
        else if ( widthFactor < heightFactor )
		{
			thumbnailPoint.x = ( ( targetWidth - scaledWidth ) * (CGFloat)0.5 );
		}
	}       
	
	UIGraphicsBeginImageContext( targetSize );		// this will crop
	
	thumbnailRect.origin = thumbnailPoint;
	
	thumbnailRect.size.width  = scaledWidth;
	
	thumbnailRect.size.height = scaledHeight;
	
	[ sourceImage drawInRect:thumbnailRect ];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// Pop the context to get back to the default...
	
	UIGraphicsEndImageContext();
	
	return newImage;
}

@end

////////////////////////////////////////////////////////////////////
// Given a CGContextRef, round its corners to the radii passed in.
////////////////////////////////////////////////////////////////////

void addRoundedRectToPath( CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight )
{
    float fw = kFloatZero;
	float fh = kFloatZero;
	
    if( !ovalWidth || !ovalHeight )
	{
        CGContextAddRect( context, rect );
        
		return;
    }
	
    CGContextSaveGState( context );
   
	CGContextTranslateCTM( context, CGRectGetMinX( rect ), CGRectGetMinY( rect ) );
   
	CGContextScaleCTM( context, ovalWidth, ovalHeight );
    
	fw = ( CGRectGetWidth( rect ) / ovalWidth );
    
	fh = ( CGRectGetHeight( rect ) / ovalHeight );
    
	CGContextMoveToPoint( context, fw, ( fh / 2 ) );
    
	CGContextAddArcToPoint( context, fw, fh, ( fw / 2 ), fh, 1 );
    
	CGContextAddArcToPoint( context, 0, fh, 0, ( fh / 2 ), 1);
    
	CGContextAddArcToPoint( context, 0, 0, ( fw / 2 ), 0, 1);
    
	CGContextAddArcToPoint( context, fw, 0, fw, ( fh / 2 ) , 1 );
    
	CGContextClosePath( context );
    
	CGContextRestoreGState( context );
}
