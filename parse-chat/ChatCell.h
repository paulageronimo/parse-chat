//
//  ChatCell.h
//  parse-chat
//
//  Created by Paula Leticia Geronimo on 7/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *user;

@end

NS_ASSUME_NONNULL_END
