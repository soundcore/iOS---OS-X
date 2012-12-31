/***********************************************************************************

File:			cbUtilsAlert.m

Date:			11/1/08

Version:		1.0

Authors:		soundcore

				Copyright 2009 Code Beauty, LLC.
				All rights reserved worldwide.

Notes:			Common alert utils for Cocoa.
				
				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF CODE BEAUTY, LLC

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE
				FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	XCode 2.5 as of this writing.

Changes:		

11/1/08			MCA		Initial version.

***********************************************************************************/

#import "cbUtilsAlert.h"

/////////////////////////////////////////////////////////////////
// Notify the user with an alert. Pass a bundle, & the localized
// keys for a message or error and a suggestion. The strings are
// pulled from inBundle. Pass nil for the buttons you don't want
// to have show up.
/////////////////////////////////////////////////////////////////

int NotifyUserWithMessageAndSuggestionFromBundle(	NSBundle		*inBundle,
													CFStringRef		messageKey,
													CFStringRef		suggestionKey,
													CFStringRef		defaultButton,
													CFStringRef		alternateButton,
													CFStringRef		otherButton )
{
	int			result = 0;
	NSString	*message = nil;
	NSString	*suggestion = nil;
	NSAlert		*alert = nil;
	
	if( inBundle && messageKey )
	{
		// Get message
		
		message = [ inBundle localizedStringForKey:(NSString*)messageKey value:nil table:nil ];
		
		if( suggestionKey )
		{
			// Get suggestion
			
			suggestion = [ inBundle localizedStringForKey:(NSString*)suggestionKey value:nil table:nil ];
		}
		
		// Make alert
		
		alert = [ NSAlert	alertWithMessageText:message
							defaultButton:(NSString*)defaultButton
							alternateButton:(NSString*)alternateButton
							otherButton:(NSString*)otherButton
							informativeTextWithFormat:(NSString*)suggestion ];
		if( alert )
		{
			// Set the alert style...
			
			[ alert setAlertStyle:NSCriticalAlertStyle ];

			// Set icon
			
			[ alert setIcon:nil ];
			
			// Set message
			
			[ alert setMessageText:message ];
			
			if( suggestion )
			{
				// Set suggestion
			
				[ alert setInformativeText:suggestion ];
			}
			
			// Run it!
			
			result = [ alert runModal ];
		}
	}
	
	return result;
}

/////////////////////////////////////////////////////////////////
// Notify the user with an alert. Pass in the localized keys for
// a message or error and a suggestion. The strings are pulled
// from the main bundle of the caller. Pass nil for the buttons
// you don't want to have show up.
/////////////////////////////////////////////////////////////////

int NotifyUserWithMessageAndSuggestionFromMainBundle(	CFStringRef		messageKey,
														CFStringRef		suggestionKey,
														CFStringRef		defaultButton,
														CFStringRef		alternateButton,
														CFStringRef		otherButton )
{
	int	result = 0;
	
	result = NotifyUserWithMessageAndSuggestionFromBundle(	[ NSBundle mainBundle ],
															messageKey,
															suggestionKey,
															defaultButton,
															alternateButton,
															otherButton );
	return result;
}