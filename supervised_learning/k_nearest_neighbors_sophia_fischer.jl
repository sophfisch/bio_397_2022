f="name_gender.txt"

using CSV
using DataFrames
data=CSV.read(f, DataFrame)

#For each name, create a list of features
#length of name, number of vowels, hard consonants

#GETTING FEATURES

function vowels(s::String)
    v = "aeiou"
    n_vowels=(count(c -> (c in v), lowercase(s)))
    return n_vowels
end

function hard_consonants(s::String)
    v= "bdgptk"
    n_hc=(count(c -> (c in v), lowercase(s)))
    return n_hc
end

function adding_features(data)
    dic=Dict{String, Any}()
    for name in data[:, 1]
        
        vowel=vowels(string(name))
        hc=hard_consonants(string(name))
        
        dic[name]=[vowel, length(name), hc]    
    end
    return dic
end

d=adding_features(data)



#Choose a k value, which is the number of nearest neighbors that will be used for making a prediction.
k=3

#Calculate the distance between the data point you want to classify and every other sample in your training set.
d[nicholas]
function distance4(dictionary, name_to_test)
    dst=[]
    fill=[]
    i=0
    ntt_features=dictionary[name_to_test]
    number_of_features=length(ntt_features)
    print(ntt_features)
    for features in values(dictionary)
        fill=[]
        if dictionary[name_to_test]==features
            continue
        else
            for i in 1:number_of_features
                
                push!(fill, sqrt(sum((ntt_features[i] - features[i]).^2)))
            end

        end
        push!(dst, fill)
    
    end
    return dst
end
dst=distance4(d, "nicholas" )
dst=sort(dst)
