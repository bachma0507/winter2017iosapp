//
//  ConfSchedDetailTableViewController.m
//  Fall2013IOSApp
//
//  Created by Barry on 8/30/13.
//  Copyright (c) 2013 BICSI. All rights reserved.
//

#import "ConfSchedDetailTableViewController.h"
#import "Fall2013IOSAppAppDelegate.h"
#import <CoreData/CoreData.h>
#import "SessionsDetailViewController.h"
#import "NSDate+TimeStyle.h"


@interface ConfSchedDetailTableViewController ()

@end

@implementation ConfSchedDetailTableViewController
@synthesize myObjects;
@synthesize cschedule, mySessions, is24h;

@synthesize tempDict;
@synthesize startTimeArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (NSManagedObjectContext *)managedObjectContext
//{
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//
//    if ([delegate performSelector:@selector(managedObjectContext)])
//    {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = cschedule.date;
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    //    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green"]];
    //    [tempImageView setFrame:self.tableView.frame];
    //
    //    self.tableView.backgroundView = tempImageView;
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //self.refreshControl  = refreshControl;
    
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
    //return 1;
    
    if (tableView == self.tableView)
    {
        
        
        return [startTimeArray count]; //replacing 'return 1' to implement Start Time Section
        
        
    }
    
    return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Set the text color of our header/footer text.
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
    
    // Set the background color of our header/footer.
    header.contentView.backgroundColor = [UIColor colorWithRed:214/255.0 green:219/255.0 blue:223/255.0 alpha:1.0];;
    
    // You can also do this to set the background color of our header/footer,
    //    but the gradients/other effects will be retained.
    // view.tintColor = [UIColor blackColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //return 50.0f;
    return 30.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    //return self.myObjects.count;
    
    //below replaces 'return self.myObjects.count' to implement Start Time Section
    NSString *strStartTime = [startTimeArray objectAtIndex:section];
    NSArray *startTimeSection = [tempDict objectForKey:strStartTime];
    return [startTimeSection count];
}

