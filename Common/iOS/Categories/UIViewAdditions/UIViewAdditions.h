/******************************************************************************

File:			UIViewAdditions.h

Date:			10/20/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Header for UIViewAdditions.m

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore.

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE
				FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	XCode 3.2
				iPhone SDK 4.0+
Changes:		

10/20/10		MCA - Initial version.

******************************************************************************/

#import <UIKit/UIKit.h>

@interface UIView ( UIViewAdditions )

// Angles & Distances

+ (void)roundView:(UIView*)view onCorner:(UIRectCorner)rectCorner radius:(float)radius;

- (double)distanceBetweenThisPoint:(CGPoint)firstPoint andThisPoint:(CGPoint)secondPoint;

- (double)angleBetweenThisPoint:(CGPoint)firstPoint andThisPoint:(CGPoint)secondPoint;

// Animations

- (void)beginDefaultAnimation:(CFTimeInterval)speed;

- (void)fadeInViewWithDuration:(CFTimeInterval)duration;

- (void)pulseViewWithDuration:(CFTimeInterval)upDuration downDuration:(CFTimeInterval)downDuration;

// Paths

- (BOOL)containsPoint:(CGPoint)point onPath:(UIBezierPath*)path inFillArea:(BOOL)inFill;

// View Controller

- (UIViewController*)viewController;

- (UIView*)topMostSuperView;

@end
