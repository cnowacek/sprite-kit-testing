//
//  KMMyScene.m
//  DragKing
//
//  Created by Charlie Nowacek on 10/2/13.
//  Copyright (c) 2013 KayosMedia. All rights reserved.
//

#import "KMMyScene.h"

static NSString * const kAnimalNodeName = @"movable";

@interface KMMyScene ()

@property (nonatomic, strong)   SKSpriteNode *background;
@property (nonatomic, strong)   SKSpriteNode *selectedNode;
@property (nonatomic, strong)   NSTimer *timer;

@end

@implementation KMMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        // Load the background
        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"blue-shooting-stars"];
        self.background.name = @"background";
        self.background.anchorPoint = CGPointZero;
        [self addChild:self.background];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-100, 0) toPoint:CGPointMake(self.size.width+100, 0)];
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        
    }
    return self;
}

- (void)spawn {
    NSString *imageName = @"turtle";
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    [sprite setName:kAnimalNodeName];
    sprite.position = CGPointMake(30, 30);
    
    SKPhysicsBody *pBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    pBody.affectedByGravity = YES;
    pBody.mass = 1000;
    pBody.restitution = .1;
    pBody.friction = 0.6;
    sprite.physicsBody = pBody;
    sprite.physicsBody.dynamic = YES;
    
    
    [self.background addChild:sprite];
    [sprite.physicsBody applyImpulse:CGVectorMake(4000, 0)];
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
        if (self.selectedNode) {
            [self.selectedNode removeAllActions];
            self.selectedNode.physicsBody.affectedByGravity = NO;
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        [self panForTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (![self.selectedNode.name isEqualToString:kAnimalNodeName]) {
            float scrollDuration = 0.2;
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            CGPoint pos = self.selectedNode.position;
            CGPoint p = mult(velocity, scrollDuration);
            
            CGPoint newPos = CGPointMake(pos.x + p.x, pos.y + p.y);
            newPos = [self boundLayerPos:newPos];
            [self.selectedNode removeAllActions];
            
            SKAction *moveTo = [SKAction moveTo:newPos duration:scrollDuration];
            [moveTo setTimingMode:SKActionTimingEaseOut];
            [self.selectedNode runAction:moveTo];
        } else {
            self.selectedNode.physicsBody.affectedByGravity = YES;
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            
            self.selectedNode.physicsBody.velocity = CGVectorMake(velocity.x/2, -velocity.y/2);
        }
    }
}

- (void)didMoveToView:(SKView *)view {
    [self spawn];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(spawn) userInfo:nil repeats:YES];
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)selectNodeForTouch:(CGPoint)touchLocation {
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    if (![self.selectedNode isEqual:touchedNode]) {
        self.selectedNode = touchedNode;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = self.selectedNode.position;
    if ([self.selectedNode.name isEqualToString:kAnimalNodeName]) {
        self.selectedNode.position = CGPointMake(position.x + translation.x, position.y + translation.y);
    } else {
        CGPoint newPos = CGPointMake(position.x + translation.x, position.y + translation.y);
        self.background.position = [self boundLayerPos:newPos];
    }
}

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -self.background.size.width + winSize.width);
    retval.y = self.position.y;
    
    return retval;
}

CGPoint mult(const CGPoint v, const CGFloat s) {
	return CGPointMake(v.x*s, v.y*s);
}
                    
float degToRad(float degree) {
  return degree / 180.0f * M_PI;
}

@end
