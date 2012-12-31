/*****************************************************************************

File:			cbUtilsXML.h

Date:			2/17/10

Version:		8.2

Authors:		soundcore

				Copyright 2008 soundcore
				All rights reserved worldwide.

Notes:			Header for cbUtilsXML.m

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

Dependencies:	XCode 4.3 as of this writing, MoreFilesX,
				System Configuration Framework.

Changes:		2/17/10 MCA Initial version.

******************************************************************************/

/////////////////////
// Classes
/////////////////////

@interface cbUtilsXML : NSObject
{
    // No properties
}

// Overides

- (id)init;

- (void)dealloc;

// NSXMLElement utils

- (NSXMLElement*)elementForName:(NSString*)name fromElement:(NSXMLElement*)parent;

- (NSXMLNode*)nodeForName:(NSString*)name fromElement:(NSXMLElement*)parent;

- (NSXMLDocument*)docInBundleForFileName:(NSString*)name andExtension:(NSString*)extension;

- (void)dumpData:(void*)data ofLength:(unsigned long)len asXMLFile:(NSString*)path;

// .NET Mimickers

- (NSXMLElement*)firstNodeForXPath:(NSString*)queryString fromXMLElement:(NSXMLElement*)element foundNodeStringValue:(NSString**)outString error:(NSError**)error;

@end