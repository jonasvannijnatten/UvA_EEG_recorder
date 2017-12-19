function daqinfo = getDaqDevice(deviceName)
daqinfo = [];
fprintf('no device connected yet, searching for %s ...\n', deviceName)
% get info on all connected devices, see if MOBIlab is amongst them
devices = daqhwinfo;
if ismember(deviceName,devices.InstalledAdaptors)
    daqinfo = daqhwinfo(deviceName);
    fprintf('%s detected\n', deviceName)
else
    errordlg(sprintf(['The $s is not recognized.\n' ...
        'Either it is not plugged in, or the drivers are not installed correctly'...
        ], deviceName))
    return
end
% sometimes the USB comport/InstalledBoardId number changes
% in that case reconnect
if isempty(daqinfo.InstalledBoardIds)
    fprintf('comport not found, resetting comport \n')
    daqreset;
    daqinfo = daqhwinfo(deviceName);
    if isempty(daqinfo.InstalledBoardIds)
        errordlg(sprintf(['Unable to connect to the recording device. Make sure that:\n' ...
            '- the device is plugged in \n- the device is turned on\n' ...
            '- the device is ready (green light blinking)\n- the drivers are installed correctly\n'...
            'If you ran all the above checks and still are unable to connect then call for help.\n'...
            ]), 'Unable to connect to device')
        
        return
    end
end
daqinfo.comport = str2double(daqinfo.InstalledBoardIds{1});