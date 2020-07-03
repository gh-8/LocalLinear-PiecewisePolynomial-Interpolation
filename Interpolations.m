%% Weather approximation

%%              Data
temp_even= [9.2, 9.0, 6.8, 5.9, 7.2, 9.2, 10.9, 10.6, 10.3, 8.2, 8.8, 7.5];
temp_odd= [9.6, 7.7, 6.0, 4.3, 8.9, 10.2, 10.6, 10.7, 8.6, 8.0, 7.1, 7.5];
time_even=[0:2:22];
time_odd=[1:2:23];
time_Total=[time_even;time_odd];
time_Total=time_Total(:)';
P = polyfit(time_even,temp_even,1);
Pnew= polyval(P, time_Total);

int_Todd = polyval(P, [1:2:23]);
MSE = sum((int_Todd - temp_odd).^2)/length(temp_odd);
temp_all= [temp_even; temp_odd];
temp_all=temp_all(:)';
int_T= [temp_even;int_Todd];
int_T= int_T(:)';

figure, plot(temp_all, 'b');
hold on
plot(int_T, 'R');
plot(Pnew,'G');
xlabel('Time(h)')
ylabel('Temperature (C)')
hold off
%The interpolated values at all odd times are equal to that in the
%original curve.

%The straight line is inaccurate because it doesnt follow the path of the curve 

%%               MSE
MSE2= zeros(1,9);
for N=1:9
    P = polyfit(time_even,temp_even,N);
    int_Todd= polyval(P, [1:2:23]);
    MSE2(N) = sum((int_Todd - temp_odd).^2)/length(temp_odd);
end


figure, plot(1:9, MSE2,'g')
xlabel('Polynomial Degree')
ylabel('MSE')
%The Curve starts by decreasing till 6, and increase till 9

%The 6th degree has the lowest MSE at 0.9627

%%              This
int_Todd=temp_even;
int_T2= [temp_even;int_Todd];
int_T2=int_T2(:)';
MSE3= sum((int_Todd - temp_odd).^2)/length(temp_odd);

figure, plot(time_Total,temp_all, 'b')
hold on
plot(time_Total,int_T2,'r')
hold off
xlabel('Time(h)')
ylabel('Temperature (C)')
%This is the second lowest MSE. The lowest is still the 6 degree
%polynomial from above

%2) The curve is more accurate than before but still not a good enough
%approximation
%%               local linear interpolation
for N=1:12
        if N==12
        int_Todd2(N)= temp_even(N);
        else
        int_Todd2(N)= (temp_even(N)+ temp_even(N+1))/2;
        end
end
MSE4= sum((int_Todd2 - temp_odd).^2)/length(temp_odd);
int_T3=[temp_even; int_Todd2];
int_T3= int_T3(:)';

figure, plot(0:23, temp_all,'b')
hold on
plot(time_Total, int_T3,'r')
hold off
xlabel('Time(h)')
ylabel('Temperature (C)')
%This is the lowest MSE

%The curve is much more closer in shape to the Original Curve.
%%               piecewise polynomial interpolation special case the cubic spline
int_Todd3= spline(time_even, temp_even, time_odd);
int_Todd3(12)=temp_even(12);
MSE5= sum((int_Todd3 - temp_odd).^2)/length(temp_odd);
int_T4=[temp_even; int_Todd3];
int_T4= int_T4(:)';

figure, plot(time_Total, temp_all,'b')
hold on
plot(time_Total, int_T4,'r')
hold off
xlabel('Time(h)')
ylabel('Temperature (C)')
%1) piecewise polynomial interpolation spline has the second Lowest MSE overall
%2) local linear interpolation has the lowest MSE, therefore is the better approximation. The
%curve looks more accurate than piecewise polynomial interpolation cubic spline
