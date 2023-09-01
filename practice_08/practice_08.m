function practice_08
    pkg load signal;
    clear all;
    close all;
    clc;
    a = [1];
    b = [1 0.9 0.81];
    x = [1 zeros(1, 10)];
    y = filter(b, a, x);
    figure;
    plot(y);

end