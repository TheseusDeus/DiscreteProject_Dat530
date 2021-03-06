clear all; clc;

global global_info;

%Load data from file //NOT IN USE
%[busNr, departures, routeTime, deviation, changeDriver,...
%    changeDriverStop, changeDriverTime] = loadData('busRoutes.xlsx');

global_info.STOP_AT = 400;

%Petri Net structure
pns = pnstruct({ ...
                'connector_pdf',...
                'generator_pdf',...
                'preparation_pdf',...
                'routes_pdf',...
                'driving_pdf',...
                'cleanup_pdf',...
              });

% firing times
% these firing times will be changed to be stochastic with rand func

dyn.ft = {
    'tRoute3', 15,...
    'tRoute5', 7.5,...
    'tRoute6', 15,...
    'tGenerator',120,...
    'postChange_tRoutex60', 3,...
    'preChange_tRoutex60', 15,...
    'allOthers', 1,...
    };
% initial state
dyn.m0 ={
         'pNumberOfRounds', 2, ... %times the generator will fire
         'pAdministration', 16 %inital tokens
        }; 

%Resources
pni = initialdynamics(pns,dyn);

%Run Simulation
sim = gpensim(pni);

% print the simulation results
prnsys(sim);
prnss(sim); 
prnfinalcolors(sim);

%Plot routes and more
plotp(sim, { ...
            'pOnRoute3', 'pOnRoute5','pOnRoute6',...
            'preChange_pOnRoutex60','postChange_pOnRoutex60',...
            'pCheckedOut', 'pAdministration','pArriveAtBusStop', ...
            });
ylabel('Active buses on route');
xlabel('Time in minutes');
