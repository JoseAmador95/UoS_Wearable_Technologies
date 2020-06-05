%% Plot Decision Boundaries
% This function was provided by the lab files. It was modified to include
% the axes boundaries and supporting feature sets with less than 3
% dimensions.

function plotdb(f, sty, classifier, classifierparam, numstep)
    assert(size(f, 2) <= 3, 'Cannot display more than 3 dimentions')
    xr= min(f(:,1)):max((max(f(:,1))-min(f(:,1)))/numstep,.1):max(f(:,1));

    if size(f,2) > 1
        yr=min(f(:,2)):max((max(f(:,2))-min(f(:,2)))/numstep,.1):max(f(:,2));
    else
        yr = zeros(1, length(xr));
    end

    if size(f,2) > 2
        zr=min(f(:,3)):max((max(f(:,3))-min(f(:,3)))/numstep,.1):max(f(:,3));
    else
        zr = zeros(1, length(xr));
    end
    
    [xg,yg,zg] = ndgrid(xr,yr,zr);
    xg = reshape(xg,size(xg,1)*size(xg,2)*size(xg,3),1);
    yg = reshape(yg,size(yg,1)*size(yg,2)*size(yg,3),1);
    zg = reshape(zg,size(zg,1)*size(zg,2)*size(zg,3),1);

    if size(f,2) > 2
        p = [xg yg zg];
    else
        p = [xg yg];
    end

    db = classifier(classifierparam,p);
    for a=1:5
        scatter3(xg(db==a),yg(db==a),zg(db==a), ...
            'MarkerFaceColor',sty{a}, 'MarkerEdgeColor', 'none', 'linewidth', 1);
        hold on;
    end
end