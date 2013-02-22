//
//  GameResult.m
//  Matchismo
//
//  Created by Tolga Y. Ozudogru on 2/15/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@property (readwrite, nonatomic) NSTimeInterval duration;
@end

@implementation GameResult

#define ALL_RESULTS_KEY @"GameResult_All"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"
#define DURATION_KEY @"Duration"

+ (NSArray *)allGameResultsSortedByProperty:(NSString *)sortProperty
                                  ascending:(BOOL)sortOrderAscending {

    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        GameResult *result = [[GameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:result];
    }

    if (!sortProperty) sortProperty = [[NSString alloc] initWithFormat:@"end"];
//    NSLog(@"sortProperty: %@", sortProperty);
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortProperty ascending:sortOrderAscending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *allGameResultsSorted;
    allGameResultsSorted = [allGameResults sortedArrayUsingDescriptors:sortDescriptors];
    
    return allGameResultsSorted;
}


// Convenience initializer
- (id)initFromPropertyList:(id)plist {
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            _duration = [resultDictionary[DURATION_KEY] intValue];
            if (!_start || !_end) self = nil;
        }
    }
    return self;
}


- (void)synchronize {
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (id)asPropertyList {
    return @{ START_KEY : self.start,
              END_KEY : self.end,
              SCORE_KEY : @(self.score),
              DURATION_KEY: @(self.duration) };
}

// Designated initializer
- (id)init {
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (NSTimeInterval)duration {
    return [self.end timeIntervalSinceDate:self.start];
}

- (NSString *)durationFormatted {
    if (self.duration < 60.0) {
        return [NSString stringWithFormat:@"%gs", round(self.duration)];
    } else {
        return [NSString stringWithFormat:@"%gm and %gs", floor(self.duration / 60.0), round((int)self.duration % 60)];
    }
}

- (NSString *)endDateTimeFormatted {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d, ''yy h:mm a"];
    return [dateFormat stringFromDate:self.end];
}

- (void)setScore:(int)score {
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

+ (void)resetAllGameResults {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
