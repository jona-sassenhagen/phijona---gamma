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
	A(:,135:end,:) = 0;
	A(1:50,:,:) = 0;
	C = setdiff(electrode,1:nchans);
	A(:,:,C) = 0;
		
	[maxval maxloc] = max(abs(A(:)));
	[maxfreq maxtime maxchan] = ind2sub(size(A), maxloc);

	all_max_coordinates_gamma(X,1) = maxfreq;
	all_max_coordinates_gamma(X,2) = maxtime;

	% get alpha coordinates
	A = mean(allersp,4);
	A(:,1:61,:) = 0;
	A(:,135:end,:) = 0;
	A(1:12,:,:) = 0;
	A(20:end,:,:) = 0;
	C = setdiff(electrode,1:nchans);
	A(:,:,C) = 0;
		
	[maxval maxloc] = max(abs(A(:)));
	[maxfreq maxtime maxchan] = ind2sub(size(A), maxloc);

	all_max_coordinates_alpha(X,1) = maxfreq;
	all_max_coordinates_alpha(X,2) = maxtime;


	% get theta coordinates
	A = mean(allersp,4);
	A(:,1:61,:) = 0;
	A(:,135:end,:) = 0;
	A(11:end,:,:) = 0;
	A(1:3,:,:) = 0;
	C = setdiff(electrode,1:nchans);
	A(:,:,C) = 0;
		
	[maxval maxloc] = max(abs(A(:)));
	[maxfreq maxtime maxchan] = ind2sub(size(A), maxloc);

	all_max_coordinates_theta(X,1) = maxfreq;
	all_max_coordinates_theta(X,2) = maxtime;



	clear allersp;
end;



gammac = ...
[    1     0     0     0     0     0     0     0     0     0     0; ...
     0     1     0     0     0     0     0     0     0     0     0; ...
     0     0     1     0     1     0     0     0     0     0     0; ...
     0     0     0     0     1     0     0     0     0     0     0; ...
     0     0     0     0     1     0     0     0     0     0     0; ...
     0     0     0     0     0     1     0     0     0     0     0; ...
     0     0     0     0     0     0     0     0     0     0     1; ...
     0     0     0     0     1     0     0     0     0     0     0; ...
     1     0     0     0     0     0     0     0     1     0     0; ...
     0     0     0     0     0     0     0     0     0     0     0; ...
     0     0     0     0     0     0     0     0     0     0     0]

gammacc = ...
[    0     0     0     0     0     0     0     0     0     0     0; ...
     0     0     0     0     0     0     0     0     0     0     0; ...
     0     0     0     0     1     0     0     0     0     0     0; ...
     0     0     0     0     1     0     0     0     0     0     0; ...
     0     0     0     0     0     0     0     0     0     0     0; ...
     0     0     0     0     0     0     0     0     0     0     0; ...
     0     0     0     0     0     0     0     0     0     0     1; ...
     0     0     0     0     1     0     0     0     0     0     0; ...
     1     0     0     0     0     0     0     0     0     0     0; ...
     0     0     0     0     0     0     0     0     0     0     0; ...
     0     0     0     0     0     0     0     0     0     0     0]


lfc = ...
[     1     1     1     1     1     0     0     1     0     1     1; ...
     1     1     0     0     0     0     0     0     0     1     1; ...
     0     0     1     1     0     1     1     0     0     0     0; ...
     1     1     1     1     1     0     1     0     0     0     0; ...
     0     0     0     0     1     0     0     0     0     0     0; ... 
     0     0     0     0     1     1     1     0     0     0     0; ...
     0     0     0     1     0     1     1     1     0     1     0; ...
     1     1     1     0     1     0     0     1     1     1     0; ...
     1     1     1     1     0     1     1     1     1     1     0; ... 
     1     1     1     0     1     1     1     1     1     1     0; ...
     1     0     1     0     0     0     0     0     0     1     1]

lfcc = ...
[    0     1     1     1     1     0     0     1     0     1     1; ...
     1     0     0     0     0     0     0     0     0     1     1; ...
     0     0     0     1     0     1     1     0     0     0     0; ...
     1     1     1     0     1     0     1     0     0     0     0; ...
     0     0     0     0     0     0     0     0     0     0     0; ... 
     0     0     0     0     1     0     1     0     0     0     0; ...
     0     0     0     1     0     1     0     1     0     1     0; ...
     1     1     1     0     1     0     0     0     1     1     0; ...
     1     1     1     1     0     1     1     1     0     1     0; ... 
     1     1     1     0     1     1     1     1     1     0     0; ...
     1     0     1     0     0     0     0     0     0     1     0]



X=1;
h=figure;
for Y = 1:5:55

	sourcefile = ['/home/jona/gamma/',num2str((X),'%01i'),'c.mat'];

	load(sourcefile)

	S = whos('-file',sourcefile);

	for P = 1:4														% find the ERSP data (which have varying names)
	content_sizes(P) = S(P).bytes;
	end;
	[R,F] = max(content_sizes);
	allersp = eval(S(F).name);
	clear S(F).name;

	sbplot(3,20,Y:Y+2);
	tftopo(allersp,times,freqs,'mode','ave','limits', [nan nan nan nan -2.5 2.5], 'timefreqs', [times(all_max_coordinates_gamma(X,2)) freqs(all_max_coordinates_gamma(X,1));  times(all_max_coordinates_theta(X,2)) freqs(all_max_coordinates_theta(X,1)); times(all_max_coordinates_alpha(X,2)) freqs(all_max_coordinates_alpha(X,1));], 'chanlocs', chanlocs,'smooth',1.5,'style','map','electrodes','off','cbar','off');

	sbplot(3,20,Y+3);
	barh([10 10],'FaceColor','w','EdgeColor','w')
	hold on;

	barh([mean(lfc(1:10,X))*10 0],'FaceColor',[0.5,0.5,0.9],'EdgeColor','b')
	hold on;
	barh([mean(lfcc(1:10,X))*10 0],'b')
	hold on;
	barh([0 mean(gammac(1:10,X))*10],'FaceColor',[0.9,0.5,0.5],'EdgeColor','r')
	hold on;
	barh([0 mean(gammacc(1:10,X))*10],'r')


	%ylabel(gca,'Alignment')
	set(gca,'YTick',[1 2])
	set(gca,'YTickLabel',{'<12 hz','>30 hz'})
	
	X = X+1;


end;

%set(h,'Resize','off')
%set(h,'Position',[200 200 3200 2400]);print -depsc gammaall.eps;


