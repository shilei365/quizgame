//
//  PlayViewController.h
//  QuizGame
//
//  Created by lei on 13.09.13.
//  Copyright (c) 2013 Lei Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTimer+Pausing.h"

@interface PlayViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate> {
    
    NSDictionary *questionDict;
    NSMutableArray *questionArray;
    NSMutableArray *answerArray;
    int page; //question number 
    int sum;  // got the sum of money
    int money; // money level, 1 = $50, ..., 15= $1,000,000
    
    //three jokers
    BOOL isRemoveAnswer;
    BOOL isPhoneHelp;
    BOOL isAskPeople;
    
    NSTimer *countdownTimer;
    int secondsCount;
}

@property(nonatomic,retain)NSDictionary *questionDict;
@property(nonatomic,retain)NSMutableArray *questionArray;
@property(nonatomic,retain)NSMutableArray *answerArray;
@property(nonatomic)BOOL isRemoveAnswer;
@property(nonatomic)BOOL isPhoneHelp;
@property(nonatomic)BOOL isAskPeople;


@end
