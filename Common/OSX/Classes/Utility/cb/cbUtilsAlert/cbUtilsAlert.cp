/***********************************************************************************

File:			cbUtilsAlert.h

Date:			11/1/08

Version:		1.0

Authors:		soundcore

				Copyright 2009 Code Beauty, LLC.
				All rights reserved worldwide.

Notes:			cbUtilsAlert.cp implementation.

				***
				
				NOTE: If you wish to use ShowFeatureUnimplemnetedAlert(), the
				calling application *must* include a
				kFeatureIsUnimplementedMessageStringKey entry in its
				Localizable.strings file or else 
				ShowFeatureUnimplemnetedAlert() will not work properly. The
				value of this key should read "This feature is unimplemented."
				
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

6/17/08			MCA		Added some standard alert code from UMB and AESim that was
						common.

***********************************************************************************/

#include "cbUtilsAlert.h"

#pragma mark ------------------------------
#pragma mark Generic Alerts
#pragma mark ------------------------------

/////////////////////////////////////////////////////////////////
// Display a CFUserNotificationDisplayAlert given CFStrings and
// other parameters. You can pass all the normal constants that
// you would pass to StandardAlert. Note that the inAlertType
// parameter works for both old-style StandardAlert and newer
// CFUserNotificationDisplayAlert because Apple has defined
// the alert type constants to be the same for both. alertAPI
// denotes whether to use old StandardAlert or newer
// CFUserNotificationDisplayAlert alerts.
/////////////////////////////////////////////////////////////////

SInt16 CFStringStandardAlert(	AlertType			inAlertType,
								unsigned			alertAPI,
								CFStringRef			messageCFString,
								CFStringRef			suggestionCFString,
								Boolean				movable,
								ConstStringPtr		defaultText,
								ConstStringPtr		cancelText,
								ConstStringPtr		otherText,
								SInt16              defaultButton,
								SInt16              cancelButton	)
{
	Boolean					converted = false;
	SInt16					outItemHit = 0;
	SInt32					result = 0;
	Str255					appNameString = "\p";
	Str255					messageString = "\p";
	CFOptionFlags			responseFlags = 0;
	AlertStdAlertParamRec	inAlertParam = { 0 };
	CFStringRef				otherTextButtonCFString = NULL;
	
	if( messageCFString )
	{
		if( alertAPI == kUseCFUserNotificationDisplayAlerts )
		{
			// First if user passed other text, we need to make a CFString for it...
			
			if( otherText )
			{
				otherTextButtonCFString = CFStringCreateWithPascalString( kCFAllocatorDefault, otherText, kCFStringEncodingASCII );
			}
			
			// Set CF alert type based on value of inAlertType...
			
			switch( inAlertType )
			{
				case kAlertStopAlert:
				
					responseFlags = kCFUserNotificationStopAlertLevel;
					
					break;
					
				case kAlertNoteAlert:
				
					responseFlags = kCFUserNotificationNoteAlertLevel;
				
					break;
					
				case kAlertCautionAlert:
				
					responseFlags = kCFUserNotificationCautionAlertLevel;
				
					break;
					
				case kAlertPlainAlert:
				
					responseFlags = kCFUserNotificationPlainAlertLevel;
				
					break;
					
				default:
				
					break;
			}
			
			// Display...
			
			result = CFUserNotificationDisplayAlert(	0,
														responseFlags,
														NULL,
														NULL,
														NULL,
														CFSTR( "Code Beauty Alert:" ),
														messageCFString,
														NULL,
														NULL,
														otherTextButtonCFString,
														&responseFlags );
			if( otherTextButtonCFString )
			{
				CFRelease( otherTextButtonCFString );
				
				otherTextButtonCFString = NULL;
			}
			
			outItemHit = 0;
		}
		else if( alertAPI == kStandardAlerts )
		{
			// Old style...
			
			// Set up param block...
		
			inAlertParam.movable = movable;
			
			inAlertParam.defaultText = (ConstStringPtr)defaultText;
			
			inAlertParam.cancelText = (ConstStringPtr)cancelText;
			
			if( otherText )
			{
				inAlertParam.otherText = (ConstStringPtr)otherText;
			}
			
			inAlertParam.defaultButton = defaultButton;
			
			inAlertParam.cancelButton = cancelButton;
			
			// Convert CFStrings to P strings...
			
			converted = CFStringGetPascalString( messageCFString, (StringPtr)appNameString, (CFIndex)255, kCFStringEncodingASCII );
			
			converted = CFStringGetPascalString( suggestionCFString, (StringPtr)messageString, (CFIndex)255, kCFStringEncodingASCII );

			// Alert user...
			
			(void)StandardAlert(	inAlertType,
									appNameString,
									messageString,
									&inAlertParam,
									&outItemHit );
		}
	}
	
	return outItemHit;
}
													
//////////////////////////////////////////////////////
// Same as CFStringStandardAlert except in the two
// CFStringRef parameters pass keys into the localized
// strings file instead of the strings themselves.
//////////////////////////////////////////////////////

