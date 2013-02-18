//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Tolga Y. Ozudogru on 2/18/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end
