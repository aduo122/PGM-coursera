%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j. 
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return 
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a 
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [i, j] = GetNextCliques(P, messages)

% initialization
% you should set them to the correct values in your code
i = 0;
j = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(P);
[A,I] = sort(sum(P.edges,1));
l = length(I);
flag = 0;
for p = 1:l
    TestList = find(P.edges(I(p),:) == 1);
    messages(I(p),TestList);
    for q = 1:length(TestList)
        if (isempty(messages(I(p),TestList(q)).card))
            TestReceiveList = find(P.edges(:,I(p)) == 1);
            TestReceiveList(q,:) = [];
            tsum = 0;
            for r = 1:length(TestReceiveList)
                tsum = tsum + isempty(messages(TestReceiveList(r),I(p)).card);
            end
            if tsum == 0
                i = I(p) ;
                j = TestList(q) ;
                flag = 1;
                break
            end
        end
        if flag == 1
            break
        end
    end
end

return;

