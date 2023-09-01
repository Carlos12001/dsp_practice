function practice_09
    % PRACTICE_09
    
    clc;
    clearvars;
    close all;
    clear all;
    % Problem 1
    pkg load signal;
    printf("Welcome to practice 9\n");
    
    % Problem 2
    [audio_data, Fs] = audioread('audio.wav');
    % Play the perfect vocal
    player = audioplayer(audio_data, Fs);
    playblocking(player);

    % Fs = 44100;  % frequency sampling Hz
    % duration = 2;  % record duration seconds
    % recorder = audiorecorder(Fs, 16, 1);
    % display("Start speaking.");
    % recordblocking(recorder, duration);
    % display("End of recording.");
    % audio_data = getaudiodata(recorder);


    % Problem 3
    [corr_audio, lag_audio] = xcorr(audio_data);
    index_lag = find(lag_audio == 0);
    cutter = 1000;
    corr_audio = corr_audio(index_lag-cutter:index_lag+cutter);
    lag_audio = lag_audio(index_lag-cutter:index_lag+cutter); 
    [~, lss] = findpeaks(corr_audio,"DoubleSided","MinPeakHeight",
                        max(corr_audio)*0.5); 
    T = lss(2)-lss(1);
    printf("The period of the audio is %d s\n", T);

    figure("Name", "Autocorrelation of audio signal");
    plot(lag_audio, corr_audio);
    set_plot_style("Autocorrelation of audio signal", "t", "r_{aa}[n]");

    % Extracting one period around the middle of the audio signal
    middle_index = floor(length(audio_data)/2);
    extracted_period = audio_data(middle_index - floor(T/2) : middle_index + floor(T/2) - 1);

    % Problem 4
    % Determine how many times we should replicate the period to get 1 or 2 seconds
    num_repeats = round(2 * Fs / T);  % This is for 2 seconds. Change 2 to 1 if you want 1 second.

    % Replicate the extracted period
    perfect_vocal = repmat(extracted_period, [num_repeats, 1]);

    % Play the perfect vocal
    player = audioplayer(perfect_vocal, Fs);
    playblocking(player);

    % Problem 5
    DFT_coeff = fft(extracted_period);

    % Problem 6
    magnitudes = abs(DFT_coeff);
    phases = angle(DFT_coeff);

    figure("name", "Magnitudes and Phases of DFT Coefficients");
    subplot(2, 1, 1);
    plot(magnitudes);
    set_plot_style("Magnitude Spectrum", "Frequency (k)", "Magnitude");

    subplot(2, 1, 2);
    plot(phases);
    set_plot_style("Phase Spectrum", "Frequency (k)", "Phase (rad)");


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
