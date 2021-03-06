G_unique__ = sort(unique(front));

G_unique_ = G_unique__;

% for i = 2 : 1 : length(G_unique__)
%     if G_unique__(i) - G_unique__(i-1) >= 1
%         G_unique_ = [G_unique_, G_unique__(i)];
%     end
% end

G_unique = [];

for i = 1 : 1 : length(G_unique_)
    G_unique = [G_unique; G_unique_(i)];
end

m = zeros(length(G_unique), 1);
va = zeros(length(G_unique), 1);
% top = zeros(length(G_unique), 1);
% bot = zeros(length(G_unique), 1);
for i = 1 : 1 : length(G_unique)
    % m(i) = mean(PDT_list(intersect(find((G_unique(i)-1) <= stableTime), find(stableTime <= (G_unique(i)+1)))));
    % va(i) = std(PDT_list(intersect(find((G_unique(i)-1) <= stableTime), find(stableTime <= (G_unique(i)+1)))));
    m(i) = mean(PDT_list(front == G_unique(i)));
    va(i) = std(PDT_list(front == G_unique(i)));
end

plot(G_unique, m, 'r');
hold on;
h = errorbar(G_unique, m, va, 'ks','MarkerSize',5,...
    'MarkerEdgeColor','b','MarkerFaceColor','b');
xlabel("Index_{front}");
ylabel("潜在危险时间比例");

% ii = find(stableTime >= 50);
disp(corr(front, PDT_list,'type','Pearson'));