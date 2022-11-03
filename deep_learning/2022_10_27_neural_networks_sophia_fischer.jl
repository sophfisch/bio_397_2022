using Flux
using ScikitLearn
using Statistics


### LOAD DATA
@sk_import datasets: load_digits
@sk_import model_selection: train_test_split
digits = load_digits();
X = Float32.(transpose(digits["data"]));  # make the X Float32 to save memory
y = digits["target"];

#SPLIT DATA
X_train, X_test, y_train, y_test = train_test_split(X', y, train_size=0.80, stratify=y)
X_train = X_train'
X_test = X_test'


#ONE_HOT ENCODING OF y_test and y_brain
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

y_train= onehot(y_train)

y_test=onehot(y_test)

X_test=transpose(X_test)
#X_train=transpose(X_train)

y_train=transpose(y_train)
y_test=transpose(y_test)
# FUNCTION RELU for inner layers, and LOGISTIC

leaky_relu(x, a=0.01) = max(a*x, x)


function logistic(z)
    σ=1 / (1 + exp(-z))
    return z
end


#LINEAR function  X for data, W for weights or slopes (same is A in linear regression), and b for intercepts

function linear(X, w, b)
    yhat=*(w,X).+b
    return yhat
end



#MODEL function
function modl(X, W1, b1, W2, b2, W3, b3)
    
    first=linear(X, W1, b1)
    z1=leaky_relu.(first)
    second=linear(z1, W2, b2)
    z2=leaky_relu.(second)
    last=linear(z2, W3, b3)
    pred=logistic.(last)
    return pred
end


#COST function that takes two Real numbers, actual y and predicted 




function cost_log(y, pred)
    cost= -(y * log(pred) + (1 - y) * log(1 - pred))
    return cost
end


function cost2(X, y, W1, b1, W2, b2, W3, b3)
    pred=modl(X, W1, b1, W2, b2, W3, b3)
    c=mean(cost_log.(y, pred))
    return c
end






function parameter_tuning2(X_train, y_train, alpha, iterations)
    W1=rand(Float64, (20, size(X_train, 1)))*10^-3
    W2=rand(Float64, (15, 20))*10^-3
    W3=rand(Float64, (10, 15))*10^-3

    b1=rand(Float64, 20) *10^-3
    b2=rand(Float64, 15) *10^-3
    b3=rand(Float64, 10) *10^-3
    for i in 1:iterations
        grads = gradient(() -> cost2(X_train, y_train, W1, b1, W2, b2, W3, b3), Flux.params(W1, b1, W2, b2, W3, b3))
        W1 = W1 .- alpha .* grads[W1]
        W2 = W2 .- alpha .* grads[W2]
        W3 = W3 .- alpha .* grads[W3]
        b1 = b1 .- alpha .* grads[b1]
        b2 = b2 .- alpha .* grads[b2]
        b3 = b3 .- alpha .* grads[b3]
    end
    
    return W1, W2, W3, b1, b2, b3
end

W1, W2, W3, b1, b2, b3=parameter_tuning2(X_train, y_train, 0.01, 10000)

predictions=modl(X_test, W1, b1, W2, b2, W3, b3 )


gradient_W1 = grads[W1]
