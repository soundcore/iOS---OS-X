#import <cb.h>
#import "cbUtilsPath.h"
#import "cbUtilsCarbonPath.h"

#import <SystemConfiguration/SCDynamicStoreCopySpecific.h>

@implementation cbPathUtils

#pragma mark -----
#pragma mark Init
#pragma mark -----

////////////////////
// - init
////////////////////

- (id)init
{
	if( ( self = ( [ super init ] ) ) )
	{
	}
	
	return self;
}

////////////////////
// Release parent
////////////////////

- (void)dealloc
{
	[ super dealloc ];
}

////////////////
// Description
////////////////

- (NSString*)description
{
	NSString	*desc = nil;
	
	desc = [ NSString stringWithString:@"cbUtilsPath" ];
	
	return desc;
}

#pragma mark --------------------------
#pragma mark General System Path Utils
#pragma mark --------------------------

#pragma mark Top-level

//////////////////////////////////////////////////////////////////////////
// Returns a localized string for the full path to the /Applications dir.
//////////////////////////////////////////////////////////////////////////

- (NSString*)getApplicationsDirFullPath
{
	NSArray				*paths = nil;
    NSString			*applicationsDirPath = nil;
	NSString			*applicationsDirPathCopy = nil;
	NSFileManager		*fm = nil;
	
	// Get default file managaer...
	
	fm = [ NSFileManager defaultManager ];
    if( fm )
	{
		// Make full path to /Applications...
		
		paths = NSSearchPathForDirectoriesInDomains( NSApplicationDirectory, NSLocalDomainMask, YES );
		if( paths )
		{
			// Get 1st entry...
				
			if( [ paths count ] > 0 )
			{ 
				applicationsDirPath = [ paths objectAtIndex:0 ];
				if( applicationsDirPath )
				{
					// Make new copy to return...
					
					applicationsDirPathCopy = [ NSString stringWithString:applicationsDirPath ];
				}
			}
		}
	}
	
	return applicationsDirPathCopy;
}

//////////////////////////////////////////////////////////////////////////
// Returns a localized string for the full path to the /Library dir.
//////////////////////////////////////////////////////////////////////////

- (NSString*)getLibraryDirFullPath
{
	NSArray				*paths = nil;
    NSString			*libraryDirPath = nil;
	NSString			*libraryDirPathCopy = nil;
	NSFileManager		*fm = nil;
	
	// Get default file managaer...
	
	fm = [ NSFileManager defaultManager ];
    if( fm )
	{
		// Make full path to /Library...
		
		paths = NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSLocalDomainMask, YES );
		if( paths )
		{
			// Get 1st entry...
				
			if( [ paths count ] > 0 )
			{ 
				libraryDirPath = [ paths objectAtIndex:0 ];
				if( libraryDirPath )
				{
					// Make new copy to return...
					
					libraryDirPathCopy = [ NSString stringWithString:libraryDirPath ];
				}
			}
		}
	}
	
	return libraryDirPathCopy;
}

//////////////////////////////////////////////////////////////////
// Returns /tmp including resolving any symlinks along the way.
// Using -pathContentOfSymbolicLinkAtPath: insures that if Apple
// moves the location of /tmp, our code won't break. Note
// that we deliberately *don't* use NSTemporaryDirectory() here
// since some CB components such as the installer hard-code
// /tmp. TODO: For API consistency, we should append a trailing
// '/' onto the end of the path, but right now we don't. Be
// aware of this difference in the cbPathUtils behaviors.
/////////////////////////////////////////////////////////////////

- (NSString*)getTempDirFullPath
{
	NSString			*tmpDirPath = nil;
	NSString			*tmpDirPathCopy = nil;
	NSFileManager		*fm = nil;
	
	// Get default file managaer...
	
	fm = [ NSFileManager defaultManager ];
    if( fm )
	{
		tmpDirPath = [ fm pathContentOfSymbolicLinkAtPath:kTmpDirPathNSString ];
		if( tmpDirPath )
		{
			// Make new copy to return...
			
			tmpDirPathCopy = [ NSString stringWithString:tmpDirPath ];
		}
	}
	
	return tmpDirPathCopy;
}

///////////////////////////////////////////////////////////////////
// Returns a localized string for the full path to the /Users dir.
///////////////////////////////////////////////////////////////////

- (NSString*)getUsersDirFullPath
{
	NSArray				*paths = nil;
    NSString			*libraryDirPath = nil;
	NSString			*libraryDirPathCopy = nil;
	NSFileManager		*fm = nil;
	
	// Get default file managaer...
	
	fm = [ NSFileManager defaultManager ];
    if( fm )
	{
		// Make full path to /Users...
		
		paths = NSSearchPathForDirectoriesInDomains( NSUserDirectory, NSLocalDomainMask, YES );		// 'Users' - not the current user dir.
		if( paths )
		{
			// Get 1st entry...
				
			if( [ paths count ] > 0 )
			{ 
				libraryDirPath = [ paths objectAtIndex:0 ];
				if( libraryDirPath )
				{
					// Make new copy to return...
					
					libraryDirPathCopy = [ NSString stringWithString:libraryDirPath ];
				}
			}
		}
	}
	
	return libraryDirPathCopy;
}

