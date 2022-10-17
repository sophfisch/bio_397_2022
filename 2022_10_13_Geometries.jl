module Functions
#have to include objects before functions or it won't recognize objects
include("objects.jl")
include("functions.jl")

export area
end

using .Functions #To load a module from a locally defined module, a dot needs to be added before the module name 

sq=Square(5)
area(sq)

##works:)