classdef SatelliteConstellationApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        MainPanel               matlab.ui.container.Panel
        
        % Navigation
        WelcomePanel            matlab.ui.container.Panel
        ConfigPanel             matlab.ui.container.Panel
        SimulationPanel         matlab.ui.container.Panel
        ResultsPanel            matlab.ui.container.Panel
        HelpPanel               matlab.ui.container.Panel
        
        % Buttons
        StartButton             matlab.ui.control.Button
        ConfigButton            matlab.ui.control.Button
        SimulateButton          matlab.ui.control.Button
        ResultsButton           matlab.ui.control.Button
        HelpButton              matlab.ui.control.Button
        BackButton              matlab.ui.control.Button
        
        % Scenario Data
        sc                      % Satellite Scenario
        satellites              % Satellites array
        groundStation           % Ground station
        cameras                 % Conical sensors
        accessAnalysis          % Access objects
    end
    
    properties (Access = private)
        CurrentPanel            % Currently displayed panel
    end
    
    methods (Access = private)
        
        function createWelcomePanel(app)
            % Create welcome panel
            app.WelcomePanel = uipanel(app.UIFigure);
            app.WelcomePanel.Position = [10 10 1180 680];
            app.WelcomePanel.Title = 'Bine ai venit!';
            app.WelcomePanel.FontSize = 16;
            app.WelcomePanel.FontWeight = 'bold';
            
            % Title
            uilabel(app.WelcomePanel, ...
                'Position', [50 580 1080 50], ...
                'Text', 'SATELLITE CONSTELLATION ACCESS ANALYZER', ...
                'FontSize', 28, ...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'center', ...
                'FontColor', [0.2 0.4 0.8]);
            
            % Subtitle
            uilabel(app.WelcomePanel, ...
                'Position', [50 540 1080 30], ...
                'Text', 'Analiză avansată a accesului între constelații de sateliți și stații terestre', ...
                'FontSize', 16, ...
                'HorizontalAlignment', 'center', ...
                'FontColor', [0.4 0.4 0.4]);
            
            % Description
            descText = ['Această aplicație îți permite să:', newline, newline, ...
                '🛰️  Configurezi constelații de sateliți LEO (Low Earth Orbit)', newline, ...
                '📡  Definești stații terestre cu parametri personalizați', newline, ...
                '📷  Simulezi camere și senzori conici pe sateliți', newline, ...
                '⏱️  Analizezi intervalele de acces între sateliți și stații', newline, ...
                '📊  Calculezi procentajul de acoperire sistem', newline, ...
                '🌍  Vizualizezi scenarii 3D interactive', newline, newline, ...
                'Proiectul este bazat pe tehnologia MathWorks Satellite Communications Toolbox', newline, ...
                'și oferă o interfață intuitivă pentru analiza misiunilor satelitare.'];
            
            uilabel(app.WelcomePanel, ...
                'Position', [100 280 980 250], ...
                'Text', descText, ...
                'FontSize', 14, ...
                'VerticalAlignment', 'top');
            
            % Features boxes
            createFeatureBox(app, 150, 100, 'Configurare', ...
                'Setează parametri orbitali, senzori și stații terestre');
            createFeatureBox(app, 420, 100, 'Simulare', ...
                'Rulează scenarii complexe cu vizualizare 3D');
            createFeatureBox(app, 690, 100, 'Analiză', ...
                'Obține statistici detaliate și grafice interactive');
            
            % Start button
            app.StartButton = uibutton(app.WelcomePanel, ...
                'Position', [450 30 280 50], ...
                'Text', 'ÎNCEPE →', ...
                'FontSize', 18, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.6 0.3], ...
                'FontColor', [1 1 1], ...
                'ButtonPushedFcn', @(btn,event) showConfigPanel(app));
        end
        
        function createFeatureBox(app, x, y, title, desc)
            p = uipanel(app.WelcomePanel);
            p.Position = [x y 240 120];
            p.BackgroundColor = [0.95 0.97 1];
            
            uilabel(p, 'Position', [10 80 220 30], ...
                'Text', title, 'FontSize', 16, 'FontWeight', 'bold');
            uilabel(p, 'Position', [10 10 220 65], ...
                'Text', desc, 'FontSize', 11, ...
                'VerticalAlignment', 'top');
        end
        
        function createConfigPanel(app)
            % Create configuration panel
            app.ConfigPanel = uipanel(app.UIFigure);
            app.ConfigPanel.Position = [10 10 1180 680];
            app.ConfigPanel.Title = 'Configurare Scenariu';
            app.ConfigPanel.FontSize = 16;
            app.ConfigPanel.FontWeight = 'bold';
            app.ConfigPanel.Visible = 'off';
            
            % Left panel - Satellite configuration
            leftPanel = uipanel(app.ConfigPanel);
            leftPanel.Position = [20 20 560 600];
            leftPanel.Title = '🛰️ Configurare Sateliți';
            leftPanel.FontSize = 14;
            
            yPos = 530;
            
            % Number of satellites
            uilabel(leftPanel, 'Position', [20 yPos 200 22], ...
                'Text', 'Număr sateliți:', 'FontWeight', 'bold');
            numSatSpinner = uispinner(leftPanel, ...
                'Position', [230 yPos 100 22], ...
                'Value', 40, ...
                'Limits', [1 100], ...
                'Tag', 'numSat');
            
            yPos = yPos - 40;
            
            % Altitude
            uilabel(leftPanel, 'Position', [20 yPos 200 22], ...
                'Text', 'Altitudine (km):', 'FontWeight', 'bold');
            altSpinner = uispinner(leftPanel, ...
                'Position', [230 yPos 100 22], ...
                'Value', 500, ...
                'Limits', [200 2000], ...
                'Tag', 'altitude');
            
            yPos = yPos - 40;
            
            % Inclination
            uilabel(leftPanel, 'Position', [20 yPos 200 22], ...
                'Text', 'Inclinație (grade):', 'FontWeight', 'bold');
            incSpinner = uispinner(leftPanel, ...
                'Position', [230 yPos 100 22], ...
                'Value', 55, ...
                'Limits', [0 90], ...
                'Tag', 'inclination');
            
            yPos = yPos - 40;
            
            % Camera FOV
            uilabel(leftPanel, 'Position', [20 yPos 200 22], ...
                'Text', 'Field of View cameră (°):', 'FontWeight', 'bold');
            fovSpinner = uispinner(leftPanel, ...
                'Position', [230 yPos 100 22], ...
                'Value', 90, ...
                'Limits', [10 180], ...
                'Tag', 'fov');
            
            yPos = yPos - 60;
            
            % Info text
            infoText = ['Sateliții vor fi plasați în orbite LEO circulare.', newline, ...
                'Fiecare satelit va avea o cameră montată cu', newline, ...
                'field of view specificat.'];
            uilabel(leftPanel, 'Position', [20 yPos-60 500 70], ...
                'Text', infoText, 'FontSize', 11, ...
                'FontColor', [0.4 0.4 0.4]);
            
            % Right panel - Ground Station configuration
            rightPanel = uipanel(app.ConfigPanel);
            rightPanel.Position = [600 20 560 600];
            rightPanel.Title = '📡 Configurare Stație Terestră';
            rightPanel.FontSize = 14;
            
            yPos = 530;
            
            % Latitude
            uilabel(rightPanel, 'Position', [20 yPos 200 22], ...
                'Text', 'Latitudine (grade):', 'FontWeight', 'bold');
            latSpinner = uispinner(rightPanel, ...
                'Position', [230 yPos 100 22], ...
                'Value', 42.3, ...
                'Limits', [-90 90], ...
                'Tag', 'latitude');
            
            yPos = yPos - 40;
            
            % Longitude
            uilabel(rightPanel, 'Position', [20 yPos 200 22], ...
                'Text', 'Longitudine (grade):', 'FontWeight', 'bold');
            lonSpinner = uispinner(rightPanel, ...
                'Position', [230 yPos 100 22], ...
                'Value', -71.35, ...
                'Limits', [-180 180], ...
                'Tag', 'longitude');
            
            yPos = yPos - 40;
            
            % Min Elevation
            uilabel(rightPanel, 'Position', [20 yPos 200 22], ...
                'Text', 'Unghi elevație min (°):', 'FontWeight', 'bold');
            elevSpinner = uispinner(rightPanel, ...
                'Position', [230 yPos 100 22], ...
                'Value', 30, ...
                'Limits', [0 90], ...
                'Tag', 'minElevation');
            
            yPos = yPos - 60;
            
            % Time configuration
            uilabel(rightPanel, 'Position', [20 yPos 200 22], ...
                'Text', 'Durată simulare (ore):', 'FontWeight', 'bold');
            durationSpinner = uispinner(rightPanel, ...
                'Position', [230 yPos 100 22], ...
                'Value', 6, ...
                'Limits', [1 24], ...
                'Tag', 'duration');
            
            yPos = yPos - 40;
            
            uilabel(rightPanel, 'Position', [20 yPos 200 22], ...
                'Text', 'Sample time (secunde):', 'FontWeight', 'bold');
            sampleSpinner = uispinner(rightPanel, ...
                'Position', [230 yPos 100 22], ...
                'Value', 30, ...
                'Limits', [10 300], ...
                'Tag', 'sampleTime');
            
            yPos = yPos - 60;
            
            % Info text
            infoText2 = ['Stația terestră va monitoriza trecerile sateliților.', newline, ...
                'Unghiul minim de elevație asigură calitatea semnalului', newline, ...
                'prin reducerea distorsiunilor atmosferice.'];
            uilabel(rightPanel, 'Position', [20 yPos-60 500 70], ...
                'Text', infoText2, 'FontSize', 11, ...
                'FontColor', [0.4 0.4 0.4]);
            
            % Buttons
            uibutton(app.ConfigPanel, ...
                'Position', [400 640 200 40], ...
                'Text', 'Pornește Simularea', ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.6 0.3], ...
                'FontColor', [1 1 1], ...
                'ButtonPushedFcn', @(btn,event) startSimulation(app));
            
            uibutton(app.ConfigPanel, ...
                'Position', [620 640 150 40], ...
                'Text', '← Înapoi', ...
                'FontSize', 12, ...
                'ButtonPushedFcn', @(btn,event) showWelcomePanel(app));
        end
        
        function createSimulationPanel(app)
            % Create simulation panel
            app.SimulationPanel = uipanel(app.UIFigure);
            app.SimulationPanel.Position = [10 10 1180 680];
            app.SimulationPanel.Title = 'Simulare și Vizualizare';
            app.SimulationPanel.FontSize = 16;
            app.SimulationPanel.FontWeight = 'bold';
            app.SimulationPanel.Visible = 'off';
            
            % Info panel
            infoPanel = uipanel(app.SimulationPanel);
            infoPanel.Position = [20 550 1140 90];
            infoPanel.BackgroundColor = [0.95 0.97 1];
            
            uilabel(infoPanel, 'Position', [20 50 1100 30], ...
                'Text', '✅ Scenariul a fost creat cu succes!', ...
                'FontSize', 16, ...
                'FontWeight', 'bold', ...
                'FontColor', [0.2 0.6 0.3]);
            
            uilabel(infoPanel, 'Position', [20 10 1100 35], ...
                'Text', 'Vizualizarea 3D va apărea într-o fereastră separată. Folosește butoanele de mai jos pentru control.', ...
                'FontSize', 12, ...
                'Tag', 'statusLabel');
            
            % Control buttons
            btnY = 480;
            uibutton(app.SimulationPanel, ...
                'Position', [50 btnY 200 50], ...
                'Text', '🌍 Afișează Scenariu', ...
                'FontSize', 13, ...
                'ButtonPushedFcn', @(btn,event) showScenarioViewer(app));
            
            uibutton(app.SimulationPanel, ...
                'Position', [270 btnY 200 50], ...
                'Text', '▶️ Play Simulare', ...
                'FontSize', 13, ...
                'ButtonPushedFcn', @(btn,event) playSimulation(app));
            
            uibutton(app.SimulationPanel, ...
                'Position', [490 btnY 200 50], ...
                'Text', '📊 Vezi Rezultate', ...
                'FontSize', 13, ...
                'BackgroundColor', [0.2 0.4 0.8], ...
                'FontColor', [1 1 1], ...
                'ButtonPushedFcn', @(btn,event) showResultsPanel(app));
            
            uibutton(app.SimulationPanel, ...
                'Position', [710 btnY 200 50], ...
                'Text', '❓ Ajutor', ...
                'FontSize', 13, ...
                'ButtonPushedFcn', @(btn,event) showHelpPanel(app));
            
            uibutton(app.SimulationPanel, ...
                'Position', [930 btnY 200 50], ...
                'Text', '← Configurare Nouă', ...
                'FontSize', 13, ...
                'ButtonPushedFcn', @(btn,event) showConfigPanel(app));
            
            % Statistics panel
            statsPanel = uipanel(app.SimulationPanel);
            statsPanel.Position = [20 20 1140 440];
            statsPanel.Title = 'Statistici Scenariu';
            statsPanel.FontSize = 14;
            
            % Will be populated after simulation
        end
        
        function createResultsPanel(app)
            % Create results panel
            app.ResultsPanel = uipanel(app.UIFigure);
            app.ResultsPanel.Position = [10 10 1180 680];
            app.ResultsPanel.Title = 'Rezultate Analiză';
            app.ResultsPanel.FontSize = 16;
            app.ResultsPanel.FontWeight = 'bold';
            app.ResultsPanel.Visible = 'off';
            
            % Back button
            uibutton(app.ResultsPanel, ...
                'Position', [20 620 150 40], ...
                'Text', '← Înapoi', ...
                'FontSize', 12, ...
                'ButtonPushedFcn', @(btn,event) showSimulationPanel(app));
        end
        
        function createHelpPanel(app)
            % Create help panel
            app.HelpPanel = uipanel(app.UIFigure);
            app.HelpPanel.Position = [10 10 1180 680];
            app.HelpPanel.Title = 'Ajutor și Explicații';
            app.HelpPanel.FontSize = 16;
            app.HelpPanel.FontWeight = 'bold';
            app.HelpPanel.Visible = 'off';
            
            % Create tabs for different help topics
            tabGroup = uitabgroup(app.HelpPanel);
            tabGroup.Position = [20 20 1140 600];
            
            % Tab 1: Concepts
            tab1 = uitab(tabGroup, 'Title', 'Concepte de Bază');
            createHelpContent1(app, tab1);
            
            % Tab 2: Parameters
            tab2 = uitab(tabGroup, 'Title', 'Parametri');
            createHelpContent2(app, tab2);
            
            % Tab 3: Analysis
            tab3 = uitab(tabGroup, 'Title', 'Analiză Access');
            createHelpContent3(app, tab3);
            
            % Back button
            uibutton(app.HelpPanel, ...
                'Position', [20 640 150 30], ...
                'Text', '← Înapoi', ...
                'FontSize', 11, ...
                'ButtonPushedFcn', @(btn,event) showSimulationPanel(app));
        end
        
        function createHelpContent1(app, parent)
            content = ['CONCEPTE DE BAZĂ', newline, newline, ...
                '🛰️ ORBITĂ LEO (Low Earth Orbit)', newline, ...
                'Sateliții LEO orbitează la altitudini între 200-2000 km.', newline, ...
                'Avantaje: latență redusă, cost mai mic de lansare', newline, ...
                'Dezavantaje: acoperire limitată, necesită constelații', newline, newline, ...
                '📡 STAȚIE TERESTRĂ (Ground Station)', newline, ...
                'Punct fix pe suprafața Pământului care comunică cu sateliții.', newline, ...
                'Poate primi date, poate transmite comenzi.', newline, newline, ...
                '🔭 CONICAL SENSOR (Senzor Conic)', newline, ...
                'Reprezintă camera sau antena de pe satelit.', newline, ...
                'Are un field of view (FOV) conic definit prin MaxViewAngle.', newline, newline, ...
                '🔗 ACCESS (Acces)', newline, ...
                'Există acces când:', newline, ...
                '  • Stația este în field of view-ul camerei', newline, ...
                '  • Unghiul de elevație > unghi minim', newline, ...
                '  • Nu există obstrucții (ex: Pământul)', newline];
            
            uilabel(parent, 'Position', [20 20 1080 520], ...
                'Text', content, 'FontSize', 12, ...
                'VerticalAlignment', 'top');
        end
        
        function createHelpContent2(app, parent)
            content = ['PARAMETRI CONFIGURABILI', newline, newline, ...
                'SATELIȚI:', newline, ...
                '• Număr sateliți: Dimensiunea constelației (1-100)', newline, ...
                '• Altitudine: Înălțimea orbitei în km', newline, ...
                '• Inclinație: Unghiul orbitei față de ecuator (0°-90°)', newline, ...
                '• FOV cameră: Câmpul vizual al senzorului', newline, newline, ...
                'STAȚIE TERESTRĂ:', newline, ...
                '• Latitudine: Poziția nord/sud (-90° la +90°)', newline, ...
                '• Longitudine: Poziția est/vest (-180° la +180°)', newline, ...
                '• Unghi elevație min: Pragul pentru vizibilitate', newline, newline, ...
                'SIMULARE:', newline, ...
                '• Durată: Intervalul de timp simulat', newline, ...
                '• Sample time: Rezoluția temporală', newline, newline, ...
                'RECOMANDĂRI:', newline, ...
                '✓ Altitudine 500-800 km pentru LEO standard', newline, ...
                '✓ Inclinație 55° pentru acoperire globală bună', newline, ...
                '✓ Unghi elevație 20-30° pentru calitate optimă', newline];
            
            uilabel(parent, 'Position', [20 20 1080 520], ...
                'Text', content, 'FontSize', 12, ...
                'VerticalAlignment', 'top');
        end
        
        function createHelpContent3(app, parent)
            content = ['ANALIZĂ ACCESS', newline, newline, ...
                'Ce reprezintă ACCESS?', newline, ...
                'Access = perioada când satelitul poate comunica cu stația.', newline, newline, ...
                'INTERVALELE DE ACCESS:', newline, ...
                '• Start Time: Când începe accesul', newline, ...
                '• End Time: Când se termină accesul', newline, ...
                '• Duration: Cât durează (în secunde)', newline, ...
                '• Orbit Count: Numărul orbitei curente', newline, newline, ...
                'SYSTEM-WIDE ACCESS PERCENTAGE:', newline, ...
                'Procentajul de timp când cel puțin un satelit', newline, ...
                'are acces la stație.', newline, newline, ...
                'Formula:', newline, ...
                'Percentage = (Total Access Time / Scenario Duration) × 100', newline, newline, ...
                'TRACKING:', newline, ...
                'Când sateliții "trackuiesc" stația, camerele lor', newline, ...
                'sunt întotdeauna îndreptate spre țintă.', newline, ...
                'Rezultat: ↑ access percentage (mai mult acces)', newline, newline, ...
                'FACTORI DE INFLUENȚĂ:', newline, ...
                '• Altitudinea sateliților', newline, ...
                '• Numărul de sateliți în constelație', newline, ...
                '• Field of view al camerelor', newline, ...
                '• Unghiul minim de elevație', newline];
            
            uilabel(parent, 'Position', [20 20 1080 520], ...
                'Text', content, 'FontSize', 11, ...
                'VerticalAlignment', 'top');
        end
        
        function showWelcomePanel(app)
            app.WelcomePanel.Visible = 'on';
            app.ConfigPanel.Visible = 'off';
            app.SimulationPanel.Visible = 'off';
            app.ResultsPanel.Visible = 'off';
            app.HelpPanel.Visible = 'off';
        end
        
        function showConfigPanel(app)
            app.WelcomePanel.Visible = 'off';
            app.ConfigPanel.Visible = 'on';
            app.SimulationPanel.Visible = 'off';
            app.ResultsPanel.Visible = 'off';
            app.HelpPanel.Visible = 'off';
        end
        
        function showSimulationPanel(app)
            app.WelcomePanel.Visible = 'off';
            app.ConfigPanel.Visible = 'off';
            app.SimulationPanel.Visible = 'on';
            app.ResultsPanel.Visible = 'off';
            app.HelpPanel.Visible = 'off';
        end
        
        function showResultsPanel(app)
            if isempty(app.sc)
                uialert(app.UIFigure, 'Rulează mai întâi o simulare!', 'Eroare');
                return;
            end
            
            app.WelcomePanel.Visible = 'off';
            app.ConfigPanel.Visible = 'off';
            app.SimulationPanel.Visible = 'off';
            app.ResultsPanel.Visible = 'on';
            app.HelpPanel.Visible = 'off';
            
            displayResults(app);
        end
        
        function showHelpPanel(app)
            app.WelcomePanel.Visible = 'off';
            app.ConfigPanel.Visible = 'off';
            app.SimulationPanel.Visible = 'off';
            app.ResultsPanel.Visible = 'off';
            app.HelpPanel.Visible = 'on';
        end
        
        function startSimulation(app)
            try
                % Get parameters from config panel
                numSat = findobj(app.ConfigPanel, 'Tag', 'numSat').Value;
                altitude = findobj(app.ConfigPanel, 'Tag', 'altitude').Value;
                inclination = findobj(app.ConfigPanel, 'Tag', 'inclination').Value;
                fov = findobj(app.ConfigPanel, 'Tag', 'fov').Value;
                lat = findobj(app.ConfigPanel, 'Tag', 'latitude').Value;
                lon = findobj(app.ConfigPanel, 'Tag', 'longitude').Value;
                minElev = findobj(app.ConfigPanel, 'Tag', 'minElevation').Value;
                duration = findobj(app.ConfigPanel, 'Tag', 'duration').Value;
                sampleTime = findobj(app.ConfigPanel, 'Tag', 'sampleTime').Value;
                
                % Show progress
                d = uiprogressdlg(app.UIFigure, 'Title', 'Se creează scenariul...', ...
                    'Message', 'Inițializare...');
                
                % Create scenario
                d.Message = 'Se creează scenariul satelitar...';
                d.Value = 0.1;
                
                startTime = datetime('now');
                stopTime = startTime + hours(duration);
                app.sc = satelliteScenario(startTime, stopTime, sampleTime);
                
                % Check if TLE file exists, otherwise create satellites with Keplerian elements
                tleFile = 'leoConstellation.tle';
                useTLE = false;
                
                if exist(tleFile, 'file')
                    % Try to use TLE file
                    try
                        d.Message = 'Se încarcă sateliții din fișierul TLE...';
                        d.Value = 0.3;
                        app.satellites = satellite(app.sc, tleFile);
                        
                        % Limit to requested number if TLE has more
                        if length(app.satellites) > numSat
                            app.satellites = app.satellites(1:numSat);
                        end
                        useTLE = true;
                        
                    catch
                        % If TLE fails, fall back to Keplerian
                        useTLE = false;
                    end
                end
                
                if ~useTLE
                    % Create TLE file on the fly
                    d.Message = 'Se generează constelația de sateliți...';
                    d.Value = 0.2;
                    
                    % Generate TLE file
                    createLEOConstellationTLE(numSat, altitude, inclination, tleFile);
                    
                    d.Message = 'Se încarcă sateliții...';
                    d.Value = 0.4;
                    
                    % Load satellites from generated TLE
                    app.satellites = satellite(app.sc, tleFile);
                end
                
                % Add cameras
                d.Message = 'Se adaugă camerele pe sateliți...';
                d.Value = 0.6;
                
                % Create camera names as char array, not string
                cameraNames = cell(1, length(app.satellites));
                for i = 1:length(app.satellites)
                    cameraNames{i} = char(string(app.satellites(i).Name) + " Camera");
                end
                
                app.cameras = conicalSensor(app.satellites, ...
                    'Name', cameraNames, ...
                    'MaxViewAngle', fov);
                
                % Add ground station
                d.Message = 'Se creează stația terestră...';
                d.Value = 0.8;
                
                app.groundStation = groundStation(app.sc, ...
                    'Name', 'Ground Station', ...
                    'Latitude', lat, ...
                    'Longitude', lon, ...
                    'MinElevationAngle', minElev);
                
                % Create access analysis
                d.Message = 'Se calculează analizele de acces...';
                d.Value = 0.9;
                
                app.accessAnalysis = access(app.cameras, app.groundStation);
                
                d.Value = 1;
                close(d);
                
                % Show simulation panel
                showSimulationPanel(app);
                
                % Update status
                statusLabel = findobj(app.SimulationPanel, 'Tag', 'statusLabel');
                statusLabel.Text = sprintf(...
                    'Scenariul conține %d sateliți la %.0f km altitudine, inclinație %.0f°. Durată simulare: %d ore.', ...
                    length(app.satellites), altitude, inclination, duration);
                
            catch ME
                if exist('d', 'var')
                    close(d);
                end
                uialert(app.UIFigure, ['Eroare: ' ME.message], 'Eroare la creare scenariului');
                rethrow(ME);
            end
        end
        
        function showScenarioViewer(app)
            if isempty(app.sc)
                uialert(app.UIFigure, 'Creează mai întâi un scenariu!', 'Eroare');
                return;
            end
            
            try
                % Create viewer with custom settings
                v = satelliteScenarioViewer(app.sc, 'ShowDetails', false);
                
                % Show ground station label
                app.groundStation.ShowLabel = true;
                
                % Show first satellite as example
                app.satellites(1).ShowLabel = true;
                show(app.satellites(1));
                
                uialert(app.UIFigure, ...
                    'Vizualizarea 3D a fost deschisă! Folosește mouse-ul pentru rotație și zoom.', ...
                    'Succes', 'Icon', 'success');
                
            catch ME
                uialert(app.UIFigure, ME.message, 'Eroare la vizualizare');
            end
        end
        
        function playSimulation(app)
            if isempty(app.sc)
                uialert(app.UIFigure, 'Creează mai întâi un scenariu!', 'Eroare');
                return;
            end
            
            try
                % Play the scenario animation
                play(app.sc);
                
            catch ME
                uialert(app.UIFigure, ME.message, 'Eroare la play');
            end
        end
        
        function displayResults(app)
            % Clear previous results
            delete(app.ResultsPanel.Children(~strcmp({app.ResultsPanel.Children.Type}, 'uibutton')));
            
            % Create results content
            resultsTab = uitabgroup(app.ResultsPanel);
            resultsTab.Position = [20 20 1140 590];
            
            % Tab 1: Access Intervals
            tab1 = uitab(resultsTab, 'Title', 'Intervale Access');
            displayAccessIntervals(app, tab1);
            
            % Tab 2: System-Wide Analysis
            tab2 = uitab(resultsTab, 'Title', 'Analiză Sistem');
            displaySystemAnalysis(app, tab2);
            
            % Tab 3: Statistics
            tab3 = uitab(resultsTab, 'Title', 'Statistici Detaliate');
            displayStatistics(app, tab3);
        end
        
        function displayAccessIntervals(app, parent)
            % Get access intervals table
            accTable = accessIntervals(app.accessAnalysis);
            
            % Display info
            infoText = sprintf(...
                'Total intervale de access detectate: %d\n\n', ...
                height(accTable));
            
            uilabel(parent, 'Position', [20 510 1080 40], ...
                'Text', infoText, 'FontSize', 13, ...
                'FontWeight', 'bold');
            
            % Create table
            if height(accTable) > 0
                uit = uitable(parent);
                uit.Position = [20 20 1080 480];
                uit.Data = accTable;
                uit.ColumnName = accTable.Properties.VariableNames;
            else
                uilabel(parent, 'Position', [20 250 1080 30], ...
                    'Text', 'Nu s-au găsit intervale de access în perioada simulată.', ...
                    'FontSize', 14, 'HorizontalAlignment', 'center');
            end
        end
        
        function displaySystemAnalysis(app, parent)
            % Calculate system-wide access
            for idx = 1:numel(app.accessAnalysis)
                [s, time] = accessStatus(app.accessAnalysis(idx));
                if idx == 1
                    systemWideAccessStatus = s;
                else
                    systemWideAccessStatus = or(systemWideAccessStatus, s);
                end
            end
            
            % Calculate percentage
            n = nnz(systemWideAccessStatus);
            systemWideAccessDuration = n * app.sc.SampleTime;
            scenarioDuration = seconds(app.sc.StopTime - app.sc.StartTime);
            systemWideAccessPercentage = (systemWideAccessDuration / scenarioDuration) * 100;
            
            % Display metrics
            yPos = 480;
            
            % Big percentage display
            percentPanel = uipanel(parent);
            percentPanel.Position = [350 yPos 380 80];
            percentPanel.BackgroundColor = [0.9 0.95 1];
            
            uilabel(percentPanel, 'Position', [10 40 360 30], ...
                'Text', 'System-Wide Access Percentage:', ...
                'FontSize', 14, 'HorizontalAlignment', 'center');
            
            uilabel(percentPanel, 'Position', [10 5 360 35], ...
                'Text', sprintf('%.2f %%', systemWideAccessPercentage), ...
                'FontSize', 24, 'FontWeight', 'bold', ...
                'HorizontalAlignment', 'center', ...
                'FontColor', [0.2 0.6 0.3]);
            
            % Additional metrics
            yPos = yPos - 100;
            
            metricsText = sprintf(...
                'Durată totală access: %.1f minute (%.2f ore)\n\n', ...
                systemWideAccessDuration/60, systemWideAccessDuration/3600);
            metricsText = [metricsText sprintf(...
                'Durată simulare: %.1f minute (%.2f ore)\n\n', ...
                scenarioDuration/60, scenarioDuration/3600)];
            metricsText = [metricsText sprintf(...
                'Sample time: %d secunde\n\n', app.sc.SampleTime)];
            metricsText = [metricsText sprintf(...
                'Total sample points cu access: %d din %d', ...
                n, length(systemWideAccessStatus))];
            
            uilabel(parent, 'Position', [50 yPos-100 500 150], ...
                'Text', metricsText, 'FontSize', 12);
            
            % Plot access status over time
            ax = uiaxes(parent);
            ax.Position = [600 yPos-200 480 300];
            
            plot(ax, time, systemWideAccessStatus, 'LineWidth', 2, 'Color', [0.2 0.6 0.3]);
            grid(ax, 'on');
            xlabel(ax, 'Timp');
            ylabel(ax, 'System-Wide Access Status');
            title(ax, 'Acoperire în timp');
            ylim(ax, [-0.1 1.1]);
            
            % Explanation
            explainText = ['INTERPRETARE:', newline, ...
                '• Când graficul este 1 (sus): cel puțin un satelit are acces', newline, ...
                '• Când graficul este 0 (jos): niciun satelit nu are acces', newline, ...
                '• Procentajul = aria verde / aria totală × 100'];
            
            uilabel(parent, 'Position', [50 20 500 100], ...
                'Text', explainText, 'FontSize', 11, ...
                'FontColor', [0.4 0.4 0.4]);
        end
        
        function displayStatistics(app, parent)
            % Get access intervals
            accTable = accessIntervals(app.accessAnalysis);
            
            yPos = 500;
            
            % Number of satellites with access
            uniqueSources = unique(accTable.Source);
            numSatWithAccess = length(uniqueSources);
            
            uilabel(parent, 'Position', [50 yPos 500 25], ...
                'Text', sprintf('Sateliți cu cel puțin un access: %d / %d', ...
                numSatWithAccess, length(app.satellites)), ...
                'FontSize', 13, 'FontWeight', 'bold');
            
            yPos = yPos - 40;
            
            % Average access duration
            if height(accTable) > 0
                avgDuration = mean(accTable.Duration);
                maxDuration = max(accTable.Duration);
                minDuration = min(accTable.Duration);
                
                uilabel(parent, 'Position', [50 yPos 500 25], ...
                    'Text', sprintf('Durată medie access: %.1f secunde (%.2f minute)', ...
                    avgDuration, avgDuration/60), ...
                    'FontSize', 12);
                
                yPos = yPos - 30;
                
                uilabel(parent, 'Position', [50 yPos 500 25], ...
                    'Text', sprintf('Durată maximă access: %.1f secunde (%.2f minute)', ...
                    maxDuration, maxDuration/60), ...
                    'FontSize', 12);
                
                yPos = yPos - 30;
                
                uilabel(parent, 'Position', [50 yPos 500 25], ...
                    'Text', sprintf('Durată minimă access: %.1f secunde (%.2f minute)', ...
                    minDuration, minDuration/60), ...
                    'FontSize', 12);
                
                yPos = yPos - 50;
                
                % Plot histogram of access durations
                ax = uiaxes(parent);
                ax.Position = [50 50 500 300];
                
                histogram(ax, accTable.Duration/60, 'FaceColor', [0.2 0.6 0.3]);
                xlabel(ax, 'Durată Access (minute)');
                ylabel(ax, 'Frecvență');
                title(ax, 'Distribuția Duratelor de Access');
                grid(ax, 'on');
                
                % Satellite contribution plot
                ax2 = uiaxes(parent);
                ax2.Position = [600 50 480 400];
                
                % Count accesses per satellite
                satNames = string(app.satellites.Name);
                accessCounts = zeros(length(satNames), 1);
                
                for i = 1:length(satNames)
                    cameraName = satNames(i) + " Camera";
                    accessCounts(i) = sum(strcmp(accTable.Source, cameraName));
                end
                
                bar(ax2, accessCounts, 'FaceColor', [0.2 0.4 0.8]);
                xlabel(ax2, 'Index Satelit');
                ylabel(ax2, 'Număr Accesses');
                title(ax2, 'Contribuția Fiecărui Satelit');
                grid(ax2, 'on');
                
            else
                uilabel(parent, 'Position', [50 yPos 1000 25], ...
                    'Text', 'Nu există date de acces pentru a calcula statistici.', ...
                    'FontSize', 13, 'FontColor', [0.8 0.2 0.2]);
            end
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1200 720];
            app.UIFigure.Name = 'Satellite Constellation Analyzer';
            app.UIFigure.Resize = 'off';

            % Create all panels
            createWelcomePanel(app);
            createConfigPanel(app);
            createSimulationPanel(app);
            createResultsPanel(app);
            createHelpPanel(app);
            
            % Show welcome panel first
            showWelcomePanel(app);

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SatelliteConstellationApp

            % Create UIFigure and components
            createComponents(app);

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end