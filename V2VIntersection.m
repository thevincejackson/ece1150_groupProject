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

%Positions, Speed Limimts, Speeds, and Accellerations
speedLimitNS = -35;
speedLimitEW = 35;
speedCarNS = 10;
speedCarEW = 10;
accCarNS = -3;
accCarEW = 3;
maxAcc = 3.5;
maxDec = 4.5;
frequency = 10;
timePerCycle = 1/frequency;
maxRange = 300;

%Initializing blank delay array
delay = [];
signalSpeed = 3e8;
count = 1;


while carNSpos > -501 || carEWpos < 501
    %See if cars within communication range and determine what to do
    if sqrt(carNSpos^2 + carEWpos^2) < 300
        delay(count) = sqrt(carNSpos^2 + carEWpos^2)/signalSpeed;
    else
        delay(count) = 0;
    end
    
    %Update Position
    carNSpos = carNSpos + speedCarNS * timePerCycle + accCarNS * timePerCycle^2;
    carEWpos = carEWpos + speedCarEW * timePerCycle + accCarEW * timePerCycle^2;

    %Update Velocity
    speedCarNS = speedCarNS + accCarNS * timePerCycle;
    speedCarEW = speedCarEW + accCarEW * timePerCycle;
    if(speedCarNS > speedLimitNS)
        speedCarNS = speedLimitNS;
        accCarNS = 0;
    end
    if(speedCarEW > speedLimitEW)
        speedCarEW = speedLimitEW;
        accCarEW = 0;
    end
    

    % Update 'g*' and 'b*' points directly
    set(h5, 'XData', 0, 'YData', carNSpos);
    set(h6, 'XData', carEWpos, 'YData', 0);
    
    count = count + 1;
    pause(timePerCycle/100)
end

x = 1:1:length(delay);
dist = 1:1:length(delay);
for i = 1:length(delay)
    dist(i) = delay(i) * signalSpeed;
end
hold off

x = x./10;
delay = delay .* 1e9;
xlim([0 max(x)])
yyaxis left  % Plot delay on the left axis
plot(x, delay)
ylabel('Delay (ns)')

yyaxis right  % Plot distance on the right axis
plot(x, dist, 'k')
ylabel('Distance (m)')
ax = gca;
ax.YColor = 'k';

xlabel('Time (s)')
legend('Delay', 'Distance')


