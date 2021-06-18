//
//  ColorPickerView.m
//  NotesManager
//
//  Created by Kristiyan Butev on 17.06.21.
//

#import "ColorPickerView.h"

#import <UIKit/UIKit.h>

#pragma mark - Layout

@interface ColorPickerViewFlowLayout: UICollectionViewFlowLayout

@property (nonatomic, assign) CGSize collectionSize;

@end

@implementation ColorPickerViewFlowLayout

- (void)prepareLayout {
    self.itemSize = CGSizeMake(self.collectionSize.width / 4, 64);
}

@end

#pragma mark - Cell

@interface ColorPickerViewCell: UICollectionViewCell
@end

@implementation ColorPickerViewCell
@end

#pragma mark - ColorPickerView

@interface ColorPickerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, copy) NSString* reuseID;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation ColorPickerView

@synthesize pickedColor = _pickedColor;

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.reuseID = NSStringFromClass([ColorPickerViewCell class]);
    
    [self configure];
}

- (void)configure {
    [self registerClass:[ColorPickerViewCell class] forCellWithReuseIdentifier:self.reuseID];
    
    ColorPickerViewFlowLayout* layout = [ColorPickerViewFlowLayout new];
    layout.collectionSize = self.frame.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionViewLayout = layout;
    self.dataSource = self;
    self.delegate = self;
    
    self.selectedIndex = 0;
    self.pickedColor = [self colorForIndex:self.selectedIndex];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorPickerViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseID forIndexPath:indexPath];
    
    NSInteger index = indexPath.row;
    
    cell.backgroundColor = [self colorForIndex:index];
    
    if (self.selectedIndex != index) {
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = UIColor.whiteColor.CGColor;
    } else {
        cell.layer.borderWidth = 0;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    _pickedColor = [self colorForIndex:self.selectedIndex];
    
    [self reloadData];
}

- (UIColor*)colorForIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return UIColor.systemRedColor;
        case 1:
            return UIColor.systemGreenColor;
        case 2:
            return UIColor.systemBlueColor;
        case 3:
            return UIColor.systemGrayColor;
        case 4:
            return UIColor.systemOrangeColor;
        case 5:
            return UIColor.systemYellowColor;
        case 6:
            return UIColor.systemPinkColor;
        case 7:
            return UIColor.systemPurpleColor;
        case 8:
            return UIColor.systemTealColor;
        case 9:
            return UIColor.systemIndigoColor;
        default:
            break;
    }
    
    return UIColor.systemIndigoColor;
}

- (UIColor*)pickedColor {
    return _pickedColor;
}

- (void)setPickedColor:(UIColor *)pickedColor {
    _pickedColor = pickedColor;
    
    for (int e = 0; e < 9; e++) {
        if ([[self colorForIndex:e] isEqual:pickedColor]) {
            self.selectedIndex = e;
            [self reloadData];
            break;
        }
    }
}

@end
