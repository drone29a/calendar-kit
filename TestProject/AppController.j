/*
 * AppController.j
 * TestProject
 *
 * Created by You on August 2, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <Foundation/CPLog.j>

@import "CalendarKit/CKWeekPlanner.j"
@import "CalendarKit/CKSchedule.j"

@import "WeekPlannerController.j"

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    CPLogRegister(CPLogPopup);
    
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    [contentView setBackgroundColor:[CPColor grayColor]];

    //    [contentView addSubview:label];

    //    var meter = [CPMeterColumn meterWithMeasureCount:4 sized:CGSizeMake(121,60)];
    
    //    [meter setCenter:[contentView center]];
    //[contentView addSubview:meter];

    var floatingWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(50.0, 50.0, 400.0, 300.0) 
                                                     styleMask:CPTitledWindowMask | CPClosableWindowMask | CPResizableWindowMask],
        floatingContentView = [floatingWindow contentView];

    var weekPlanner = [[CKWeekPlanner alloc] initWithFrame:[floatingContentView bounds] schedule:nil];
    [weekPlanner setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

    var weekPlannerController = [[WeekPlannerController alloc] init];
    [weekPlanner setDelegate:weekPlannerController];

    var startDate = [[CPDate alloc] initWithString:"Aug 30, 2009"],
        endDate = [[CPDate alloc] initWithTimeInterval:(7 * 24 * 60 * 60 * 1000) - 1 sinceDate:startDate],
        schedule = [[CKSchedule alloc] initWithStartDate:startDate endDate:endDate];

    [weekPlanner setSchedule:schedule];
    [weekPlannerController setSchedule:schedule];
    [schedule addObserver:weekPlannerController
               forKeyPath:"startDate"
                  options:(CPKeyValueObservingOptionNew |
                           CPKeyValueObservingOptionOld)
                  context:NULL];

    [schedule addObserver:weekPlanner
               forKeyPath:"events"
                  options:CPKeyValueObservingOptionNew
                  context:NULL];

    [floatingContentView addSubview:weekPlanner];

    [theWindow orderFront:self];
    [floatingWindow orderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //    [CPMenu setMenuBarVisible:YES];
}

@end
