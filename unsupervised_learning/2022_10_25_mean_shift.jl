
#excercise 1 to write algorithm
using ScikitLearn
using DataFrames
@sk_import datasets: make_blobs
features, labels = make_blobs(n_samples=500, centers=3, cluster_std=0.55, random_state=0)

using Statistics

using Images
#Write a kernel function. A kernel function receives two arguments: distance and λ, and returns weight. 
#The simplest kernel function is a flat one where weight is 1 if distance is less than λ and 0 otherwise.
    
#For a distance function, you may Euclidean distance.
using Distances

function distance(X, mn) #takes sample and gives distance to mean, euclidian
    
    distances=zeros(size(X,1))
    for row in size(X, 1)
        distances[row, :] .= euclidean(X[row, :], mn)
    end
    return distances
end



X=features
mn=[mean(X[:, 1]), mean(X[:,2])]
function kernel(X, λ)
    dst=distance(X)
    weight=zeros(length(dst))
    for r in length(dst)
        if dst[r] < λ
            weight[r]=1
        else
            weight[r]=0
        end
    end
    return weight
end



#Write a shift function. This function will be applied to each data point and move them.
#The shift function should accept three arguments: a data point p, all data X, and λ.
#Write a loop for each sample in X. Calculate the weight of each sample according to its distance from p.
#Return the new position of p by taking the weighted average of all the points.
    
λ=4
#take only points where weight==1

g=shift(features, 4) 

# shift function
function shift(p,X,λ)
    weight = Float64[]
    for i in 1:size(X,1)
        distance = euclidean(p,X[i,:])
        push!(weight,kernel(distance,λ))
    end
    reshape(weight,size(X,1),1)
    new_point = mean(weight .* X,dims=1)
    return new_point'
end
#in a while loop, keep shifting the point using the shift function.
#After each shift, check whether it has moved more than the threshold.
#If not, it has reached the peak. In this case, check whether its distance to any of the centroids is less than the threshold. If it is, then move on to the next sample.
#Otherwise, add the shifted point to the list of centroids.

function mean_shift2(X, λ, threshold)
    centroids=[]
   for row in 1:size(X, 1) 
        p=X[row, :]
        c=deepcopy(p)
        move=1000
        valid =true
        #while valid==true
            new_mean= (c[row,:],X)          
            move=euclidean.(new_mean[row, :], c)
            if move < threshold
                if euclidean(new_mean, centroids) < threshold
                    valid= false
                else
                    push!(centroids, new_mean)
                end
            end

            
       # end
    end
    return centroids
end


p=X[5, :]
c=deepcopy(p)

c[1, : ]
g=mean_shift2(features, 4.3, 0.1) 

new_mean= (c[1,:],X)          
move=euclidean(new_mean, c[1, : ])


# assign sample to closest cluster
function cluster_assign_mean_shift(features,centroids)
    distances = []
    d=[]
    clusters = []
    size_data = size(features,1)
    for data_point in 1:size_data
        for centroid in 1:length(centroids)
            d = distance(features[data_point,:],centroids[centroid])
            push!(distances,d)
        end
        index_of_min = argmin(distances)
        push!(clusters,index_of_min)
        distances = []
    end
    return clusters
end
################################# 2 #####################################
# GETTING IMAGE
img=load("simple_landscape.jpg")

#For each pixel, define five features: x and y positions, luminosity, and color channels (U, V)


#CONVERTING FROM RGB TO YUV
function RGB_YUV(img)
    
    R=red.(img)
    G=green.(img)
    B=blue.(img)
    x = []
    y = []
   
    for xx in 1:height(img)
        for yy in 1:width(img)
            push!(x, xx)
            push!(y, yy)
        end
    end

    pix = hcat(x,y)

    Y = 0.299R .+ 0.587G .+ 0.114B
    U = 0.492 .*(B.-Y)  # or U = -0.147R - 0.289G + 0.436B
    V = 0.877 .*(R.-Y)  # or V = 0.615R - 0.515G - 0.100B
    Y = reshape(Y, size(pix, 1), 1)
    U = reshape(U, size(pix, 1), 1)
    V = reshape(V, size(pix, 1), 1)
  
    
    features = hcat(pix,Y,U,V)



    
 
    return features
end

f=RGB_YUV(img)


img_n0f8 = N0f8, x, y


#Create a new image where each pixel has the RGB values of the centroid.

#SCALING

using Statistics
feature_matrix_normalized = zeros(size(features))
for i in 1:size(features,2)
    mm = mean(features[:,i])
    sd = std(features[:,i])
    for p in 1:size(features,1)
        feature_matrix_normalized[p,i] = (features[p,i] - mm) / (maximum(features[:,i])-minimum(features[:,i]))
    end
end
feature_matrix_normalized

@sk_import cluster: MeanShift

model = MeanShift(bandwidth=0.5)
fitted = model.fit(feature_matrix_normalized)

centroids = model.cluster_centers_ #the centroids
labels = model.labels_ #which centroid the pixel belongs to

labels = labels .+ 1 #to avoid bounds error
#BACK TO RGB

#first get RGBs of centroids

feature_matrix_normalized()

R = YUV[:,1] .+ 1.140 .* YUV[:,3] 
G = YUV[:,1] .- 0.395 .* YUV[:,2] .- 0.581*YUV[:,3]
B = YUV[:,1] .+ 2.032 .* YUV[:,3]


C = N0f8.(collect(0:1/length(R):1))

segmented_image = img



for i in 1:length(img)
    segmented_image[i] = RGB(C[labels[i]],C[labels[i]],C[labels[i]])
end


