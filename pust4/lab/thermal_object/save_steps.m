st1 = step(tf1);
st2 = step(tf2,100);
st1 = st1(1:100);
st2 = st2(2:end);

% t = 0:79;
t = 0:99;
resp1_ts = [t' resp1];
resp2_ts = [t' resp2];

t = 0:99;
appr1_ts = [t' st1];
appr2_ts = [t' st2];

dlmwrite('../../data/lab/thermal_object/zad4/normalizacja/norm_response_y1_u2.csv', resp1_ts, '\t');
dlmwrite('../../data/lab/thermal_object/zad4/normalizacja/norm_response_y2_u2.csv', resp2_ts, '\t');
dlmwrite('../../data/lab/thermal_object/zad4/normalizacja/appr_norm_response_y1_u2.csv', appr1_ts, '\t');
dlmwrite('../../data/lab/thermal_object/zad4/normalizacja/appr_norm_response_y2_u2.csv', appr2_ts, '\t');