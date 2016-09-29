//
//  StartViewController.m
//  FileService
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2014 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

#import "StartViewController.h"
#import "Backendless.h"
#import "ImagePreviewViewController.h"

@interface StartViewController ()
-(void)showAlert:(NSString *)message;
@end

@implementation StartViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    BackendlessUser *currentUser;
    currentUser = backendless.userService.currentUser;
    NSLog(@"The current user is: %@", currentUser);
    
    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

- (void)takePhoto:(id)sender
{

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
//        picker.showsCameraControls = YES;
//    }
//    else
//    {
//        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    }
//    [self presentViewController:picker animated:YES completion:^{}];
}

- (IBAction)uploadPhoto:(id)sender {
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

- (IBAction)logout:(id)sender {
    [self userLogout];
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        ImagePreviewViewController *imgPreview = [[self storyboard] instantiateViewControllerWithIdentifier:@"ImagePreviewViewController"];
        imgPreview.mainImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.navigationController pushViewController:imgPreview animated:YES];
    }];  
}

-(void)userLogout
{
    Responder *responder = [Responder responder:self
                             selResponseHandler:@selector(responseHandler:)
                                selErrorHandler:@selector(errorHandler:)];
    [backendless.userService logout:responder];
}

-(id)responseHandler:(id)response;
{
    BOOL result = (response != nil);
    if (result == TRUE){
        [self performSegueWithIdentifier:@"LogoutSuccess" sender:self];
    };
    return response;
}

-(void)errorHandler:(Fault *)fault
{
    NSLog(@"FAULT = %@ <%@>", fault.message, fault.detail);
}
@end
