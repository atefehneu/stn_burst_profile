%% init
% dummy matrix
% pd = makedist('Normal');
% dumm = random(pd, [6, 100]);

data_dbs_amp = [test.VarName2';
    f020.VarName2';
    f060.VarName2';
    f100.VarName2';
    f140.VarName2';
    f180.VarName2';
    f220.VarName2';
    f260.VarName2'];

data_dbs_f = [test.VarName2';
    f20.VarName2';
    f60.VarName2';
    f100.VarName2';
    f140.VarName2';
    f180.VarName2';
    f220.VarName2';
    f260.VarName2'];

data_dbs_dur = [test.VarName2';
    dur06.VarName2';
    dur08.VarName2';
    dur10.VarName2';
    dur12.VarName2';
    dur14.VarName2';
    dur16.VarName2';
    dur18.VarName2'];
%%
% figure template
figure

rows = 8;
cols = 3;

data = data_dbs_amp;
time = nondbs.VarName1';

row_ = 0;
for sub_ = 1:rows*cols

    % set col_
    col_ = mod(sub_ - 1, cols) + 1;
    %col_ = mod(sub_, cols);  % note that the col_=0 is for the last column
    % set row_
    if col_ == 1
        row_ = row_ + 1;
    end

    data_ = data(row_, :);

    if col_ == 1
        % hist
        ax = subplot(rows, cols, sub_);
        % dur_find
        ind_thres = find(data_ > -65.2 & data_ < -64.8);
        ind_diff = ind_thres - circshift(ind_thres, -1);
        ind_ = find(abs(ind_diff(1:end)) > 350);
        dur = [];
        ind_ = [0; ind_'];
        for i=1:length(ind_) - 1
            dur = [dur, ind_thres(ind_(i+1)) - ind_thres(ind_(i) + 1)];
        end
        dur_t = 0.4*dur;
        binEdges = 0:100:2100;
        histogram(dur_t,binEdges);
        %
        ax.XLim = [0, 1100];
        ax.YLim = [0, 50];
        ax.XColor = 'black';
        ax.YColor = 'black';
        ax.ZColor = 'black';
        ax.GridColor = 'black';
        ax.MinorGridColor = 'black';
        % ax.Position = [ax.Position(1) ax.Position(2), 0.10, 0.10];
        %
        if row_ == 1
            % ax.Title.String = 'A';
            % ax.Title.FontSize = 12;
            % ax.Title.FontWeight = 'bold';
            % ax.TitleHorizontalAlignment = 'left';
        elseif row_ == 4
            ax.YLabel.String = 'Number of bursts';
            ax.YLabel.FontSize = 12;
            ax.YLabel.FontWeight = 'bold';
        elseif row_ == 8
            ax.XLabel.String = 'Burst Duration (ms)';
            ax.XLabel.FontSize = 12;
            ax.XLabel.FontWeight = 'bold';
        end

    elseif col_ == 2
        % psd
        ax = subplot(rows, cols, sub_);
        % psd
        y = data_;
        x = (y - mean(y)) / std(y);
        Ts = 0.0004;
        fs = 1/Ts;
        Nx = length(x);
        nsc = floor(Nx/10);
        nov = floor(0.9*nsc);
        nff = max(256,2^nextpow2(nsc));
        [pxx,f] = pwelch(x,hamming(nsc),nov,nff,fs,...
            'ConfidenceLevel',0.95);
        plot(ax,f,pxx*100)
        %
        ax.XLim = [13, 25];
        ax.YLim = [0, 15];
        ax.XColor = 'black';
        ax.YColor = 'black';
        ax.ZColor = 'black';
        ax.GridColor = 'black';
        ax.MinorGridColor = 'black';
        %
        if row_ == 1
            % ax.Title.String = 'B';
            % ax.Title.FontSize = 12;
            % ax.Title.FontWeight = 'bold';
            % ax.TitleHorizontalAlignment = 'left';
        elseif row_ == 4
            ax.YLabel.String = 'PSD (dB/Hz)';
            ax.YLabel.FontSize = 12;
            ax.YLabel.FontWeight = 'bold';
        elseif row_ == 8
            ax.XLabel.String = 'Frequency (Hz)';
            ax.XLabel.FontSize = 12;
            ax.XLabel.FontWeight = 'bold';
        end

    elseif col_ == 3
        % series
        ax = subplot(rows, cols, sub_);
        plot(ax, time, data_)
        ax.XLim = [1000, 6000];
        ax.YLim = [-90, 50];
        ax.XColor = 'black';
        ax.YColor = 'black';
        ax.ZColor = 'black';
        ax.GridColor = 'black';
        ax.MinorGridColor = 'black';
        %
        if row_ == 1
            % ax.Title.String = 'C';
            % ax.Title.FontSize = 12;
            % ax.Title.FontWeight = 'bold';
            % ax.TitleHorizontalAlignment = 'left';
        elseif row_ == 4
            ax.YLabel.String = 'Voltage (mV)';
            ax.YLabel.FontSize = 12;
            ax.YLabel.FontWeight = 'bold';
        elseif row_ == 8
            ax.XLabel.String = 'Time (ms)';
            ax.XLabel.FontSize = 12;
            ax.XLabel.FontWeight = 'bold';
        end

        % elseif col_ == 4
        %     % pass
        % elseif col_ == 0
        %     % pass
        % end

        % ax.FontSize = 12;
    end
end

