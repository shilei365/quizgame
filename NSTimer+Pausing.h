//
//  NSTimer+Pausing.h
//  QuizGame
//
//  Created by apple on 13-9-13.
//  Copyright (c) 2013 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Pausing)

- (NSMutableDictionary *)pauseDictionary;
- (void)pause;
- (void)resume;

@end
