//
//  LFCGzipUtility.m
//  GooNuu
//
//  Created by xie yilong on 10-8-12.
//  Copyright 2010 xyl. All rights reserved.
//

#import "LFCGzipUtility.h"


@implementation LFCGzipUtility
/******************************************************************************* 
 See header for documentation. 
 */  
+(NSData*) gzipData: (NSData*)pUncompressedData  
{  
	/* 
	 Special thanks to Robbie Hanson of Deusty Designs for sharing sample code 
	 showing how deflateInit2() can be used to make zlib generate a compressed 
	 file with gzip headers: 
	 http://deusty.blogspot.com/2007/07/gzip-compressiondecompression.html 
	 */  
	
	if (!pUncompressedData || [pUncompressedData length] == 0)  
	{  
		NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);  
		return nil;  
	}  
	
	/* Before we can begin compressing (aka "deflating") data using the zlib 
	 functions, we must initialize zlib. Normally this is done by calling the 
	 deflateInit() function; in this case, however, we'll use deflateInit2() so 
	 that the compressed data will have gzip headers. This will make it easy to 
	 decompress the data later using a tool like gunzip, WinZip, etc. 
	 
	 deflateInit2() accepts many parameters, the first of which is a C struct of 
	 type "z_stream" defined in zlib.h. The properties of this struct are used to 
	 control how the compression algorithms work. z_stream is also used to 
	 maintain pointers to the "input" and "output" byte buffers (next_in/out) as 
	 well as information about how many bytes have been processed, how many are 
	 left to process, etc. */  
	z_stream zlibStreamStruct;  
	zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so  
	zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be  
	zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.  
	zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far  
	zlibStreamStruct.next_in   = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes  
	zlibStreamStruct.avail_in  = [pUncompressedData length]; // Number of input bytes left to process  
	
	/* Initialize the zlib deflation (i.e. compression) internals with deflateInit2(). 
	 The parameters are as follows: 
	 
	 z_streamp strm - Pointer to a zstream struct 
	 int level      - Compression level. Must be Z_DEFAULT_COMPRESSION, or between 
	 0 and 9: 1 gives best speed, 9 gives best compression, 0 gives 
	 no compression. 
	 int method     - Compression method. Only method supported is "Z_DEFLATED". 
	 int windowBits - Base two logarithm of the maximum window size (the size of 
	 the history buffer). It should be in the range 8..15. Add 
	 16 to windowBits to write a simple gzip header and trailer 
	 around the compressed data instead of a zlib wrapper. The 
	 gzip header will have no file name, no extra data, no comment, 
	 no modification time (set to zero), no header crc, and the 
	 operating system will be set to 255 (unknown). 
	 int memLevel   - Amount of memory allocated for internal compression state. 
	 1 uses minimum memory but is slow and reduces compression 
	 ratio; 9 uses maximum memory for optimal speed. Default value 
	 is 8. 
	 int strategy   - Used to tune the compression algorithm. Use the value 
	 Z_DEFAULT_STRATEGY for normal data, Z_FILTERED for data 
	 produced by a filter (or predictor), or Z_HUFFMAN_ONLY to 
	 force Huffman encoding only (no string match) */  
	int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);  
	if (initError != Z_OK)  
	{  
		NSString *errorMsg = nil;  
		switch (initError)  
		{  
			case Z_STREAM_ERROR:  
				errorMsg = @"Invalid parameter passed in to function.";  
				break;  
			case Z_MEM_ERROR:  
				errorMsg = @"Insufficient memory.";  
				break;  
			case Z_VERSION_ERROR:  
				errorMsg = @"The version of zlib.h and the version of the library linked do not match.";  
				break;  
			default:  
				errorMsg = @"Unknown error code.";  
				break;  
		}  
		NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);  
		[errorMsg release];  
		return nil;  
	}  
	
	// Create output memory buffer for compressed data. The zlib documentation states that  
	// destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.  
	NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 12];  
	
	int deflateStatus;  
	do  
	{  
		// Store location where next byte should be put in next_out  
		zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;  
		
		// Calculate the amount of remaining free space in the output buffer  
		// by subtracting the number of bytes that have been written so far  
		// from the buffer's total capacity  
		zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;  
		
		/* deflate() compresses as much data as possible, and stops/returns when 
		 the input buffer becomes empty or the output buffer becomes full. If 
		 deflate() returns Z_OK, it means that there are more bytes left to 
		 compress in the input buffer but the output buffer is full; the output 
		 buffer should be expanded and deflate should be called again (i.e., the 
		 loop should continue to rune). If deflate() returns Z_STREAM_END, the 
		 end of the input stream was reached (i.e.g, all of the data has been 
		 compressed) and the loop should stop. */  
		deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);  
		
	} while ( deflateStatus == Z_OK );        
	
	// Check for zlib error and convert code to usable error message if appropriate  
	if (deflateStatus != Z_STREAM_END)  
	{  
		NSString *errorMsg = nil;  
		switch (deflateStatus)  
		{  
			case Z_ERRNO:  
				errorMsg = @"Error occured while reading file.";  
				break;  
			case Z_STREAM_ERROR:  
				errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";  
				break;  
			case Z_DATA_ERROR:  
				errorMsg = @"The deflate data was invalid or incomplete.";  
				break;  
			case Z_MEM_ERROR:  
				errorMsg = @"Memory could not be allocated for processing.";  
				break;  
			case Z_BUF_ERROR:  
				errorMsg = @"Ran out of output buffer for writing compressed bytes.";  
				break;  
			case Z_VERSION_ERROR:  
				errorMsg = @"The version of zlib.h and the version of the library linked do not match.";  
				break;  
			default:  
				errorMsg = @"Unknown error code.";  
				break;  
		}  
		NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);  
		[errorMsg release];  
		
		// Free data structures that were dynamically created for the stream.  
		deflateEnd(&zlibStreamStruct);  
		
		return nil;  
	}  
	// Free data structures that were dynamically created for the stream.  
	deflateEnd(&zlibStreamStruct);  
	[compressedData setLength: zlibStreamStruct.total_out];  
	NSLog(@"%s: Compressed file from %d KB to %d KB", __func__, [pUncompressedData length]/1024, [compressedData length]/1024);  
	
	return compressedData;  
}  


 /******************************************************************************* 
  See header for documentation. 
  */  
 +(NSData*)gzipDataTest: (NSData*)pUncompressedData  
 {  
     /* 
      Special thanks to Robbie Hanson of Deusty Designs for sharing sample code 
      showing how deflateInit2() can be used to make zlib generate a compressed 
      file with gzip headers: 
      http://deusty.blogspot.com/2007/07/gzip-compressiondecompression.html 
     */  
   
     if (!pUncompressedData || [pUncompressedData length] == 0)  
     {  
         NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);  
         return nil;  
     }  
   
     /* Before we can begin compressing (aka "deflating") data using the zlib 
      functions, we must initialize zlib. Normally this is done by calling the 
      deflateInit() function; in this case, however, we'll use deflateInit2() so 
      that the compressed data will have gzip headers. This will make it easy to 
      decompress the data later using a tool like gunzip, WinZip, etc. 
  
      deflateInit2() accepts many parameters, the first of which is a C struct of 
      type "z_stream" defined in zlib.h. The properties of this struct are used to 
      control how the compression algorithms work. z_stream is also used to 
      maintain pointers to the "input" and "output" byte buffers (next_in/out) as 
      well as information about how many bytes have been processed, how many are 
      left to process, etc. */  
     z_stream zlibStreamStruct;  
     zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so  
     zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be  
     zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.  
     zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far  
     zlibStreamStruct.next_in   = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes  
     zlibStreamStruct.avail_in  = [pUncompressedData length]; // Number of input bytes left to process  
   
     /* Initialize the zlib deflation (i.e. compression) internals with deflateInit2(). 
      The parameters are as follows: 
  
      z_streamp strm - Pointer to a zstream struct 
      int level      - Compression level. Must be Z_DEFAULT_COMPRESSION, or between 
                       0 and 9: 1 gives best speed, 9 gives best compression, 0 gives 
                       no compression. 
     int method     - Compression method. Only method supported is "Z_DEFLATED". 
      int windowBits - Base two logarithm of the maximum window size (the size of 
                       the history buffer). It should be in the range 8..15. Add 
                       16 to windowBits to write a simple gzip header and trailer 
                       around the compressed data instead of a zlib wrapper. The 
                       gzip header will have no file name, no extra data, no comment, 
                       no modification time (set to zero), no header crc, and the 
                       operating system will be set to 255 (unknown). 
      int memLevel   - Amount of memory allocated for internal compression state. 
                       1 uses minimum memory but is slow and reduces compression 
                       ratio; 9 uses maximum memory for optimal speed. Default value 
                       is 8. 
      int strategy   - Used to tune the compression algorithm. Use the value 
                       Z_DEFAULT_STRATEGY for normal data, Z_FILTERED for data 
                       produced by a filter (or predictor), or Z_HUFFMAN_ONLY to 
                       force Huffman encoding only (no string match) */  
     int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);  
     if (initError != Z_OK)  
	{  
         NSString *errorMsg = nil;  
         switch (initError)  
         {  
             case Z_STREAM_ERROR:  
                 errorMsg = @"Invalid parameter passed in to function.";  
                 break;  
             case Z_MEM_ERROR:  
                 errorMsg = @"Insufficient memory.";  
                 break;  
             case Z_VERSION_ERROR:  
                 errorMsg = @"The version of zlib.h and the version of the library linked do not match.";  
                 break;  
             default:  
                 errorMsg = @"Unknown error code.";  
                 break;  
         }  
         NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);  
         [errorMsg release];  
         return nil;  
     }  
   
     // Create output memory buffer for compressed data. The zlib documentation states that  
     // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.  
     NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 12];  
   
     int deflateStatus;  
     do  
     {  
         // Store location where next byte should be put in next_out  
         zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;  
  
         // Calculate the amount of remaining free space in the output buffer  
         // by subtracting the number of bytes that have been written so far  
         // from the buffer's total capacity  
         zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;  
   
         /* deflate() compresses as much data as possible, and stops/returns when 
          the input buffer becomes empty or the output buffer becomes full. If 
          deflate() returns Z_OK, it means that there are more bytes left to 
          compress in the input buffer but the output buffer is full; the output 
          buffer should be expanded and deflate should be called again (i.e., the 
          loop should continue to rune). If deflate() returns Z_STREAM_END, the 
          end of the input stream was reached (i.e.g, all of the data has been 
          compressed) and the loop should stop. */  
         deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);  
   
     } while ( deflateStatus == Z_OK );        
   
     // Check for zlib error and convert code to usable error message if appropriate  
     if (deflateStatus != Z_STREAM_END)  
     {  
         NSString *errorMsg = nil;  
         switch (deflateStatus)  
         {  
             case Z_ERRNO:  
                 errorMsg = @"Error occured while reading file.";  
                 break;  
             case Z_STREAM_ERROR:  
                 errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";  
                 break;  
             case Z_DATA_ERROR:  
                 errorMsg = @"The deflate data was invalid or incomplete.";  
                 break;  
             case Z_MEM_ERROR:  
                 errorMsg = @"Memory could not be allocated for processing.";  
                 break;  
             case Z_BUF_ERROR:  
                 errorMsg = @"Ran out of output buffer for writing compressed bytes.";  
                 break;  
             case Z_VERSION_ERROR:  
                 errorMsg = @"The version of zlib.h and the version of the library linked do not match.";  
                 break;  
             default:  
                 errorMsg = @"Unknown error code.";  
                 break;  
         }  
         NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);  
         [errorMsg release];  
   
         // Free data structures that were dynamically created for the stream.  
         deflateEnd(&zlibStreamStruct);  
   
         return nil;  
     }  
     // Free data structures that were dynamically created for the stream.  
     deflateEnd(&zlibStreamStruct);  
     [compressedData setLength: zlibStreamStruct.total_out];  
     NSLog(@"%s: Compressed file from %d KB to %d KB", __func__, [pUncompressedData length]/1024, [compressedData length]/1024);  
   
     return compressedData;  
 }  

