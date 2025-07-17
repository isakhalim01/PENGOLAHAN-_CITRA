pkg load image

% Membaca gambar
img = imread('D:\gambar\redup.jpg');

% Mengubah gambar RGB ke grayscale
imgray = rgb2gray(img);

% Meningkatkan kecerahan
cerah = imgray + 100;
cerah(cerah > 255) = 255; % Menjaga agar nilai pixel tidak melebihi 255
cerah = uint8(cerah);

% Menampilkan gambar sebelum dan sesudah cerah
figure;
subplot(2,2,1);
imshow(imgray);
title('Gambar Sebelum Dicerahkan');

subplot(2,2,2);
imshow(cerah);
title('Gambar Sesudah Dicerahkan');

% Menampilkan histogram
subplot(2,2,3);
imhist(imgray);
title('Histogram Sebelum Dicerahkan');

subplot(2,2,4);
imhist(cerah);
title('Histogram Sesudah Dicerahkan');

