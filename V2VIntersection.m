%{
Simaulation notes
*****************
Units are in m, m/s, m/s^2 for distance, speed, and accelleration

Grid is 500m by 500m 

We are assuming no interference or noise from outside signals, buildings,
etc.

Cars initial position, speed, and acceleration can be modified to simulate
different initial states.

Speed can not exceed speed limit for safety controls of an automated
car, but can also be modified to simulate different roads (Neighborhood VS
Highway)

Max Accelleration/Decelleration uses estimates found online for the average car given
good tires
%}


clear
close all

%Plot Parameter Setup
rx1 = 25;
ry1 = -500:1:500;
ry1(475:525) = -2000;
rx2 = -25;
ry2 = -500:1:500;
ry2(475:525) = -2000;
rx3 = -500:1:500;
ry3 = 25;
rx3(475:525) = -2000;
rx4 = -500:1:500;
ry4 = -25;
rx4(475:525) = -2000;

carNSpos = 400;
carEWpos = -450;
carNSposPrev = 0;
carEWposPrev = 0;

%Starting Plot
h1 = plot(rx1, ry1, 'k|');
hold on 
h2 = plot(rx2, ry2, 'k|');
h3 = plot(rx3, ry3, 'k_');
h4 = plot(rx4, ry4, 'k_');
h5 = plot(-10, carNSpos, 'g*');
h6 = plot(carEWpos, -10, 'b*');
xlim([-500 500])
ylim([-500 500])
xrange = 500;
yrange = 500;

%Positions, Speed Limimts, Speeds, and Accellerations
speedLimitNS = -25;
speedLimitEW = 25;
speedCarNS = -15;
speedCarEW = 15;
speedCarNSPrev = 0;
speedCarEWPrev = 0;
accCarNSPrev = 0;
accCarEWPrev = 0;
accCarNS = -3;
accCarEW = 3;
maxAcc = 3;
maxDec = 4;
frequency = 10;
timePerCycle = 1/frequency;
maxRange = 300;
carInRangePrev = false;
carSignalsRec = 0;
delay = 0;


%Initializing blank data array
data = [];
signalSpeed = 3e8;
count = 1;

