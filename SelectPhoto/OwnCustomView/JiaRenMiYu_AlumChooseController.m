//
//  AlumChooseController.m
//  VChatApp
//
//  Created by LewisC on 2019/2/21.
//  Copyright © 2019年 Super. All rights reserved.
//

#import "JiaRenMiYu_AlumChooseController.h"
#import <Photos/Photos.h>
#import "JiaRenMiYu_AlumViewCell.h"
#import "ImageSelectCell.h"
#import "SelectImgtypeModel.h"
#import "RSKImageCropper.h"
#import "Masonry.h"
//#import "JiaRenMiYu_ImagecatController.h"
//#import "JiaRenMiYu_PermitView.h"
#define StatuBar_Height  ([UIScreen mainScreen ].bounds.size.height >= 812.0 ? 44 : 20)

#define SCREEN_Width [UIScreen mainScreen].bounds.size.width

#define SCREEN_Height [UIScreen mainScreen].bounds.size.height

#define kRGB_alpha(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define WeakSelf __weak typeof(self) weakSelf = self;

static NSString *imageCell = @"ImageSelectCell";
static NSString *identFier = @"AlumViewCell";
@interface JiaRenMiYu_AlumChooseController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
/// 开启相机权限的视图
//@property(nonatomic, strong)JiaRenMiYu_PermitView *JiaRenMiYuBLM_photoView;
/// 返回按钮
@property(nonatomic, strong)UIButton *JiaRenMiYuBLM_backBtn;

/// 标题
@property(nonatomic, strong)UILabel *JiaRenMiYuBLM_titleLabel;

///下拉显示
@property(nonatomic, strong)UIImageView *showmoreImg;

/// 底部图片
@property(nonatomic, strong)UIImageView *JiaRenMiYuBLM_bottomImg;

/// 底部标签
@property(nonatomic, strong)UILabel *JiaRenMiYuBLM_bottomLabel;

/// 图片布局
@property(nonatomic, strong)UICollectionView *JiaRenMiYuBLM_dataCollectView;

/// 带缓存的图片管理器
@property(nonatomic, strong)PHCachingImageManager *JiaRenMiYuBLM_imageManager;

/// 取得的资源结果，用于存放PHAsset
@property(nonatomic, strong)PHFetchResult<PHAsset *> *JiaRenMiYuBLM_assetsFetchResults;

/// 缩略图大小
@property(nonatomic, assign)CGSize JiaRenMiYuBLM_assetGridThumbnailSize;

/// 图片选择器
@property(nonatomic,strong)UIImagePickerController *JiaRenMiYuBLM_imagePicker;


/// 类型选择视图
@property(nonatomic, strong)UITableView *typeTable;

/// 类型选择的透明背景
@property(nonatomic, strong)UIView *typeselectBack;

/// 存储本地相册的数量
@property(nonatomic, strong)NSMutableArray *alumArr;

@end

@implementation JiaRenMiYu_AlumChooseController
- (NSMutableArray *)alumArr{
    if (!_alumArr) {
        _alumArr = [[NSMutableArray alloc] init];
    }
    return _alumArr;
}

- (UIView *)typeselectBack{
    if (!_typeselectBack) {
        _typeselectBack = [[UIView alloc]  init];
        _typeselectBack.backgroundColor = [UIColor clearColor];
        /// 背景的点击
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(typebackClick)];
        _typeselectBack.userInteractionEnabled = YES;
        [_typeselectBack addGestureRecognizer:backTap];
    }
    return _typeselectBack;
}

- (UITableView *)typeTable{
    if (!_typeTable) {
        _typeTable = [[UITableView alloc]  initWithFrame:CGRectMake(0,StatuBar_Height + 48, SCREEN_Width, 0) style:UITableViewStyleGrouped];
        _typeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_typeTable registerNib:[UINib nibWithNibName:@"ImageSelectCell" bundle:nil] forCellReuseIdentifier:imageCell];
        _typeTable.showsVerticalScrollIndicator = NO;
        _typeTable.delegate = self;
        _typeTable.dataSource = self;
        UIView *headView = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, SCREEN_Width, 0.1)];
        headView.backgroundColor = [UIColor clearColor];
        _typeTable.tableHeaderView = headView;
        _typeTable.backgroundColor = [UIColor whiteColor];
    }
    return _typeTable;
}
//- (JiaRenMiYu_PermitView *)JiaRenMiYuBLM_photoView{
//    if (!_JiaRenMiYuBLM_photoView) {
//        _JiaRenMiYuBLM_photoView = [[JiaRenMiYu_PermitView alloc]  init];
//        _JiaRenMiYuBLM_photoView.delegate = self;
//        _JiaRenMiYuBLM_photoView.frame = CGRectMake(0, 0, SCREEN_Width, SCREEN_Height);
//        _JiaRenMiYuBLM_photoView.backgroundColor = kRGB_alpha(0, 0, 0, 0.5);// RGB(0, 0, 0, 0.5);
//    }
//    return _JiaRenMiYuBLM_photoView;
//}

