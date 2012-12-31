/*****************************************************************************

File:			cbUtilsIcon.m

Date:			5/2/09

Version:		1.0

Authors:		soundcore

				Copyright 2009 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			See comment in header.
				
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

******************************************************************************/

#import <cb.h>
#import "cbUtilsAE.h"
#import "cbUtilsBundle.h"
#import "cbUtilsIcon.h"

@implementation cbIconUtils

#pragma mark ------------
#pragma mark Init & term
#pragma mark ------------

////////////////////
// - Init
////////////////////

- (id)init
{
	if( ( self = [ super init ] ) )
	{
	}
	
	return self;
}

//////////////////////
// -dealloc overide
//////////////////////

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
	
	desc = [ NSString stringWithString:@"cbIconUtils" ];
	
	return desc;
}

#pragma mark -----------
#pragma mark Icon Utils
#pragma mark -----------

///////////////////////////////////////////////////////////////////
// Set the custom icon on the file at targetPath to the bundle
// icon for the bundle at sourcePath. Note that targetPath MUST be
// a file and sourcePath MUST be a bundle. You cannot do vice
// versa. If either of the file system objects are not of the
// correct type, the routine will fail.
///////////////////////////////////////////////////////////////////

- (BOOL)setCustomFileIcon:(NSString*)targetPath fromBundlePath:(NSString*)sourcePath
{
	BOOL				iconWasSet = NO;
	BOOL				synced = NO;
	Boolean				converted = false;
	long				response = 0;
	NSBundle			*sourceBundle = nil;
	NSString			*sourceBundleIconsFilePath = nil;
	NSImage				*sourceBundleIconImage = NULL;
	NSURL				*targetFileURL = nil;
	FSRef				targetRef;
	AliasHandle			aliasH = NULL;
	NSWorkspace			*defaultWorkspace = nil;
	cbAEUtils			*aeUtils = nil;
	cbBundleUtils		*bundleUtils = nil;
	OSStatus			err = noErr;
	
	memset( &targetRef, 0, sizeof( targetRef ) );
	
	defaultWorkspace = [ NSWorkspace sharedWorkspace ];
	
	// Make AE Utils
	
	aeUtils = [ [ cbAEUtils alloc ] init ];
	
	// Make bundle utils...
	
	bundleUtils = [ [ cbBundleUtils alloc ] init ];
	
	if( targetPath && sourcePath && defaultWorkspace && aeUtils && bundleUtils )
	{
		// Make bundle for source path...
	
		sourceBundle = [ [ NSBundle alloc ] initWithPath:sourcePath ];
		if( sourceBundle )
		{
			// Dive into the source bundle and get its icon...
			
			sourceBundleIconsFilePath = [ bundleUtils icnsFilePathForBundle:sourceBundle ];
			if( sourceBundleIconsFilePath )
			{
				// Get the source bundle's icon from its .icns file...
				
				sourceBundleIconImage = [ [ NSImage alloc ] initWithContentsOfFile:sourceBundleIconsFilePath ];
				if( sourceBundleIconImage )
				{
					// Set the icon as a custom icon onto the file at targetPath...
					
					iconWasSet = [ defaultWorkspace setIcon:sourceBundleIconImage forFile:targetPath options:NSExcludeQuickDrawElementsIconCreationOption ];
					
					////////////////////////////////////////////////////////////////////////////
					// Force a Finder update on the new item if we are on 10.4 or earlier...
					////////////////////////////////////////////////////////////////////////////
					
					err = Gestalt( gestaltSystemVersion, &response );
					if( !err && ( response < kMacOSTenPointFive ) )
					{
						// Convert path to URL...
						
						targetFileURL = [ NSURL fileURLWithPath:targetPath ];
						if( targetFileURL )
						{
							// Convert the URL to a ref...
							
							converted = CFURLGetFSRef( (CFURLRef)targetFileURL, &targetRef );
							if( converted )
							{
								// Make alias to folderRef...
					
								err = FSNewAliasMinimal( &targetRef, &aliasH );
								if( !err && aliasH )
								{
									// Force Finder update...
									
									synced = [ aeUtils sendFinderResyncEvent:aliasH ];
								}
							}
						}
					}
		
					// Clean up...
			
					[ sourceBundleIconImage release ];
		
					sourceBundleIconImage = nil;
				}
			}
			
			// Clean up...
			
			[ sourceBundle release ];
		
			sourceBundle = nil;
		}
		
		// Clean up...
		
		[ aeUtils release ];
		
		aeUtils = nil;
		
		[ bundleUtils release ];
		
		bundleUtils = nil;
	}
	
	return iconWasSet;
}

@end