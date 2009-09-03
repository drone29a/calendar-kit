@implementation CKSchedule : CPObject
{
    CPDate _startDate @accessors(property=startDate);
    CPDate _endDate @accessors(property=endDate);
    CPArray _events @accessors(property=events);
}

- (id)initWithStartDate:(CPDate)aStartDate endDate:(CPDate)anEndDate
{
    if (self = [super init])
    {
        _startDate = aStartDate;
        _endDate = anEndDate;
        [self _init];
    }

    return self;
}

- (void)_init
{
    _events = [CPArray array];
}
    
- (void)addEvent:(CKEvent)anEvent
{
    [self willChangeValueForKey:"events"];
    [_events addObject:anEvent];
    [self didChangeValueForKey:"events"];
}

- (void)removeEvent:(CKEvent)anEvent
{
    [self willChangeValueForKey:"events"];
    [_events removeObjectAtIndex:[_events indexOfObject:anEvent]];
    [self didChangeValueForKey:"events"];
}

- (int)numDays
{
    return (_endDate - _startDate) / 1000 * 60 * 60 * 24;
}

- (CPDate)day:(int)dayIndex
{
    if (dayIndex < [self numDays])
    {
        var date = [[CPDate alloc] initWithTimeInterval:dayIndex * 24 * 60 * 60 sinceDate:_startDate];
        date.setHours(0);
        date.setMinutes(0);
        date.setSeconds(0);
        return date;
    }

    return nil;
}
