//
//  CBALegalViewController.m
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/20/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import "CBALegalViewController.h"
#import "CBAContractViewController.h"

@interface CBALegalViewController ()

@end

@implementation CBALegalViewController

@synthesize legalItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Legal";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupLegalItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLegalItems
{
    self.legalItems = [NSMutableArray array];
    [self.legalItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                @"Shimmer", @"name",
                                @"BSD License\n\n"
                                @"For Shimmer software\n\n"
                                
                                @"Copyright (c) 2014, Facebook, Inc. All rights reserved.\n\n"
                                
                                @"Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n\n"
                                
                                @"  * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n\n"
                                
                                @"  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n\n"
                                
                                @"  * Neither the name Facebook nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n\n"
                                
                                @"THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
                                
                                , @"contract",
                                nil]];
    [self.legalItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                @"CWDepthView", @"name",
                                @"The MIT License (MIT)\n\n"
                                
                                @"Copyright (c) 2014 Cezary Wojcik\n<http://www.cezarywojcik.com>\n\n"
                                
                                @"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\n"
                                
                                @"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n"
                                
                                @"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.", @"contract",
                                nil]];
    [self.tableView reloadData];
}

# pragma mark - table view data source

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"LegalTableCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [UITableViewCell new];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = [[self.legalItems objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.legalItems count];
}

# pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBAContractViewController *contractViewController = [[CBAContractViewController alloc] initWithNibName:@"CBAContractViewController" bundle:nil];
    contractViewController.title = [[self.legalItems objectAtIndex:indexPath.row] objectForKey:@"name"];
    contractViewController.contract = [[self.legalItems objectAtIndex:indexPath.row] objectForKey:@"contract"];
    [self.navigationController pushViewController:contractViewController animated:YES];
}


@end