#pragma mark User
	
//////////////////////////////////////////////////////////////////
// Returns a string for the full path to the current user's
// Desktop dir. Caller must release returned string.
// TODO: Remove the trailing slash so that it behaves like the
// other path utils do.
//////////////////////////////////////////////////////////////////

- (NSString*)getUserDesktopFullPath
{
	NSArray				*pathsArray = nil;
	NSString			*tempS = nil;
	NSString			*userDesktopFullPathString = nil;
	NSMutableString		*tempMutableString = nil;
	
	// Make mutable...
	
	tempMutableString = [ NSMutableString stringWithCapacity:0 ];
	
	// Get expanded path to current user desktop from OS...
	
	pathsArray = NSSearchPathForDirectoriesInDomains( NSDesktopDirectory, NSUserDomainMask, YES );
	
	if( pathsArray && tempMutableString )
	{
		// See if we got one...
		
		if( [ pathsArray count ] > 0 )
		{
			// Get path string...
			
			tempS = [ pathsArray objectAtIndex:0 ];
			if( tempS )
			{
				// Append...
				
				[ tempMutableString appendString:tempS ];
				
				[ tempMutableString appendString:kSlashStringKey ];
				
				// Make output...
				
				userDesktopFullPathString = [ [ NSString alloc ] initWithString:tempMutableString ];
			}
		}
	}
	
	return userDesktopFullPathString;
}

//////////////////////////////////////////////////////////////////////
// Returns the system-sanctioned user home directory regardless of OS
// version.
//////////////////////////////////////////////////////////////////////

- (NSString*)getUserHomeDirFullPath
{
	NSString	*dirNSString = nil;
	
	dirNSString = NSHomeDirectory();
	
	return dirNSString;
}

//////////////////////////////////////////////////////////////////////////
// Returns a localized string to the full path to the ~/Library dir.
//////////////////////////////////////////////////////////////////////////

- (NSString*)getUserLibraryDirFullPath
{
	NSArray				*paths = nil;
    NSString			*libraryDirPath = nil;
	NSString			*libraryDirPathCopy = nil;
	NSFileManager		*fm = nil;
	
	// Get default file managaer...
	
	fm = [ NSFileManager defaultManager ];
    if( fm )
	{
		// Make full path to /Library...
		
		paths = NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSUserDomainMask, YES );
		if( paths )
		{
			// Get 1st entry...
				
			if( [ paths count ] > 0 )
			{ 
				libraryDirPath = [ paths objectAtIndex:0 ];
				if( libraryDirPath )
				{
					// Make new copy to return...
					
					libraryDirPathCopy = [ NSString stringWithString:libraryDirPath ];
				}
			}
		}
	}
	
	return libraryDirPathCopy;
}

//////////////////////////////////////////////////////////////////
// Returns a string for the full path to the current user's
// Preferences dir. Caller must release returned string.
//////////////////////////////////////////////////////////////////

- (NSString*)getUserPrefsDirFullPath
{
	NSString			*tempS = nil;
	NSString			*userPreferencesFullPathString = nil;
	NSMutableString		*tempMutableString = nil;
	
	// Make mutable...
	
	tempMutableString = [ NSMutableString stringWithCapacity:0 ];
	
	// Get user Library dir full path...
	
	tempS = [ self getUserLibraryDirFullPath ];
			
	if( tempMutableString && tempS )
	{
		// Append...
				
		[ tempMutableString appendString:tempS ];
		
		[ tempMutableString appendString:kSlashStringKey ];
		
		// Append "Preferences"...
		
		[ tempMutableString appendString:kPreferencesDirNameString ];			// This is ok because the "Preferences" dir name is never localized.
		
		[ tempMutableString appendString:kSlashStringKey ];

		// Make output...
		
		userPreferencesFullPathString = [ [ NSString alloc ] initWithString:tempMutableString ];
	}
	
	return userPreferencesFullPathString;
}

//////////////////////////////////////////////////////////////////////
// Returns the system-sanctioned user temp directory regardless of OS
// version.
//////////////////////////////////////////////////////////////////////

- (NSString*)getUserTempDirFullPath
{
	NSString	*dirNSString = nil;
	
	dirNSString = NSTemporaryDirectory();
	
	return dirNSString;
}

#pragma mark 2nd-level

/////////////////////////////////////////////////////////
// Returns a localized string for the full path to the
// /Library/Documentation dir.
/////////////////////////////////////////////////////////

