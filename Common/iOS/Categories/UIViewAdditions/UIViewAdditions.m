/****************************************************************************

File:			UIViewAdditions.m

Date:			10/10/10

Version:		1.1

Authors:		soundcore

				Copyright 2009 soundcore
				All rights reserved worldwide.

Notes:			Implementation of UIViewAdditions

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

******************************************************************************/

#import "UIViewAdditions.h"

#import <cb.h>

@implementation UIView ( UIViewAdditions )

#pragma mark Angles & Distances

//////////////////////////////
// Round a UIView's corners.
//////////////////////////////

+ (void)roundView:(UIView*)view onCorner:(UIRectCorner)rectCorner radius:(float)radius
{
	UIBezierPath		*maskPath = [ UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake( radius, radius ) ];
	CAShapeLayer		*maskLayer = [ [ CAShapeLayer alloc ] init ];
	
	maskLayer.frame = view.bounds;
	maskLayer.path = maskPath.CGPath;
	
	[ view.layer setMask:maskLayer ];
	
	maskLayer = nil;
}

////////////////////////////////
// Calc angle between 2 points.
////////////////////////////////

- (double)angleBetweenThisPoint:(CGPoint)firstPoint andThisPoint:(CGPoint)secondPoint
{
	double xDif = firstPoint.x - secondPoint.x;
	
	double yDif = firstPoint.y - secondPoint.y;
	
	return atan2( xDif, yDif );
}

////////////////////////////////////
// Calc distance between 2 points.
////////////////////////////////////

- (double)distanceBetweenThisPoint:(CGPoint)firstPoint andThisPoint:(CGPoint)secondPoint
{
	double xDif = firstPoint.x - secondPoint.x;
	
	double yDif = firstPoint.y - secondPoint.y;
	
	double dist = ( ( xDif * xDif ) + ( yDif * yDif ) );
	
	return sqrt( dist );
}

#pragma mark Animations

//////////////////////////////////
// Start a default UI animation.
//////////////////////////////////

- (void)beginDefaultAnimation:(CFTimeInterval)speed
{
	[ UIView beginAnimations:nil context:nil ];
			
	[ UIView setAnimationDuration:speed ];
			
	[ UIView setAnimationCurve:UIViewAnimationCurveEaseInOut ];
}

///////////////////////////////////////////////////////////////////////////////////////
// Fade in the view passed in. View must already be visible or this method won't work.
///////////////////////////////////////////////////////////////////////////////////////

- (void)fadeInViewWithDuration:(CFTimeInterval)duration
{
	CABasicAnimation	*theAnimation = nil;
	NSNumber			*n1 = nil;
	NSNumber			*n2 = nil;
	
	// Make new animation...
	
	theAnimation = [ CABasicAnimation animationWithKeyPath:kOpacityAnimationNameKey ];
	if( theAnimation && self.layer )
	{
		theAnimation.duration = duration;
		
		theAnimation.repeatCount = 0;
		
		theAnimation.autoreverses = NO;
		
		theAnimation.removedOnCompletion = YES;
		
		n1 = [ [ NSNumber alloc ] initWithFloat:kTotallyTransparent ];
		theAnimation.fromValue = n1;
		
		n2 = [ [ NSNumber alloc ] initWithFloat:kTotallyOpaque ];
		theAnimation.toValue = n2;
		
		[ self.layer addAnimation:theAnimation forKey:kAnimateFadeInOpacityNameKey ];
	}
}

///////////////////////////////////////////////////////////////////////////////////////
// Pulse the view passed in. View must already be visible or this method won't work.
///////////////////////////////////////////////////////////////////////////////////////

- (void)pulseViewWithDuration:(CFTimeInterval)upDuration downDuration:(CFTimeInterval)downDuration
{
	CGAffineTransform transform = { (CGFloat)0.0, (CGFloat)0.0, (CGFloat)0.0, (CGFloat)0.0, (CGFloat)0.0, (CGFloat)0.0 };
	
	// Up...
	
	[ UIView beginAnimations:nil context:NULL ];
	[ UIView setAnimationDuration:upDuration ];
	
	transform = CGAffineTransformMakeScale( (CGFloat)1.2, (CGFloat)1.2 );
	self.transform = transform;
	
	[ UIView commitAnimations ];
	
	// Down...
	
	[ UIView beginAnimations:nil context:NULL ];
	[ UIView setAnimationDuration:downDuration ];
	
	transform = CGAffineTransformMakeScale( 1.0, 1.0 );
	self.transform = transform;
	
	[ UIView commitAnimations ];
}

#pragma mark Paths

- (BOOL)containsPoint:(CGPoint)point onPath:(UIBezierPath*)path inFillArea:(BOOL)inFill
{
	CGContextRef		context = nil;
	CGPathRef			cgPath = nil;
	CGPathDrawingMode	mode = kCGPathStroke;
	BOOL				isHit = NO;
	
	context = UIGraphicsGetCurrentContext();
	
	if( path && context )
	{
		cgPath = path.CGPath;
		
		// Determine the drawing mode to use. Default to detecting hits on the stroked portion of the path...
	
		if( inFill )
		{
			// Look for hits in the fill area of the path instead...
			
			if( path.usesEvenOddFillRule )
			{
				mode = kCGPathEOFill;
			}
			else
			{
				mode = kCGPathFill;
			}
			
			// Save the graphics state so that the path can be removed later.
			
			CGContextSaveGState( context );
			
			// Add the path...
			
			CGContextAddPath( context, cgPath );
			
			// Do the hit detection...
			
			isHit = CGContextPathContainsPoint( context, point, mode );
			
			// Restore old state...
			
			CGContextRestoreGState( context );
		}
	}
	
	return isHit;
}

#pragma mark View Controller

//////////////////////////////////////
// Return the view's view controller.
//////////////////////////////////////

- (UIViewController*)viewController
{
    UIViewController *foundVC = nil;
	
	id nextResponder = [ self nextResponder ];
	
    if( [ nextResponder isKindOfClass:[ UIViewController class ] ] )
	{
        foundVC = (UIViewController*)nextResponder;
    }
	
	return foundVC;
}

//////////////////////////////////////////////////////////////
// Return the very topmost view in the entire view hierarchy.
//////////////////////////////////////////////////////////////

- (UIView*)topMostSuperView
{
	UIWindow	*w = nil;
	UIView		*v = nil;
	
	// Get window...
	
	w =  [ UIAppDelegate window ];
	
	// Get topmost view...
	
	v = [ [ w subviews ] lastObject ];
	
	return v;
}

@end
