Htot=12; %cm
Lx=8; 
H_A=4; 
H_V=8;
dx=0.1; 

spessore_atri=0.5; %cm
N_atri=round(spessore_atri/dx)+1;

spessore_ventricoli=1; %cm
N_ventricoli=round(spessore_ventricoli/dx)+1;

N_Htot= round (Htot/dx)+1;
N_x= round (Lx/dx)+1;
N_y_A= round (H_A/dx)+1;

AVN=floor(N_x/2);
L_y_AVN=0.03*Htot;
N_AVN=round(L_y_AVN/dx)+1;

%SAN
SAN_x=0.25*Lx;
dim_x_SAN= 0.005*Lx; 
SAN_y= 0.02*H_A;

SAN_index= round(SAN_x/dx)+1;
SAN_index_y=round (SAN_y/dx)+1;
lunghezza_san=round (dim_x_SAN/dx)+1;

L_epi_x=0.36*spessore_ventricoli;
N_epi=round(L_epi_x/dx);

L_mid=0.28*spessore_ventricoli;   
N_mid=round(L_mid/dx);

%Kent
KENT_x=0.96*Lx;
dim_KENT= 0.009*Lx; 

KENT_index= round(KENT_x/dx)+1;
N_L_KENT=round(dim_KENT/dx)+1;

% geometry matrix
Cuore= ones(N_Htot,N_x)*100;

Cuore(1:N_y_A,AVN-N_atri/2:AVN+N_atri/2)=30;
Cuore(N_y_A:N_Htot,AVN-N_atri/2:AVN+N_atri/2)=40;

%endo 
Cuore(N_y_A:N_Htot,1:N_ventricoli)=40;
Cuore(N_Htot-N_ventricoli:N_Htot,:)=40;
Cuore(N_y_A:N_Htot,N_x-N_ventricoli:N_x)=40;

%mid
Cuore(N_y_A:N_Htot,1:N_mid+N_epi)=50;
Cuore(N_y_A:N_Htot,N_x-N_mid-N_epi:N_x)=50;
Cuore(N_Htot-N_mid-N_epi:N_Htot,:)=50;

%epi
Cuore(N_y_A:N_Htot,1:N_epi)=65;
Cuore(N_y_A:N_Htot,N_x-N_epi:N_x)=65;
Cuore(N_Htot-N_epi:N_Htot,:)=65;

Cuore(1:N_atri,:)=30;
Cuore(1:N_y_A,1:N_atri)=30;
Cuore(1:N_y_A,N_x-N_atri:N_x)=30;

%SAN
Cuore(SAN_index_y:SAN_index_y+lunghezza_san,SAN_index:SAN_index+lunghezza_san)=80;

%AVN
Cuore(N_y_A-N_AVN:N_AVN+N_y_A,:)=100;
Cuore(N_y_A-N_AVN:N_AVN+N_y_A,AVN-N_atri/2:AVN+N_atri/2)=1;

%Kent
Cuore(N_y_A-N_AVN:N_y_A+N_AVN,KENT_index:N_L_KENT+KENT_index)=16;

figure
imagesc(Cuore);
colormap(hot); 
colorbar;
axis equal
axis ij
cb=colorbar;
cb.Ticks = [1,16,30, 40,50,65,80];
cb.TickLabels = {'AVN','Fascio di Kent','Tessuto atriale', 'Tessuto endo','Tessuto mid','Tessuto epi','SAN'};
cb.Label.String = 'Componenti del cuore';

T=1000; %ms
dt=0.1; 

Dm=1.171e-3*7; %cm^2/ms
Dm_A=1.171e-3*7*2.8;
Dm_AVN=1.171e-3*7/6;
Dm_endo=1.171e-3*7*2.8;
Dm_Kent=1.171e-3*7/6;

e_endo=0.0045;
e_mid=0.003;
e_epi=0.006;
e_atrio=0.008;
e_AVN=0.008;

Nt=round(T/dt)+1;

Vm=-85*ones(Nt,N_x,N_Htot); %mV
u = zeros(Nt, N_x, N_Htot);

%SAN
Vm(1,SAN_index:SAN_index+lunghezza_san,SAN_index_y:SAN_index_y+lunghezza_san)=-65; %mV

