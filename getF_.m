function f_ = getF_(f,mode)
% f_ = getF_(f, mode)
% default mode is linear, w/ robust fit estimation

if ~exist('mode','var') || isempty(mode)
    mode = 'exp_linear';
end

switch mode
    case 'exp_linear'
        x = linspace(-1,1,length(f));
        xExp = exp(-x);
        b = robustfit([x',xExp'],f);
        f_ = [ones(length(f),1),x',xExp'] * b;
        f_ = f_';
    case 'exponential'
        % Robustly fit a straight line to log(fluorescence) and then
        % subtract exp(straightLine).
        f(f<0.1) = 0.1; % So that log() works without imaginary issues.
        fl = log(f);
        x = 1:numel(f);
        b = robustfit(x, fl);
        f_ = exp(b(1)+b(2)*x);
        
    case 'linear'
%         f = detrend(f);
        % Detrend is not robust to outliers, so we use robustfit instead:
        x = 1:numel(f);
        b = robustfit(x, f);
        f_ = b(1)+b(2)*x;

end