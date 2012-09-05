/******************************************************************************

File:			WOWButton.h

Date:			9/26/09

Version:		1.0

Authors:		soundcore

				Copyright 2009-2012 soundcore
				All rights reserved worldwide.

Notes:			Header for WOWButton.m

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

Dependencies:	XCode 3.1.3 or later
				iPhone SDK 3.0 or later
				cb.h
Changes:		

9/26/09			soundcore Initial version.

******************************************************************************/

#ifdef TARGET_OS_IPHONE
	#import <UIKit/UIKit.h>
#else
	#import <Cocoa/Cocoa.h>
#endif

// Defines

#define kNumImagesInButtonArray					10
#define kWOWButtonFilenameSuffixString			@"wow"
#define kWOWButtonAnimationDurationInSeconds	0.45

// Classes

@interface WOWButton : UIButton
{
	double										animationDuration;							// In seconds. Can be a fraction.
	NSMutableArray								*animatedButtonImagesArray;					// An array of UIImages to animate the button.
}

@property (readwrite)							double				animationDuration;
@property (nonatomic, readwrite, retain)		NSMutableArray		*animatedButtonImagesArray;

// Init & term

+ (id)buttonWithType:(UIButtonType)buttonType;

- (id)initWithFrame:(CGRect)frameRect;

- (void)dealloc;

// Animation

- (void)startAnimating;

- (void)stopAnimating;

@end