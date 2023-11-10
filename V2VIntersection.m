%Plot Parameter Setup
rx1 = 50;
ry1 = -500:1:500;
ry1(445:555) = -2000;
rx2 = -50;
ry2 = -500:1:500;
ry2(445:555) = -2000;
rx3 = -500:1:500;
ry3 = 50;
rx3(445:555) = -2000;
rx4 = -500:1:500;
ry4 = -50;
rx4(445:555) = -2000;

carNSpos = 400;
carEWpos = -450;

%Starting Plot
h1 = plot(rx1, ry1, 'k|');
hold on 
h2 = plot(rx2, ry2, 'k|');
h3 = plot(rx3, ry3, 'k_');
h4 = plot(rx4, ry4, 'k_');
h5 = plot(0, carNSpos, 'g*');
h6 = plot(carEWpos, 0, 'b*');
xlim([-500 500])
ylim([-500 500])

while carNSpos > -501 || carEWpos < 501
    carNSpos = carNSpos - 10;
    carEWpos = carEWpos + 10;

    % Update 'g*' and 'b*' points directly
    set(h5, 'XData', 0, 'YData', carNSpos);
    set(h6, 'XData', carEWpos, 'YData', 0);

    pause(0.1);
end