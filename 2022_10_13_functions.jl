
function area(ob::Square)
    s=ob.side
    a=s*s
    return a
end

function area(ob::Circle)
    a=ob.radius^2* π
    return a
end

function overlapping(circ1::Circle,circ2::Circle)
    distance = sqrt((circ1.point.x - circ2.point.x)^2 + (circ1.point.y - circ2.point.y)^2)
    if distance < circ1.radius + circ2.radius
        return "Overlap!"
    else
        return "No overlap."
    end
end
