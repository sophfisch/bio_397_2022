using DataFrames
f="hotel_bookings.csv"
using CSV
df_bookings=CSV.read(f, DataFrame)
#################### to do #####################
#dataset1: clean up, create new data frame containing all good stuff

# Use the hotel bookings dataset to define a set of clean features that may be used to predict when hotels receive high demand. 
#It may be useful for planning a trip to get cheapest stay costs.

#seeing what is in dataset

rows=names(df_bookings) #getting out rows

show(rows) 
#overview , has 32x7
describe(df_bookings) 
first(df_bookings, 5)



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
 ##making a list of all months so then I can use findall function to make a list of integers


months=unique(df_use.arrival_date_month)

#making dictionary of months
month_dic=Dict(v=> k for (k,v) in enumerate(months))
#making month_num, an array of all months as integers
month_num= Int[]
for h in df_use[!, :arrival_date_month]
    push!(month_num, month_dic[h])
end

#converting to binary
month_binary=Base.bin.(UInt.(month_num), 4, false)

#Base.bin returns a string. Convert each single digit of the binary numbers to an integer before putting them in your table.
[parse(Int, x) for x in month_binary]
#adding it into a new data frame just to test
new_df=DataFrame(month_of_arrival_binary=month_binary)


###################### dataset2 ######################
#This dataset lists project data available from the US Governments IT Dashboard system. It covers the projected and actual costs and timings of a number of government funded projects in the US
g="dataset2.csv"

df2=CSV.read(g, DataFrame)

#exploring dataset2
#This dataset lists project data available from the US Governments IT Dashboard system
#It covers the projected and actual costs and timings of a number of government funded projects in the US
#Create a new dataset with a set of clean features that may be used to predict “Projected/Actual Cost ($ M)”

r=names(df2) #23 columns
show(r)
size(df2)

#need column “Projected/Actual Cost ($ M)”
show(df2)
#column is in float format


new_data = DataFrame(project_id=df2[!,6],lifecycle_cost=df2[!,14],shedule_var=df2[!,15],planned_cost=df2[!,19], projected_actual_cost=df2[!,end-3])
describe(new_data)#look for missing values
describe(new_data, :nmissing) 
#not so many missing values so can just delete them
dropmissing(new_data)

# Mixed numerical scales.
# We need to standardize our data:
sdf(x, m, s) = (x-m)/s

sdf_lifecycle = sdf.(new_data.lifecycle_cost, mean(new_data.lifecycle_cost), std(new_data.lifecycle_cost))
sdf_shedule_var = sdf.(new_data.shedule_var, mean(new_data.shedule_var), std(new_data.shedule_var))
sdf_planned_cost = sdf.(new_data.planned_cost, mean(new_data.planned_cost), std(new_data.planned_cost))



sd_data = DataFrame(project_id=new_data.project_id,lifecycle_cost=sdf_planned_cost,shedule_var=sdf_shedule_var,planned_cost=sdf_planned_cost)
