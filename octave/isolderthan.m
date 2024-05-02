function tf = isolderthan(a, b)
	astat = stat(a);
	bstat = stat(b);
	tf = astat.mtime < bstat.mtime;
end
