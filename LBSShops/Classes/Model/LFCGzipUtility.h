//
//  LFCGzipUtility.h
//  GooNuu
//
//  Created by xie yilong on 10-8-12.
//  Copyright 2010 xyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h"  

@interface LFCGzipUtility : NSObject {

}

/***************************************************************************//** 
#  Uses zlib to compress the given data. Note that gzip headers will be added so 
#  that the data can be easily decompressed using a tool like WinZip, gunzip, etc. 
#  
#  Note: Special thanks to Robbie Hanson of Deusty Designs for sharing sample code 
#  showing how deflateInit2() can be used to make zlib generate a compressed file 
#  with gzip headers: 
#  http://deusty.blogspot.com/2007/07/gzip-compressiondecompression.html 
#  
#  @param pUncompressedData memory buffer of bytes to compress 
#  @return Compressed data as an NSData object 
#  */  
+(NSData*) gzipData: (NSData*)pUncompressedData;  
+ (NSData *) uncompress: (NSData*) data;
+(NSData *)uncompressZippedData:(NSData *)compressedData;
+(NSData*)gzipDataTest: (NSData*)pUncompressedData;
@end
