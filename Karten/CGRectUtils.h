#ifndef CGRECTUTILS_H
#define CGRECTUTILS_H
#endif
#import <CoreGraphics/CoreGraphics.h>

inline CGRect CGRectMakeFrameForCenter(UIView *view, CGSize size, CGFloat yPos);
inline CGRect CGRectMakeFrameWithSizeFromFrame(CGRect rect);
inline CGPoint CGPointGetCenterFromRect(CGRect rect);
inline CGRect CGRectMakeFrameWithOriginInBottomOfFrame(CGRect hostFrame, CGFloat width, CGFloat height);
inline CGSize CGSizeAddHeightToSize(CGSize size, CGFloat delta);
inline CGSize CGSizeAddWidthToSize(CGSize size, CGFloat delta);
inline CGRect CGRectAddHeightToRect(CGRect rect, CGFloat delta);
inline CGRect CGRectMakeFrameWithOriginOnBottomOfFrame(CGRect hostFrame, CGFloat width, CGFloat height);
inline CGSize CGSizeMakeFromRect(CGRect rect);
inline CGRect CGRectSetHeightForRect(CGFloat height, CGRect rect);
inline CGRect CGRectSetWidthForRect(CGFloat width, CGRect rect);
inline CGRect CGRectSetOriginOnRect(CGRect rect, CGFloat originX, CGFloat originY);
inline CGRect CGRectMakeFrameForDeadCenterInRect(CGRect rect, CGSize frameSize);
inline CGRect CGRectSetSizeOnFrame(CGRect rect, CGSize size);
inline CGSize CGSizeAddSizeToSize(CGSize size, CGSize delta);
inline CGSize CGSizeInset(CGSize size, CGFloat dw, CGFloat dh);