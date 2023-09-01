function practice_06 
    % Problem 1 and Problem 2
    pkg load signal;
    pkg load audio;
    clear;
    clc;
    close all;
    
    % Problem 4
    M = 2500;
    r = randn(1, M)/2;

    figure("name","Random and Periodic Sequences, and their Correlations");
    subplot(3, 2, 1);
    stem(r(1:100));
    set_plot_style("Random Sequence", "n", "r[n]");

    % Problem 5
    N = 100/M;
    p = sin (2*pi*(1:M)*N);
    maximus = 25;

    subplot(3, 2, 2);
    stem(p(1:100));
    set_plot_style("Periodic Sequence", "n", "p[n]");

    % Problem 6
    [corr_rr, lag_rr] = xcorr(r);
    [corr_rp, lag_rp] = xcorr(r, p);
    [corr_pp, lag_pp] = xcorr(p);
    [corr_rprp, lag_rprp] = xcorr(r.+p);

    % Problem 7
    subplot(3, 2, 3);
    stem(lag_rr(M-maximus:M+maximus),corr_rr(M-maximus:M+maximus));
    set_plot_style("Autocorrelation of r[n]", "n", "r_{rr}[n]");
    subplot(3, 2, 5);
    stem(lag_rp(M-maximus:M+maximus),corr_rp(M-maximus:M+maximus));
    set_plot_style("Crosscorrelation of r[n] and p[n]", "n", "r_{rp}[n]");
    subplot(3, 2, 4);
    stem(lag_pp(M-maximus:M+maximus),corr_pp(M-maximus:M+maximus));
    set_plot_style("Autocorrelation of p[n]", "n", "r_{pp}[n]");
    subplot(3, 2, 6);
    stem(lag_rprp(M-maximus:M+maximus),corr_rprp(M-maximus:M+maximus));
    set_plot_style("Autocorrelation of r[n]+p[n]", "n", "r_{r+p}[n]");

    % El inidice está en la posición M del vector, porque el vector
    % empieza la posicion 1 y tiene 2*M-1 elementos, por lo que el
    % la posicion de 0 es M.

    % Problem 8
    Fs = 44100;  % frequency sampling Hz
    duration = 2;  % record duration seconds
    recorder = audiorecorder(Fs, 16, 1);
    display("Start speaking.");
    recordblocking(recorder, duration);
    display("End of recording.");
    audio_data = getaudiodata(recorder);
    audiowrite('myRecording.wav', audio_data, Fs);

    % Problem 9
    [corr_audio, lag_audio] = xcorr(audio_data);
    index_lag = find(lag_audio == 0);
    cutter = 1000;
    corr_audio = corr_audio(index_lag:index_lag+cutter);
    lag_audio = lag_audio(index_lag:index_lag+cutter);  

    figure("name","Autocorrelation of audio");
    stem(lag_audio, corr_audio);
    set_plot_style("Autocorrelation of audio", "n", "r_{audio}[n]");
    player = audioplayer(audio_data, Fs);
    playblocking(player);

    % Problem 10
    [~, lss] = findpeaks(corr_audio,"DoubleSided","MinPeakHeight",
                        max(corr_audio)*0.6);
    T = lss(2)-lss(1);
    printf("The period of the audio is %d s\n", T);

end

function set_plot_style(title_str = "", x_label = "n", y_label = "y[n]")
    %SET_PLOT_STYLE Sets a standardized style for plots.
    %
    %   set_plot_style() applies a standardized style to the current plot, 
    %   including enabling the grid, setting a default font size, and 
    %   configuring the x and y labels. An optional title string can be 
    %   provided, which will be interpreted in TeX format.
    %
    %   Syntax:
    %       set_plot_style(title_str)
    %
    %   Input:
    %       title_str - (Optional) A string specifying the title of the plot. 
    %                   Default is an empty string.
    %
    %   Example:
    %       plot(1:10, sin(1:10));
    %       set_plot_style("Sine Wave");
    %
    grid on;
    set(gca, "FontSize", 24);
    title(title_str, "interpreter", 
    "tex");
    xlabel(x_label, "FontSize", 24);
    ylabel(y_label, "FontSize", 24);
end