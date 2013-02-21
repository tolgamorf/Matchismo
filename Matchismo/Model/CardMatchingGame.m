//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Tolga Y. Ozudogru on 2/10/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score; // Even though readwrite is default, use it for readibility in private implementation
@property (readwrite, strong, nonatomic) NSMutableArray *cards; // of Card
@end


@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            self.descriptionOfLastFlip = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.descriptionOfLastFlip = [NSString stringWithFormat:@"Matched %@ & %@ for %i points.", card.contents, otherCard.contents, matchScore * MATCH_BONUS];
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.descriptionOfLastFlip = [NSString stringWithFormat:@"%@ & %@ don't match! %i points penalty!", card.contents, otherCard.contents, MISMATCH_PENALTY];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;

    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    _gameOverAlert = YES;
    return self;
}

- (BOOL)gameOver {
    BOOL gameIsOver = NO;
    
    if (self.gameOverAlert) {
        NSMutableArray *unplayableCardContents = [[NSMutableArray alloc] init];
        for (PlayingCard *card in self.cards) {
            if (!card.isUnplayable) {
                [unplayableCardContents addObject:card.suit];
                [unplayableCardContents addObject:[NSString stringWithFormat:@"%i", (int)card.rank]];
            }
        }

        if ([unplayableCardContents count] <= 8) {
            gameIsOver = YES;
            NSCountedSet *set = [[NSCountedSet alloc] initWithArray:unplayableCardContents];
            for (id item in set) {
                if ([set countForObject:item] > 1) gameIsOver = NO;
            }
        }
    }
    return gameIsOver;
}

@end
