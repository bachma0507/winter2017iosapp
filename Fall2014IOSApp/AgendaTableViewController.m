//
//  AgendaTableViewController.m
//  Fall2013IOSApp
//
//  Created by Barry on 7/19/13.
//  Copyright (c) 2013 BICSI. All rights reserved.
//

#import "AgendaTableViewController.h"
#import "Fall2013IOSAppAppDelegate.h"
//#import "StackMob.h"
#import "AgendaCell.h"
#import "NotesViewController.h"
#import <AudioToolbox/AudioToolbox.h>



@interface AgendaTableViewController ()

@end

@implementation AgendaTableViewController
@synthesize sessionName, sessionId, location;
@synthesize tempDict;
@synthesize dateArray;

//
//- (NSManagedObjectContext *)managedObjectContext {
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate performSelector:@selector(managedObjectContext)]) {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self.tableView reloadData];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    //    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green"]];
    //    [tempImageView setFrame:self.tableView.frame];
    //
    //    self.tableView.backgroundView = tempImageView;
    
    
    NSUUID *id = [[UIDevice currentDevice] identifierForVendor];
    NSString *deviceID = [[NSString alloc] initWithFormat:@"%@",id];
    NSString *newDeviceID = [deviceID substringWithRange:NSMakeRange(30, [deviceID length]-30)];
    
    NSLog(@"Untruncated Device ID is: %@", deviceID);
    NSLog(@"Truncated Device ID is: %@", newDeviceID);
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl  = refreshControl;
    
    [refreshControl beginRefreshing];
    
    
    [self refreshTable];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //    if (tableView == self.tableView)
    //    {
    //        return [dateArray count];
    //    }
    
    return 1;
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    // Set the text color of our header/footer text.
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    [header.textLabel setTextColor:[UIColor blackColor]];
//    header.textLabel.textAlignment = NSTextAlignmentCenter;
//
//    // Set the background color of our header/footer.
//    header.contentView.backgroundColor = [UIColor colorWithRed:249/255.0 green:255/255.0 blue:235/255.0 alpha:1.0];;
//
//    // You can also do this to set the background color of our header/footer,
//    //    but the gradients/other effects will be retained.
//    // view.tintColor = [UIColor blackColor];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50.0f;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.objects count];
    
    //    NSString *strDate = [dateArray objectAtIndex:section];
    //    NSArray *dateSection = [tempDict objectForKey:strDate];
    //    return [dateSection count];
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (tableView == self.tableView)
//    {
//        return dateArray[section];
//    }
//
//    return @"";
//
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AgendaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[AgendaCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    NSManagedObject *object = [self.objects objectAtIndex:indexPath.row];
    //    NSString *strDate = [dateArray objectAtIndex:indexPath.section];
    //    NSMutableArray *dateSection = [tempDict objectForKey:strDate];
    //
    //    NSManagedObject *object = [dateSection objectAtIndex:indexPath.row];
    
    cell.sessionNameLabel.text = [object valueForKey:@"sessionname"];
    cell.sessionNameLabel.textColor = [UIColor redColor];
    cell.location.text = [object valueForKey:@"location"];
    cell.location.textColor = [UIColor colorWithRed:128/255.0 green:139/255.0 blue:150/255.0 alpha:1.0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate *date = (NSDate*) [object valueForKey:@"sessiondate"];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    
    cell.sessionDateLabel.text = stringDate;
    cell.sessionDateLabel.textColor = [UIColor blackColor];
    cell.sessionTimeLabel.text = [object valueForKey:@"sessiontime"];
    cell.sessionTimeLabel.textColor = [UIColor blackColor];
    
    //cell.textLabel.numberOfLines = 0;
    //cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row%2 == 0) {
//        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
//        cell.backgroundColor = altCellColor;
//    }
//}


- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    if(indexPath.row % 2 == 0){
        UIColor *altCellColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        cell.backgroundColor = altCellColor;
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];;
    }
}