- (UIImagePickerController *)JiaRenMiYuBLM_imagePicker{
    if (!_JiaRenMiYuBLM_imagePicker) {
        _JiaRenMiYuBLM_imagePicker = [[UIImagePickerController alloc] init];
        //_JiaRenMiYuBLM_imagePicker.delegate = self;
        _JiaRenMiYuBLM_imagePicker.allowsEditing = YES;
        _JiaRenMiYuBLM_imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    return _JiaRenMiYuBLM_imagePicker;
}

- (PHCachingImageManager *)JiaRenMiYuBLM_imageManager{
    if (!_JiaRenMiYuBLM_imageManager) {
        _JiaRenMiYuBLM_imageManager = [[PHCachingImageManager alloc]  init];
    }
    return _JiaRenMiYuBLM_imageManager;
}

- (PHFetchResult<PHAsset *> *)JiaRenMiYuBLM_assetsFetchResults{
    if (!_JiaRenMiYuBLM_assetsFetchResults) {
        _JiaRenMiYuBLM_assetsFetchResults = [[PHFetchResult<PHAsset *>  alloc]  init];
    }
    return  _JiaRenMiYuBLM_assetsFetchResults;
}

- (UICollectionView *)JiaRenMiYuBLM_dataCollectView{
    if (!_JiaRenMiYuBLM_dataCollectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]  init];
        layout.itemSize = CGSizeMake(SCREEN_Width/3.0, SCREEN_Width/3.0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _JiaRenMiYuBLM_dataCollectView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, StatuBar_Height + 48, SCREEN_Width, SCREEN_Height - 48 - StatuBar_Height) collectionViewLayout:layout];
        _JiaRenMiYuBLM_dataCollectView.backgroundColor = [UIColor whiteColor];
        _JiaRenMiYuBLM_dataCollectView.showsVerticalScrollIndicator = NO;
        _JiaRenMiYuBLM_dataCollectView.delegate = self;
        _JiaRenMiYuBLM_dataCollectView.dataSource = self;
        _JiaRenMiYuBLM_dataCollectView.bounces = YES;
    }
    return _JiaRenMiYuBLM_dataCollectView;
}


- (UIButton *)JiaRenMiYuBLM_backBtn{
    if (!_JiaRenMiYuBLM_backBtn) {
        _JiaRenMiYuBLM_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_JiaRenMiYuBLM_backBtn initButtonWithTitle:@"" font:[UIFont systemFontOfSize:0.0] image:@"" backImage:@"newBack"];
        //[_JiaRenMiYuBLM_backBtn setBackgroundImage:[UIImage imageNamed:@"返回 拷贝"] forState:UIControlStateNormal];
        [_JiaRenMiYuBLM_backBtn setImage:[UIImage imageNamed:@"me_back"] forState:UIControlStateNormal];
        [_JiaRenMiYuBLM_backBtn setImage:[UIImage imageNamed:@"me_back"] forState:UIControlStateHighlighted];
        [_JiaRenMiYuBLM_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _JiaRenMiYuBLM_backBtn;
}


- (UILabel *)JiaRenMiYuBLM_titleLabel{
    if (!_JiaRenMiYuBLM_titleLabel) {
        _JiaRenMiYuBLM_titleLabel = [[UILabel alloc]  init];
       // [_JiaRenMiYuBLM_titleLabel initLabelWithTitle:@"选择照片" font:20 textColor:RGB(0, 0, 0, 1) backColor:[UIColor clearColor] alignment:NSTextAlignmentCenter];
        _JiaRenMiYuBLM_titleLabel.text = @"";
        _JiaRenMiYuBLM_titleLabel.font = [UIFont systemFontOfSize:20];
        _JiaRenMiYuBLM_titleLabel.textColor = kRGB_alpha(0, 0, 0, 1);
        _JiaRenMiYuBLM_titleLabel.textAlignment = NSTextAlignmentCenter;
        _JiaRenMiYuBLM_titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        ///  点击
        UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(selectClick)];
        _JiaRenMiYuBLM_titleLabel.userInteractionEnabled = YES;
        [_JiaRenMiYuBLM_titleLabel addGestureRecognizer:selectTap];
    }
    return _JiaRenMiYuBLM_titleLabel;
}

