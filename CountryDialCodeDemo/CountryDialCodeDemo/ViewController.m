//
//  ViewController.m
//  CountryDialCodeDemo
//
//  Created by lieyunye on 12/5/14.
//  Copyright (c) 2014 lieyunye. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UITableView *mTableView;
    NSDictionary *sortedChnamesDict;
    NSArray *indexArray;
    UISearchBar *mSearchBar;
    UISearchDisplayController *mySearchDisplayController;
    NSMutableArray *searchResultValuesArray;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    searchResultValuesArray = [[NSMutableArray alloc] init];
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:mTableView];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.sectionIndexBackgroundColor = [UIColor clearColor];

    mSearchBar = [[UISearchBar alloc] init];
    [mSearchBar sizeToFit];
    mSearchBar.delegate = self;
    mSearchBar.placeholder = @"搜索";
    [mSearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    mTableView.tableHeaderView = mSearchBar;
    
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mSearchBar contentsController:self];
    mySearchDisplayController.delegate = self;
    mySearchDisplayController.searchResultsDataSource = self;
    mySearchDisplayController.searchResultsDelegate = self;
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sortedChnames"
                                                          ofType:@"plist"];
    sortedChnamesDict = [[NSDictionary dictionaryWithContentsOfFile:plistPath] copy];
    
    indexArray = [sortedChnamesDict allKeys];
    indexArray = [indexArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    NSLog(@"%@",sortedChnamesDict);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    NSLog(@"%s",__FUNCTION__);
    
    [searchResultValuesArray removeAllObjects];
    
    for (NSArray *array in [sortedChnamesDict allValues]) {
        for (NSString *value in array) {
            if ([value containsString:searchBar.text]) {
                [searchResultValuesArray addObject:value];
            }
        }
    }
    [mySearchDisplayController.searchResultsTableView reloadData];

}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == mTableView) {
        static NSString *cellIdentifier = @"cellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        
        cell.textLabel.text = [[sortedChnamesDict objectForKey:[indexArray objectAtIndex:section]] objectAtIndex:row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        return cell;
    }else {
        static NSString *cellIdentifier = @"cellIdentifier2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if ([searchResultValuesArray count] > 0) {
            cell.textLabel.text = [searchResultValuesArray objectAtIndex:indexPath.row];
        }
        return cell;
    }
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == mTableView) {
        NSArray *array = [sortedChnamesDict objectForKey:[indexArray objectAtIndex:section]];
        return  array.count;
    }else {
        return [searchResultValuesArray count];
    }

}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == mTableView) {
        return [sortedChnamesDict allKeys].count;
    }else {
        return 1;
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
{
    if (tableView == mTableView) {
        return indexArray;
    }else {
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == mTableView) {
        return index;
    }else {
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == mTableView) {
        if (section == 0) {
            return 0;
        }
        return 30;
    }else {
        return 0;
    }
   
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [indexArray objectAtIndex:section];
}
@end
