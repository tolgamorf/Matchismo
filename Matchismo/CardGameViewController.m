//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tolga Y. Ozudogru on 2/3/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"
//#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardGameViewController ()
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation CardGameViewController

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
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.text = self.game.descriptionOfLastFlip;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    int index = 0; // ????
    [self.game flipCardAtIndex:index];
    self.flipCount++;
    [self updateUI];
    self.gameResult.score = self.game.score;
    self.gameModeSegmentedControl.enabled = NO;
}

- (IBAction)reDealCards:(id)sender {
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    [self updateUI];
}
@end
