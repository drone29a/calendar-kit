@import <Foundation/CPArray.j>
@import <Foundation/CPData.j>
@import <Foundation/CPIndexSet.j>
@import <Foundation/CPKeyedArchiver.j>
@import <Foundation/CPKeyedUnarchiver.j>

@import <AppKit/CPView.j>

@implementation CKWeekPlanner : CPView
{
    CKSchedule _schedule;
    
    CPData _eventViewData;
    CKEventView _eventViewForDragging;
    CKEventView _eventViewPrototype;
    CPRange _hourRange;
}

- (id)initWithFrame:(CGRect)aFrame schedule:(CKSchedule)aSchedule
{
    if (self = [super initWithFrame:aFrame])
    {
        _schedule = aSchedule;
        _hourRange = CPMakeRange(0, 24);
    }

    return self;
}

- (void)setSchedule:(CKSchedule)aSchedule
{
    _schedule = aSchedule;
    [self reloadSchedule];
}

- (CKSchedule)schedule
{
    return _schedule;
}

- (void)setEventViewPrototype:(CKEventView)anEventView
{
    _eventViewData = [CPKeyedArchiver archivedDataWithRootObject:anEventView];
    _eventViewForDragging = anEventView;
    _eventViewPrototype = anEventView;

    [self reloadSchedule];
}

- (CKEventView)eventViewPrototype
{
    return _eventViewPrototype;
}

- (void)drawRect:(CPRect)aRect
{
    var context = [[CPGraphicsContext currentContext] graphicsPort];
    var boundsSize = [self bounds].size;

    // Draw background
    [[CPColor whiteColor] setFill];
    CGContextFillRect(context, CGRectMake(0.0, 0.0, boundsSize.width, boundsSize.height));
    
    [self drawDays];
    [self drawHourGrid];   
    [self drawHalfHourGrid];
}

- (void)drawHourGrid
{
    var numHours = _hourRange.length;
    var spacing = CPRectGetHeight([self bounds]) / numHours;
    var length = CPRectGetWidth([self bounds]);

    [[CPColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] setStroke];
    var path = [CPBezierPath bezierPath];
    [path setLineWidth:2.5];

    for (var i = 1; i < numHours; ++i) 
    {
        var yPos = (i * spacing) + 1;
        [path moveToPoint:CGPointMake(0.0, yPos)];
        [path lineToPoint:CGPointMake(0.0 + length, yPos)];
    }
    [path stroke];
}

- (void)drawHalfHourGrid
{
    var numHalfHours = _hourRange.length;
    var spacing = CPRectGetHeight([self bounds]) / numHalfHours;
    var length = CPRectGetWidth([self bounds]);

    [[CPColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:0.5] setStroke];
    var path = [CPBezierPath bezierPath];
    [path setLineWidth:1.0];

    for (var i = 0; i < numHalfHours; ++i) 
    {
        var yPos = (i * spacing) + 1 + (spacing / 2);
        [path moveToPoint:CGPointMake(0.0, yPos)];
        [path lineToPoint:CGPointMake(0.0 + length, yPos)];
    }
    [path stroke];
}

- (void)drawDays
{
    var numDays = 7;
    var spacing = CPRectGetWidth([self bounds]) / numDays;
    var height = CPRectGetHeight([self bounds]);

    [[CPColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] setStroke];
    var path = [CPBezierPath bezierPath];
    [path setLineWidth:2.0];

    for (var i = 0; i < numDays; ++i) 
    {
        var xPos = (i * spacing) + 1;
        [path moveToPoint:CGPointMake(xPos, 0.0)];
        [path lineToPoint:CGPointMake(xPos, 0.0 + height)];
    }
    [path stroke];
}
