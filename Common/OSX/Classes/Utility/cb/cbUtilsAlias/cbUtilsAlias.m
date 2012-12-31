/***************************************************************************************

File:			cbUtilsAlias.m

Date:			9/29/08

Version:		1.0

Authors:		soundcore

				Copyright 2008-2009 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			A class to handle aliases and symlinks in Cocoa
				atomically.
				
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

***************************************************************************************/

#import <cb.h>

#import <cbUtilsAlias.h>
#import <cbUtilsIcon.h>
#import <cbUtilsMac.h>
#import <cbUtilsPath.h>
#import <cbUtilsXPLATPath.h>

@implementation cbAliasUtils

#pragma mark ------------
#pragma mark Init & term
#pragma mark ------------

- (id)init
{
	if( ( self = [ super init ] ) )
	{
	}
	
	return self;
}

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
	
	desc = [ NSString stringWithString:@"cbUtilsAlias" ];
	
	return desc;
}

#pragma mark --------------------
#pragma mark Alias/Symlink Utils
#pragma mark --------------------

////////////////////////////////////////////////////////////////
// Make an alias handle in memory representing the item on disk
// pointed to by fullPath. The returned AliasHandle is nlocked.
// fullPath must not point to an alias as CFURLGetFSRef
// cannot resolve them.
////////////////////////////////////////////////////////////////

- (AliasHandle)aliasHandleFromFullPath:(NSString*)fullPath
{
	Boolean			converted = false;
	AliasHandle		aliasH = NULL;
	FSRef			target;
	NSURL			*url = nil;
	OSStatus		err = noErr;
	
	memset( &target, 0, sizeof( target ) );
	
	if( fullPath )
	{
		// Make a URL...
				
		url = [ NSURL fileURLWithPath:fullPath ];
		if( url )
		{
			// Get FSRef from url...
				
			converted = CFURLGetFSRef( (CFURLRef)url, &target );
			if( converted )
			{
				// Make alias from FSRef...
				
				err = FSNewAlias( NULL, &target, &aliasH );
			}
		}
	}
	
	return aliasH;
}

////////////////////////////////////////////////////////////////
// Return an AliasHandle from the alias data contained in the
// file located at fileFullPath.
////////////////////////////////////////////////////////////////

- (void)aliasHandle:(AliasHandle*)inAliasHPtr fromAliasFileFullpath:(NSString*)fileFullPath
{
	Boolean			gotIt = false;
	Boolean			aliasFileFlag = false;
	Boolean			folderFlag = false;
	char			fullPathCString[ kTempCStringBufferLength ];
	FSRef			target;
	OSStatus		err = noErr;
	
	memset( fullPathCString, 0, sizeof( fullPathCString ) );
	
	memset( &target, 0, sizeof( target ) );
	
	if( fileFullPath && inAliasHPtr )
	{
		*inAliasHPtr = NULL;
		
		// Convert to C string...
				
		gotIt = [ fileFullPath getCString:fullPathCString
									maxLength:(unsigned)sizeof( fullPathCString )
									encoding:NSASCIIStringEncoding ];
		if( gotIt )
		{
			// Make ref to file from path...
	
			err = MakeFSRefFromFullPathName( &target, fullPathCString, kPOSIXStringPathType );
			if( !err )
			{
				// See if it is a valid alias file...
				
				err = FSIsAliasFile ( &target, &aliasFileFlag, &folderFlag );
				if( !err && aliasFileFlag && !folderFlag )
				{
					// Load the alias data stored in the resource fork...
							
					*inAliasHPtr =	(void*)Get1DetachedResourceFromClosedFile(	rAliasType,
																				kFndrAlisID,
																				(OSErr*)&err,
																				&target );
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////
// See if sourceUrl points to an alias and if it does,
// resolve it and return a new resolved URL in outURL, else
// return nil in outURL. If sourceUrl did point to an alias
// and it was resolved, return YES, else return NO. On entry,
// outURL should be a valid pointer to an unallocted NSURL.
///////////////////////////////////////////////////////////////

- (BOOL)resolvedURL:(NSURL**)outURL forSourceURL:(NSURL*)sourceUrl
{
	BOOL			resolved = NO;
	Boolean			gotIt = false;
	Boolean			aliasFileFlag = false;
	Boolean			folderFlag = false;
	Boolean			wasAliased = false;
	char			fullPathCString[ kTempCStringBufferLength ];
	FSRef			target;
	FSSpec			resFileSpec;
	NSString		*absPathString = nil;
	OSStatus		err = noErr;
	
	if( outURL && sourceUrl )
	{
		*outURL = nil;
		
		memset( fullPathCString, 0, sizeof( fullPathCString ) );
		
		memset( &target, 0, sizeof( target ) );
		
		memset( &resFileSpec, 0, sizeof( resFileSpec ) );
		
		// Get path of sourceUrl...
		
		absPathString = [ sourceUrl absoluteString ];
		if( absPathString )
		{
			// Convert to C string...
					
			gotIt = [ absPathString getCString:fullPathCString
										maxLength:(unsigned)sizeof( fullPathCString )
										encoding:NSASCIIStringEncoding ];
			if( gotIt )
			{
				// Make ref to file from path...
		
				err = MakeFSRefFromFullPathName( &target, fullPathCString, kPOSIXStringPathType );
				if( !err )
				{
					// See if it is a valid alias file...
					
					err = FSIsAliasFile ( &target, &aliasFileFlag, &folderFlag );
					if( !err && aliasFileFlag && !folderFlag )
					{
						// Resolve...
					
						err = FSResolveAliasFile(	&target,
													true,
													&folderFlag,
													&wasAliased );
						if( !err )
						{
							// Convert the resolved ref back into a new URL for output...
							
							*outURL = (NSURL*)CFURLCreateFromFSRef( kCFAllocatorDefault, &target );
							if( *outURL )
							{				
								resolved = YES;
							}
						}
					}
				}
			}
		}
	}
	
	return resolved;
}

@end