function [ fit ] = fitCopula( family, X, method )
%FITCOPULA Fit single copula family to X using selected method. Depending
%on the method it preprocesses the data and the uniforms them. Uniformed
%data are then fitted to specified copula family.

dbg('fitcopulas', 3, 'Fitting family %s.\n', family);
fit.Family = family;

% Preprocess data for some types of copulas
if ismember(family, {'claytonhac*', 'gumbelhac*', 'frankhac*'})
    P = hac.preprocess( family(1:end-4), X, method );
    X = X * P;
    family = family(1:end-1);
end

% Obtain uniformed sample
if strcmp(method, 'CML')
    U = pseudoObservations(X);
elseif strcmp(method, 'IFM');
    U = probabilityTransform(X, fitMargins(X));
else
    error('Method %s not recognized.', method);
end

% Fit copula to uniformed data
copulaparams = copula.fit(family, U);
dbg('fitcopulas', 3, 'Computing statistics.\n');    
[ll, aic, bic, aks, snc] = copula.fitStatistics(copulaparams, U);

% Compose the resulting fit object    
fit.Copula = copulaparams;
fit.Method = method;
fit.LL = ll;
fit.AIC = aic;
fit.BIC = bic;
fit.AKS = aks;
fit.SnC = snc;

end

