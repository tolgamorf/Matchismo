//
//  GameResult.h
//  Matchismo
//
//  Created by Tolga Y. Ozudogru on 2/15/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

@property (nonatomic) int score;
@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (readonly, nonatomic) NSString *durationFormatted;
@property (readonly, nonatomic) NSString *endDateTimeFormatted;

+ (NSArray *)allGameResultsSortedByProperty:(NSString *)sortProperty ascending:(BOOL)sortOrderAscending;

+ (void)resetAllGameResults;

@end
