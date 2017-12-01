name = "1503512621910";
summary = csvread('custom_summary.csv');
frame_rate = summary(4, 4);
total_frames = summary(4, 2);
endtime = summary(4, 5);

interval_data = load("annotations/" + name + ".txt");
emg_data = load("emg/" + name + "_EMG.txt");
imu_data = load("imu/" + name + "_IMU.txt");

start_time_stamp = endtime - ((total_frames/frame_rate) * 1000);

start_points = interval_data(:,1);
end_points = interval_data(:,2);

feating_action = fopen('eat_data.csv', 'w');
fnoneating_action = fopen('noneat_data.csv', 'w');

prev_end = 0;

for idx = 1:size(start_points)
    current_start = start_time_stamp + ((start_points(idx)/frame_rate) * 1000);
    current_end = start_time_stamp + ((end_points(idx)/frame_rate) * 1000);
    
    index = idx + 0;
    % Eating IMU data
    eating_data = imu_data(imu_data(:, 1) > current_start & imu_data(:, 1) < current_end, 2:end);
    eating_names = ["Eating Action " + index + " Ort x", "Eating Action " + index + " Ort y", "Eating Action " + index + " Ort z", "Eating Action " + index + " Ort w", "Eating Action " + index + " Acc x", "Eating Action " + index + " Acc y", "Eating Action " + index + " Acc z", "Eating Action " + index + " gyro x", "Eating Action " + index + " gyro y", "Eating Action " + index + " gyro z"]';
    eating_data = [eating_names eating_data'];
    for iterator = 1:size(eating_data, 1)
        fprintf(feating_action, '%s,', eating_data(iterator, 1));
        fprintf(feating_action, '%g,', eating_data(iterator, 2:end));
        fprintf(feating_action, '\n');
    end
    
    % Non-Eating IMU data
    non_eating_data = imu_data(imu_data(:, 1) > prev_end & imu_data(:, 1) < current_start, 2:end);
    non_eating_names = ["Non-Eating Action " + index + " Ort x", "Non-Eating Action " + index + " Ort y", "Non-Eating Action " + index + " Ort z", "Non-Eating Action " + index + " Ort w", "Non-Eating Action " + index + " Acc x", "Non-Eating Action " + index + " Acc y", "Non-Eating Action " + index + " Acc z", "Non-Eating Action " + index + " gyro x", "Non-Eating Action " + index + " gyro y", "Non-Eating Action " + index + " gyro z"]';
    non_eating_data = [non_eating_names, non_eating_data'];
    for iterator = 1:size(non_eating_data, 1)
        fprintf(fnoneating_action, '%s,', non_eating_data(iterator, 1));
        fprintf(fnoneating_action, '%g,', non_eating_data(iterator, 2:end));
        fprintf(fnoneating_action, '\n');
    end
    
    % Eating EMG Data
    eating_data = emg_data(emg_data(:, 1) > current_start & emg_data(:, 1) < current_end, 2:end);
    eating_names = ["Eating Action " + index + " Emg 1", "Eating Action " + index + " Emg 2", "Eating Action " + index + " Emg 3", "Eating Action " + index + " Emg 4", "Eating Action " + index + " Emg 5", "Eating Action " + index + " Emg 6", "Eating Action " + index + " Emg 7", "Eating Action " + index + " Emg 8"]';
    eating_data = [eating_names eating_data'];
    for iterator = 1:size(eating_data, 1)
        fprintf(feating_action, '%s,', eating_data(iterator, 1));
        fprintf(feating_action, '%g,', eating_data(iterator, 2:end));
        fprintf(feating_action, '\n');
    end
    
    % Non-Eating EMG Data
    non_eating_data = emg_data(emg_data(:, 1) > prev_end & emg_data(:, 1) < current_start, 2:end);
    non_eating_names = ["Non-Eating Action " + index + " Emg 1", "Non-Eating Action " + index + " Emg 2", "Non-Eating Action " + index + " Emg 3", "Non-Eating Action " + index + " Emg 4", "Non-Eating Action " + index + " Emg 5", "Non-Eating Action " + index + " Emg 6", "Non-Eating Action " + index + " Emg 7", "Non-Eating Action " + index + " Emg 8"]';
    non_eating_data = [non_eating_names, non_eating_data'];
    for iterator = 1:size(non_eating_data, 1)
        fprintf(fnoneating_action, '%s,', non_eating_data(iterator, 1));
        fprintf(fnoneating_action, '%g,', non_eating_data(iterator, 2:end));
        fprintf(fnoneating_action, '\n');
    end
    
    prev_end = current_end;
end

fclose('all');