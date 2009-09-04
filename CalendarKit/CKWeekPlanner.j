@import <Foundation/CPArray.j>
@import <Foundation/CPData.j>
@import <Foundation/CPIndexSet.j>
@import <Foundation/CPKeyedArchiver.j>
@import <Foundation/CPKeyedUnarchiver.j>

@import <AppKit/CPView.j>

@implementation CKWeekPlanner : CPView
{
    CKSchedule _schedule @accessors(property=schedule);
    id _delegate @accessors(property=delegate);
    
    CKWeekPlannerItem _eventItemData;
    CKWeekPlannerItem _eventItemForDragging;
    CKWeekPlannerItem _eventItemPrototype @accessors(property=eventItemPrototype);
    // What hours to display
    CPRange _hourRange @accessors(property=hourRange);
    
    CPArray _items;
    //TODO: how to handle multiple selected
    CPArray _selectedItems @accessors(property=selectedItems);

    int _numDays; // @accessors(property=numDays);
    int _numHours; // @accessors(property=numHours);
}

- (id)initWithFrame:(CGRect)aFrame schedule:(CKSchedule)aSchedule
{
    if (self = [super initWithFrame:aFrame])
    {
        _schedule = aSchedule;
        [self _init];
    }

    return self;
}

- (void)_init
{
    _hourRange = CPMakeRange(0, 24);
    _numDays = 7;
    _numHours = 24;

    _eventItems = [];
}

- (void)setEventItemPrototype:(CKWeekPlannerItem)anEventItem
{
    _eventItemData = [CPKeyedArchiver archivedDataWithRootObject:anEventItem];
    _eventItemForDragging = anEventItem;
    _eventItemPrototype = anEventItem;

    [self setNeedsDisplay:YES];
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

    // Draw events
    var index = 0;
    for (; index < [[_schedule events] count]; ++index) 
    {
        _eventItems.push([self newEventItemForEventObject:[[_schedule events] objectAtIndex: index]]);        
        [self addSubview:[_eventItems[index] view]];
        [self layoutItemView:[_eventItems[index] view]];
    }
}

- (void)layoutItemView:(CPView)itemView
{
    [itemView setFrameSize:CPSizeMake([self dayWidth], [self hourHeight])];
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
    var spacing = [self dayWidth];
    var height = CPRectGetHeight([self bounds]);

    [[CPColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] setStroke];
    var path = [CPBezierPath bezierPath];
    [path setLineWidth:2.0];

    for (var i = 0; i < _numDays; ++i) 
    {
        var xPos = (i * spacing) + 1;
        [path moveToPoint:CGPointMake(xPos, 0.0)];
        [path lineToPoint:CGPointMake(xPos, 0.0 + height)];
    }
    [path stroke];
}

/*
    Returns the index of the row at the given point, or CPNotFound (-1) if it is out of range.
    @param aPoint the point
    @return the index of the row at aPoint
*/
- (int)dayAtPoint:(CGPoint)aPoint
{
    var index = Math.floor(aPoint.x / [self dayWidth]);

    if (index >= 0 && index <= _numDays - 1) 
    {
        return index;
    } else
    {
        return CPNotFound;
    }
}

- (float)dayWidth
{
    return CPRectGetWidth([self bounds]) / _numDays;
}

- (float)timeAtPoint:(CGPoint)aPoint
{
    var time = (aPoint.y / [self hourHeight]) + _hourRange.location;
    
    if (time < 0 || time > 24)
        return CPNotFound;

    return time;
}

- (float)hourHeight
{
    return CPRectGetHeight([self bounds]) / _numHours;
}

- (void)mouseUp:(CPEvent)anEvent
{
    var type = [anEvent type],
        location = [self convertPoint:[anEvent locationInWindow] fromView:nil],
        clickedDay = [self dayAtPoint:location],
        clickedTime = [self timeAtPoint:location];

    if (type == CPLeftMouseUp && [anEvent clickCount] == 2)
    {
        if ([_delegate respondsToSelector:@selector(weekPlanner:didDoubleClickOnDay:atTime:)]) 
        {
            [_delegate weekPlanner:self didDoubleClickOnDay:clickedDay atTime:clickedTime];
        }
    }
    else if (type == CPLeftMouseUp)
    {
        if ([_delegate respondsToSelector:@selector(weekPlanner:didClickOnDay:atTime:)]) 
        {
            [_delegate weekPlanner:self didClickOnDay:clickedDay atTime:clickedTime];
        }
    }
        
}

- (void)mouseDown:(CPEvent)anEvent
{       

}

- (void)observeValueForKeyPath:(CPString)keyPath
                      ofObject:(id)object
                        change:(CPDictionary)change
                       context:(id)context
{
    if (keyPath == "events")
    {
        [self setNeedsDisplay:YES];
    }
}

