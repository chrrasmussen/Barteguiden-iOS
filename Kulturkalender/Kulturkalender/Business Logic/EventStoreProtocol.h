//
//  EventStoreProtocol.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol Event;

typedef void (^EventSearchCallback)(id<Event> event, BOOL *stop);

@protocol EventStore <NSObject>

// Access Events
- (id<Event>)eventWithIdentifier:(NSString *)identifier;
- (NSArray *)eventsMatchingPredicate:(NSPredicate *)predicate;
- (void)enumerateEventsMatchingPredicate:(NSPredicate *)predicate usingBlock:(EventSearchCallback)block;

// Predicates
- (NSPredicate *)predicateForEventsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSPredicate *)predicateForFeaturedEvents;
- (NSPredicate *)predicateForFavoritedEvents;
- (NSPredicate *)predicateForPaidEvents;
- (NSPredicate *)predicateForFreeEvents;
- (NSPredicate *)predicateForEventsWithCategoryIDs:(NSArray *)categoryIDs;
- (NSPredicate *)predicateForEventsAllowedForAge:(NSUInteger)age;
- (NSPredicate *)predicateForTitleContainingText:(NSString *)text;
- (NSPredicate *)predicateForPlaceNameContainingText:(NSString *)text;

// Saving Changes
- (BOOL)save:(NSError **)error;

@end

// Notifications
//extern NSString * const EventStoreChangedNotification;
//extern NSString * const EventStoreWillRefreshNotification;
//extern NSString * const EventStoreDidRefreshNotification;