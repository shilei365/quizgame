//
//  NSDictionary+json.m
//  10yan
//
//  Created by apple on 12-10-22.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "NSDictionary+json.h"
#import "JSONKit.h"

@implementation NSDictionary (json)

// transfer JSON data of remote address to a Dictionary object
+(NSDictionary*)dictionaryWithContentsOfURLString:(NSString*)urlAddress
{
    // request remote data and push into NSData
    NSData* data =[NSData dataWithContentsOfURL:[NSURL URLWithString: urlAddress]];
    
    // define an error message
    __autoreleasing NSError *error =nil;
    
    Class jsonSerializationClass = NSClassFromString(@"NSJSONSerialization");
    if (!jsonSerializationClass) {
        //iOS < 5 didn't have the JSON serialization class
        return [data objectFromJSONData]; //JSONKit
        //return nil;
    }
    else {
        // string serializing
        id result =[NSJSONSerialization JSONObjectWithData:data
                                               options:kNilOptions error:&error];
        if(error !=nil)
        return nil;    
        return result;
    }
}



// transfer a Dictionary object to Json data
-(NSData*)toJSON{
    NSError *error =nil;
    // transfer Dictionary to string
    id result =[NSJSONSerialization dataWithJSONObject:self
                                               options:kNilOptions error:&error];
    if(error !=nil)
        return nil;
    
    return result;
}

@end
