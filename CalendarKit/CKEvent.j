@import <Foundation/CPDate.j>

@implementation CKEvent : CPObject
{
    CPDate _startDate @accessors(property=startDate);
    CPDate _endDate @accessors(property=endDate);
    CPString _title @accessors(property=title);
    CPString _description @accessors(property=description);
}

- (id)initWithStartDate:(CPDate)aStart endDate:(CPDate)anEnd
{
    if (self = [super init])
    {
        _startDate = aStart;
        _endDate = anEnd;
    }
    
    return self;
}