//
+ (NSData *) uncompress: (NSData*) data
{
	if ([data length] == 0){
		return nil;
	}
	NSInteger length = [data length];
	unsigned full_length = length;
	unsigned half_length =length/ 2;
	
	NSMutableData *decompressed = [NSMutableData dataWithLength: 5*full_length + half_length];
	BOOL done = NO;
	int status;
	
	z_stream strm;
	length=length-4;
	void* bytes= malloc(length);
	NSRange range;
	range.location=4;
	range.length=length;
	[data getBytes: bytes range: range];
	strm.next_in = bytes;
	strm.avail_in = length;
	strm.total_out = 0;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.data_type= Z_BINARY;
	// if (inflateInit(&strm) != Z_OK) return nil;
	
	if (inflateInit2(&strm, (-15)) != Z_OK){
		return nil; //It won't work if change -15 to positive numbers.
	}
	while (!done)
	{
		// Make sure we have enough room and reset the lengths.
		if (strm.total_out >= [decompressed length])
			[decompressed increaseLengthBy: half_length];
		strm.next_out = [decompressed mutableBytes] + strm.total_out;
		strm.avail_out = [decompressed length] - strm.total_out;
		
		// Inflate another chunk.
		status = inflate (&strm, Z_SYNC_FLUSH); //Z_SYNC_FLUSH-->Z_BLOCK, won't work either 
		if (status == Z_STREAM_END){
			
			done = YES;
		}
		else if (status != Z_OK) break;
	}
	
	if (inflateEnd (&strm) != Z_OK) return nil;
	
	// Set real length.
	if (done)
	{
		[decompressed setLength: strm.total_out];
		return [NSData dataWithData: decompressed];
	}
	else {
		return nil;
	}
}