- (UIImageView *)showmoreImg{
    if (!_showmoreImg) {
        _showmoreImg = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"photosMore"]];
    }
    return _showmoreImg;
}


- (UIImageView *)JiaRenMiYuBLM_bottomImg{
    if (!_JiaRenMiYuBLM_bottomImg) {
        _JiaRenMiYuBLM_bottomImg = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"morephoto"]];
    }
    return _JiaRenMiYuBLM_bottomImg;
}

- (UILabel *)JiaRenMiYuBLM_bottomLabel{
    if (!_JiaRenMiYuBLM_bottomLabel) {
        _JiaRenMiYuBLM_bottomLabel = [[UILabel alloc]  init];
        //[_JiaRenMiYuBLM_bottomLabel initLabelWithTitle:@"最近照片" font:15 textColor:RGB(80, 80, 80, 1.0) backColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        _JiaRenMiYuBLM_bottomLabel.text = @"";
        _JiaRenMiYuBLM_bottomLabel.font = [UIFont systemFontOfSize:15];
        _JiaRenMiYuBLM_bottomLabel.textAlignment  = NSTextAlignmentLeft;
        _JiaRenMiYuBLM_bottomLabel.textColor = kRGB_alpha(80, 80, 80, 1.0);
    }
    
    return _JiaRenMiYuBLM_bottomLabel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    CGSize cellSize = CGSizeMake(SCREEN_Width/3.0, SCREEN_Width/3.0);
    self.JiaRenMiYuBLM_assetGridThumbnailSize = CGSizeMake(cellSize.width, cellSize.height);
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self JiaRenMiYuFFM_setUI];
    [self JiaRenMiYuFFM_snapView];
    [self.view addSubview:self.JiaRenMiYuBLM_dataCollectView];
    [self.JiaRenMiYuBLM_dataCollectView registerClass:[JiaRenMiYu_AlumViewCell class] forCellWithReuseIdentifier:identFier];
    
    /// 初始化和重置缓存
    [self JiaRenMiYuFFM_resetCachedAssets];
    [self JiaRenMiYuFFM_getAllPHasset];
    // Do any additional setup after loading the view.
}


/// 选择的点击
- (void)selectClick{
    self.typeTable.frame = CGRectMake(0, StatuBar_Height + 48, SCREEN_Width, 0);
    self.typeselectBack.frame = CGRectMake(0, 0, SCREEN_Width , SCREEN_Height);
    [[[UIApplication sharedApplication] keyWindow ] addSubview:self.typeselectBack];
    [[[UIApplication sharedApplication]  keyWindow] addSubview:self.typeTable];
    [UIView animateWithDuration:0.25f animations:^{
        self.showmoreImg.transform = CGAffineTransformMakeRotation(M_PI);
        
    } completion:^(BOOL finished) {
        
    }];
    /// 速度 匀速  振动幅度  移动初始速度
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.typeTable.frame = CGRectMake(0, StatuBar_Height + 48, SCREEN_Width, SCREEN_Height/2);
        
    } completion:^(BOOL finished) {
        
    }];
}



- (void)JiaRenMiYuFFM_setUI{
    
    [self.view addSubview:self.JiaRenMiYuBLM_backBtn];
    [self.view addSubview:self.JiaRenMiYuBLM_titleLabel];
    [self.view addSubview:self.showmoreImg];
   // [self.view  addSubview:self.JiaRenMiYuBLM_bottomImg];
    //[self.view addSubview:self.JiaRenMiYuBLM_bottomLabel];
    
//    UIView *bottomView = [[UIView alloc]  init];
//    bottomView.backgroundColor =  kRGB(255, 255, 255); //RGB(255, 255, 255, 1.0);
//    [self.view addSubview:bottomView];
//    [self.view addSubview:self.JiaRenMiYuBLM_bottomImg];
//    [self.view addSubview:self.JiaRenMiYuBLM_bottomLabel];
//
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(self.view);
//        make.height.mas_equalTo(53);
//    }];
//
//    [self.JiaRenMiYuBLM_bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(bottomView.mas_left).offset(15);
//        make.centerY.equalTo(bottomView);
//        make.size.mas_equalTo(CGSizeMake(12, 15));
//    }];
//
//    [self.JiaRenMiYuBLM_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(bottomView);
//        make.left.equalTo(self.JiaRenMiYuBLM_bottomImg.mas_right).offset(12);
//    }];
    
}

