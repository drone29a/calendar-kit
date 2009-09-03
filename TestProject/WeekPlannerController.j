@implementation WeekPlannerController : CPObject
{
    CKSchedule _schedule @accessors(property=schedule);
}

- (void)weekPlanner:(CKWeekPlanner)aPlanner didDoubleClickOnDay:(int)dayIndex atTime:(float)time
{
    //    _schedule
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
}
