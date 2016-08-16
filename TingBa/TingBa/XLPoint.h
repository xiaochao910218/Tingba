//
//  XLPoint.h
//  XLSphereView
//  shaoshuaiCooker
//
//  Created by qingyun on 16/7/4.
//  Copyright © 2016年 qindongfang. All rights reserved.

//

#ifndef XLPoint_h
#define XLPoint_h

struct XLPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

typedef struct XLPoint XLPoint;


XLPoint XLPointMake(CGFloat x, CGFloat y, CGFloat z) {
    XLPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}


#endif /* XLPoint_h */
