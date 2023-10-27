#!/usr/bin/env python3

import math

def calculate_positions(outer_radius, inner_border, inner_radius, inner_count):
    dials = []
    radius = inner_radius + inner_border
    inner_angle = 360/inner_count
    for i in 0, 1, 2:
        angle = i * inner_angle;
        dx = round(math.sin(angle/360*2*math.pi) * radius)
        dy = round(math.cos(angle/360*2*math.pi) * -1 * radius)
        #print (angle,dx,dy)
        dials.append({ "x": outer_radius + dx, "y": outer_radius + dy, "r": inner_radius })
    return dials

sizes = [
    { "outer_radius" : 227, "inner_border": 20, "inner_radius": 85, "inner_count": 3 },
    { "outer_radius" : 208, "inner_border": 17, "inner_radius": 80, "inner_count": 3 },
    { "outer_radius" : 195, "inner_border": 15, "inner_radius": 75, "inner_count": 3 },
    { "outer_radius" : 140, "inner_border": 10, "inner_radius": 55, "inner_count": 3 },
    { "outer_radius" : 130, "inner_border": 10, "inner_radius": 50, "inner_count": 3 },
    { "outer_radius" : 120, "inner_border": 10, "inner_radius": 45, "inner_count": 3 }
]

dials_by_size = {}

for size in sizes:
    #print(size["outer_radius"])
    dials = calculate_positions(size["outer_radius"],size["inner_border"],size["inner_radius"],size["inner_count"])
    dials_by_size[size["outer_radius"]] = dials

#print(dials_by_size)
for radius in dials_by_size:
    print(radius,dials_by_size[radius])
