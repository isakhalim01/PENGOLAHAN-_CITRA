F = imread('D:\gambar\godong.jpg');
F = rgb2gray(F);
% Kernel Gaussian separabel
Hkol = [1 2 1]/4;
Hbrs = [1 2 1]/4;

% Faktor penguat high-boost
A = 2.5;

%Fungsi High-Boost
 [tinggi_f, lebar_f] = size(F);
 [~, lebar_h] = size(Hbrs);
m2 = floor(lebar_h/2);
F2 = double(F);
T = F2;

% Konvolusi vertikal
for y = m2+1 : tinggi_f - m2
for x = 1 : lebar_f
jum = 0;
for p = -m2 : m2
jum = jum + Hkol(p + m2 + 1) * F2(y - p, x);
end
T(y, x) = jum;
end
end

% Konvolusi horizontal (low-pass)
LPF = zeros(size(F2));
for y = 1 : tinggi_f
for x = m2+1 : lebar_f - m2
jum = 0;
for p = -m2 : m2
jum = jum + Hbrs(p + m2 + 1) * T(y, x - p);
end
LPF(y, x) = jum;
end
end
% rumus High-Boost
G = A * F2 - LPF;
G = uint8(max(min(G, 255), 0));

% Tampilkan hasil
subplot(1,2,1); imshow(F); title('Citra Asli');
subplot(1,2,2); imshow(G); title('High-Boost');
