function haus = hausdorff(A1,B1)
sizea = length(A1);
sizeb = length(B1);

Ax = A1(:,1)/std(A1(:,1)); 
Ay = A1(:,2)/std(A1(:,2)); 

Bx = B1(:,1)/std(B1(:,1)); 
By = B1(:,2)/std(B1(:,2)); 
hab = 0;

for i = 1:sizea
    j = 1:sizeb;
    
    dd = ((Ax(i) - Bx(j)).^2 + (Ay(i) - By(j)).^2).^(0.5);
    shortab(i) = min(dd);
end

hab = sum(shortab)/sizea;
hba = 0;
for i = 1:sizeb
    j = 1:sizea;

    dd = ((Ax(j) - Bx(i)).^2 + (Ay(j) - By(i)).^2).^(0.5);
    shortba(i) = min(dd);
end

hba = sum(shortba)/sizeb;

haus = max(hab,hba);

