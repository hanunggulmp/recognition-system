function colorDist = Euclidean(R,G,B, R1,G1,B1)
    R = double(R);
    G = double(G);
    B = double(B);
    R1 = double(R1);
    G1 = double(G1);
    B1 =double(B1);
    colorDist = sqrt((((R1-R).^2) + ((G1-G).^2) + ((B1-B).^2)));
    colorDist = round(colorDist);
return