- (void) refreshTable {
    NSUUID *id = [[UIDevice currentDevice] identifierForVendor];
    NSString *deviceID = [[NSString alloc] initWithFormat:@"%@",id];
    NSString *newDeviceID = [deviceID substringWithRange:NSMakeRange(30, [deviceID length]-30)];
    
    NSLog(@"Untruncated Device ID is: %@", deviceID);
    NSLog(@"Truncated Device ID is: %@", newDeviceID);
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessnotes" inManagedObjectContext:[[CoreDataHelper sharedHelper] context]];
    [fetchRequest setEntity:entity];
    
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"deviceowner == %@ && agenda == 'Yes'", newDeviceID]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT(sessionID CONTAINS 'GUES' || sessionID CONTAINS 'OD_') && agenda == 'Yes'"]];
    //NSError *error = nil;
    //NSArray *array = [self executeFetchRequest:fetchRequest error:&error];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sessiondate" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"starttime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *results = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
    
    if (!results || !results.count || results.count == 0) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        NSURL *fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/Modern/sms_alert_bamboo.caf"]; // see list below
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)fileURL,&soundID);
        AudioServicesPlaySystemSound(soundID);
        
        NSString *message = @"You have not added any items to your schedule. Please tap Add to Schedule when viewing Schedule or Session details. If you signed up for sessions or other items when you registered, please tap the Import button below to import your sessions.";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Notification"
                                                           message:message
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:@"Import",nil];
        alertView.tag = 1;
        [alertView show];
    }
    
    //    else {
    //
    //
    ////        [self.refreshControl endRefreshing];
    ////        self.objects = results;
    ////    NSLog(@"Results = %lu", (unsigned long)results.count);
    //
    //
    //    tempDict = nil;
    //    tempDict = [[NSMutableDictionary alloc] init];
    //
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //
    //    NSDate *date = (NSDate*) [[results objectAtIndex:0] valueForKey:@"sessiondate"];
    //
    //    NSString *stringDate = [dateFormatter stringFromDate:date];
    //
    //    NSLog(@"sessiondate is: %@", stringDate);
    //
    //    NSString *strPrevDate= stringDate;
    //    NSString *strCurrDate = nil;
    //    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    //    //Add the Similar Date data in An Array then add this array to Dictionary
    //    //With date name as a Key. It helps to easily create section in table.
    //    for(int i=0; i< [results count]; i++)
    //    {
    //
    //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //
    //        NSDate *date = (NSDate*) [[results objectAtIndex:i] valueForKey:@"sessiondate"];
    //
    //        NSString *stringDate2 = [dateFormatter stringFromDate:date];
    //
    //        strCurrDate = stringDate2;
    //
    //        if ([strCurrDate isEqualToString:strPrevDate])
    //        {
    //
    //            [tempArray addObject:[results objectAtIndex:i]];
    //        }
    //        else
    //        {
    //            [tempDict setValue:[tempArray copy] forKey:strPrevDate];
    //
    //            strPrevDate = strCurrDate;
    //            [tempArray removeAllObjects];
    //            [tempArray addObject:[results objectAtIndex:i]];
    //        }
    //    }
    //    //Set the last date array in dictionary
    //    [tempDict setValue:[tempArray copy] forKey:strPrevDate];
    //
    //    NSArray *tArray = [tempDict allKeys];
    //    //Sort the array in ascending order
    //    //dateArray = [tArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    //    //NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCompare:)];
    //    //dateArray = [tArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    //
    //    NSMutableArray *arrDate = [[NSMutableArray alloc]init];
    //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    //    for (int i = 0; i<tArray.count; i++) {
    //        [arrDate addObject:[dateFormat dateFromString:tArray[i]]];
    //        NSLog(@"%d", i);
    //    }
    //
    //
    //    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:YES];
    //    NSArray * newDateArray = [arrDate sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    //
    //    NSMutableArray * newStringArray = [[NSMutableArray alloc]init];
    //    NSDateFormatter *stringFormat = [[NSDateFormatter alloc] init];
    //    [stringFormat setDateStyle:NSDateFormatterMediumStyle];
    //    for (int i = 0; i<newDateArray.count; i++){
    //
    //        [newStringArray addObject:[stringFormat stringFromDate:newDateArray[i]]];
    //    }
    //
    //    dateArray = newStringArray;
    //
    //    NSLog(@"PRINT ARRAY %@", dateArray);
    //
    //
    //
    //
    //
    //
    //    }
    
    [self.refreshControl endRefreshing];
    self.objects = results;
    NSLog(@"Results = %lu", (unsigned long)results.count);
    
    [self.tableView reloadData];
}


