//
//  MainViewController.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "MainViewController.h"
#import "MainView.h"
#import "TaskCell.h"

#import "SettingsViewController.h"
#import "EditTaskViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate>

@property (nonatomic, strong) id<MainPresenter> presenter;
@property (readonly) MainView* baseView;

@end

@implementation MainViewController

- (MainView*)baseView {
    return (MainView*)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configure];
}

- (void)configure {
    NSString* cellNib = NSStringFromClass([TaskCell class]);
    [self.baseView.tasksTable registerNib:[UINib nibWithNibName:cellNib bundle:nil] forCellReuseIdentifier:TaskCell_CELL_ID];
    
    self.baseView.tasksTable.dataSource = self;
    self.baseView.tasksTable.delegate = self;
    self.baseView.tasksTable.dragInteractionEnabled = true;
    self.baseView.tasksTable.dragDelegate = self;
    self.baseView.tasksTable.dropDelegate = self;
    self.baseView.tasksTable.allowsMultipleSelectionDuringEditing = NO;
    
    [self.baseView.tasksTable reloadData];
    
    [self configurateNavigationBar];
}

- (void)configurateNavigationBar {
    self.title = @"Tasks";
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self.presenter action:@selector(onSettingsTap)];
    UIBarButtonItem *addTaskButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self.presenter action:@selector(onAddTaskTap)];
    
    self.navigationItem.leftBarButtonItem = settingsButton;
    self.navigationItem.rightBarButtonItem = addTaskButton;
}

#pragma mark - Data

- (TaskViewItem*)taskAtIndex:(NSIndexPath *)indexPath {
    NSInteger i = indexPath.row;
    return indexPath.section == 0 ? [self.presenter.activeTasks objectAtIndex:i] : [self.presenter.inactiveTasks objectAtIndex:i];
}

#pragma mark - MainPresenterDelegate

- (void)reloadData {
    [self.baseView.tasksTable reloadData];
}

- (void)openSettingsScreenWithPresenter:(nonnull id<SettingsPresenter>)presenter {
    SettingsViewController* vc = [SettingsViewController buildWithPresenter:presenter];
    presenter.delegate = vc;
    [presenter reloadData];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)openCreateTaskScreenWithPresenter:(nonnull id<EditTaskPresenter>)presenter {
    EditTaskViewController* vc = [EditTaskViewController buildWithPresenter:presenter];
    vc.navigationTitle = @"Create";
    presenter.delegate = vc;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)openEditTaskScreenWithPresenter:(nonnull id<EditTaskPresenter>)presenter {
    EditTaskViewController* vc = [EditTaskViewController buildWithPresenter:presenter];
    vc.navigationTitle = presenter.name;
    vc.isExpireButtonVisible = true;
    presenter.delegate = vc;
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.presenter onTaskDelete:[self taskAtIndex:indexPath]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.presenter onTaskTap:[self taskAtIndex:indexPath]];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.presenter.allTasks.count == 0) {
        return 1;
    }
    
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.presenter.allTasks.count == 0) {
        return @"No tasks";
    }
    
    return section == 0 ? @"Tasks" : @"Completed Tasks";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 0) {
        return self.presenter.inactiveTasks.count;
    }
    
    return self.presenter.activeTasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<TaskViewItem*>* tasks = indexPath.section == 0 ? self.presenter.activeTasks : self.presenter.inactiveTasks;
    
    TaskCell* cell = (TaskCell*)[tableView dequeueReusableCellWithIdentifier:TaskCell_CELL_ID];
    TaskViewItem* itemData = [tasks objectAtIndex:indexPath.row];
    cell.nameLabel.text = itemData.name;
    cell.solidColorView.backgroundColor = itemData.categoryColor;
    [cell setExpiration:itemData.expiration];
    return cell;
}

#pragma mark - UITableViewDragDelegate

- (NSArray<UIDragItem *> *)tableView:(UITableView *)tableView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return [NSArray new];
    }
    
    UIDragItem* dragItem = [[UIDragItem alloc] initWithItemProvider:[NSItemProvider new]];
    dragItem.localObject = indexPath;
    
    return @[ dragItem ];
}

#pragma mark - UITableViewDropDelegate

- (UITableViewDropProposal *)tableView:(UITableView *)tableView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(nullable NSIndexPath *)destinationIndexPath {
    if (destinationIndexPath.section != 0) {
        return [[UITableViewDropProposal alloc] initWithDropOperation:UIDropOperationCancel];
    }
    
    return [[UITableViewDropProposal alloc] initWithDropOperation:UIDropOperationMove];
}

- (void)tableView:(UITableView *)tableView performDropWithCoordinator:(id<UITableViewDropCoordinator>)coordinator {
    id<UITableViewDropItem> dropItem = coordinator.items.firstObject;
    
    NSIndexPath* index = dropItem.dragItem.localObject;
    
    [self.presenter onExpireTask:[self taskAtIndex:index]];
}

@end

@implementation MainViewController (BUILD)

+ (nonnull MainViewController*)buildWithPresenter:(nonnull id<MainPresenter>)presenter {
    MainViewController* vc = [MainViewController new];
    vc.presenter = presenter;
    return vc;
}

@end
