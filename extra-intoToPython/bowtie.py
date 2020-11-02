#bowtie.py
#draw a bowtie

from turtle import *

pensize(7)
penup() #don't draw
goto(-200,-100)
pendown()#now draw
fillcolor("red")
begin_fill()
goto(-200, 100)
goto(200, -100)
goto(200, 100)
goto(-200, -100)
end_fill()

exitonclick()
