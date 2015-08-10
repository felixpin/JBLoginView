//
//  JBLoginViewController.m
//  Pods
//
//  Created by Bartel on 30.07.15.
//
//

#import "JBLoginViewController.h"
#import <VISPER/UIViewController+VISPER.h>
#import <PureLayout/PureLayout.h>

@interface JBLoginViewController ()
@property BOOL isMovedUp;
@property double keyboardHeight;
@end

@implementation JBLoginViewController
@dynamic view;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil
                        bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.view.usernameField.delegate = self;
    self.view.passwordField.delegate = self;
    
    self.view.titleLabel.text = @"Ein kurzer Spruch zur Begrüßung";
    self.view.subTitleLabel.text = @"Und ein witziger Untertitel!";
    
    [self.view setNeedsUpdateConstraints];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


-(IBAction)forgotPassword:(id)sender{
    [self notifyPresentersOfView:self.view
                       withEvent:[self.visperServiceProvider createEventWithName:@"forgotPasswordButtonPressed"
                                                                          sender:self
                                                                            info:nil]];
}

-(IBAction)loginAction:(id)sender{
    [self notifyPresentersOfView:self.view
                       withEvent:[self.visperServiceProvider createEventWithName:@"loginButtonPressed"
                                                                          sender:self
                                                                            info:nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#define kOFFSET_FOR_KEYBOARD 120.0

-(void)keyboardWillShow:(NSNotification*)notification {

    
    self.keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide:(NSNotification*)notification {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField==self.view.passwordField){
        [textField resignFirstResponder];
        [self loginAction:textField];
    }else{
        [self.view.passwordField becomeFirstResponder];
    }
    return YES;
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    
    if(self.isMovedUp == movedUp){
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= self.keyboardHeight;
        rect.size.height += self.keyboardHeight;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += self.keyboardHeight;
        rect.size.height -= self.keyboardHeight;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
    self.isMovedUp = movedUp;
}

-(NSString*)username{
    return self.view.usernameField.text;
}

-(NSString*)password{
    return self.view.usernameField.text;
}






@end
