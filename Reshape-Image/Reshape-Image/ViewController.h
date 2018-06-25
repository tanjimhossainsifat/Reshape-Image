//
//  ViewController.h
//  Reshape-Image
//
//  Created by Tanjim on 25/6/18.
//  Copyright © 2018 Tanjim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stickerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topLeftControl;
@property (weak, nonatomic) IBOutlet UIImageView *topRightControl;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRightControl;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLeftControl;


@end

