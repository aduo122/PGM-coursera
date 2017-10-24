%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (isMax)
  for i = 1:length(P.cliqueList)
    P.cliqueList(i).val =  log(P.cliqueList(i).val);
  end
end
 
[i,j] = GetNextCliques(P,MESSAGES);
while i~=0 && j~=0
    CommonElement = intersect(P.cliqueList(i).var, P.cliqueList(j).var);
    DifferElement = setdiff(P.cliqueList(i).var, CommonElement);
    EVar = setdiff(P.cliqueList(i).var,CommonElement);
    T1 = P.edges(:,i);
    T1(j) = [];
    T2 = MESSAGES(:,i);
    T2(j) = [];
    D = T2(find(T1 == 1));
    tM = P.cliqueList(i);
    for p = 1:length(D)
        if (isMax)
            tM = FactorSum(tM,D(p)); 
        else
            tM = FactorProduct(tM,D(p));
        end
        
    end
    if (isMax)
        tM = FactorMaxMarginalization(tM,DifferElement);
    else
        tM = ComputeMarginal(CommonElement,tM,[]);
    end
    MESSAGES(i,j) = tM;
    [i,j] = GetNextCliques(P,MESSAGES);
end

 
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:N
    neighbours = P.edges(i, :);
    result = P.cliqueList(i);
    for j = 1:N
        if neighbours(j) == 1
            if isMax == 0
                result = FactorProduct(result, MESSAGES(j, i));
            else
                result = FactorSum(result, MESSAGES(j, i));
            end
        end
    end
    P.cliqueList(i) = result;
end


return
