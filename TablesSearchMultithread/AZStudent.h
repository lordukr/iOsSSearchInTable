//
//  AZStudent.h
//  TablesSearchMultithread
//
//  Created by My mac on 26.04.16.
//  Copyright © 2016 Anatolii Zavialov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSNumber* birthDate;

+ (AZStudent*) randomStudent;

@end
