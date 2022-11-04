
using Flux, Statistics
using Flux: onehotbatch, onecold, logitcrossentropy
using MLDatasets
using Statistics: mean


train_x, train_y = MNIST.traindata()
test_x,  test_y  = MNIST.testdata()

train_x_n = reshape(train_x, 28, 28, 1, size(train_x,3))
test_x_n = reshape(test_x, 28, 28, 1, size(test_x,3))
train_y_h = onehotbatch(train_y, 0:9)
test_y_h = onehotbatch(test_y, 0:9)


model = Chain(
    Conv((5, 5), 1=>6,pad=(2,2), relu),
    MeanPool((2,2)),
    Conv((5, 5), 6=>16, relu),
    MeanPool((2,2)),
    Flux.flatten,
    Dense(400,120,relu),
    Dense(120,84,relu),
    Dense(84,10),
    softmax
)


cost(x, y) = logitcrossentropy(model(x), y)


optimiser = Descent(0.005)


iterations = 10

data = [(train_x_n,train_y_h)]
data2 = Flux.Data.DataLoader((train_x_n,train_y_h); batchsize=50, shuffle=true)
for i in 1:iterations
  for j in data2
    Flux.train!(cost, Flux.params(model), [j], optimiser)
  end
end


accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))
acc = accuracy(test_x_n, test_y_h)
