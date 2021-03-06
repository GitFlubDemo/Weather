//
//  WViewController.m
//  Weather
//
//  Created by Andrew Charkin on 11/21/13.
//  Copyright (c) 2013 Charimon. All rights reserved.
//

#import "WViewController.h"
#import "WStatusBar.h"
#import "WConstants.h"
#import "WCardViewController.h"
#import "WRestkitManager.h"
#import "WWeatherGroup.h"
#import "WLoader.h"
#import <TouchIndicatorView.h>

@interface WViewController ()
@property (strong, nonatomic) WStatusBar *statusBar;
@property (strong, nonatomic) WCardViewController *cardViewController;
@property (strong, nonatomic) WLocationManager * locationManger;

@end

@implementation WViewController

-(void) setupStatusBar {
    self.statusBar = [[WStatusBar alloc] init];
    self.statusBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusBar];
}

-(void) setupCardViewController {
    self.cardViewController = [[WCardViewController alloc] init];
    [self.view addSubview: self.cardViewController.view];
    [self addChildViewController:self.cardViewController];
    self.cardViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.locationManger = [[WLocationManager alloc] init];
    self.locationManger.delegate = self;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.locationManger stopUpdatingLocation];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.locationManger startUpdatingLocation];
    
    if(!self.statusBar) [self setupStatusBar];
    if(!self.cardViewController) [self setupCardViewController];
    
    ACP(self.view, self.statusBar, NSLayoutAttributeTop, NSLayoutRelationEqual, self.view, NSLayoutAttributeTop, 1.f, 0.f, UILayoutPriorityRequired);
    ACP(self.view, self.statusBar, NSLayoutAttributeLeading, NSLayoutRelationEqual, self.view, NSLayoutAttributeLeading, 1.f, 0.f, UILayoutPriorityRequired);
    ACP(self.view, self.statusBar, NSLayoutAttributeTrailing, NSLayoutRelationEqual, self.view, NSLayoutAttributeTrailing, 1.f, 0.f, UILayoutPriorityRequired);
    ACP(self.view, self.statusBar, NSLayoutAttributeHeight, NSLayoutRelationEqual, nil, NSLayoutAttributeNotAnAttribute, 0.f, 22.f, UILayoutPriorityRequired);
    
    ACP(self.view, self.cardViewController.view, NSLayoutAttributeTop, NSLayoutRelationEqual, self.statusBar, NSLayoutAttributeBottom, 1.f, 0.f, UILayoutPriorityRequired);
    ACP(self.view, self.cardViewController.view, NSLayoutAttributeLeading, NSLayoutRelationEqual, self.view, NSLayoutAttributeLeading, 1.f, 0.f, UILayoutPriorityRequired);
    ACP(self.view, self.cardViewController.view, NSLayoutAttributeTrailing, NSLayoutRelationEqual, self.view, NSLayoutAttributeTrailing, 1.f, 0.f, UILayoutPriorityRequired);
    ACP(self.view, self.cardViewController.view, NSLayoutAttributeBottom, NSLayoutRelationEqual, self.view, NSLayoutAttributeBottom, 1.f, 0.f, UILayoutPriorityRequired);
    
//    TouchIndicatorView* touch = [[TouchIndicatorView alloc] initWithSize:CGSizeMake(30.f,30.f) action:TouchActionTypeDragNorth];
//    touch.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:touch];
//    ACP(self.view, touch, NSLayoutAttributeCenterX, NSLayoutRelationEqual, self.view, NSLayoutAttributeCenterX, .5f, 0.f, UILayoutPriorityRequired);
//    ACP(self.view, touch, NSLayoutAttributeCenterY, NSLayoutRelationEqual, self.view, NSLayoutAttributeCenterY, 1.f, 0.f, UILayoutPriorityRequired);
//    ACP(self.view, touch, NSLayoutAttributeWidth, NSLayoutRelationEqual, nil, NSLayoutAttributeNotAnAttribute, 0.f, 30.f, UILayoutPriorityRequired);
//    ACP(self.view, touch, NSLayoutAttributeHeight, NSLayoutRelationEqual, nil, NSLayoutAttributeNotAnAttribute, 0.f, 30.f, UILayoutPriorityRequired);
//    [touch startAnimation];
}

- (void) viewDidAppear:(BOOL)animated {}
- (void)didReceiveMemoryWarning{ [super didReceiveMemoryWarning];}

- (UIStatusBarStyle)preferredStatusBarStyle{ return UIStatusBarStyleLightContent; }

#pragma mark - WLocationManagerDelgate
- (void)locationUpdate:(NSArray *)locations {}
- (void)locationError:(NSError *)error {
    //TODO: remove current weather icon
}
- (void) locationChanged:(CLLocation *)location {
    [WLoader getWeatherAtLocation:location WithCompletion:^(WWeatherGroup *weatherGroup) {
        self.cardViewController.weatherGroup = weatherGroup;
    } failure:^(NSError *error) {}];
}
- (void)pausedLocationUpdates {}
- (void)resumedLocationUpdates {}
#pragma mark - end WLocationManagerDelgate


static NSDictionary *bigWeatherImage = nil;
+(NSDictionary*) bigWeatherImage
{
    if(bigWeatherImage) return bigWeatherImage;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        bigWeatherImage = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:WWeatherTypeUndefined],@"395",
                    [NSNumber numberWithInt:WWeatherTypeUndefined],@"392",
                    nil];
    });
    
    return bigWeatherImage;
}


@end
