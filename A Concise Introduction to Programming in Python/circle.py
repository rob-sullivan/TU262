#square.py
# Draw a circle
#p6

from turtle import *

#center of a circle
circle(100)
left(90)
forward(100)
right(90)
forward(100)

#center of a circle offset
left(90)
circle(100)
left(90)
forward(100)
right(90)
backward(100)

exitonclick()