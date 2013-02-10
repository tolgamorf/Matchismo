//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tolga Y. Ozudogru on 2/3/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (nonatomic) PlayingCardDeck *deck;
@end

@implementation CardGameViewController

// Lazy instantiation of deck
-(PlayingCardDeck *) deck
{
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    return _deck;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    Card *card = [self.deck drawRandomCard];
    if (card) {
        [sender setTitle:[card contents] forState:UIControlStateSelected];
        sender.selected = !sender.isSelected;
        self.flipCount++;
        //NSLog(@"%d : %@", self.flipCount, card.contents);
    }
}

@end
