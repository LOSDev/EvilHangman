//
//  MainViewController.m
//  Hangman
//
//  Created by Rincewind on 23.12.12.
//  Copyright (c) 2012 Rincewind. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()



- (IBAction)closeKeyboard:(id)sender;
- (IBAction)newGame:(id)sender;


@end

@implementation MainViewController
@synthesize alphabet;
@synthesize inputField;
@synthesize label1;
@synthesize guesses;
@synthesize input;
@synthesize wordlength;
@synthesize maxlength;
@synthesize partial;
@synthesize numberOfPicks;
@synthesize noLettersGuessed;
@synthesize set;
@synthesize evilMode;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	
    [self initializeGame];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        
        //set the maximum Word length for the Slider
        [segue.destinationViewController setMaxWLValue:maxlength];
        [[segue destinationViewController] setDelegate:self];
    }
}


-(void) initializeGame{
    [self initializeSettings];
    
    partial=@"";
    noLettersGuessed=@"";
    
    //show blanks for every letter of the word
    for(int i=0;i<wordlength;i++) {
        partial = [partial stringByAppendingString:@"-"];
    }
    self.label1.text =partial;
    
    for(int i=0;i<wordlength;i++) noLettersGuessed = [noLettersGuessed stringByAppendingString:@"_"];
    NSString *numberGuesses = [NSString stringWithFormat:@"Guesses Left: %d",numberOfPicks];
    [guesses setText:numberGuesses];
    
    set = [NSMutableSet set];
    
    // Path to the dictionary plist (in the application bundle)
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"words" ofType:@"plist"];
    
    // Build an array from a plist
    NSMutableArray *dictionary = [[NSMutableArray alloc] initWithContentsOfFile:path];
   
    // put words with correct length in an array
    maxlength=0;
    for (NSString *str in dictionary){
        int strlength = [str length];
        
        //Find the longest word for the settings
        if (strlength>maxlength) maxlength=strlength;
        
        //Put the words with the correct length in an NSSet
        if ([str length]==wordlength) {
            [set addObject:str];
        }
     }
    
}

//checking and processing the user input
- (IBAction)closeKeyboard:(id)sender {
   
    self.input = [self.inputField.text capitalizedString];
    
    [inputField setText:@""];
       
    [self.inputField resignFirstResponder];
    //check if entered text is only 1 character
    if ([self.input length]==1) {
        //check if character is one that hasn't already be chosen
        if ([self.alphabet.text rangeOfString:self.input].location == NSNotFound){
            [self showMessage: @"Please Enter a valid letter that you have not entered before." withTitle: @"Error"];
            
        }else{
            [self replaceLetter: self.input];
            if(evilMode)
                [self createDictionary:(self.input)];
            else
                [self normalMode];
        }
    }else {
        [self showMessage: @"Please Enter exactly one letter." withTitle: @"Error"];
    }
    
}

//called when the "new Game" Button is pressed
- (IBAction)newGame:(id)sender {
    [alphabet setText:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    [self initializeGame];
}


//replacing the chosen letter in the Alphabet-Label
-(void) replaceLetter:(NSString *) letter{
    NSString *alpha = [self.alphabet.text stringByReplacingOccurrencesOfString:letter  withString:@" "];
    self.alphabet.text =alpha;
}

//show a message and title in an UIAlertDialog
- (void) showMessage:(NSString *)message withTitle:(NSString *)title{
    
    UIAlertView *ms = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [ms show];
}


//searching the NSSet for words containing the selected Character
-(void) createDictionary: (NSString *) inputchar{
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (NSString *str in set){
        //result is the equivalence Class String
        NSString *result=@"";
        int strlen=[str length];
        //search for the letter in every word in the set
        NSRange textRange =[str rangeOfString:inputchar];
        
        if(textRange.location != NSNotFound){
            //creating the equivalence Class String
            for (int i=0; i < strlen; i++) {
                NSString *ichar  = [NSString stringWithFormat:@"%c", [str characterAtIndex:i]];
                if ([ichar isEqualToString:inputchar]) {
                    result=[result stringByAppendingString:ichar];
                }else{
                    result=[result stringByAppendingString:@"_"];
                }
            }
        }else result = [NSMutableString stringWithString: noLettersGuessed];
        
        //take the equivalence class String and put the word in the appropriate Dictionary bucket
        NSMutableSet *eClass = [dict objectForKey:result];
        if(eClass){
            [eClass addObject:str];
        }else{
            eClass = [NSMutableSet set];
            [eClass addObject:str];            
        }
        
        [dict setObject:eClass forKey:result];
    }
    
    //find biggest set in Dictionary
    int maxleng=0;
    NSString *longestWordList=@"";
    for (NSString *key in dict) {
        NSMutableSet *object1 = [dict objectForKey:key];
        int leng = [object1 count];
        if (leng>maxleng) {
            maxleng=leng;
            longestWordList=key;
        }
    }
    //take the key of the largest Array and update the set
    NSMutableSet *newSet = [dict objectForKey:longestWordList];
    
    set = [NSSet setWithSet:newSet];
    
    //show the number of words in the set
    NSLog(@"%d",[set count]);
    
    //update Display and GameState
    BOOL found = [self changePartial:longestWordList];
    if (!found) numberOfPicks--;
    NSString *numberGuesses = [NSString stringWithFormat:@"Guesses Left: %d",numberOfPicks];
    [guesses setText:numberGuesses];
    
    //check if Game was won or lost
    [self checkWin];
    
    
}

//The guessed letter is shown to the user
-(BOOL) changePartial:(NSString *)str{
    BOOL letterFound=NO;
    for (int i=0; i < [str length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [str characterAtIndex:i]];
        if ([ichar isEqualToString:@"_"]) {
            
        }else{
            NSRange range = NSMakeRange(i,1);
            partial = [partial stringByReplacingCharactersInRange:range withString:ichar];
            letterFound=YES;
        }
    }
    [label1 setText:partial];
    return letterFound;
}

//
-(void) initializeSettings{
    // set default values
    NSMutableDictionary *defaultValues = [[NSMutableDictionary alloc] init];
    [defaultValues setValue:@"5" forKey:@"wordlength"];
    [defaultValues setValue:@"10" forKey:@"guesses"];
    [defaultValues setValue:@"YES" forKey:@"evil"];
    
    // register defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:defaultValues];
    
    wordlength = [defaults integerForKey:@"wordlength"];
    numberOfPicks=[defaults integerForKey:@"guesses"];
    evilMode=[defaults boolForKey:@"evil"];

}

//Check if the Game is won or Lost and show a message
-(void) checkWin{
    if ([set count]==1) {
        if ([[set anyObject] isEqualToString:partial]) {
            NSString *cmes = [NSString stringWithFormat:
                              @"You did the impossible. You beat Evil Hangman by guessing the word %@",
                              partial ];
            [self showMessage:cmes  withTitle:@"Congratulations" ];
            [self newGame:nil];
        }
    }
    if (numberOfPicks==0) {
        
        NSString *word = [set anyObject];
        NSString *cmes = [NSString stringWithFormat:
                          @"Your Phone is so much smarter than you. The correct word was %@",
                          word ];
        [self showMessage:cmes  withTitle:@"You lost" ];
        [self newGame:nil];
        
    }
}


//If Evil Mode is turned Off, only one word is selected
-(void)normalMode{
    if ([set count]>1) {
        NSString *pick =[set anyObject];
        [set removeAllObjects];
        [set addObject:pick];
    }
    [self createDictionary:self.input];

}

@end
