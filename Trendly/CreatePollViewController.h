//
//  CreatePollViewController.h
//  Trendly
//
//  Created by Michael Scaria on 4/7/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePollViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableDictionary *dictionary;
    NSMutableArray *selected;
    NSMutableArray *selectedItems;
}
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSArray *searchResults;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *createButton;

- (IBAction)clear:(id)sender;
- (IBAction)create:(id)sender;

@end
