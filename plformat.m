/*
 * Copyright (c) 2013, Petroules Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

int main()
{
    NSArray *args = [[NSProcessInfo processInfo] arguments];
    if ([args count] < 2)
    {
        fprintf(stderr, "%s\n", "usage: plformat file");
        return 1;
    }

    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:[args objectAtIndex:1] options:0 error:&error];
    if (error)
    {
        fprintf(stderr, "%s\n", [[error localizedDescription] UTF8String]);
        [error release];
        return 1;
    }

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber10_7)
    {
        id plist = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (plist && !error)
        {
            printf("json\n");
            return 0;
        }

        [error release];
        error = nil;
    }
#endif

    NSPropertyListFormat format;
    id plist = [NSPropertyListSerialization propertyListWithData:data options:0 format:&format error:&error];

    if (error)
        fprintf(stderr, "%s\n", [[error localizedDescription] UTF8String]);

    if (error || !plist)
    {
        [error release];
        return 1;
    }

    switch (format)
    {
        case NSPropertyListOpenStepFormat:
            printf("openstep\n");
            break;
        case NSPropertyListXMLFormat_v1_0:
            printf("xml1\n");
            break;
        case NSPropertyListBinaryFormat_v1_0:
            printf("binary1\n");
            break;
        default:
            printf("unknown\n");
            return 1;
    }

    return 0;
}
