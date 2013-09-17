//
//  ReadyViewController.m
//  QuizGame
//
//  Created by lei on 13.09.13.
//  Copyright (c) 2013 Lei Shi. All rights reserved.
//

#import "ReadyViewController.h"

@interface ReadyViewController ()
@property (strong, nonatomic) IBOutlet UITextField *user;

- (IBAction)play:(id)sender;

@end

@implementation ReadyViewController

extern NSString *USERNAME;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

- (IBAction)play:(id)sender {
    NSLog(@"startGame");
    USERNAME = self.user.text;
    NSLog(@"user name: %@", USERNAME);
}
@end
