mutable struct Point
    x::Number
    y::Number
end
#Create another object named Circle with fields center and radius, where center is itself a Point object and radius is a number.
mutable struct Circle
    center::Point
    radius::Number
end

mutable struct Square
    side::Number
end
