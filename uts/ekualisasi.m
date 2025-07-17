pkg load image

% Baca dan konversi ke grayscale
Img = imread('D:\gambar\volly (1).jpg');
Img = rgb2gray(Img);  % Konversi ke grayscale

[jum_baris, jum_kolom] = size(Img);
L = 256;  % Jumlah level intensitas
Histog = zeros(L, 1);

% Hitung histogram citra asli
for baris = 1 : jum_baris
    for kolom = 1 : jum_kolom
        nilai = Img(baris, kolom);
        Histog(nilai + 1) = Histog(nilai + 1) + 1;
    end
end

% Hitung distribusi kumulatif (CDF)
alpha = (L - 1) / (jum_baris * jum_kolom);
C(1) = alpha * Histog(1);
for i = 2 : L
    C(i) = C(i - 1) + round(alpha * Histog(i));
end

% Transformasi piksel berdasarkan CDF
Hasil = Img;
for baris = 1 : jum_baris
    for kolom = 1 : jum_kolom
        Hasil(baris, kolom) = C(Img(baris, kolom) + 1);
    end
end

Hasil = uint8(Hasil);

% Tampilkan citra sebelum dan sesudah ekualisasi
figure;
subplot(2,2,1);
imshow(Img);
title('Citra Asli (Grayscale)');

subplot(2,2,2);
imshow(Hasil);
title('Setelah Ekualisasi Histogram');

% Tampilkan histogram sebelum dan sesudah
subplot(2,2,3);
imhist(Img);
title('Histogram Asli');

subplot(2,2,4);
imhist(Hasil);
title('Histogram Setelah Ekualisasi');

