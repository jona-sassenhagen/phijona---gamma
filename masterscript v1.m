
% find subset of common electrodes across all data sets
for X = 1:10

	sourcefile = ['/home/jona/gamma/',num2str((X),'%01i'),'c.mat'];
	sourcefiles = ['/home/jona/gamma/',num2str(X),'s.mat'];

	load(sourcefile)

	for elec = 1:length(chanlocs)
		labels{elec} = chanlocs(elec).labels;
	end;

	sourcefile

	if X == 1
		all_available_chans = upper(labels);
	else
		all_available_chans = intersect(upper(labels),upper(all_available_chans))
	end;

	clear labels;

end;



% run massive list of ttests  
% across experiments, frequencies, electrodes, time window lengths, time steps,
% and save coordinates of max val

timewindows = {[0:25:1000], [0:100:1000], [0:250:1000]};
winlength = {25,100,250};

for X = 1:10

	sourcefile = ['/home/jona/gamma/',num2str((X),'%01i'),'c.mat'];

	load(sourcefile)

	for Y = 1:length(chanlocs)
		for Z = 1:length(all_available_chans)
			if strcmp(upper(chanlocs(Y).labels),all_available_chans(Z)) == 1;
			electrode(Z) = Y;
			end;
		end;
	end;

	[ntimes,nfreqs,nchans,nsubjs]=size(allersp);

	coord=[];t=[];
	for frequencies = 45:90
		for e = 1:length(all_available_chans)
			elec = electrode(e);									% choose elec (1/(length(C)))
			for winsize = 1:length(timewindows)						% choose timewins (1/4)
				for timewindow = 1:length(timewindows(winsize))-1	% choose position in timewindow (depends on winsize)
					for subject = 1:nsubjs							% choose subj (depends on exp)
					
						tframe = [timewindow:(timewindow+winlength(winsize))]
					
						value(subject) = mean((allersp(frequencies,tframe,elec,subject)),2);
					end;
					[h,p,ci,stats] = ttest(value);
					t = [t,stats.tstat];
					coord = [coord;{frequencies,timewindow,elec}];
					clear value;
				end;
			end;
		end;
	end;
	
	[tvalue,max_tval_index] = max(abs(t));
	max_t_coord{X} = coord(max_tval_index);

	

end;



% calculate max val ttests again on each subject

for X = 1:10


sourcefile = ['/home/jona/gamma/',num2str((X),'%01i'),'c.mat'];

	load(sourcefile)

	for Y = 1:10

		[h,p,ci,stats] = ttest(mean((allersp(max_t_coord{Y})),2));

		outcomes(X,Y) = h;
		
	end;

end;