//below used to implement Start Time Section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return startTimeArray[section];
        
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"confSchedDetailCell";
    
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    confSchedDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //cell.backgroundColor = [UIColor colorWithRed:130/255.0 green:171/255.0 blue:50/255.0 alpha:1.0];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (!cell)
    {
        cell = [[confSchedDetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if (tableView == self.tableView)
    {
        
        //NSManagedObject *object = [self.myObjects objectAtIndex:indexPath.row];
        
        NSString *strStartTime = [startTimeArray objectAtIndex:indexPath.section]; //used to implement Start TIme Section
        NSMutableArray *startTimeSection = [tempDict objectForKey:strStartTime]; //used to implement Start TIme Section
        
        NSManagedObject *object = [startTimeSection objectAtIndex:indexPath.row]; //used to implement Start TIme Section and replaces 'NSManagedObject *object = [self.myObjects objectAtIndex:indexPath.row]'
        
        cell.sessionName.text = [object valueForKey:@"sessionName"];
        cell.sessionLocation.text = [object valueForKey:@"location"];
        
        NSString * planner = [NSString stringWithFormat:@"%@", [object valueForKey:@"planner"]];
        
        if ([planner isEqualToString:@"Yes"]) {
            
            cell.sessionName.textColor = [UIColor redColor];
            
            UIImage * myImage = [UIImage imageNamed:@"star_red_120.png"];
            
            [cell.starUnSel setImage:myImage];
            
        }
        else{
            
            //cell.sessionName.textColor = [UIColor colorWithRed:30/255.0 green:37/255.0 blue:89/255.0 alpha:1.0];
            cell.sessionName.textColor = [UIColor colorWithRed:30/255.0 green:37/255.0 blue:89/255.0 alpha:1.0];
            
            UIImage * myImage2 = [UIImage imageNamed:@"transparent.png"];
            
            [cell.starUnSel setImage:myImage2];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"MM/dd/yy hh:mm"];
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        NSDate *time = (NSDate*) [object valueForKey:@"startTime"];
        
        NSString *stringTime = [dateFormatter stringFromDate:time];
        
        NSLog(@"Session Start Time is: %@", stringTime);
        
        NSDate * sTime = [object valueForKey:@"startTime"];
        NSDate * eTime = [object valueForKey:@"endTime"];
        
        
        // set the formatter like this
        NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
        [sdf setDateStyle:NSDateFormatterNoStyle];
        [sdf setTimeStyle:NSDateFormatterShortStyle];
        
        // set the formatter like this
        NSDateFormatter *edf = [[NSDateFormatter alloc] init];
        [edf setDateStyle:NSDateFormatterNoStyle];
        [edf setTimeStyle:NSDateFormatterShortStyle];
        
        NSString * sessionTime = [[NSString alloc] initWithFormat:@"%@ - %@", [NSDate stringFromTime:sTime], [NSDate stringFromTime:eTime]];
        
        cell.sessionTime.text = sessionTime;
        cell.sessionTime.textColor = [UIColor blackColor];
        cell.sessionLocation.textColor = [UIColor colorWithRed:128/255.0 green:139/255.0 blue:150/255.0 alpha:1.0];
        cell.itscecs.hidden = YES;
        //cell.sessionStatus.hidden = YES;
        //}
        //cell.sessionStatus.text = [object valueForKey:@"sessionStatus"];
        
        //    NSString *itscecsStr = [[NSString alloc] initWithFormat:@"%@",[object valueForKey:@"itscecs"]];
        //    if ([itscecsStr isEqual: @"3"]) {
        //        cell.itscecs.text = @"ITS CECs: 3";
        //    }
        //    else if([itscecsStr isEqual: @"6"]){
        //        cell.itscecs.text = @"ITS CECs: 6";
        //    }
        //    else{
        //    cell.itscecs.text = @" ";
        //    }
        
        //cell.itscecs.text =[object valueForKey:@"itscecs"];
        //cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
        //cell.textLabel.font = [UIFont fontWithName:@"Arial-Bold" size:10.0];
        //cell.textLabel.font = [UIFont systemFontOfSize:11.0];
        //cell.textLabel.textColor = [UIColor brownColor];
        
        //cell.textLabel.numberOfLines = 0;
        //cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        // Configure the cell...
        
    }
    
    return cell;
    
}

-(void)refreshTable{
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:[[CoreDataHelper sharedHelper] context]];
    
    [fetchRequest setEntity:entity];
    
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT(sessionID CONTAINS 'EXHV' || sessionID CONTAINS 'EXHX' || sessionID CONTAINS 'DRIN' || sessionID CONTAINS 'BADG' || sessionID CONTAINS 'CRED_H' || sessionID CONTAINS 'FTA' || sessionID CONTAINS 'GUES' || sessionID CONTAINS 'NEW_' || sessionID CONTAINS 'GS_TUESA' || sessionID CONTAINS 'GS_TUESP' || sessionID CONTAINS 'GS_THURA' || sessionID CONTAINS 'OD_') && sessionDate == %@",cschedule.trueDate]];
    
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT(sessionID CONTAINS 'BODMC')"]];
    
    
    NSLog(@"cshedule date in refreshtable is: %@",cschedule.date);
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSArray *myResults = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
    
    self.myObjects = myResults;
    
    if (!myResults || !myResults.count){
        NSLog(@"No results!");
    }
    else{
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                            init];
        
        [refreshControl endRefreshing];
        self.myObjects = myResults;
        
        ////START below is implemented for Start Time Section
        tempDict = nil;
        tempDict = [[NSMutableDictionary alloc] init];
        
        NSDateFormatter *timeFormatter1 = [[NSDateFormatter alloc] init];
        [timeFormatter1 setDateFormat:@"hh:mm a"];
        
        NSDate *time1 = (NSDate*) [[myResults objectAtIndex:0] valueForKey:@"startTime"];
        
        NSString *stringStartTime = [timeFormatter1 stringFromDate:time1];
        
        //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        //NSDate *date = (NSDate*) [[myResults objectAtIndex:0] valueForKey:@"sessionDate"];
        
        //NSString *stringDate = [dateFormatter stringFromDate:date];
        
        NSLog(@"sessionStartTime is: %@", stringStartTime);
        
        NSString *strPrevStartTime= stringStartTime;
        NSString *strCurrStartTime = nil;
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        //Add the Similar Date data in An Array then add this array to Dictionary
        //With date name as a Key. It helps to easily create section in table.
        for(int i=0; i< [myResults count]; i++)
        {
            
            //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            
            //NSDate *date = (NSDate*) [[myResults objectAtIndex:i] valueForKey:@"sessionDate"];
            
            //NSString *stringDate2 = [dateFormatter stringFromDate:date];
            
            NSDateFormatter *timeFormatter1 = [[NSDateFormatter alloc] init];
            [timeFormatter1 setDateFormat:@"hh:mm a"];
            
            NSDate *time1 = (NSDate*) [[myResults objectAtIndex:i] valueForKey:@"startTime"];
            
            NSString *stringStartTime2 = [timeFormatter1 stringFromDate:time1];
            
            strCurrStartTime = stringStartTime2;
            
            if ([strCurrStartTime isEqualToString:strPrevStartTime])
            {
                
                [tempArray addObject:[myResults objectAtIndex:i]];
            }
            else
            {
                [tempDict setValue:[tempArray copy] forKey:strPrevStartTime];
                
                strPrevStartTime = strCurrStartTime;
                [tempArray removeAllObjects];
                [tempArray addObject:[myResults objectAtIndex:i]];
            }
        }
        //Set the last date array in dictionary
        [tempDict setValue:[tempArray copy] forKey:strPrevStartTime];
        
        NSArray *tArray = [tempDict allKeys];
        NSLog(@"PRINT tARRAY %@", tArray);
        //Sort the array in ascending order
        //startTimeArray = [tArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSMutableArray *arrTime = [[NSMutableArray alloc]init];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"hh:mm a"];
        for (int i = 0; i<tArray.count; i++) {
            [arrTime addObject:[timeFormat dateFromString:tArray[i]]];
            NSLog(@"%d", i);
        }
        
        //NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        //NSArray * newTimeArray = [arrTime sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:YES];
        NSArray * newTimeArray = [arrTime sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSMutableArray * newStringArray = [[NSMutableArray alloc]init];
        NSDateFormatter *stringFormat = [[NSDateFormatter alloc] init];
        [stringFormat setDateFormat:@"hh:mm a"];
        for (int i = 0; i<newTimeArray.count; i++){
            
            [newStringArray addObject:[stringFormat stringFromDate:newTimeArray[i]]];
        }
        
        startTimeArray = newStringArray;
        
        NSLog(@"PRINT ARRAY %@", startTimeArray);
        //NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCompare:)];
        //dateArray = [tArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        
        ////END above is implemented for Start Time Section
        
        [self.tableView reloadData]; //add this here to implement Start Time Section instead of below
        
    }
    
    //[self.tableView reloadData];
    
}


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

- (void)viewDidAppear:(BOOL)animated
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:[[CoreDataHelper sharedHelper] context]];
    
    [fetchRequest setEntity:entity];
    
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT(sessionID CONTAINS 'EXHV' || sessionID CONTAINS 'EXHX' || sessionID CONTAINS 'DRIN' || sessionID CONTAINS 'BADG' || sessionID CONTAINS 'CRED_H' || sessionID CONTAINS 'FTA' || sessionID CONTAINS 'GUES' || sessionID CONTAINS 'NEW_' || sessionID CONTAINS 'GS_TUESA' || sessionID CONTAINS 'GS_TUESP' || sessionID CONTAINS 'GS_THURA' || sessionID CONTAINS 'OD_') && sessionDate == %@",cschedule.trueDate]];
    
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT(sessionID CONTAINS 'BODMC')"]];
    
    
    NSLog(@"cshedule date in refreshtable is: %@",cschedule.date);
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSArray *myResults = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
    
    self.myObjects = myResults;
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    
    [refreshControl endRefreshing];
    self.myObjects = myResults;
    
    [self.tableView reloadData];
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sessionsDetailCell"])
    {
        
        
        //NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        //SessionsDetailViewController *destViewController = segue.destinationViewController;
        //destViewController.mySessions = [self.myObjects objectAtIndex:indexPath.row];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *strStartTime = [startTimeArray objectAtIndex:indexPath.section];
        NSMutableArray *startTimeSection = [tempDict objectForKey:strStartTime];
        
        SessionsDetailViewController *destViewController = segue.destinationViewController;
        destViewController.mySessions = [startTimeSection objectAtIndex:indexPath.row];
        
    }
    
}



#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

@end
