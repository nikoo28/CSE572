sample = [newFeatureMat(1:end,:); newnFeatureMat(1:end,:)];
[m,~] = size(sample);
d = int16(m/66);
x = 1;
P1accuracyMetricsDTree = zeros(33,4);
P1accuracyMetricsSVM = zeros(33,4);
P1accuracyMetricsNN = zeros(33,4);
done = 0;

%Phase 1
fig1 = figure('visible','off');
hold on
for i=1:33
    if i==33
        inpMatrix = [newFeatureMat(x:end,:); newnFeatureMat(x:end,:)];
    else
        inpMatrix = [newFeatureMat(x:x+d-1,:); newnFeatureMat(x:x+d-1,:)];
    end
    [m,~] = size(inpMatrix);
    labels = [ones(m/2,1); ones(m/2,1)*2];
    inpMatrix = [inpMatrix labels];
    input = inpMatrix(randperm(end),:); 
    train_length = int16(0.6*m);
    training = input(1:train_length,:);
    testing = input(train_length+1:end,:);
    
    [prec,recall,fscore,ROC,done] = classify(training,testing,"DTree",done);
    P1accuracyMetricsDTree(i,:) = [prec recall fscore ROC];
    [prec,recall,fscore,ROC,done] = classify(training,testing,"SVM",done);
    P1accuracyMetricsSVM(i,:) = [prec recall fscore ROC];
    [prec,recall,fscore,ROC,done] = classify(training,testing,"NN",done);
    P1accuracyMetricsNN(i,:) = [prec recall fscore ROC];
    x = x+d;
end
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves for different classifiers')
legend('Decision Tree','SVM','NeuralNet')
saveas(fig,'Phase1_ROC.png')

%Phase 2
x = 10*d; 
inpMatrix = [newFeatureMat(1:x,:); newnFeatureMat(1:x,:)];
[m,~] = size(inpMatrix);
labels = [ones(m/2,1); ones(m/2,1)*2];
inpMatrix = [inpMatrix labels];
input = inpMatrix(randperm(end),:);
training = input;

x = x+1;
P2accuracyMetricsDTree = zeros(23,4);
P2accuracyMetricsSVM = zeros(23,4);
P2accuracyMetricsNN = zeros(23,4);
done = zeros(1,3);

fig2 = figure('visible','off');
hold on
for i=1:23
    if i==23
        testing = [newFeatureMat(x:end,:); newnFeatureMat(x:end,:)];
    else
        testing = [newFeatureMat(x:x+d-1,:); newnFeatureMat(x:x+d-1,:)];
    end
    [m,n] = size(testing);
    labels = [ones(m/2,1); ones(m/2,1)*2];
    testing = [testing labels];
    
    [prec,recall,fscore,ROC,done] = classify(training,testing,"DTree",done);
    P2accuracyMetricsDTree(i,:) = [prec recall fscore ROC];
    [prec,recall,fscore,ROC,done] = classify(training,testing,"SVM",done);
    P2accuracyMetricsSVM(i,:) = [prec recall fscore ROC];
    [prec,recall,fscore,ROC,done] = classify(training,testing,"NN",done);
    P2accuracyMetricsNN(i,:) = [prec recall fscore ROC];
    x = x+d;
end
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves for different classifiers')
legend('Decision Tree','SVM','NeuralNet')
saveas(fig2,'Phase2_ROC.png')

%classifier function
function [prec,recall,fscore,ROC,done] = classify(training,testing,method,done)
    [m,n] = size(training);
    training_data = training(:,1:end-1);
    training_labels = training(:,end);
    [test_m,~] = size(testing);
    test_data = testing(:,1:end-1);
    test_labels = testing(:,end);
    if method == "DTree"
        tree = fitctree(training_data,training_labels);
        if done == 0
            view(tree,'Mode','graph')
        end
        predicted_labels = predict(tree,test_data);
    elseif method == "SVM"
        svm = fitcsvm(training_data,training_labels);
        predicted_labels = predict(svm,test_data);
    elseif method == "NN"
        net = patternnet(10);
        training_data = reshape(training_data,n-1,m);
        training_labels = reshape(training_labels,1,m);
        training_labels = ind2vec(training_labels);
        test_data = reshape(test_data,n-1,test_m);
        test_labels = reshape(test_labels,1,test_m);
        [net,tr] = train(net,training_data,training_labels);
        predicted_labels = net(test_data);
        predicted_labels = reshape(vec2ind(predicted_labels),test_m,1);
    end
    CM = confusionmat(test_labels,predicted_labels);
    [X,Y,T,ROC] = perfcurve(test_labels,predicted_labels,2);
    if done < 3 
        plot(X,Y);
        done = done+1;
    end
    prec = CM(1,1)/(CM(1,1)+CM(2,1));
    recall = CM(1,1)/(CM(1,1)+CM(1,2));
    fscore = harmmean([prec,recall]);
end