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

@interface AZTableViewController ()

@property (strong, nonatomic) NSArray* studentsArray;

@property (strong, nonatomic) NSMutableArray* groupsArray;

@end

@implementation AZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* tempArray = [NSMutableArray array];
    self.groupsArray = [NSMutableArray array];
    
    for (int i = 0; i < 1000; i++) {
        [tempArray addObject:[AZStudent randomStudent]];
    }
    
    self.studentsArray = [self sortArray:tempArray];
    
    NSNumber* currentNumber = 0;
    
    for (AZStudent* student in self.studentsArray) {
        AZGroups* group = nil;
        NSNumber* firstNumber = student.birthDate;
        
        if (![currentNumber isEqualToNumber:student.birthDate]) {
            group = [[AZGroups alloc] init];
            group.name = [NSString stringWithFormat:@"%d", [firstNumber intValue]];
            group.groupItems = [NSMutableArray array];
            currentNumber = firstNumber;
            [self.groupsArray addObject:group];
        } else {
            group = [self.groupsArray lastObject];
        }
        [group.groupItems addObject:student];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (NSArray*) sortArray:(NSArray*) array {
    NSMutableArray* tempArray = [NSMutableArray array];
    tempArray = [NSMutableArray arrayWithArray:array];
    
    NSSortDescriptor* firstNameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* lastNameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSSortDescriptor* birthDescriptor = [[NSSortDescriptor alloc] initWithKey:@"birthDate" ascending:YES];
    
    [tempArray sortUsingDescriptors:@[birthDescriptor, firstNameSortDescriptor, lastNameSortDescriptor]];
  
    return tempArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.groupsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.studentsArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* title;
    
    AZGroups* group = [self.groupsArray objectAtIndex:section];
    
    title = [NSString stringWithFormat:@"%@", group.name];
    
    return title;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray* arr = [NSMutableArray array];
    for (AZGroups* group in self.groupsArray) {
        [arr addObject:group.name];
    }
    return arr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    AZStudent* student = [self.studentsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)student.birthDate];
    
    return cell;
}

@end
