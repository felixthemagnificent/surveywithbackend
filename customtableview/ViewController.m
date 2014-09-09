//
//  ViewController.m
//  customtableview
//
//  Created by Felix on 8/28/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "CheckCell.h"
#import "RadioCell.h"
#import "AppDelegate.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,CheckBtn>
{
    
    NSMutableArray *checkCells;
    NSMutableArray *radioCells;
    NSInteger radioSelected;
    NSInteger checkSelected;
    NSDictionary *jsonData;
    NSInteger currentQuestion;
    NSMutableDictionary *toServer;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation ViewController

- (void)loadToTable:(NSDictionary *)questionSet
{
    NSDictionary *answers = questionSet[@"answers"];
    _questionLabel.text = questionSet[@"question"];
    
    if ([questionSet[@"type"] isEqualToString:@"check"]){
        radioCells = nil;
        checkCells = [NSMutableArray new];
        
        for (NSString *answer in answers){
            [checkCells addObject:answer];
        }
    } else {
        checkCells = nil;
        radioCells = [NSMutableArray new];
        
        for (NSString *answer in answers){
            [radioCells addObject:answer];
        }
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
	// Do any additional setup after loading the view, typically from a nib.
    radioSelected = 0;
    checkSelected = 0;
    toServer = [NSMutableDictionary new];
    NSString *strURL= [NSString stringWithFormat:@"http://107.170.9.119/api.json"];//Here is pass your json link
    
    NSURL *URL = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSLog(@"Json");
         jsonData = [NSDictionary new];
         jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
         if (error) {
             UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                              message:@"Error in JSON Data"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
             [alert show];
         }
         else
         {
             NSLog(@"%d primary arrays", [jsonData count]);
             
             currentQuestion = 1;
             NSLog(@"%@",jsonData);
             NSDictionary *questionSet = [jsonData objectForKey:[NSString stringWithFormat:@"q%d",currentQuestion]];
             [self loadToTable:questionSet];
             
         }
     } ];
    
}
-(void)checkBtn:(CheckCell *)cell andBtn:(UIButton *)btn
{
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    NSNumber *power_of_two = [NSNumber numberWithDouble:pow(2.0,indexPath.row)];
    NSLog(@"%d",power_of_two.intValue);
    CheckCell  *currentCell = (CheckCell *)[_tableView cellForRowAtIndexPath:indexPath];
    if ([btn isSelected]) {
        checkSelected += power_of_two.intValue;
    }
    else
    {
        checkSelected -= power_of_two.intValue;		
    }
    
}
- (void)addAnswerToDictionary
{
    NSMutableString *keyForAnswer;
    if (radioSelected > 0)
    {
        keyForAnswer = [NSMutableString stringWithFormat:@"radio_%ld",(long)radioSelected];
        NSLog(@"%@",keyForAnswer);

        [toServer setObject:[NSNumber numberWithInteger:radioSelected] forKey:keyForAnswer];
    }
    else if (checkSelected > 0)
    {
        keyForAnswer = [NSMutableString stringWithFormat:@"check_%ld",(long)checkSelected];
        [toServer setObject:[NSNumber numberWithInteger:checkSelected] forKey:keyForAnswer];
    }
}
- (NSString *)getUUID
{
    NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueID"];
    if (!UUID) {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        UUID = [(__bridge NSString*)string stringByReplacingOccurrencesOfString:@"-"withString:@""];
        [[NSUserDefaults standardUserDefaults] setValue:UUID forKey:@"uniqueID"];
    }
    return UUID;
}
- (void)sendPostData
{
    NSString *phoneId = [self getUUID];
    [toServer setValue:phoneId forKey:@"phoneID"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:toServer
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {

        
        NSURL *url = [NSURL URLWithString:@"http://107.170.9.119/api.json"];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"POST"];
        [req setValue:[NSString stringWithFormat:@"%d", jsonData.length] forHTTPHeaderField:@"Content-Length"];
        [req setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [req setHTTPBody:jsonData];
        
        NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:requestURL
                                           queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {

             if (error) {
                 UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                                  message:@"Error while uploading"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
                 [alert show];
             }
             else
             {
//                 NSLog(@"%d primary arrays", [jsonData count]);
//                 
//                 currentQuestion = 1;
//                 NSLog(@"%@",jsonData);
//                 NSDictionary *questionSet = [jsonData objectForKey:[NSString stringWithFormat:@"q%d",currentQuestion]];
//                 [self loadToTable:questionSet];
                 
             }
         } ];
        
    }
    
}
- (IBAction)nextButtonTap:(id)sender {
    if (radioSelected + checkSelected == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Questionnaire" message:@"Please make your choice" delegate:self
                                                 cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        [self addAnswerToDictionary];
        
        radioSelected = 0;
        checkSelected = 0;
        
        currentQuestion++;
        
        NSDictionary *questionSet = [jsonData objectForKey:[NSString stringWithFormat:@"q%d",currentQuestion]];
        if (!questionSet) {
            [self sendPostData];
            [self performSegueWithIdentifier:@"FinalScreen" sender:self];
        } else {
            [self loadToTable:questionSet];
        }
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return 2;
}
- (IBAction)processRadio:(UIButton *)sender {
    radioSelected = sender.tag;
    [self.tableView reloadData];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        CheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckCell"];
        NSNumber *power_of_two = [NSNumber numberWithDouble:pow(2.0,indexPath.row)];
        NSLog(@"%d",power_of_two.intValue);
        cell.checkButton.tag = power_of_two.intValue;
        NSLog(@"tag=%d",cell.checkButton.tag);
        cell.checkLabel.text = [checkCells objectAtIndex:indexPath.row];
        [cell setDelegate:self];
        return cell;
        
    } else if (indexPath.section==1)
    {
        RadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadioCell"];
        cell.radioLabel.text = [radioCells objectAtIndex:indexPath.row];
        cell.radioButton.tag = (indexPath.row+1);
       
        if (cell.radioButton.tag == radioSelected) {
            [cell.radioButton setSelected:YES];
        }
        else
        {
            [cell.radioButton setSelected:NO];
        }
         return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
    return [checkCells count];
    }
    else if (section == 1)
    {
        return [radioCells count];
    }
    else
        return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
