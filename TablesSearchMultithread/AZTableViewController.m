//
//  AZTableViewController.m
//  TablesSearchMultithread
//
//  Created by My mac on 26.04.16.
//  Copyright © 2016 Anatolii Zavialov. All rights reserved.
//

#import "AZTableViewController.h"
#import "AZStudent.h"
#import "AZGroups.h"
#import "AZTableViewCell.h"

@interface AZTableViewController () <UISearchBarDelegate>

@property (strong, nonatomic) NSArray* studentsArray;

@property (strong, nonatomic) NSArray* groupsArray;

@property (assign, nonatomic) NSInteger segmentValue;

@property (strong, nonatomic) NSOperation* currentOperation;

@end

typedef enum {
    FirstNameType,
    LastNameType,
    BirthdateType
} SegmentDataTypes;

@implementation AZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray* tempArray = [NSMutableArray array];
    self.studentsArray = [NSMutableArray array];
    self.groupsArray = [NSMutableArray array];
    
    for (int i = 0; i < 100000; i++) {
        [tempArray addObject:[AZStudent randomStudent]];
    }
    self.studentsArray = tempArray;
    
    [self createSectionsAsync:self.studentsArray andFilterText:self.searchBar.text];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) createSectionsAsync:(NSArray*) array andFilterText:(NSString*)filterString {
    
    [self.currentOperation cancel];
    
    __weak NSArray* weakStudents = self.studentsArray;
    self.studentsArray = [self sortArray:weakStudents];
    
    __weak AZTableViewController* weakSelf = self;
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        [weakSelf createSectionsFromArray:self.studentsArray andFilterString:filterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
    
            self.currentOperation = nil;
        });
        
    }];
    
    [self.currentOperation start];
}

- (void) createSectionsFromArray:(NSArray*) array andFilterString:(NSString*) filterText {
    NSMutableArray* arraySections = [NSMutableArray array];
    
    NSString* currentValue = nil;
    
    for (AZStudent* student in array) {
        NSString* firstValue = nil;
        AZGroups* group = nil;
        NSString* currentTextToFilter;
        switch (self.segmentValue) {
            case FirstNameType:
                currentTextToFilter = student.firstName;
                firstValue = [student.firstName substringToIndex:1];
                break;
            case LastNameType:
                currentTextToFilter = student.lastName;
                firstValue = [student.lastName substringToIndex:1];
                break;
            case BirthdateType:
                firstValue = [NSString stringWithFormat:@"%d", [student.birthDate intValue]];
                break;
                
            default:
                break;
        }
        
        if (filterText.length > 0 && [currentTextToFilter rangeOfString:filterText].location == NSNotFound) {
            continue;
        }
        
        if (![currentValue isEqualToString:firstValue]) {
            group = [[AZGroups alloc] init];
            
            if (self.segmentValue == BirthdateType) {
                group.name = [firstValue substringWithRange:NSMakeRange(1, 2)];
            } else {
                group.name = [firstValue substringToIndex:1];
            }
            
            group.groupItems = [NSMutableArray array];
            currentValue = firstValue;
            [arraySections addObject:group];
        } else {
            group = [arraySections lastObject];
        }
        
        [group.groupItems addObject:student];
    }
    
    self.groupsArray = arraySections;
}

- (NSArray*) sortArray:(NSArray*) array {
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:array];
    
    NSSortDescriptor* sortDescriptor;
    
    switch (self.segmentValue) {
        case FirstNameType:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
            break;
        case LastNameType:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
            break;
        case BirthdateType:
             sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"birthDate" ascending:YES];
            break;
            
        default:
            break;
    }
    
    [tempArray sortUsingDescriptors:@[sortDescriptor]];
    
    return tempArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.groupsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AZGroups* groups = [self.groupsArray objectAtIndex:section];
    
    return [groups.groupItems count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* title;
    
    AZGroups* group = [self.groupsArray objectAtIndex:section];
    
    title = group.name;
    
    return title;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray* arr = [NSMutableArray array];
    
    for (AZGroups* group in self.groupsArray) {
        NSString* currentTitle = group.name;
        [arr addObject:currentTitle];
    }
    
    return arr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"AZTableViewCell";
    
    AZTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[AZTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    AZGroups* groups = [self.groupsArray objectAtIndex:indexPath.section];
    AZStudent* student = [groups.groupItems objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", student.birthDate];
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text = nil;
    [self createSectionsFromArray:self.studentsArray andFilterString:searchBar.text];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self createSectionsFromArray:self.studentsArray andFilterString:searchText];
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)segmentedControlAction:(UISegmentedControl *)sender {
    
    NSInteger selectedValue = sender.selectedSegmentIndex;
    self.segmentValue = selectedValue;
    
    [self createSectionsAsync:self.studentsArray andFilterText:self.searchBar.text];
    
    [self.tableView reloadData];
    
}

@end
