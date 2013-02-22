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
@property (strong, nonatomic) NSString *sortProperty;
@property (nonatomic) BOOL sortOrderAscending;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UITableView *gameResultsTableView;
@end

@implementation GameResultViewController

- (IBAction)resetGameResults:(id)sender {
    [self showResetScoresConfirmAlert];
}

- (IBAction)sortScores:(UIButton *)sender {
    
    self.sortOrderAscending = !self.sortOrderAscending;
    
    if ([sender.currentTitle isEqualToString:@"Score"]) {
        self.sortProperty = @"score";
    } else if ([sender.currentTitle isEqualToString:@"Duration"]) {
        self.sortProperty = @"duration";
    } else {
        self.sortProperty = @"end";
    }
    [self.gameResultsTableView reloadData];
}

- (NSString *)sortProperty {
    if (!_sortProperty) _sortProperty = [[NSString alloc] initWithFormat:@"end"];
    return _sortProperty;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.gameResultsTableView reloadData];
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
	if (buttonIndex == 0) {
        // Clear scoreboard
        [GameResult resetAllGameResults];
        [self.gameResultsTableView reloadData];
	} else if (buttonIndex == 1) {
        // Do nothing
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self makeItPrettyWithButton:[self resetButton]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [[GameResult allGameResultsSortedByProperty:self.sortProperty ascending:self.sortOrderAscending] count];
    return count ? count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }

    if ([[GameResult allGameResultsSortedByProperty:self.sortProperty ascending:self.sortOrderAscending] count] == 0) {
        cell.textLabel.text = @"No scores to view";
        cell.detailTextLabel.text = @"Please play the game ;)";
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"Score: %i", [[[GameResult allGameResultsSortedByProperty:self.sortProperty ascending:self.sortOrderAscending] objectAtIndex:indexPath.row] score]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (Duration: %@)", [[[GameResult allGameResultsSortedByProperty:self.sortProperty ascending:self.sortOrderAscending] objectAtIndex:indexPath.row] endDateTimeFormatted], [[[GameResult allGameResultsSortedByProperty:self.sortProperty ascending:self.sortOrderAscending] objectAtIndex:indexPath.row] durationFormatted]];
    }
    return cell;
}

@end
