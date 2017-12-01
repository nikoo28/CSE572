featureMat = [STD FFT DWT RMS RANGE MODE MAX MIN AVG];
nfeatureMat = [nSTD nFFT nDWT nRMS nRANGE nMODE nMAX nMIN nAVG];

[samples,ft] = size(featureMat);
[coeff,scores,latent] = pca(featureMat);
[ncoeff,nscores,nlatent] = pca(nfeatureMat);
newFeatureMat = featureMat*coeff;
newFeatureMat = newFeatureMat(:,1:18);
newnFeatureMat = nfeatureMat*ncoeff;
newnFeatureMat = newnFeatureMat(:,1:18);
% figure
% for i=1:numComp
%     subplot(numComp,1,i)
%     hold on
%     plot(featureMat(:,i)*coeff(i))
%     plot(nfeatureMat(:,i)*ncoeff(i))
%     legend('eating','non-eating')
% end
% 
% ftlabel = zeros(ft,1);
% for i=1:ft
%     ftlabel(i) = i;
% end
% figure
% biplot(coeff(:,1:2),'scores',scores(:,1:2),'varlabels',int2str(ftlabel));
% figure
% biplot(ncoeff(:,1:2),'scores',nscores(:,1:2),'varlabels',int2str(ftlabel));
