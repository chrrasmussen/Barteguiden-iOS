//
//  UserDefaultsCalendarManager.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 03.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "UserDefaultsCalendarManager.h"
#import <EventKit/EventKit.h>


static BOOL const kDefaultShouldAutoAddFavorites = NO;
static double const kDefaultAlertTimeInterval = 30;

static NSString * const kCalendarAutoAddFavoritesKey = @"CalendarAutoAddFavorites";
static NSString * const kCalendarDefaultCalendarIdentifierKey = @"CalendarDefaultCalendarIdentifier";
static NSString * const kCalendarDefaultAlertTimeIntervalKey = @"CalendarDefaultAlertTimeInterval";


@interface UserDefaultsCalendarManager ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation UserDefaultsCalendarManager

@synthesize calendarStore=_calendarStore;


- (id)initWithUserDefaults:(NSUserDefaults *)userDefaults calendarStore:(EKEventStore *)calendarStore
{
    self = [super init];
    if (self) {
        _userDefaults = userDefaults;
        _calendarStore = calendarStore;
    }
    return self;
}

- (void)save
{
    [self.userDefaults synchronize];
}

#pragma mark - Defaults

- (void)registerDefaultAutoAddFavorites:(BOOL)autoAddFavorites
{
    [self.userDefaults registerDefaults:@{kCalendarAutoAddFavoritesKey: @(autoAddFavorites)}];
}

- (void)registerDefaultDefaultCalendarIdentifier:(NSString *)defaultCalendarIdentifier
{
    [self.userDefaults registerDefaults:@{kCalendarDefaultCalendarIdentifierKey: defaultCalendarIdentifier}];
}

- (void)registerDefaultDefaultAlertTimeInterval:(NSTimeInterval)defaultAlertTimeInterval
{
    [self.userDefaults registerDefaults:@{kCalendarDefaultAlertTimeIntervalKey: @(defaultAlertTimeInterval)}];
}

#pragma mark - Auto-add favorites

- (BOOL)shouldAutoAddFavorites
{
    NSNumber *autoAddFavoritesNumber = [self.userDefaults objectForKey:kCalendarAutoAddFavoritesKey];
    if (autoAddFavoritesNumber == nil) {
        return kDefaultShouldAutoAddFavorites;
    }
    
    return [autoAddFavoritesNumber boolValue];
}

- (void)setAutoAddFavorites:(BOOL)autoAddFavorites
{
    [self.userDefaults setObject:@(autoAddFavorites) forKey:kCalendarAutoAddFavoritesKey];
}


#pragma mark - Default calendar

- (EKCalendar *)defaultCalendar
{
    NSString *calendarIdentifier = [self.userDefaults objectForKey:kCalendarDefaultCalendarIdentifierKey];
    if (calendarIdentifier == nil) {
        return [self.calendarStore defaultCalendarForNewEvents];
    }
    
    EKCalendar *calendar = [self.calendarStore calendarWithIdentifier:calendarIdentifier];
    if (calendar != nil) {
        return calendar;
    }
    
    return [self.calendarStore defaultCalendarForNewEvents];
}

- (void)setDefaultCalendar:(EKCalendar *)defaultCalendar
{
    [self.userDefaults setObject:[defaultCalendar calendarIdentifier] forKey:kCalendarDefaultCalendarIdentifierKey];
}


#pragma mark - Default alert

- (EKAlarm *)defaultAlert
{
    NSNumber *defaultAlertNumber = [self.userDefaults objectForKey:kCalendarDefaultAlertTimeIntervalKey];
    if (defaultAlertNumber == nil) {
        return [EKAlarm alarmWithRelativeOffset:kDefaultAlertTimeInterval];
    }
    
    return [EKAlarm alarmWithRelativeOffset:[defaultAlertNumber doubleValue]];
}

- (void)setDefaultAlert:(EKAlarm *)defaultAlert
{
    [self setDefaultAlertTimeInterval:defaultAlert.relativeOffset];
}

- (void)setDefaultAlertTimeInterval:(NSTimeInterval)timeInterval
{
    [self.userDefaults setObject:@(timeInterval) forKey:kCalendarDefaultAlertTimeIntervalKey];
}

@end
