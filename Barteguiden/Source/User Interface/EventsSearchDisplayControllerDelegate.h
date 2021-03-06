//
//  EventsSearchDisplayControllerDelegate.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventsSearchDisplayControllerDelegate <NSObject>

- (NSPredicate *)eventsPredicate;
- (NSString *)eventsCacheName;
- (void)navigateToEvent:(id)event;

@end
