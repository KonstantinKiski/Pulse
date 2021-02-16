#import "HeartRateKitController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+ImageAverageColor.h"
#import "HeartRateKitAlgorithm.h"
#import "HeartRateKitResult.h"
#import "HeartRateKitResult+Protected.h"
#import "UIView+HeartRateKit.h"

#define kShouldAbortAfterSeconds 1
#define kTimeToDetermineBPMFinalResultInSeconds 20

static const NSUInteger HRKLabelFontSize = 14;
static const CGFloat HRKTopButtonsVerticalPadding = 8.0;
static const CGFloat HRKLabelToLabelTopPadding = 8.0;

@interface HeartRateKitController () <AVCaptureVideoDataOutputSampleBufferDelegate>
    // AVFoundation
    @property (nonatomic,strong) AVCaptureSession * session;
    @property (strong) AVCaptureDevice * videoDevice;
    @property (strong) AVCaptureDeviceInput * videoInput;
    @property (strong) AVCaptureVideoDataOutput * frameOutput;

    @property bool * animationStared;

    @property bool * hitScreenHasShowed;
    @property bool * showHitScreen;
    @property bool * isDetecting;

    @property NSTimer * timer;

    // Algorithm
    @property (nonatomic, strong) HeartRateKitAlgorithm *algorithm;
    @property (strong, nonatomic) NSDate *algorithmStartTime;
    @property (strong, nonatomic) NSDate *bpmFinalResultFirstTimeDetected;

//    @property (strong, nonatomic) UILabel *statusLabel;
//    @property (strong, nonatomic) UILabel *bpmLabel;
    @property (strong, nonatomic) UIButton *cancelButton;

    @property (nonatomic, strong) HeartRateKitResult *result;


    @property (weak) IBOutlet UIButton *heart;
    @property (weak) IBOutlet UILabel *bpmValue;
    @property (weak) IBOutlet UILabel *bpmLabel;
    @property (weak) IBOutlet UIProgressView *bpmProgress;
    @property (weak) IBOutlet UIButton *startButton;
    @property (weak) IBOutlet UILabel *hitLabel;

    
@end

@implementation HeartRateKitController
   
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (NSDate *)algorithmStartTime
{
    if (!_algorithmStartTime) {
        _algorithmStartTime = [NSDate date];
    }
    return _algorithmStartTime;
}

- (NSDate *)bpmFinalResultFirstTimeDetected
{
    if (!_bpmFinalResultFirstTimeDetected) {
        _bpmFinalResultFirstTimeDetected = [NSDate date];
    }
    return _bpmFinalResultFirstTimeDetected;
}

- (HeartRateKitAlgorithm *)algorithm
{
    if (!_algorithm) {
        _algorithm = [[HeartRateKitAlgorithm alloc] init];
        _algorithm.windowSize = 9;
        _algorithm.filterWindowSize = 45;
    }
    return _algorithm;
}

- (HeartRateKitResult *)result
{
    if (!_result) _result = [HeartRateKitResult createResult];
    return _result;
}

- (void)setupViews
{
    self.animationStared = false;
    [self.hitLabel setHidden:false];
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    self.title = @"Heart Rate";
    
    self.bpmValue.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.bpmValue setFont:[UIFont fontWithName:@"GothamPro-Medium" size:80]];
    
    self.bpmLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.bpmLabel setFont:[UIFont fontWithName:@"GothamPro-Medium" size:20]];
    
    self.hitLabel.textColor = [UIColor colorWithRed:224/255.0 green:0/255.0 blue:3/255.0 alpha:1];
    [self.hitLabel setFont:[UIFont fontWithName:@"GothamPro-Medium" size:16]];
    [self.bpmProgress setProgress:0.0 animated:false];
    self.bpmProgress.trackTintColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1];

    self.bpmProgress.progressTintColor = [UIColor colorWithRed:224/255.0 green:0/255.0 blue:3/255.0 alpha:1];

    self.heart.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.startButton setHidden: true];
}




- (void)startRunningSession
{
    dispatch_queue_t sessionQ = dispatch_queue_create("start running session thread", NULL);
    
    dispatch_async(sessionQ, ^{
        // turn flash on
        [self.session startRunning];
        if ([self.videoDevice hasTorch] && [self.videoDevice hasFlash]){
            [self.videoDevice lockForConfiguration:nil];
            [self.videoDevice setTorchMode:AVCaptureTorchModeOn];
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            AVCapturePhotoSettings *set = [AVCapturePhotoSettings photoSettings];
            set.flashMode = AVCaptureFlashModeOn;
#else
            [self.videoDevice setFlashMode:AVCaptureFlashModeOn];
#endif
            [self.videoDevice unlockForConfiguration];
        }
        
    });
}

