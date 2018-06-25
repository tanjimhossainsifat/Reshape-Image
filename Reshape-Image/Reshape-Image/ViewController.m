//
//  ViewController.m
//  Reshape-Image
//
//  Created by Tanjim on 25/6/18.
//  Copyright © 2018 Tanjim. All rights reserved.
//

#import "ViewController.h"
#import <AGGeometryKit/AGGeometryKit.h>

typedef enum {
    
    Reshape = 1,
    Rotate = 2,
    Resize = 3,
    Move = 4,
    Nothing = 5
    
}OperationType;


@interface ViewController ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) OperationType currentOperationType;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.imageView.layer ensureAnchorPointIsSetToZero];
    
    [self initControls];
    
    self.imageView.layer.quadrilateral = AGKQuadMake(self.topLeftControl.center,
                                                     self.topRightControl.center,
                                                     self.bottomRightControl.center,
                                                     self.bottomLeftControl.center);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (IBAction)panGestureChanged:(UIPanGestureRecognizer *)recognizer
{
    UIImageView *controlPointView = (UIImageView *)[recognizer view];
    controlPointView.highlighted = recognizer.state == UIGestureRecognizerStateChanged;
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    if(self.currentOperationType == Reshape) {
        
        controlPointView.centerX += translation.x;
        controlPointView.centerY += translation.y;
    }
    else if(self.currentOperationType == Rotate) {
        
        
    }
    else if(self.currentOperationType == Resize) {
        
        if(controlPointView == self.centerLeftControl) {
            
            self.topLeftControl.centerX += translation.x;
            //self.topLeftControl.centerY += translation.y;
            self.bottomLeftControl.centerX += translation.x;
            //self.bottomLeftControl.centerY += translation.y;
        }
        else if(controlPointView == self.centerTopControl) {
            
            //self.topLeftControl.centerX += translation.x;
            self.topLeftControl.centerY += translation.y;
            //self.topRightControl.centerX += translation.x;
            self.topRightControl.centerY += translation.y;
        }
        else if(controlPointView == self.centerRightControl) {
            
            self.topRightControl.centerX += translation.x;
            //self.topRightControl.centerY += translation.y;
            self.bottomRightControl.centerX += translation.x;
            //self.bottomRightControl.centerY += translation.y;
        }
        else if(controlPointView == self.centerBottomControl) {
            
            //self.bottomRightControl.centerX += translation.x;
            self.bottomRightControl.centerY += translation.y;
            //self.bottomLeftControl.centerX += translation.x;
            self.bottomLeftControl.centerY += translation.y;
        }
        
    }
    else if(self.currentOperationType == Move) {
        
        self.topLeftControl.centerX += translation.x;
        self.topLeftControl.centerY += translation.y;
        self.topRightControl.centerX += translation.x;
        self.topRightControl.centerY += translation.y;
        self.bottomRightControl.centerX += translation.x;
        self.bottomRightControl.centerY += translation.y;
        self.bottomLeftControl.centerX += translation.x;
        self.bottomLeftControl.centerY += translation.y;
        
    }
    
    
    
    [self updateControlsByCornerControls];
    
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    self.imageView.layer.quadrilateral = AGKQuadMake(self.topLeftControl.center,
                                                     self.topRightControl.center,
                                                     self.bottomRightControl.center,
                                                     self.bottomLeftControl.center);
}


