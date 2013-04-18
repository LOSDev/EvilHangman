//
//  MainViewController.h
//  Hang
//
//  Created by Rincewind on 23.12.12.
//  Copyright (c) 2012 Rincewind. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *alphabet;
@property (retain, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *guesses;

@property NSString *input;
@property int wordlength;
@property int numberOfPicks;
@property BOOL evilMode;
@property int maxlength;
@property NSString *partial;
@property NSString *noLettersGuessed;
@property NSMutableSet *set;

-(void) replaceLetter: (NSString *) letter;
-(void) initializeGame;
-(BOOL) changePartial:(NSString *)str;
-(void) initializeSettings;

@end
