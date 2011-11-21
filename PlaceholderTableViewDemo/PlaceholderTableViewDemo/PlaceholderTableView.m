//
//  PlaceholderTableViewController.m
//  ShootStudio
//
//  Created by Tom Fewster on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceholderTableView.h"
#import <QuartzCore/QuartzCore.h>

@interface PlaceholderTableView (private)
- (void)displayPlaceholderIfNeeded;
@end

@implementation PlaceholderTableView

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
	if (_batchUpdateInProgress == NO) {
		[self displayPlaceholderIfNeeded];
	}
	[super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
	[super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
	if (_batchUpdateInProgress == NO) {
		[self displayPlaceholderIfNeeded];
	}
}

- (void)beginUpdates {
	_batchUpdateInProgress = YES;
	[super beginUpdates];
	[self displayPlaceholderIfNeeded];
}

- (void)endUpdates {
	[super endUpdates];
	_batchUpdateInProgress = NO;
	[self displayPlaceholderIfNeeded];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
	[super setEditing:editing animated:animate];
	[self displayPlaceholderIfNeeded];
}

- (void)setEditing:(BOOL)editing {
	[super setEditing:editing];
	[self displayPlaceholderIfNeeded];
}

- (void)didMoveToSuperview {
	[self displayPlaceholderIfNeeded];
}

- (void)displayPlaceholderIfNeeded {
	BOOL needPlaceHolder = YES;
	if (!self.editing) {
		NSInteger sections = [super.dataSource numberOfSectionsInTableView:self];
		for (NSInteger i = 0; i < sections && needPlaceHolder == YES; i++) {
			if ([super.dataSource tableView:self numberOfRowsInSection:i] != 0) {
				needPlaceHolder = NO;
			}
		}
	} else {
		needPlaceHolder = NO;
	}
	
	if ([self.delegate respondsToSelector:@selector(tableView:placeHolderViewForFrame:)]) {
		if (needPlaceHolder) {
			if (_placeHolderVisible == NO) {
				_placeHolderView = [(NSObject<PlaceholderTableViewDelegate> *)self.delegate tableView:self placeHolderViewForFrame:self.frame];

				if (_initialised) {
					_placeHolderView.alpha = 0.0f;
					[self.superview addSubview:_placeHolderView];
					[self.superview bringSubviewToFront:_placeHolderView];
					self.scrollEnabled = NO;
					[UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseIn animations:^{
						_placeHolderView.alpha = 1.0f;
					} completion:^(BOOL completed){
					}];
				} else {
					_placeHolderView.alpha = 1.0f;
					[self.superview addSubview:_placeHolderView];
					[self.superview bringSubviewToFront:_placeHolderView];
					self.scrollEnabled = NO;
				}
				_placeHolderVisible = YES;
			}
		} else {
			if (_placeHolderVisible == YES && _placeHolderView != nil) {
				[self bringSubviewToFront:_placeHolderView];
				if (_currentlyAnimating == NO) {
					_currentlyAnimating = YES;
					_placeHolderVisible = NO;
					[UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
						_placeHolderView.alpha = 0.0f;
					} completion:^(BOOL completed){
						if (completed) {
							[_placeHolderView removeFromSuperview];
						}
						self.scrollEnabled = YES;
						_currentlyAnimating = NO;
					}];
				}
			}
		}
	}
	_initialised = YES;
}

@end
