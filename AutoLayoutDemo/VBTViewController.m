//
//  VBTViewController.m
//  AutoLayoutDemo
//
//  Created by Vaibhav Bhatia on 2/19/13.
//  Copyright (c) 2013 Vaikings. All rights reserved.
//

#import "VBTViewController.h"

#if DEBUG
@interface UIWindow (AutolayoutDebug)
+ (UIWindow *)keyWindow;
- (NSString *)_autolayoutTrace;
@end
#endif

@interface VBTViewController ()

@property (nonatomic, strong) NSMutableArray* portraitConstraints ;
@property (nonatomic, strong) NSMutableArray* landscapeConstraints ;
@property (nonatomic, strong) NSDictionary* viewBindings ; 

@property (nonatomic, strong) UIView* blackView ;
@property (nonatomic, strong) UIView* redView ;

@end

@implementation VBTViewController

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad called");
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]] ;
    
    self.redView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.redView setBackgroundColor:[UIColor redColor]];
    self.redView.translatesAutoresizingMaskIntoConstraints = NO ;
    [self.view addSubview:self.redView];
    
    self.blackView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.blackView setBackgroundColor:[UIColor blackColor]];
    self.blackView.translatesAutoresizingMaskIntoConstraints = NO ;
    [self.view addSubview:self.blackView];

    self.viewBindings = @{@"blackView": self.blackView, @"redView":self.redView};
    
    [self.view setNeedsUpdateConstraints]; 
}


#if DEBUG
//added for debugging constraints 
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"%@", [[UIWindow keyWindow] _autolayoutTrace]);
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"%@", [[UIWindow keyWindow] _autolayoutTrace]);
}
#endif


#pragma mark - Autolayout

- (void) updateViewConstraints
{
    [super updateViewConstraints];
    
    [self _updateViewConstraintsForInterfaceOrientation:self.interfaceOrientation withDuration:0.1];
}


- (void) _updateViewConstraintsForInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation  withDuration:(NSTimeInterval)duration ;
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        NSLog(@"update constraints for moving to portrait orientation" );
        [self _constructPortraitConstraints];
        if (self.landscapeConstraints != nil){
            [self.view removeConstraints:self.landscapeConstraints];
            self.landscapeConstraints = nil ; 
        }
        [self.view addConstraints:self.portraitConstraints]; 
        
    } else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        NSLog(@"update constraints for moving to landscape orientation" );
        [self _constructLandscapeConstraints];
        if (self.portraitConstraints != nil) {
            [self.view removeConstraints:self.portraitConstraints];
            self.portraitConstraints = nil ;
        }
        [self.view addConstraints:self.landscapeConstraints]; 
    }
}

- (void) _constructPortraitConstraints ;
{
    NSLog(@"construct portrait constraints");
    if (self.portraitConstraints != nil)
        return;
    
    self.portraitConstraints = [NSMutableArray array];
    
    //add vertical constraints to specify height
    [self.portraitConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[blackView(==200)]-|" options:0 metrics:nil views:self.viewBindings]];
    [self.portraitConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[redView(==20)]" options:0 metrics:nil views:self.viewBindings]];
    
    //add horizontal constraints to specify width 
    [self.portraitConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[blackView(==100)]" options:0 metrics:nil views:self.viewBindings]];
    [self.portraitConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[redView(==blackView)]" options:0 metrics:nil views:self.viewBindings]];
    
    //set view relative to each other 
    [self.portraitConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[redView][blackView]" options:0 metrics:nil views:self.viewBindings]];
    
    [self.portraitConstraints addObject:[NSLayoutConstraint constraintWithItem:self.blackView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.portraitConstraints addObject:[NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
}

- (void) _constructLandscapeConstraints ; 
{
    NSLog(@"construct landscape constraints");
    if (self.landscapeConstraints != nil)
        return ;
    
    self.landscapeConstraints  = [NSMutableArray array];
    
    // add vertical constraints
    [self.landscapeConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[blackView(==100)]-|" options:0 metrics:nil views:self.viewBindings]];
    [self.landscapeConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[redView(==blackView)]-|" options:0 metrics:nil views:self.viewBindings]];

    // add horizontal constraints
    [self.landscapeConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[blackView(==100)]" options:0 metrics:nil views:self.viewBindings]];
    [self.landscapeConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[redView(==blackView)]" options:0 metrics:nil views:self.viewBindings]];
    
    // position them next to each other
    [self.landscapeConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[blackView]-|" options:0 metrics:nil views:self.viewBindings]];
    [self.landscapeConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[redView]" options:0 metrics:nil views:self.viewBindings]];
}

@end
