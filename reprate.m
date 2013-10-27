mastercell = {lfcontrast gammacontrast lfc gammac lfs gammas};
values=[];values2=[];
for X = 1:length(mastercell)

	data = mastercell{X};
	data2 = data;
	num_exp = length(data);
	for Y = 1:num_exp

		data2(Y,Y) = 0;
	end;

	sum(sum(data));
	sum(sum(data2));
	values = [values; sum(sum(data))]
	values2 = [values2; sum(sum(data2))]

end;


values = 100*(values/121)
values2 = 100*(values2/121)

h = figure;
bar([ values(1) 0 values(3)  0 values(5) 0  ], 'FaceColor',[0.5,0.5,0.9],'EdgeColor','b')

hold on;

bar([ 0	 values(2)  0	 values(4)	 	0	 values(6)  ], 'FaceColor',[0.9,0.5,0.5],'EdgeColor','r')


hold on;

bar([ values2(1) 0 values2(3)  0 values2(5) 0  ], 'FaceColor','b','EdgeColor','b')

hold on;

bar([ 0	 values2(2)  0	 values2(4)	 	0	 values2(6)  ], 'FaceColor','r','EdgeColor','r')

set(gca,'XTick',[1.5 3.5  5.5])

set(gca,'XTickLabel',{'contrast' 'congruent' 'violation'})

legend('<12 hz','>30hz',sprintf('<12hz (only\nindependent)'),sprintf('>30hz (only\nindependent)'))
title('replication rate in %')

set(h,'Resize','off')
set(h,'Position',[1 1 1024 768])
