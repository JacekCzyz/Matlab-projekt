clear all;
close all;


%wartosci nominalne
TzewN=-20;%[C]
TwewN=20;%[C]
TgN=40;%[C]
qgN=2000;%[W]


%budynek betonowy, grzejnik wypełniony powietrzem
Vg=1;
Vw=15*2;
ppow=1.2; 
cpow=1000;
pbet=800;
cbet=840;
Cvw=cpow*ppow*Vw;
Cvg=cpow*ppow*Vg;


Kg=qgN/(2*(TgN-TwewN));
K1=(2*Kg*(TgN-TwewN))/(TwewN-TzewN);
fgN=Kg/(cpow*ppow);

Tzewar=[TzewN TzewN+5 TzewN+5];
fgar=[fgN fgN 0.5*fgN];
qgar=[qgN qgN*0.5 qgN*0.5];

dTzew=0;
dfg=0;
dqg=0;
T=1000;
stop_czas=7000;  

kolor=['g o'; 'b -'; 'r--'];

Tzewstat=TzewN:1:-TzewN;
qgstat=0:50:qgN;
fgstat=0:(1/40)*fgN:fgN;
%
%
%
%charakterystyki statyczne
%
%
%
    a=cpow*ppow*fgN;
    Tg0=(qgN*(Kg+K1+a)+(K1*Tzewstat)*(Kg+a))/((a+Kg)*(Kg+K1+a)-(a+Kg)^2);
    Twew0=(Tg0*(a+Kg)+K1*Tzewstat)/(Kg+K1+a);
    figure(7)
    hold on;
    subplot(311)
    plot(Tzewstat,Tg0)

    figure(6)
    hold on;
    subplot(311)
    plot(Tzewstat,Twew0)

    a=cpow*ppow*fgN;
    Tg0=(qgstat*(Kg+K1+a)+(K1*TzewN)*(Kg+a))/((a+Kg)*(Kg+K1+a)-(a+Kg)^2);
    Twew0=(Tg0*(a+Kg)+K1*TzewN)/(Kg+K1+a);
    figure(7)
    hold on;
    subplot(312)
    plot(qgstat,Tg0)

    figure(6)
    hold on;
    subplot(312)
    plot(qgstat,Twew0)

    a=cpow.*ppow.*fgstat;
    Tg0=(qgN.*(Kg+K1+a)+(K1.*TzewN).*(Kg+a))./((a+Kg).*(Kg+K1+a)-(a+Kg).^2);
    Twew0=(Tg0.*(a+Kg)+K1.*TzewN)./(Kg+K1+a);
    figure(7)   
    hold on;
    subplot(313)
    plot(fgstat,Tg0)

    figure(6)
    hold on;
    subplot(313)
    plot(fgstat,Twew0)

figure(7)
subplot(311)
hold on;
plot(TzewN,TgN, 'go'); xlabel('Tzew'); ylabel('Tg'); title('Charakterystyka statyczna Tg(Tzew)'); legend('','punkt nominalny', 'Location','southeast');
subplot(312)
hold on;
plot(qgN,TgN, 'go'); xlabel('Qg'); ylabel('Tg'); title('Charakterystyka statyczna Tg(Qg)'); legend('','punkt nominalny', 'Location','southeast');
subplot(313)
hold on;
plot(fgN,TgN, 'go'); xlabel('Fg'); ylabel('Tg'); title('Charakterystyka statyczna Tg(Fg)'); legend('','punkt nominalny', 'Location','northeast');

figure(6)
subplot(311)
hold on;
plot(TzewN,TwewN, 'go'); xlabel('Tzew'); ylabel('Twew'); title('Charakterystyka statyczna Twew(Tzew)'); legend('','punkt nominalny', 'Location','southeast');
subplot(312)
hold on;
plot(qgN,TwewN, 'go'); xlabel('Qg'); ylabel('Twew'); title('Charakterystyka statyczna Twew(Qg)'); legend('','punkt nominalny', 'Location','southeast');
subplot(313)
hold on;
plot(fgN,TwewN, 'go'); xlabel('Fg'); ylabel('Twew'); title('Charakterystyka statyczna Twew(Fg)'); legend('','punkt nominalny', 'Location','southeast');



%
%
%
%Badanie model nieliniowy
%
%
%

%skok na Tzew
figure(1);
hold on;
subplot(311)
title('Tg, model nieliniowy, skok Tzew=1')
dTzew=1;
xlabel('czas[s]');
ylabel('Tg[^{\circ} C]');
for i=1:length(Tzewar)
    Tzew=Tzewar(i);
    qg=qgar(i);
    fg=fgar(i);

    a=cpow*ppow*fg;
    Tg0=(qg*(Kg+K1+a)+(K1*Tzew)*(Kg+a))/((a+Kg)*(Kg+K1+a)-(a+Kg)^2);
    Twew0=(Tg0*(a+Kg)+K1*Tzew)/(Kg+K1+a);

    figure(1);
    subplot(311)
    hold on;
    sim("model");
    plot(ans.tout, ans.Tg-Tg0, kolor(i, :));
    figure(2)
    subplot(311)
    hold on;
    plot(ans.tout, ans.Twew-Twew0, kolor(i, :));
