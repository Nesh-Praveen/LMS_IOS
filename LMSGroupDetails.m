//
//  LMSGroupDetails.m
//  LMSApp
//
//  Created by praveen on 22/10/15.
//  Copyright © 2015 Nesh. All rights reserved.
//

#define groupDetailCell              @"groupDetailCell"
#define groupProfileCell             @"groupProfileCell"


#import "LMSGroupDetails.h"
// 
#import "LMSCommon.h"
#import "LMSConstants.h"
#import "LMSMyCourseCustomCell.h"
#import "LMSGroupDetailCell.h"
#import "LMSGroupProfileCell.h"
#import "LMSCommntView.h"
@interface LMSGroupDetails (){

    __weak IBOutlet UIImageView *coverImg;
    __weak IBOutlet UIImageView *coverProfImg;
    NSString *activeGpid;
    __weak IBOutlet UITableView *groupDetailTable;
    UIImageView *imageViewForImage;
    NSMutableArray *groupActivityContainer;
    NSMutableArray *postedCommontContainer;
    UILabel *likecount_lbl;
    NSMutableArray *tempArray;
    UITextView *commonTxtView;
    __weak IBOutlet UILabel *createdNameLbl;
    LMSCommntView *commntPop;
}

@end

@implementation LMSGroupDetails
@synthesize groupID;
#pragma mark -
#pragma mark  viewlifeCycle
#pragma mark -

- (void)viewDidLoad {
  
    [super viewDidLoad];
    tempArray  = [[NSMutableArray  alloc]init];
    activityIndicater = [[POAcvityView alloc]initWithTitle:nil message:keyWAIT];
    [activityIndicater showView];
     NSString *groupdetService = [NSString stringWithFormat:kLMS_group_details,[LMSCommon getUserid],groupID];
     Parssing *parsVc = [Parssing new];
     parsVc.delegate = (id)self;
     [parsVc passUrl:groupdetService andTag:tagGroupDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -
#pragma mark  Actiom Methods
#pragma mark -
- (IBAction)coverCamereBtnTapped:(id)sender {
    
}
- (IBAction)profileCamereBtnTapped:(id)sender {
    
}
- (IBAction)profileImgTapped:(id)sender {
}


#pragma mark -
#pragma mark  Parser Delegate
#pragma mark -

- (void)FinishParssingUrl:(NSData *)userData tagValue:(NSString *)isTag{
    
    if ([isTag isEqualToString:tagGroupDetails]) {
        
        NSDictionary *respondData = [NSJSONSerialization JSONObjectWithData:userData options:0 error:nil];
        NSString *stauts = [respondData objectForKey:kLMSStatus];
        if ([stauts isEqualToString:kLMS_Status_0]) {

            groupActivityContainer = [[NSMutableArray alloc] init];
          
            coverImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[respondData objectForKey:kLMSdata] objectForKey:kLMS_activity_group_cover_image]]]];
            coverProfImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[respondData objectForKey:kLMSdata] objectForKey:kLMS_activity_group_thumb_image]]]];
         NSString *str = [LMSCommon stringByStrippingHTML:[[respondData objectForKey:kLMSdata] objectForKey:kLMS_activity_group_createdby]];
            createdNameLbl.text = str;
            groupActivityContainer = [NSMutableArray arrayWithArray:[[respondData objectForKey:kLMSdata]objectForKey:kLMS_activity_group_activities]];
            
           
    }
     [groupDetailTable reloadData];
     [activityIndicater hideView];
}
}


#pragma mark -
#pragma mark  Action Method
#pragma mark -

- (IBAction)menuBtnTapped:(id)sender {
    
 //   [[NSNotificationCenter defaultCenter] postNotificationName:@"DEMOLeftMenuViewController" object:nil];
  //  [self presentLeftMenuViewController:nil];
}
- (BOOL) shouldAllowMenu
{
    return YES;
}

