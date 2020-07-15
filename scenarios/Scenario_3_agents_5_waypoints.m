function [ objectIndex ] = Scenario_3_agents_5_waypoints(varargin)
% This function generates the four agent, four obstacle example, termed
% scenario D in the formation control/ collision avoidance study.

fprintf('[SCENARIO]\tGetting the four agent, four obstacle formation control example.\n');

%% SCENARIO INPUT HANDLING ////////////////////////////////////////////////
% DEFAULT INPUT CONDITIONS
defaultConfig = struct(...
    'file','scenario.mat',...
    'agents',[],...
    'agentOrbit',10,...
    'agentVelocity',0,...
    'offsetAngle',0,...
    'obstacles',4,...
    'obstacleRadius',1,...
    'obstacleOrbit',5,...
    'waypointOrbit',[],...
    'waypointOffsetAngle',[],...
    'waypointRadius',0.1,...
    'adjacencyMatrix',[],...                            % The globally specified adjacency matrix
    'noiseFactor',0,...
    'plot',false);                     
% Instanciate the scenario builder
SBinstance = scenarioBuilder();
% Parse user inputs 
[inputConfig] = SBinstance.configurationParser(defaultConfig,varargin);

% AGENT CONDITIONING
agentNumber = numel(inputConfig.agents);
%assert(agentNumber == 4,'This scenario requires four input agents, specified by the "agent" attribute.');

if isnumeric(inputConfig.obstacles)
    obstacleSet = cell(inputConfig.obstacles,1);
    for index = 1:inputConfig.obstacles
       obstacleSet{index} = obstacle();
    end
    inputConfig.obstacles = obstacleSet;
end
% DECLARE THE NUMBER OF OBSTACLES
obstacleNumber = numel(inputConfig.obstacles);  

% DESIGN THE DESIRED SEPERATION MATRIX (ADJACENCY MATRIX)
% The adjacency matrix is indexed by objectID in scenarioConfig.adjacencyMatrix
% OTHERWISE ASSIGN DEFAULT ADJACENCY MATRIX
if isempty(inputConfig.adjacencyMatrix)
   inputConfig.adjacencyMatrix = double(~eye(agentNumber)); 
end

%% /////////////////// BUILD THE AGENTS GLOBAL STATES /////////////////////
% INNER AGENTS
[ agentConfig ] = SBinstance.planarRing(...
    'objects',agentNumber,...
    'velocities',inputConfig.agentVelocity,...
    'radius',inputConfig.agentOrbit);
% % OUTER AGENTS                                           
% [ agentConfigB ] = SBinstance.planarRing(...
%     'objects',agentNumber/2,...
%     'velocities',inputConfig.agentVelocity,...
%     'radius',inputConfig.agentOrbit*1.5);

locations = [[-8 0 0];...
    [-8 1 0];...
    [-8 -1 0]];

