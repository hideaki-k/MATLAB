
t = [0:0.01:0.98];
y1 = sin(2*pi*t*4);
plot(t, y1);
hold on;
y2 = cos(2*pi*t*4);
plot(t, y2,"r");
xlabel("time");
ylabel("value");
title("myplot")
legend("sin","cos")
print("myplot","-dpng")
close
figure(1);plot(t, y1);
figure(2);plot(t, y2);
close
subplot(1, 2, 1);
plot(t, y1);
subplot(1, 2, 2);
plot(t, y2);
clf;
a = magic(5)
imagesc(a)