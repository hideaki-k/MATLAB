clear ; close all; clc
data = load('ex2data1.txt');
X = data(:, [1, 2])
y = data(:, 3)
[m, n] = size(X) % m = 100 n = 2
X = [ones(m, 1) X];
disp(X);
initial_theta = zeros(n + 1, 1);
disp(initial_theta); % 0 0 0
m = length(y) % m = 100

J = 0;
grad = zeros(size(initial_theta))
hy = X*initial_theta
h_theta = sigmoid(X*initial_theta)
disp(size(h_theta))

J = (1/m)*((-y'*log(h_theta))-(1-y)'*log(1-h_theta)) % 全データyと仮設h_thetaとの差を加算

options = optimset('GradObj', 'on', 'MaxIter', 800);
[theta, cost] = ...
	fminunc(@(t)(costFunction(t, X, y)), initial_theta, options)
  
fprintf('Cost at initial theta (zeros): %f\n', cost);
fprintf('Expected cost (approx): 0.693\n');
fprintf('Gradient at initial theta (zeros): \n');
fprintf(' %f \n', grad);
fprintf('Expected gradients (approx):\n -0.1000\n -12.0092\n -11.2628\n');
