//
//  MZBlurredParallax.h
//  CoreImageFun
//
//  Created by Michał Zygar on 07.05.2013.
//

#import <UIKit/UIKit.h>

@interface MZBlurredParallax : UIView
@property (nonatomic, weak) id<UIScrollViewDelegate> delegate;
- (id)initWithScrollView:(UIScrollView*)scrollView background:(UIImage*)bgImage;
@end