- (NSString*)libraryDocumentationDirFullPath
{
	NSArray				*paths = nil;
    NSString			*libraryDocumentationDirPath = nil;
	NSString			*libraryDocumentationDirPathCopy = nil;
	NSFileManager		*fm = nil;
	
	// Get default file manager...
	
	fm = [ NSFileManager defaultManager ];
    if( fm )
	{
		// Make full path to /Library/Documentation...
		
		paths = NSSearchPathForDirectoriesInDomains( NSDocumentationDirectory, NSLocalDomainMask, YES );
		if( paths )
		{
			// Get 1st entry...
				
			if( [ paths count ] > 0 )
			{ 
				libraryDocumentationDirPath = [ paths objectAtIndex:0 ];
				if( libraryDocumentationDirPath )
				{
					// Make new copy to return...
					
					libraryDocumentationDirPathCopy = [ NSString stringWithString:libraryDocumentationDirPath ];
				}
			}
		}
	}
	
	return libraryDocumentationDirPathCopy;
}

//////////////////////////////////////////////////////////////////////////
// Returns a localized string for the full path to the
// /Library/Receipts dir. Note that as of 10.5 nothing after the
// /Library dir name is localized so we can hard code "Receipts" here.
//////////////////////////////////////////////////////////////////////////

- (NSString*)libraryReceiptsDirFullPath
{
	NSString			*libraryDirPath = nil;
	NSMutableString		*libraryDirPathMutable = nil;
	NSString			*libraryReceiptsDirPath = nil;
	
	// Get /Library path...
	
	libraryDirPath = [ self getLibraryDirFullPath ];
	if( libraryDirPath )
	{
		// Make new mutable...
		
		libraryDirPathMutable = [ NSMutableString stringWithCapacity:0 ];
		if( libraryDirPathMutable )
		{
			[ libraryDirPathMutable appendString:libraryDirPath ];
			
			// Append /Receipts...
			
			[ libraryDirPathMutable appendString:kSlashStringKey ];
			
			[ libraryDirPathMutable appendString:kReceiptsDirNameString ];
			
			// Make output copy...
			
			libraryReceiptsDirPath = [ NSString stringWithString:libraryDirPathMutable ];
		}
	}
	
	return libraryReceiptsDirPath;
}

#pragma mark Dock

//////////////////////////////////////////////////////////////////
// Returns a string for the full path to the com.apple.dock.plist
// file. User must release the returned string.
//////////////////////////////////////////////////////////////////

- (NSString*)getDockPlistFilePath
{
	NSString	*temp1String = nil;
	NSString	*temp2String = nil;
	NSString	*userDockPrefsPlistFileFullPathName = nil;
	
	// Get path to ~/Library/Preferences/
	
	temp1String = [ self getUserPrefsDirFullPath ];
	if( temp1String )
	{
		// Now make full path including filename...
		
		temp2String = [ temp1String stringByAppendingString:kDockPlistFileNameNSString ];
		if( temp2String )
		{
			// Allocate new copy for return...
			
			userDockPrefsPlistFileFullPathName = [ [ NSString alloc ] initWithString:temp2String ];
		}
	}
	
	return userDockPrefsPlistFileFullPathName;
}

#pragma mark -------------------
#pragma mark General Path Utils
#pragma mark -------------------

////////////////////////////////////////////////////////////////////////////////
// Create a dir at the full path passed in and also create any parent dirs
// needed along the way. This is an incredibly difficult task to do in Carbon
// because of the nature of FSRef structures, so we just do it in Cocoa
// and then use a C wrapper to allow it to interface to C/C++ apps. If the
// requested dir was created, or already exists, return YES, else return NO.
//
// Note we need our own autorelease pool here to prevent leaks as this method
// is often used in apps before the default runloop is initialized - meaning
// there is no default autorelease pool for returned autoreleased objects.
// It doesn't hurt to add a local pool here so in the case where this message
// is sent after default runloop initalization, it won't cause any harm.
////////////////////////////////////////////////////////////////////////////////

