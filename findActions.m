function [accNS, accEW] = findActions(carNSpos, carEWpos, carNSposPrev, carEWposPrev, speedCarNS, speedCarEW, speedCarNSPrev, speedCarEWPrev, speedLimitNS, speedLimitEW)
    %{
    NS car Acc Calculation
    %If self is past intersection go max speed
    if(carNSpos < -25)
        if(abs(speedCarNS) >= abs(speedLimitNS))
            accNS = 0;
        else
            accNS = -3;
        end
    %If other is past intersection go max speed
    elseif (carEWposPrev > 25)
       if(abs(speedCarNS) >= abs(speedLimitNS))
           accNS = 0;
       else
           accNS = -3;
       end
    %If neither to intersection yet
    elseif ((carNSpos > 25) && (carEWposPrev < -25))
        %Distance to start of intersection
        distNS = carNSpos - 25;
        distEW = -25 - carEWposPrev;

        %given current speed find how fast would have to slow down to stop
        %before intersection
        accNeededToStopAtLightNS = -(speedCarNS^2)/(2*distNS);
        accNeededToStopAtLightEW = -(speedCarEWPrev^2)/(2*distEW);

        %If both going too fast to stop before the intersection make one
        %who would have to deccellerate more go through and slow other
        %one as much as possible
        if(abs(accNeededToStopAtLightNS) > 4 && abs(accNeededToStopAtLightEW) > 4)
            if(abs(accNeededToStopAtLightNS) > abs(accNeededToStopAtLightEW))
               if(abs(speedCarNS) >= abs(speedLimitNS))
                   accNS = 0;
               else
                   accNS = -3;
               end
            else
                accNS = 4;
            end
        %If only NS car can slow down make it slow down but make it get to
        %the intersection at max possible speed
        elseif(abs(accNeededToStopAtLightEW) > 4)
            %If going max speed easy calculation
            %distNS = distNS - 10;
            if(speedCarEWPrev >= speedLimitEW)
                timeIntEW = (distEW + 50)/speedLimitEW;
                %accNS = (distNS - abs(speedCarNS) * timeIntEW)/(0.5 * timeIntEW^2);
                vf = ((2*distNS)/timeIntEW) - abs(speedCarNS);
                accNS = ((vf)^2 - speedCarNS^2)/(2*distNS);
            else
                %Conservative time estimate
                timeIntEW = (distEW + 50)/(0.5*(speedLimitEW + speedCarEWPrev));
                accNS = (distNS - speedCarNS * timeIntEW)/(0.5 * timeIntEW^2);
            end
        %If only NS car can't slow down go max speed through
        else
           if(speedCarNS >= speedLimitNS)
               accNS = 0;
           else
               accNS = -3;
           end
        end
    %If both in intersection we max speed and hope for best (prior
    %communication works toward this goal)
    elseif ((carNSpos <= 25) && (carNSpos >= -25) && (carEWposPrev >= -25) && (carEWposPrev <= 25))
       if(speedCarNS >= speedLimitNS)
           accNS = 0;
       else
           accNS = -3;
       end
    %Just NS in intersection max speed to get through asap
    elseif ((carNSpos <= 25) && (carNSpos >= -25) && (carEWposPrev < -25))
       if(speedCarNS >= speedLimitNS)
           accNS = 0;
       else
           accNS = -3;
       end
    %Just EW in intersection get to intersection with max possible speed
    %without entering early
    elseif ((carEWposPrev >= -25) && (carEWposPrev <= 25) && carNSpos > 25)
        if(carEWposPrev <= 0)
            distEW = abs(carEWposPrev) + 25;
        else
            distEW = 25 - carEWposPrev;
        end
        distNS = carNSpos + 35;
        %If EW going max speed easy calculation
        if(speedCarEWPrev >= speedLimitEW)
            timeIntEW = (distEW)/speedLimitEW;
            accNS = (distNS - abs(speedCarNS) * timeIntEW)/(0.5 * timeIntEW^2);
        else
            %Conservative time estimate
            timeIntEW = (distEW)/(0.5*(speedLimitEW + speedCarEWPrev));
            accNS = (distNS - abs(speedCarNS) * timeIntEW)/(0.5 * timeIntEW^2);
        end
    end
    %}
    
    
    %NS car Acc Calculation
    %If other is past intersection go max speed
    if(carEWposPrev > 25)
       if(abs(speedCarNS) >= abs(speedLimitNS))
           accNS = 0;
       else
           accNS = -3;
       end
    %If self is past intersection go max speed
    elseif (carNSpos < -25)
       if(abs(speedCarNS) >= abs(speedLimitNS))
           accNS = 0;
       else
           accNS = -3;
       end
    %If neither to intersection yet
    elseif ((carNSpos > 25) && (carEWposPrev < -25))
        %Distance to start of intersection
        distNS = carNSpos - 25;
        distEW = -25 - carEWposPrev;

        %given current speed find how fast would have to slow down to stop
        %before intersection
        accNeededToStopAtLightNS = -(speedCarNS^2)/(2*distNS);
        accNeededToStopAtLightEW = -(speedCarEWPrev^2)/(2*distEW);

        %If both going to fast to stop before the intersection make one
        %who would have to deccellerate more go through and slow other
        %one as much as possible
        if(abs(accNeededToStopAtLightNS) > 4 && abs(accNeededToStopAtLightEW) > 4)
            if(abs(accNeededToStopAtLightEW) > abs(accNeededToStopAtLightNS))
               accNS = 4;
            else
               if(abs(speedCarNS) >= abs(speedLimitNS))
                   accNS = 0;
               else
                   accNS = -3;
               end
            end
        %If only NS car can slow down make it slow down but make it get to
        %the intersection at max possible speed
        elseif(abs(accNeededToStopAtLightEW) > 4)
            %If going max speed easy calculation
            distNS = distNS - 10;
            if(speedCarEWPrev >= speedLimitEW)
                timeIntEW = (distEW + 60)/abs(speedLimitNS);
                accNS = (distNS - abs(speedCarNS) * timeIntEW)/(0.5 * timeIntEW^2);
            else
                %Conservative time estimate
                timeIntEW = (distEW + 60)/(0.5*(speedLimitEW) + (speedCarEWPrev));
                accNS = (distNS - abs(speedCarNS) * timeIntEW)/(0.5 * timeIntEW^2);
            end
        %If only NS car can't slow down go max speed through
        elseif(abs(accNeededToStopAtLightNS) > 4)
           if(abs(speedCarNS) >= abs(speedLimitNS))
               accNS = 0;
           else
               accNS = -3;
           end
        %Base command off of which one will arrive first
        else
           %harder for NS to stop
           if(abs(accNeededToStopAtLightEW) < abs(accNeededToStopAtLightNS))
               if(abs(speedCarNS) >= abs(speedLimitNS))
                   accNS = 0;
               else
                   accNS = -3;
               end
           else
               %If EW going max speed easy calculation
                if(abs(speedCarEWPrev) >= abs(speedLimitEW))
                    timeIntEW = (distEW + 60)/abs(speedLimitEW);
                    accNS = (distNS - abs(speedCarNS) * timeIntEW)/(0.5 * timeIntEW^2);
                else
                    %Conservative time estimate
                    timeIntEW = (distEW + 60)/(0.5*(abs(speedLimitEW) + abs(speedCarEWPrev)));
                    accNS = (distNS - abs(speedCarNS) * timeIntEW)/(0.5 * timeIntEW^2);
                end
           end
        end
    %If both in intersection we max speed and hope for best (prior
    %communication works toward this goal)
    elseif ((carEWposPrev <= 25) && (carEWposPrev >= -25) && (carNSpos >= -25) && (carNSpos <= 25))
       if(abs(speedCarNS) >= abs(speedLimitNS))
           accNS = 0;
       else
           accNS = -3;
       end
    %Just NS in intersection max speed to get through asap
    elseif ((carNSpos >= -25) && (carNSpos <= 25) && (carEWposPrev < -25))
       if(abs(speedCarNS) >= abs(speedLimitNS))
           accNS = 0;
       else
           accNS = -3;
       end
    %Just EW in intersection get to intersection with max possible speed
    %without entering early
    elseif ((carEWposPrev <= 25) && (carEWposPrev >= -25) && carNSpos > 25)
        if(carEWposPrev <= 0)
            distEW = abs(carEWposPrev) + 25;
        else
            distEW = 25 - carNSposPrev;
        end
        distNS = carNSpos - 35;
        %If NS going max speed easy calculation
        if(abs(speedCarEWPrev) >= abs(speedLimitEW))
            timeIntEW = (distEW)/abs(speedLimitEW);
            accNS = (distNS - speedCarNS * timeIntEW)/(0.5 * timeIntEW^2);
        else
            %Conservative time estimate
            timeIntEW = (distEW)/(0.5*(abs(speedLimitEW) + abs(speedCarEWPrev)));
            accEW = (distNS - speedCarNS * timeIntEW)/(0.5 * timeIntEW^2);
        end
    end



















    %EW car Acc Calculation
    %If other is past intersection go max speed
    if(carNSposPrev < -25)
       if(speedCarEW >= speedLimitEW)
           accEW = 0;
       else
           accEW = 3;
       end
    %If self is past intersection go max speed
    elseif (carEWpos > 25)
       if(speedCarEW >= speedLimitEW)
           accEW = 0;
       else
           accEW = 3;
       end
    %If neither to intersection yet
    elseif ((carNSposPrev > 25) && (carEWpos < -25))
        %Distance to start of intersection
        distNS = carNSposPrev - 25;
        distEW = -25 - carEWpos;

        %given current speed find how fast would have to slow down to stop
        %before intersection
        accNeededToStopAtLightNS = -(speedCarNSPrev^2)/(2*distNS);
        accNeededToStopAtLightEW = -(speedCarEW^2)/(2*distEW);

        %If both going to fast to stop before the intersection make one
        %who would have to deccellerate more go through and slow other
        %one as much as possible
        if(abs(accNeededToStopAtLightNS) > 4 && abs(accNeededToStopAtLightEW) > 4)
            if(abs(accNeededToStopAtLightNS) > abs(accNeededToStopAtLightEW))
               accEW = -4;
            else
               if(speedCarEW >= speedLimitEW)
                   accEW = 0;
               else
                   accEW = 3;
               end
            end
        %If only EW car can slow down make it slow down but make it get to
        %the intersection at max possible speed
        elseif(abs(accNeededToStopAtLightNS) > 4)
            %If going max speed easy calculation
            distEW = distEW - 10;
            if(abs(speedCarNSPrev) >= abs(speedLimitNS))
                timeIntNS = (distNS + 60)/abs(speedLimitNS);
                accEW = (distEW - speedCarEW * timeIntNS)/(0.5 * timeIntNS^2);
            else
                %Conservative time estimate
                timeIntNS = (distNS + 60)/(0.5*(abs(speedLimitNS) + abs(speedCarNSPrev)));
                accEW = (distEW - speedCarEW * timeIntNS)/(0.5 * timeIntNS^2);
            end
        %If only EW car can't slow down go max speed through
        elseif(abs(accNeededToStopAtLightEW) > 4)
           if(speedCarEW >= speedLimitEW)
               accEW = 0;
           else
               accEW = 3;
           end
        %Base command off of which one will arrive first
        else
           %harder for EW to stop
           if(abs(accNeededToStopAtLightNS) < abs(accNeededToStopAtLightEW))
               if(speedCarEW >= speedLimitEW)
                   accEW = 0;
               else
                   accEW = 3;
               end
           else
               %If NS going max speed easy calculation
                if(abs(speedCarNSPrev) >= abs(speedLimitNS))
                    timeIntNS = (distNS + 60)/abs(speedLimitNS);
                    accEW = (distEW - speedCarEW * timeIntNS)/(0.5 * timeIntNS^2);
                else
                    %Conservative time estimate
                    timeIntNS = (distNS + 60)/(0.5*(abs(speedLimitNS) + abs(speedCarNSPrev)));
                    accEW = (distEW - speedCarEW * timeIntNS)/(0.5 * timeIntNS^2);
                end
           end
        end
    %If both in intersection we max speed and hope for best (prior
    %communication works toward this goal)
    elseif ((carNSposPrev <= 25) && (carNSposPrev >= -25) && (carEWpos >= -25) && (carEWpos <= 25))
       if(speedCarEW >= speedLimitEW)
           accEW = 0;
       else
           accEW = 3;
       end
    %Just EW in intersection max speed to get through asap
    elseif ((carEWpos >= -25) && (carEWpos <= 25) && (carNSposPrev > 25))
       if(speedCarEW >= speedLimitEW)
           accEW = 0;
       else
           accEW = 3;
       end
    %Just NS in intersection get to intersection with max possible speed
    %without entering early
    elseif ((carNSposPrev <= 25) && (carNSposPrev >= -25) && carEWpos < -25)
        if(carNSposPrev >= 0)
            distNS = carNSposPrev + 25;
        else
            distNS = 25 - abs(carNSposPrev);
        end
        distEW = -35 - carEWpos;
        %If NS going max speed easy calculation
        if(abs(speedCarNSPrev) >= abs(speedLimitNS))
            timeIntNS = (distNS)/abs(speedLimitNS);
            accEW = (distEW - speedCarEW * timeIntNS)/(0.5 * timeIntNS^2);
        else
            %Conservative time estimate
            timeIntNS = (distNS)/(0.5*(abs(speedLimitNS) + abs(speedCarNSPrev)));
            accEW = (distEW - speedCarEW * timeIntNS)/(0.5 * timeIntNS^2);
        end
    end
    if(accEW > 3)
        accEW = 3;
    elseif(accEW < -4)
        accEW = -4;
    end
    if(accNS > 4)
        accNS = 4;
    elseif(accNS < -3)
        accNS = -3;
    end
end