for i=1:Nt-1
    for jy= 1:N_Htot
        for jx= 1:N_x

            if Cuore(jy,jx)~=100 

                dm=Dm;

                if Cuore(jy,jx)==30  
                    dm=Dm_A;
                    e=e_atrio;
                elseif Cuore(jy,jx)==16
                    e=e_atrio;
                    dm=Dm_Kent;
                elseif Cuore(jy,jx)== 1
                    dm=Dm_AVN;
                    e=e_AVN;
                elseif Cuore(jy,jx)== 40
                    dm=Dm_endo; 
                    e=e_endo;
                elseif Cuore (jy,jx)==50
                    e=e_mid;
                elseif Cuore (jy,jx)==65
                    e=e_epi;
                end

                %Laplacian
                 
                if jx > 1 && Cuore(jy, jx-1) ~= 100 
                    sx = Vm(i, jx-1, jy);
                else
                    sx = Vm(i, jx, jy);
                end

                if jx < N_x && Cuore(jy, jx+1) ~= 100
                    dx_ = Vm(i, jx+1, jy);
                else
                    dx_ = Vm(i, jx, jy);
                end

                lapvx = (sx + dx_ - 2*Vm(i, jx, jy)) / (dx^2);

                if jy > 1 && Cuore(jy-1, jx) ~= 100
                    sy = Vm(i, jx, jy-1);
                else
                    sy = Vm(i, jx, jy);
                end

                if jy < N_Htot && Cuore(jy+1, jx) ~= 100
                    dy = Vm(i, jx, jy+1);
                else
                    dy = Vm(i, jx, jy);
                end

                lapvy = (sy + dy - 2*Vm(i, jx, jy)) / (dx^2);

                lapv=lapvx+lapvy;
                Im=dm*lapv;    
                
                if Cuore(jy,jx)==30 & Cuore(jy+1,jx)==1;
                    Im=Im+((Dm_AVN-Dm_A)/dx)*((Vm(i,jx,jy+1)-Vm(i,jx,jy))/dx);
                end

                if Cuore(jy,jx)==1 & Cuore(jy+1,jx)==40
                    Im=Im+((Dm_endo-Dm_AVN)/dx)*((Vm(i,jx,jy+1)-Vm(i,jx,jy))/dx);
                end

                if Cuore(jy,jx)==30 & Cuore(jy+1,jx)==16;
                    Im=Im+((Dm_Kent-Dm_A)/dx)*((Vm(i,jx,jy+1)-Vm(i,jx,jy))/dx);
                end

                if Cuore(jy,jx)==16 & Cuore(jy+1,jx)==65;
                    Im=Im+((Dm-Dm_Kent)/dx)*((Vm(i,jx,jy+1)-Vm(i,jx,jy))/dx);
                end

                if Cuore(jy,jx)==40 & Cuore(jy+1,jx)==50;
                    Im=Im+((Dm-Dm_endo)/dx)*((Vm(i,jx,jy+1)-Vm(i,jx,jy))/dx);
                end

                if Cuore(jy,jx)==40 & Cuore(jy,jx+1)==50;
                    Im=Im+((Dm-Dm_endo)/dx)*((Vm(i,jx+1,jy)-Vm(i,jx,jy))/dx);
                end

                %Rogers-McCulloch
                if Cuore(jy,jx)~=80  
                c1=2.6;
                c2=1;
                a=0.13;
                d=1;
                A=135;
                B=-85;
                vr=Vm(i,jx,jy)-B;
                vm=vr/A;
                
                Ii=c1*vr*(a-vm)*(1-vm)+c2*u(i,jx,jy)*vr;
                dv2dt=Im-Ii;

                %SAN FitzHugh-Nagumo
                elseif Cuore(jy,jx)==80 
                    c1=1.56;
                    c2=0.6;
                    a=-1;
                    e_APD=0.009;
                    e_HR=0.005;
                    d=0;
                    A=35;
                    B=-30; 
                    vr=Vm(i,jx,jy)-B;
                    vm=vr/A;

                    Ii=c1*vr*(a-vm)*(1-vm)+c2*u(i,jx,jy)*A;
                    dv2dt=Im-Ii;

                    if (dv2dt>=0)
                       e=e_HR;
                    else
                       e=e_APD;
                    end  

                end                 
                u(i+1,jx,jy)=u(i,jx,jy)+dt*e*(vm-d*u(i,jx,jy));
                Vm(i+1,jx,jy)=Vm(i,jx,jy)+dt*dv2dt;               
            else
                Vm(i+1,jx,jy)=NaN;
            end
        end
    end
end


figure;
plot(0:dt:T, squeeze(Vm(:, 1, 1)), 'LineWidth', 1.5);
xlabel('Tempo [ms]');
ylabel('Vm [mV]');
title(sprintf('Potenziale Cardiaco'));

figure;
plot(0:dt:T, squeeze(Vm(:,SAN_index,SAN_index_y)));
xlabel('Tempo [ms]');
ylabel('Vm [mV]');
title('Potenziale SAN');

R=20;  %cm
x=(0:dx:Lx);
y=(0:dx:Htot);
x0 = round(N_x / 2);
y0 = round(N_Htot / 2);


Rl_base=R*[cosd(30);cosd(60)]; 
Rr_base=R*[-cosd(30);cosd(60)];
Rf_base=R*[0;-1];

