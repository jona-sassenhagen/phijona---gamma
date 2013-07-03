filelist = { ' ' };


% find subset of common electrodes across all data sets

for X = 1:length(filelist)

	load file

	for elec = 1:EEG.nbchan
		labels{elec} = EEG.chanlocs(elec).labels;
	end;

	all_available_chans = intersect(upper(labels),upper(all_available_chans));

end;



% run massive list of ttests across files, frequencies, electrodes, time window lengths, time steps, and save coordinates of max val

timewindows = {[0:50:1000], [0:100:1000], [0:250:1000], [0:500:1000]};

for X = 1:length(filelist)

	load file

	for Y = 1:length(chanlocs)
		for Z = 1:length(all_available_chans)
			if strcmp(upper(chanlocs(Y).labels),all_available_chans(Z)) == 1;
			elec(Z) = Y;
			end;
		end;
	end;

	[ntimes,nfreqs,nchans,nsubjs]=size(allersp);


	for frequencies = 45:90
		for elec = length(all_available_chans)						% choose elec (1/(length(C)))
			for timewinsize = 1:length(timewindows)					% choose timewins (1/4)
				for timewindow = 1:length(timewindows(timewinsize))	% choose position in timewindow (depends on winsize)
					for subject = 1:nsubjs							% choose subj (depends on exp)
						
						[h,p,ci,stats] = ttest(mean((allersp(frequencies,timewindow,elec,subject)),2));
						t = [t,stats];
						coord = [coord,{frequencies,timewindow,elec,subject}];

					end;
				end;
			end;
		end;
	end;

	[tvalue,max_tval_index] = max(abs(t));
	max_t_coord{X} = coord(max_tval_index);

end;



% calculate max val ttests again on each subject

for X = 1:length(filelist)

	load file

	for Y = 1:length(filelist)

		[h,p,ci,stats] = ttest(mean((allersp(max_t_coord{Y})),2));

		outcomes(X,Y) = h;
		
	end;

end;