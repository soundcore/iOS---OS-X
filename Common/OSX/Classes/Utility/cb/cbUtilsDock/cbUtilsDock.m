/*****************************************************************************

File:			cbUtilsDock.m

Date:			9/29/08

Version:		1.0

Authors:		soundcore

				�2008-2009 Code Beauty, LLC
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
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/NSAppleScript.h>

#import <cb.h>
#import "cbUtilsAlias.h"
#import "cbUtilsPath.h"
#import "cbUtilsDock.h"

@implementation cbDockUtils

#pragma mark ---------------------
#pragma mark Overrides
#pragma mark ---------------------

////////////////////////////////////////////////////
// - Init our object.
// Note the importance of sending
// -reloadData: it loads all the Dock.plist
// file data into our object so that all the other
// methods can manipulate it.
////////////////////////////////////////////////////

- (id)init
{
	if( ( self = [ super init ] ) )
	{
		guidNumber = 2080206938;
	
		guidNSNumber = nil;
		
		dockPlistFullPath = nil;
		
		loadedDockPlistDictMutable = nil;
		
		loadedPersistentAppsArrayMutable = nil;
		
		loadedPersistentAppsEntryDictMutable = nil;
		
		loadedPersistentAppsEntryTileDataDictMutable = nil;
		
		loadedPersistentAppsEntryTileDataFileDataDictMutable = nil;
	
		// Load data from Apple's Dock.plist file...
		
		[ self reloadData ];
	}
	
	return self;
}

/////////////////////////////
// Release parent & clean up
/////////////////////////////

- (void)dealloc
{
	[ self releaseData ];
	
	[ super dealloc ];
}

////////////////
// Description
////////////////

- (NSString*)description
{
	NSString *desc = nil;
	
	desc = [ NSString stringWithString:@"cbUtilsDock" ];
	
	return desc;
}

#pragma mark --------------------------
#pragma mark High-level Dock utils
#pragma mark --------------------------

//////////////////////////////////////////////////////////////////
// This is a very high-level routine which simply returns whether
// the Dock already has an entry to an app in it or not. This
// message can be sent by other classes, but is mainly used
// internally. targetAppPath is the full path to an app on disk,
// not merely the app name.
//////////////////////////////////////////////////////////////////

- (BOOL)dockHasAppEntryForTargetPath:(NSString*)targetAppPath
{
	BOOL				hasEntry = NO;
	BOOL				hasExtension = NO;
	NSString			*targetAppNameString = nil;
	NSMutableString		*targetAppNameMutableString = nil;
	cbPathUtils			*pathUtils = nil;
	
	// Make paths utils object to use...
		
	pathUtils = [ [ cbPathUtils alloc ] init ];
	
	// Make mutable hack...
	
	targetAppNameMutableString = [ NSMutableString stringWithCapacity:0 ];
	
	if( targetAppPath && pathUtils && targetAppNameMutableString )
	{
		// Get just the app name from the path passed in...
	
		targetAppNameString = [ targetAppPath lastPathComponent ];
		if( targetAppNameString )
		{
			[ targetAppNameMutableString appendString:targetAppNameString ];
			
			// See if target file has a file extension on it...
			
			if( !( [ [ targetAppNameMutableString pathExtension ] isEqualToString:kEmptyStringKey ] ) )
			{
				hasExtension = YES;
			}
			
			if( hasExtension )
			{
				// Strip off extension at end...
			
				[ pathUtils stripTrailingPathExtension:targetAppNameMutableString ];
			}
			
			hasEntry = [ self persistentAppsArrayHasAppEntryName:targetAppNameMutableString ];
		}
		
		// Clean up...
		
		[ pathUtils release ];
		
		pathUtils = nil;
	}
	
	return hasEntry;
}

////////////////////////////////////////////////////////////////
// Create an app shortcut in the Dock. If the shortcut already
// exists, no nothing. Note that this method does  *not*
// restart the Dock so if you want the Dock to reload, you will 
// need to send the -restartDock message separately.
//
// Note that after this method runs, the plist is modified both
// in memory and on disk with the new app entry. You should
// never modify the contents of the dock's plist directly or
// modify any of the members of this class directly or it may
// cause synchronization problems.
////////////////////////////////////////////////////////////////

- (BOOL)createDockAppEntryFromTargetPath:(NSString*)targetAppPath
{
	BOOL					created = NO;
	BOOL					hasEntry = NO;
	BOOL					hasExtension = NO;
	unsigned				index = 0;
	
	NSString				*targetAppNameString = nil;
	
	NSString				*_CFURLString = nil;
	NSMutableData			*_CFURLAliasData = nil;
	NSString				*fileLabelString = nil;
	
	AliasHandle				aliasH = NULL;
	
	NSDictionary			*finalEntryDict = nil;
	
	NSMutableString			*targetAppNameMutableString = nil;
	
	cbAliasUtils			*aliasUtils = nil;
	cbPathUtils			*pathUtils = nil;
	
	// Make mutable hack...
	
	targetAppNameMutableString = [ NSMutableString stringWithCapacity:0 ];
	
	if( targetAppPath && targetAppNameMutableString )
	{
		// See if the array already has an entry for the item @ targetAppPath ...
			
		hasEntry = [ self dockHasAppEntryForTargetPath:targetAppPath ];
		if( hasEntry == NO )
		{
			// Get the name of the app we want to add from the path passed in...
			
			targetAppNameString = [ targetAppPath lastPathComponent ];
			if( targetAppNameString )
			{
				// Make utils objects to use...
				
				aliasUtils = [ [ cbAliasUtils alloc ] init ];
				
				pathUtils = [ [ cbPathUtils alloc ] init ];
				
				if( aliasUtils && pathUtils )
				{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// At this point we have all the dictionaries, sub-dictionaries, and arrays loaded that we need to mod the
					// com.apple.dock.plist file. The next step is to replace some values in the dictionaries. The relevant
					// values that need to be replaced are:
					//
					// 1.	loadedPersistentAppsArrayMutable array - we need to add our new Dock entry to this array.
					//
					// 2.	loadedPersistentAppsEntryDictMutable dict - In this dict we need to replace the values for the
					//		following keys:
					//
					//			file-data->_CFURLAliasData - Needs a new alias that points to the target app.
					//
					//			file-data->_CFURLString - Needs the fullpath to the app.
					//
					// 3.		file-label - Need the name of the target app. This is the text which shows up in the Dock icon.
					//
					// 4.		Ideally we should also update file-mod-date and parent-mod-date but we don't because it's
					//			more work and doesn't affect the operation of the icon in the Dock so we just leave those
					//			values the same.
					//
					// loadedDockPlistDictMutable represents the entire Dock.plist in memory.
					//
					// When we are all done, the following values get replaced:
					//
					// 1.		Replace file-data in loadedPersistentAppsEntryTileDataDictMutable with
					//			loadedPersistentAppsEntryTileDataFileDataDictMutable.
					//
					// 2.		Replace GUID with a unique number.
					//
					// 3.		Replace tile-data in loadedPersistentAppsEntryDictMutable with
					//			loadedPersistentAppsEntryTileDataDictMutable.
					//
					// 4.		Mod the other atomic fields in loadedPersistentAppsEntryDictMutable.
					//
					// 5.		Add loadedPersistentAppsEntryDictMutable as a new entry to loadedPersistentAppsArrayMutable.
					//
					// 6.		Replace the entire persistent-apps entry in loadedDockPlistDictMutable with our modified
					//			loadedPersistentAppsArrayMutable.
					//
					// 7.		Blast the entire loadedDockPlistDictMutable back to disk, replacing com.apple.dock.plist to
					//			complete the hack!
					//
					// Prety messy huh? So far this works for 10.4/10.5/10.6 but we'll need to monitor any changes Apple makes
					// to the dock plist file since there are no Apple public APIs for altering the Dock plist file currently.
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////

					// First hack our new values into loadedPersistentAppsEntryTileDataFileDataDictMutable (should probably have an API for all this)...
										
					// _CFURLString - Make a full path to the installed target app...
					
					_CFURLString = [ NSString stringWithString:targetAppPath ];
					if( _CFURLString )
					{
						// Replace entry in dict with new value...
						
						if( loadedPersistentAppsEntryTileDataFileDataDictMutable )
						{
							[ loadedPersistentAppsEntryTileDataFileDataDictMutable setValue:_CFURLString forKey:kPersistentAppsEntryFileData_CFURLStringKey ];
						}
					}
									
					// _CFURLAliasData - Make alias data to the installed app...
					
					aliasH = [ aliasUtils aliasHandleFromFullPath:targetAppPath ];
					if( aliasH )
					{			
						HLock( (Handle)aliasH );
						
						_CFURLAliasData = [ [ NSMutableData alloc ] initWithCapacity:(unsigned)GetHandleSize( (Handle)aliasH ) ];
						if( _CFURLAliasData )
						{
							// Add alias data to _CFURLAliasData...
							
							[ _CFURLAliasData appendBytes:(const void*)*aliasH length:(unsigned)GetHandleSize( (Handle)aliasH ) ];
							
							// Clean up alias handle...
							
							HUnlock( (Handle)aliasH );
							
							DisposeHandle( (Handle)aliasH );
							
							aliasH = NULL;
							
							// Replace entry in dict with new value (should have an API for this)...
							
							if( loadedPersistentAppsEntryTileDataFileDataDictMutable )
							{
								[ loadedPersistentAppsEntryTileDataFileDataDictMutable setValue:_CFURLAliasData forKey:kPersistentAppsEntryFileData_CFURLAliasDataKey ];
							}
						}
					}
					
					////////////////////////////////////////////////////////////////////////////////
					// Next hack our new values into loadedPersistentAppsEntryTileDataDictMutable.
					// (Should also have an API for this)...
					//
					// Note that 'file-data' dict itself must be replaced with our copy in
					// loadedPersistentAppsEntryTileDataFileDataDictMutable.
					////////////////////////////////////////////////////////////////////////////////
					
					if( loadedPersistentAppsEntryTileDataDictMutable )
					{
						[ loadedPersistentAppsEntryTileDataDictMutable setValue:loadedPersistentAppsEntryTileDataFileDataDictMutable forKey:kPersistentAppsEntryFileDataSubDictKey ];
					}
					
					// Hack 'tile-data': we need to replace 'file-label' with the name of the app. But note in this case we have to strip any file extension first...
					
					fileLabelString = [ NSString stringWithString:targetAppNameString ];
					if( fileLabelString )
					{
						[ targetAppNameMutableString appendString:fileLabelString ];
			
						// See if target file has a file extension on it...
						
						if( !( [ [ targetAppNameMutableString pathExtension ] isEqualToString:kEmptyStringKey ] ) )
						{
							hasExtension = YES;
						}
						
						if( hasExtension )
						{
							// Strip off extension at end...
						
							[ pathUtils stripTrailingPathExtension:targetAppNameMutableString ];
						}
						
						// Replace entry in dict with new value...
						
						if( loadedPersistentAppsEntryTileDataDictMutable )
						{
							[ loadedPersistentAppsEntryTileDataDictMutable setValue:targetAppNameMutableString forKey:kPersistentAppsEntryTileDataFileLabelKey ];
						}
					}
					
					// Now add the tile-data dict back to the loadedPersistentAppsEntryDictMutable (our new entry)...
					
					if( loadedPersistentAppsEntryDictMutable )
					{
						[ loadedPersistentAppsEntryDictMutable setValue:loadedPersistentAppsEntryTileDataDictMutable forKey:kPersistentAppsEntryTileDataDictKey ];
					}
						
					// Now replace the 'GUID' value in the entry with some bogus number (TODO: we should randomize the # for each entry)...
					
					guidNSNumber = [ NSNumber numberWithLong:guidNumber ];
					
					if( loadedPersistentAppsEntryDictMutable )
					{
						[ loadedPersistentAppsEntryDictMutable setValue:guidNSNumber forKey:kPersistentAppsEntryGUIDKey ];
					}
					
					////////////////////////////////////////////////////////////////////////////////////////////////
					// This concludes the hacking of the single entry we will add to the persistent-apps array.
					// Now we must add our new entry (loadedPersistentAppsEntryDictMutable) to the persistent-apps
					// array (loadedPersistentAppsArrayMutable) as a *new entry*.
					////////////////////////////////////////////////////////////////////////////////////////////////
					
					// Add new entry 2nd from end...
					
					index = ( [ loadedPersistentAppsArrayMutable count ] - 1 );
					
					finalEntryDict = [ [  NSDictionary alloc ] initWithDictionary:loadedPersistentAppsEntryDictMutable copyItems:YES  ];
					if( finalEntryDict )
					{
						[ loadedPersistentAppsArrayMutable insertObject:finalEntryDict atIndex:(unsigned)index ];
						
						[ finalEntryDict release ];
					}
					
					// Now replace the entire persistent-apps array in the main com.apple.dock.plist dict!
					
					if( loadedDockPlistDictMutable )
					{
						[ loadedDockPlistDictMutable setValue:loadedPersistentAppsArrayMutable forKey:kPersistentAppsSubArrayKey ];
					}
					
					// Now blast the whole thing back to disk!!!!!!!!
					
					if( dockPlistFullPath )
					{
						[ loadedDockPlistDictMutable writeToFile:dockPlistFullPath atomically:NO ];
						
						created = YES;
					}
					
					// Clean up...
					
					[ pathUtils release ];
					
					[ aliasUtils release ];
					
					pathUtils = nil;
					
					aliasUtils = nil;
				}
			}
		}
	}
	
	return created;
}

/////////////////////////////////////////////////////////////////////
// Remove all app (persistent-apps) entries for the name
// passed in in appName. Note that appName has to be the name
// *without* the ".app" extension on the end. Note that if
// the item is in the file part of the Dock (persistent-others),
// this routine does nothing.
//
// The return value is whether or not the name was found even
// ONCE in the Dock - not whether or not all entries were
// removed.
//
// See the big comment in -createDockAppEntryFromTargetPath:
// for a description of how the Dock hacking works. Also note
// that we don't restart the Dock here. You'll need to do that
// from the sender if the return value is YES.
//
// Note that because we are removing all entries for a given name,
// we have to flush and then resend -matchingIndiciesArrayForAppName
// after every single remove or else the internal object's
// members will become out of sync with what we just removed.
// This is redundant and not very fast but it makes the code easier.
//
// Note for example, this means that while we are in this method,
// the persisten-apps array member of loadedDockPlistDictMutable
// in our object is stale and cannot be accessed. We can only access
// that member after we have removed all matching entries and
// resync'ed everything.
//////////////////////////////////////////////////////////////////////

- (BOOL)removeAllDockAppEntriesForName:(NSString*)appName
{
	BOOL					nameWasFoundAtLeastOnce = NO;
	BOOL					hasEntry = NO;
	unsigned				indiciesArrayCount = 0;
	unsigned				decodedInt = 0;
	NSMutableArray			*matchingIndiciesTempArray = nil;
	NSNumber				*decodedNSNumber = nil;
	cbAliasUtils			*aliasUtils = nil;
	cbPathUtils			*pathUtils = nil;
	
	// Make utils objects to use...
				
	aliasUtils = [ [ cbAliasUtils alloc ] init ];
				
	pathUtils = [ [ cbPathUtils alloc ] init ];
				
	if( loadedPersistentAppsArrayMutable &&
		loadedDockPlistDictMutable &&
		dockPlistFullPath &&
		appName &&
		aliasUtils &&
		pathUtils )
	{
		// See if the persistent-apps array already has an entry for this appName...
			
		hasEntry = [ self persistentAppsArrayHasAppEntryName:appName ];
		if( hasEntry )
		{
			nameWasFoundAtLeastOnce = YES;
			
			while( 1 )
			{
				// Get a list of all entry indicies in the Dock that match this name...
			
				matchingIndiciesTempArray = [ self matchingIndiciesArrayForAppName:appName ];
				if( matchingIndiciesTempArray )
				{
					// See if we have any matching entries...
					
					indiciesArrayCount = [ matchingIndiciesTempArray count ];
					
					if( indiciesArrayCount > 0 )
					{
						// Get 1st entry (NSNumber) in the matching indicies array...
						
						decodedNSNumber = [ matchingIndiciesTempArray objectAtIndex:0 ];
						if( decodedNSNumber )
						{
							// Get it as an unsigned int...
							
							decodedInt = [ decodedNSNumber unsignedIntValue ];
							
							// Now remove the item at that index in persistent-apps array...
							
							[ loadedPersistentAppsArrayMutable removeObjectAtIndex:decodedInt ];
						}
					}
					else
					{
						// No more matching entries so break...
						
						break;
					}
				}
				else
				{
					break;
				}
			}
			
			// * * * CRITICAL! * * *  Re-insert loadedPersistentAppsArrayMutable into loadedDockPlistDictMutable...
			
			if( loadedDockPlistDictMutable )
			{
				[ loadedDockPlistDictMutable setValue:loadedPersistentAppsArrayMutable forKey:kPersistentAppsSubArrayKey ];
			}
			
			// Now blast the whole thing back to disk!!!!!!!!
			
			if( dockPlistFullPath )
			{
				[ loadedDockPlistDictMutable writeToFile:dockPlistFullPath atomically:NO ];
			}
			
			// Clean up...
			
			[ aliasUtils release ];
			
			[ pathUtils release ];
			
			aliasUtils = nil;
			
			pathUtils = nil;
			
			// Last but not least, reload all the Dock data back into our object...
			
			[ self reloadData ];
		}
	}
	
	return nameWasFoundAtLeastOnce;
}

///////////////////////////////////////////////////////////////
// Restart the Dock which forces it to re-read the Dock plist
// file. Ideally this should be done with Apple Events or
// AppleScript so that the Dock shuts down gracefully. If we
// don't use AE, we instead use brute-force kill system calls
// which is a hack but always works.
///////////////////////////////////////////////////////////////

- (void)restartDock
{
	NSAppleScript			*as = nil;
	NSAppleEventDescriptor	*asDesc = nil;
	NSDictionary			*asErrorDict = nil;
	
	// Restart Dock so new shortcut shows up...
	
	#if kUseAppleScriptDockRestart
	
		///////////////////////////////////////////////////////////////////////////////
		// Could also use:
		// system( "osascript -e 'tell application \"Dock\" to quit end tell'" );
		// but if Apple changes the OSA architecture in any way, that may break too.
		///////////////////////////////////////////////////////////////////////////////
		
		as = [ [ NSAppleScript alloc ] initWithSource:kTellDockToQuitAppleScriptCodeNSString ];
		if( as )
		{
			// Run the script...
			
			asDesc = [ as executeAndReturnError:&asErrorDict ];
			if( asErrorDict )
			{
				// Dump error to Console only if an error dict was returned...
			}
		}
	
	#else
	
		#pragma unused( as )
		#pragma unused( asDesc )
		#pragma unused( asErrorDict )
		
		// Evil but effective - brute force just restarts the Dock...
		
		system( "killall Dock" );
	
	#endif
}

#pragma mark ---------------------------------------
#pragma mark Internal routines - Don't call directly
#pragma mark ---------------------------------------

//////////////////////////////////////////////////////////////////
// Returns an NSMutableDictionary of the entire
// com.apple.dock.plist file. Caller must deallocate.
//////////////////////////////////////////////////////////////////

- (NSMutableDictionary*)getDockPlistMutableDictionary
{
	NSMutableDictionary		*mutablePlistDictionary = nil;
	NSMutableDictionary		*newMutablePlistDictionary = nil;
	cbPathUtils			*pathUtils = nil;
	
	// Make paths utils object to use...
		
	pathUtils = [ [ cbPathUtils alloc ] init ];
	if( pathUtils )
	{
		// Now load the entire com.apple.dock.plist file into an NSMutableDictionary
			
		mutablePlistDictionary = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:dockPlistFullPath ];
		if( mutablePlistDictionary )
		{
			// Make a new copy...
		
			newMutablePlistDictionary = [ [ NSMutableDictionary alloc ] initWithDictionary:mutablePlistDictionary copyItems:YES ];
		}
		
		[ pathUtils release ];
	}
	
	return newMutablePlistDictionary;
}

//////////////////////////////////////////////////////////////////
// Given a valid plist from getDockPlistMutableDictionary, return
// a mutable array containing just the 'persistent-apps'
// sub array. 'dict' must be a valid plist returned from
// - getDockPlistMutableDictionary.
//////////////////////////////////////////////////////////////////

- (NSMutableArray*)getPersistentAppsSubArrayFromDockPlistMutableDictionary:(NSMutableDictionary*)dict
{
	NSMutableArray		*mutablePlistArray = nil;
	NSMutableArray		*newMutablePlistArray = nil;
	
	if( dict )
	{
		// Get 'persistent-apps' sub-array...
		
		mutablePlistArray = [ dict objectForKey:kPersistentAppsSubArrayKey  ];
		if( mutablePlistArray )
		{
			// Make a new copy...
		
			newMutablePlistArray = [ [ NSMutableArray alloc ] initWithArray:mutablePlistArray copyItems:YES ];
		}
	}
	
	return newMutablePlistArray;
}

//////////////////////////////////////////////////////////////////////
// Given a valid plist persistent-apps array, get *a copy of* a
// file-tile entry from the persistent apps array. The array passed in
// must be a valid persistent apps sub array obtained from
// -getPersistentAppsSubArrayFromDockPlistMutableDictionary.
//
// Note that the persistent-apps array is not a key/value based
// dictionary but rather an NSArray. Because of this a simple
// objectForKey message will not work.
//
// We use the first 'file-type' entry found as any app's entry will
// do for the basis of our new entry. The idea is to use the copy as
// a basis, replace it's values, and then add it as a new entry back
// to the persistent-apps array.
//
// Entry 0 is always the dashboard entry under 10.4 & 10.5 so we skip
// that one and get the 2nd dock entry which is the first entry after
// the dashboard entry. Also note the Finder's enttry is not contained
// in the plist because it is inserted into the dock at runtime.
//////////////////////////////////////////////////////////////////////

- (NSMutableDictionary*)getAPersistentAppsEntryFromPersistentAppsArray:(NSMutableArray*)array
{
	NSMutableDictionary		*mutablePlistDictionary = nil;
	NSMutableDictionary		*newMutableDictionary = nil;
	
	if( array )
	{
		// Get 2nd entry the persistent-apps array...
		
		mutablePlistDictionary = [ array objectAtIndex:1 ];
		if( mutablePlistDictionary )
		{
			// Make a new copy...
		
			newMutableDictionary = [ [ NSMutableDictionary alloc ] initWithDictionary:mutablePlistDictionary copyItems:YES ];
		}
	}
	
	return newMutableDictionary;
}

///////////////////////////////////////////////////////////////
// Given a single mutable dict for a file-tile entry from the
// persistent apps dict, return the entry's tile-data dict as
// a mutable dict. dict passed in must be a valid dictionary
// returned by getAPersistentAppsEntryFromPersistentAppsArray.
///////////////////////////////////////////////////////////////

- (NSMutableDictionary*)getTileDataDictFromPersistentAppsEntryDict:(NSMutableDictionary*)dict
{
	NSMutableDictionary		*mutablePlistDictionary = nil;
	NSMutableDictionary		*newMutableDictionary = nil;
	
	if( dict )
	{
		mutablePlistDictionary = [ dict objectForKey:kPersistentAppsEntryTileDataDictKey  ];
		if( mutablePlistDictionary )
		{
			// Make a new copy...
		
			newMutableDictionary = [ [ NSMutableDictionary alloc ] initWithDictionary:mutablePlistDictionary copyItems:YES ];
		}
	}
	
	return newMutableDictionary;
}

///////////////////////////////////////////////////////////////
// Given a single mutable dict as a tile-data entry from a
// persistent-apps entry dict, return the entry's file-data
// dict as a mutable dict. dict passed in must be a valid
// tile-data dict returned by
// getTileDataDictFromPersistentAppsDict.
///////////////////////////////////////////////////////////////

- (NSMutableDictionary*)getFileDataDictFromTileDataDict:(NSMutableDictionary*)dict
{
	NSMutableDictionary		*mutablePlistDictionary = nil;
	NSMutableDictionary		*newMutableDictionary = nil;
	
	if( dict )
	{
		mutablePlistDictionary = [ dict objectForKey:kPersistentAppsEntryFileDataSubDictKey  ];
		if( mutablePlistDictionary )
		{
			// Make a new copy...
		
			newMutableDictionary = [ [ NSMutableDictionary alloc ] initWithDictionary:mutablePlistDictionary copyItems:YES ];
		}
	}
	
	return newMutableDictionary;
}

////////////////////////////////////////////////////////////////
// Return an array of NSNumbers - each one representing an
// index into the persistent-apps array that matches appName.
////////////////////////////////////////////////////////////////

- (NSMutableArray*)matchingIndiciesArrayForAppName:(NSString*)appName
{
	unsigned				i = 0;
	unsigned				persistentAppsArrayCount = 0;
	NSMutableArray			*array = nil;
	NSMutableDictionary		*tempMutableDict = nil;
	NSMutableDictionary		*tileDataMutableDictionary = nil;
	NSString				*foundFileLabelString = nil;
	NSComparisonResult		result = -99;
	NSNumber				*newIndex = nil;
	
	if( loadedPersistentAppsArrayMutable && appName )
	{
		// Make mutable array...
		
		array = [ NSMutableArray arrayWithCapacity:0 ];
		if( array )
		{
			// Get count of Dock app entries...
			
			persistentAppsArrayCount = [ loadedPersistentAppsArrayMutable count ];
			
			// Loop all entries...
			
			for( i = 0; i < persistentAppsArrayCount; i++ )
			{
				result = -99;
				
				// Get next entry...
				
				tempMutableDict = [ loadedPersistentAppsArrayMutable objectAtIndex:i ];
				if( tempMutableDict )
				{
					// Get its tile-data dict...
				
					tileDataMutableDictionary = [ self getTileDataDictFromPersistentAppsEntryDict:tempMutableDict ];
					if( tileDataMutableDictionary )
					{
						// For this entry's tile-data dict, get its file-label value...
								
						foundFileLabelString = [ tileDataMutableDictionary valueForKey:kPersistentAppsEntryTileDataFileLabelKey ];
						if( foundFileLabelString )
						{
							// Compare...
							
							result = [ foundFileLabelString compare:appName ];
							if( result == NSOrderedSame )
							{
								// We have a match!
								
								newIndex = [ NSNumber numberWithUnsignedInt:i ];
								if( newIndex )
								{
									// Add the new number to our returned array...
									
									[ array addObject:newIndex ];
								}
							}
						}
					}
				}
			}
		}
	}
	
	return array;
}

///////////////////////////////////////////////////////////////
// See if the entry to appName already exists in the Dock.
// Note the check is by app name, not path.
///////////////////////////////////////////////////////////////

- (BOOL)persistentAppsArrayHasAppEntryName:(NSString*)appName
{		
	BOOL					hasIt = NO;
	unsigned				i = 0;
	unsigned				count = 0;
	NSMutableDictionary		*mutableArrayEntryDictionary = nil;
	NSMutableDictionary		*mutableArrayEntryTileDataDictionary = nil;
	NSComparisonResult		result = -9;
	NSString				*appStringName = nil;
	
	if( loadedPersistentAppsArrayMutable  )
	{
		// Walk the entire array searching for this app entry...
		
		count = [ loadedPersistentAppsArrayMutable count ];
		
		for( i = 0; i < count; i++ )
		{
			// Get each entry...
			
			mutableArrayEntryDictionary = [ loadedPersistentAppsArrayMutable objectAtIndex:i ];
			if( mutableArrayEntryDictionary )
			{
				// Get the tile-data value for this entry..
				
				mutableArrayEntryTileDataDictionary = [ mutableArrayEntryDictionary objectForKey:kPersistentAppsEntryTileDataDictKey  ];
				if( mutableArrayEntryTileDataDictionary )
				{
					// For this entry's tile-data dict, get its file-label value...
								
					appStringName = [ mutableArrayEntryTileDataDictionary valueForKey:kPersistentAppsEntryTileDataFileLabelKey ];
					if( appStringName )
					{
						// Compare...
						
						result = [ appStringName compare:appName ];
						if( result == NSOrderedSame )
						{
							// We have a match!
							
							hasIt = true;
						}
					}
				}
			}
		}
	}
	
	return hasIt;
}

///////////////////////////////////////////////////////////
// Reload all the data in the object from the file again.
///////////////////////////////////////////////////////////

- (void)reloadData
{
	cbPathUtils	*pathUtils = nil;
	
	// Free old data if it exists first...
	
	[ self releaseData ];
	
	// Make paths utils object to use...
		
	pathUtils = [ [ cbPathUtils alloc ] init ];
	if( pathUtils )
	{
		// Get the full path to the Dock.plist file on disk...
		
		dockPlistFullPath = [ pathUtils getDockPlistFilePath ];
		if( dockPlistFullPath )
		{
			///////////////////////////////////////////////////////////////////////////////
			// Load the entire com.apple.dock.plist file and all its sub-dictionaries and
			// arrays into the object..
			///////////////////////////////////////////////////////////////////////////////

			// First get entire com.apple.dock.plist dictionary...
			
			loadedDockPlistDictMutable = [ self getDockPlistMutableDictionary ];
			if( loadedDockPlistDictMutable )
			{
				// Now get the "persistent-apps' array from the main dict...
				
				loadedPersistentAppsArrayMutable = [ self getPersistentAppsSubArrayFromDockPlistMutableDictionary:loadedDockPlistDictMutable ];
				if( loadedPersistentAppsArrayMutable )
				{
					// Now get an entry in the persistent apps sub dict. This is the entry we will copy and modify. We don't care which one it is. We just need a copy of one...
					
					loadedPersistentAppsEntryDictMutable = [ self getAPersistentAppsEntryFromPersistentAppsArray:loadedPersistentAppsArrayMutable ];
					if( loadedPersistentAppsEntryDictMutable )
					{
						// For this entry's dict get its tile-data dict...
						
						loadedPersistentAppsEntryTileDataDictMutable = [ self getTileDataDictFromPersistentAppsEntryDict:loadedPersistentAppsEntryDictMutable ];
						if( loadedPersistentAppsEntryTileDataDictMutable )
						{
							// For this entry's tile-data dict, get its file-data dict...
							
							loadedPersistentAppsEntryTileDataFileDataDictMutable = [ self getFileDataDictFromTileDataDict:loadedPersistentAppsEntryTileDataDictMutable ];
						}
					}
				}
			}
		}
	
		// Clean up...
		
		[ pathUtils release ];
		
		pathUtils = nil;
	}
}

////////////////////////////////////////////////////////////
// Release all the loaded data...
////////////////////////////////////////////////////////////

- (void)releaseData
{
	if( loadedPersistentAppsEntryTileDataFileDataDictMutable )
	{
		[ loadedPersistentAppsEntryTileDataFileDataDictMutable release ];
		
		loadedPersistentAppsEntryTileDataFileDataDictMutable = nil;
	}

	if( loadedPersistentAppsEntryTileDataDictMutable )
	{
		[ loadedPersistentAppsEntryTileDataDictMutable release ];
		
		loadedPersistentAppsEntryTileDataDictMutable = nil;
	}

	if( loadedPersistentAppsEntryDictMutable )
	{
		[ loadedPersistentAppsEntryDictMutable release ];
		
		loadedPersistentAppsEntryDictMutable = nil;
	}

	if( loadedPersistentAppsArrayMutable )
	{
		[ loadedPersistentAppsArrayMutable release ];
		
		loadedPersistentAppsArrayMutable = nil;
	}
		
	if( loadedDockPlistDictMutable )
	{
		[ loadedDockPlistDictMutable release ];
		
		loadedDockPlistDictMutable = nil;
	}
	
	if( dockPlistFullPath )
	{
		[ dockPlistFullPath release ];
		
		dockPlistFullPath = nil;
	}
}

@end