% MOVE THROUGH THE AGENTS AND INITIALISE WITH GLOBAL PROPERTIES
fprintf('[SCENARIO]\tAssigning agent global parameters...\n'); 
agentIndex = cell(agentNumber,1);
for index = 1:agentNumber
    agentIndex{index} = inputConfig.agents{index};
    % APPEND THE FORMATION CONTROL ADJACENCY MATRIX
    if isprop(inputConfig.agents{index},'adjacencyMatrix')
        agentIndex{index}.adjacencyMatrix = inputConfig.adjacencyMatrix;
    end
        % APPLY GLOBAL STATE VARIABLES
        agentIndex{index}.SetGLOBAL('position',locations(index,:)');
        agentIndex{index}.SetGLOBAL('velocity',[0; 0; 0]);
        agentIndex{index}.SetGLOBAL('quaternion',[1; 0; 0; 0]);
end

% % ASSIGN AGENT GLOBAL PROPERTIES, ONE SIDE OF THE RINGS TO THE OTHER
% agentIndex{1}.SetGLOBAL('position',agentConfigB.positions(:,1));
% agentIndex{1}.SetGLOBAL('velocity',agentConfigB.velocities(:,1));
% agentIndex{1}.SetGLOBAL('quaternion',agentConfigB.quaternions(:,1));          % Append properties from the sphereical scenario
% agentIndex{2}.SetGLOBAL('position',agentConfigA.positions(:,1));
% agentIndex{2}.SetGLOBAL('velocity',agentConfigA.velocities(:,1));
% agentIndex{2}.SetGLOBAL('quaternion',agentConfigA.quaternions(:,1));          % Append properties from the sphereical scenario
% agentIndex{3}.SetGLOBAL('position',agentConfigA.positions(:,2));
% agentIndex{3}.SetGLOBAL('velocity',agentConfigA.velocities(:,2));
% agentIndex{3}.SetGLOBAL('quaternion',agentConfigA.quaternions(:,2)); 
% agentIndex{4}.SetGLOBAL('position',agentConfigB.positions(:,2));
% agentIndex{4}.SetGLOBAL('velocity',agentConfigB.velocities(:,2));
% agentIndex{4}.SetGLOBAL('quaternion',agentConfigB.quaternions(:,2));                                                 

%% //////////////// BUILD THE OBSTACLES GLOBAL STATES /////////////////////
% The four obstacles are positioned in a ring around the center
% [ obstacleConfig ] = SBinstance.planarRing(...
%     'objects',obstacleNumber,...
%     'radius',inputConfig.obstacleOrbit,...
%     'offsetAngle',pi,...
%     'velocity',0);
% nScenerios = 3;
% [ obstacleConfig(1) ] = SBinstance.line(...
%     'objects',obstacleNumber/nScenerios,...
%     'pointA',[4;0;0],...
%     'pointB',[8;0;0],...
%     'heading',[1;0;0]);
% [ obstacleConfig(2) ] = SBinstance.line(...
%     'objects',obstacleNumber/nScenerios,...
%     'pointA',[4;-2;0],...
%     'pointB',[4;-6;0],...
%     'heading',[1;0;0]);
% [ obstacleConfig(3) ] = SBinstance.line(...
%     'objects',obstacleNumber/nScenerios,...
%     'pointA',[2;-6;0],...
%     'pointB',[-2;-6;0],...
%     'heading',[1;0;0]);
% 
% % MOVE THROUGH THE AGENTS AND INITIALISE WITH GLOBAL PROPERTIES
% fprintf('[SCENARIO]\tAssigning obstacle global parameters...\n'); 
% obstacleIndex = cell(obstacleNumber,1);
% for scenerio = 1:nScenerios
%     for obsNum = 1:obstacleNumber/nScenerios
%         index = (scenerio - 1) * obstacleNumber/nScenerios + obsNum;
%         obstacleIndex{index} = inputConfig.obstacles{index};                                    % Get the agents from the input structure
%         obstacleIndex{index}.name = sprintf('OB-%s',inputConfig.obstacles{index}.name);
%         obstacleIndex{index}.radius = inputConfig.obstacleRadius;
%         % APPLY GLOBAL STATE VARIABLES
%         obstacleIndex{index}.SetGLOBAL('position',obstacleConfig(scenerio).positions(:,obsNum));
%         obstacleIndex{index}.SetGLOBAL('velocity',obstacleConfig(scenerio).velocities(:,obsNum));
%         obstacleIndex{index}.SetGLOBAL('quaternion',obstacleConfig(scenerio).quaternions(:,obsNum));  % Append properties from the sphereical scenario
%     end
% end

% locations = [[-8 4 0];...
%     [-8 6 0];...
%     [-6 6 0];...
%     [-2 4 0];...
%     [-2 6 0];...
%     [0 6 0];...
%     [2 6 0];...
%     [2 8 0];...
%     [2 10 0];...
%     [6 4 0];...
%     [6 2 0];...
%     [6 0 0];...
%     [6 -2 0];...
%     [8 -2 0];...
%     [2 -6 0];...
%     [0 -6 0];...
%     [0 -4 0];...
%     [-2 -4 0];...
%     [-4 -4 0];...
%     [-6 -4 0];...
%     [-8 -4 0];...
%     [-6 0 0];...
%     [-6 2 0];...
%     [-8 2 0]];

locations = [[4 0 0];...
    [0 -4 0];...
    [-4 0 0];...
    [0 4 0];...
    [0 0 0]];

% MOVE THROUGH THE AGENTS AND INITIALISE WITH GLOBAL PROPERTIES
fprintf('[SCENARIO]\tAssigning obstacle global parameters...\n'); 
obstacleIndex = cell(obstacleNumber,1);
for index = 1:obstacleNumber
    obstacleIndex{index} = inputConfig.obstacles{index};                                    % Get the agents from the input structure
    obstacleIndex{index}.name = sprintf('OB-%s',inputConfig.obstacles{index}.name);
    obstacleIndex{index}.radius = inputConfig.obstacleRadius;
    % APPLY GLOBAL STATE VARIABLES
    obstacleIndex{index}.SetGLOBAL('position',locations(index,:)');
    obstacleIndex{index}.SetGLOBAL('velocity',[0; 0; 0]);
    obstacleIndex{index}.SetGLOBAL('quaternion',[1; 0; 0; 0]);  % Append properties from the sphereical scenario
end

% Agent 1 waypoint locations
waypoint_locations(:,:,1) = [[6 0 0];... 
    [0 -6 0];...
    [-6 0 0];...
    [0 6 0];...
    [0 0 0]];
% Agent 2 waypoint locations
waypoint_locations(:,:,2) = [[6 0 0];... 
    [0 -6 0];...
    [-6 0 0];...
    [0 6 0];...
    [0 0 0]];
% Agent 3 waypoint locations
waypoint_locations(:,:,3) = [[6 0 0];... 
    [0 -6 0];...
    [-6 0 0];...
    [0 6 0];...
    [0 0 0]];

fprintf('[SCENARIO]\tAssigning waypoint definitions:\n'); 
for agent_num = 1:agentNumber
    for waypoint_num = 1:4
        index = 4*(agent_num - 1) + waypoint_num;
        % Create a way-point
        waypointIndex{index} = waypoint('radius',inputConfig.waypointRadius,'name',sprintf('WP-%s',agentIndex{agent_num}.name));
        % Update the GLOBAL properties
        waypointIndex{index}.SetGLOBAL('position',waypoint_locations(waypoint_num,:,agent_num)');
        waypointIndex{index}.SetGLOBAL('velocity',[0; 0; 0]);
        waypointIndex{index}.SetGLOBAL('quaternion',[1; 0; 0; 0]);
        % Create the way-point association
        waypointIndex{index}.CreateAgentAssociation(agentIndex{agent_num},5);  % Create waypoint with association to agent
    end
end

%% DEFINE WAYPOINTS AND ASSIGN GLOBAL PARAMETERS
% DEFINE THE FIRST WAYPOINT SETF
% waypointConfig = SBinstance.planarRing(...
%     'objects',agentNumber,...
%     'radius',inputConfig.waypointOrbit,...
%     'velocities',0,...
%     'zeroAngle',0);

% MOVE THROUGH THE WAYPOINTS AND INITIALISE WITH GLOBAL PROPERTIES
% fprintf('[SCENARIO]\tAssigning waypoint definitions:\n'); 
% for index = 1:agentNumber
%     % Create a way-point
%     waypointIndex{index} = waypoint('radius',inputConfig.waypointRadius,'name',sprintf('WP-%s',agentIndex{index}.name));
%     % Update the GLOBAL properties
%     waypointIndex{index}.SetGLOBAL('position',waypointConfig.positions(:,index) + inputConfig.noiseFactor*[randn(2,1);0]);
%     waypointIndex{index}.SetGLOBAL('velocity',waypointConfig.velocities(:,index));
%     waypointIndex{index}.SetGLOBAL('quaternion',waypointConfig.quaternions(:,index));
%     % Create the way-point association
%     waypointIndex{index}.CreateAgentAssociation(agentIndex{index},5);  % Create waypoint with association to agent
% end

%% /////////////// CLEAN UP ///////////////////////////////////////////////
% BUILD THE COMPLETE OBJECT SET
objectIndex = vertcat(agentIndex,obstacleIndex,waypointIndex'); 
% PLOT THE SCENE
if inputConfig.plot
    SBinstance.plotObjectIndex(objectIndex);                            % Plot the object index
end
clearvars -except objectIndex % Clean-up
end