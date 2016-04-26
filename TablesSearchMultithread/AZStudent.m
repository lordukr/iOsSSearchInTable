//
//  AZStudent.m
//  TablesSearchMultithread
//
//  Created by My mac on 26.04.16.
//  Copyright © 2016 Anatolii Zavialov. All rights reserved.
//

#import "AZStudent.h"

static NSString* lastNames [] = {@"Parks",  @"Hansen", @"Meadows", @"Maxwell", @"Lamb", @"Fletcher", @"Berg", @"Wright", @"Reese", @"Herring", @"Johnson", @"Rangel",@"Pearson",@"Beard", @"Chan", @"Archer", @"Shah", @"Choi", @"Bass", @"Howard", @"Herrera",@"Pope",@"Whitehead", @"Flynn", @"Turner", @"Clark", @"Joseph", @"Moreno", @"Heath", @"Carroll"};
static NSString* firstNames [] = {@"Crystal", @"Allen", @"Rodrigo", @"Kallie", @"Rosemary", @"Penelope", @"Quinten", @"Marlene", @"Armani", @"Izaiah", @"Lennon",@"Helen",@"Helena",@"Deandre", @"Grant", @"Alannah", @"Mohammad", @"Rodney", @"Alfredo", @"Keshawn", @"Taniyah", @"Gilberto", @"German", @"Terrence", @"Leonard", @"Finnegan", @"Aryanna", @"Asher", @"Leon", @"Frederick"};
static NSInteger namesCount = 30;

@implementation AZStudent

+ (AZStudent*) randomStudent {
    AZStudent* student = [[AZStudent alloc] init];
    
    student.firstName = firstNames[arc4random() % namesCount];
    student.lastName = lastNames[arc4random() % namesCount];
    student.birthDate = [NSNumber numberWithInteger:arc4random() % 12 + 1990];
    
    return student;
}

@end
