using ScikitLearn
import ScikitLearn: fit!, predict
using ML
@sk_import datasets: load_diabetes
all_data = load_diabetes()

X = all_data["data"]
y = all_data["target"]

function multivariate_predict(X,A)
    pred = X*A
    return pred
end
function gradient_lasso(X,Y,A,λ)
    predict = multivariate_predict(X,A)
    gradient = (1/size(X,1)) *(((predict - Y)') * X)
    At = deepcopy(A)
    At[1] = 0
    Abs = abs.(At)
    gradient = gradient' .+ ((λ ./(size(X,1)) .*Abs)) .*At
    return vec(gradient)
end

############################################################################

function cost_lasso(X,Y,A,λ=4)
    predict = ML.multivariate_predict(X,A)
    cost = 1/(2*(size(X,1)))* sum((predict .- Y).^2)
    cost = cost + λ*sum(abs.(A))
    return cost
end

############################################################################

function lasso_linear_regression(X,Y,λ,iterations)
    A= zeros(size(X,2))
    for i in 1:iterations
        gradient = gradient_lasso(X,Y,A,λ)
        A = (A.- α*gradient)
    end
    return A
end

############################################################################
lasso_linear_regression(X, y, 0.4, 10)