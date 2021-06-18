//
//  EditTaskViewController.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "EditTaskViewController.h"
#import "EditTaskView.h"

@interface EditTaskViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) id<EditTaskPresenter> presenter;
@property (readonly) EditTaskView* baseView;
@property (nonatomic, strong) NSArray<CategoryViewItem*>* categories;

@end

@implementation EditTaskViewController

- (EditTaskView*)baseView {
    return (EditTaskView*)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)configure {
    self.baseView.nameTextField.delegate = self;
    
    if (!self.presenter.isCreate) {
        [self.baseView.nameTextField setEnabled:false];
    }
    
    self.baseView.nameTextField.text = self.presenter.name;
    [self.baseView.datePicker setDate:self.presenter.expiration];
    
    self.categories = self.presenter.availableCategories;
    
    self.baseView.categoriesPicker.delegate = self;
    self.baseView.categoriesPicker.dataSource = self;
    [self.baseView.categoriesPicker reloadAllComponents];
    
    NSInteger selectedRow = 0;
    
    for (CategoryViewItem* category in self.categories) {
        if ([category.name isEqual:self.presenter.categoryName]) {
            [self.baseView.categoriesPicker selectRow:selectedRow inComponent:0 animated:NO];
            break;
        }
        
        selectedRow += 1;
    }
    
    self.baseView.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    
    [self.baseView.notificationSwitch setOn:self.presenter.notifyOnExpiration];
    
    [self configurateNavigationBar];
}

- (void)configurateNavigationBar {
    self.title = self.navigationTitle;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(onSaveTap)];
    
    if (!self.isExpireButtonVisible) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"< Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        
        self.navigationItem.leftBarButtonItem = cancelButton;
        self.navigationItem.rightBarButtonItem = saveButton;
    } else {
        saveButton.title = @"< Save";
        
        UIBarButtonItem *expireButton = [[UIBarButtonItem alloc] initWithTitle:@"Expire" style:UIBarButtonItemStylePlain target:self action:@selector(onExpire)];
        
        self.navigationItem.leftBarButtonItem = saveButton;
        self.navigationItem.rightBarButtonItem = expireButton;
    }
}

- (void)updatePresenterWithLatestData {
    self.presenter.name = self.baseView.nameTextField.text;
    [self textFieldShouldReturn:self.baseView.nameTextField];
    self.presenter.expiration = self.baseView.datePicker.date;
    self.presenter.notifyOnExpiration = [self.baseView.notificationSwitch isOn];
}

- (void)onSaveTap {
    [self updatePresenterWithLatestData];
    
    BOOL result = [self.presenter saveChanges];
    
    if (!result) {
        return;
    }
    
    [self goBack];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)onExpire {
    [self.presenter expireTask];
    
    UIAlertController* alert = [[UIAlertController alloc] init];
    [alert setTitle:@"Alert"];
    [alert setMessage:@"Task expired."];
    
    __weak typeof(self) weakSelf = self;
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [weakSelf goBack];
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - EditTaskPresenterDelegate

- (void)showUnknownErrorAlert {
    UIAlertController* alert = [[UIAlertController alloc] init];
    [alert setTitle:@"Error"];
    [alert setMessage:@"Unknown error."];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showNameIsTakenAlert {
    UIAlertController* alert = [[UIAlertController alloc] init];
    [alert setTitle:@"Error"];
    [alert setMessage:@"Name is taken, please pick another."];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showNameIsInvalidAlert {
    UIAlertController* alert = [[UIAlertController alloc] init];
    [alert setTitle:@"Error"];
    [alert setMessage:@"Name is too long or contains invalid characters."];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showExpirationDateInvalidAlert {
    UIAlertController* alert = [[UIAlertController alloc] init];
    [alert setTitle:@"Error"];
    [alert setMessage:@"Expiration date must take place in the future."];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.presenter.availableCategories.count;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component API_AVAILABLE(ios(6.0)) API_UNAVAILABLE(tvos) {
    CategoryViewItem* category = [self.categories objectAtIndex:row];
    NSString* name = category.name;
    UIColor* color = category.color;
    return [[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName : color}];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component API_UNAVAILABLE(tvos) {
    CategoryViewItem* category = [self.categories objectAtIndex:row];
    self.presenter.categoryName = category.name;
}

@end

@implementation EditTaskViewController (BUILD)

+ (nonnull EditTaskViewController*)buildWithPresenter:(nonnull id<EditTaskPresenter>)presenter {
    EditTaskViewController* vc = [EditTaskViewController new];
    vc.presenter = presenter;
    return vc;
}

@end
