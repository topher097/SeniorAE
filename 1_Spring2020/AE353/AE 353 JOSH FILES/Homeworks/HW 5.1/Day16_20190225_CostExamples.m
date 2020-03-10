function Day16_20190225_CostExamples(K, color, varargin)
% Parse arguments
if nargin == 4
    q = varargin{1};
    r = varargin{2};
elseif nargin == 2
    q = [];
    r = [];
else
    error('wrong number of arguments');
end


% Open-loop system
A = 5;
B = 1;

% Plot eigenvalues
subplot(2, 2, 1);
axis equal;
axis([-15 5 -5 5]);
grid on;
hold on;
p = eig(A - B * K);
plot(real(p), imag(p), 'kx', 'markersize', 8, 'linewidth', 2, 'color', color);
title('closed-loop eigenvalues');
set(gca, 'fontsize', 18);


% Compute time response
% - state
x0 = [-1];
t1 = 5;
t = linspace(0, t1, 1 + ceil(t1 / 1e-2));
x = zeros(size(A, 1), length(t));
for i = 1:length(t)
    x(:, i) = expm((A - B * K) * t(i)) * x0;
end
% - input
u = -K * x;
% - cost
if ~isempty(q)
    cost = zeros(size(t));
    for i = 1:length(t)
        cost(i) = integral(@(t) integrand(t, A, B, K, q, r, x0), 0, t(i));
    end
    cost_at_infinity = integral(@(t) integrand(t, A, B, K, q, r, x0), 0, inf);
end

% Plot time response
% - state
subplot(3, 2, 2);
plot(t, x, '-', 'linewidth', 2, 'color', color);
axis([0 t1 -2 2]);
grid on;
hold on;
title('state: x(t)');
set(gca, 'fontsize', 18);
% - input
subplot(3, 2, 4);
plot(t, u, '-', 'linewidth', 2, 'color', color);
axis([0 t1 -10 10]);
grid on;
hold on;
title('input: u(t)');
set(gca, 'fontsize', 18);
% - cost
if ~isempty(q)
    subplot(3, 2, 6);
    plot(t, cost, '-', 'linewidth', 2, 'color', color);
    axis([0 t1 0 50]);
    grid on;
    hold on;
    title('cost(t)');
    set(gca, 'fontsize', 18);
    
    subplot(2, 2, 3);
    plot(K, cost_at_infinity, '.', 'markersize', 16, 'color', color);
    xlabel('K');
    ylabel('cost');
    hold on;
    grid on;
    set(gca, 'fontsize', 18);
    title('cost(K)');
    axis([0 20 0 50]);
end

end


function cost = integrand(t, A, B, K, q, r, x0)
cost = zeros(size(t));
for i = 1:length(t)
    x = expm((A - B * K) * t(i)) * x0;
    u = -K * x;
    cost(i) = q * x^2 + r * u^2;
end
end

