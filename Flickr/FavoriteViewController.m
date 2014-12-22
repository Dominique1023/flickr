//
//  FavoriteViewController.m
//  Flickr
//
//  Created by Dominique on 12/19/14.
//  Copyright (c) 2014 dominique vasquez. All rights reserved.
//

#import "FavoriteViewController.h"

@interface FavoriteViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property NSMutableArray *pictures;
@property NSDictionary *photo;
@property (weak, nonatomic) IBOutlet UICollectionView *favoriteCollectionView;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"My Favorites";
    self.pictures = [NSMutableArray new];

    [self readingDefaults];

}

-(void)readingDefaults{
    self.photo = [[NSUserDefaults standardUserDefaults]objectForKey:@"images"];

    [self.pictures addObject:self.photo];
    NSLog(@"SELF.PICTURES %@", self.pictures);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pictures.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"faveCell" forIndexPath:indexPath];

    for (NSDictionary *dictionary in self.pictures) {
        id farm = [dictionary objectForKey:@"farm"];
        id server = [dictionary objectForKey:@"server"];
        id userID = [dictionary objectForKey:@"id"];
        id secret = [dictionary objectForKey:@"secret"];

        NSString *stringURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_m.jpg", farm, server, userID, secret];
        NSURL *url = [NSURL URLWithString:stringURL];
        NSData *data = [NSData dataWithContentsOfURL:url];

        UIImage *image = [UIImage imageWithData:data];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [cell addSubview:imageView];

    }



    return cell;
}

@end
