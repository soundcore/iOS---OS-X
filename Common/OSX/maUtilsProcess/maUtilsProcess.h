#include <assert.h>
#include <errno.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/sysctl.h>

/////////////
// Defines
/////////////

/////////////
// Protos
/////////////

#ifndef __OBJC__
	#ifdef __cplusplus
	extern "C" {
	#endif
#endif

	int			GetBSDProcessList( struct kinfo_proc **procList, size_t *procCount );
	
#ifndef __OBJC__
	#ifdef __cplusplus
	}
	#endif
#endif

#ifdef __OBJC__

	///////////
	// Classes
	///////////

	@interface maUtilsProcess : NSObject
	{
	}
	
	// Init & term

	- (id)init;

	- (void)dealloc;
	
	// General process utils
	
	- (int)GetBSDProcessList:(struct kinfo_proc**)procList withCount:(size_t*)procCount;
	
	@end

#endif