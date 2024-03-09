function fis = trainFis(trnData, c1, sig1, c2, sig2, num_rules)
    fis = newfis('FIS_SC', 'sugeno');
    names_in = {'in1', 'in2', 'in3'};
    numInputs = size(trnData, 2) - 1;

    for i = 1:numInputs
        fis = addInput(fis, [0 1], 'Name', names_in{i});
    end
    fis = addOutput(fis, [0 1], 'Name', 'out1');
    
    % Add Input Membership Functions
    for i = 1:numInputs
        input = strcat('in', string(i));
        for j = 1:size(c1, 1)
            fis = addMF(fis, input, 'gaussmf', [sig1(i) c1(j,i)]);
        end
        for j = 1:size(c2, 1)
            fis = addMF(fis, input, 'gaussmf', [sig2(i) c2(j, i)]);
        end
    end
    
    % Add Output Membership Functions
    params = [zeros(1, size(c1, 1)) ones(1, size(c2, 1))];
    for i = 1:num_rules
        output = strcat('out', string(1));
        fis = addMF(fis, output, 'constant', params(i));
    end
    
    % Add FIS Rule Base
    ruleList = zeros(num_rules, size(trnData, 2));
    for i = 1:size(ruleList, 1)
        ruleList(i, :) = i;
    end

    ruleList = [ruleList ones(num_rules, 2)];
    fis = addrule(fis, ruleList);
end