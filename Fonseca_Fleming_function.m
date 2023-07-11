function z=Fonseca_Fleming_function(x,D)
z1=1-exp(-sum(((x-1/sqrt(D)).^(2)),2));
z2=1-exp(-sum(((x+1/sqrt(D)).^(2)),2));
z=[z1,z2];
end