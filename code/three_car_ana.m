load cdata16.mat
lead = cdata(:,6);
mid = cdata(:,9);
last = cdata(:,12);
        
[m, n] = size(mid);
        
x = 1 : 1 : m;
figure();
plot(x, lead, 'k');
hold on;
plot(x, mid, 'b');
hold on;
plot(x, last, 'r');