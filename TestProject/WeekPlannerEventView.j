var DEFAULT_COLOR = [CPColor colorWithCalibratedRed:0.3 green:0.9 blue:0.2 alpha:0.65];
var SELECTED_COLOR = [CPColor colorWithCalibratedRed:0.3 green:0.9 blue:0.2 alpha:1.0];

@implementation WeekPlannerEventView : CPView
{
    CPTextField title @accessors;
    id _representedObject;
    
    BOOL selected;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        [self _init];
    }

    return self;
}

- (void)_init
{

}

- (void)viewDidMoveToWindow
{
    [[self window] setAcceptsMouseMovedEvents:YES];
}

- (BOOL)acceptsMouseMovedEvents
{
    return YES;
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

    [self setBackgroundColor:DEFAULT_COLOR];
}

- (void)setSelected:(BOOL)isSelected
{
    [self setBackgroundColor:isSelected ? SELECTED_COLOR : DEFAULT_COLOR];
    [self setAlphaValue: 1.0];
}

- (void)mouseDown:(CPEvent)anEvent
{
    [[CPNotificationCenter defaultCenter] postNotificationName:CKWeekPlannerItemViewSelectedNotification
                                                        object:self
                                                      userInfo:[CPDictionary dictionaryWithObject:anEvent forKey:"event"]];

    [[self nextResponder] mouseDown:anEvent];
}

- (void)mouseMoved:(CPEvent)anEvent
{
    var location = [self convertPoint:[anEvent locationInWindow] fromView:nil];
    
    if (location.y < 5 || location.y > [self frame].size.height - 5) 
    {
        [self superview]._DOMElement.style.cursor = "ns-resize";
    } else
    {
        [self superview]._DOMElement.style.cursor = "default";
    }
}

@end
