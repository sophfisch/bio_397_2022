using DataFrames
f="hotel_bookings.csv"
using CSV
df_bookings=CSV.read(f, DataFrame)

# Use the hotel bookings dataset to define a set of clean features that may be used to predict when hotels receive high demand. 
#It may be useful for planning a trip to get cheapest stay costs.

#seeing what is in dataset

rows=names(df_bookings) #getting out rows

show(rows) 
#overview , has 32x7
describe(df_bookings) 
first(df_bookings, 5)


#want to know how many days the people stayed in total so adding up weekend and weekend


#function add_column(df::DataFrame, colname::Symbol, cols_to_concat::Vector)
    #df[!,colname] = (df[!, names(df)[cols_to_concat[1]]] 
                 #.* df[!, names(df)[cols_to_concat[2]]] 
                 #.* df[!, names(df)[cols_to_concat[3]]])
 #end
 
 

 df_bookings.is_canceled .== 0 #checks where column is_canceled is 0

 #want to see which month is most booked on weekend nights

 df_use=select!(df_bookings, ([:arrival_date_month, :stays_in_weekend_nights]))
 show(df_use)

 #arrival_date_moth is categorical and stays_in_weekend_nights
 describe(df_use) 
#Binary encoding
 #convert arrival_date_month into binary
 #Assign an integer to each category, starting from 1 to N, where N is the number of categories.
 months=[]

 int_data=[]
 n=0
 ##1)making a list of all unique values, 2)making dictionary of unique values, assigning an integer
function unique_array(array)
    un_ar=unique(array) #1
    dic=Dict(v=> k for (k,v) in enumerate(un_ar)) #2
    return dic
end


#if want all in one column
function integer_data(column, sze::Int, dic)
    int_ar= Int[]
    dic=dic
    for h in column
        push!(int_ar, dic[h])
    end
    b=Base.bin.(UInt.(int_ar), sze, false)
    return(int_ar, b)
end
#alternative: all in seperate columns

function single_columns_binary(column, sze)
    int_ar,b=integer_data(column, sze)
    for i in 1:length(column)
        for j in 1:length(dic)
            matrix[i,j]=parse(Int, b[i], [j])
        end
    end
end




#Base.bin returns a string. Convert each single digit of the binary numbers to an integer before putting them in your table.
[parse(Int, x) for x in b]
#adding it into a new data frame just to test
new_df=DataFrame(column_binary=b)
