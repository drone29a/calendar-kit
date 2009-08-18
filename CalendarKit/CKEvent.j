@import <Foundation/CPDate.j>

@implementation CKEvent : CPObject
{
    CPDate _start;
    CPTimeInterval _duration;
    CPString _title;
    CPString _description;
}

- (CPDate)startTime
{
    return _start;
}

- (CPDate)endTime
{
    return [[CPDate alloc] initWithTimeInterval:_duration sinceDate:_start];
}

- (CPString)title
{
    return _title;
}

- (CPString)description
{
    return _description;
}
