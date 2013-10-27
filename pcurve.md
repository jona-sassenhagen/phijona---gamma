p values for main effects only (no interactions) for studies of gamma activity during semantic integration

urrutia		1	0.04
urrutia		2	0.03
penolazzi	1	0.007	(These are the main effects, for different frequency bands.)
penolazzi	2	0.029
penolazzi	3	0.05
hald		1	0.034
rommers		1	<0.005
rommers		2	0.032
rommers		3	0.052
rommers		4	0.045
wang		1	0.048 quote For the high fre- quencies (30–80Hz), the contrasts HC–LC and HC–SV both showed one significant cluster (p = 0.048 and 0.005, respec- tively), in the gamma-frequency range (40–50 Hz) between 0.2 and 1.0s, while the contrast of LC–SV showed no significant difference.
wang		2	0.005
hagoort		1	? (< 0.05)




corresponding p values for theta

urrutia		1	?
penolazzi	3	?
hald		1	0.048
rommers		1	> 0.05
wang		1	0.003 
wang		2	0.0005
hagoort		1	0.0002

roehm		1	0.0003
roehm		1	< 0.0001
bastiaansen 	1	< 0.0001
heine		1	0.028



%% matlab script for p-curve %%
gamma = [0.04
0.03
0.007
0.029
0.05
0.034
0.005
0.032
0.052
0.045
0.048
0.005]


theta=[0.048
0.003 
0.0005
0.0002
0.0003
0.0001
0.0001
0.028]

ksdensity(gamma);
hold on;
ksdensity(theta,'width',.02);
xlim([0 0.1])

line([0.05 0.05],[0 20])
set(gca,'YTickLabel','')
set(gca,'YTick',[])

set(h,'Resize','off')
set(h,'Position',[1 1 640 480])
 legend('gamma effects','theta effects','alpha = 0.05')
 title('Kernel Density estimate of p-values in previously published investigations')