- (void)JiaRenMiYuFFM_snapView{
    [self.JiaRenMiYuBLM_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(StatuBar_Height + 14);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.JiaRenMiYuBLM_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.JiaRenMiYuBLM_backBtn);
        make.left.equalTo(self.JiaRenMiYuBLM_backBtn.mas_right).offset(15);
    }];
    
    [self.showmoreImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.JiaRenMiYuBLM_backBtn);
        make.left.equalTo(self.JiaRenMiYuBLM_titleLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(12, 6));
    }];
}

- (void)JiaRenMiYuFFM_resetCachedAssets{
    
    [self.JiaRenMiYuBLM_imageManager stopCachingImagesForAllAssets];
}

- (void)JiaRenMiYuFFM_getAllPHasset{
    PHFetchOptions *smarts = [[PHFetchOptions alloc]  init];
    PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:smarts];
    //[self JiaRenMiYuFFM_convertCollect:smartAlbums];
    [self transferAlumDataWith:smartAlbums];
}


/// 获取选择的数组
- (void)transferAlumDataWith:(PHFetchResult<PHAssetCollection*> *)collection{
    [self.alumArr removeAllObjects];
    for (NSInteger j = 0; j < collection.count; j++) {
        // 获取当前相簿内的图片
        PHFetchOptions *resultOption = [[PHFetchOptions alloc] init];
        resultOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        resultOption.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
        PHAssetCollection *c = collection[j];
        PHFetchResult<PHAsset *> *assetsFetchResult =  [PHAsset fetchAssetsInAssetCollection:c options:resultOption];
        if (assetsFetchResult.count > 0) {
            PHAsset *asset  = assetsFetchResult[0];
            ///获取缩略图
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            option.resizeMode = PHImageRequestOptionsResizeModeFast;//控制照片尺寸
            option.synchronous = YES;//主要是这个设为YES这样才会只走一次
            option.networkAccessAllowed = YES;
            CGSize targetSize = CGSizeMake(32, 32);
            [self.JiaRenMiYuBLM_imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                SelectImgtypeModel *model = [[SelectImgtypeModel alloc]  init];
                model.img = result;
                model.name = c.localizedTitle;
                model.number = [NSString stringWithFormat:@"%ld", assetsFetchResult.count];
                model.assetsFetchResult = assetsFetchResult;
                [self.alumArr addObject:model];
            }];
        }
    }
    SelectImgtypeModel *firstModel = [self.alumArr objectAtIndex:0];
    [self bindDataWithModel:firstModel];
    [self.typeTable reloadData];
}

/// 根据选择的相册更新数据
- (void)bindDataWithModel:(SelectImgtypeModel *)model{
    self.JiaRenMiYuBLM_assetsFetchResults = model.assetsFetchResult;
    self.JiaRenMiYuBLM_titleLabel.text = model.name;
    [self.JiaRenMiYuBLM_dataCollectView reloadData];
    
}

/// 转化处理获取到的相簿
- (void)JiaRenMiYuFFM_convertCollect:(PHFetchResult<PHAssetCollection*> *)collection{
    for (NSInteger j = 0; j < collection.count; j++) {
        // 获取当前相簿内的图片
        PHFetchOptions *resultOption = [[PHFetchOptions alloc] init];
        resultOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        resultOption.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
        
        PHAssetCollection *c = collection[j];
        // 最近添加的  Recently Added info中配置转为中文  最近添加   所有照片
        if ([c.localizedTitle isEqualToString:@"相机胶卷"]||[c.localizedTitle isEqualToString:@"所有照片"]) {
            PHFetchResult<PHAsset *> *assetsFetchResult =  [PHAsset fetchAssetsInAssetCollection:c options:resultOption];
            self.JiaRenMiYuBLM_assetsFetchResults = assetsFetchResult;
            [self.JiaRenMiYuBLM_dataCollectView reloadData];
        }
    }
}

