%% SATELLITE CONSTELLATION ANALYZER - START SCRIPT
% Script pentru pornirea aplicației de analiză constelații sateliți
% Autor: [Numele Tău]
% Data: 2025

%% Verificare toolboxuri necesare
fprintf('=== Verificare Toolboxuri Necesare ===\n\n');

% Lista toolboxuri necesare
requiredToolboxes = {
    'Satellite Communications Toolbox'
    'Aerospace Toolbox'
};

allAvailable = true;

for i = 1:length(requiredToolboxes)
    toolboxInfo = ver(requiredToolboxes{i});
    if isempty(toolboxInfo)
        fprintf('❌ LIPSĂ: %s\n', requiredToolboxes{i});
        allAvailable = false;
    else
        fprintf('✓ Disponibil: %s (Version %s)\n', ...
            requiredToolboxes{i}, toolboxInfo.Version);
    end
end

fprintf('\n');

%% Verificare fișier TLE (opțional)
% Dacă vrei să folosești fișiere TLE pentru sateliți reali
if exist('leoSatelliteConstellation.tle', 'file')
    fprintf('✓ Fișier TLE găsit: leoSatelliteConstellation.tle\n');
else
    fprintf('ℹ️  Fișier TLE nu a fost găsit (opțional)\n');
    fprintf('   Aplicația va crea sateliți folosind elemente Keplerian\n');
end

fprintf('\n');

%% Pornire aplicație
if allAvailable
    fprintf('=== Pornire Aplicație ===\n\n');
    fprintf('Se deschide interfața grafică...\n');
    fprintf('Dacă nu apare automat, verifică taskbar-ul!\n\n');
    
    % Creează și pornește aplicația
    app = SatelliteConstellationApp;
    
    fprintf('✓ Aplicația a pornit cu succes!\n');
    fprintf('\n');
    fprintf('INSTRUCȚIUNI RAPIDE:\n');
    fprintf('1. Citește pagina de bun venit\n');
    fprintf('2. Configurează parametrii pentru sateliți și stație\n');
    fprintf('3. Pornește simularea\n');
    fprintf('4. Vizualizează rezultatele\n');
    fprintf('5. Folosește secțiunea Ajutor pentru detalii\n');
    fprintf('\n');
    fprintf('Enjoy! 🛰️\n');
else
    fprintf('❌ EROARE: Nu toate toolboxurile necesare sunt instalate!\n');
    fprintf('\n');
    fprintf('Pentru a instala toolboxurile lipsă:\n');
    fprintf('1. Deschide MATLAB\n');
    fprintf('2. Home Tab → Add-Ons → Get Add-Ons\n');
    fprintf('3. Caută și instalează toolboxurile lipsă\n');
    fprintf('\n');
    error('Toolboxuri lipsă. Instalează-le pentru a continua.');
end