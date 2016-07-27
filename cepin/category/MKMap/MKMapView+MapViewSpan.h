//
//  MKMapView+MapViewSpan.h
//  RTMap
//
//  Created by 嘉宾 唐 on 12-10-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (MapViewSpan)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
