
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

	S = whos('-file',sourcefile);

	for P = 1:4
	content_sizes(P) = S(P).bytes;
	end;
	[R,F] = max(content_sizes);
	allersp = eval(S(F).name);
	clear S(F).name;
	
	clear labels;

end;

clear max_t_coord
% run massive list of ttests  
% across experiments, frequencies, electrodes, time window lengths, time steps,
% and save coordinates of max val


winlength = [round(25/8),round(100/8),round(250/8)];			% /8 because of 125 hz sampling rate

for X = 1:10

	sourcefile = ['/home/jona/gamma/',num2str((X),'%01i'),'c.mat'];

	load(sourcefile)

	S = whos('-file',sourcefile);

	for P = 1:4
	content_sizes(P) = S(P).bytes;
	end;
	[R,F] = max(content_sizes);
	allersp = eval(S(F).name);
	clear S(F).name;
	
	for Y = 1:length(chanlocs)
		for Z = 1:length(all_available_chans)
			if strcmp(upper(chanlocs(Y).labels),all_available_chans(Z)) == 1;
			electrode(Z) = Y;
			end;
		end;
	end;

	[nfreqs,ntimes,nchans,nsubjs]=size(allersp);

	coord=[];t=[];
	for frequencies = 45:90											% freqs(frequencies) will tell you what frequency it is
		for e = 1:length(all_available_chans)						% chanlocs(elec).label will tell you what electrode it is
			elec = electrode(e);									% choose elec (1/(length(C)))
			for winsize = 1:length(winlength)						% choose timewins (1/4)
				startingpositions = [0:winlength(winsize):round(1000/8)];
 				for timewindow = 1:length(startingpositions)-1;		% times(t1:t2) will tell you what time point you're looking at
					windowstart = startingpositions(timewindow);
																	% choose beginning of timewindow (depends on winsize)
					for subject = 1:nsubjs							% choose subj (depends on exp)
					
						t1 = windowstart+61;						% 61 is time point 0 b/c the -760:1760 time window data is sampled at 125 hz
						t2 = t1+(winlength(winsize));					
						value(subject)=mean(allersp(frequencies,t1:t2,elec,subject));
					end;
					[h,p,ci,stats] = ttest(value);
					t = [t,stats.tstat];
					coord = [coord;{frequencies,t1,t2,chanlocs(elec).labels}];
					clear value;
				end;
			end;
		end;
	end;
	
	[tvalue,max_tval_index] = max(abs(t))							% find max val
	max_t_coord{X} = [coord(max_tval_index,:,:,:)];					% save frequency/time/electrode coordinates for max val


end;


% tested up to this point

% jackknife
% calculate max val ttests again on each subject

for X = 1:10


sourcefile = ['/home/jona/gamma/',num2str((X),'%01i'),'c.mat'];

	load(sourcefile)

	for Y = 1:10

		[h,p,ci,stats] = ttest(mean((allersp(max_t_coord{Y})),2));

		outcomes(X,Y) = h;
		
	end;

end;