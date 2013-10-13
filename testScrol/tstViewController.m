//
//  tstViewController.m
//  testScrol
//
//  Created by Vincenzo Auteri on 10/13/13.
//  Copyright (c) 2013 Vincenzo Auteri. All rights reserved.
//

#import "tstViewController.h"

@interface tstViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation tstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.backgroundColor = [UIColor blueColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scroll.png"] highlightedImage:nil];
    [self.scrollView addSubview:imageView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillHideNotification object:nil];
    [self.textField setDelegate:self];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)onKeyboardShow:(NSNotification *)notification
{
   
    NSDictionary* info = [notification userInfo];
     NSLog(@"keyboard will show %@ ",[notification description]);
    CGFloat height = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        [self updateKeyboardConstraint:height height:height animationDuration:0.3];
     } else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]){
       [self updateKeyboardConstraint:0 height:-height animationDuration:0.3];
     }
}



- (void)updateKeyboardConstraint:(CGFloat)constraint height:(CGFloat)height animationDuration:(NSTimeInterval)duration {
     NSLog(@"constraint %f",self.bottomConst.constant );
    self.bottomConst.constant  = constraint;
    [self.view setNeedsUpdateConstraints];
    NSLog(@"update with height %f",height);
    NSLog(@"content offset %f",self.scrollView.contentOffset.y);
    NSLog(@"content height %f",self.scrollView.contentSize.height);
    //self.scrollView.contentOffset =  CGPointMake(0,0);
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
       [self.view setNeedsDisplay];
        self.scrollView.center=CGPointMake(self.scrollView.center.x, self.scrollView.center.y-height);
        self.textField.center=CGPointMake(self.scrollView.center.x, self.scrollView.center.y-height);
        
    } completion:^(BOOL fin) {
        [self logFinished:fin];
    }];
}
     
-(void)logFinished:(BOOL) finished
     {
         NSLog(@"content offset %f",self.scrollView.contentOffset.y);
         NSLog(@"content height %f",self.scrollView.contentSize.height);
         NSLog(@"frame height %f",self.scrollView.frame.size.height);
         NSLog(@"frame  origin %f",self.scrollView.frame.origin.y);

    }

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
