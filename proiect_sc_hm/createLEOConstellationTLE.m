function createLEOConstellationTLE(numSatellites, altitude, inclination, filename)
%CREATELEOCONSTELLATIONTLE Creează un fișier TLE pentru o constelație LEO
%
% Sintaxă:
%   createLEOConstellationTLE(numSatellites, altitude, inclination, filename)
%
% Inputs:
%   numSatellites - Numărul de sateliți în constelație
%   altitude      - Altitudinea orbitei în km
%   inclination   - Inclinația orbitei în grade
%   filename      - Numele fișierului de output (ex: 'constellation.tle')
%
% Exemplu:
%   createLEOConstellationTLE(40, 550, 53, 'myConstellation.tle');

    if nargin < 4
        filename = 'leoConstellation.tle';
    end
    
    % Parametri orbitali
    earthRadius = 6378.137; % km
    semiMajorAxis = earthRadius + altitude;
    
    % Calculează mean motion (revoluții pe zi)
    mu = 398600.4418; % km^3/s^2 (Earth gravitational parameter)
    period = 2*pi*sqrt(semiMajorAxis^3/mu); % seconds
    meanMotion = 86400/period; % revolutions per day
    
    % Epoch - data curentă în format TLE
    currentDate = datetime('now', 'TimeZone', 'UTC');
    yearValue = year(currentDate);
    yearTwoDigit = mod(yearValue, 100); % Last 2 digits
    dayOfYear = day(currentDate, 'dayofyear');
    fractionalDay = hour(currentDate)/24 + minute(currentDate)/1440 + second(currentDate)/86400;
    epoch = sprintf('%02d%012.8f', yearTwoDigit, dayOfYear + fractionalDay);
    
    % Deschide fișierul pentru scriere
    fid = fopen(filename, 'w');
    
    if fid == -1
        error('Nu s-a putut crea fișierul %s', filename);
    end
    
    fprintf('Generare fișier TLE pentru %d sateliți...\n', numSatellites);
    
    % Generează TLE pentru fiecare satelit
    for i = 1:numSatellites
        satNumber = 40000 + i; % ID satelit (începe de la 40001)
        
        % Distribuie sateliții uniform în orbită
        meanAnomaly = 360 * (i-1) / numSatellites;
        
        % Distribuie și RAAN pentru constelații mai complexe (opțional)
        % Pentru orbită simplă, folosim același RAAN
        raan = 0; % sau: 360 * mod(i-1, numPlanes) / numPlanes
        
        satName = sprintf('LEO-SAT-%d', i);
        
        % Line 0: Numele satelitului
        fprintf(fid, '%s\n', satName);
        
        % Line 1: Parametri orbitali (parte 1)
        line1Catalog = sprintf('%05d', satNumber);
        line1Classification = 'U';
        line1IntDesignator = sprintf('%02d001%s', yearTwoDigit, 'A  ');
        line1Epoch = epoch;
        line1FirstDeriv = ' .00000000'; % Mean motion derivative (assumem 0)
        line1SecondDeriv = ' 00000-0'; % Mean motion second derivative
        line1Bstar = ' 00000-0'; % B* drag term
        line1EphemerisType = '0';
        line1ElementNumber = sprintf('%4d', mod(i, 9999));
        
        % Construiește Line 1 fără checksum
        line1_no_check = sprintf('1 %sU %s %s %s %s %s %s %s', ...
            line1Catalog, line1IntDesignator, line1Epoch, ...
            line1FirstDeriv, line1SecondDeriv, line1Bstar, ...
            line1EphemerisType, line1ElementNumber);
        
        % Calculează checksum pentru Line 1
        checksum1 = calculateTLEChecksum(line1_no_check);
        line1 = sprintf('%s%d', line1_no_check, checksum1);
        
        fprintf(fid, '%s\n', line1);
        
        % Line 2: Parametri orbitali (parte 2)
        line2Catalog = sprintf('%05d', satNumber);
        line2Inclination = sprintf('%8.4f', inclination);
        line2RAAN = sprintf('%8.4f', raan);
        line2Eccentricity = '0000000'; % Orbită circulară
        line2ArgPerigee = sprintf('%8.4f', 0.0); % Argument of perigee (0 pentru circular)
        line2MeanAnomaly = sprintf('%8.4f', meanAnomaly);
        line2MeanMotion = sprintf('%11.8f', meanMotion);
        line2RevNumber = sprintf('%5d', 1); % Revolution number
        
        % Construiește Line 2 fără checksum
        line2_no_check = sprintf('2 %s %s %s %s %s %s %s%s', ...
            line2Catalog, line2Inclination, line2RAAN, ...
            line2Eccentricity, line2ArgPerigee, line2MeanAnomaly, ...
            line2MeanMotion, line2RevNumber);
        
        % Calculează checksum pentru Line 2
        checksum2 = calculateTLEChecksum(line2_no_check);
        line2 = sprintf('%s%d', line2_no_check, checksum2);
        
        fprintf(fid, '%s\n', line2);
    end
    
    fclose(fid);
    
    fprintf('✓ Fișier TLE creat cu succes: %s\n', filename);
    fprintf('  Sateliți: %d\n', numSatellites);
    fprintf('  Altitudine: %.1f km\n', altitude);
    fprintf('  Inclinație: %.1f°\n', inclination);
    fprintf('  Mean Motion: %.8f rev/day\n', meanMotion);
end

function checksum = calculateTLEChecksum(line)
    % Calculează checksum-ul pentru o linie TLE
    % Suma tuturor cifrelor, unde '-' = 1
    
    checksum = 0;
    for i = 1:length(line)
        c = line(i);
        if c >= '0' && c <= '9'
            checksum = checksum + str2double(c);
        elseif c == '-'
            checksum = checksum + 1;
        end
    end
    
    % Checksum este ultima cifră a sumei
    checksum = mod(checksum, 10);
end