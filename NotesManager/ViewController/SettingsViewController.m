//
//  SettingsViewController.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "SettingsViewController.h"
#import "EditCategoryViewController.h"
#import "SettingsView.h"
#import "CategoryCell.h"
#import "CategoryViewItem.h"
#import "GeneralSettings.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<SettingsPresenter> presenter;
@property (readonly) SettingsView* baseView;

@end

@implementation SettingsViewController

- (SettingsView*)baseView {
    return (SettingsView*)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configure];
}

- (void)configure {
    NSString* cellNib = NSStringFromClass([CategoryCell class]);
    [self.baseView.categoriesTable registerNib:[UINib nibWithNibName:cellNib bundle:nil] forCellReuseIdentifier:CategoryCell_CELL_ID];
    
    self.baseView.categoriesTable.dataSource = self;
    self.baseView.categoriesTable.delegate = self;
    
    [self.baseView.categoriesTable reloadData];
    
    [self.baseView.notificationsEnabledButton addTarget:self action:@selector(onNotificationsButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self updateNotificationsEnabledButtonTitle];
    
    [self.baseView.sortingButton addTarget:self action:@selector(onSortingButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self updateSortingButtonTitle];
    
    [self configurateNavigationBar];
}

- (void)configurateNavigationBar {
    self.title = @"Settings";
    
    UIBarButtonItem *categoriesButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self.presenter action:@selector(onAddCategoryTap)];
    
    self.navigationItem.rightBarButtonItem = categoriesButton;
}

- (void)updateNotificationsEnabledButtonTitle {
    NSString* title = [GeneralSettings shared].isNotificationDeliveryOn ? @"Enabled" : @"Disabled";
    [self.baseView.notificationsEnabledButton setTitle:title forState:UIControlStateNormal];
}

- (void)onNotificationsButtonTap {
    [self.presenter onNotificationsEnabledTap];
    [self updateNotificationsEnabledButtonTitle];
}

- (void)updateSortingButtonTitle {
    [self.baseView.sortingButton setTitle:[GeneralSettings shared].tasksSortingAsString forState:UIControlStateNormal];
}

- (void)onSortingButtonTap {
    [self.presenter onSortingTap];
    [self updateSortingButtonTitle];
}

#pragma mark - SettingsPresenterDelegate

- (void)reloadData {
    [self.baseView.categoriesTable reloadData];
}

- (void)openCreateCategoryScreenWithPresenter:(nonnull id<EditCategoryPresenter>)presenter {
    EditCategoryViewController* vc = [EditCategoryViewController buildWithPresenter:presenter];
    vc.navigationTitle = @"Create";
    presenter.delegate = vc;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)openEditCategoryScreenWithPresenter:(nonnull id<EditCategoryPresenter>)presenter {
    EditCategoryViewController* vc = [EditCategoryViewController buildWithPresenter:presenter];
    vc.navigationTitle = presenter.name;
    presenter.delegate = vc;
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.presenter onCategoryTap:[self.presenter.data objectAtIndex:indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCell* cell = (CategoryCell*)[tableView dequeueReusableCellWithIdentifier:CategoryCell_CELL_ID];
    CategoryViewItem* itemData = [[self.presenter data] objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%lu tasks)", itemData.name, (unsigned long)itemData.numberOfTasks];
    cell.solidColorView.backgroundColor = itemData.color;
    return cell;
}

@end

@implementation SettingsViewController (BUILD)

+ (nonnull SettingsViewController*)buildWithPresenter:(nonnull id<SettingsPresenter>)presenter {
    SettingsViewController* vc = [SettingsViewController new];
    vc.presenter = presenter;
    return vc;
}

@end
