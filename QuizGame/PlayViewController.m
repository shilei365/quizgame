//
//  PlayViewController.m
//  QuizGame
//
//  Created by lei on 13.09.13.
//  Copyright (c) 2013 Lei Shi. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;

@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn4;

@property (strong, nonatomic) IBOutlet UILabel *moneyLabel0;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel1;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel2;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel3;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel4;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel5;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel6;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel7;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel8;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel9;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel10;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel11;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel12;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel13;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel14;

- (IBAction)answer1:(id)sender;
- (IBAction)answer2:(id)sender;
- (IBAction)answer3:(id)sender;
- (IBAction)answer4:(id)sender;
- (IBAction)clickJoker:(id)sender;

@end

@implementation PlayViewController

@synthesize questionDict,questionArray,answerArray;
@synthesize isRemoveAnswer,isAskPeople,isPhoneHelp;

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
	
    NSLog(@"game");
    //init
    isRemoveAnswer = TRUE;
    isPhoneHelp = TRUE;
    isAskPeople = TRUE;
    page = 0;
    sum = 0;
    money = 0;
    
    self.questionDict = [[NSDictionary alloc]initWithObjectsAndKeys:nil];
    self.questionArray = [NSMutableArray arrayWithObjects:nil];
    self.answerArray = [NSMutableArray arrayWithObjects:nil];
    
    [self openFileToDict];
    
    // load questions and answers
    self.questionArray= [self.questionDict valueForKey:@"questions"];
    self.questionLabel.text = [[self.questionArray objectAtIndex:page] valueForKey:@"text"];
    self.questionLabel.numberOfLines = 0;  // newline
    self.answerArray=[[self.questionArray objectAtIndex:page] valueForKey:@"answers"];
    
    [self.btn1 setTitle:[self.answerArray objectAtIndex:0] forState:UIControlStateNormal];
    [self.btn2 setTitle:[self.answerArray objectAtIndex:1] forState:UIControlStateNormal];
    [self.btn3 setTitle:[self.answerArray objectAtIndex:2] forState:UIControlStateNormal];
    [self.btn4 setTitle:[self.answerArray objectAtIndex:3] forState:UIControlStateNormal];
   
    
    [self setTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Countdown timer
- (void)setTimer {
    secondsCount = 60;
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
}

- (void)timerRun {
    secondsCount = secondsCount -1;
    NSString *timerOutput = [NSString stringWithFormat:@"%2d", secondsCount];
    self.countdownLabel.text = timerOutput;
    if (secondsCount == 0) {
        [countdownTimer invalidate];
        countdownTimer = nil;
        if (money < 5) sum = 0;
        if (money >5 && money <9 ) sum = 500;
        if (money >9 && money < 15) sum = 16000;
        [self gameOver];
    }
}

// handle JSON data; parse json to Dict object
-(void)openFileToDict {
    NSString *fullPath = [NSBundle pathForResource:@"questions" ofType:@"json" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSString* html = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    NSData* jsonData =[html dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil){
        // NSLog(@"Successfully deserialized...");
        if ([jsonObject isKindOfClass:[NSDictionary class]]){
            self.questionDict = (NSDictionary *)jsonObject;
            // NSLog(@"Dersialized JSON Dictionary = %@", self.questionDict);
        } else if ([jsonObject isKindOfClass:[NSArray class]]){
            NSArray *deserializedArray = (NSArray *)jsonObject;
            // NSLog(@"Dersialized JSON Array = %@", deserializedArray);
        } else {
            NSLog(@"An error happened while deserializing the JSON data.");
        }
    }
    // NSLog(@"Successfully deserialized OK!");
}

// define the button action
- (IBAction)answer1:(id)sender {
    [self submitAnswer:self.btn1];
}

- (IBAction)answer2:(id)sender {
    [self submitAnswer:self.btn2];
}

- (IBAction)answer3:(id)sender {
    [self submitAnswer:self.btn3];
}

- (IBAction)answer4:(id)sender {
    [self submitAnswer:self.btn4];
}


// click the Jokers button
- (IBAction)clickJoker:(id)sender {
    [countdownTimer pause];
    UIActionSheet *acView=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"Fifty fifty"
                                            otherButtonTitles:@"Phone a friend",@"Ask the audience", nil];
    //acView.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [acView showInView:self.view];
}

//submit the answer
-(void)submitAnswer:(UIButton *)button {
    int index  =button.tag - 10;
    //NSLog(@"%d",button.tag);
    NSString *success= [NSString stringWithFormat:@"%d",index];
    NSString *answerOK = [[self.questionArray objectAtIndex:page] valueForKey:@"solution"];
    answerOK = [NSString stringWithFormat:@"%@",answerOK];
    if([success compare:answerOK] == NSOrderedSame) {
        [countdownTimer pause];
        if(page == 14) {
            sum = 1000000;
            self.moneyLabel13.backgroundColor = [UIColor clearColor];
            self.moneyLabel14.backgroundColor = [UIColor yellowColor];
            [self showMessage:@"You win! You got $1,000,000!"];
        }
        else {
            //calculate money
            money = money+1;
            switch (money) {
                case 0:
                    break;
                case 1:
                    sum = 50;
                    self.moneyLabel0.backgroundColor = [UIColor yellowColor];
                    break;
                case 2:
                    sum = 100;
                    self.moneyLabel0.backgroundColor = [UIColor clearColor];
                    self.moneyLabel1.backgroundColor = [UIColor yellowColor];
                    break;
                case 3:
                    sum = 200;
                    self.moneyLabel1.backgroundColor = [UIColor clearColor];
                    self.moneyLabel2.backgroundColor = [UIColor yellowColor];
                    break;
                case 4:
                    sum = 300;
                    self.moneyLabel2.backgroundColor = [UIColor clearColor];
                    self.moneyLabel3.backgroundColor = [UIColor yellowColor];
                    break;
                case 5:
                    sum = 500;
                    self.moneyLabel3.backgroundColor = [UIColor clearColor];
                    self.moneyLabel4.backgroundColor = [UIColor yellowColor];
                    break;
                case 6:
                    sum = 1000;
                    self.moneyLabel4.backgroundColor = [UIColor clearColor];
                    self.moneyLabel5.backgroundColor = [UIColor yellowColor];
                    break;
                case 7:
                    sum = 2000;
                    self.moneyLabel5.backgroundColor = [UIColor clearColor];
                    self.moneyLabel6.backgroundColor = [UIColor yellowColor];
                    break;
                case 8:
                    sum = 4000;
                    self.moneyLabel6.backgroundColor = [UIColor clearColor];
                    self.moneyLabel7.backgroundColor = [UIColor yellowColor];
                    break;
                case 9:
                    sum = 8000;
                    self.moneyLabel7.backgroundColor = [UIColor clearColor];
                    self.moneyLabel8.backgroundColor = [UIColor yellowColor];
                    break;
                case 10:
                    sum = 16000;
                    self.moneyLabel8.backgroundColor = [UIColor clearColor];
                    self.moneyLabel9.backgroundColor = [UIColor yellowColor];
                    break;
                case 11:
                    sum = 32000;
                    self.moneyLabel9.backgroundColor = [UIColor clearColor];
                    self.moneyLabel10.backgroundColor = [UIColor yellowColor];
                    break;
                case 12:
                    sum = 64000;
                    self.moneyLabel10.backgroundColor = [UIColor clearColor];
                    self.moneyLabel11.backgroundColor = [UIColor yellowColor];
                    break;
                case 13:
                    sum = 125000;
                    self.moneyLabel11.backgroundColor = [UIColor clearColor];
                    self.moneyLabel12.backgroundColor = [UIColor yellowColor];
                    break;
                case 14:
                    sum = 500000;
                    self.moneyLabel12.backgroundColor = [UIColor clearColor];
                    self.moneyLabel13.backgroundColor = [UIColor yellowColor];
                    break;
               // case 15:
                  //  sum = 1000000;
                 //   self.moneyLabel13.backgroundColor = [UIColor clearColor];
                   // self.moneyLabel14.backgroundColor = [UIColor yellowColor];
                   // break;
                default:
                    break;
            }
            
            UIAlertView *alert;
            alert= [[UIAlertView alloc] initWithTitle:@"Congratulation!" message:@"Next question?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No, give up", nil];
            [alert show];
        }
    }
    else {
        if (money < 5) sum = 0;
        if (money >5 && money <9 ) sum = 500;
        if (money >9 && money < 15) sum = 16000;
        [self gameOver];
    }
}

// reset question and answers
-(void)resetAnswer:(int)p {
    self.answerArray=[[self.questionArray objectAtIndex:p] valueForKey:@"answers"];
    self.questionLabel.text = [[self.questionArray objectAtIndex:p] valueForKey:@"text"];
    self.questionLabel.numberOfLines = 0;
    self.btn1.hidden = NO;
    self.btn2.hidden = NO;
    self.btn3.hidden = NO;
    self.btn4.hidden = NO;
    [self.btn1 setTitle:[self.answerArray objectAtIndex:0] forState:UIControlStateNormal];
    [self.btn2 setTitle:[self.answerArray objectAtIndex:1] forState:UIControlStateNormal];
    [self.btn3 setTitle:[self.answerArray objectAtIndex:2] forState:UIControlStateNormal];
    [self.btn4 setTitle:[self.answerArray objectAtIndex:3] forState:UIControlStateNormal];
    [self setTimer];
}

// game over
-(void)gameOver {
    [countdownTimer invalidate];
    
    UIView *alertView=[[UIView alloc]init];
    alertView.frame = CGRectMake(20, 80, 280, 300);
    alertView.backgroundColor = [UIColor grayColor];
    alertView.tag = 999;
    //alertView.alpha = 0.8;
    UILabel *labelTitle=[[UILabel alloc]init];
    NSString *name=[NSString stringWithFormat:@"Game over!"];
    labelTitle.text=name;
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.contentMode = UIControlContentVerticalAlignmentCenter;
    labelTitle.frame = CGRectMake(10, 10, 260, 30);
    [alertView addSubview:labelTitle];
    
    UILabel *labelText=[[UILabel alloc]init];
    NSString *str=[NSString stringWithFormat:@"%@, you got $%d!",USERNAME,sum];
    labelText.text=str;
    labelText.backgroundColor = [UIColor clearColor];
    labelText.textColor = [UIColor whiteColor];
    labelText.contentMode = UIControlContentVerticalAlignmentCenter;
    labelText.frame = CGRectMake(10, 50, 260, 30);
    [alertView addSubview:labelText];
    
    UIButton *resetBtn = [[UIButton alloc]init];
    resetBtn.userInteractionEnabled = YES;
    [resetBtn setTitle:@"New start" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(restartGame:) forControlEvents:UIControlEventTouchUpInside];
    resetBtn.frame = CGRectMake(80, 160, 120, 40);
    [resetBtn setBackgroundColor:[UIColor whiteColor]];
    [alertView addSubview:resetBtn];
    
    [self.view addSubview:alertView];
}


//restart game
-(void)restartGame:(UIButton *)button {
    isRemoveAnswer = TRUE;
    isPhoneHelp = TRUE;
    isAskPeople = TRUE;
    page = 0;
    sum = 0;
    money = 0;
    
    self.moneyLabel0.backgroundColor = [UIColor clearColor];
    self.moneyLabel1.backgroundColor = [UIColor clearColor];
    self.moneyLabel2.backgroundColor = [UIColor clearColor];
    self.moneyLabel3.backgroundColor = [UIColor clearColor];
    self.moneyLabel4.backgroundColor = [UIColor clearColor];
    self.moneyLabel5.backgroundColor = [UIColor clearColor];
    self.moneyLabel6.backgroundColor = [UIColor clearColor];
    self.moneyLabel7.backgroundColor = [UIColor clearColor];
    self.moneyLabel8.backgroundColor = [UIColor clearColor];
    self.moneyLabel9.backgroundColor = [UIColor clearColor];
    self.moneyLabel10.backgroundColor = [UIColor clearColor];
    self.moneyLabel11.backgroundColor = [UIColor clearColor];
    self.moneyLabel12.backgroundColor = [UIColor clearColor];
    self.moneyLabel13.backgroundColor = [UIColor clearColor];
    self.moneyLabel14.backgroundColor = [UIColor clearColor];
    
    self.answerArray=[[self.questionArray objectAtIndex:page] valueForKey:@"answers"];
    self.questionLabel.text = [[self.questionArray objectAtIndex:page] valueForKey:@"text"];
    self.btn1.hidden = NO;
    self.btn2.hidden = NO;
    self.btn3.hidden = NO;
    self.btn4.hidden = NO;
    [self.btn1 setTitle:[self.answerArray objectAtIndex:0] forState:UIControlStateNormal];
    [self.btn2 setTitle:[self.answerArray objectAtIndex:1] forState:UIControlStateNormal];
    [self.btn3 setTitle:[self.answerArray objectAtIndex:2] forState:UIControlStateNormal];
    [self.btn4 setTitle:[self.answerArray objectAtIndex:3] forState:UIControlStateNormal];
    UIView *view=(UIView *)[self.view viewWithTag:999];
    [view removeFromSuperview];
    [self resetAnswer:page];
}


// jokers sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 3) {//cancel button
        [countdownTimer resume];
        return;
    }

    if(buttonIndex == 0) {   // fifty-fifty
        if(!isRemoveAnswer) { // this joker is available?
            [self showMessage:@"This joker has been used!"];
            return;
        }
        // delete two false answers
        UIView *btn;
        NSString *suc = [[self.questionArray objectAtIndex:page] valueForKey:@"solution"];
        int ok = [suc intValue];
        if(ok >=2) {
            btn=(UIView *)[self.view viewWithTag:10];
            btn.hidden = YES;
            btn=(UIView *)[self.view viewWithTag:11];
            btn.hidden = YES;
        }
        else {
            btn=(UIView *)[self.view viewWithTag:12];
            btn.hidden = YES;
            btn=(UIView *)[self.view viewWithTag:13];
            btn.hidden = YES;
        }
        isRemoveAnswer = FALSE;
        [countdownTimer resume];
    }
    else if (buttonIndex == 1) {  //phone help
        if(!isPhoneHelp) { // this joker is available?
            [self showMessage:@"This joker has been used!"];
            return;
        }
        else { // prompt a new view to call a phone number
            UIView *alertView=[[UIView alloc]init];
            alertView.frame = CGRectMake(20, 50, 280, 250);
            alertView.backgroundColor = [UIColor grayColor];
            alertView.tag = 998;
            
            UILabel *labelTitle=[[UILabel alloc]init];
            labelTitle.text=@"Phone Nr.:";
            labelTitle.backgroundColor = [UIColor clearColor];
            labelTitle.contentMode = UIControlContentVerticalAlignmentCenter;
            labelTitle.frame = CGRectMake(10, 10, 85, 30);
            [alertView addSubview:labelTitle];
            
            UITextField *phoneText = [[UITextField alloc]init];
            phoneText.frame = CGRectMake(100, 10, 150, 30);
            phoneText.backgroundColor = [UIColor whiteColor];
            phoneText.borderStyle= UITextBorderStyleLine;
            phoneText.adjustsFontSizeToFitWidth = YES;
            phoneText.keyboardAppearance = UIKeyboardTypeNumberPad;
            phoneText.delegate = self;
            phoneText.tag = 997;
            [alertView addSubview:phoneText];
            
            UIButton *callPhone = [[UIButton alloc]init];
            callPhone.userInteractionEnabled = YES;
            [callPhone setTitle:@"Call" forState:UIControlStateNormal];
            [callPhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [callPhone addTarget:self action:@selector(callMobile:) forControlEvents:UIControlEventTouchUpInside];
            callPhone.frame = CGRectMake(30, 80, 100, 30);
            [callPhone setBackgroundColor:[UIColor whiteColor]];
            [alertView addSubview:callPhone];
            
            UIButton *cancelBtn = [[UIButton alloc]init];
            cancelBtn.userInteractionEnabled = YES;
            [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(closePhoneWindow:) forControlEvents:UIControlEventTouchUpInside];
            cancelBtn.frame = CGRectMake(160, 80, 100, 30);
            [cancelBtn setBackgroundColor:[UIColor whiteColor]];
            [alertView addSubview:cancelBtn];
            
            [self.view addSubview:alertView];
        }
    }
    else if (buttonIndex == 2) {  //ask the audience
        [self showMessage:@"sorry, this joker do not exist now!"]; //TODO: ask the audience
    }
    
}