#pragma mark - UITabbarDelegte methods

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSLog(@"didSelectItem: %ld", item.tag);
    
    switch (item.tag) {
        case 0:
        {
            //Reshape
            self.currentOperationType = Reshape;
            [self loadViewForReshape];
            
        }
            break;
        case 1:
        {
            //Rotate
            self.currentOperationType = Rotate;
            [self loadViewForRotate];
        }
            break;
        case 2:
        {
            //Resize
            self.currentOperationType = Resize;
            [self loadViewForResize];
        }
            break;
        case 3:
        {
            //Move
            self.currentOperationType = Move;
            [self loadViewForMove];
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

- (void) initControls {
    
    self.topLeftControl.center = self.imageView.frame.origin;
    self.topRightControl.center = CGPointMake(self.imageView.frame.origin.x+self.imageView.frame.size.width, self.imageView.frame.origin.y);
    self.bottomRightControl.center = CGPointMake(self.imageView.frame.origin.x+self.imageView.frame.size.width, self.imageView.frame.origin.y + self.imageView.frame.size.height);
    self.bottomLeftControl.center = CGPointMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + self.imageView.frame.size.height);
    
    self.centerLeftControl.center = CGPointMake((self.topLeftControl.centerX + self.bottomLeftControl.centerX)/2, (self.topLeftControl.centerY+self.bottomLeftControl.centerY)/2);
    self.centerTopControl.center = CGPointMake((self.topLeftControl.centerX + self.topRightControl.centerX)/2, (self.topLeftControl.centerY+self.topRightControl.centerY)/2);
    self.centerRightControl.center = CGPointMake((self.topRightControl.centerX + self.bottomRightControl.centerX)/2, (self.topRightControl.centerY+self.bottomRightControl.centerY)/2);
    self.centerBottomControl.center = CGPointMake((self.bottomLeftControl.centerX + self.bottomRightControl.centerX)/2, (self.bottomLeftControl.centerY+self.bottomRightControl.centerY)/2);
}

- (void) updateControlsByCornerControls {
    
    self.centerLeftControl.center = CGPointMake((self.topLeftControl.centerX + self.bottomLeftControl.centerX)/2, (self.topLeftControl.centerY+self.bottomLeftControl.centerY)/2);
    self.centerTopControl.center = CGPointMake((self.topLeftControl.centerX + self.topRightControl.centerX)/2, (self.topLeftControl.centerY+self.topRightControl.centerY)/2);
    self.centerRightControl.center = CGPointMake((self.topRightControl.centerX + self.bottomRightControl.centerX)/2, (self.topRightControl.centerY+self.bottomRightControl.centerY)/2);
    self.centerBottomControl.center = CGPointMake((self.bottomLeftControl.centerX + self.bottomRightControl.centerX)/2, (self.bottomLeftControl.centerY+self.bottomRightControl.centerY)/2);
}

- (void) loadViewForReshape {
    
    self.topLeftControl.hidden = NO;
    self.topRightControl.hidden = NO;
    self.bottomRightControl.hidden = NO;
    self.bottomLeftControl.hidden = NO;
    
    self.centerLeftControl.hidden = YES;
    self.centerTopControl.hidden = YES;
    self.centerRightControl.hidden = YES;
    self.centerBottomControl.hidden = YES;
}

- (void) loadViewForRotate {
    
    self.topLeftControl.hidden = NO;
    self.topRightControl.hidden = NO;
    self.bottomRightControl.hidden = NO;
    self.bottomLeftControl.hidden = NO;
    
    self.centerLeftControl.hidden = YES;
    self.centerTopControl.hidden = YES;
    self.centerRightControl.hidden = YES;
    self.centerBottomControl.hidden = YES;
    
}

- (void) loadViewForResize {
    
    
    self.topLeftControl.hidden = YES;
    self.topRightControl.hidden = YES;
    self.bottomRightControl.hidden = YES;
    self.bottomLeftControl.hidden = YES;
    
    self.centerLeftControl.hidden = NO;
    self.centerTopControl.hidden = NO;
    self.centerRightControl.hidden = NO;
    self.centerBottomControl.hidden = NO;
    
}

- (void) loadViewForMove {
    
    self.topLeftControl.hidden = YES;
    self.topRightControl.hidden = YES;
    self.bottomRightControl.hidden = YES;
    self.bottomLeftControl.hidden = YES;
    
    self.centerLeftControl.hidden = YES;
    self.centerTopControl.hidden = YES;
    self.centerRightControl.hidden = YES;
    self.centerBottomControl.hidden = YES;
}

- (void) saveImageToLibrary {
    
    UIImage *backgroundImage = self.backgroundImageView.image;
    UIImage *maskImage = self.imageView.image;
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