- (IBAction)backBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark  TableView Delegate Data Source
#pragma mark -

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, groupDetailTable.frame.size.width, 220.0)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:237.0 / 255.0
                                                        green:237.0 / 255.0
                                                         blue:237.0 / 255.0
                                                        alpha:1.0];
 //profile Img
   UIImageView *activity_posted_img =[[UIImageView alloc] initWithFrame:CGRectMake(15.0,4.0,40.0,40.0)];
   NSString *profileImg = [LMSCommon stringByStrippingHTML:[[groupActivityContainer objectAtIndex:section] objectForKey:kLMS_activity_posted_by_thumb]];
   activity_posted_img.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImg]]];
   activity_posted_img.layer.cornerRadius = activity_posted_img.frame.size.width / 2;
   activity_posted_img.clipsToBounds = YES;
   [sectionHeaderView addSubview:activity_posted_img];
   
  //Profile Stream name lbl
    UILabel *ativity_stream_title_lbl = [[UILabel alloc] initWithFrame:
                            CGRectMake(70.0, 2, sectionHeaderView.frame.size.width-80,40.0)];
    [ativity_stream_title_lbl setNumberOfLines:2];
    [ativity_stream_title_lbl setLineBreakMode:NSLineBreakByCharWrapping];
    ativity_stream_title_lbl.backgroundColor = [UIColor clearColor];
    [ativity_stream_title_lbl setTextColor:[UIColor blackColor]];
    ativity_stream_title_lbl.textAlignment = NSTextAlignmentLeft;
    [ativity_stream_title_lbl setFont:[UIFont fontWithName:kLMS_Helvetica size:12.0]];
    ativity_stream_title_lbl.text = [LMSCommon stringByStrippingHTML:[[groupActivityContainer objectAtIndex:section] objectForKey:kLMS_activity_stream_title]];
    [sectionHeaderView addSubview:ativity_stream_title_lbl];
  
    //Aleart
    
    UIButton *alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alertBtn.frame = CGRectMake(groupDetailTable.frame.size.width-35,30,25,20);
    [alertBtn setTitle:@"" forState:UIControlStateNormal];
    [alertBtn setBackgroundColor:[UIColor clearColor]];
    alertBtn.tag = section;
    [alertBtn addTarget:self action:@selector(alertBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [alertBtn setImage:[UIImage imageNamed:@"alert2x.png"] forState:UIControlStateNormal];
    [sectionHeaderView addSubview:alertBtn];
    
    
    //profile Cover img
    
    UIImageView *stream_content_thumb_img =[[UIImageView alloc] initWithFrame:CGRectMake(3.0,alertBtn.frame.origin.y+alertBtn.frame.size.height,groupDetailTable.frame.size.width,84.0)];
  
    
    NSDictionary *dict = [[groupActivityContainer objectAtIndex:section] objectForKey:kLMS_activity_stream_content];
    if (dict != nil && [dict isKindOfClass:[NSDictionary class]]) {
   
        
        NSArray *stremArray = [dict objectForKey:kLMS_stream];
        NSString *streamThum = [[stremArray objectAtIndex:0] objectForKey:kLMS_stream_content_thumb];
        NSString *tempImg =    [LMSCommon stringByStrippingHTML:streamThum];
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
         
            UIImage *img =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempImg]]];
            UIGraphicsBeginImageContext(CGSizeMake(1,1));
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), [img CGImage]);
            UIGraphicsEndImageContext();
            dispatch_sync(dispatch_get_main_queue(), ^{
                [stream_content_thumb_img setImage: img];
            });
        });
        
        
      //  stream_content_thumb_img.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempImg]]];
        [sectionHeaderView addSubview:stream_content_thumb_img];
    
    
    
    }
    else{
    
      
    }
    
   
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.frame = CGRectMake(groupDetailTable.frame.origin.x+10,stream_content_thumb_img.frame.origin.y+stream_content_thumb_img.frame.size.height+4,25,25);
    [likeBtn setTitle:@"" forState:UIControlStateNormal];
    [likeBtn setBackgroundColor:[UIColor clearColor]];
    likeBtn.tag = section;
    [likeBtn addTarget:self action:@selector(likeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
  //  [likeBtn setImage:[UIImage imageNamed:@"heart2x.png"] forState:UIControlStateNormal];
    [sectionHeaderView addSubview:likeBtn];
   
    NSString *likeCheck;
    NSDictionary *likeunStatus = [[groupActivityContainer objectAtIndex:section]objectForKey:kLMS_activity_stream_action];
    if (likeunStatus !=0 && [likeunStatus isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *likeStDict = [likeunStatus objectForKey:kLMS_likeunlike];
        likeCheck = [likeStDict objectForKey:kLMS_like_status];
        if ([likeCheck isEqualToString:kLMS_unliked]) {
         
            [likeBtn setImage:[UIImage imageNamed:@"heart_dislike.png"] forState:UIControlStateNormal];
        }
        else{
               [likeBtn setImage:[UIImage imageNamed:@"heart2x.png"] forState:UIControlStateNormal];
        }
    }
    else{
        
        likeCheck = @"";
    }
   
    //Like Lable
 //   NSLog(@"like count %@",[[[[groupActivityContainer objectAtIndex:section] objectForKey:kLMS_activity_stream_action] objectForKey:kLMS_likeunlike] objectForKey:kLMS_like_cid]);
//    NSString *linkCount = [[[[groupActivityContainer objectAtIndex:section] objectForKey:kLMS_activity_stream_action] objectForKey:kLMS_likeunlike] objectForKey:kLMS_like_cid];
//
    NSString *likeCount;
    NSDictionary *likeDict = [[groupActivityContainer objectAtIndex:section]objectForKey:kLMS_activity_stream_action];
    if (likeDict !=0 && [dict isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *likeDict1 = [likeDict objectForKey:kLMS_likedusers];
        likeCount = [likeDict1 objectForKey:kLMS_total_liked];
       
    }
    
    else{
        
       likeCount = @"0";
    }
    
    likecount_lbl = [[UILabel alloc] initWithFrame:
                                         CGRectMake(likeBtn.frame.origin.x+likeBtn.frame.size.width+10, stream_content_thumb_img.frame.origin.y+stream_content_thumb_img.frame.size.height+6,100,20.0)];
    likecount_lbl.tag= section;
    likecount_lbl.backgroundColor = [UIColor clearColor];
    [likecount_lbl setTextColor:[UIColor blackColor]];
    likecount_lbl.textAlignment = NSTextAlignmentLeft;
    [likecount_lbl setFont:[UIFont fontWithName:kLMS_Helvetica size:12.0]];
    likecount_lbl.text = [NSString stringWithFormat:@"%@ likes",likeCount];
    [sectionHeaderView addSubview:likecount_lbl];
    
    
  //commont btn
    UIButton *commontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commontBtn.frame = CGRectMake(groupDetailTable.frame.size.width-90,stream_content_thumb_img.frame.origin.y+stream_content_thumb_img.frame.size.height+6,20,20);
    [commontBtn setTitle:@"" forState:UIControlStateNormal];
    [commontBtn setBackgroundColor:[UIColor clearColor]];
    commontBtn.tag = section;
    [commontBtn addTarget:self action:@selector(commontBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [commontBtn setImage:[UIImage imageNamed:@"comment2x.png"] forState:UIControlStateNormal];
    [sectionHeaderView addSubview:commontBtn];
    
    //Share Btn
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(groupDetailTable.frame.size.width-35,stream_content_thumb_img.frame.origin.y+stream_content_thumb_img.frame.size.height+6,20,20);
    [shareBtn setTitle:@"" forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:[UIColor clearColor]];
    shareBtn.tag = section;
    [shareBtn addTarget:self action:@selector(shareBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [sectionHeaderView addSubview:shareBtn];
    
    //Textfiled Bg Image
    
    UIImageView *txtBg_img =[[UIImageView alloc] initWithFrame:CGRectMake(0.0,likeBtn.frame.origin.y+likeBtn.frame.size.height+2,groupDetailTable.frame.size.width,35.0)];
    [txtBg_img setBackgroundColor:[UIColor lightGrayColor]];
    //stream_content_thumb_img.frame.origin.y+stream_content_thumb_img.frame.size.height+4
    //commentTxt Field
    [sectionHeaderView addSubview:txtBg_img];
//   UITextField *commontTxtField = [[UITextField alloc] initWithFrame:CGRectMake(txtBg_img.frame.origin.x+6,txtBg_img.frame.origin.y+3, txtBg_img.frame.size.width-50,36)];
//    
/*    UITextField *commontTxtField = [[UITextField alloc] initWithFrame:CGRectMake(txtBg_img.frame.origin.x+10,5.0,txtBg_img.frame.size.width-75,25.0)];
   commontTxtField.font = [UIFont fontWithName:kLMS_Helvetica size:12];
   commontTxtField.backgroundColor=[UIColor whiteColor];
   commontTxtField.placeholder = @"Type your comments";
    commontTxtField.delegate = (id)self;
    commontTxtField.tag = section;
   [txtBg_img addSubview:commontTxtField];

    
    commonTxtView = [[UITextView alloc] initWithFrame:CGRectMake(txtBg_img.frame.origin.x+10,5.0,txtBg_img.frame.size.width-75,25.0)];
    commonTxtView.font = [UIFont fontWithName:kLMS_Helvetica size:12];
    commonTxtView.backgroundColor=[UIColor whiteColor];
    commonTxtView.delegate = (id)self;
    commonTxtView.tag = section;
    [txtBg_img addSubview:commonTxtView];

    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(txtBg_img.frame.size.width-60,5.0,55.0,25.0);
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [sendBtn setBackgroundColor:[UIColor clearColor]];
   
    sendBtn.tag = section;
    [sendBtn addTarget:self action:@selector(sendBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
  //  [sendBtn setImage:[UIImage imageNamed:@"comment2x.png"] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor blackColor]];
    [txtBg_img addSubview:sendBtn];
    
    
    return sectionHeaderView;
}
*/

- (void)alertBtnTapped:(id)sender{

    NSLog(@"alertBtnTapped");
}
- (void)likeBtnTapped:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%ld",(long)btn.tag);
    NSString *likeStaus;
    [btn setImage:[UIImage imageNamed:@"heart2x.png"] forState:UIControlStateNormal];
    NSMutableDictionary *mainDict = [NSMutableDictionary dictionaryWithDictionary:[groupActivityContainer objectAtIndex:btn.tag]];
    NSMutableDictionary *activity_stream_action_dict = [NSMutableDictionary dictionaryWithDictionary:[mainDict objectForKey:kLMS_activity_stream_action]];
    NSMutableDictionary *likeunlike = [NSMutableDictionary dictionaryWithDictionary:[activity_stream_action_dict objectForKey:kLMS_likeunlike]];
    
    if((btn.selected = ![btn isSelected])){
        
        
        if ([[likeunlike objectForKey:kLMS_like_status]isEqualToString:@"unliked"]) {
          
            [likeunlike setObject:@"like" forKey:kLMS_like_status];
            likeStaus = @"like";
        }
        else{
        
             [likeunlike setObject:@"unliked" forKey:kLMS_like_status];
             likeStaus = @"unlike";
        }
        
        [activity_stream_action_dict setObject:likeunlike forKey:kLMS_likeunlike];
        [mainDict setObject:activity_stream_action_dict forKey:kLMS_activity_stream_action];
        [groupActivityContainer replaceObjectAtIndex:btn.tag withObject:mainDict];
        //
        NSString *likeUnlikeService = [NSString stringWithFormat:kLMS_activity_likeunlike,[LMSCommon getUserid],@"95",likeStaus];
        Parssing *parsVc = [Parssing new];
        parsVc.delegate = (id)self;
        [parsVc passUrl:likeUnlikeService andTag:tagLikeUnlike];

        
    }
    else{
      
        if ([[likeunlike objectForKey:kLMS_like_status]isEqualToString:@"unliked"]) {
            
            [likeunlike setObject:@"like" forKey:kLMS_like_status];
            likeStaus = @"like";
        }
        else{
            
            [likeunlike setObject:@"unliked" forKey:kLMS_like_status];
            likeStaus = @"unlike";
        }
        
        [activity_stream_action_dict setObject:likeunlike forKey:kLMS_likeunlike];
        [mainDict setObject:activity_stream_action_dict forKey:kLMS_activity_stream_action];
        [groupActivityContainer replaceObjectAtIndex:btn.tag withObject:mainDict];

        likeStaus = @"unlike";
        [btn setImage:[UIImage imageNamed:@"heart_dislike.png"] forState:UIControlStateNormal];
        NSString *likeUnlikeService = [NSString stringWithFormat:kLMS_activity_likeunlike,[LMSCommon getUserid],@"95",likeStaus];
        Parssing *parsVc = [Parssing new];
        parsVc.delegate = (id)self;
        [parsVc passUrl:likeUnlikeService andTag:tagLikeUnlike];
    }
    [groupDetailTable reloadData];
    
}
- (void)commontBtnTapped:(id)sender{
   
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%ld",(long)btn.tag);
    NSString *commentText = [LMSCommon replaceCheracterWith20Str:commonTxtView.text];
    NSString *likeUnlikeService = [NSString stringWithFormat:kLMS_activity_comments,[LMSCommon getUserid],@"95",commentText];
    Parssing *parsVc = [Parssing new];
    parsVc.delegate = (id)self;
    [parsVc passUrl:likeUnlikeService andTag:tagActiveComment];


}

- (void)shareBtnTapped:(id)sender{
    NSLog(@"shareBtnTapped:");
}

- (void)sendBtnTapped:(id)sender{
  NSLog(@"sendBtnTapped:");
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 187.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
/*    NSDictionary *likeunStatus = [[groupActivityContainer objectAtIndex:section]objectForKey:kLMS_activity_stream_action];
    if (likeunStatus !=0 && [likeunStatus isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *postedcommentsDict = [likeunStatus objectForKey:@"postedcomments"];
        tempArray = [postedcommentsDict objectForKey:@"details"];
        
        if (tempArray !=0 && [tempArray isKindOfClass:[NSArray class]]) {
            
            return tempArray.count;
        }
        
    }
    return 0;
 */
    return  groupActivityContainer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    static NSString *MyIdentifier = groupProfileCell;
    LMSGroupProfileCell *cell = (LMSGroupProfileCell *)[groupDetailTable dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:[LMSCommon isIpad] ? @"LMSGroupProfileCell_ipad" : @"LMSGroupProfileCell" owner:self options:nil];
        cell = (LMSGroupProfileCell *)[nibViews objectAtIndex:0];
    }
    cell.delegate = (id)self;
    cell.theIndexPath = indexPath.row;
    cell.likeBtn.tag = indexPath.row;
    cell.commntBtn.tag = indexPath.row;
    NSString *profileImg = [LMSCommon stringByStrippingHTML:[[groupActivityContainer objectAtIndex:indexPath.row] objectForKey:kLMS_activity_posted_by_thumb]];
    cell.profileImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImg]]];
    cell.profileNamelbl.text = [LMSCommon stringByStrippingHTML:[[groupActivityContainer objectAtIndex:indexPath.row] objectForKey:kLMS_activity_stream_title]];
   
    NSDictionary *dict = [[groupActivityContainer objectAtIndex:indexPath.row] objectForKey:kLMS_activity_stream_content];
    if (dict != nil && [dict isKindOfClass:[NSDictionary class]]) {
        
        
        NSArray *stremArray = [dict objectForKey:kLMS_stream];
        NSString *streamThum = [[stremArray objectAtIndex:0] objectForKey:kLMS_stream_content_thumb];
        NSString *tempImg =    [LMSCommon stringByStrippingHTML:streamThum];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            UIImage *img =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempImg]]];
            UIGraphicsBeginImageContext(CGSizeMake(1,1));
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), [img CGImage]);
            UIGraphicsEndImageContext();
            dispatch_sync(dispatch_get_main_queue(), ^{
                [cell.profilePostImg setImage: img];
            });
        });
    }

    
    NSString *likeCheck;
    NSDictionary *likeunStatus = [[groupActivityContainer objectAtIndex:indexPath.row]objectForKey:kLMS_activity_stream_action];
    if (likeunStatus !=0 && [likeunStatus isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *likeStDict = [likeunStatus objectForKey:kLMS_likeunlike];
        likeCheck = [likeStDict objectForKey:kLMS_like_status];
        if ([likeCheck isEqualToString:kLMS_unliked]) {
            
            [cell.likeBtn setImage:[UIImage imageNamed:@"heart_dislike.png"] forState:UIControlStateNormal];
        }
        else{
            [cell.likeBtn setImage:[UIImage imageNamed:@"heart2x.png"] forState:UIControlStateNormal];
        }
    }
    else{
        
        [cell.likeBtn setImage:[UIImage imageNamed:@"heart_dislike.png"] forState:UIControlStateNormal];
    }

    
    NSNumber *likeCount;
    NSDictionary *likeDict = [[groupActivityContainer objectAtIndex:indexPath.row]objectForKey:kLMS_activity_stream_action];
    if (likeDict !=0 && [likeDict isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *likeDict1 = [likeDict objectForKey:kLMS_likedusers];
        likeCount = [NSNumber numberWithInteger:[[likeDict1 objectForKey:kLMS_total_liked] integerValue]];
        
    }
    
    else{
        
        likeCount = [NSNumber numberWithInteger:0];
    }
    cell.likeLbl.text = [NSString stringWithFormat:@"%@ likes",likeCount];

    
    NSNumber *commntCount;
    NSDictionary *commntDict = [[groupActivityContainer objectAtIndex:indexPath.row]objectForKey:kLMS_activity_stream_action];
    if (commntDict !=0 && [commntDict isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *comntDict1 = [commntDict objectForKey:kLMS_postedcomments];
        commntCount = [NSNumber numberWithInteger:[[comntDict1 objectForKey:kLMS_total_comments] integerValue]];
        
    }
    
    else{
        
        commntCount = [NSNumber numberWithInteger:0];
    }
    cell.commntLbl.text = [NSString stringWithFormat:@"%@ comments",commntCount];;
    
    return cell;
}

- (void)getlikeBtnIndexPath:(NSInteger )indexPath{

    LMSGroupProfileCell *cell;
  //  [cell.likeBtn setImage:[UIImage imageNamed:@"heart2x.png"] forState:UIControlStateNormal];
   
    NSMutableDictionary *mainDict = [NSMutableDictionary dictionaryWithDictionary:[groupActivityContainer objectAtIndex:indexPath]];
    NSDictionary *dict = [mainDict objectForKey:kLMS_activity_stream_action];
    NSMutableDictionary *activity_stream_action_dict;
    NSMutableDictionary *likeunlike;
    NSString *likeStaus;
    if (dict != nil && [dict isKindOfClass:[NSDictionary class]]) {
     
        activity_stream_action_dict = [NSMutableDictionary dictionaryWithDictionary:[mainDict objectForKey:kLMS_activity_stream_action]];
        likeunlike = [NSMutableDictionary dictionaryWithDictionary:[activity_stream_action_dict objectForKey:kLMS_likeunlike]];
      
        if((cell.likeBtn.selected = ![cell.likeBtn isSelected])){
            
            
            if ([[likeunlike objectForKey:kLMS_like_status]isEqualToString:@"unliked"]) {
                
                [likeunlike setObject:@"like" forKey:kLMS_like_status];
                likeStaus = @"like";
                [cell.likeBtn setImage:[UIImage imageNamed:@"heart2x.png"] forState:UIControlStateNormal];
                // [likeunlike1 setObject:[NSNumber numberWithInteger:1] forKey:kLMS_total_liked];
                
            }
            else{
                
                [likeunlike setObject:@"unliked" forKey:kLMS_like_status];
                likeStaus = @"unlike";
                [cell.likeBtn setImage:[UIImage imageNamed:@"heart_dislike"] forState:UIControlStateNormal];
                // [likeunlike1 setObject:[NSNumber numberWithInteger:0] forKey:kLMS_total_liked];
            }
            
            [activity_stream_action_dict setObject:likeunlike forKey:kLMS_likeunlike];
            [mainDict setObject:activity_stream_action_dict forKey:kLMS_activity_stream_action];
            [groupActivityContainer replaceObjectAtIndex:indexPath withObject:mainDict];
            //
            
            //   [activity_stream_action_dict1 setObject:likeunlike1 forKey:kLMS_likedusers];
            //   [mainDict1 setObject:activity_stream_action_dict1 forKey:kLMS_activity_stream_action];
            //   [groupActivityContainer replaceObjectAtIndex:indexPath withObject:mainDict1];
            
            
            NSString *likeUnlikeService = [NSString stringWithFormat:kLMS_activity_likeunlike,[LMSCommon getUserid],[[groupActivityContainer objectAtIndex:indexPath] objectForKey:kLMS_activity_id],likeStaus];
            Parssing *parsVc = [Parssing new];
            parsVc.delegate = (id)self;
            [parsVc passUrl:likeUnlikeService andTag:tagLikeUnlike];
        }
        
    }
    else{
    
        likeStaus = @"like";
        NSString *likeUnlikeService = [NSString stringWithFormat:kLMS_activity_likeunlike,[LMSCommon getUserid],[[groupActivityContainer objectAtIndex:indexPath] objectForKey:kLMS_activity_id],likeStaus];
        Parssing *parsVc = [Parssing new];
        parsVc.delegate = (id)self;
        [parsVc passUrl:likeUnlikeService andTag:tagLikeUnlike];
    }
    
     [groupDetailTable reloadData];

}
- (void)getCommontBtnIndexpath:(NSInteger )indexPath{
  
    commntPop = [[LMSCommntView alloc] initWithNibName:@"LMSCommntView" bundle:nil];
    commntPop.delegate = (id)self;
    [commntPop setActivityID:[[groupActivityContainer objectAtIndex:indexPath] objectForKey:kLMS_activity_id]];
    [self.view addSubview:commntPop.view];
}


- (void)removwLMSCommntView{
   
    [commntPop.view removeFromSuperview];
    commntPop = nil;
}




- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        
        
    }
    else{
        
        if (commonTxtView.text.length<500) {
            
            if ([text isEqualToString:@"\n"]) {
                
                [textView resignFirstResponder];
                //[professionalScrool setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else{
                
            }
        }
        else{
            
            [textView resignFirstResponder];
           // [professionalScrool setContentOffset:CGPointMake(0, 0) animated:YES];
            [LMSCommon showAlert:@"Description length allow maximum 500 characters."];
        }
        
    }
    
    return YES;
}




#pragma mark -
#pragma mark  Device Rotation Methods
#pragma mark -


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self adjustViewsForOrientation:toInterfaceOrientation];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation {
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        // set you subviews,Label button frame here for landscape mode,,
        NSLog(@"LandScape");
    }
    else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        // set you subviews,Label button frame here for portrait-mode,
        NSLog(@"portrait");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    // Return YES for supported orientations
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
