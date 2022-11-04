#Write a PCA function that accepts two arguments: data X and k for the reduced number of features. The output is the data in the new dimensions and the total explained variance by the new dimensions.
#Reduce the dimensions of the dataset below to 2D for visualization.
#Reduce the dimensions of the dataset below to k dimensions such that those k new features explain 99% of the variance in the data.

using Statistics
using ScikitLearn
using LinearAlgebra
@sk_import datasets: load_breast_cancer
all_data = load_breast_cancer()

X = all_data["data"]
y = all_data["target"]


#Data should be mean normalized and scaled before PCA. So the data should have a mean zero and the same scale. You may apply feature scaler after the normalization step.
function pca(X)
    # determine the mean of the and subtract that value from all the entries
    mn=mean(X)
    s=std(X)
    norm_X=(X.-mn)/s

    mean(new_X) #new X
    #making covariance matrix
    covm_X=Statistics.cov(new_X) #element i,j shows the covariance of feature i and feature j.

    #Compute the eigenvectors of covm: the eigvecs command from the LinearAlgebra package in Julia.


    eigen_vecs=eigvecs(covm_X)
    eigen_vals=eigvals(covm_X)
    #sort eigenvalues for best and choose their vectors
    indexes_sorted=sortperm(eigen_vals, rev=true)
    uk = eigen_vecs[:,indexes_sorted]
    X_comp = norm_X*uk
    sum(eigen_vals)
    #k new features explain 99% of the variance in the data
    s_vals=sum(eigen_vals)
    perc= eigen_vals./ s_vals
    #sorted_perc=sort(perc, rev=true)
    #index_perc=sortperm(perc, rev=true)

    return X_comp, perc
end


X_comp, percent_expl = pca(X)

Plots.scatter(X_comp[:, 1], X_comp[:, 2])
#The first k eigenvectors are the vectors on to which we want to project the data u_ku 



function find_k(X, thresh)
    k=size(X,2)
    X_comp, percent_expl = pca(X, k)
    perc = sum(percent_expl)
    while perc > thresh
        k=k-1
        perc = sum(percent_expl[1:k])
    end
    return k
end


find_k(X, 0.99999)
