//
//  ANBankDepartmentTableViewCell.h
//  ArtecBankSample
//
//  Created by Dmitry Davidov on 09.06.14.
//  Copyright (c) 2014 Anabatik. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ANBankDepartmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bankDepartmentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankDepartmentAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankDepartmentDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankDepartmentWorkingTimeLabel;

@end
