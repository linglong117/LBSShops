/*
 *  DebugMode.h
 *  GtFund
 *
 *  Created by xie yilong on 10-9-1.
 *  Copyright 2010 xyl. All rights reserved.
 *
 */

//! 1、XCode 中设置控制
// Target > Get Info > Build > GCC_PREPROCESSOR_DEFINITIONS
// Configuration = Release: <empty>
//               = Debug:   DEBUG_MODE=1
//！2、人为控制
//#define DEBUG_MODE
#ifdef DEBUG_MODE
#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... )
#endif