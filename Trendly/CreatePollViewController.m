//
//  CreatePollViewController.m
//  Trendly
//
//  Created by Michael Scaria on 4/7/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "CreatePollViewController.h"
#import "Session.h"
#import "Model.h"
#import "Item.h"

@interface CreatePollViewController ()

@end

@implementation CreatePollViewController
@synthesize textField, name;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![Session sharedInstance].user) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In" message:@"You have to be logged in to create a contest!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else {
        self.name.font = [UIFont fontWithName:@"Fabrica" size:12];
        self.name.text = [NSString stringWithFormat:@"%@ asks...", [Session sharedInstance].user.username];
        dictionary = [[NSMutableDictionary alloc] init];
        selected = [[NSMutableArray alloc] init];
        selectedItems = [[NSMutableArray alloc] init];
        [[Model sharedInstance] searchRewardStyle:@"Chanel" completion:^(NSArray *itemsArray){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.searchResults = itemsArray;
                [self.collectionView reloadData];
            }];
        }];
    }
}

- (IBAction)clear:(id)sender {
    self.textField.text = @"";
}

- (void)remove:(UIButton *)button {
    NSLog(@"%d", button.tag);
    UIView *selectedView = [selected objectAtIndex:button.tag];
    [selected removeObjectAtIndex:button.tag];
    [selectedItems removeObjectAtIndex:button.tag];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        selectedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        for (int i = button.tag; i < 3; i++) {
            UIView *animateView = [selected objectAtIndex:i];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                animateView.frame = CGRectMake(animateView.frame.origin.x - 79, animateView.frame.origin.y, animateView.frame.size.width, animateView.frame.size.height);
            } completion:nil];

        }
    }];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
     [self.tabBarController setSelectedIndex:0];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    [tf resignFirstResponder];
    if (tf.text.length > 1) {
        [[Model sharedInstance] searchRewardStyle:tf.text completion:^(NSArray *itemsArray){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.searchResults = itemsArray;
                [self.collectionView reloadData];
            }];
        }];
    }
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SearchResult";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *itemImageView = (UIImageView *)[cell viewWithTag:100];
    UIActivityIndicatorView *av = (UIActivityIndicatorView *)[cell viewWithTag:101];
    [av startAnimating];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Item *item = self.searchResults[indexPath.row];
        UIImage *image;
        if (![dictionary valueForKey:item.imageURL]) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.imageURL]];
            image = [UIImage imageWithData:data];
            if (data) [dictionary setObject:data forKey:item.imageURL];
        }
        else {
            NSData *data = [dictionary valueForKey:item.imageURL];
            image = [UIImage imageWithData:data];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [av stopAnimating];
            [itemImageView setImage:image];
        }];
    });
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Item *item = self.searchResults[indexPath.row];
    if (![selectedItems containsObject:item] && selected.count < 5) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake((79 * selected.count) + 6.0f, 87, 72, 72)];
        
        UIButton *bkg = [UIButton buttonWithType:UIButtonTypeCustom];
        [bkg addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        bkg.frame = CGRectMake(0, 0, 72, 72);
        [bkg setImage:[UIImage imageNamed:@"SelectedBackground.png"] forState:UIControlStateNormal];
        bkg.tag = selected.count;
        
        UIImage *image;
        if (![dictionary valueForKey:item.imageURL]) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.imageURL]];
            image = [UIImage imageWithData:data];
            if (data) [dictionary setObject:data forKey:item.imageURL];
        }
        else {
            NSData *data = [dictionary valueForKey:item.imageURL];
            image = [UIImage imageWithData:data];
        }
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.frame = CGRectMake(6, 6, 60, 60);
        [itemButton setImage:image forState:UIControlStateNormal];
        itemButton.tag = selected.count;
        
        [selectedView addSubview:itemButton];
        [selectedView addSubview:bkg];
        
        [selected addObject:selectedView];
        [selectedItems addObject:item];
        [self.view addSubview:selectedView];
        
        selectedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            selectedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
        }];
    }

}
@end
