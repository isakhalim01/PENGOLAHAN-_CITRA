pkg load image;
% Membaca gambar
gambar = imread('D:\gambar\nois.webp');

% Konversi ke grayscale jika perlu
if size(gambar, 3) == 3
    gambar_gray = rgb2gray(gambar);
else
    gambar_gray = gambar;
end

% Terapkan median filter 3x3
gambar_median = medfilt2(gambar_gray, [3 3]);

% Terapkan mean filter 3x3 (menggunakan konvolusi)
kernel_mean = ones(3,3) / 9;
gambar_mean = conv2(double(gambar_gray), kernel_mean, 'same');
gambar_mean = uint8(gambar_mean);

% Tampilkan hasil
figure;
subplot(1,3,1), imshow(gambar_gray), title('Asli (Grayscale)');
subplot(1,3,2), imshow(gambar_median), title('Median Filter 3x3');
subplot(1,3,3), imshow(gambar_mean), title('Mean Filter 3x3');

