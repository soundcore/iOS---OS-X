/****************************************************************************

File:			UIViewControllerAdditions.m

Date:			9/13/10

Version:		1.1

Authors:		soundcore & Lane Roathe

				Copyright 2009 soundcore
				All rights reserved worldwide.

Notes:			Implementation of UIViewControllerAdditions

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

#import "UIViewControllerAdditions.h"

@implementation UIViewController ( UIViewControllerAdditions )

///////////////////////////////////////////////////////////////////////////
// Return whether a UIViewController is valid and has a valid view loaded.
///////////////////////////////////////////////////////////////////////////

- (BOOL)viewControllerIsValidAndHasView
{
	BOOL hasBoth = NO;
	
	if( self.view )
	{
		hasBoth = YES;
	}

	return hasBoth;
}

#pragma mark-
#pragma mark Core Animation
#pragma mark-

////////////////////////////////////////////////////////////////////////////////////
// Make a default CATransition with the values passed in. Returned CATransition is
// autoreleased. The returned CATransition always has its delegate set to self.
////////////////////////////////////////////////////////////////////////////////////

- (CATransition*)makeCannedCATransitionWithDuration:(NSUInteger)duration timingFucntionName:(NSString*)tfName type:(NSString*)tranType subtype:(NSString*)tranSubType removeOnCompletion:(BOOL)removeIt
{	
	CATransition *trans = [ CATransition animation ];
	if( trans && tfName )
	{
		trans.duration = duration;
		
		trans.timingFunction = [ CAMediaTimingFunction functionWithName:tfName ];
		
		trans.type = tranType;
		
		trans.subtype = tranSubType;
		
		trans.removedOnCompletion = removeIt;
		
		trans.delegate = self;
	}
	
	return trans;
}

@end
