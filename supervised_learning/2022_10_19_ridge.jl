
#Modify the multivariate linear regression code that you had written before and add regularization to it to build a Ridge regression algorithm. 
#You will only have to change the cost function and the gradient function.

# RIDGE REGRESSION
############################################################################

using ML
using RDatasets
trees = dataset("datasets", "trees");
X = Matrix(trees[!, [:Girth,:Height]]);
Y = trees[!, :Volume];

############################################################################

# A
A = ML.ridge_linear_regression(X,Y,0.0001,0.1,10^7)[1]
cost = ML.ridge_linear_regression(X,Y,0.0001,0.1,10^7)[2]


############################################################################

# B
# 80% of data --> approx 25 datapoints
using StatsBase
train_ind = StatsBase.sample(1:size(X,1),25,replace=false)
train = X[train_ind,:]
test = X[Not(train_ind),:]
# fit with training data
A2 = ML.ridge_linear_regression(train,Y[train_ind],0.0001,0.1,10^7)[1]
# test with test data
o = ones(size(test,1))
XX = hcat(o,test)
prediction = ML.ridge_predict(XX,A2)
# compare to the real data
comparison = hcat(Y[Not(train_ind)],prediction)
residuals = Y[Not(train_ind)] .- prediction
print(residuals)
# We can see that our model isn't too far of the real values

############################################################################

# C
# fit higher polynomial model
iris = dataset("datasets", "iris");
X_iris = Matrix(iris[!, [:SepalLength,:SepalWidth,:PetalLength]]);
Y_iris = iris[!, :PetalWidth];
X_iris_new = hcat(X_iris[:,1],X_iris[:,2].^2,X_iris[:,3].^3)
A3 = ML.ridge_linear_regression(X_iris_new,Y_iris,0.0001,0.1,10^5)[1]
o = ones(size(X_iris,1))
XX_iris = hcat(o,X_iris)
prediction_iris = ML.ridge_predict(XX_iris,A3)
comparison = hcat(Y_iris,prediction_iris)
residuals_iris = Y_iris .- prediction_iris

using ScikitLearn
import ScikitLearn: fit!, predict
@sk_import linear_model: Ridge
model = Ridge(alpha=0.1)
ridge=fit!(model, X_iris_new, Y_iris)
ypred = ridge.predict(X_iris)
coef = ridge.intercept_, ridge.coef_
print(coef)
print(A)

############################################################################

# Comparison of tree model with ScikitLearn built in

using ScikitLearn
import ScikitLearn: fit!, predict
@sk_import linear_model: Ridge
model = Ridge(alpha=0.1)
ridge=fit!(model, X, Y)
ypred = ridge.predict(X)
coef = ridge.intercept_, ridge.coef_
print(coef)
print(A)

# FUNCTIONS
############################################################################
function ridge_predict(X,A)
    pred = X*A
    return pred
end

############################################################################

function ridge_gradient(X,Y,A,α::Number,λ)
    At = deepcopy(A)
    At[1] = 0
    a_gradient = (1/size(X,1)) * (((X*A-Y)')*X .+ (λ/size(X,1).*At)')
    A_new = A .- α * a_gradient'
    return A_new
end

############################################################################

function ridge_cost(X,Y,A,λ)
    pred = ridge_predict(X,A)
    cost = (1/2*size(X,1)) * (sum((pred.-Y).^2) + λ * sum(A.^2))
    return cost
end

############################################################################

function ridge_linear_regression(X,Y,α::Number,λ,iterations::Number)
    o = ones(size(X,1))
    X2 = hcat(o,X)
    A = zeros(size(X2,2))
    λ = λ
    cost = []
    for i in 1:iterations
        ncost = ridge_cost(X2,Y,A,λ)
        A .= vec(ridge_gradient(X2,Y,A,α,λ))
        push!(cost,ncost-ridge_cost(X2,Y,A,λ))
    end
    return A,cost
end

############################################################################