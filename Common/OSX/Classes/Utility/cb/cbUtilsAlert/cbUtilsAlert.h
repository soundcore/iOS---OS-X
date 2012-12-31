/***********************************************************************************

File:			cbUtilsAlert.h

Date:			11/1/08

Version:		1.0

Authors:		soundcore

				Copyright 2009 Code Beauty, LLC.
				All rights reserved worldwide.

Notes:			Header for cbUtilsAlert.m and cbUtilsAlert.cp.

				Includes code for both Cocoa-style and Carbon-style alerts.
				
				***
				
				NOTE: If you wish to use ShowFeatureUnimplemnetedAlert(), the
				calling application *must* include a
				kFeatureIsUnimplementedMessageStringKey entry in its
				Localizable.strings file or else  ShowFeatureUnimplemnetedAlert() 
				will not work properly. The value of this key should read "This
				feature is unimplemented."
				
				***

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

#include <Carbon/Carbon.h>

#ifdef __OBJC__
#include <Cocoa/Cocoa.h>
#endif

//////////////
// Defines
//////////////

#define kFeatureIsUnimplementedMessageStringKey			CFSTR( "kFeatureIsUnimplementedMessageStringKey" )

#define kUseCFUserNotificationDisplayAlerts				1
#define kStandardAlerts									2

#ifdef __cplusplus
extern "C" {
#endif
	
#ifdef __OBJC__

/////////////////////////////
// Cocoa-style alerts
/////////////////////////////

int NotifyUserWithMessageAndSuggestionFromBundle(	NSBundle		*inBundle,
													CFStringRef		messageKey,
													CFStringRef		suggestionKey,
													CFStringRef		defaultButtonTitle,
													CFStringRef		alternateButtonTitle,
													CFStringRef		otherButtonTitle );

#endif

int NotifyUserWithMessageAndSuggestionFromMainBundle(	CFStringRef		messageKey,
														CFStringRef		suggestionKey,
														CFStringRef		defaultButtonTitle,
														CFStringRef		alternateButtonTitle,
														CFStringRef		otherButtonTitle );
/////////////////////////////
// Carbon-style alerts
/////////////////////////////

// Protos - Generic alerts using CFStrings and keys into Localizable.strings

SInt16		CFStringStandardAlert(	AlertType			inAlertType,
									unsigned			alertAPI,
									CFStringRef			messageCFString,
									CFStringRef			suggestionCFString,
									Boolean				movable,
									ConstStringPtr		defaultText,
									ConstStringPtr		cancelText,
									ConstStringPtr		otherText,
									SInt16              defaultButton,
									SInt16              cancelButton	);
									
SInt16		CFStringStandardAlertFromLocalizedKeys(	AlertType			inAlertType,
													CFStringRef			messageCFStringKey,
													CFStringRef			suggestionCFStringKey,
													Boolean				movable,
													ConstStringPtr		defaultText,
													ConstStringPtr		cancelText,
													ConstStringPtr		otherText,
													SInt16              defaultButton,
													SInt16              cancelButton	);

SInt16		CFStringStandardAlertWithOtherButtonFromLocalizedKeys(	AlertType			inAlertType,
																	CFStringRef			messageCFStringKey,
																	CFStringRef			suggestionCFStringKey,
																	Boolean				movable,
																	ConstStringPtr		defaultText,
																	ConstStringPtr		cancelText,
																	CFStringRef			otherButtonNameCFStringKey,
																	SInt16              defaultButton,
																	SInt16              cancelButton	);
// Protos - Pre-made static alerts

void		ShowFeatureUnimplemnetedAlert( CFStringRef appNameStringKey );

#ifdef __cplusplus
}
#endif
