#import <unistd.h>

#import "maUtilsProcess.h"

@implementation maUtilsProcess

#pragma mark -------------
#pragma mark Init & Term
#pragma mark -------------

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
// - dealloc
////////////////////

- (void)dealloc
{
	[ super dealloc ];
}

//////////////////////
// Get process list.
//////////////////////

- (int)GetBSDProcessList:(struct kinfo_proc**)procList withCount:(size_t*)procCount
{
	int	result = 0;
	
	result = GetBSDProcessList( procList, procCount );
	
	return result;
}

@end