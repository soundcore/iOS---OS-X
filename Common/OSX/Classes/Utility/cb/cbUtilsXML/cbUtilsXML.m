/*****************************************************************************

File:			cbUtilsXML.m

Date:			2/17/10

Version:		8.2

Authors:		soundcore

				Copyright 2008 soundcore
				All rights reserved worldwide.

Notes:			Implementation for cbUtilsXML

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore.

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE
				FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	XCode 2.5 as of this writing, MoreFilesX,
				System Configuration Framework.

Changes:		

2/17/10			MCA Initial version.

******************************************************************************/

#import <cbUtilsXML.h>

@implementation cbUtilsXML

#pragma mark --------------------------
#pragma mark Overrides
#pragma mark --------------------------

////////////////////
// - init
////////////////////

- (id)init
{
	if( ( self = [ super init ] ) )
	{
	}
	
	return self;
}

////////////////////
// -dealloc
////////////////////

- (void)dealloc
{
	[ super dealloc ];
}

#pragma mark --------------------------
#pragma mark  NSXMLElement utils
#pragma mark --------------------------

//////////////////////////////////////////////////////////////////
// The most absolutely annoying thing in working with OS X's
// NSXML-based classes is the inability to directly obtain a
// single XML child element from a given NSXMLElement. There is
// no -elementForName method, only an -elementsForName method,
// which returns an array of elements matching the given name.
//
// But what if you have an element whose contents you know and
// whose contents contain *only* single child nodes of unique
// names? Then what? Suppose you know the names of the children
// nodes and want to get just one of them by name, and know that
// there is only one child having each name, how do you get
// just one child with one message? Answer: in OS X you can't!
//
// Instead you must always send -elementsForName, and then extract
// the individual elements from the returned array, even though
// you already know there will only be one element. This is
// incredibly annoying and more than doubles code size as you
// have to always get the array first and process it.
//
// To solve this problem, I wrote two methods -elementForName,
// and -nodeForName. These two methods return one and only one
// child element or node respectively given a parent element and
// a child node name. Both of these methods assume that the
// parent which you pass in has one and only one child with the
// given name. If you pass in a parent with more than one child of
// the given name, only the first one in the parent will be
// returned.
//
// Use -elementForName instead of -elementsForName in order to
// avoid having to declare and process the array returned by
// -elementsForName. This saves a huge amount of code and time.
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// Given a parent element and a child name, return the child
// NSXMLElement contained in the parent.
//////////////////////////////////////////////////////////////////

- (NSXMLElement*)elementForName:(NSString*)name fromElement:(NSXMLElement*)parent
{
	NSUInteger		foundArrayItemsCount = 0;
	NSArray			*foundArray = nil;
	NSXMLElement	*foundElement = nil;
	
	if( name && parent )
	{
		// Get the array of matches using -elementsForName...
	
		foundArray = [ parent elementsForName:name ];
		if( foundArray )
		{
			// Make sure the array is not empty or else we will crash when we send it -objectAtIndex...
			
			foundArrayItemsCount = [ foundArray count ];
			if( foundArrayItemsCount > 0 )
			{
				// Get 1st matching child element from array...
			
				foundElement = [ foundArray objectAtIndex:0 ];
			}
		}
	}
	
	return foundElement;
}

//////////////////////////////////////////////////////////////////
// Given a parent element and a child name, return the child
// NSXMLNode contained in the parent.
//////////////////////////////////////////////////////////////////

- (NSXMLNode*)nodeForName:(NSString*)name fromElement:(NSXMLElement*)parent
{
	NSUInteger		foundArrayItemsCount = 0;
	NSArray			*foundArray = nil;
	NSXMLNode		*foundNode = nil;
	
	if( name && parent )
	{
		// Get the array of matches using -elementsForName...
	
		foundArray = [ parent elementsForName:name ];
		if( foundArray )
		{
			// Make sure the array is not empty or else we will crash when we send it -objectAtIndex...
			
			foundArrayItemsCount = [ foundArray count ];
			if( foundArrayItemsCount > 0 )
			{
				// Get 1st matching child element from array...
			
				foundNode = (NSXMLNode*)[ foundArray objectAtIndex:0 ];
			}
		}
	}
	
	return foundNode;
}

//////////////////////////////////////////////////////////////////
// Given a filename and extension of a valid XML file stored in
// the current bundle, return an NSXMLDocument object representing
// the XML contents of the file. The file indicated must be a
// valid XML file or this routine will fail.
//////////////////////////////////////////////////////////////////

