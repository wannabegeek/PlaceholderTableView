//
//  PlaceholderTableViewController.h
//  ShootStudio
//
//  Created by Tom Fewster on 16/11/2011.
//

#import <UIKit/UIKit.h>

@protocol PlaceholderTableViewDelegate <UITableViewDelegate>
@optional
- (UIView *)tableView:(UITableView *)tableView placeHolderViewForFrame:(CGRect)frame;
@end

@interface PlaceholderTableView : UITableView {
	UIView *_placeHolderView;
	BOOL _placeHolderVisible;
	BOOL _batchUpdateInProgress;
	BOOL _currentlyAnimating;
	BOOL _initialised;
}

@end
