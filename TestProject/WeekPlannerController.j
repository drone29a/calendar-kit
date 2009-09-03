@import "CalendarKit/CKEvent.j"

@implementation WeekPlannerController : CPObject
{
    CKSchedule _schedule @accessors(property=schedule);
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