/// 选择视图的消失
- (void)typebackClick{
    [UIView animateWithDuration:0.25f animations:^{
        self.showmoreImg.transform = CGAffineTransformIdentity; //CGAffineTransformMakeRotation(2*M_PI); 
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.typeTable.frame = CGRectMake(0, StatuBar_Height + 48, SCREEN_Width, 0);
    } completion:^(BOOL finished) {
        [self.typeTable removeFromSuperview];
        [self.typeselectBack removeFromSuperview];
    }];
}

/// 返回
- (void)backClick{
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}

#pragma mark -UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return  self.JiaRenMiYuBLM_assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JiaRenMiYu_AlumViewCell *cell = (JiaRenMiYu_AlumViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identFier forIndexPath:indexPath];
//    if (indexPath.row == 0) {
//        cell.JiaRenMiYuBLM_takeImg.hidden = NO;
//        cell.JiaRenMiYuBLM_backImg.hidden = YES;
//    }else{
        cell.JiaRenMiYuBLM_takeImg.hidden = YES;
        cell.JiaRenMiYuBLM_backImg.hidden = NO;
        PHAsset *asset = self.JiaRenMiYuBLM_assetsFetchResults[indexPath.row];
        WeakSelf;
        /// 缩略图
        [self.JiaRenMiYuBLM_imageManager requestImageForAsset:asset targetSize:self.JiaRenMiYuBLM_assetGridThumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.JiaRenMiYuBLM_backImg.image = result;
            [weakSelf.JiaRenMiYuBLM_imageManager stopCachingImagesForAllAssets];
        }];
   // }
    return cell;
}


/// 选择item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 0) {
//        /// 是否开启相机权限
//        if ([GlobalauthorityTool isPermitCamera] == NO) {
//
//            self.JiaRenMiYuBLM_photoView.JiaRenMiYuBLM_type = 2;
//            self.JiaRenMiYuBLM_photoView.hidden = NO;
//            [self.JiaRenMiYuBLM_photoView JiaRenMiYuFFM_loadContentView];
//            [[[UIApplication sharedApplication]keyWindow] addSubview:self.JiaRenMiYuBLM_photoView];
//        }else{
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//
//                [self presentViewController:self.JiaRenMiYuBLM_imagePicker animated:YES completion:nil];
//            }
//        }
//
//    }else{
        PHAsset *asset = self.JiaRenMiYuBLM_assetsFetchResults[indexPath.row ];
        
        /// CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 80)
        ///获取缩略图
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        /**
         resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
         deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
         这个属性只有在 synchronous 为 true 时有效。
         */
        option.resizeMode = PHImageRequestOptionsResizeModeFast;//控制照片尺寸
        //option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
        option.synchronous = YES;//主要是这个设为YES这样才会只走一次
        option.networkAccessAllowed = YES;
        [self.JiaRenMiYuBLM_imageManager  requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result.size.width >= SCREEN_Width) {
                
                RSKImageCropViewController *imageCropVc = [[RSKImageCropViewController alloc] initWithImage:result cropMode:RSKImageCropModeSquare];
                imageCropVc.avoidEmptySpaceAroundImage  = YES;
                imageCropVc.delegate = self;
                //[self.navigationController pushViewController:imageCropVc animated:YES];
                [self presentViewController:imageCropVc animated:YES completion:nil];
            }
        }];
}




#pragma mark - PhotoClipperDelegate
//- (void)didFinishClippingPhoto:(UIImage *)image{
//        if (self.delegate) {
//        if ([self.delegate respondsToSelector:@selector(didSelectPhoto:)]) {
//            [self.delegate didSelectPhoto:image];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }
//}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
//     [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(didSelectPhoto:)]) {
                [self.delegate didSelectPhoto:croppedImage];
                
            }
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.alumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageSelectCell *cell = (ImageSelectCell *) [tableView dequeueReusableCellWithIdentifier:imageCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.alumArr.count) {
        cell.selectModel = self.alumArr[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return  48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self typebackClick];
    SelectImgtypeModel *model = self.alumArr[indexPath.row];
    [self bindDataWithModel:model];
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end