//}


-(void)importBtnClick
{
    //write your code to prepare popview
    //[self.navigationController popViewControllerAnimated:YES];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) /* Device is iPad */
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"   bundle:nil];
        
        SubmitMemberIDViewController *smi = [storyboard instantiateViewControllerWithIdentifier:@"SubmitMemberID" ];
        
        [self presentViewController:smi animated:YES completion:NULL];
    }
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"   bundle:nil];
        
        SubmitMemberIDViewController *smi = [storyboard instantiateViewControllerWithIdentifier:@"SubmitMemberID" ];
        
        [self presentViewController:smi animated:YES completion:NULL];
        
        
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    if (alertView.tag ==1) {
        
        if (buttonIndex == 1) {
            
            [self importBtnClick];
            
        }
    }
}


- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        NSManagedObject *object = [self.objects objectAtIndex:indexPath.row];
        
        sessionId = [object valueForKey:@"sessionID"];
        
        NSManagedObjectContext *context = [[CoreDataHelper sharedHelper] context];
        
        [context deleteObject:[context objectWithID:[object objectID]]];
        
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        NSMutableArray *array = [self.objects mutableCopy];
        [array removeObjectAtIndex:indexPath.row];
        self.objects = array;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //////
        NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:context];
        [fetchRequest2 setEntity:entity2];
        
        [fetchRequest2 setPredicate:[NSPredicate predicateWithFormat:@"sessionID == %@", sessionId]];
        NSArray *results2 = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest2 error:nil];
        self.objects2 = results2;
        NSLog(@"Results Count is: %lu", (unsigned long)results2.count);
        if (!results2 || !results2.count){//start nested if block
            NSLog(@"No results2");}
        else{
            NSManagedObject *object = [results2 objectAtIndex:0];
            [object setValue:NULL forKey:@"planner"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                
            }
            
            NSLog(@"You updated a PLANNER to NULL object in Sessions");
            
            
            
        }
        /////
        
        
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"agendaDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [self.objects objectAtIndex:indexPath.row];
        self.sessionName = [object valueForKey:@"sessionname"];
        self.sessionId = [object valueForKey:@"sessionID"];
        self.location = [object valueForKey:@"location"];
        
        
        
        
        NotesViewController *destViewController = segue.destinationViewController;
        destViewController.title = self.sessionName;
        destViewController.sessionName = self.sessionName;
        destViewController.sessionId = self.sessionId;
        destViewController.location = self.location;
        
        
        
        
        NSLog(@"Session ID is %@", self.sessionId);
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessnotes" inManagedObjectContext:[[CoreDataHelper sharedHelper] context]];
    [fetchRequest setEntity:entity];
    
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"deviceowner == %@ && agenda == 'Yes'", newDeviceID]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT(sessionID CONTAINS 'GUES' || sessionID CONTAINS 'OD_') && agenda == 'Yes'"]];
    //NSError *error = nil;
    //NSArray *array = [self executeFetchRequest:fetchRequest error:&error];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sessiondate" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"starttime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *results = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
    
    [self.refreshControl endRefreshing];
    self.objects = results;
    
    [self.tableView reloadData];
}

- (IBAction)importBtnClicked:(id)sender {
    
    [self importBtnClick];
}
@end
