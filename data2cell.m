function c = data2cell(data)
%data struct to cell
len=length(data);
c=cell(len,2);
for i=1:len
    c(i,1)={i};
    c(i,2)={data(i).name};
end
end

