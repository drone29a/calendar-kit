@implementation WeekPlannerEventView : CPView
{
    CPTextField title @accessors;
    id _representedObject;
    
    BOOL selected;
}

- (id)representedObject
{
    return _representedObject;
}

- (void)setRepresentedObject:(id)anObject
{
    _representedObject = anObject;

    if (!title)
    {
        title = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
        [title setFont:[CPFont systemFontOfSize:12.0]];
        [title setTextColor:[CPColor blackColor]];
        [self addSubview:title];
    }

    [title setStringValue:anObject.title];
    [title setFrameSize:CGSizeMake(100, 20)];
    [title setFrameOrigin:CGPointMake(10, 0)];
    [title setLineBreakMode:CPLineBreakByWordWrapping];

    [self setBackgroundColor:[CPColor blueColor]];
}

- (void)setSelected:(BOOL)isSelected
{
    [self setBackgroundColor:isSelected ? [CPColor greenColor] : [CPColor blueColor]];
}

- (void)mouseUp:(CPEvent)anEvent
{
    [[CPNotificationCenter defaultCenter] postNotificationName:CKWeekPlannerItemViewSelectedNotification
                                                        object:self
                                                      userInfo:[CPDictionary dictionaryWithObject:anEvent forKey:"event"]];
}

@end
