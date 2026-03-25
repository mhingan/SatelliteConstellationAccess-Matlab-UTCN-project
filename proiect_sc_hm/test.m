%% Configurare scenariu

% Definește timpul de start al simulării: 12 mai 2020, ora 13:00:00
startTime = datetime(2020,5,12,13,0,0);

% Definește timpul de oprire: 24 ore după startTime (pentru a include treceri peste România)
stopTime = startTime + hours(24);

% Setează intervalul de eșantionare la 30 de secunde
sampleTime = 30; % secunde

% Creează scenariul de sateliți
sc = satelliteScenario(startTime, stopTime, sampleTime);

%% Încarcă constelația de sateliți LEO din fișierul TLE
tleFile = "leoSatelliteConstellation.tle";
sat = satellite(sc, tleFile);

%% Adaugă câte un gimbal și un senzor conic pe fiecare satelit
g = gimbal(sat);  % gimbal pentru orientare
names = sat.Name + " Camera";
cam = conicalSensor(g, "Name", names, "MaxViewAngle", 90);

%% Creează stația la sol în România (Cluj-Napoca)
latitude = 46.7712;     % grade Nord
longitude = 23.6236;    % grade Est
altitude = 0;           % metri
minElevationAngle = 20; % grade

geoSite = groundStation(sc, ...
    "Name", "Romania Ground Station", ...
    "Latitude", latitude, ...
    "Longitude", longitude, ...
    "Altitude", altitude, ...
    "MinElevationAngle", minElevationAngle);

%% Orientează gimbalurile (și implicit senzorii) către stația la sol
pointAt(g, geoSite);

%% Creează analiza de acces între senzori și stația la sol
ac = access(cam, geoSite);
ac.LineColor = 'red';

%% Vizualizare 3D
v = satelliteScenarioViewer(sc, "ShowDetails", false);
geoSite.ShowLabel = true;
show(geoSite);
show(sat);
play(sc);

%% Afișează intervalele de timp când există acces
disp("Intervale de acces între sateliți și stația la sol:");
accessIntervals(ac);

%% Analiză sistemică: dacă oricare satelit are acces, sistemul e conectat
for idx = 1:numel(ac)
    [s, time] = accessStatus(ac(idx)); % s = vector logic (1=acces)
    if idx == 1
        systemWideAccessStatus = s;
    else
        systemWideAccessStatus = or(systemWideAccessStatus, s);
    end
end

%% Reprezentare grafică a accesului total
figure;
plot(time, systemWideAccessStatus, "LineWidth", 2);
grid on;
xlabel("Time");
ylabel("System-Wide Access Status");
title("Acces total al constelației LEO la stația din România");

%% Rezumat
% 1. Creează scenariul de 24h pentru constelația LEO.
% 2. Încarcă datele orbitale din TLE.
% 3. Adaugă gimbaluri și senzori conici orientați către stația din Cluj.
% 4. Calculează perioadele de vizibilitate și le afișează.
% 5. Vizualizează animația 3D și graficul logic al conexiunilor.