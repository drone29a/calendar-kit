@implementation CKSchedule : CPObject
{
    CPDate _startDate @accessors(property=startDate);
    CPDate _endDate @accessors(property=endDate);
    CPTimeInterval _timeDuration;
    CPArray _events @accessors(property=events);
}

- (id)initWithStartDate:(CPDate)aStartDate endDate:(CPDate)anEndDate
{
    if (self = [super init])
    {
        _startDate = aStartDate;
        _endDate = anEndDate;
    }

    return self;
}
    
- (CPArray)events
{
    return _events;
}

- (void)addEvent:(CKEvent)anEvent
{
    [_events addObject:anEvent];
}

- (void)removeEvent:(CKEvent)anEvent
{
    [_events removeObjectAtIndex:[_events indexOfObject:anEvent]];
}

- (int)numDays
{
    return (_endDate - _startDate) / 1000 * 60 * 60 * 24;
}