- (void)trackSelection:(CPEvent)anEvent
{
    var type = [anEvent type],
        point = [self convertPoint:[anEvent locationInWindow] fromView:nil],
        currentRow = MAX(0, MIN(_numberOfRows-1, [self _rowAtY:point.y]));
    
    if (type == CPLeftMouseUp)
    {
        _clickedDay = [self dayAtPoint:point];
        _clickedTime = [self timeAtPoint:point];
        
        if ([anEvent clickCount] === 2)
        {
            CPLog.warn("edit?!");
            
            [self sendAction:_doubleAction to:_target];
        }
        else
        {
            if (![_previousSelectedRowIndexes isEqualToIndexSet:_selectedRowIndexes])
            {
                [[CPNotificationCenter defaultCenter] postNotificationName:CPTableViewSelectionDidChangeNotification object:self userInfo:nil];
            }
            
            [self sendAction:_action to:_target];
        }
        return;
    }
    
    if (type == CPLeftMouseDown)
    {

    }
    else if (type == CPLeftMouseDragged)
    {

    }
    
    [CPApp setTarget:self selector:@selector(trackSelection:) forNextEventMatchingMask:CPLeftMouseDraggedMask | CPLeftMouseUpMask untilDate:nil inMode:nil dequeue:YES];
}

- (CKEventItem)newEventItemForEventObject:(id)anObject
{
    var item = [CPKeyedUnarchiver unarchiveObjectWithData:_eventItemData];
    
    CPLog.debug(anObject._startDate);

    [item setRepresentedObject:anObject];
    [[item view] setFrameSize:CPSizeMake(100, 100)];

    return item;
}

@end

// TODO: We could use just one notification if we determine it's fair to add 
// an "item" attribute to the item's _view, so that way we get the item reference
// when the ItemViewSelected notification goes out instead of using it as a way
// to lookup the item reference.

// The CKWeekPlannerItem view should post this notification when appropriate
CKWeekPlannerItemSelectedNotification = "CKWeekPlannerItemSelectedNotification";
CKWeekPlannerItemViewSelectedNotification = "CKWeekPlannerItemViewSelectedNotification";

@implementation CKWeekPlannerItem : CPObject
{
    id      _representedObject;
    CPView  _view;
    BOOL    _isSelected;
}

// Setting the Represented Object
/*!
    Sets the object to be represented by this item.
    @param anObject the object to be represented
*/
- (void)setRepresentedObject:(id)anObject
{
    if (_representedObject == anObject)
        return;
    
    _representedObject = anObject;
    
    // FIXME: This should be set up by bindings
    [_view setRepresentedObject:anObject];

    [[CPNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(viewSelected:)
                                                 name:CKWeekPlannerItemViewSelectedNotification
                                               object:_view];
}

- (void)viewSelected:(CPNotification)notification
{
    [[CPNotificationCenter defaultCenter] postNotificationName:CKWeekPlannerItemSelectedNotification
                                                        object:self];
}

/*!
    Returns the object represented by this view item
*/
- (id)representedObject
{
    return _representedObject;
}

// Modifying the View
/*!
    Sets the view that is used represent this object.
    @param aView the view used to represent this object
*/
- (void)setView:(CPView)aView
{
    _view = aView;
}

/*!
    Returns the view that represents this object.
*/
- (CPView)view
{
    return _view;
}

// Modifying the Selection
/*!
    Sets whether this view item should be selected.
    @param shouldBeSelected \c YES makes the item selected. \c NO deselects it.
*/
- (void)setSelected:(BOOL)shouldBeSelected
{
    if (_isSelected == shouldBeSelected)
        return;
    
    _isSelected = shouldBeSelected;
    
    // FIXME: This should be set up by bindings
    [_view setSelected:_isSelected];
}

/*!
    Returns \c YES if the item is currently selected. \c NO if the item is not selected.
*/
- (BOOL)isSelected
{
    return _isSelected;
}

- (CKWeekPlanner)weekPlanner
{
    return [_view superview];
}

@end

var CKWeekPlannerItemViewKey = @"CKWeekPlannerItemViewKey";

@implementation CKWeekPlannerItem (CPCoding)

/*!
    Initializes the view item by unarchiving data from a coder.
    @param aCoder the coder from which the data will be unarchived
    @return the initialized collection view item
*/
- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
        _view = [aCoder decodeObjectForKey:CKWeekPlannerItemViewKey];
    
    return self;
}

/*!
    Archives the colletion view item to the provided coder.
    @param aCoder the coder to which the view item should be archived
*/
- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_view forKey:CKWeekPlannerItemViewKey];
}

@end
