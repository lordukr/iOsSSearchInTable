//
//  AZTableViewCell.h
//  TablesSearchMultithread
//
//  Created by My mac on 13.05.16.
//  Copyright © 2016 Anatolii Zavialov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;

@end
