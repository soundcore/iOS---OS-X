/***************************************************************************************

File:			cbUtilsAlias.h

Date:			9/29/08

Version:		1.0

Authors:		soundcore

				Copyright 2008-2009 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Header for cbUtilsAlias.m

				A class to handle aliases and symlinks atomically.
				
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

Dependencies:	XCode 2.5
				cbIconUtils
				cbPathUtils
				MoreFilesX
				Goo Library
				
Changes:		9/29/08			MCA Initial version.

***************************************************************************************/

#ifdef __OBJC__
#import <Cocoa/Cocoa.h>

@interface cbAliasUtils : NSObject
{
}

// Init & term

- (id)init;

- (void)dealloc;

- (NSString*)description;

// Alias utils

- (AliasHandle)aliasHandleFromFullPath:(NSString*)fullPath;

- (void)aliasHandle:(AliasHandle*)inAliasHPtr fromAliasFileFullpath:(NSString*)fileFullPath;

- (BOOL)resolvedURL:(NSURL**)outURL forSourceURL:(NSURL*)sourceUrl;

@end

#endif
