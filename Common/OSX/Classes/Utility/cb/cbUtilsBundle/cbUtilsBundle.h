/*****************************************************************************

File:			cbUtilsBundle.h

Date:			4/29/09

Version:		1.0

Authors:		soundcore

				Copyright 2009 by Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Header for cbUtilsBundle.m

				TODO: We need to add a very high-level routine that, given a
				path to a bundle, returns the NSImage of the icon in it's
				.icns file. Right now we have methods to get the path
				& FSRef to the .icns file, but not the icon image itself.
				This is a very common need that begs for a common routine
				in order to avoid duplicating code to dive into a bundle and
				load the image.
				
				Set tab width and indent width both to 4 In Project Builder's
				or XCode's Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF CODE BEAUTY, LLC

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE
				FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	XCode 2.5 as of this writing.
				cbUtilsPath
				MoreFilesX
				
Changes:		4/29/09			MCA Initial version

******************************************************************************/

#ifdef __OBJC__
#import <Cocoa/Cocoa.h>

@interface cbBundleUtils : NSObject
{
}

// Init & term

- (id)init;

- (void)dealloc;

- (NSString*)description;

// Get Info & Info.plist Bundle utils

- (NSString*)getInfoStringForMainBundle:(NSString*)whichString;

- (NSString*)getInfoString:(NSString*)whichString forBundle:(NSBundle*)bundle;

// Bundle .icns utils

- (FSRef*)icnsFileRefForBundle:(NSBundle*)bundle;

- (NSString*)icnsFilePathForBundle:(NSBundle*)bundle;

- (FSRef*)icnsFileRefForBundlePath:(NSString*)bundlePath;

- (NSString*)icnsFilePathForBundlePath:(NSString*)bundlePath;

// Installer Package, Plugin, & Installer Receipt Bundle utils

- (NSDictionary*)installerDescriptionPlistFileDictionaryForPluginBundle:(NSBundle*)pluginBundle;

@end

#endif