- (BOOL)createDirAtPathWithAllSubDirs:(NSString*)fullPath
{
	BOOL				result = NO;
	BOOL				isDir = NO;
	BOOL				created = NO;
	unsigned			i = 0;
	unsigned			count = 0;
	NSFileManager		*manager = nil;
	NSArray				*pathComponents = nil;
	NSString			*pathComponentString = nil;
	NSMutableString		*nextPathString = nil;
	NSAutoreleasePool	*pool = nil;
		
	pool = [ [ NSAutoreleasePool alloc ] init ];
	if( pool )
	{
		// Make a mutable string for appending path components to...
			
		nextPathString = [ [ NSMutableString alloc ] initWithCapacity:0 ];
		
		if( fullPath && nextPathString )
		{
			// Prepend @"/"...
			
			[ nextPathString appendString:kSlashStringKey ];
			
			// Get default file manager...
				
			manager = [ NSFileManager defaultManager ];
			if( manager )
			{
				// First see if dir exists at path...
				
				result = [ manager fileExistsAtPath:fullPath isDirectory:&isDir ];
				if( !result )
				{
					// Get path components...
					
					pathComponents = [ fullPath componentsSeparatedByString:kSlashStringKey ];
					if( pathComponents )
					{
						// Walk down the fullPath, making a path string at each step and seeing if the dir exists...
						
						count = [ pathComponents count ];
						
						// Loop all path components, skipping the 1st one...
						
						for( i = 1; i < count; i++ )
						{
							// Append next path component...
							
							pathComponentString = [ pathComponents objectAtIndex:i ];
							if( pathComponentString )
							{
								[ nextPathString appendString:pathComponentString ];
								
								// See if it exists...
								
								if( ![ manager fileExistsAtPath:nextPathString isDirectory:&isDir ] )
								{
									// Create it...
									
									created = [ manager createDirectoryAtPath:nextPathString attributes:nil ];
								}
								
								// Append slash for next path iteration...
								
								[ nextPathString appendString:kSlashStringKey ];
							}
						}
						
						// See if i == total # of path components - 1. If so, set result to YES...
						
						if( ( i == count ) && ( created == YES ) )
						{
							result = YES;
						}
					}
				}
				else
				{
					// Dir already exists at path so set result to YES...
					
					result = YES;
				}
			}
			
			// Clean up...
			
			[ nextPathString release ];
			
			nextPathString = nil;
		}
		
		// Clean up...
		
		[ pool release ];
		
		pool = nil;
	}
	
	return result;
}

////////////////////////////////////////////////////////////////////////
// Hide the file extension, if any, on the item pointed to by fullPath.
////////////////////////////////////////////////////////////////////////