+(NSData *)uncompressZippedData:(NSData *)compressedData  {  
	
	if ([compressedData length] == 0) return compressedData;  
	
    unsigned full_length = [compressedData length];  
	
    unsigned half_length = [compressedData length] / 2;  
	
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];  
	
    BOOL done = NO;  
	
    int status;  
	
    z_stream strm;  
	
    strm.next_in = (Bytef *)[compressedData bytes];  
	
    strm.avail_in = [compressedData length];  
	
    strm.total_out = 0;  
	
    strm.zalloc = Z_NULL;  
	
    strm.zfree = Z_NULL;  
	
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;  
	
    while (!done) {  
        // Make sure we have enough room and reset the lengths.  
        if (strm.total_out >= [decompressed length]) {  
            [decompressed increaseLengthBy: half_length];  
        }  
        strm.next_out = [decompressed mutableBytes] + strm.total_out;  
        strm.avail_out = [decompressed length] - strm.total_out;  
        // Inflate another chunk.  
        status = inflate (&strm, Z_SYNC_FLUSH);  
        if (status == Z_STREAM_END) {  
            done = YES;  
        } else if (status != Z_OK) {  
            break;  
        }  
    }  
    if (inflateEnd (&strm) != Z_OK) return nil;  
    // Set real length.  
    if (done) {  
        [decompressed setLength: strm.total_out];  
        return [NSData dataWithData: decompressed];  
    } else {  
        return nil;  
    }  
}


