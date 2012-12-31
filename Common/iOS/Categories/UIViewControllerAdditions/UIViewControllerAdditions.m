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

// Twitter Integration

#if defined(__OBJC__) && defined(__IPHONE_5_0)
#import <Twitter/Twitter.h>
#endif

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

- (CATransition*)makeCannedCATransitionWithDuration:(NSUInteger)duration
					timingFucntionName:(NSString*)tfName
					type:(NSString*)tranType
					subtype:(NSString*)tranSubType
					removeOnCompletion:(BOOL)removeIt
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

#pragma mark- - Twitter
#pragma mark-

/////////////////////////////////////////////////////////////////////
// Throw up a Tweet Sheet using the localized string key passed in.
// If initalTextKey == nil, don't set any initial text.
// If url == nil, don't set any URL.
// Return whether we were able to tweet or not.
/////////////////////////////////////////////////////////////////////

- (TweetResult)tweetMeSilly:(NSString*)initalTextKey andOptionalURL:(NSURL*)url
{
	TWTweetComposeViewController	*tweetSheetViewController = nil;
	TweetResult						result = { NO, NO };
	BOOL							textSet = NO;
	BOOL							urlSet = NO;
	
	// Make sure Twitter is reachable...
	
	result.canTweet = [ TWTweetComposeViewController canSendTweet ];
	if( result.canTweet )
	{
		// Make a Tweet Sheet...
		
		tweetSheetViewController = [ [ TWTweetComposeViewController alloc ] init ];
		if( tweetSheetViewController )
		{
			// Set sheet's initial text...
			
			if( initalTextKey )
			{
				textSet = [ tweetSheetViewController setInitialText:NSLocalizedString( initalTextKey, kEmptyStringKey ) ];
			}
			
			// Set sheet's URL if any...
			
			if( url )
			{
				urlSet = [ tweetSheetViewController addURL:url ];
			}
			
			result.didTweet = YES;
			
			// Show it!
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			// Note the UIViewController has a completion that gets called when the view actually appears.
			// This is different than the TWTweetComposeViewController's completion handler which is a
			// property and must be set explicitly. For now, for the UIViewController's completion, just do nothing.
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			[ self presentViewController:tweetSheetViewController animated:YES completion:kVoidBlockCompletion ];
		}
	}
	
	return result;
}

#pragma mark- - Utils
#pragma mark-

////////////////////////////////////////////////////////////////////////////
// See if the runtime version of iOS is at least that passed in or later.
////////////////////////////////////////////////////////////////////////////

- (BOOL)osVersionIsAtLeast:(NSString*)desiredVersionString
{
	NSString	*currentSystemversion = [ [ kCurrentDevice systemVersion ] copy ];
	BOOL		is = NO;
	
	if( desiredVersionString )
	{
		if( [ currentSystemversion compare:desiredVersionString options:NSNumericSearch ] != NSOrderedAscending )
		{
			is = YES;
		}
	}
	
	return is;
}

@end