SInt16 CFStringStandardAlertFromLocalizedKeys(	AlertType			inAlertType,
												CFStringRef			messageCFStringKey,
												CFStringRef			suggestionCFStringKey,
												Boolean				movable,
												ConstStringPtr		defaultText,
												ConstStringPtr		cancelText,
												ConstStringPtr		otherText,
												SInt16              defaultButton,
												SInt16              cancelButton	)
{
	SInt16				outItemHit = 0;
	CFStringRef			messageCFString = NULL;
	CFStringRef			suggestionCFString = NULL;
	
	if( messageCFStringKey )
	{
		// Load strings indicated from Localizable.strings file...
		
		messageCFString = CFCopyLocalizedString( messageCFStringKey, NULL );
		
		if( suggestionCFStringKey )
		{
			suggestionCFString = CFCopyLocalizedString( suggestionCFStringKey, NULL );
		}
		
		if( messageCFString )
		{
			// Show alert...
			
			outItemHit = CFStringStandardAlert(	inAlertType,
												kUseCFUserNotificationDisplayAlerts,
												messageCFString,
												suggestionCFString,
												movable,
												defaultText,
												cancelText,
												otherText,
												defaultButton,
												cancelButton		);
			// Clean up...
			
			CFRelease( messageCFString );
			
			messageCFString = NULL;
			
			if( suggestionCFStringKey )
			{
				CFRelease( suggestionCFString );
				
				suggestionCFString = NULL;
			}
		}
	}
	
	return outItemHit;
}

//////////////////////////////////////////////////////
// Same as CFStringStandardAlertFromLocalizedKeys
// except that you can pass an optional localized
// key in the 7th parameter as a CFString for the
// "Other" button name. If you don't want the other
// button displayed, then just call
// CFStringStandardAlertFromLocalizedKeys instead.
//////////////////////////////////////////////////////

SInt16 CFStringStandardAlertWithOtherButtonFromLocalizedKeys(	AlertType			inAlertType,
																CFStringRef			messageCFStringKey,
																CFStringRef			suggestionCFStringKey,
																Boolean				movable,
																ConstStringPtr		defaultText,
																ConstStringPtr		cancelText,
																CFStringRef			otherButtonNameCFStringKey,
																SInt16              defaultButton,
																SInt16              cancelButton	)
{
	Boolean				converted = false;
	SInt16				outItemHit = 0;
	Str255				buttonName255 = { 0 };
	ConstStringPtr		otherText = NULL;
	CFStringRef			messageCFString = NULL;
	CFStringRef			suggestionCFString = NULL;
	CFStringRef			tempButtonNameCFStringRef = NULL;
	
	if( messageCFStringKey )
	{
		// Load strings indicated from Localizable.strings file...
		
		messageCFString = CFCopyLocalizedString( messageCFStringKey, NULL );
		
		suggestionCFString = CFCopyLocalizedString( suggestionCFStringKey, NULL );
		
		// Also load the other button name if indicated...
		
		if( otherButtonNameCFStringKey )
		{
			// Load button name...
			
			tempButtonNameCFStringRef = CFCopyLocalizedString( otherButtonNameCFStringKey, NULL );
			if( tempButtonNameCFStringRef )
			{
				// Make Pascal string...
				
				converted = CFStringGetPascalString(	tempButtonNameCFStringRef,
														buttonName255,
														(CFIndex)sizeof( buttonName255 ),
														kCFStringEncodingASCII	);
				
				if( converted )
				{
					// Point the StringPtr at the Str255...
			
					otherText = buttonName255;
				}
				
				CFRelease( tempButtonNameCFStringRef );
			}
		}
		
		if( messageCFString )
		{
			// Show alert...
			
			outItemHit = CFStringStandardAlert(	inAlertType,
												kUseCFUserNotificationDisplayAlerts,
												messageCFString,
												suggestionCFString,
												movable,
												defaultText,
												cancelText,
												otherText,
												defaultButton,
												cancelButton		);
			// Clean up...
			
			CFRelease( messageCFString );
			
			CFRelease( suggestionCFString );
		}
	}
	
	return outItemHit;
}

#pragma mark ------------------------------
#pragma mark Pre-made Alerts
#pragma mark ------------------------------

///////////////////////////////////////////////////////////////////
// Show the feature unimplemented alert.
//
//	NOTE: If you wish to use ShowFeatureUnimplemnetedAlert(), the
//	calling application *must* include a
//	kFeatureIsUnimplementedMessageStringKey entry in its
//	Localizable.strings file or else 
//	ShowFeatureUnimplemnetedAlert() will not work properly. The
//	value of this key should read "This feature is unimplemented."
///////////////////////////////////////////////////////////////////

void ShowFeatureUnimplemnetedAlert( CFStringRef appNameStringKey )
{
	SInt16	outItemHit = 0;
	
	outItemHit = CFStringStandardAlertFromLocalizedKeys(	kAlertNoteAlert,
															appNameStringKey,
															kFeatureIsUnimplementedMessageStringKey,
															true,
															(ConstStringPtr)kAlertDefaultOKText,
															NULL,
															NULL,
															kAlertStdAlertOKButton,
															0							);
}