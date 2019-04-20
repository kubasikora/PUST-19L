function timestamp = createTimestamp()
    date_string = strsplit(datestr(now));
    timestamp = strcat(date_string{1}, '-', date_string{2}, '/');
end

