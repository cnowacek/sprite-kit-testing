//
//  KMViewController.m
//  DragKing
//
//  Created by Charlie Nowacek on 10/2/13.
//  Copyright (c) 2013 KayosMedia. All rights reserved.
//

#import "KMViewController.h"
#import "KMMyScene.h"

@implementation KMViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // COnfigure
    SKView *skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Configure the scene
        SKScene *scene = [KMMyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present scene
        
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
