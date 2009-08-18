/*
 * AppController.j
 * TestProject
 *
 * Created by You on August 2, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "CalendarKit/CKWeekPlanner.j"

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    [contentView setBackgroundColor:[CPColor grayColor]];

    //    [contentView addSubview:label];

    //    var meter = [CPMeterColumn meterWithMeasureCount:4 sized:CGSizeMake(121,60)];
    
    //    [meter setCenter:[contentView center]];
    //[contentView addSubview:meter];

    var weekPlanner = [[CKWeekPlanner alloc] initWithFrame:CGRectMake(0, 0, 960, 600) schedule:nil];
    [weekPlanner setCenter:[contentView center]];
    [contentView addSubview:weekPlanner];

    [theWindow orderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

@end
