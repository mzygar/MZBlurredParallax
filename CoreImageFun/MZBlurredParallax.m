//
//  MZBlurredParallax.m
//  CoreImageFun
//
//  Created by Michał Zygar on 07.05.2013.
//

#import "MZBlurredParallax.h"


#define BLUR_RADIUS 9.0
#define PARALLAX_SPEED_RATIO 10.0f
#define TOTAL_BLUR_HEIGHT_FRACTION 0.85f


@interface MZBlurredParallax () <UIScrollViewDelegate>
{
    UIImageView* _blurredImgView;
}
@property (nonatomic, strong) UIScrollView* parallaxBg;
@property (nonatomic, strong) UIImage* backgroundImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation MZBlurredParallax

- (id)initWithScrollView:(UIScrollView*)scrollView background:(UIImage*)bgImage
{
    self = [super initWithFrame:scrollView.frame];
    if (self) {
        self.backgroundImage=bgImage;
        [self setupBackground];
        [self addSubview:scrollView];
        [scrollView setDelegate:self];
        self.scrollView=scrollView;
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    }
    return self;
}


-(void)setupBackground
{
    _parallaxBg=[[UIScrollView alloc] initWithFrame:self.frame];
    CIImage *beginImage = [CIImage imageWithCGImage:self.backgroundImage.CGImage];
    CIContext* context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, beginImage, @"inputRadius", @(BLUR_RADIUS), nil];
    CIImage *outputImage = [filter outputImage];
    

    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[beginImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    
    CGRect imagesFrame=self.frame;
    imagesFrame.size.height+=imagesFrame.size.height/PARALLAX_SPEED_RATIO;
    _blurredImgView =[[UIImageView alloc] initWithFrame:imagesFrame];
    [_blurredImgView setContentMode:UIViewContentModeScaleAspectFill];
    [_blurredImgView setImage:newImage];
    [_blurredImgView setAlpha:0.0];
    

    UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:imagesFrame];
    [bgImageView setImage:self.backgroundImage];
    [bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [bgImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

    [self.parallaxBg addSubview:bgImageView];
    [self.parallaxBg addSubview:_blurredImgView];
    
    [self addSubview:self.parallaxBg];
    
    CGImageRelease(cgimg);
}

-(void)layoutSubviews
{
    CGRect imagesFrame=self.frame;
    imagesFrame.size.height+=imagesFrame.size.height/PARALLAX_SPEED_RATIO;

    [self.parallaxBg setFrame:self.frame];
    [_blurredImgView setFrame:imagesFrame];
    [self.scrollView setFrame:self.frame];
}




#pragma mark -
#pragma mark Delegate forwarding
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    CGFloat yOffset=scrollView.contentOffset.y;
    CGFloat blurThresholdHeight=self.frame.size.height*TOTAL_BLUR_HEIGHT_FRACTION;
    [_blurredImgView setAlpha:yOffset/blurThresholdHeight];
    
    if (yOffset/PARALLAX_SPEED_RATIO>0.0f && yOffset<_parallaxBg.frame.size.height) {
        [_parallaxBg setContentOffset:CGPointMake(0.0f, yOffset/PARALLAX_SPEED_RATIO) animated:NO];
    }

    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }

}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.delegate scrollViewDidZoom:scrollView];
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.delegate viewForZoomingInScrollView:scrollView];
    }
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.delegate scrollViewShouldScrollToTop:scrollView];
    }
    
    return YES;
    
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.delegate scrollViewDidScrollToTop:scrollView];
    }
}



@end
