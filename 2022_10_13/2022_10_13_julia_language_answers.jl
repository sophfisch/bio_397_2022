#day1
##excercise1
a=[10*0]
a[2]=1

##2
m = rand(1:6, (2,3))

##3 Find the odd elements in vector [1,4,2,3,6,7].

v=[1,4,2,3,6,7]
for val in v
   if isodd(val) 
    println(val)
   end
end

##4 Multiply a 5x3 matrix of random numbers by a 3x2 matrix of random numbers

m1=rand(5,3)
m2=rand(3,2)
m1*m2

##5 Write a function that takes a string as its input and returns the string from backward

function f1(strng)
    return(reverse(strng))
end

##6 Write a function that checks whether a string is palindromic (the string is the same whether read from backward or forward).

function plndrm(x::String)
    if reverse(x) == x
        return("is a palindrom:)")
    end
end

plndrm("agga")



##7 Write a function that accepts a DNA sequence as a string and returns its RNA transcript. If the DNA has wrong letters, the function should complain.
function dna_to_rna(dna::String)
    rna=""
    bp=["A", "G", "C", "T"]
    for n in dna
        if n == "A"
            rna+="U"
        end
        if n == "T"
            rna+="A"
        end
        if n=="G"
            rna+="C"
        end
        if n=="C"
            rna+="G"
        end
        if n ∉ bp
            "no"
        end
    end
    return(rna)
end

tst="ACCDDGG"
dna_to_rna(tst)
    
##8 Write a function that determines whether a word is an isogram (has no repeating letters, like the word “isogram”)

function isogram(i::String)
    iso=""
    for letr in i
        if letr in iso
            return("not an isogram")
        end
        if letr ∉ iso
            iso=iso*letr
        end
    end
    return(iso)
end

test="isos"
isogram(test)


##9 Write a function that counts the number of elements of its input, whether the input is an array or a string. Then, it should return a new element that is of the same type as its input but with duplicate elements (“abc” will be “aabbcc”).

function count(inp::Union{Array, String})
    newnr=""
    nr=length(inp)
    for lt in inp
        newnr=newnr*(lt^2)
    end
    return(newnr)
end

l="lol"
count(l)

##10 Write a function called nestedsum that takes an array of arrays of integers and adds up the elements from all of the nested arrays. For example:

function nestedsum(h::Array)
    res=0
    for arr in h
        res+=sum(arr)
    end
    return(res)
end

t=[[1, 2], [3], [4, 5, 6]]

nestedsum(t)


## 1.1 Write a function that checks whether an array has duplicates. Use this function inside another function that returns the duplicated values and indices of an array, if they exist.

#I know excercise said to use two functions but I read that too late...
#still have to add ALL duplications not just the 2nd ones... not sure how

function dupl(ar::Array)
    d=Dict() #Dictionary that should contain duplication and position
    dupli=[] #array contains duplicated values and positions
    n=0
    for s in ar
        n+=1
        if s in keys(d)
            push!(dupli, [s,n])
            d[s]=n
        end
        if s ∉ keys(d)
            d[s]=n
        end
    end
    return(dupli)
end


ary=[0,2,3,5,6,6,5,5,4]
dupl(ary)


## The geometry module:
#Create an object named Point which has two number fields: x and y.
mutable struct Point
    x::Number
    y::Number
end
#Create another object named Circle with fields center and radius, where center is itself a Point object and radius is a number.
mutable struct Circle
    center::Point
    radius::Number
end

#Now write a function named area that accepts a Circle object as its inputs and returns the area of the circle.

function area(ob::Circle)
    a=ob.radius^2* π
    return a
end
#Create another object named Square with a single number field called side.
mutable struct Square
    side::Number
end

#Finally, create a new method for the area function. This time, a function with the same name, but accepts a Square object and returns its area.
#Create another object named Square with a single number field called side.
mutable struct square
    side::Number
end

function area(ob::Square)
    s=ob.side
    a=s*s
    return a
end

#Test your functions with some instances of a Square and Circle objects.

sq=square(5)

area(sq)
x=Point(5,6)
circ=Circle(x, 9)
area(circ)

#works:)

#Write a function that check whether two circles overlap each other.
#idea 

function overlapping(circ1::Circle,circ2::Circle)
    distance = sqrt((circ1.point.x - circ2.point.x)^2 + (circ1.point.y - circ2.point.y)^2)
    if distance < circ1.radius + circ2.radius
        return "Overlap!"
    else
        return "No overlap."
    end
end

#Put your Circle and Square object definitions in a file names objects.jl. Put the functions methods in another file named functions. Create a new file named Geometry.jl. Create a module inside it with the same name. Inside the module, include the two files. You may export the functions and objects. Test your module.

#Modules in Julia help organize code into coherent units. They are delimited syntactically inside module NameOfModule ... end, and have the following features:

#Modules are separate namespaces, each introducing a new global scope. This is useful, because it allows the same name to be used for different functions or global variables without conflict, as long as they are in separate modules.

#Modules have facilities for detailed namespace management: each defines a set of names it exports, and can import names from other modules with using and import.

#Modules can be precompiled for faster loading, and contain code for runtime initialization.

#3 Use the following dataset, take a subset of it where the values of the first column are less than the mean of the fifth column. Sort the new data frame by the values of the first and the fifth columns. Write it to file.
using RDatasets
df = dataset("datasets","anscombe")
using Random, Statistics
function compare_columns(column1, column2, df) 
    m=mean(column2)
    print(m)
    dont_include=[] #makes a list of which rows not to include in new dataframe
    for (i,val) in enumerate(column1)
        if val>=m
            push!(dont_include, i)
        end
    end
    return(dont_include)
end
dont_include=compare_columns(df[!,1], df[!,5], df) #get list of what not to include
anscombe=df[Not(dont_include), :] #make new dataframe 
using CSV
using DataFrames
CSV.write("C:\\Users\\sophi\\Desktop\\machine_learning\\anscombe.csv", anscombe) #writing it into a csv

anscombe2=CSV.read("C:\\Users\\sophi\\Desktop\\machine_learning\\anscombe.csv", DataFrame)

#Create scatter plots of age vs education and income vs education. Color the points according to sex.
using(Plots)


using RDatasets
chile = dataset("car","Chile")
first(chile,5)
y=chile[!, :Age]
x=chile[!, :Education]
z=chile[!, :Income]
sex=chile[!, :Sex] #have to convert sex to integer type or can't scatter by Color

###converting sex ####

function unique_array(array) #makes an array of unique values
    un_ar=unique(array) #1
    dic=Dict(v=> k for (k,v) in enumerate(un_ar)) #2
    return dic
end

function integer_data(column, sze::Int, dic) #takes column to convert it into an array of integers and also makes dictionary
    int_ar= Int[]
    dic=dic
    for h in column
        push!(int_ar, dic[h])
    end
    b=Base.bin.(UInt.(int_ar), sze, false)
    return(int_ar, b)
end
un_a=unique_array(sex)
print(un_a) #un_a is a dictionary
int_ar_sex, b=integer_data(sex, 1, un_a) 
print(int_ar)
[parse(Int, x) for x in b]

###plotting####
plot(x, y, color=int_ar_sex,  seriestype = :scatter, title = "Education level at different ages", xlab="Education", ylab="Age")
plot(x,z, color=int_ar_sex, seriestype = :scatter, title="Income/ Education", xlab="Educaction", ylab="Income")
#still have to index which sex is which color 