while carNSpos > -301 || carEWpos < 301 
    %See if cars within communication range and determine what to do
    if (sqrt((carNSpos - 10)^2 + (-10 - carEWpos)^2) < maxRange)
        delay = sqrt((carNSpos - 10)^2 + (-10 - carEWpos)^2) /signalSpeed;
    else
        delay = 0;
    end
    
    %Updating Position from previous info (will factor in signal if it is
    %received below
    carNSposPrev = carNSpos;
    carEWposPrev = carEWpos;
    carNSpos = carNSpos + speedCarNS * timePerCycle + accCarNS * timePerCycle^2;
    carEWpos = carEWpos + speedCarEW * timePerCycle + accCarEW * timePerCycle^2;
    
    %Updating Velocity from previous info (will factor in signal if it is
    %received below
    speedCarNSPrev = speedCarNS;
    speedCarEWPrev = speedCarEW;
    speedCarNS = speedCarNS + accCarNS * timePerCycle;
    speedCarEW = speedCarEW + accCarEW * timePerCycle;
    if(speedCarNS < speedLimitNS)
        speedCarNS = speedLimitNS;
    end
    if(speedCarEW > speedLimitEW)
        speedCarEW = speedLimitEW;
    end

    if(sqrt(carNSpos^2 + carEWpos^2) < maxRange)
        if(carInRangePrev)
            carSignalsRec = carSignalsRec + 1;
            carSignalRecieved = true;
            [accCarNS, accCarEW] = findActions(carNSpos, carEWpos, carNSposPrev, carEWposPrev, speedCarNS, speedCarEW, speedCarNSPrev, speedCarEWPrev, speedLimitNS, speedLimitEW);
        else
            carInRangePrev = true;
            carSignalRecieved = false;
            %car NS acting on own
            if(speedCarNS <= speedLimitNS)
                accCarNS = 0;
            else
                accCarNS = -3;
            end
            %Car EW acting on own
            if(speedCarEW >= speedLimitEW)
                accCarEW = 0;
            else
                accCarEW = 3;
            end
        end
    else
        carSignalRecieved = false;
        %car NS acting on own
        if(speedCarNS <= speedLimitNS)
            accCarNS = 0;
        else
            accCarNS = -3;
        end
        %Car EW acting on own
        if(speedCarEW >= speedLimitEW)
            accCarEW = 0;
        else
            accCarEW = 3;
        end
    end

    % Update 'g*' and 'b*' points directly
    set(h5, 'XData', -10, 'YData', carNSpos);
    set(h6, 'XData', carEWpos, 'YData', -10);
    
    if(round(carNSpos / 100) * 100 < yrange - 100)
        yrange = abs(round(carNSpos / 100)) * 100 + 100;
        if(yrange > 200)
            ylim([-yrange, yrange]);
        else
            yrange = 200;
            ylim([-yrange, yrange]);
        end
        
    end
    if(round(carEWpos / 100) * 100 < xrange - 100)
        xrange = abs(round(carEWpos / 100)) * 100 + 100;
        if(xrange >= 200 && xrange <= 500)
            xlim([-xrange, xrange]);
        elseif(xrange < 200)
            xrange = 200;
            xlim([-xrange, xrange]);
        elseif(xrange > 500)
            xrange = 500;
            xlim([-xrange, xrange]);
        end
    end
    data = [data,  [delay, carNSpos, carEWpos, abs(speedCarNS), speedCarEW, accCarNS, accCarEW, carSignalRecieved,]'];
    count = count + 1;
    pause(timePerCycle/100)
end

%Making final graphs
delayAll = data(1,:);
carNSposAll = data(2,:);
carEWposAll = data(3,:);
speedCarNSAll = data(4,:);
speedCarEWAll = data (5,:);
accCarNSAll = data(6,:);
accCarEWAll = data(7,:);
signalRecievedAll = data(8,:);



x = 1:1:length(delayAll);
dist = 1:1:length(delayAll);
for i = 1:length(delayAll)
    dist(i) = delayAll(i) * signalSpeed;
end

%Delay Graph
hold off
x = x./10;
delayAll = delayAll .* 1e9;
xlim([0 max(x)])
yyaxis left  % Plot delay on the left axis
plot(x, delayAll)
ylabel('Delay (ns)')

yyaxis right  % Plot distance on the right axis
plot(x, dist, 'k')
ylabel('Distance (m)')
ax = gca;
ax.YColor = 'k';

xlabel('Time (s)')

%NS Car Graphs
figure;
xlim([0 max(x)])
plot(x, carNSposAll, 'k')
ylabel('Pos (m)')
xlabel('Time (s)')
title('NS Car Position VS. Time')

figure;
xlim([0 max(x)])
plot(x, speedCarNSAll, 'k')
ylabel('Speed (m/s)')
xlabel('Time (s)')
title('NS Car Speed VS. Time')

figure;
xlim([0 max(x)])
plot(x, accCarNSAll, 'k')
ylabel('Acc (m/s^2)')
xlabel('Time (s)')
title('NS Car Acceleration VS. Time')

%EW Car Graphs
figure;
xlim([0 max(x)])
plot(x, carEWposAll, 'k')
ylabel('Pos (m)')
xlabel('Time (s)')
title('EW Car Position VS. Time')

figure;
xlim([0 max(x)])
plot(x, speedCarEWAll, 'k')
ylabel('Speed (m/s)')
xlabel('Time (s)')
title('EW Car Speed VS. Time')

figure;
xlim([0 max(x)])
plot(x, accCarEWAll, 'k')
ylabel('Acc (m/s^2)')
xlabel('Time (s)')
title('EW Car Acceleration VS. Time')

figure;
xlim([0 max(x)])
plot(x, signalRecievedAll, 'k')
ylabel('T/F')
xlabel('Time (s)')
title('Communication Between Cars')