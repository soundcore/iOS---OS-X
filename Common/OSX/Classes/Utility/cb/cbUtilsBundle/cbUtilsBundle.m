/*****************************************************************************

File:			cbUtilsBundle.m

Date:			4/29/09

Version:		1.0

Authors:		soundcore

				Copyright 2009 by Code Beauty, LLC
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

#import <Cocoa/Cocoa.h>

#import <cb.h>
#import "cbUtilsBundle.h"
#import "cbUtilsPath.h"

@implementation cbBundleUtils

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
	
	desc = [ NSString stringWithString:@"cbBundleUtils" ];
	
	return desc;
}

#pragma mark -----------------------------------
#pragma mark Get Info & Info.plist Bundle Utils
#pragma mark -----------------------------------

///////////////////////////////////////////////////////////
// Return the user-visible copyright/Get Info string for
// the main bundle. whichString can be:
//
// 1) CFBundleGetInfoString
//
// 2) CFBundleShortVersionString
//
// 3) NSHumanReadableCopyright
///////////////////////////////////////////////////////////

- (NSString*)getInfoStringForMainBundle:(NSString*)whichString
{
	NSBundle	*bundle = nil;
	NSString	*outString = nil;
	
	// Get main bundle...
	
	bundle = [ NSBundle mainBundle ];
	
	if( whichString && bundle )
	{
		// Make output string...
			
		outString = [ self getInfoString:whichString forBundle:bundle ];
	}
	
	return outString;
}

///////////////////////////////////////////////////////////////
// Return the user-visible copyright/Get Info string for
// the bundle passed in. whichString can be:
//
// 1) CFBundleGetInfoString
//
// 2) CFBundleShortVersionString
//
// 3) NSHumanReadableCopyright
///////////////////////////////////////////////////////////////

- (NSString*)getInfoString:(NSString*)whichString forBundle:(NSBundle*)bundle
{
	NSString		*infoPlistStringsFilePathString = nil;
	NSDictionary	*dict = nil;
	NSString		*getInfoString = nil;
	NSString		*outString = nil;
	
	if( whichString && bundle )
	{
		infoPlistStringsFilePathString = [ bundle pathForResource:kCFBundleInfoPlistStringsFileNameNSString ofType:kStaticStringsFilenameExtension ];
		if( infoPlistStringsFilePathString )
		{
			// Load the InfoPlist.strings dict...
			
			dict = [ NSDictionary dictionaryWithContentsOfFile:infoPlistStringsFilePathString ];
			if( dict )
			{
				// Load the get info string from the InfoPlist.strings file for the bundle passed in...
			
				getInfoString = [ dict valueForKey:(NSString*)kCFBundleNSHumanReadableCopyrightgKey ];
				if( getInfoString )
				{
					// Make output string...
					
					outString = [ NSString stringWithString:getInfoString ];
				}
			}
		}
	}
	
	return outString;
}

#pragma mark ------------------------
#pragma mark Bundle .icns file utils
#pragma mark ------------------------

////////////////////////////////////////////////////////////////
// Given a bundle, return a malloc'ed FSRef to its .icns file.
// Caller must dispose of the ref via free().
////////////////////////////////////////////////////////////////

- (FSRef*)icnsFileRefForBundle:(NSBundle*)bundle
{
	Boolean		converted = false;
	FSRef		*ref = NULL;
	FSRef		tempRef;
	NSString	*bundleIconsFilePath = nil;
	NSURL		*url = nil;
	
	memset( &tempRef, 0, sizeof( tempRef ) );
	
	ref = malloc( sizeof( FSRef ) );
	if( ref && bundle )
	{
		// Get path to this bundle's .icns file...
		
		bundleIconsFilePath = [ self icnsFilePathForBundle:bundle ];
		if( bundleIconsFilePath )
		{
			// Make an NSURL to the path...
			
			url = [ NSURL fileURLWithPath:bundleIconsFilePath ];
			if( url )
			{
				// Convert URL to ref...
				
				converted = CFURLGetFSRef( (CFURLRef)url, &tempRef );
				if( converted )
				{
					// Copy to output...
					
					memcpy( ref, &tempRef, sizeof( tempRef ) );
				}
			}
		}
	}
	
	return ref;
}

/////////////////////////////////////////////////////////////
// Given a bundle, return the full path to its .icns file.
/////////////////////////////////////////////////////////////

- (NSString*)icnsFilePathForBundle:(NSBundle*)bundle
{
	NSString			*path = nil;
	NSString			*bundleIconsFileName = nil;
	NSMutableString		*bundleIconsFileNameMutable = nil;
	NSDictionary		*infoPlistDict = nil;
	cbPathUtils		*pathUtils = nil;
	
	// Make path utils...
	
	pathUtils = [ [ cbPathUtils alloc ] init ];
	
	// Make mutable...
	
	bundleIconsFileNameMutable = [ NSMutableString stringWithCapacity:0 ];
	
	if( bundle && pathUtils && bundleIconsFileNameMutable )
	{
		// Get the bundle's Info.plist dict...
		
		infoPlistDict = [ bundle infoDictionary ];
		if( infoPlistDict )
		{
			// Get the bundle's .icns file name from the dict...
			
			bundleIconsFileName = [ infoPlistDict objectForKey:kCFBundleIconFileKeyNSString ];
			if( bundleIconsFileName )
			{
				// Append to mutable...
				
				[ bundleIconsFileNameMutable appendString:bundleIconsFileName ];
				
				////////////////////////////////////////////////////////////////////////////////////////////
				// Some 'CFBundleIconFile' Info.plist entires have an ".icns" suffix on them, some don't.
				// As of 10.4 Finder accepts both. If this one has an extension, we need to strip it off...
				////////////////////////////////////////////////////////////////////////////////////////////
				
				if( !( [ [ bundleIconsFileNameMutable pathExtension ] isEqualToString:kEmptyStringKey ] ) )
				{
					[ pathUtils stripTrailingPathExtension:bundleIconsFileNameMutable ];
				}
				
				// Get the path to the .icns file inside this bundle...
				
				path = [ bundle pathForResource:bundleIconsFileNameMutable ofType:kIconsFileExtension ];
			}
		}
		
		// Clean up...
		
		[ pathUtils release ];
		
		pathUtils = nil;
	}
	
	return path;
}

////////////////////////////////////////////////////////////////
// Given a path to a bundle, return a malloc'ed FSRef to its
// .icns file.
//
// Caller must dispose of the ref via free().
////////////////////////////////////////////////////////////////

- (FSRef*)icnsFileRefForBundlePath:(NSString*)bundlePath
{
	NSBundle	*bundle = nil;
	FSRef		*ref = NULL;
	
	if( bundlePath )
	{
		// Make bundle to bundlePath...
		
		bundle = [ [ NSBundle alloc ] initWithPath:bundlePath ];
		if( bundle )
		{
			// Get FSRef to the icons file inside this bundle...
			
			ref = [ self icnsFileRefForBundle:bundle ];
			
			// Clean up...
			
			[ bundle release ];
			
			bundle = nil;
		}
	}
	
	return ref;
}

/////////////////////////////////////////////////////////////
// Given a path to a bundle, return the full path to its
// .icns file.
/////////////////////////////////////////////////////////////

- (NSString*)icnsFilePathForBundlePath:(NSString*)bundlePath
{
	NSBundle	*bundle = nil;
	NSString	*path = nil;
	
	if( bundlePath )
	{
		bundle = [ [ NSBundle alloc ] initWithPath:bundlePath ];
		if( bundle )
		{
			path = [ self icnsFilePathForBundle:bundle ];
			
			// Clean up...
			
			[ bundle release ];
		}
	}
	
	return path;
}

#pragma mark -------------------------------------------------------------
#pragma mark Installer Package, Plugin, & Installer Receipt Bundle utils
#pragma mark -------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////
// This method can only be used from an Apple installer plugin. This
// routine gets the Description.plist file's dictionary from the
// installer's .lproj directory for the current language.
//
// You must pass in the installer plugin's bundle.
//
// Note that this routine is *highly* dependent on the structure
// of Apple's installers and thus it may be fragile.
//
// Also note that this method only works for plugins bundled
// inside .mpkg type installers.
//
// Basically what we do is go up from the plugin's bundle to the
// installer's .mpkg bundle, then use the localization routines
// to get the Description.plist file path for the current language
// from there. Once we have that path, we can then get the file's dict.
//
// * * * Only send this message from within installer plugin code! * * *
//
// Note that this method doesn't get the dictionary from the plugin
// itself, but from the plugin's * parent installer *.
/////////////////////////////////////////////////////////////////////////

- (NSDictionary*)installerDescriptionPlistFileDictionaryForPluginBundle:(NSBundle*)pluginBundle
{
	Boolean				converted = false;
	unsigned			i = 0;
	NSBundle			*parentInstallerBundle = nil;
	NSString			*component = nil;
	NSMutableString		*installerBundlePathMutable = nil;
	NSArray				*pluginBundlePathElementsArray = nil;
	
	NSURL				*installerPkgContentsDirURL = nil;
	FSRef				installerPkgContentsDirRef;
	
	FSRef				installerPkgRef;
	CFURLRef			installerPkgCFURL = NULL;
	CFStringRef			installerPkgPathCFStringRef = NULL;
	
	NSString			*descriptionPlistFilePathString = nil;
	NSDictionary		*dict = nil;
	
	OSErr				err = noErr;
	
	memset( &installerPkgContentsDirRef, 0, sizeof( installerPkgContentsDirRef ) );
	
	memset( &installerPkgRef, 0, sizeof( installerPkgRef ) );
	
	installerBundlePathMutable = [ NSMutableString stringWithCapacity:0 ];
	
	if( pluginBundle && installerBundlePathMutable )
	{
		// Get plugin bundle's path components...
		
		pluginBundlePathElementsArray = [ [ pluginBundle bundlePath ] pathComponents ];
		if( pluginBundlePathElementsArray )
		{
			// Loop all components, leaving off last 2 components...
			
			for( i = 0; i < ( [ pluginBundlePathElementsArray count ] - 2 ); i++ )
			{
				// Append next component + slash...
				
				component = [ pluginBundlePathElementsArray objectAtIndex:i ];
				if( component )
				{
					[ installerBundlePathMutable appendString:component ];
					
					[ installerBundlePathMutable appendString:kSlashStringKey ];
				}
			}
			
			// Make a URL...
				
			installerPkgContentsDirURL = [ NSURL fileURLWithPath:installerBundlePathMutable ];
			if( installerPkgContentsDirURL )
			{
				// Convert the URL to a ref...
				
				converted = CFURLGetFSRef( (CFURLRef)installerPkgContentsDirURL, &installerPkgContentsDirRef );
				if( converted )
				{
					// Get /Contents ref's parent ref - this is the installer itself...
					
					err = FSGetParentRef( &installerPkgContentsDirRef, &installerPkgRef );
					if( !err )
					{
						// Convert to URL...
						
						installerPkgCFURL = CFURLCreateFromFSRef( kCFAllocatorDefault, &installerPkgRef );
						if( installerPkgCFURL )
						{
							installerPkgPathCFStringRef = CFURLCopyFileSystemPath( installerPkgCFURL, kCFURLPOSIXPathStyle );
							if( installerPkgPathCFStringRef )
							{
								parentInstallerBundle = [ [ NSBundle alloc ] initWithPath:(NSString*)installerPkgPathCFStringRef  ];
								if( parentInstallerBundle )
								{
									// Now we can finally find the Description.plist file by localization...
									
									descriptionPlistFilePathString = [ parentInstallerBundle pathForResource:kAppleInstallerDescriptionPlistFilenameKey ofType:kStaticPlistFilenameExtension ];
									if( descriptionPlistFilePathString )
									{
										// Load dict from file...
										
										dict = [ NSDictionary dictionaryWithContentsOfFile:descriptionPlistFilePathString ];
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	return dict;
}

@end