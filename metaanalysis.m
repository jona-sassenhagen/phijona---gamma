
% find subset of common electrodes across all data sets
for X = 1:11

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

	for P = 1:4													% this one finds the name of allersp
	content_sizes(P) = S(P).bytes;
	end;
	[R,F] = max(content_sizes);
	allersp = eval(S(F).name);
	clear S(F).name;											% ... just to clear it again
	
	clear labels;

end;
 
U = 1; 
% run massive list of ttests  
% across experiments, frequencies, electrodes, time window lengths, time steps,
% and save coordinates of max val
clear max_t_coord
hs = [];
winlength = [round(25/8),round(100/8),round(250/8)];				% /8 because of 125 hz sampling rate

for X = 1:11

	sourcefile = ['/home/jona/gamma/',num2str((X),'%01i'),'c.mat'];

	load(sourcefile)

	S = whos('-file',sourcefile);

	for P = 1:4														% find the ERSP data (which have varying names)
	content_sizes(P) = S(P).bytes;
	end;
	[R,F] = max(content_sizes);
	allersp = eval(S(F).name);
	clear S(F).name;
	
	for Y = 1:length(chanlocs)										% this is supposed to get the numbers of the appropriate electrodes, which differ between files
		for Z = 1:length(all_available_chans)						% note that it requires all_available_chans to still be available
			if strcmp(upper(chanlocs(Y).labels),all_available_chans(Z)) == 1;
			electrode(Z) = Y;
			end;
		end;
	end;

	[nfreqs,ntimes,nchans,nsubjs]=size(allersp);

	coord=[];t=[];
	for frequencies = 1:20											% freqs(frequencies) will tell you what frequency it is
%	for frequencies = 50:90-8											% freqs(frequencies) will tell you what frequency it is
		for e = 1:length(all_available_chans)						% chanlocs(elec).label will tell you what electrode it is
			elec = electrode(e);									% choose elec (1/(length(C)))
			for winsize = 1:length(winlength)						% choose timewins (1/4)
				startingpositions = [0:winlength(winsize):80];		% hardcoded 1000 msec window
 				for timewindow = 1:length(startingpositions)-1;		% times(t1:t2) will tell you what time point you're looking at
					windowstart = startingpositions(timewindow);
																	% choose beginning of timewindow (depends on winsize)
					for subject = 1:nsubjs							% choose subj (depends on exp)
					
						t1 = windowstart+61;						% hardcoded 61 as time point 0
						t2 = t1+(winlength(winsize));					
						value(subject)=mean(mean(allersp(frequencies:frequencies+3,t1:t2,elec,subject)));
%						value(subject)=mean(mean(allersp(frequencies:frequencies+8,t1:t2,elec,subject)));

						U = U+1;
					end;
					[h,p,ci,stats] = ttest(value);
					t = [t,stats.tstat];
					hs = [hs,h];
					coord = [coord;{frequencies,t1,t2,chanlocs(elec).labels}];
					clear value;
				end;
			end;
		end;
	end;
	
	[tvalue,max_tval_index] = max(abs(t))							% find max val
	max_t_coord{X} = [coord(max_tval_index,:,:,:)];					% save frequency/time/electrode coordinates for max val
	allhs(X) = hs(max_tval_index);
	clear allersp;
end;



% jackknife
% calculate max val ttests again on each subject

outcomes = [];
for X = 1:11

	sourcefile = ['/home/jona/gamma/',num2str((X),'%01i'),'c.mat'];

	load(sourcefile)


	S = whos('-file',sourcefile);

	for P = 1:4													% this again finds allersp
		content_sizes(P) = S(P).bytes;
	end;
	[R,F] = max(content_sizes);
	allersp = eval(S(F).name);

	for Y = 1:11												% this loop tests all the coordinates from max_t_coord
																% note that each file is also tested against its own max t vals!
		a = max_t_coord{Y};
		frequency = a{1}; t1 = a{2}; t2 = a{3}; elec = a{4};
		
		for elect = 1:length(chanlocs)								% this is supposed to get the numbers of the appropriate electrodes, which differ between files
			if strcmp(upper(chanlocs(elect).labels),elec) == 1;
				el = elect;
			end;
		end;
		
		[h,p,ci,stats] = ttest(mean( allersp( frequency, t1:t2, el, :  ),2));

		if h == 1												% this should provide the coordinates of all positive tests
			sourcefile
			frequency
			t1
			t2
			chanlocs(el).labels
		end;

%		if Y == 10 
%			if h == 1
		
%				sourcefile
%				frequency
%				t1
%				t2
%				chanlocs(el).labels
%			end;
%		end;
		
%		if X == Y
%			h
%		end;
		
		outcomes(X,Y) = h;
		
	end;
	clear allersp;
end;

U
sum(sum(outcomes))
outcomes

% figure; tftopo(allersp,times,freqs,'mode','ave','limits', [nan nan nan nan nan nan], 'timefreqs', [times(166) 30], 'chanlocs', chanlocs,'smooth',2,'style','map','electrodes','off');
