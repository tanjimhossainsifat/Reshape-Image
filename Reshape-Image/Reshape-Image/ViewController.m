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
    Nothing = 4
    
}OperationType;


@interface ViewController ()
{
    CAShapeLayer *borderLayer;
}

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
    
    borderLayer = [[CAShapeLayer alloc] init];
    borderLayer.lineWidth = 2.0;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:borderLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.topLeftControl.center];
    [path addLineToPoint:self.topRightControl.center];
    [path addLineToPoint:self.bottomRightControl.center];
    [path addLineToPoint:self.bottomLeftControl.center];
    [path closePath];
    
    borderLayer.path = [UIBezierPath bezierPathWithAGKQuad:self.imageView.layer.quadrilateral].CGPath;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabbar.selectedItem = [self.tabbar.items objectAtIndex:0];
    self.currentOperationType = Reshape;
    [self loadViewForReshape];
}

#pragma mark - Gesture

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
    
    if(self.currentOperationType == Reshape && controlPointView != self.imageView) {
        
        controlPointView.centerX += translation.x;
        controlPointView.centerY += translation.y;
    }
    else if(self.currentOperationType == Rotate && controlPointView != self.imageView) {
            
            CGPoint vector1 = CGPointMake(controlPointView.centerX-(self.imageView.frame.origin.x+self.imageView.frame.size.width/2), controlPointView.centerY-(self.imageView.frame.origin.y+self.imageView.frame.size.height/2));
            
            CGPoint nextControlPoint;
            nextControlPoint.x = controlPointView.centerX + translation.x;
            nextControlPoint.y = controlPointView.centerY + translation.y;
            
            CGPoint vector2 = CGPointMake(nextControlPoint.x-(self.imageView.frame.origin.x+self.imageView.frame.size.width/2), nextControlPoint.y-(self.imageView.frame.origin.y+self.imageView.frame.size.height/2));
            
            float angle1 = atan2f(vector1.x, vector1.y);
            float angle2 = atan2f(vector2.x, vector2.y);
            float rotationAngle =  -(angle2- angle1);
            
            [self.imageView.layer ensureAnchorPointIsSetToZero];
            AGKQuad q = AGKQuadRotateAroundPoint(self.imageView.layer.quadrilateral, CGPointMake(self.imageView.frame.origin.x+self.imageView.frame.size.width/2, self.imageView.frame.origin.y+self.imageView.frame.size.height/2), rotationAngle);
            
            self.topLeftControl.center = q.tl;
            self.topRightControl.center = q.tr;
            self.bottomRightControl.center = q.br;
            self.bottomLeftControl.center = q.bl;
        
        

    }
    else if(self.currentOperationType == Resize && controlPointView != self.imageView) {
        
        if(controlPointView == self.centerLeftControl) {
            self.topLeftControl.centerX += translation.x;
            self.topLeftControl.centerY += translation.y;
            self.bottomLeftControl.centerX += translation.x;
            self.bottomLeftControl.centerY += translation.y;
        }
        else if(controlPointView == self.centerTopControl) {
            
            self.topLeftControl.centerX += translation.x;
            self.topLeftControl.centerY += translation.y;
            self.topRightControl.centerX += translation.x;
            self.topRightControl.centerY += translation.y;
        }
        else if(controlPointView == self.centerRightControl) {
            
            self.topRightControl.centerX += translation.x;
            self.topRightControl.centerY += translation.y;
            self.bottomRightControl.centerX += translation.x;
            self.bottomRightControl.centerY += translation.y;
        }
        else if(controlPointView == self.centerBottomControl) {
            
            self.bottomRightControl.centerX += translation.x;
            self.bottomRightControl.centerY += translation.y;
            self.bottomLeftControl.centerX += translation.x;
            self.bottomLeftControl.centerY += translation.y;
        }
        
    }
    
    
    if(controlPointView == self.imageView) {
        
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
    
    
    borderLayer.path = [UIBezierPath bezierPathWithAGKQuad:self.imageView.layer.quadrilateral].CGPath;
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
        case 4:
        {
            
            //Save
            self.currentOperationType = Nothing;
            [self loadViewForSave];
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


#pragma mark - UI related methods
- (void) initControls {
    
    self.topLeftControl.center = self.imageView.frame.origin;
    self.topRightControl.center = CGPointMake(self.imageView.frame.origin.x+self.imageView.frame.size.width, self.imageView.frame.origin.y);
    self.bottomRightControl.center = CGPointMake(self.imageView.frame.origin.x+self.imageView.frame.size.width, self.imageView.frame.origin.y + self.imageView.frame.size.height);
    self.bottomLeftControl.center = CGPointMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + self.imageView.frame.size.height);
    
    [self updateControlsByCornerControls];
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
    
    borderLayer.hidden = NO;
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
    
    borderLayer.hidden = NO;
    
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
    
    borderLayer.hidden = NO;
    
}

- (void) loadViewForSave {
    self.topLeftControl.hidden = YES;
    self.topRightControl.hidden = YES;
    self.bottomRightControl.hidden = YES;
    self.bottomLeftControl.hidden = YES;
    
    self.centerLeftControl.hidden = YES;
    self.centerTopControl.hidden = YES;
    self.centerRightControl.hidden = YES;
    self.centerBottomControl.hidden = YES;
    
    borderLayer.hidden = YES;
    
}

#pragma mark - Save Image
- (void) saveImageToLibrary {
    
    self.tabbar.hidden = YES;
    UIImage *mergedImage = [self takeSnapshotOfView:self.view];
    NSArray *excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage];
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[mergedImage] applicationActivities:nil];
    
    activityView.excludedActivityTypes = excludedActivityTypes;
    activityView.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if(completed && [activityType isEqualToString:UIActivityTypeSaveToCameraRoll]){
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Image Saved Successfully to gallery" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                self.tabbar.hidden = NO;
            }];
            
        }
    };
    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityView animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityView];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
}


- (UIImage *)takeSnapshotOfView:(UIView *)view
{
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
