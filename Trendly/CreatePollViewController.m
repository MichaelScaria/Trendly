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

#import "PhotoThumbnail.h"

@interface CreatePollViewController ()

@end

@implementation CreatePollViewController
@synthesize textField, name;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.createButton.hidden = YES;
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

    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIView *v in selected) {
        [v removeFromSuperview];
    }
    [selected removeAllObjects];
    [selectedItems removeAllObjects];
    
}

- (IBAction)clear:(id)sender {
    self.textField.text = @"";
}

- (IBAction)create:(id)sender {
    [[Model sharedInstance] createPollWIthItems:selectedItems completion:^{
        for (UIView *v in selected) {
            [v removeFromSuperview];
        }
        [selected removeAllObjects];
        [selectedItems removeAllObjects];
        NSLog(@"Poll Create Success!");
        [self.tabBarController setSelectedIndex:0];
    }];
}

- (void)remove:(UIButton *)button {
    NSLog(@"%d", button.tag);
    UIView *selectedView = [selected objectAtIndex:button.tag];
    [selected removeObjectAtIndex:button.tag];
    [selectedItems removeObjectAtIndex:button.tag];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        selectedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [selectedView removeFromSuperview];
    } completion:^(BOOL finished){
        for (int i = button.tag; i < selected.count; i++) {
            PhotoThumbnail *animateView = (PhotoThumbnail *)[selected objectAtIndex:i];
            NSLog(@"before:%d", animateView.button.tag);
            animateView.button.tag = i;
            NSLog(@"after:%d", animateView.button.tag);
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                animateView.frame = CGRectMake(animateView.frame.origin.x - 79, animateView.frame.origin.y, animateView.frame.size.width, animateView.frame.size.height);
            } completion:^(BOOL finished){
                if (selected.count != 4) {
                    self.createButton.hidden = YES;
                }
            }];

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
    if (![selectedItems containsObject:item] && selected.count < 4) {
        NSLog(@"adding item");
        PhotoThumbnail *selectedView = [[PhotoThumbnail alloc] initWithFrame:CGRectMake((79 * selected.count) + 6.0f, 87, 72, 72)];
        
        selectedView.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectedView.button addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        selectedView.button.frame = CGRectMake(0, 0, 72, 72);
        [selectedView.button setImage:[UIImage imageNamed:@"SelectedBackground.png"] forState:UIControlStateNormal];
        selectedView.button.tag = selected.count;
        
        UIImageView *bkg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
        bkg.image = [UIImage imageNamed:@"SelectedBackground.png"];
        
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
        UIImageView *itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 60, 60)];
        itemImage.image = image;
        
        [selectedView addSubview:itemImage];
        [selectedView addSubview:bkg];
        [selectedView addSubview:selectedView.button];
        
        [selected addObject:selectedView];
        [selectedItems addObject:item];
        [self.view addSubview:selectedView];
        
        selectedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            selectedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            if (selected.count == 4) {
                self.createButton.hidden = NO;
            }
        }];
    }

}
@end
