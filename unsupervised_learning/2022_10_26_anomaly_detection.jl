#We build a model p(x)p(x) that assigns a probability to each data point xx, given all the data.

#Calculating the probability of occurrence of all the data points, we can choose the outlier by selecting those who are less likely than a threshold.

#GETTING DATA 
using ScikitLearn
using VegaLite
using LinearAlgebra
using Statistics
@sk_import covariance: EllipticEnvelope
@sk_import datasets: make_moons
@sk_import datasets: make_blobs

# Example settings
n_samples = 300
outliers_fraction = 0.05
n_outliers = round(Int64, outliers_fraction * n_samples)
n_inliers = n_samples - n_outliers

X, y = make_blobs(centers=[[0, 0], [0, 0]], cluster_std=0.5, random_state=1, n_samples=n_inliers, n_features=2)

@vlplot(mark=:point, x=X[:, 1], y=X[:, 2])

X[1, :]
#We can use the Gaussian or normal distribution to assign a probability to each data point.
size(X)
function pdf(X)
    
    f = zeros(size(X, 1), size(X, 2))
    for r in 1:size(f, 2)
        mu=mean(X[:, r])
        sigma=var(X[:, r])
        g=1/(sigma*2*π)
        for el in 1:size(f, 1)
             #making a matrix out of data
            f[el, r] = g*exp(-1/2*(X[el, r]-mu/sigma^2)^2) #table with probabilities
        end
    end
    probs = prod(f, dims=2)
    return probs
end


probs= pdf(X)

probs
function outliers(X, threshold)
    probs=pdf(X)
    outlier_arr=[]
    for j in 1:length(probs)
       if probs[j] < threshold
          push!(outlier_arr, X[j, :])
       end
    end
    return outlier_arr
end


o=outliers(X, 0.2) #these are the outliers with threshold 0.2

# EXCERCISE CREDIT CARDS


using CSV
using DataFrames
ccf=CSV.read("creditcardfraud_normalised.csv", DataFrame)
data = Matrix(ccf)
outliers_index,outliers_encoding = outliers(data,0.001)
