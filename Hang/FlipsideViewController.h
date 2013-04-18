//
//  FlipsideViewController.h
//  Hang
//
//  Created by Rincewind on 23.12.12.
//  Copyright (c) 2012 Rincewind. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController{
int maxWLValue;
}
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *guessesLabel;
@property (weak, nonatomic) IBOutlet UISlider *s1;
@property (weak, nonatomic) IBOutlet UISlider *s2;
@property (weak, nonatomic) IBOutlet UISwitch *evilSwitch;
@property int maxWLValue;

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)lengthSlide:(id)sender;
- (IBAction)guessesSlider:(id)sender;
- (IBAction)done:(id)sender;
- (void) setMaxWLValue:(int)maxWLValue;
@end