- (void)stopRunningSession
{
    dispatch_queue_t sessionQ = dispatch_queue_create("stop running session thread", NULL);
    
    dispatch_async(sessionQ, ^{
        [self.session stopRunning];
        // turn flash off (maybe unnecessary because stopRunning do this)
        if ([self.videoDevice hasTorch] && [self.videoDevice hasFlash]){
            [self.videoDevice lockForConfiguration:nil];
            [self.videoDevice setTorchMode:AVCaptureTorchModeOff];
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            AVCapturePhotoSettings *set = [AVCapturePhotoSettings photoSettings];
            set.flashMode = AVCaptureFlashModeOff;
#else
            [self.videoDevice setFlashMode:AVCaptureFlashModeOff];
#endif
            
            [self.videoDevice unlockForConfiguration];
        }
    });
}


- (void)resetAlgorithm
{
    self.algorithmStartTime = nil;
    self.bpmFinalResultFirstTimeDetected = nil;
    self.algorithm = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetAlgorithm];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hitScreenHasShowed = false;
    self.showHitScreen = false;
    [self startRunningSession];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];// prevent the iphone from sleeping
    
    [self.hitLabel setText:@"Please place your finger on the front camera"];
    [self.bpmProgress setProgress:0.0 animated:true];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(showHit) userInfo:nil repeats:NO];
//    timer = Timer.scheduledTimer(withTimeInterval: 59, repeats: true, block: { [weak self] (timer) in
//        guard let `self` = self else {return}
//        self.checkToken()
//    })
}

- (void) showHit
{
    if (self.isDetecting == FALSE) {
        self.hitScreenHasShowed = true;
        self.showHitScreen = false;
        [self performSegueWithIdentifier:@"hit" sender:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopRunningSession];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO]; // enable sleeping
    [self.timer invalidate];
    self.timer = NULL;
}

- (void)applicationWillEnterForeground
{
    if (self.isViewLoaded && self.view.window) {
        [self resetAlgorithm];
    }
}

- (void)applicationEnteredForeground
{
    if (self.isViewLoaded && self.view.window) {
        [self startRunningSession];
    }
}

- (void)applicationEnteredBackground
{
    if (self.isViewLoaded && self.view.window) {
        [self stopRunningSession];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    // Create the session
    self.session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames
    self.session.sessionPreset = AVCaptureSessionPreset352x288;
    
    // Find a suitable AVCaptureDevice
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Create a device input with the device and add it to the session.
    NSError *error = nil;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:&error];
    
    if (!self.videoInput) {
        // Handling the error appropriately.
    }
    [self.session addInput:self.videoInput];
    
    // Create a VideoDataOutput and add it to the session
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // Configure your output.
    // Specify the pixel format
    self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    // shouldn't throw away frames
    self.frameOutput.alwaysDiscardsLateVideoFrames = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("frameOutputQueue", NULL);
    [self.frameOutput setSampleBufferDelegate:self queue:queue];
    
    [self.session addOutput:self.frameOutput];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    

    
//    self.bpmLabel = [[UILabel alloc] init];
//    self.bpmLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.bpmLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self.bpmLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.bpmLabel setTextColor:[UIColor blackColor]];
//    self.bpmLabel.font = [UIFont systemFontOfSize:HRKLabelFontSize];
//    [self.view addSubview:self.bpmLabel];
//    [self.view hrkPinAttribute:NSLayoutAttributeCenterX toAttribute:NSLayoutAttributeCenterX ofItem:self.bpmLabel];
//    [self.bpmLabel hrkPinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.statusLabel withConstant:HRKLabelToLabelTopPadding];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancelButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    [self.view hrkPinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeTop ofItem:self.cancelButton withConstant:-HRKTopButtonsVerticalPadding];
    [self.view hrkPinAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeLeft ofItem:self.cancelButton withConstant:-HRKTopButtonsVerticalPadding];
    [self setupViews];
    
    
}

-(void)cancelButtonAction:(UIButton*)sender {
    if ([self.delegate respondsToSelector:@selector(heartRateKitControllerDidCancel:)]) {
        [self.delegate heartRateKitControllerDidCancel:self];
    }
}