//call a phone number
-(void)callMobile:(UIButton *)button {
    isPhoneHelp = FALSE;
    UILabel *mobile = (UILabel *)[self.view viewWithTag:997];
    NSString *phone = mobile.text;
    phone = [NSString stringWithFormat:@"telprompt://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

//close the phone window
-(void)closePhoneWindow:(UIButton *)button {
    UIView *view=(UIView *)[self.view viewWithTag:998];
    [view removeFromSuperview];
    [countdownTimer resume];
}

//prompt a message
-(void)showMessage:(NSString *)message {
    UIAlertView *alert;
    alert= [[UIAlertView alloc] initWithTitle:@"Tip:" message:message delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles: nil];
    if (money == 14) alert.tag = 990; // when player got 1 million
    if (money < 14 ) alert.tag = 991; // for jokers
    [alert show];
}

// alert action
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag ==991) {
        [countdownTimer resume];
        return;
    }
    if (alertView.tag == 990) {
        if (buttonIndex == 0) {
            //restart game
            [self performSegueWithIdentifier:@"backMenu" sender:nil];
            return;
        }
    }
    
    if(buttonIndex ==0) { // next question
        page = page + 1;
        [self resetAnswer:page];
    }
    else { // give up with the money
        [self gameOver];
    }
}

// close the keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return  YES;
}

@end
