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
@property (weak, nonatomic) IBOutlet UIImageView *topLeftControl;
@property (weak, nonatomic) IBOutlet UIImageView *topRightControl;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRightControl;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLeftControl;

@property (weak, nonatomic) IBOutlet UIImageView *centerLeftControl;
@property (weak, nonatomic) IBOutlet UIImageView *centerTopControl;
@property (weak, nonatomic) IBOutlet UIImageView *centerRightControl;
@property (weak, nonatomic) IBOutlet UIImageView *centerBottomControl;

@end

