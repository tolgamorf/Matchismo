//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tolga Y. Ozudogru on 2/3/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;


@property (strong, nonatomic) UICollectionViewFlowLayout *portraitLayout;
@property (strong, nonatomic) UICollectionViewFlowLayout *landscapeLayout;

@end

@implementation CardGameViewController
- (IBAction)notImplemented {
    [self showNotImplementedAlert];
    self.gameModeSegmentedControl.selectedSegmentIndex = 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.startingCardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:YES];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate {
    // abstract
}

// Lazy instantiation of GameResult
- (GameResult *)gameResult {
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    return _gameResult;
}

// Lazy instantiation of CardMatchingGame
- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]];
        self.gameModeSegmentedControl.enabled = YES;
    }
    return _game;
}

- (Deck *)createDeck {
    return nil; // abstract
}

- (void) updateUI {
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animate:NO];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    if (self.game.descriptionOfLastFlip) {
        self.resultLabel.text = self.game.descriptionOfLastFlip;
    } else {
        self.resultLabel.text = @" ";
    }
    if ([self.game gameOver]) {
        [self showGameOverAlert];
    }
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];

        UICollectionViewCell *cell = [self.cardCollectionView cellForItemAtIndexPath:indexPath];
        Card *card = [self.game cardAtIndex:indexPath.item];
        
        if (!card.isUnplayable) [self updateCell:cell usingCard:card animate:YES];
        
        self.flipCount++;
        [self updateUI];
        self.gameResult.score = self.game.score;
        self.gameModeSegmentedControl.enabled = NO;
    }
}
- (IBAction)reDealCards {
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    [self updateUI];
}

- (void)viewDidLoad {
    [self updateUI];
}


- (void)showGameOverAlert
{
	UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTag:1];
	[alert setTitle:@"Game over"];
	[alert setMessage:@"Current game is over. Do you want to start a new one?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
}

- (void)showNotImplementedAlert
{
	UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTag:999];
	[alert setTitle:@"Feature not implemented"];
	[alert setMessage:@"This feature is not yet implemented. It will allow you to match 3 cards instead of 2. I might add another tab and remove this control."];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"OK"];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0)
        {
            // Re-deal cards
            [self reDealCards];
        }
        else if (buttonIndex == 1)
        {
            // Turn off game over alert
            self.game.gameOverAlert = NO;
        }
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation duration:(NSTimeInterval)duration
{        
        switch (interfaceOrientation) {
            case UIInterfaceOrientationPortrait:
                NSLog(@"Portrait");
                break;
                
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                NSLog(@"LandscapeLeft or LandscapeRight");
                break;
                
            default:
                break;
        }
}

@end
