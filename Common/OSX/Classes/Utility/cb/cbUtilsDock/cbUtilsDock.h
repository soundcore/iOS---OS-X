/*****************************************************************************************

File:			cbUtilsDock.h

Date:			9/29/08

Version:		1.0

Authors:		soundcore

				�2008-2009 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Header for cbUtilsDock.m

				A class to handle Dock-related hacks.
				
				TODO: This class is not currently bindings-compatible
				because we don't have accessors for all properties.
								
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
				cbPathUtils.h
Changes:		

9/29/08			MCA		Initial version.

5/9/09			MCA		Added path-specific Dock shortcut-add API.
				MCA		Added support for 10.5 & 10.6
				MCA		Fixed bug 2687 - Game installer Dock game alias doesn't work

*****************************************************************************************/

#pragma once

#define kUseDockUtilsDebug											0													// 1 for debug, 0 for release *** BE SURE TO TURN OFF FOR RELEASE ***

#define kUseAppleScriptDockRestart									0													// If non-0, use NSAppleScript, else use brute-force kill system calls.

#define kTellDockToQuitAppleScriptCodeNSString						@"tell application \"Dock\" to quit end tell"		// Should be in a .plist for Dock name localization.

// Keys/values in com.apple.dock.plist

#define kPersistentAppsSubArrayKey									@"persistent-apps"

// persistent-apps tile-data entry keys

#define kPersistentAppsEntryGUIDKey									@"GUID"
#define kPersistentAppsEntryTileDataDictKey							@"tile-data"
#define kPersistentAppsEntryTileTypeKey								@"tile-type"

// file-data key

#define kPersistentAppsEntryFileDataSubDictKey						@"file-data"

// tile-type values

#define kPersistentAppsEntryTileTypeFileValue						@"file-tile"
#define kPersistentAppsEntryTileTypeDashboardValue					@"dashboard-tile"

// tile-data keys

#define kPersistentAppsEntryTileDataFileLabelKey					@"file-label"
#define kPersistentAppsEntryTileDataFileModDateKey					@"file-mod-date"
#define kPersistentAppsEntryTileDataParentModDateKey				@"parent-mod-date"

// file-data keys

#define kPersistentAppsEntryFileData_CFURLAliasDataKey				@"_CFURLAliasData"
#define kPersistentAppsEntryFileData_CFURLStringKey					@"_CFURLString"
#define kPersistentAppsEntryFileData_CFURLStringTypeKey				@"_CFURLStringType"

@interface cbDockUtils : NSObject
{
	long					guidNumber;
	NSNumber				*guidNSNumber;
								
	NSString				*dockPlistFullPath;
	
	NSMutableDictionary		*loadedDockPlistDictMutable;
	NSMutableArray			*loadedPersistentAppsArrayMutable;
	NSMutableDictionary		*loadedPersistentAppsEntryDictMutable;
	NSMutableDictionary		*loadedPersistentAppsEntryTileDataDictMutable;
	NSMutableDictionary		*loadedPersistentAppsEntryTileDataFileDataDictMutable;
}

// Init

- (id)init;

- (void)dealloc;

- (NSString*)description;

// Dock utils

- (BOOL)dockHasAppEntryForTargetPath:(NSString*)targetAppPath;

- (BOOL)createDockAppEntryFromTargetPath:(NSString*)targetAppPath;

- (BOOL)removeAllDockAppEntriesForName:(NSString*)appName;

- (void)restartDock;

// Internal routines - Don't call directly!

- (NSMutableDictionary*)getDockPlistMutableDictionary;

- (NSMutableArray*)getPersistentAppsSubArrayFromDockPlistMutableDictionary:(NSMutableDictionary*)dict;

- (NSMutableDictionary*)getAPersistentAppsEntryFromPersistentAppsArray:(NSMutableArray*)array;

- (NSMutableDictionary*)getTileDataDictFromPersistentAppsEntryDict:(NSMutableDictionary*)dict;

- (NSMutableDictionary*)getFileDataDictFromTileDataDict:(NSMutableDictionary*)dict;

- (NSMutableArray*)matchingIndiciesArrayForAppName:(NSString*)appName;

- (BOOL)persistentAppsArrayHasAppEntryName:(NSString*)appName;

- (void)reloadData;

- (void)releaseData;

@end
