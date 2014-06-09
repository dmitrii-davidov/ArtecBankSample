//
//  ANBanksTableViewController.m
//  ArtecBankSample
//
//  Created by Dmitry Davidov on 09.06.14.
//  Copyright (c) 2014 Anabatik. All rights reserved.
//

#import "ANBankDepartmentsTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ANAppDelegate.h"
#import "ANBankDepartmentTableViewCell.h"


NSString *const kANBankDepartmentAddressKey = @"address";
NSString *const kANBankDepartmentWorkingTimeKey = @"workingTime";
NSString *const kANBankDepartmentCoordinatesKey = @"coords";


@interface ANBankDepartmentsTableViewController () <NSURLConnectionDataDelegate>
{
    NSURLConnection *_fetchBankDepartmentsConnection;
    NSMutableData *_fetchBankDepartmentsResponseData;

    NSArray *_bankDepartments;

    UIRefreshControl *_refreshControl;

    CLLocation *_lastLocation;
}

@end


@implementation ANBankDepartmentsTableViewController

- (void)updateBankDepartments
{
    [self bankDepartmentsWillUpdate];

    _fetchBankDepartmentsConnection = [NSURLConnection connectionWithRequest:[ANAppDelegate fetchBankDepartmentsFromServerURLRequest] delegate:self];
}

- (void)bankDepartmentsWillUpdate
{
    self.tableView.userInteractionEnabled = NO;
    [_refreshControl beginRefreshing];
}

- (void)bankDepartmentsDidUpdated
{
    [_refreshControl endRefreshing];
    self.tableView.userInteractionEnabled = YES;

    _lastLocation = [ANAppDelegate lastLocation];

    [self.tableView reloadData];
}

#pragma mark View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;

    if (!_bankDepartments) {
        _bankDepartments = @[];
        [self updateBankDepartments];
    }

    if (!_refreshControl) {
        _refreshControl = [UIRefreshControl new];
        _refreshControl.tintColor = [UIColor lightGrayColor];
        [_refreshControl addTarget:self action:@selector(updateBankDepartments) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:_refreshControl];
    }
}

#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bankDepartments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *bankDepartment = _bankDepartments[indexPath.row];

    if ([cell isKindOfClass:[ANBankDepartmentTableViewCell class]]) {
        ANBankDepartmentTableViewCell *bdCell = (ANBankDepartmentTableViewCell *)cell;
        bdCell.bankDepartmentTitleLabel.text = @"Магазин \"Связной\"";
        bdCell.bankDepartmentAddressLabel.text = bankDepartment[kANBankDepartmentAddressKey];
        bdCell.bankDepartmentWorkingTimeLabel.text = bankDepartment[kANBankDepartmentWorkingTimeKey];
    }
    else {
        cell.textLabel.text = @"Магазин \"Связной\"";
        cell.detailTextLabel.text = bankDepartment[@"address"];
    }

    return cell;
}

# pragma mark URL Connection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (_fetchBankDepartmentsConnection == connection) {
        _fetchBankDepartmentsResponseData = [NSMutableData new];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_fetchBankDepartmentsConnection == connection) {
        [_fetchBankDepartmentsResponseData appendData:data];
#ifdef DEBUG
        NSLog(@"fetch bank departments url request did recieve data");
#endif
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_fetchBankDepartmentsConnection == connection) {
#ifdef DEBUG
        NSString *dataString = [[NSString alloc] initWithData:_fetchBankDepartmentsResponseData encoding:NSUTF8StringEncoding];
        NSLog(@"fetch bank departments url request response:\n%@", dataString);
#endif
        NSError *error = nil;
        id dataObject = [NSJSONSerialization JSONObjectWithData:_fetchBankDepartmentsResponseData options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"error: %@", [error localizedDescription]);
        }
        _bankDepartments = dataObject[@"locations"];

        _fetchBankDepartmentsConnection = nil;
        _fetchBankDepartmentsResponseData = nil;

        [self bankDepartmentsDidUpdated];
    }
}

@end
