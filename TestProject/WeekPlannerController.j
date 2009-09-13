@import "CalendarKit/CKEvent.j"

@import "WeekPlannerEventView.j"

@implementation WeekPlannerController : CPObject
{
    CKSchedule _schedule @accessors(property=schedule);
    
}

- (id)init
{
    if (self = [super init])
    {

    }

    return self;
}

- (void)weekPlanner:(CKWeekPlanner)aPlanner didDoubleClickOnDay:(int)dayIndex atTime:(float)time
{
    var startDate = [_schedule day:dayIndex];
    startDate.setHours(Math.floor(time));
    startDate.setMinutes(60 * (time - Math.floor(time)));

    var event = [[CKEvent alloc] initWithStartDate:startDate endDate:[[CPDate alloc] initWithTimeInterval:60 * 60 sinceDate:startDate]];

    [_schedule addEvent:event];
}

- (void)observeValueForKeyPath:(CPString)keyPath
                      ofObject:(id)object
                        change:(CPDictionary)change
                       context:(id)context
{
    if ([keyPath isEqual:"startDate"]) 
    {
        CPLog.debug([change objectForKey:CPKeyValueChangeNewKey]);
    }
    else if ([keyPath isEqual:"events"])
    {
        
    }
}

// TODO: Should be CKWeekPlannerItem that handles instead, then we get called as delegate?
- (void)weekPlannerItemSelected:(CPNotification)notification
{
    [[notification object] setSelected:YES];
}

- (void)weekPlannerItem:(CKWeekPlannerItem)anItem movedToDay:(int)aDay
{
    var event = [anItem representedObject],
        interval = 24 * 60 * 60 * (aDay - [event startDate].getDay());
    
    [event setStartDate: [[CPDate alloc] initWithTimeInterval:interval sinceDate:[event startDate]]];
    [event setEndDate: [[CPDate alloc] initWithTimeInterval:interval sinceDate:[event endDate]]];

    [anItem setRepresentedObject:event];
}

- (void)weekPlannerItem:(CKWeekPlannerItem)anItem movedToTime:(float)aTime
{

    CPLog.debug("aTime: " + aTime);

    var event = [anItem representedObject],
        eventStart = [event startDate],
        interval = (aTime * 60 * 60) - ((eventStart.getHours() * 60 * 60) + 
                                        (eventStart.getMinutes() * 60) +
                                        eventStart.getSeconds() +
                                        (eventStart.getMilliseconds() / 1000));
    
    [event setStartDate: [[CPDate alloc] initWithTimeInterval:interval sinceDate:[event startDate]]];
    [event setEndDate: [[CPDate alloc] initWithTimeInterval:interval sinceDate:[event endDate]]];

    [anItem setRepresentedObject:event];
}

@end
