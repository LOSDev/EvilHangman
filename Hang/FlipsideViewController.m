//
//  FlipsideViewController.m
//  Hang
//
//  Created by Rincewind on 23.12.12.
//  Copyright (c) 2012 Rincewind. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController
@synthesize lengthLabel;
@synthesize guessesLabel;
@synthesize s1;
@synthesize s2;
@synthesize maxWLValue;
@synthesize evilSwitch;


- (void)viewDidLoad
{
    [super viewDidLoad];
	//load default Values and set the Sliders and Textlabels
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int v1=[defaults integerForKey:@"wordlength"];
    NSString *lLabel = [NSString stringWithFormat:@"%d", v1];
    lengthLabel.text = lLabel;
    [s1 setMaximumValue:maxWLValue];
    [s1 setValue:v1];
    
    int v2 =[defaults integerForKey:@"guesses"];
    NSString *gLabel = [NSString stringWithFormat:@"%d", v2];
    guessesLabel.text = gLabel;
    [s2 setValue:v2];
    
    
    BOOL evil =[defaults boolForKey:@"evil"];
    [evilSwitch setOn:evil animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
//Called when the WordLength Slider changes value
- (IBAction)lengthSlide:(id)sender {
    int value1=(int)s1.value;
    NSString *lLabel = [NSString stringWithFormat:@"%d",value1];
    lengthLabel.text = lLabel;

    
    
}
//Called when the Number of Guesses Slider changes value
- (IBAction)guessesSlider:(id)sender {
    int value2=(int)s2.value;
    NSString *gLabel = [NSString stringWithFormat:@"%d",value2 ];
    guessesLabel.text = gLabel;

    
}

 // saves values from sliders and Switch into NSUserDefaults when the user clicks Done
- (IBAction)done:(id)sender
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *w= [NSString stringWithFormat:@"%d",(int)s1.value ];
    [defaults setObject:w forKey:@"wordlength"];
    NSString *g= [NSString stringWithFormat:@"%d",(int)s2.value ];
    [defaults setObject:g forKey:@"guesses"];
    
    BOOL *evil = evilSwitch.on;
    
    if (evil) {
        [defaults setValue:@"YES" forKey:@"evil"];
    }else{
        [defaults setValue:@"NO" forKey:@"evil"];
    }
    
    [defaults synchronize];
    
    [self.delegate flipsideViewControllerDidFinish:self];
}


@end
