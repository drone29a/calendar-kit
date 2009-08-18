@implementation CKSchedule
{
    CPDate _startDate;
    CPTimeInterval _timeDuration;
    CPArray _events;  //TODO: this should be CPDictionary, just need to pick a key
}
    
- (CPDate)startDate
{
    return _startDate;
}

- (CPDate)endDate
{
    return [[CPDate alloc] initWithTimeInterval:_timeDuration sinceDate:_start];
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
    return nil;
}
