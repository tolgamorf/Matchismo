//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Tolga Y. Ozudogru on 2/15/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (nonatomic) BOOL sortOrderAscending;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@end

@implementation GameResultViewController
- (IBAction)resetGameResults:(id)sender {
    [self showResetScoresConfirmAlert];
}

- (IBAction)sortScores:(UIButton *)sender {
    
    self.sortOrderAscending = !self.sortOrderAscending;
    
    if ([sender.currentTitle isEqualToString:@"Score"]) {
        [self updateUIandSortGameResultsBy:@"score" ascending:self.sortOrderAscending];
    } else if ([sender.currentTitle isEqualToString:@"Duration"]) {
        [self updateUIandSortGameResultsBy:@"duration" ascending:self.sortOrderAscending];
    } else {
        [self updateUIandSortGameResultsBy:@"end" ascending:self.sortOrderAscending];
    }
}

- (void)updateUIandSortGameResultsBy:(NSString *)sortProperty ascending:(BOOL)sortOrderAscending {
    NSString *displayText = @"";
    
    for (GameResult *result in [GameResult allGameResultsSortedByProperty:sortProperty ascending:sortOrderAscending]) {
        displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %@)\n", result.score, result.endDateTimeFormatted, result.durationFormatted];
    }
    if ([displayText isEqualToString:@""]) {
        displayText = @"No scores to view";
    }
    
    self.display.text = displayText;

}

- (void)viewWillAppear:(BOOL)animated {    
    [super viewWillAppear:animated];
    [self updateUIandSortGameResultsBy:nil ascending:self.sortOrderAscending];
}

- (void)setup {
    // Initialization that can't wait unti viewDidLoad
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)makeItPrettyWithButton:(UIButton *)button {
    // Load our image normally.
    UIImage *image = [UIImage imageNamed:@"button_red.png"];
    
    // And create the stretchy version.
    float w = image.size.width / 2, h = image.size.height / 2;
    UIImage *stretch = [image stretchableImageWithLeftCapWidth:w topCapHeight:h];
    
    [button setBackgroundImage:stretch forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)showResetScoresConfirmAlert
{
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Reset game scores"];
	[alert setMessage:@"Do you want to clear all the game scores?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        // Clear scoreboard
        [GameResult resetAllGameResults];
        [self updateUIandSortGameResultsBy:nil ascending:NO];
	}
	else if (buttonIndex == 1)
	{
        // Do nothing
	}
}

- (void)viewDidLoad
{
    [self makeItPrettyWithButton:[self resetButton]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
