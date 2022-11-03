using ScikitLearn
@sk_import datasets:load_digits


digits = load_digits();
X = digits["data"];
y = digits["target"];


#use one-hot encoding on y
function onehot(Y)
    categories = sort(unique(Y))
    mat = Matrix(undef, length(Y), length(categories))
    for i in 1:length(categories)
        present = []
        for row in Y
            if row == categories[i]
                push!(present, 1)
            else
                push!(present, 0)
            end
        end
        mat[:, i] = present
    end
    return mat
end

#getting random 80% of data to train model with
using StatsBase
N = length(y)
onehot_y = onehot(y)
training_data_index = sort(StatsBase.sample((1:N), Int(round(0.8 * N)), replace=false))
training_data_y = onehot_y[training_data_index, :]
training_data_x = X[training_data_index, :]


sigmoid(x) = max(min(1 / (1 + exp(-x)), 0.99999), 0.000001)

function logistic_regression_predict2(X, A)
    m = X * A
    #pred=maximum.(minimim.(1 ./ 1 .+ exp.(-m)), 0.99999, 0.00001)
    #pred=@. 1/(1+exp(-m))
    pred = sigmoid.(m)
    return pred
end

#change derivative function
function logistic_regression_gradient(X, Y, A, alpha)
    n = size(X, 1)
    yhat = logistic_regression_predict2(X, A)
    derivative = -1 / n .* ((Y .- yhat)' * X)'
    new_d = A .- (alpha .* derivative)
    return new_d
end

function logistic_cost(X, Y, A)
    pred = logistic_regression_predict(X, A)
    cost = (1 / 2 * size(X, 1)) * sum((A .- Y) .^ 2)
    return cost
end

function logistic_regression(X::Matrix, Y::Array, alpha::Number, iterations::Number)
    A = zeros(size(X)[2], size(Y)[2])
    for i in 1:iterations
        A = logistic_regression_gradient(X, Y, A, alpha)
    end
    return A
end

accuracy(y, ypred) = count(y .== ypred) / length(y)

Atrained = logistic_regression(training_data_x, training_data_y, 0.1, 10000)
preds = logistic_regression_predict2(training_data_x, Atrained)
predsnums = [i[2] - 1 for i in findmax(preds, dims=2)[2]]
true_outputs = y[training_data_index]
accuracy(true_outputs, predsnums)