%rotation matrix
theta = deg2rad(-45);
Rmat = [cos(theta), -sin(theta); -sin(theta), -cos(theta)];

Rl=Rmat * Rl_base;
Rf=Rmat * Rf_base;
Rr=Rmat * Rr_base;

Pb=zeros(Nt,2);
VRR=zeros(Nt,1);
VLL=zeros(Nt,1);
VFF=zeros(Nt,1);

for i=1:Nt
    vR=0;
    vL=0;
    vF=0;
    dp=zeros(2,1); 

    for jx=1:N_x-1
       
        for jy=1:N_Htot-1

            if Cuore (jy,jx) ~= 100 & Cuore(jy,jx+1) ~= 100
                Vmx=(Vm(i,jx+1,jy)-Vm(i,jx,jy))/dx;
            else
                Vmx=0;
            end

            if Cuore(jy,jx) ~= 100  & Cuore(jy+1,jx) ~= 100  
                Vmy = (Vm(i,jx,jy+1) - Vm(i,jx,jy)) / dx;
            else
                Vmy = 0;
            end

            if     Cuore(jy,jx) ==30
                dm=Dm_A;
            elseif Cuore(jy,jx) ==16
                dm=Dm_Kent;
            elseif Cuore(jy,jx) ==1
                dm=Dm_AVN;
            elseif Cuore(jy,jx) ==40
                dm=Dm_endo;
            else
                dm=1.171e-3*7;
            end

            grad=[Vmx; Vmy];
                    
            RR=[Rr(1)-x(jx);Rr(2)-y(jy)];
            vR=vR-dx^2*(grad'*RR)/norm(RR)^3;

            RL=[Rl(1)-x(jx);Rl(2)-y(jy)];
            vL=vL-dx^2*(grad'*RL)/norm(RL)^3;

            RF=[Rf(1)-x(jx);Rf(2)-y(jy)];
            vF=vF-dx^2*(grad'*RF)/norm(RF)^3;

            pb=-grad*dm; 
            dp=dp+pb*dx^2;
            
        end
    end

    Pb(i,:)=dp;
    VRR(i)=vR;
    VLL(i)=vL;
    VFF(i)=vF;

end

mag=20;


figure;
for i = 1:10:Nt  
    V = squeeze(Vm(i,:,:))';  
    imagesc(V, [-90 40]);     
    colormap(jet);
    colorbar;
    title(sprintf('Potenziale Vm a t = %.1f ms', (i-1)*dt));
    axis equal ij
    hold on
    quiver(x0,y0,Pb(i,1),Pb(i,2),mag,'k','Linewidth',2);
    drawnow;
    hold off
   
end

%ECG
ECG1=VLL-VRR;
ECG2=VFF-VRR;
ECG3=VFF-VLL;

t = (0:Nt-1)*dt;

figure;
subplot(3,1,1);
plot(t, ECG1, 'b');
title('I');
ylabel('mV'); grid on;

subplot(3,1,2);
plot(t, ECG2, 'r');
title('II');
ylabel('mV'); grid on;

subplot(3,1,3);
plot(t, ECG3, 'g');
title('III');
xlabel('Tempo [ms]');
ylabel('mV'); grid on;

R_p = R / dx; 
Rlp_base=R_p*[cosd(30);cosd(60)]; 
Rrp_base=R_p*[-cosd(30);cosd(60)];
Rfp_base=R_p*[0;-1];

theta = deg2rad(-45);
Rmat = [cos(theta), -sin(theta); -sin(theta), -cos(theta)];

Rlp=Rmat * Rlp_base;
Rfp=Rmat * Rfp_base;
Rrp=Rmat * Rrp_base;

figure
imagesc(Cuore)
colormap(hot); 
axis equal tight off             
hold on, scatter(Rrp_base(1),Rrp_base(2), 'r', 'filled')
text(Rrp_base(1)+30*dx, Rrp_base(2), 'VR');
hold on, scatter(Rlp_base(1),Rlp_base(2), 'b', 'filled')
text(Rlp_base(1)+30*dx, Rlp_base(2), 'VL');
hold on, scatter(Rfp_base(1),Rfp_base(2), 'g', 'filled')
text(Rfp_base(1)+30*dx, Rfp_base(2), 'VF');
hold off
title('Cuore + Derivazioni')

figure
imagesc(Cuore) 
colormap(hot); 
axis equal tight off             
hold on, scatter(Rrp(1),Rrp(2), 'r', 'filled')
text(Rrp(1)+30*dx, Rrp(2), 'VR');
hold on, scatter(Rlp(1),Rlp(2), 'b', 'filled')
text(Rlp(1)+30*dx, Rlp(2), 'VL');
hold on, scatter(Rfp(1),Rfp(2), 'g', 'filled')
text(Rfp(1)+30*dx, Rfp(2), 'VF');
hold off
title('Cuore + Derivazioni ruotate ')
