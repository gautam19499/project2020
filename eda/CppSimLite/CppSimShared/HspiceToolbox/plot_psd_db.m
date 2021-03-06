% Plot expressions invoking signal names from structure x.
% Usage: plot_psd_db(x, exp) or plot_psd_db(x, exp, plot_args)
%        where plot_args is 'logx', 'logy', or 'logxy'.
% In exp, commas delimit curves to be overlayed and semicolons delimit
% seperate subplots on the same figure.  E.g., plotsig(x,'v1,v2;v3')
% creates two subplots, with voltages v1 and v2 overlayed.  Also note
% that numeric node names should be prepended by '@' to distinguish
% them from constants.
%  written by Mike Perrott with modifications by Scott Willingham

function [] = plot_psd_db(x,exp,plot_args)

clf;
delim_m = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789@+-/*^().:';

nsp = 1 + sum(exp == ';');	% number of subplots

r = exp;

%% separate curves by '?' to avoid confusion with function arg delimiters
net_paren = 0;
for i=1:length(r)
   if r(i) == '('
      net_paren = net_paren+1;
   elseif r(i) == ')'
      net_paren = net_paren-1;
   elseif r(i) == ','
      if net_paren == 0
        r(i) = '?';
      end
   end
end

for i = 1:nsp
    subplot(nsp,1,i);
    cplot = [];
    [t,r] = strtok(r,';');
    while length(t) > 0
	[s,t] = strtok(t,'?');
	if length(s) > 0
            if isempty(cplot)
               cplot = cellstr(s);
            else
	       cplot = [cplot, cellstr(s)];
            end
	end
	[s,t] = strtok(t,delim_m);
    end
    if nargin > 2
	plot_psd_db1(x,cplot,plot_args);
    else
	plot_psd_db1(x,cplot);
    end
    if i == 1
       title('One-Sided Power Spectral Density 10log(V^2/Hz) or 10log(A^2/Hz)')
    end
end

xlabel('Frequency (Hz)');

if (exist('zoom'))
   zoom on
end
