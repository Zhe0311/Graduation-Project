G_unique_ = sort(unique(G));

G_unique = [];

for i = 1 : 1 : length(G_unique_)/2
    G_unique = [G_unique; G_unique_(i)];
end

for i = length(G_unique_)/2+1 : 1 : length(G_unique_)/2+10
    G_unique = [G_unique; G_unique_(i)];
end

for i = length(G_unique_)/2+11 : 1 : length(G_unique_)
    G_unique = [G_unique; G_unique_(i)];
end

m = zeros(length(G_unique), 1);
va = zeros(length(G_unique), 1);
% top = zeros(length(G_unique), 1);
% bot = zeros(length(G_unique), 1);
for i = 1 : 1 : length(G_unique)
    m(i) = mean(crashtime(G == G_unique(i)));
%     top(i) = max(crashtime(G == G_unique(i))) - m(i);
%     bot(i) = m(i) - min(crashtime(G == G_unique(i)));
    va(i) = std(crashtime(G == G_unique(i)));
end

% plot(G_unique, m, 'r');
hold on;  
h = errorbar(G_unique, m, va, 'ks','MarkerSize',5,...
    'MarkerEdgeColor','b','MarkerFaceColor','b');
xlabel("G_{max}");
ylabel("追尾发生时间(s)");