#define CHUNK 16384

#pragma mark zlib  methods

-(NSData*) UnzipFileToData {
	NSMutableData* data = [[NSMutableData alloc] init];
	
	
	
	gzFile file = gzopen([@"sourcePath" UTF8String], "rb");
	FILE *dest = fopen([@"destPath" UTF8String], "w");
	
	unsigned char buffer[CHUNK];
	
	int uncompressedLength = gzread(file, buffer, CHUNK);
	
	if(fwrite(buffer, 1, uncompressedLength, dest) != uncompressedLength || ferror(dest)) {
		NSLog(@"error writing data");
	}
	
	fclose(dest);
	gzclose(file);
	
	/*
	 int ret = unzGoToFirstFile( _unzFile );
	 unsigned char		buffer[4096] = {0};
	 if( ret!=UNZ_OK )
	 {
	 [self OutputErrorMessage:@"Failed to go to first file"];
	 return data;
	 }
	 
	 ret = unzOpenCurrentFile( _unzFile );
	 if( ret!=UNZ_OK )
	 {
	 [self OutputErrorMessage:@"Error opening file"];
	 return data;
	 }
	 // reading data and write to data object
	 int read = 1 ;
	 while( read > 0 )
	 {
	 read=unzReadCurrentFile(_unzFile, buffer, 4096);
	 if( read > 0 )
	 {
	 [data appendBytes:buffer length:read];
	 }
	 else if( read<0 )
	 {
	 [self OutputErrorMessage:@"Failed to reading zip file"];
	 break;
	 }
	 else 
	 break;				
	 }
	 unzCloseCurrentFile( _unzFile );
	 ret = unzGoToNextFile( _unzFile );
	 */
	return data;
}


