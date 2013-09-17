//
//  NSDictionary+json.h
//  10yan
//
//  Created by apple on 12-10-22.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (json)
// transfer JSON data of remote address to a Dictionary object
+(NSDictionary*)dictionaryWithContentsOfURLString:(NSString*)urlAddress;

// transfer a Dictionary object to Json data
-(NSData*)toJSON;
@end
