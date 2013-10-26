% masterplotscript


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

%	A = mean(allersp(50:90-8,61:end-61,electrode,:),4);

	% get max gamma coordinates
	A = mean(allersp,4);
	A(:,1:61,:) = 0;
	A(:,175:end,:) = 0;
	A(1:50,:,:) = 0;
	C = setdiff(electrode,1:nchans);
	A(:,:,C) = 0;
		
	[maxval maxloc] = max(A(:));
	[maxfreq maxtime maxchan] = ind2sub(size(A), maxloc);

	all_max_coordinates_gamma(X,1) = maxfreq;
	all_max_coordinates_gamma(X,2) = maxtime;

	% get alpha coordinates
	A = mean(allersp,4);
	A(:,1:61,:) = 0;
	A(:,175:end,:) = 0;
	A(1:12,:,:) = 0;
	A(20:end,:,:) = 0;
	C = setdiff(electrode,1:nchans);
	A(:,:,C) = 0;
		
	[maxval maxloc] = max(A(:));
	[maxfreq maxtime maxchan] = ind2sub(size(A), maxloc);

	all_max_coordinates_alpha(X,1) = maxfreq;
	all_max_coordinates_alpha(X,2) = maxtime;


	% get alpha coordinates
	A = mean(allersp,4);
	A(:,1:61,:) = 0;
	A(:,175:end,:) = 0;
	A(12:end,:,:) = 0;
	C = setdiff(electrode,1:nchans);
	A(:,:,C) = 0;
		
	[maxval maxloc] = max(A(:));
	[maxfreq maxtime maxchan] = ind2sub(size(A), maxloc);

	all_max_coordinates_theta(X,1) = maxfreq;
	all_max_coordinates_theta(X,2) = maxtime;



	clear allersp;
end;


figure;
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

	sbplot(3,4,X);
	tftopo(allersp,times,freqs,'mode','ave','limits', [nan nan nan nan -2 2], 'timefreqs', [times(all_max_coordinates_gamma(X,2)) freqs(all_max_coordinates_gamma(X,1));  times(all_max_coordinates_theta(X,2)) freqs(all_max_coordinates_theta(X,1)); times(all_max_coordinates_alpha(X,2)) freqs(all_max_coordinates_alpha(X,1));], 'chanlocs', chanlocs,'smooth',3,'style','map','electrodes','off');

end;
