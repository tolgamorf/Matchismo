//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Tolga Y. Ozudogru on 2/10/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;
@property (readonly, strong, nonatomic) NSMutableArray *cards; // of Card
@property (nonatomic) NSString *descriptionOfLastFlip;
@property (nonatomic) BOOL gameOverAlert;

// designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (BOOL)gameOver;
@end
