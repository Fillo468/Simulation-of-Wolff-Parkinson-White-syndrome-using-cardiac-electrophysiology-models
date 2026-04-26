Htot=12; %cm
Lx=8; 
H_A=4; 
H_V=8;
dx=0.1 ;

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

SAN_x=0.25*Lx;
dim_x_SAN= 0.005*Lx; 
SAN_y= 0.02*H_A;

SAN_index= round(SAN_x/dx)+1;
SAN_index_y=round (SAN_y/dx)+1;
lunghezza_san=round (dim_x_SAN/dx)+1;

%definisco i vari tipi di miociti cardiaci
L_epi_x=0.36*spessore_ventricoli;
N_epi=round(L_epi_x/dx);

L_mid=0.28*spessore_ventricoli;   
N_mid=round(L_mid/dx);

% Kent indici 
KENT_x=0.96*Lx;
dim_KENT= 0.009*Lx; 

KENT_index= round(KENT_x/dx)+1;
N_L_KENT=round(dim_KENT/dx)+1;

%matrice per definire la geometria
Cuore= ones(N_Htot,N_x)*100;

%setto
Cuore(1:N_y_A,AVN-N_atri/2:AVN+N_atri/2)=30;
Cuore(N_y_A:N_Htot,AVN-N_atri/2:AVN+N_atri/2)=40;

%tessuto endo 
Cuore(N_y_A:N_Htot,1:N_ventricoli)=40;
Cuore(N_Htot-N_ventricoli:N_Htot,:)=40;
Cuore(N_y_A:N_Htot,N_x-N_ventricoli:N_x)=40;

%tessuto mid
Cuore(N_y_A:N_Htot,1:N_mid+N_epi)=50;
Cuore(N_y_A:N_Htot,N_x-N_mid-N_epi:N_x)=50;
Cuore(N_Htot-N_mid-N_epi:N_Htot,:)=50;

%tessuto epi
Cuore(N_y_A:N_Htot,1:N_epi)=65;
Cuore(N_y_A:N_Htot,N_x-N_epi:N_x)=65;
Cuore(N_Htot-N_epi:N_Htot,:)=65;

%atrio
Cuore(1:N_atri,:)=30;
Cuore(1:N_y_A,1:N_atri)=30;
Cuore(1:N_y_A,N_x-N_atri:N_x)=30;

%SAN
Cuore(SAN_index_y:SAN_index_y+lunghezza_san,SAN_index:SAN_index+lunghezza_san)=80;

%AVN
Cuore(N_y_A-N_AVN:N_AVN+N_y_A,:)=100;
Cuore(N_y_A-N_AVN:N_AVN+N_y_A,AVN-N_atri/2:AVN+N_atri/2)=1;

%fascio di Kent 
Cuore(N_y_A-N_AVN:N_y_A+N_AVN,KENT_index:N_L_KENT+KENT_index)=16;

figure
imagesc(Cuore);
colormap(hot); 
colorbar;
title('Rappresentazione cuore');
axis equal
axis ij
cb=colorbar;
cb.Ticks = [1,16,30, 40,50,65,80];
cb.TickLabels = {'AVN','Fascio di Kent','Tessuto atriale', 'Tessuto endo','Tessuto mid','Tessuto epi','SAN'};
cb.Label.String = 'Componenti del cuore';

T=1500; %ms
dt=0.1; 

Dm=1.171e-3*7;%cm^2/ms
Dm_A=1.171e-3*7*2.8;
Dm_AVN=1.171e-3*7/6;
Dm_endo=1.171e-3*7*2.8;
Dm_Kent=1.171e-3*7*2.8;

e_endo=0.005; %parametro leggermente modificato per favorire la propagazione
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
                    e=0.0255;  %parametro cambiato
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
               
                % Calcolo del Laplaciano con metodo dei punti fantasma
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

                %trascuro il termine aggiuntivo dovuto alla eterogeinità
                %della diffusività

                %corrente ionica Rogers-McCulloch
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
                          
                %SAN FitzHugh-Nagumo con punto equilibrio instabile
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


% v=VideoWriter('Progettino_rientroAV.mp4','MPEG-4');
% v.Quality=90;
% v.FrameRate=30;
% open(v);

figure;
for i = 1:10:Nt  
    V = squeeze(Vm(i,:,:))';  
    imagesc(V, [-90 40]);     
    colormap(jet);
    colorbar;
    title(sprintf('Potenziale Vm a t = %.1f ms', (i-1)*dt));
    axis equal ij
    drawnow;
    % frame=getframe(gcf);
    % writeVideo(v,frame)
end
% close(v)
















