//
//  PhotoViewController.m
//  Flickr
//
//  Created by Dominique on 12/17/14.
//  Copyright (c) 2014 dominique vasquez. All rights reserved.
//

#import "PhotoViewController.h"
#import "FavoriteViewController.h"

@interface PhotoViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UITextView *photoTitle;
@property NSString *urlString;
@property NSMutableArray *urlStrings;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.urlStrings = [[NSMutableArray alloc]init];

    self.navigationItem.title = @"Flickr Photo";

    NSString *titleString = [self.photo objectForKey:@"title"];
    self.photoTitle.text = titleString;

    //Tap gesture on Image saves the photo to NSUserDefaults
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(save)];
    [self.photoImage addGestureRecognizer:tapGestureRecognizer];

    [self retrieveImage];

}

-(void)retrieveImage{

    id farm = [self.photo objectForKey:@"farm"];
    id server = [self.photo objectForKey:@"server"];
    id userID = [self.photo objectForKey:@"id"];
    id secret = [self.photo objectForKey:@"secret"];

    self.urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_m.jpg", farm, server, userID, secret];
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];

    self.photoImage.image = image;
    [self.photoImage sizeToFit];

}

-(void)save{
    NSLog(@"Tapped and Saved");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.urlStrings addObject:self.urlString];
    [defaults setObject:self.urlStrings forKey:@"strings"];

    NSLog(@"self.urlStrings %@", self.urlStrings); 

    [defaults synchronize];
}



@end