- (NSXMLDocument*)docInBundleForFileName:(NSString*)name andExtension:(NSString*)extension
{
	NSBundle		*mainBundle = nil;						// Caller's main bundle.
	NSString		*docFileFullpathNSString = nil;			// Full path to file passed in located in caller's main bundle.
	NSData			*fileData = nil;						// Raw config file data.
	NSXMLDocument	*doc = nil;								// Newly created XML doc from the file.
	NSError			*error = nil;
	
	// Get the app's bundle...
	
	mainBundle = kMainBundle;
	if( mainBundle )
	{
		// Look for the config file in the main bundle by name and type...

		docFileFullpathNSString = [ mainBundle pathForResource:name ofType:extension ];
		if( docFileFullpathNSString )
		{
			// Alloc an NSData from the file...
			
			fileData = [ [ NSData alloc ] initWithContentsOfFile:docFileFullpathNSString ];
			if( fileData )
			{
				// Make NSXMLDocument from NSData...
				
				doc = [ [ [ NSXMLDocument alloc ] initWithData:fileData options:NSXMLDocumentTidyXML error:&error ] autorelease ];
				
				// Clean up...
				
				[ fileData release ];
			}
		}
	}
	
	return doc;
}

///////////////////////////////////////////////////////////////////
// Given a raw pointer to valid XML data, dump the data to an XML
// file at the fullpath specified. Ideally the filename extension
// at 'path' should be '.xml'.
///////////////////////////////////////////////////////////////////

- (void)dumpData:(void*)data ofLength:(unsigned long)len asXMLFile:(NSString*)path
{
	NSData *tempData = nil;
	
	tempData = [ NSData dataWithBytes:(const void*)data length:len ];
	
	if( data && path && tempData )
	{
		// Dump it...
			
		(void)[ tempData writeToFile:path atomically:NO ];
	}
}

#pragma mark --------------------------
#pragma mark .NET Mimickers
#pragma mark --------------------------

/////////////////////////////////////////////////////////////////////////////////////////
// This method is roughly designed to mimic .NET's SelectSingleNode method.
// There is ONE major difference:
//
// SelectSingleNode will return the next node given a parent node with subsequent
// iterations on the same node. -firstNodeForXPath does NOT support multiple
// iterations on the same node. Instead it provides the first and only the first node
// matching the XPath query string. If you call it multiple times on the same node,
// you'll get back the same first node every time.
//
// So why have it at all?
//
// It's useful because in much of the Security Shield WIndows application,
// SelectSingleNode is used to get only the first node from an XML document. In these
// cases, -firstNodeForXPath is immensely useful because it saves a ton of OS X code.
//
// How?
//
// Well OS X uses a method named -nodesForXPath:error: that returns an array of ALL
// matching nodes for an XPath query. Then you have to check that that array is not
// empty, then you have to get its first entry, then in most cases you have to
// convert that entry to a string. So -firstNodeForXPath is a convenience routine that
// does the same thing as SelectSingleNode in .NET, but only for the very first
// iteration. This saves a lot of code anytime you need to get only the very first node.
// Just be aware that you *cannot* use -firstNodeForXPath to recursively iterate an
// XML doc or node.
//
// For convenience, if the node is found, we also return a string representation of it
// so that you don't have to send it -stringValue after that if you want it as a string.
// If the node is not found, the string will be nil. We also return the error returned
// by -nodesForXPath:error: , if any.
/////////////////////////////////////////////////////////////////////////////////////////

- (NSXMLElement*)firstNodeForXPath:(NSString*)queryString
					fromXMLElement:(NSXMLElement*)element
					foundNodeStringValue:(NSString**)outString
					error:(NSError**)error
{
	NSArray				*elementsArray = nil;
	NSXMLElement		*tempNode = nil;
	NSXMLElement		*newNode = nil;
	NSString			*nodeStringValue = nil;
	NSError				*err = nil;
	
	if( queryString && element && outString && error )
	{
		// Get the array of elements matching queryString in the passed-in element...
				
		elementsArray = [ element nodesForXPath:queryString error:error ];
		if( elementsArray && ![ *error code ] )
		{
			// Check # array elements to avoid -objectAtIndex crash if array count == 0...
									
			if( [ elementsArray count ] > 0 )
			{
				// Get the first node in the array...
				
				tempNode = [ elementsArray objectAtIndex:0 ];
				if( tempNode )
				{
					nodeStringValue = [ tempNode stringValue ];
					if( nodeStringValue )
					{
						// Allocate a new element to return...
					
						newNode = [ [ [ NSXMLElement alloc ] initWithXMLString:nodeStringValue error:&err ] autorelease ];
						if( newNode && ![ err code ] )
						{
							// Allocate & get the node content as a string...
													
							*outString = [ [ NSString alloc ] initWithString:[ newNode stringValue ] ];
						}
					}
				}
			}
		}
	}
	
	return newNode;
}

@end