/*
//
- (NSData *)zlibInflate:(NSData *)data
{
	if ([self length] == 0) return nil;
	
	unsigned full_length = [data length];
	unsigned half_length = [data length] / 2;
	
	NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
	BOOL done = NO;
	int status;
	
	z_stream strm;
	strm.next_in = (Bytef *)[self bytes];
	strm.avail_in = [data length];
	strm.total_out = 0;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	
	if (inflateInit (&strm) != Z_OK) return nil;
	
	while (!done)
	{
		// Make sure we have enough room and reset the lengths.
		if (strm.total_out >= [decompressed length])
			[decompressed increaseLengthBy: half_length];
		strm.next_out = [decompressed mutableBytes] + strm.total_out;
		strm.avail_out = [decompressed length] - strm.total_out;
		
		// Inflate another chunk.
		status = inflate (&strm, Z_SYNC_FLUSH);
		if (status == Z_STREAM_END) done = YES;
		else if (status != Z_OK) break;
	}
	if (inflateEnd (&strm) != Z_OK) return nil;
	
	// Set real length.
	if (done)
	{
		[decompressed setLength: strm.total_out];
		return [NSData dataWithData: decompressed];
	}
	else return nil;
}

- (NSData *)zlibDeflate:(NSData *)data
{
	if ([data length] == 0) return nil;
	
	z_stream strm;
	
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	strm.total_out = 0;
	strm.next_in=(Bytef *)[data bytes];
	strm.avail_in = [data length];
	
	// Compresssion Levels:
	//   Z_NO_COMPRESSION
	//   Z_BEST_SPEED
	//   Z_BEST_COMPRESSION
	//   Z_DEFAULT_COMPRESSION
	
	if (deflateInit(&strm, Z_DEFAULT_COMPRESSION) != Z_OK) return nil;
	
	NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chuncks for expansion
	
	do {
		
		if (strm.total_out >= [compressed length])
			[compressed increaseLengthBy: 16384];
		
		strm.next_out = [compressed mutableBytes] + strm.total_out;
		strm.avail_out = [compressed length] - strm.total_out;
		
		deflate(&strm, Z_FINISH);  
		
	} while (strm.avail_out == 0);
	
	deflateEnd(&strm);
	
	[compressed setLength: strm.total_out];
	return [NSData dataWithData: compressed];
}

- (NSData *)gzipInflate:(NSData *)data
{
	if ([data length] == 0){
		return self;
	}
	
	unsigned full_length = [data length];
	unsigned half_length = [data length] / 2;
	
	NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
	BOOL done = NO;
	int status;
	
	z_stream strm;
	strm.next_in = (Bytef *)[self bytes];
	strm.avail_in = [self length];
	strm.total_out = 0;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	
	if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
	while (!done)
	{
		// Make sure we have enough room and reset the lengths.
		if (strm.total_out >= [decompressed length])
			[decompressed increaseLengthBy: half_length];
		strm.next_out = [decompressed mutableBytes] + strm.total_out;
		strm.avail_out = [decompressed length] - strm.total_out;
		
		// Inflate another chunk.
		status = inflate (&strm, Z_SYNC_FLUSH);
		if (status == Z_STREAM_END) done = YES;
		else if (status != Z_OK) break;
	}
	if (inflateEnd (&strm) != Z_OK) return nil;
	
	// Set real length.
	if (done)
	{
		[decompressed setLength: strm.total_out];
		return [NSData dataWithData: decompressed];
	}
	else return nil;
}

- (NSData *)gzipDeflate
{
	if ([self length] == 0) return self;
	
	z_stream strm;
	
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	strm.total_out = 0;
	strm.next_in=(Bytef *)[self bytes];
	strm.avail_in = [self length];
	
	// Compresssion Levels:
	//   Z_NO_COMPRESSION
	//   Z_BEST_SPEED
	//   Z_BEST_COMPRESSION
	//   Z_DEFAULT_COMPRESSION
	
	if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
	
	NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
	
	do {
		
		if (strm.total_out >= [compressed length])
			[compressed increaseLengthBy: 16384];
		
		strm.next_out = [compressed mutableBytes] + strm.total_out;
		strm.avail_out = [compressed length] - strm.total_out;
		
		deflate(&strm, Z_FINISH);  
		
	} while (strm.avail_out == 0);
	
	deflateEnd(&strm);
	
	[compressed setLength: strm.total_out];
	return [NSData dataWithData:compressed];
}
*/

@end
