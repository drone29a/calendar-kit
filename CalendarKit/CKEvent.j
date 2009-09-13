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
    return [self initWithStartDate:aStart
                           endDate:anEnd
                             title:nil
                       description:nil];
}

- (id)initWithStartDate:(CPDate)aStart 
                endDate:(CPDate)anEnd 
                  title:(CPString)aTitle 
            description:(CPString)aDescription
{
    if (self = [super init])
    {
        _startDate = aStart;
        _endDate = anEnd;
        _title = aTitle;
        _description = aDescription;
    }
    
    return self;    
}

- (id)copy
{
    return [[CKEvent alloc] initWithStartDate:_startDate
                                      endDate:_endDate
                                        title:_title
                                  description:_description];
}
