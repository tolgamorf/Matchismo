//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Tolga Y. Ozudogru on 2/3/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

- (Deck *)createDeck; // abstract
@property (nonatomic) NSUInteger startingCardCount; // abstract
@end
