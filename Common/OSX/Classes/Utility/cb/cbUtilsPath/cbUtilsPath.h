#pragma once

#include <Carbon/Carbon.h>

#ifdef __OBJC__
#import <Cocoa/Cocoa.h>

#define kSmallLocalStringBufferSize			8

#define kDockPlistFileNameNSString			@"com.apple.dock.plist"

#endif

///////////
// Protos
///////////

#ifndef __OBJC__
#ifdef __cplusplus
extern "C" {
#endif
#endif

	// C wrapper protos for cbUtilsPath.m - For C/C++ includes & apps.

	CFStringRef		GetApplicationsDirFullPathCWrapper( void );
	
	Boolean			CreateDirAtPathWithAllSubDirs( CFStringRef fullPath );
	
	CFStringRef		CFStringRefFromCStringWithEncoding( char *inString, UInt32 newEncoding );
	
#ifndef __OBJC__
#ifdef __cplusplus
}
#endif
#endif

#ifdef __OBJC__

	////////////////////////////////
	// Classes
	////////////////////////////////

	@interface cbPathUtils : NSObject
	{
    }

	// Init
	
	- (id)init;
	
	- (void)dealloc;
	
	- (NSString*)description;

	// Top-level
	
	- (NSString*)getApplicationsDirFullPath;
	
	- (NSString*)getLibraryDirFullPath;
	
	- (NSString*)getTempDirFullPath;
	
	- (NSString*)getUsersDirFullPath;
	
	// User
	
	- (NSString*)getUserDesktopFullPath;

	- (NSString*)getUserHomeDirFullPath;
	
	- (NSString*)getUserLibraryDirFullPath;
	
	- (NSString*)getUserPrefsDirFullPath;

	- (NSString*)getUserTempDirFullPath;

	// 2nd-level
	
	- (NSString*)libraryDocumentationDirFullPath;
	
	- (NSString*)libraryReceiptsDirFullPath;
	
	// Dock
	
	- (NSString*)getDockPlistFilePath;
	
	// General path utils
	
	- (BOOL)createDirAtPathWithAllSubDirs:(NSString*)fullPath;
	
	- (void)hideFileExtensionAtPath:(NSString*)fullPath;
	
	- (BOOL)isAliasFile:(NSString*)fullPath;
	
	- (void)stripTrailingPathExtension:(NSMutableString*)fullPath;
	
	// Receipts path utils
	
	- (NSString*)libraryReceiptsPackageFullPathForPackageName:(NSString*)packageName;
	
	// Email path component utils for URLs
	
	- (NSString*)safeURLEncodeEmailStringForReservedChars:(NSString*)inString;
	
	// URL normalization methods.
	
	- (NSString*)safeURLEncodeForReservedChars:(NSString*)inString;
	
	// unichar string utils
	
	- (unsigned)unicharstrlen:(unichar*)string;
	
	// C string utils
	
	- (NSString*)cFStringRefFromCString:(char*)inString withEncoding:(UInt32)encoding;
	
	@end

#endif
