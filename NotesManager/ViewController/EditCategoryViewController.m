//
//  EditCategoryViewController.m
//  NotesManager
//
//  Created by Kristiyan Butev on 16.06.21.
//

#import "EditCategoryViewController.h"
#import "EditCategoryView.h"

@interface EditCategoryViewController () <UITextFieldDelegate>

@property (nonatomic, strong) id<EditCategoryPresenter> presenter;
@property (readonly) EditCategoryView* baseView;

@end

@implementation EditCategoryViewController

- (EditCategoryView*)baseView {
    return (EditCategoryView*)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)configure {
    self.baseView.nameTextField.delegate = self;
    
    self.baseView.nameTextField.text = self.presenter.name;
    
    if (!self.presenter.isCreate) {
        [self.baseView.nameTextField setEnabled:false];
        
        self.baseView.pickedColor = self.presenter.color;
    }
    
    [self configurateNavigationBar];
}

- (void)configurateNavigationBar {
    self.title = self.navigationTitle;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(onSaveTap)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"< Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)updatePresenterWithLatestData {
    self.presenter.name = self.baseView.nameTextField.text;
    [self textFieldShouldReturn:self.baseView.nameTextField];
    self.presenter.color = self.baseView.pickedColor;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - EditCategoryPresenterDelegate

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

@end

@implementation EditCategoryViewController (BUILD)

+ (nonnull EditCategoryViewController*)buildWithPresenter:(nonnull id<EditCategoryPresenter>)presenter {
    EditCategoryViewController* vc = [EditCategoryViewController new];
    vc.presenter = presenter;
    return vc;
}

@end
