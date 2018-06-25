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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *topLeftControl;
@property (weak, nonatomic) IBOutlet UIView *topRightControl;
@property (weak, nonatomic) IBOutlet UIView *bottomRightControl;
@property (weak, nonatomic) IBOutlet UIView *bottomLeftControl;


@end

