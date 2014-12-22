//
//  ViewController.m
//  Flickr
//
//  Created by Dominique on 12/17/14.
//  Copyright (c) 2014 dominique vasquez. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate> 
@property NSMutableArray *recentPhotos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSDictionary *selectedPhoto;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadJSONFromURL];
}

-(void)loadJSONFromURL{
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=b6b88095d36fba2342af73a1c11e3af2&format=json&nojsoncallback=1&auth_token=72157649860947272-ce9ce6d82498c1ca&api_sig=14cc453f53c52b18854e7360d7cf9891"];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.recentPhotos = [[[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]objectForKey:@"photos"]objectForKey:@"photo"];
        [self.collectionView reloadData];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.recentPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];

    NSDictionary *recentPhotoDictionary = [self.recentPhotos objectAtIndex:indexPath.row];
    id farm = [recentPhotoDictionary objectForKey:@"farm"];
    id server = [recentPhotoDictionary objectForKey:@"server"];
    id userID = [recentPhotoDictionary objectForKey:@"id"];
    id secret = [recentPhotoDictionary objectForKey:@"secret"];

    NSString *stringURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_m.jpg", farm, server, userID, secret];
    NSURL *photoURL = [NSURL URLWithString:stringURL];
    NSData *data = [NSData dataWithContentsOfURL:photoURL];

    UIImage *image = [UIImage imageWithData:data];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];

    [cell addSubview:imageView];

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"photoSegue"]) {
        PhotoViewController *pvc = segue.destinationViewController;

        NSArray *photoSelected = [[NSArray alloc]initWithArray:[self.collectionView indexPathsForSelectedItems]];

        for (NSIndexPath *path in photoSelected) {
            pvc.photo = [self.recentPhotos objectAtIndex:path.row];
        }
    }


}

@end









