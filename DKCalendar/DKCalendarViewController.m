//
//  DKCalendarViewController.m
//  DKCalendar
//
//  Created by Dikey on 8/18/14.
//  Copyright (c) 2014 dikey. All rights reserved.
//  

#import "DKCalendarViewController.h"
#define FANRAG_COLOR [UIColor colorWithRed:0 green:0.8 blue:1 alpha:1]
@interface DKCalendarViewController ()
@end

@implementation DKCalendarViewController

-(void)dateSelected:(UIButton*)sender
{
    int month_ = currentMonth.month;
	int year_ = currentMonth.year;
    int day_ = sender.tag;
    
    _selectedDate = [NSString new];
    if (day_<=9 && month_<=9)
    {
        _selectedDate = [NSString stringWithFormat:@"%d-0%d-0%d",year_,month_,day_];
    }
    if (day_<=9 && month_>9)
    {
        _selectedDate = [NSString stringWithFormat:@"%d-%d-0%d",year_,month_,day_];
    }
    if (day_>9 && month_>9)
    {
        _selectedDate = [NSString stringWithFormat:@"%d-%d-%d",year_,month_,day_];
    }
    if (day_>9 && month_<=9)
    {
        _selectedDate = [NSString stringWithFormat:@"%d-0%d-%d",year_,month_,day_];
    }
    
    NSLog(@"选中了%d年%d月%d日",year_,month_,day_);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    
    //   [self gotoSelectedDay];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) initialize {
	
	if (btnDayArray != nil) {
		[btnDayArray removeAllObjects];
		btnDayArray = nil;
	}
	btnDayArray = [[NSMutableArray alloc] initWithObjects:btn0,btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,btn10,btn11,btn12,btn13,btn14,btn15,btn16,btn17,btn18,btn19,btn20,btn21,btn22,btn23,btn24,btn25,btn26,btn27,btn28,btn29,btn30,btn31,btn32,btn33,btn34,btn35,btn36,btn37,btn38,btn39,btn40,btn41,nil];
    
	today = [NSDate date];
  //  today = _summaryCurrentDate;
    
	calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	currentMonth = [calendar components:(NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:today];
	
	if (MyDayMonthNames != nil) {
		[MyDayMonthNames removeAllObjects];
		MyDayMonthNames = nil;
	}
    
	MyDayMonthNames = [[NSMutableArray alloc] initWithObjects:@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月",nil];
    
	NSData *firstData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MyDayCalendarDateBack" ofType:@"png"]];
	
	first = [[UIImage alloc] initWithData:firstData];
	
    /*add guesture to know user scroll up or down and depending upon up or down swipe change month */
    UISwipeGestureRecognizer *recognizerUp;
    recognizerUp.delegate=self;
    [recognizerUp requireGestureRecognizerToFail:recognizerUp];
    recognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    [recognizerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [viewCalendar addGestureRecognizer:recognizerUp];
    
    UISwipeGestureRecognizer *recognizerDown;
    recognizerDown.delegate=self;
    recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    [recognizerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [viewCalendar addGestureRecognizer:recognizerDown];
    
	[self draw];
}

-(void)draw {
	[self.view setUserInteractionEnabled:NO];
	[self drawSelector];
}

-(void)drawSelector {
    
	for (int i = 0; i<42; i++) {
        UIButton *bt = [btnDayArray objectAtIndex:i];
        [bt setTitle:@"" forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.enabled = FALSE;
        [bt setHidden:FALSE];
        [bt setBackgroundImage:first forState:UIControlStateNormal];
        [bt.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16.0f]];
        [bt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [bt setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        bt.layer.borderColor =[UIColor grayColor].CGColor;
        bt.layer.borderWidth = 0.5;
    }
	
	NSString *strmonth = [MyDayMonthNames objectAtIndex:currentMonth.month-1];
    
	lblMonth.text = [NSString stringWithFormat:@"%@  %d",strmonth,currentMonth.year];
    
	NSDate *date = [calendar dateFromComponents:currentMonth];
    
	int btnIndex = [calendar components:NSWeekdayCalendarUnit fromDate:date].weekday-1;
    
	while ([calendar components:(NSMonthCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit) fromDate:date].month == currentMonth.month) {
		
        day = [calendar components:NSDayCalendarUnit fromDate:date].day;
        month = [calendar components:NSMonthCalendarUnit fromDate:date].month;
        year = [calendar components:NSYearCalendarUnit fromDate:date].year;
        
        int currentday = [calendar components:NSDayCalendarUnit fromDate:[NSDate date]].day;
        int currentmonth = [calendar components:NSMonthCalendarUnit fromDate:[NSDate date]].month;
        int currentyear = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]].year;
        
        UIButton *btn = [btnDayArray objectAtIndex:btnIndex];
        
		[btn setTitle:[NSString stringWithFormat:@"%d",day] forState:UIControlStateNormal];
		btn.tag = day;
        
        //to fetch selected date pass button title to tag
        [btn addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        //to show button highlighted state
        [btn setBackgroundImage:[self imageFromColor:FANRAG_COLOR] forState:UIControlStateHighlighted];
        btn.enabled = TRUE;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY/d/M"];
        
        //高亮显示当前日期
    //    currentday = [calendar components:NSDayCalendarUnit fromDate:_summaryCurrentDate].day;
        
     //   currentmonth = [calendar components:NSMonthCalendarUnit fromDate:_summaryCurrentDate].month;
     //   currentyear = [calendar components:NSYearCalendarUnit fromDate:_summaryCurrentDate].year;
        
        if (month == currentmonth && currentday == day && year == currentyear) {
            [btn setBackgroundImage:[self imageFromColor:FANRAG_COLOR] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        NSDateComponents *dayCompontent = [[NSDateComponents alloc] init];
        [dayCompontent setDay:1];
		date = [calendar dateByAddingComponents:dayCompontent toDate:date options:0];
        btnIndex = (btnIndex+1)%42;
	}
	
	[self.view setUserInteractionEnabled:YES];
}

/* method to fetch image from color*/
-(UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(IBAction)nextMonth:(id)sender{
    
	int month_ = currentMonth.month;
	int year_ = currentMonth.year;
    
	NSDateComponents *newMonth = [[NSDateComponents alloc] init];
	[newMonth setDay:28];
	[newMonth setMonth:month_];
	[newMonth setYear:year_];
	
	NSDate *date = [calendar dateFromComponents:newMonth];
	date = [date dateByAddingTimeInterval:3600*24*4];
	currentMonth = [calendar components:(NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date];
	
	[self draw];
    
}

-(IBAction)prevoiuseMonth:(id)sender{
    
    int month_ = currentMonth.month;
	int year_ = currentMonth.year;
	NSDateComponents *newMonth = [[NSDateComponents alloc] init];
	[newMonth setDay:1];
	[newMonth setMonth:month_];
	[newMonth setYear:year_];
	
	NSDate *date = [calendar dateFromComponents:newMonth];
	date = [date dateByAddingTimeInterval:-3600*24*4];
	currentMonth = [calendar components:(NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date] ;
	
	[self draw];
    
    
}


#pragma mark Gesture Methods

- (void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self nextMonth:self];
}

- (void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self prevoiuseMonth:self];
}


@end
