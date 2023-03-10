function nven = normalizeVec(vec)
  normThresh  = 1.5;
  assert(isequal(size(vec),[3,1])||isequal(size(vec),[4,1]), ...
    "[normalizeVec]-->> not a col vec")
  assert(isequal(class(vec), "double"), "[normalizeVec]->> vec is not a matrix!");
  nven  = vec ./ sqrt(sum(vec.*vec)); % normalize v answer 
  if all(nven < 0) 
      nven = - nven; 
  end 
  if isequal(size(vec),[4,1]) && nven(1) < 0 
      nven = - nven; 
  end 
  
  if ~(sqrt(sum(nven.*nven))<normThresh)
    disp(nven);
    disp(sqrt(sum(nven.*nven)));
  end
  assert(sqrt(sum(nven.*nven))<normThresh,"[normalizeVec]->> nven not normalized properly!!"  );
  %disp("nven");
  %disp(nven);
  %;
  
