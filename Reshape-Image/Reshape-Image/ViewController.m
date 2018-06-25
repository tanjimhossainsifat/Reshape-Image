//
//  ViewController.m
//  Reshape-Image
//
//  Created by Tanjim on 25/6/18.
//  Copyright © 2018 Tanjim. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UITabbarDelegte methods

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSLog(@"didSelectItem: %ld", item.tag);
    
    switch (item.tag) {
        case 0:
        {
            //Reshape
        }
            break;
        case 1:
        {
            //Rotate
        }
            break;
        case 2:
        {
            //Resize
        }
            break;
        case 3:
        {
            //Move
        }
            break;
        case 4:
        {
            
            //Save
            
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self saveImageToLibrary];
            }];
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to save this image to photo library?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self presentViewController:alert animated:YES completion:nil];
                
            });
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void) saveImageToLibrary {
    
    UIImage *backgroundImage = self.backgroundImageView.image;
    UIImage *maskImage = self.stickerImageView.image;
    CGSize imageSize = CGSizeMake(backgroundImage.size.width, backgroundImage.size.height);
    
    UIImage *mergedImage = [self mergeImage:maskImage overImage:backgroundImage inSize:imageSize];
    
    NSArray *excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage];
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[mergedImage] applicationActivities:nil];
    
    activityView.excludedActivityTypes = excludedActivityTypes;
    activityView.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if(completed && [activityType isEqualToString:UIActivityTypeSaveToCameraRoll]){
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Image Saved Successfully to gallery" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    };
    
    [self presentViewController:activityView animated:YES completion:nil];
    
}

-(UIImage*)mergeImage:(UIImage*)mask overImage:(UIImage*)source inSize:(CGSize)size
{
    //Capture image context ref
    UIGraphicsBeginImageContext(size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Draw images onto the context
    [source drawInRect:CGRectMake(0, 0, source.size.width, source.size.height)];
    [mask drawInRect:CGRectMake(0, 0, mask.size.width, mask.size.height)];
    
    return viewImage;
    
}

@end