- (void)hideFileExtensionAtPath:(NSString*)fullPath
{
	BOOL					fileExists = NO;
	BOOL					changed = NO;
	NSFileManager			*fm = nil;
	NSString				*fullPathExpanded = nil;
	NSNumber				*hiddenValue = nil;
	NSDictionary			*fileAttributesDict = nil;
	NSMutableDictionary		*fileAttributesMutableDict = nil;
	
	if( fullPath )
	{
		// Get default manager...
		
		fm = [ NSFileManager defaultManager ];
		
		// Make mutable...
		
		fileAttributesMutableDict = [ NSMutableDictionary dictionaryWithCapacity:0 ];
		
		if( fullPath && fm && fileAttributesMutableDict )
		{
			// Expand tilde if any...
			
			fullPathExpanded = [ fullPath stringByExpandingTildeInPath ];
			if( fullPathExpanded )
			{
				// See if file exists...
						
				fileExists = [ fm fileExistsAtPath:fullPathExpanded ];
				if( fileExists )
				{
					// Get dir attributes at path...
				
					fileAttributesDict = [ fm fileAttributesAtPath:fullPathExpanded traverseLink:YES ];
					if( fileAttributesDict )
					{
						// Make mutabl copy of dict...
						
						[ fileAttributesMutableDict setDictionary:fileAttributesDict ];
						
						// Make hidden value object...

						hiddenValue = [ NSNumber numberWithBool:YES ];
						if( hiddenValue )
						{
							// Set it into the mutable dict...
							
							[ fileAttributesMutableDict setObject:hiddenValue forKey:NSFileExtensionHidden ];
							
							// Now set the changed dict onto the file...
							
							changed = [ fm changeFileAttributes:fileAttributesMutableDict atPath:fullPathExpanded ];
						}
					}
				}
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////
// Return whether the file at fullPath is a Finder alias file or not.
// fullPath must point to a file and not a dir or else this routine will
// fail. This really should be moved to the Alias Utils library.
/////////////////////////////////////////////////////////////////////////

- (BOOL)isAliasFile:(NSString*)fullPath
{
	BOOL				isFile = NO;
	BOOL				fileExists = NO;
	BOOL				isAlias= NO;
	OSType				creatorLong = 0;
	OSType				typeLong  = 0;
	NSNumber			*creator = nil;
	NSNumber			*type = nil;
	NSFileManager		*fm = nil;
	NSDictionary		*fileAttributesDict = nil;
	NSString			*fileTypeNSString = nil;
	NSString			*fullPathExpanded = nil;
	NSMutableString		*tempFileHackMutablePath = nil;
	
	// Get default manager...
	
	fm = [ NSFileManager defaultManager ];
	
	// Make mutable...
	
	tempFileHackMutablePath = [ NSMutableString stringWithCapacity:0 ];
	
	if( fullPath && fm && tempFileHackMutablePath )
	{
		// Expand tilde if any...
		
		fullPathExpanded = [ fullPath stringByExpandingTildeInPath ];
		if( fullPathExpanded )
		{
			// See if file exists...
					
			fileExists = [ fm fileExistsAtPath:fullPathExpanded ];
			if( fileExists )
			{
				// Get dir attributes at path...
			
				fileAttributesDict = [ fm fileAttributesAtPath:fullPathExpanded traverseLink:YES ];
				if( fileAttributesDict )
				{
					// Get file type...
					
					fileTypeNSString = [ fileAttributesDict objectForKey:NSFileType ];
					if( fileTypeNSString )
					{
						// See if it is a file...
					
						isFile = [ fileTypeNSString isEqualToString:NSFileTypeRegular ];
						if( isFile )
						{
							// See if it is an alias file...
							
							creator = [ fileAttributesDict objectForKey:NSFileHFSCreatorCode ];
							if( creator )
							{
								creatorLong = (OSType)[ creator unsignedLongValue ];
							}
							
							type = [ fileAttributesDict objectForKey:NSFileHFSCreatorCode ];
							if( type )
							{
								typeLong = (OSType)[ type unsignedLongValue ];
							}
							
							if( ( creatorLong == typeAlias ) && ( typeLong == typeAlias ) )
							{
								isAlias = YES;
							}
						}
					}
				}
			}
		}
	}
	
	return isAlias;
}

//////////////////////////////////////////////////////////////////////
// Strip the trailing file extension off the path passed in, if any.
// If the path does not have an extension, do nothing. This method
// works for both fully-qualified POSIX paths and URL-style paths.
//////////////////////////////////////////////////////////////////////

- (void)stripTrailingPathExtension:(NSMutableString*)fullPath
{
	unichar		nextChar = 0;
	unsigned	fullPathLength = 0;
	unsigned	i = 0;
	unsigned	pathExtensionCharCount = 0;
	
	if( fullPath )
	{
		fullPathLength = [ fullPath length ];
		
		// Loop string from end looking for '.'...
		
		for( i = [ fullPath length ]; i >= 0 ; i-- )
		{
			nextChar = [ fullPath characterAtIndex:( i - 1 ) ];
			if( nextChar != '.' )
			{
				pathExtensionCharCount++;
			}
			else
			{
				// Strip off pathExtensionCharCount + 1 from end of string...
				
				[ fullPath deleteCharactersInRange:NSMakeRange( ( fullPathLength - ( pathExtensionCharCount + 1 ) ), ( pathExtensionCharCount + 1 ) ) ];
				
				break;
			}
		}
	}
}

#pragma mark --------------------
#pragma mark Receipts Path Utils
#pragma mark --------------------

//////////////////////////////////////////////////////////////////////////
// Returns a localized string for the full path to the Receipts package
// in the /Library/Receipts dir.
//
// The returned path is the full path for the .pkg including the
// package extension.
//
// Example:
//
// If the Receipts package name is "Jewel Quest.pkg", then the
// returned path will be:
//
// /Library/Receipts/Jewel Quest.pkg
//////////////////////////////////////////////////////////////////////////

- (NSString*)libraryReceiptsPackageFullPathForPackageName:(NSString*)packageName
{
	NSString			*libraryReceiptsDirPath = nil;
	NSMutableString		*libraryReceiptsDirPathMutable = nil;
	NSString			*libraryReceiptsPackageDirPath = nil;
	
	if( packageName )
	{
		// Get /Library/Receipts path...
		
		libraryReceiptsDirPath = [ self libraryReceiptsDirFullPath ];
		if( libraryReceiptsDirPath )
		{
			// Make new mutable...
			
			libraryReceiptsDirPathMutable = [ NSMutableString stringWithCapacity:0 ];
			if( libraryReceiptsDirPathMutable )
			{
				[ libraryReceiptsDirPathMutable appendString:libraryReceiptsDirPath ];
				
				// Append /<packageName>...
				
				[ libraryReceiptsDirPathMutable appendString:kSlashStringKey ];
				
				[ libraryReceiptsDirPathMutable appendString:packageName ];
				
				// Append .pkg...
				
				[ libraryReceiptsDirPathMutable appendString:kDotStringKey ];
				
				[ libraryReceiptsDirPathMutable appendString:kInstallerPackageBundleExtension ];
				
				// Make output copy...
				
				libraryReceiptsPackageDirPath = [ NSString stringWithString:libraryReceiptsDirPathMutable ];
			}
		}
	}
	
	return libraryReceiptsPackageDirPath;
}

#pragma mark -------------------------------
#pragma mark Email URL Path Component Utils 
#pragma mark -------------------------------

/////////////////////////////////////////////////////////////////////////
// Given an input email string, return a new string with any reserved
// chars in the original string percent-encoded for HTTP/URL usage.
//
// According to RFC 1738: Uniform Resource Locators (URL) specification,
// 'reserved' chars are:
//
// Dollar ("$")
// Ampersand ("&")
// Plus ("+")
// Comma (",")
// Forward slash/Virgule ("/")
// Colon (":")
// Semi-colon (";")
// Equals ("=")
// Question mark ("?")
// 'At' symbol ("@")
//
// In 2005 this list was appened and we support all of the chars in the
// 2005 spec. See RFC 1738 for more info.
/////////////////////////////////////////////////////////////////////////

- (NSString*)safeURLEncodeEmailStringForReservedChars:(NSString*)inString
{
	unsigned	i = 0;
	unsigned	inStringLength = 0;
	unichar		thisCharUni = 0;
	char		thisCharASCII = 0;
	char		thisCharASCIIBuf [ kSmallLocalStringBufferSize ] = { 0 };
	char		replacementCharBuf [ kSmallLocalStringBufferSize ] = { 0 };
	char		finalBuffer[ kTempCStringBufferLength ] = { 0 };
	NSString	*finalOutString = nil;
	
	if( inString )
	{
		////////////////////////////////////////////////////////////////////////////
		// Walk the inString, getting each char. If the char is a reserved char,
		// replace it with the matching escaped char and append to mutable stiring.
		////////////////////////////////////////////////////////////////////////////
		
		inStringLength = [ inString length ];
		
		for( i = 0; i < inStringLength; i++ )
		{
			thisCharASCII = 0;
			
			memset( thisCharASCIIBuf, kMemsetBufferFillValue, sizeof( thisCharASCIIBuf ) );
			
			memset( replacementCharBuf, kMemsetBufferFillValue, sizeof( replacementCharBuf ) );
			
			// Get next char in input string...
			
			thisCharUni = [ inString characterAtIndex:i ];
			if( thisCharUni )
			{
				// Convert Uni char returned to ASCII...
				
				thisCharASCII = (char)thisCharUni;
				
				// See if it matches a special char & if so, set replacementCharBuf to the %-escape string...
				
				if( thisCharASCII == '!' )
				{
					memcpy( replacementCharBuf, kPercent21, strlen( kPercent21 ) );
				}
				else if( thisCharASCII == '*' )
				{
					 memcpy( replacementCharBuf, kPercent2A, strlen( kPercent2A ) );
				}
				else if( thisCharASCII == '\'' )
				{
					 memcpy( replacementCharBuf, kPercent27, strlen( kPercent27 ) );
				}
				else if( thisCharASCII == '(' )
				{
					 memcpy( replacementCharBuf, kPercent28, strlen( kPercent28 ) );
				}
				else if( thisCharASCII == ')' )
				{
					memcpy( replacementCharBuf, kPercent29, strlen( kPercent29 ) );
				}
				else if( thisCharASCII == ';' )
				{
					memcpy( replacementCharBuf, kPercent3B, strlen( kPercent3B ) );
				}
				else if( thisCharASCII == ':' )
				{
					memcpy( replacementCharBuf, kPercent3A, strlen( kPercent3A ) );
				}
				else if( thisCharASCII == '@' )
				{
					memcpy( replacementCharBuf, kPercent40, strlen( kPercent40 ) );
				}
				else if( thisCharASCII == '&' )
				{
					memcpy( replacementCharBuf, kPercent26, strlen( kPercent26 ) );
				}
				else if( thisCharASCII == '=' )
				{
					memcpy( replacementCharBuf, kPercent3D, strlen( kPercent3D ) );
				}
				else if( thisCharASCII == '+' )
				{
					memcpy( replacementCharBuf, kPercent2B, strlen( kPercent2B ) );
				}
				else if( thisCharASCII == '$' )
				{
					memcpy( replacementCharBuf, kPercent24, strlen( kPercent24 ) );
				}
				else if( thisCharASCII == ',' )
				{
					memcpy( replacementCharBuf, kPercent2C, strlen( kPercent2C ) );
				}
				else if( thisCharASCII == '/' )
				{
					memcpy( replacementCharBuf, kPercent2F, strlen( kPercent2F ) );
				}
				else if( thisCharASCII == '?' )
				{
					memcpy( replacementCharBuf, kPercent3F, strlen( kPercent3F ) );
				}
				else if( thisCharASCII == '%' )
				{
					memcpy( replacementCharBuf, kPercent25, strlen( kPercent25 ) );
				}
				else if( thisCharASCII == '#' )
				{
					memcpy( replacementCharBuf, kPercent23, strlen( kPercent23 ) );
				}
				else if( thisCharASCII == '[' )
				{
					memcpy( replacementCharBuf, kPercent5B, strlen( kPercent5B ) );
				}
				else if( thisCharASCII == ']' )
				{
					memcpy( replacementCharBuf, kPercent5D, strlen( kPercent5D ) );
				}
				else
				{
					// Not a reserved char so just append it to mutable string...
				
					thisCharASCIIBuf[ 0 ] = thisCharASCII;
				
					(void)strcat( finalBuffer, thisCharASCIIBuf );
				}
				
				// If a reserved char was found, append replacement char to the end of the finalBuffer...
				
				if( replacementCharBuf[ 0 ] )
				{
					(void)strcat( finalBuffer, replacementCharBuf );
				}
			}
		}
		
		// Make return string from finalBuffer...
		
		finalOutString = [ NSString stringWithCString:finalBuffer encoding:NSASCIIStringEncoding ];
	}
	
	return finalOutString;
}

#pragma mark ----------------------------
#pragma mark URL normalization methods
#pragma mark ----------------------------

/////////////////////////////////////////////////////////////////////////
// Given an input URL string, return a new string with any reserved
// chars in the original string percent-encoded for HTTP/URL usage.
//
// According to RFC 1738: Uniform Resource Locators (URL) specification,
// 'reserved' chars are:
//
// Dollar ("$")
// Ampersand ("&")
// Plus ("+")
// Comma (",")
// Forward slash/Virgule ("/")
// Colon (":")
// Semi-colon (";")
// Equals ("=")
// Question mark ("?")
// 'At' symbol ("@")
//
// In 2005 this list was appened and we support all of the chars in the
// 2005 spec. See RFC 1738 for more info.
//
// We also handle spaces using %20.
//
// This method is the same as -safeURLEncodeEmailStringForReservedChars
// except that -safeURLEncodeForReservedChars also handles spaces. In
// the future we should probably combine these two routines into one
// in order to avoid duplication of what is almost identical code.
//
// We also don't convert the following chars as they are normally part of
// standard URLs:
//
// '/'
// '?'
// '='
// '&'
//
// If you have a URL which has a '/' in an email address parameter,
// you should first parameterize the email address separately using
// -safeURLEncodeEmailStringForReservedChars. And then assembled the
// string using that normalized email address.
/////////////////////////////////////////////////////////////////////////

- (NSString*)safeURLEncodeForReservedChars:(NSString*)inString
{
	unsigned	i = 0;
	unsigned	inStringLength = 0;
	unichar		thisCharUni = 0;
	char		thisCharASCII = 0;
	char		thisCharASCIIBuf [ kSmallLocalStringBufferSize ] = { 0 };
	char		replacementCharBuf [ kSmallLocalStringBufferSize ] = { 0 };
	char		finalBuffer[ kTempCStringBufferLength ] = { 0 };
	NSString	*finalOutString = nil;
	
	if( inString )
	{
		////////////////////////////////////////////////////////////////////////////
		// Walk the inString, getting each char. If the char is a reserved char,
		// replace it with the matching escaped char and append to mutable stiring.
		////////////////////////////////////////////////////////////////////////////
		
		inStringLength = [ inString length ];
		
		for( i = 0; i < inStringLength; i++ )
		{
			thisCharASCII = 0;
			
			memset( thisCharASCIIBuf, kMemsetBufferFillValue, sizeof( thisCharASCIIBuf ) );
			
			memset( replacementCharBuf, kMemsetBufferFillValue, sizeof( replacementCharBuf ) );
			
			// Get next char in input string...
			
			thisCharUni = [ inString characterAtIndex:i ];
			if( thisCharUni )
			{
				// Convert Uni char returned to ASCII...
				
				thisCharASCII = (char)thisCharUni;
				
				// See if it matches a special char & if so, set replacementCharBuf to the %-escape string...
				
				if( thisCharASCII == ' ' )
				{
					 memcpy( replacementCharBuf, kPercent20, strlen( kPercent20 ) );
				}
				else if( thisCharASCII == '!' )
				{
					memcpy( replacementCharBuf, kPercent21, strlen( kPercent21 ) );
				}
				else if( thisCharASCII == '*' )
				{
					 memcpy( replacementCharBuf, kPercent2A, strlen( kPercent2A ) );
				}
				else if( thisCharASCII == '\'' )
				{
					 memcpy( replacementCharBuf, kPercent27, strlen( kPercent27 ) );
				}
				else if( thisCharASCII == '(' )
				{
					 memcpy( replacementCharBuf, kPercent28, strlen( kPercent28 ) );
				}
				else if( thisCharASCII == ')' )
				{
					memcpy( replacementCharBuf, kPercent29, strlen( kPercent29 ) );
				}
				else if( thisCharASCII == ';' )
				{
					memcpy( replacementCharBuf, kPercent3B, strlen( kPercent3B ) );
				}
				else if( thisCharASCII == ':' )
				{
					memcpy( replacementCharBuf, kPercent3A, strlen( kPercent3A ) );
				}
				else if( thisCharASCII == '@' )
				{
					memcpy( replacementCharBuf, kPercent40, strlen( kPercent40 ) );
				}
				else if( thisCharASCII == '+' )
				{
					memcpy( replacementCharBuf, kPercent2B, strlen( kPercent2B ) );
				}
				else if( thisCharASCII == '$' )
				{
					memcpy( replacementCharBuf, kPercent24, strlen( kPercent24 ) );
				}
				else if( thisCharASCII == ',' )
				{
					memcpy( replacementCharBuf, kPercent2C, strlen( kPercent2C ) );
				}
				else if( thisCharASCII == '%' )
				{
					memcpy( replacementCharBuf, kPercent25, strlen( kPercent25 ) );
				}
				else if( thisCharASCII == '#' )
				{
					memcpy( replacementCharBuf, kPercent23, strlen( kPercent23 ) );
				}
				else if( thisCharASCII == '[' )
				{
					memcpy( replacementCharBuf, kPercent5B, strlen( kPercent5B ) );
				}
				else if( thisCharASCII == ']' )
				{
					memcpy( replacementCharBuf, kPercent5D, strlen( kPercent5D ) );
				}
				else
				{
					// Not a reserved char so just append it to mutable string...
				
					thisCharASCIIBuf[ 0 ] = thisCharASCII;
				
					(void)strcat( finalBuffer, thisCharASCIIBuf );
				}
				
				// If a reserved char was found, append replacement char to the end of the finalBuffer...
				
				if( replacementCharBuf[ 0 ] )
				{
					(void)strcat( finalBuffer, replacementCharBuf );
				}
			}
		}
		
		// Make return string from finalBuffer...
		
		finalOutString = [ NSString stringWithCString:finalBuffer encoding:NSASCIIStringEncoding ];
	}
	
	return finalOutString;
}

#pragma mark ----------------------
#pragma mark  unichar string utils
#pragma mark ----------------------
	
/////////////////////////////////////////////////////////////////////////
// Get the length of string passed in. string must be NULL-terminated.
// Note tha the returned value is the number of characters in the
// string, not the length of the string in bytes.
/////////////////////////////////////////////////////////////////////////

- (unsigned)unicharstrlen:(unichar*)string
{
	unsigned	i = 0;
	unsigned	len = 0;
	unichar		next = 0;
	
	if( string )
	{
		for( i = 0; i < 10000; i++ )
		{
			// Get next char...
			
			next = string[ i ];
			
			// See if it was a zero. If so, break - else increment counter and continue...
			
			if( next == 0 )
			{
				break;
			}
			else
			{
				len++;
			}
		}
	}
	
	return len;
}

#pragma mark -----------------
#pragma mark  C string utils
#pragma mark -----------------

- (NSString*)cFStringRefFromCString:(char*)string withEncoding:(UInt32)newEncoding
{
	NSString	*outString = nil;
	
	outString = [ NSString stringWithCString:string encoding:newEncoding ];
	
	return outString;
}

@end

#pragma mark ------------
#pragma mark C Wrappers
#pragma mark ------------

///////////////////////////////////////////////
// C wrapper for -getApplicationsDirFullPath.
///////////////////////////////////////////////

CFStringRef GetApplicationsDirFullPathCWrapper( void )
{
	NSString		*appDirFullPath = nil;
	cbPathUtils	*utils = nil;
	
	// Make utils...
		
	utils = [ [ cbPathUtils alloc ] init ];
	if( utils )
	{
		appDirFullPath = [ utils getApplicationsDirFullPath ];
		
		// Clean up...
		
		[ utils release ];
		
		utils = nil;
	}
	
	return (CFStringRef)appDirFullPath;
}

//////////////////////////////////////////////////////////////////////////////////
// We use this to transmorgify the results of
// -createDirAtPathWithAllSubDirs:(NSString*)fullPath into C-callable form.
// This is so C/C++ apps can use the Obj-C method.
//////////////////////////////////////////////////////////////////////////////////

Boolean CreateDirAtPathWithAllSubDirs( CFStringRef fullPath )
{
	BOOL			created = NO;
	cbPathUtils	*utils = nil;
	
	if( fullPath )
	{
		// Make utils...
		
		utils = [ [ cbPathUtils alloc ] init ];
		if( utils )
		{
			created = [ utils createDirAtPathWithAllSubDirs:(NSString*)fullPath ];
			
			// Clean up...
			
			[ utils release ];
			
			utils = nil;
		}
	}
	
	return created;
}

/////////////////////////////////////////////////////////////////////////////
// Use this when you want to force the creation of an NSString from C code
// instead of a CFStringRef. Also note that you should pass one of the
// available NSString encodings in the newEncoding param rather than a
// CFString encoding.
/////////////////////////////////////////////////////////////////////////////

CFStringRef CFStringRefFromCStringWithEncoding( char *inString, UInt32 newEncoding )
{
	NSString		*outString = nil;
	cbPathUtils	*utils = nil;
	
	if( inString )
	{
		// Make utils...
		
		utils = [ [ cbPathUtils alloc ] init ];
		if( utils )
		{
			outString = [ utils cFStringRefFromCString:(char*)inString withEncoding:(UInt32)newEncoding ];
			
			// Clean up...
			
			[ utils release ];
			
			utils = nil;
		}
	}
	
	return (CFStringRef)outString;
}
