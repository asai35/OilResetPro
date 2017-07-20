//
//  IntroPageViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//
//

#import "IntroPageViewController.h"

@interface IntroPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    UIButton *leftButton, *rightButton;
    UIPageControl *pageControl;
}
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation IntroPageViewController

@synthesize PageViewController,arrPageTitles,arrPageImages;

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrPageTitles = @[@"Onboard", @"Onboard 2",@"Onboard 3"];
    arrPageImages =@[@"onboard1",@"onboard2",@"onboard3"];

    [self setTitle:arrPageTitles[0]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageNamed:@"ic_menu"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:button];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem=barButton;

    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 32, 32);
    [leftButton setImage:[UIImage imageNamed:@"ic_arrow_left"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightbar1=[[UIBarButtonItem alloc] init];
    [rightbar1 setCustomView:leftButton];

    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    [rightButton setImage:[UIImage imageNamed:@"ic_arrow_right"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightbar2=[[UIBarButtonItem alloc] init];
    [rightbar2 setCustomView:rightButton];
    self.navigationItem.rightBarButtonItems = @[rightbar2, rightbar1];
    // Create page view controller
    self.PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.PageViewController.dataSource = (id)self;
    
    IntroScreenViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.PageViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    [self addChildViewController:PageViewController];
    [self.view addSubview:PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];
    pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.backgroundColor = [UIColor clearColor];
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;

    NSDictionary *transitionData = self.transitions.all[3];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        self.slidingViewController.delegate = nil;
    } else {
        self.slidingViewController.delegate = transition;
    }

    NSString *transitionName = transitionData[@"name"];
    if ([transitionName isEqualToString:METransitionNameDynamic]) {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
        self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
        self.slidingViewController.customAnchoredGestures = @[];
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }

}

#pragma mark - Properties

- (METransitions *)transitions {
    if (_transitions) return _transitions;

    _transitions = [[METransitions alloc] init];

    return _transitions;
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;

    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];

    return _dynamicTransitionPanGesture;
}

- (void)actionMenu:(id)sender{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
- (void) leftButtonClick:(id)sender{
    if (((IntroScreenViewController *)self.PageViewController.viewControllers.lastObject).pageIndex == 0){
        IntroScreenViewController *startingViewController = [self viewControllerAtIndex:2];
        NSArray *viewControllers = @[startingViewController];
        [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }else if (((IntroScreenViewController *)self.PageViewController.viewControllers.lastObject).pageIndex == 1){
        IntroScreenViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }else{
        IntroScreenViewController *startingViewController = [self viewControllerAtIndex:1];
        NSArray *viewControllers = @[startingViewController];
        [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }

}

- (void) rightButtonClick:(id)sender{

    if (((IntroScreenViewController *)self.PageViewController.viewControllers.lastObject).pageIndex == 0){
        IntroScreenViewController *startingViewController = [self viewControllerAtIndex:1];
        NSArray *viewControllers = @[startingViewController];
        [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }else if (((IntroScreenViewController *)self.PageViewController.viewControllers.lastObject).pageIndex == 1){
        IntroScreenViewController *startingViewController = [self viewControllerAtIndex:2];
        NSArray *viewControllers = @[startingViewController];
        [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }else{
        IntroScreenViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
//    if ([pageControl currentPage] >= ([self.arrPageTitles count] - 1)) {
//        IntroScreenViewController *startingViewController = [self viewControllerAtIndex:0];
//        NSArray *viewControllers = @[startingViewController];
//        [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    }else{
//        IntroScreenViewController *startingViewController = [self viewControllerAtIndex:[pageControl currentPage] + 1];
//        NSArray *viewControllers = @[startingViewController];
//        [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]]) {
        MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)self.slidingViewController.delegate;
        if (!self.dynamicTransitionPanGesture) {
            self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
        }
        
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Page View Datasource Methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroScreenViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound))
    {
        index = 3;
//        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroScreenViewController*) viewController).pageIndex;
    
    if (index == NSNotFound)
    {
        index = -1;

//        return nil;
    }
    
    index++;
    if (index == [self.arrPageTitles count])
    {
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        if (![de objectForKey:@"isFirst"]) {
            [de setObject:@"true" forKey:@"isFirst"];
            [appdelegate().menuController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            [appdelegate().menuController tableView:appdelegate().menuController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNav"];
            [self.slidingViewController resetTopViewAnimated:YES];

        }
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - Other Methods
- (IntroScreenViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.arrPageTitles count] == 0) || (index >= [self.arrPageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    IntroScreenViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroScreenViewController"];
    pageContentViewController.imgFile = self.arrPageImages[index];
    [pageContentViewController setTitle: self.arrPageTitles[index]];
    pageContentViewController.pageIndex = index;
    [pageControl setCurrentPage:index];
    return pageContentViewController;
}

#pragma mark - No of Pages Methods
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.arrPageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (IBAction)btnStartAgain:(id)sender
{
    IntroScreenViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}
@end