end
xlabel('czas[s]');
ylabel('Twew[^{\circ} C]');
title('Twew, model nieliniowy, skok Tzew=1')
legend('TzewN, qgN, fgN', 'TzewN+5, qgN*0.5, fgN', 'TzewN+5, qgN*0.5, fgN*0.5');
figure(1);
legend('TzewN, qgN, fgN', 'TzewN+5, qgN*0.5, fgN', 'TzewN+5, qgN*0.5, fgN*0.5');


%skok na qg
figure(1);
subplot(312)
hold on;
title('Tg, model nieliniowy, skok qg=0.1*qgN')
dTzew=0;
dqg=0.1*qgN;
xlabel('czas[s]');
ylabel('Tg[^{\circ} C]');
for i=1:length(Tzewar)
    Tzew=Tzewar(i);
    qg=qgar(i);
    fg=fgar(i);

    a=cpow*ppow*fg;
    Tg0=(qg*(Kg+K1+a)+(K1*Tzew)*(Kg+a))/((a+Kg)*(Kg+K1+a)-(a+Kg)^2);
    Twew0=(Tg0*(a+Kg)+K1*Tzew)/(Kg+K1+a);

    figure(1);
    subplot(312)
    hold on;
    sim("model");
    plot(ans.tout, ans.Tg-Tg0, kolor(i, :));
    figure(2)
    subplot(312)
    hold on;
    plot(ans.tout, ans.Twew-Twew0, kolor(i, :));
end
xlabel('czas[s]');
ylabel('Twew[^{\circ} C]');
title('Twew, model nieliniowy, skok qg=0.1*qgN')
legend('TzewN, qgN, fgN', 'TzewN+5, qgN*0.5, fgN', 'TzewN+5, qgN*0.5, fgN*0.5');
figure(1);
legend('TzewN, qgN, fgN', 'TzewN+5, qgN*0.5, fgN', 'TzewN+5, qgN*0.5, fgN*0.5');

%skok na fg
figure(1);
hold on;
subplot(313)
title('Tg, model nieliniowy, skok fg=0.1*fgN')
dTzew=0;
dqg=0;
dfg=0.1*fgN;
xlabel('czas[s]');
ylabel('Tg[^{\circ} C]');

for i=1:length(Tzewar)
    Tzew=Tzewar(i);
    qg=qgar(i);
    fg=fgar(i);

    a=cpow*ppow*fg;
    Tg0=(qg*(Kg+K1+a)+(K1*Tzew)*(Kg+a))/((a+Kg)*(Kg+K1+a)-(a+Kg)^2);
    Twew0=(Tg0*(a+Kg)+K1*Tzew)/(Kg+K1+a);

    figure(1);
    subplot(313)
    hold on;
    sim("model");
    plot(ans.tout, ans.Tg-Tg0, kolor(i, :));
    figure(2)
    subplot(313)
    hold on;
    plot(ans.tout, ans.Twew-Twew0, kolor(i, :));
end
    subplot(313)
xlabel('czas[s]');
ylabel('Twew[^{\circ} C]');
title('Twew, model nieliniowy, skok fg=0.1*fgN')
legend('TzewN, qgN, fgN', 'TzewN+5, qgN*0.5, fgN', 'TzewN+5, qgN*0.5, fgN*0.5');
figure(1);
legend('TzewN, qgN, fgN', 'TzewN+5, qgN*0.5, fgN', 'TzewN+5, qgN*0.5, fgN*0.5');
dfg=0;

%
%
%
%Badanie - model liniowy
%
%
%



%symulacja za pomoca transmitancji uruchomiona w sposob tekstowy

dTzew=1;
dqg=0.1*qgN;
figure(3);
for i=1:(length(Tzewar)-1)

    Tzew=Tzewar(i);
    qg=qgar(i);
    fg=fgar(i);

    a=cpow*ppow*fg;

    %transmitancje
    M11=[Kg+a];
    M12=[Cvg*K1 (Kg+a)*K1];
    M21=[Cvw Kg+K1+a];
    M22=[K1*(Kg+a)];
    M=[Cvg*Cvw Cvg*(Kg+K1+a)+Cvw*(Kg+a) (Kg+a)*(Kg+K1+a)-(Kg+a)^2];
    
    transmitancja=tf({M11,M12;M21,M22},{M,M;M,M}, 'InputName', ['qg  '; 'Tzew'], 'OutputName', ['Twew'; 'Tg  ']);
    step_opt = stepDataOptions('InputOffset', [0, 0] ,'StepAmplitude', [dqg, dTzew]);
    step(transmitancja, step_opt, kolor(i, :))
    hold on;
    title('Odpowiedzi modelu liniowego, uruchomione w sposob tekstowy')
end