-(void)dismissWithResult:(HeartRateKitResult *)result {
    if ([self.delegate respondsToSelector:@selector(heartRateKitController:didFinishWithResult:)]) {
        [self.delegate heartRateKitController:self didFinishWithResult:result];
    }
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    self.isDetecting = TRUE;
    // Create a UIImage from the sample buffer data
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    // dispatch all the algorithm functionality to another thread
    dispatch_queue_t algorithmQueue = dispatch_queue_create("algorithm thread", NULL);
    dispatch_async(algorithmQueue, ^{
        UIColor *dominantColor = [image hrkAverageColorPrecise];// get the average color from the image
        CGFloat red , green , blue , alpha;
        [dominantColor getRed:&red green:&green blue:&blue alpha:&alpha];
        blue = blue*255.0f;
        green = green*255.0f;
        red = red*255.0f;
        [self.algorithm newFrameDetectedWithAverageColor:dominantColor];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSTimeInterval algorithmStartTime = kTimeToDetermineBPMFinalResultInSeconds - [[NSDate date] timeIntervalSinceDate:self.algorithmStartTime];
            if (algorithmStartTime < 16 && self.hitScreenHasShowed == false) {
                self.showHitScreen = true;
            } else {
                self.showHitScreen = false;
            }
            if (algorithmStartTime > 10) {
                self.hitLabel.text = [NSString stringWithFormat:@"Detecting pulse: %.0fs left" , algorithmStartTime];
                if (self.animationStared == false) {
                    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                    animation.values = [NSArray arrayWithObjects: @(1.0), @(1.2), @(1.0), nil];
                    animation.keyTimes = [NSArray arrayWithObjects: @(0.0), @(0.5), @(1.0), nil];
                    animation.duration = 1.0;
                    animation.repeatCount = INFINITY;
                    [self.heart.layer addAnimation:animation forKey:@"pulse"];
                    self.animationStared = true;
                }
                float progress = (20.0 - algorithmStartTime) / 20.0 ;
                [self.bpmProgress setProgress:progress animated:true];
            }
            
            if (self.algorithm.shouldShowLatestResult) {
                NSTimeInterval finalTime = kTimeToDetermineBPMFinalResultInSeconds - [[NSDate date] timeIntervalSinceDate:self.bpmFinalResultFirstTimeDetected];
                if (finalTime > 0) {
                    self.bpmValue.text = [NSString stringWithFormat:@"%.0f", self.algorithm.bpmLatestResult];
                    if ((finalTime - 10) > 0) {
                        self.hitLabel.text = [NSString stringWithFormat:@"Measuring heart rate: %.0fs left" , finalTime - 10];
                    }
                    float progress = ((20.0 - finalTime) / 20.0) + 0.5;
                    [self.bpmProgress setProgress:progress animated:true];
                    if (progress > 0.997) {
                        self.animationStared = false;
                        [self.heart.layer removeAllAnimations];
                        [self.bpmProgress setProgress:0.0 animated:true];
                        [self performSegueWithIdentifier:@"tags" sender:nil];
                    }
                }

            }
            self.bpmValue.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9];
            self.bpmLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
            if (self.algorithm.isFinalResultDetermined) {
                if (kTimeToDetermineBPMFinalResultInSeconds <= [[NSDate date] timeIntervalSinceDate:self.bpmFinalResultFirstTimeDetected]) {
                    [self.result markBPM:self.algorithm.bpmLatestResult];
                    [self dismissWithResult:self.result];
                    self.algorithm = nil;
                }
            } else {
                self.bpmFinalResultFirstTimeDetected = nil;
            }
            if (red < 190) {
                //finger isn't on camera
                if (kShouldAbortAfterSeconds > 0) {
                    if ([[NSDate date] timeIntervalSinceDate:self.algorithmStartTime] > kShouldAbortAfterSeconds) {
                        if (self.algorithm.isFinalResultDetermined) {
                            [self.result markBPM:self.algorithm.bpmLatestResult];
                            [self dismissWithResult:self.result];
                            self.algorithm = nil;
                            self.algorithmStartTime = nil;
                            self.bpmFinalResultFirstTimeDetected = nil;
                            return;  // stop execution
                        }
                    }
                }
                else {
                    if (self.algorithm.isFinalResultDetermined) {
                        [self.result markBPM:self.algorithm.bpmLatestResult];
                        [self dismissWithResult:self.result];
                        self.algorithm = nil;
                        self.algorithmStartTime = nil;
                        self.bpmFinalResultFirstTimeDetected = nil;
                        return;  // stop execution
                    }
                }
                self.isDetecting = FALSE;
                [self.heart.layer removeAllAnimations];
                self.animationStared = false;
                self.hitLabel.text = @"Please place your finger on the front camera";
                [self.bpmProgress setProgress:0.0 animated:true];
                self.bpmValue.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
                self.bpmLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
                self.bpmValue.text = @"00";
                self.algorithm = nil;
                self.algorithmStartTime = nil;
                self.bpmFinalResultFirstTimeDetected = nil;
                if (self.showHitScreen) {
                    [self showHit];
                } else {
                    
                }
                return; // stop execution
            }
        });
    });
}

// Create a UIImage from sample buffer data
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return image;
}

@end

