% Runs tests on fflib functions, helpful to verify that after e.g.
% refactoring some function, functionality is still alright. Note that the
% tests only take samples and cannot not guarantee the absence of flaws
% e.g. for corner cases.
%
% \author Jan Bolting, ONERA/ISAE, 2014, j.bolting@isae.fr
%
function fflib_tests
disp([mfilename '>> Running fflib unit tests...']);
tol = 1e-10;
% Test unit vector function:
check(...
    norm(fflib_normalize([1 1 1])), 1, tol ...
    );

% Test transformation between cartesian frames:
% Position:
% Transform a point in the body frame to the NED frame. The body frame is
% rotated by 90 deg about the NED z axis.
p_b = [0 1 0]';
p_b_NED = [1 1 0]';
qAttitude_b_NED = angle2quat(deg2rad(90), 0, 0, 'ZXY')';
check(...
    fflib_frame2frame(p_b, p_b_NED, qAttitude_b_NED), [0 1 0]', tol ...
    );
% Speed:
% Transform the velocity of a point that moves w.r.t. the moving body frame
% to the NED frame:
v_b = [10 0 0]';
vb_NED = [0 -10 0]';
check(...
    fflib_frame2frame(v_b, vb_NED, qAttitude_b_NED), [0 0 0]', tol ...
    );

% Test unit conversion functions:
check(...
    fflib_kmh2mps(36), 10, tol ...
    );
check(...
    fflib_mps2kmh(20), 72, tol ...
    );

% Test function that sets small matrix elements to zero:
a = [-tol/2 1; 2*tol tol/2];
a = fflib_removeSubEps(a);
check(...
    a(1,1), 0, tol ...
    );
check(...
    a(2,2), 0, tol ...
    );

disp([mfilename '>> All fflib tests passed']);

    % This function raises an error message if a false result is passed in.
    function check(result, expected_result, tolerance)
        delta = abs(result - expected_result);
        errors = delta(delta>tolerance);
        % check if there are logical zeros in the results:
        passed = isempty(errors);
        if ~passed
           error([mfilename '>> at least one fflib test not passed, aborting.']);
        end
    end

end